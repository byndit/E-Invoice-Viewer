report 50600 "PTE E-Invoice Viewer"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'E-Invoice Viewer';
    DefaultRenderingLayout = Xml;

    dataset
    {
        dataitem(TempSalesHeader; "Sales Header")
        {
            UseTemporary = true;
            DataItemTableView = sorting("No.") where("Document Type" = const(Invoice));
            column(Header_No; "No.") { IncludeCaption = true; }
            column(Header_Sell_to_Customer_No; "Sell-to Customer No.") { }
            //Sell to Name
            column(Header_Sell_to_Name; "Sell-to Customer Name") { }
            //Sell to Address
            column(Header_Sell_to_Address; "Sell-to Address") { }
            //Sell to City
            column(Header_Sell_to_City; "Sell-to City") { }
            //Sell to Post Code
            column(Header_Sell_to_Post_Code; "Sell-to Post Code") { }
            //Bill to Name
            column(Header_Bill_to_Name; "Bill-to Name") { }
            //Bill to Address
            column(Header_Bill_to_Address; "Bill-to Address") { }
            //Bill to City
            column(Header_Bill_to_City; "Bill-to City") { }
            //Bill to Post Code
            column(Header_Bill_to_Post_Code; "Bill-to Post Code") { }

            column(Header_Bill_to_Customer_No; "Bill-to Customer No.") { }
            column(Header_Posting_Date_Value; Format("Posting Date")) { }
            column(Header_Document_Date_Value; Format("Document Date")) { }
            column(Header_Posting_Date; "Posting Date") { IncludeCaption = true; }
            column(Header_Document_Date; "Document Date") { IncludeCaption = true; }
            column(Header_Currency_Code; "Currency Code") { IncludeCaption = true; }
            column(Header_Payment_Terms_Code; PaymentTerms) { }
            column(Amount; TaxExclusiveAmount) { }
            column(TaxAmount; TaxAmount) { }
            column(Amount_Including_VAT; TotalAmount) { }
            column(Amount_Excluding_VAT; TaxExclusiveAmount) { }
            column(Buyer_Reference; BuyerReference) { }
            column(Invoice_Note; Note) { }
            column(Invoice_Type_Code; InvoiceTypeCode) { }
            column(Contact_Name; ContactName) { }
            column(Contact_Phone; ContactPhone) { }
            column(Contact_Email; ContactEmail) { }
            column(Payment_Means_Code; PaymentMeansCode) { }
            column(Payment_Account; PaymentAccount) { }
            column(Line_Extension_Amount; LineExtensionAmount) { }
            column(Tax_Inclusive_Amount; TaxInclusiveAmount) { }
            //CustomerLbl
            column(Customer_Label; CustomerLbl) { }
            //SupplierLbl
            column(Supplier_Label; SupplierLbl) { }
            //AmountExclVATLbl
            column(Amount_Excl_VAT_Label; AmountExclVATLbl) { }
            //AmountInclVATLbl
            column(Amount_Incl_VAT_Label; AmountInclVATLbl) { }
            //VATAmountLbl
            column(VAT_Amount_Label; VATAmountLbl) { }
            dataitem(TempSalesLine; "Sales Line")
            {
                UseTemporary = true;
                DataItemLinkReference = TempSalesHeader;
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.");
                DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                column(Document_No; "Document No.") { IncludeCaption = true; }
                column(Line_No; "Line No.") { IncludeCaption = true; }
                column(Type; Type) { IncludeCaption = true; }
                column(No; "No.") { IncludeCaption = true; }
                column(Description; Description) { IncludeCaption = true; }
                column(Quantity; Quantity)
                {
                    IncludeCaption = true;
                    AutoFormatExpression = TempSalesHeader."Currency Code";
                    AutoFormatType = 1;
                }
                column(Unit_Price; "Unit Price")
                {
                    IncludeCaption = true;
                    AutoFormatExpression = TempSalesHeader."Currency Code";
                    AutoFormatType = 1;
                }
                column(Line_Amount; "Line Amount")
                {
                    IncludeCaption = true;
                    AutoFormatExpression = TempSalesHeader."Currency Code";
                    AutoFormatType = 1;
                }
                column(Line_Discount_Amount; "Line Discount Amount")
                {
                    IncludeCaption = true;
                    AutoFormatExpression = TempSalesHeader."Currency Code";
                    AutoFormatType = 1;
                }
                column(Line_Discount_Percent; "Line Discount %")
                {
                    IncludeCaption = true;
                    AutoFormatExpression = TempSalesHeader."Currency Code";
                    AutoFormatType = 1;
                }
                column(Line_Note; LineNote) { }
                column(Start_Date; StartDate) { }
                column(End_Date; EndDate) { }
                column(Order_Line_ID; OrderLineID) { }
                column(Seller_Item_ID; SellerItemID) { }
                column(Commodity_Code; CommodityCode) { }
                column(Line_Tax_Category; LineTaxCategory) { }
                column(Line_Tax_Percent; LineTaxPercent) { }
            }

        }

    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                field(SelectFile; '<SelectFile>')
                {
                    ApplicationArea = All;
                    Caption = 'XML File';
                    trigger OnDrillDown()
                    begin
                        TempBlob.CreateInStream(InStr, TextEncoding::UTF8);
                        UploadIntoStream('Select XML File', '', 'XML-Files (*.xml)|*.xml|All Files (*.*)|*.*', XMLFile, InStr);
                        LoadRecords(InStr);
                    end;
                }
            }
        }
    }

    rendering
    {
        layout(Xml)
        {
            Type = RDLC;
            LayoutFile = './src/Viewer.rdlc';
        }
    }


    var
        TempBlob: Codeunit "Temp Blob";
        CurrencyCode: Code[10];
        IssueDate: Date;
        TaxAmount: Decimal;
        TaxExclusiveAmount: Decimal;
        TotalAmount: Decimal;
        InStr: InStream;
        LineNo: Integer;
        AmountExclVATLbl: Label 'Amount Excluding VAT';
        AmountInclVATLbl: Label 'Amount Including VAT';
        CustomerLbl: Label 'Customer';
        SupplierLbl: Label 'Supplier';
        VATAmountLbl: Label 'VAT Amount';
        CustomerAddress: Text;
        CustomerCity: Text;
        CustomerName: Text;
        CustomerPostalZone: Text;
        InvoiceId: Text;
        PaymentTerms: Text;
        SupplierAddress: Text;
        SupplierCity: Text;
        SupplierName: Text;
        SupplierPostalZone: Text;
        XmlDoc: XmlDocument;
        RootElement: XmlElement;
        NamespaceManager: XmlNamespaceManager;
        BuyerReference: Text;
        Note: Text;
        InvoiceTypeCode: Text;
        ContactName: Text;
        ContactPhone: Text;
        ContactEmail: Text;
        PaymentMeansCode: Text;
        PaymentAccount: Text;
        LineExtensionAmount: Decimal;
        TaxInclusiveAmount: Decimal;
        LineNote: Text;
        StartDate: Date;
        EndDate: Date;
        OrderLineID: Text;
        SellerItemID: Text;
        CommodityCode: Text;
        LineTaxCategory: Text;
        LineTaxPercent: Text;
        XMLFile: Text;

    [TryFunction]
    procedure LoadRecords(var InStr: InStream)
    var
        TypeHelper: Codeunit "Type Helper";
        DiscountAmount: Decimal;
        DiscountPercent: Decimal;
        LineAmount: Decimal;
        PriceAmount: Decimal;
        Quantity: Decimal;
        ItemName: Text;
        LineId: Text;
        XmlText: Text;
        InvoiceLine: XmlElement;
        InvoiceLineNode: XmlNode;
        InvoiceLines: XmlNodeList;
    begin
        // Load XML from file
        XmlText := ReadAsTextWithSeparator(InStr, TypeHelper.CRLFSeparator());
        XmlDocument.ReadFrom(XmlText, XmlDoc);
        XmlDoc.GetRoot(RootElement);

        // Set up namespace manager
        NamespaceManager.NameTable(XmlDoc.NameTable());
        NamespaceManager.AddNamespace('cbc', 'urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2');
        NamespaceManager.AddNamespace('cac', 'urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2');

        // Parse header information
        InvoiceId := GetXmlValue(RootElement, 'cbc:ID', NamespaceManager);
        IssueDate := GetXmlDateValue(RootElement, 'cbc:IssueDate', NamespaceManager);
        CurrencyCode := CopyStr(GetXmlValue(RootElement, 'cbc:DocumentCurrencyCode', NamespaceManager), 1, 10);
        BuyerReference := GetXmlValue(RootElement, 'cbc:BuyerReference', NamespaceManager);
        Note := GetXmlValue(RootElement, 'cbc:Note', NamespaceManager);
        InvoiceTypeCode := GetXmlValue(RootElement, 'cbc:InvoiceTypeCode', NamespaceManager);

        // Supplier
        SupplierName := GetXmlValue(RootElement, 'cac:AccountingSupplierParty/cac:Party/cac:PartyName/cbc:Name', NamespaceManager);
        SupplierAddress := GetXmlValue(RootElement, 'cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName', NamespaceManager);
        SupplierCity := GetXmlValue(RootElement, 'cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName', NamespaceManager);
        SupplierPostalZone := GetXmlValue(RootElement, 'cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone', NamespaceManager);

        // Customer
        CustomerName := GetXmlValue(RootElement, 'cac:AccountingCustomerParty/cac:Party/cac:PartyName/cbc:Name', NamespaceManager);
        CustomerAddress := GetXmlValue(RootElement, 'cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName', NamespaceManager);
        CustomerCity := GetXmlValue(RootElement, 'cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName', NamespaceManager);
        CustomerPostalZone := GetXmlValue(RootElement, 'cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone', NamespaceManager);

        // Contact
        ContactName := GetXmlValue(RootElement, 'cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Name', NamespaceManager);
        ContactPhone := GetXmlValue(RootElement, 'cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Telephone', NamespaceManager);
        ContactEmail := GetXmlValue(RootElement, 'cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:ElectronicMail', NamespaceManager);

        // Payment
        PaymentMeansCode := GetXmlValue(RootElement, 'cac:PaymentMeans/cbc:PaymentMeansCode', NamespaceManager);
        PaymentAccount := GetXmlValue(RootElement, 'cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:ID', NamespaceManager);
        PaymentTerms := GetXmlValue(RootElement, 'cac:PaymentTerms/cbc:Note', NamespaceManager);

        // Totals
        LineExtensionAmount := GetXmlDecimalValue(RootElement, 'cac:LegalMonetaryTotal/cbc:LineExtensionAmount', NamespaceManager);
        TaxExclusiveAmount := GetXmlDecimalValue(RootElement, 'cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount', NamespaceManager);
        TaxInclusiveAmount := GetXmlDecimalValue(RootElement, 'cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount', NamespaceManager);
        TaxAmount := GetXmlDecimalValue(RootElement, 'cac:TaxTotal/cbc:TaxAmount', NamespaceManager);
        TotalAmount := GetXmlDecimalValue(RootElement, 'cac:LegalMonetaryTotal/cbc:PayableAmount', NamespaceManager);

        // Fill Temp Sales Header
        TempSalesHeader.Init();
        TempSalesHeader."Document Type" := TempSalesHeader."Document Type"::Invoice;
        TempSalesHeader."No." := CopyStr(InvoiceId, 1, 20);
        TempSalesHeader."Sell-to Customer Name" := CopyStr(CustomerName, 1, 100);
        TempSalesHeader."Sell-to Address" := CopyStr(CustomerAddress, 1, 100);
        TempSalesHeader."Sell-to City" := CopyStr(CustomerCity, 1, 30);
        TempSalesHeader."Sell-to Post Code" := CopyStr(CustomerPostalZone, 1, 20);
        TempSalesHeader."Bill-to Name" := CopyStr(SupplierName, 1, 100);
        TempSalesHeader."Bill-to Address" := CopyStr(SupplierAddress, 1, 100);
        TempSalesHeader."Bill-to City" := CopyStr(SupplierCity, 1, 30);
        TempSalesHeader."Bill-to Post Code" := CopyStr(SupplierPostalZone, 1, 20);
        TempSalesHeader."Payment Terms Code" := CopyStr(PaymentTerms, 1, 10);
        TempSalesHeader."Posting Date" := IssueDate;
        TempSalesHeader."Document Date" := IssueDate;
        TempSalesHeader."Currency Code" := CurrencyCode;
        TempSalesHeader.Insert();

        // Additional header fields (stored in TempSalesHeader for display)
        // Note: Since TempSalesHeader doesn't have fields for these, we'll use existing fields or add custom logic in RDLC

        // Parse invoice lines
        RootElement.SelectNodes('cac:InvoiceLine', NamespaceManager, InvoiceLines);
        LineNo := 10000;
        foreach InvoiceLineNode in InvoiceLines do begin
            InvoiceLine := InvoiceLineNode.AsXmlElement();
            LineId := GetXmlValue(InvoiceLine, 'cbc:ID', NamespaceManager);
            Quantity := GetXmlDecimalValue(InvoiceLine, 'cbc:InvoicedQuantity', NamespaceManager);
            LineAmount := GetXmlDecimalValue(InvoiceLine, 'cbc:LineExtensionAmount', NamespaceManager);
            ItemName := GetXmlValue(InvoiceLine, 'cac:Item/cbc:Name', NamespaceManager);
            DiscountAmount := GetXmlDecimalValue(InvoiceLine, 'cac:AllowanceCharge/cbc:Amount', NamespaceManager);
            PriceAmount := GetXmlDecimalValue(InvoiceLine, 'cac:Price/cbc:PriceAmount', NamespaceManager);

            // Additional line fields
            LineNote := GetXmlValue(InvoiceLine, 'cbc:Note', NamespaceManager);
            StartDate := GetXmlDateValue(InvoiceLine, 'cac:InvoicePeriod/cbc:StartDate', NamespaceManager);
            EndDate := GetXmlDateValue(InvoiceLine, 'cac:InvoicePeriod/cbc:EndDate', NamespaceManager);
            OrderLineID := GetXmlValue(InvoiceLine, 'cac:OrderLineReference/cbc:LineID', NamespaceManager);
            SellerItemID := GetXmlValue(InvoiceLine, 'cac:SellersItemIdentification/cbc:ID', NamespaceManager);
            CommodityCode := GetXmlValue(InvoiceLine, 'cac:CommodityClassification/cbc:ItemClassificationCode', NamespaceManager);
            LineTaxCategory := GetXmlValue(InvoiceLine, 'cac:ClassifiedTaxCategory/cbc:ID', NamespaceManager);
            LineTaxPercent := GetXmlValue(InvoiceLine, 'cac:ClassifiedTaxCategory/cbc:Percent', NamespaceManager);

            // Calculate discount %
            if PriceAmount <> 0 then
                DiscountPercent := (DiscountAmount / PriceAmount) * 100
            else
                DiscountPercent := 0;

            // Fill Temp Sales Line
            TempSalesLine.Init();
            TempSalesLine."Document Type" := TempSalesLine."Document Type"::Invoice;
            TempSalesLine."Document No." := CopyStr(InvoiceId, 1, 20);
            TempSalesLine."Line No." := LineNo;
            TempSalesLine.Type := TempSalesLine.Type::Item;
            TempSalesLine."No." := CopyStr(LineId, 1, 20); // Assuming line ID as item no
            TempSalesLine.Description := CopyStr(ItemName, 1, 100);
            TempSalesLine.Quantity := Quantity;
            TempSalesLine."Unit Price" := PriceAmount;
            TempSalesLine."Line Amount" := LineAmount;
            TempSalesLine."Line Discount Amount" := DiscountAmount;
            TempSalesLine."Line Discount %" := DiscountPercent;
            TempSalesLine.Insert();

            LineNo += 10000;
        end;
    end;

    local procedure ReadAsTextWithSeparator(var InStream: InStream; LineSeparator: Text): Text
    var
        Line: Text;
        Tb: TextBuilder;
    begin
        InStream.ReadText(Line);
        Tb.Append(Line);
        while not InStream.EOS do begin
            InStream.ReadText(Line);
            Tb.Append(LineSeparator);
            Tb.Append(Line);
        end;
        exit(Tb.ToText());
    end;

    local procedure GetXmlValue(Element: XmlElement; XPath: Text; NamespaceMgr: XmlNamespaceManager): Text
    var
        Node: XmlNode;
    begin
        if Element.SelectSingleNode(XPath, NamespaceMgr, Node) then
            exit(Node.AsXmlElement().InnerText())
        else
            exit('');
    end;

    local procedure GetXmlDecimalValue(Element: XmlElement; XPath: Text; NamespaceMgr: XmlNamespaceManager): Decimal
    var
        d: Decimal;
        Value: Text;
    begin
        Value := GetXmlValue(Element, XPath, NamespaceMgr);
        if Value <> '' then begin
            Evaluate(d, ConvertStr(Value, ',.', '.,'));
            exit(d)
        end else
            exit(0);
    end;

    local procedure GetXmlDateValue(Element: XmlElement; XPath: Text; NamespaceMgr: XmlNamespaceManager): Date
    var
        d: Date;
        Value: Text;
    begin
        Value := GetXmlValue(Element, XPath, NamespaceMgr);
        if Value <> '' then begin
            Evaluate(d, Value);
            exit(d);
        end else
            exit(0D);
    end;
}