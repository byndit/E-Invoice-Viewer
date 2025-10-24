# E-Invoice Viewer

This project provides a comprehensive solution for viewing and processing electronic invoices in UBL (Universal Business Language) XML format. It includes both a Python script for standalone PDF generation and a Business Central AL extension for integrated invoice viewing.

## Features

### Python Script (`xml_to_invoice_pdf.py`)
- Parses UBL XML invoice files
- Generates PDF invoices with detailed formatting
- Supports comprehensive invoice data extraction including:
  - Header information (ID, dates, currency, buyer reference, notes, type code)
  - Supplier and customer details
  - Contact information (name, phone, email)
  - Payment information (means code, account, terms)
  - Invoice line items with quantities, prices, discounts
  - Tax subtotals and totals
  - Legal monetary totals

### Business Central AL Extension
- **Report**: `EInvoiceViewer.Report.al` - Main report for displaying parsed invoice data
- **Layout**: `Viewer.rdlc` - RDLC report layout with comprehensive fields
- **Integration**: Automatic XML parsing and data population into Business Central
- **Page Extensions**: Integration with Incoming Documents for seamless workflow

## Installation

### Python Requirements
```bash
pip install reportlab
```

### Business Central Extension
1. Import the AL extension files into your Business Central development environment
2. Publish and install the extension
3. The report will be available under Reports and Analysis

## Usage

### Python Script
```bash
python xml_to_invoice_pdf.py input_invoice.xml output_invoice.pdf
```

Example:
```bash
python xml_to_invoice_pdf.py 01.01a-INVOICE_ubl.xml invoice.pdf
```

### Business Central Report
1. Navigate to the E-Invoice Viewer report
2. Select an XML file when prompted
3. The report will automatically parse and display the invoice data

## XML Structure Support

The solution supports the following UBL 2.1 invoice elements:

### Header Elements
- `cbc:ID` - Invoice number
- `cbc:IssueDate` - Issue date
- `cbc:DocumentCurrencyCode` - Currency
- `cbc:BuyerReference` - Buyer reference
- `cbc:Note` - Invoice notes
- `cbc:InvoiceTypeCode` - Invoice type

### Party Information
- Supplier details (name, address, contact)
- Customer details (name, address)
- Contact information (name, phone, email)

### Payment Information
- Payment means code
- Payee financial account
- Payment terms

### Line Items
- Line ID and description
- Quantity and unit price
- Line amount and discounts
- Tax category and percentage
- Additional line notes and references

### Tax and Totals
- Tax subtotals by category
- Legal monetary totals (line extension, tax exclusive/inclusive amounts)
- Payable amount

## Architecture

### Python Component
- Uses `xml.etree.ElementTree` for XML parsing
- `reportlab` library for PDF generation
- Namespace-aware XPath queries for reliable data extraction
- Comprehensive error handling and data validation

### AL Extension Component
- XML parsing using Business Central's XmlDocument and XmlNamespaceManager
- Data population into temporary Sales Header and Line tables
- RDLC layout for professional report presentation
- Integration with Incoming Documents workflow

## File Structure

```
app/
├── xml_to_invoice_pdf.py          # Python PDF generation script
├── src/
│   ├── EInvoiceViewer.Report.al   # Main AL report
│   ├── Viewer.rdlc                # Report layout
│   └── PTEAfterImportIntoDoc.Codeunit.al  # Integration codeunit
├── 01.01a-INVOICE_ubl.xml         # Sample XML file
└── README.md                      # This file
```

## Contributing

This project is based on the AL-Go Per Tenant Extension Template. Please refer to the [AL-Go documentation](https://aka.ms/AL-Go) for contribution guidelines.

## License

This project is provided as-is for educational and development purposes.
