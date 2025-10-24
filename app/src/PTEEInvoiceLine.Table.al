table 50601 "PTE E-Invoice Line"
{
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(1; "Document No."; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Document No.';
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No.';
        }
        field(5; Description; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(6; "Description 2"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Description 2';
        }
        field(7; Quantity; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity';
        }
        field(8; "Unit Price"; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Unit Price';
        }
        field(9; "Line Amount"; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Line Amount';
        }
        field(10; "Line Discount Amount"; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Line Discount Amount';
        }
        field(11; "Line Discount %"; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Line Discount %';
        }
        field(12; "Line Note"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Line Note';
        }
        field(13; "Start Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Start Date';
        }
        field(14; "End Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'End Date';
        }
        field(15; "Order Line ID"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Order Line ID';
        }
        field(16; "Seller Item ID"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Seller Item ID';
        }
        field(17; "Commodity Code"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Commodity Code';
        }
        field(18; "Line Tax Category"; Text[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Line Tax Category';
        }
        field(19; "Line Tax Percent"; Text[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Line Tax Percent';
        }
        field(20; "Item Description"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Item Description';
        }
    }

    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
}