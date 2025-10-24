table 50600 "PTE E-Invoice Header"
{
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(1; "No."; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'No.';
        }
        field(2; "Sell-to Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Sell-to Customer No.';
        }
        field(3; "Sell-to Customer Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Sell-to Customer Name';
        }
        field(4; "Sell-to Address"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Sell-to Address';
        }
        field(5; "Sell-to Address 2"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Sell-to Address 2';
        }
        field(6; "Sell-to City"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Sell-to City';
        }
        field(7; "Sell-to Post Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Sell-to Post Code';
        }
        field(8; "Sell-to Country/Region Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Sell-to Country/Region Code';
        }
        field(9; "Bill-to Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Bill-to Name';
        }
        field(10; "Bill-to Address"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Bill-to Address';
        }
        field(11; "Bill-to Address 2"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Bill-to Address 2';
        }
        field(12; "Bill-to City"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Bill-to City';
        }
        field(13; "Bill-to Post Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Bill-to Post Code';
        }
        field(14; "Bill-to Country/Region Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Bill-to Country/Region Code';
        }
        field(15; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Posting Date';
        }
        field(16; "Document Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Document Date';
        }
        field(17; "Currency Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Currency Code';
        }
        field(18; "Payment Terms Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Payment Terms Code';
        }
        field(19; Amount; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Amount';
        }
        field(20; "Amount Including VAT"; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Amount Including VAT';
        }
        field(21; "VAT Amount"; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'VAT Amount';
        }
        field(22; "Buyer Reference"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Buyer Reference';
        }
        field(23; "Note"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Note';
        }
        field(24; "Invoice Type Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Invoice Type Code';
        }
        field(25; "Contact Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Contact Name';
        }
        field(26; "Contact Phone"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Contact Phone';
        }
        field(27; "Contact Email"; Text[80])
        {
            DataClassification = CustomerContent;
            Caption = 'Contact Email';
        }
        field(28; "Payment Means Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Payment Means Code';
        }
        field(29; "Payment Account"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Payment Account';
        }
        field(30; "Line Extension Amount"; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Line Extension Amount';
        }
        field(31; "Tax Exclusive Amount"; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Tax Exclusive Amount';
        }
        field(32; "Tax Inclusive Amount"; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Tax Inclusive Amount';
        }
        field(33; "Payable Amount"; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Payable Amount';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
}