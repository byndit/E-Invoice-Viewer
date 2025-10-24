#how to use it
#python xml_to_invoice_pdf.py input.xml output.pdf
#python .\xml_to_invoice_pdf.py .\01.01a-INVOICE_ubl.xml invoice.pdf

import sys
from xml.etree import ElementTree as ET
from reportlab.lib.pagesizes import letter
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle
from reportlab.lib.styles import getSampleStyleSheet
from reportlab.lib import colors
from reportlab.lib.units import inch

def parse_invoice(xml_file):
    tree = ET.parse(xml_file)
    root = tree.getroot()
    ns = {
        'cbc': 'urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2',
        'cac': 'urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2'
    }

    # Extract header information
    invoice_id = root.find('.//cbc:ID', ns)
    invoice_id = invoice_id.text if invoice_id is not None else 'N/A'

    issue_date = root.find('.//cbc:IssueDate', ns)
    issue_date = issue_date.text if issue_date is not None else 'N/A'

    currency = root.find('.//cbc:DocumentCurrencyCode', ns)
    currency = currency.text if currency is not None else 'N/A'

    buyer_reference = root.find('.//cbc:BuyerReference', ns)
    buyer_reference = buyer_reference.text if buyer_reference is not None else 'N/A'

    note = root.find('.//cbc:Note', ns)
    note = note.text if note is not None else 'N/A'

    invoice_type_code = root.find('.//cbc:InvoiceTypeCode', ns)
    if invoice_type_code is None:
        invoice_type_code = root.find('.//cbc:CreditNoteTypeCode', ns)  # For credit notes
    invoice_type_code = invoice_type_code.text if invoice_type_code is not None else 'N/A'

    # Extract supplier information
    supplier_name = root.find('.//cac:AccountingSupplierParty/cac:Party/cac:PartyName/cbc:Name', ns)
    supplier_name = supplier_name.text if supplier_name is not None else 'N/A'

    supplier_address = root.find('.//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress', ns)
    supplier_addr_str = ''
    if supplier_address is not None:
        street = supplier_address.find('cbc:StreetName', ns)
        city = supplier_address.find('cbc:CityName', ns)
        postal = supplier_address.find('cbc:PostalZone', ns)
        country = supplier_address.find('cac:Country/cbc:IdentificationCode', ns)
        supplier_addr_str = f"{street.text if street is not None else ''} {city.text if city is not None else ''} {postal.text if postal is not None else ''} {country.text if country is not None else ''}".strip()

    # Extract customer information
    customer_name = root.find('.//cac:AccountingCustomerParty/cac:Party/cac:PartyName/cbc:Name', ns)
    customer_name = customer_name.text if customer_name is not None else 'N/A'

    customer_address = root.find('.//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress', ns)
    customer_addr_str = ''
    if customer_address is not None:
        street = customer_address.find('cbc:StreetName', ns)
        city = customer_address.find('cbc:CityName', ns)
        postal = customer_address.find('cbc:PostalZone', ns)
        country = customer_address.find('cac:Country/cbc:IdentificationCode', ns)
        customer_addr_str = f"{street.text if street is not None else ''} {city.text if city is not None else ''} {postal.text if postal is not None else ''} {country.text if country is not None else ''}".strip()

    # Extract contact information
    contact_name = root.find('.//cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Name', ns)
    contact_name = contact_name.text if contact_name is not None else 'N/A'

    contact_phone = root.find('.//cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Telephone', ns)
    contact_phone = contact_phone.text if contact_phone is not None else 'N/A'

    contact_email = root.find('.//cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:ElectronicMail', ns)
    contact_email = contact_email.text if contact_email is not None else 'N/A'

    # Extract payment information
    payment_means_code = root.find('.//cac:PaymentMeans/cbc:PaymentMeansCode', ns)
    payment_means_code = payment_means_code.text if payment_means_code is not None else 'N/A'

    payment_account = root.find('.//cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:ID', ns)
    payment_account = payment_account.text if payment_account is not None else 'N/A'

    # Extract payment terms
    payment_terms = root.find('.//cac:PaymentTerms/cbc:Note', ns)
    payment_terms = payment_terms.text if payment_terms is not None else 'N/A'

    # Extract tax subtotals
    tax_subtotals = []
    for subtotal in root.findall('.//cac:TaxTotal/cac:TaxSubtotal', ns):
        taxable_amount = subtotal.find('cbc:TaxableAmount', ns)
        taxable_amount = taxable_amount.text if taxable_amount is not None else '0.00'

        tax_amount = subtotal.find('cbc:TaxAmount', ns)
        tax_amount = tax_amount.text if tax_amount is not None else '0.00'

        tax_percent = subtotal.find('.//cac:TaxCategory/cbc:Percent', ns)
        tax_percent = tax_percent.text if tax_percent is not None else '0'

        tax_category = subtotal.find('.//cac:TaxCategory/cbc:ID', ns)
        tax_category = tax_category.text if tax_category is not None else 'N/A'

        tax_subtotals.append({
            'taxable_amount': taxable_amount,
            'tax_amount': tax_amount,
            'tax_percent': tax_percent,
            'tax_category': tax_category
        })

    # Extract totals
    total_tax = root.find('.//cac:TaxTotal/cbc:TaxAmount', ns)
    total_tax = total_tax.text if total_tax is not None else '0.00'

    line_extension_amount = root.find('.//cac:LegalMonetaryTotal/cbc:LineExtensionAmount', ns)
    line_extension_amount = line_extension_amount.text if line_extension_amount is not None else '0.00'

    tax_exclusive_amount = root.find('.//cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount', ns)
    tax_exclusive_amount = tax_exclusive_amount.text if tax_exclusive_amount is not None else '0.00'

    tax_inclusive_amount = root.find('.//cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount', ns)
    tax_inclusive_amount = tax_inclusive_amount.text if tax_inclusive_amount is not None else '0.00'

    total_amount = root.find('.//cac:LegalMonetaryTotal/cbc:PayableAmount', ns)
    total_amount = total_amount.text if total_amount is not None else '0.00'

    # Extract invoice lines - try InvoiceLine first, then CreditNoteLine for credit notes
    lines = []
    invoice_lines = root.findall('.//cac:InvoiceLine', ns) or root.findall('.//cac:CreditNoteLine', ns)

    for line in invoice_lines:
        line_id = line.find('cbc:ID', ns)
        line_id = line_id.text if line_id is not None else ''

        quantity = line.find('cbc:InvoicedQuantity', ns)
        if quantity is None:
            quantity = line.find('cbc:CreditedQuantity', ns)  # For credit notes
        quantity = quantity.text if quantity is not None else '0'

        amount = line.find('cbc:LineExtensionAmount', ns)
        amount = amount.text if amount is not None else '0.00'

        item_name = line.find('.//cac:Item/cbc:Name', ns)
        item_name = item_name.text if item_name is not None else 'N/A'

        item_description = line.find('.//cac:Item/cbc:Description', ns)
        item_description = item_description.text if item_description is not None else ''

        discount_amount = line.find('.//cac:AllowanceCharge/cbc:Amount', ns)
        discount_amount = discount_amount.text if discount_amount is not None else '0.00'

        # Calculate discount %
        try:
            disc_amt = float(discount_amount)
            price_amt_elem = line.find('.//cac:Price/cbc:PriceAmount', ns)
            price_amt = float(price_amt_elem.text) if price_amt_elem is not None and price_amt_elem.text else 0.0
            if price_amt > 0:
                discount_percent = (disc_amt / price_amt) * 100
            else:
                discount_percent = 0.0
        except (ValueError, TypeError):
            discount_percent = 0.0

        # Don't print zero values
        quantity = '' if quantity in ['0', '0.00'] else quantity
        amount = '' if amount in ['0', '0.00'] else amount
        discount_amount = '' if discount_amount in ['0', '0.00'] else discount_amount
        discount_percent_str = '' if discount_percent == 0.0 else f"{discount_percent:.2f}%"

        # Additional line fields
        line_note = line.find('cbc:Note', ns)
        line_note = line_note.text if line_note is not None else ''

        start_date = line.find('.//cac:InvoicePeriod/cbc:StartDate', ns)
        start_date = start_date.text if start_date is not None else ''

        end_date = line.find('.//cac:InvoicePeriod/cbc:EndDate', ns)
        end_date = end_date.text if end_date is not None else ''

        order_line_id = line.find('.//cac:OrderLineReference/cbc:LineID', ns)
        order_line_id = order_line_id.text if order_line_id is not None else ''

        seller_item_id = line.find('.//cac:SellersItemIdentification/cbc:ID', ns)
        seller_item_id = seller_item_id.text if seller_item_id is not None else ''

        commodity_code = line.find('.//cac:CommodityClassification/cbc:ItemClassificationCode', ns)
        commodity_code = commodity_code.text if commodity_code is not None else ''

        line_tax_category = line.find('.//cac:ClassifiedTaxCategory/cbc:ID', ns)
        line_tax_category = line_tax_category.text if line_tax_category is not None else ''

        line_tax_percent = line.find('.//cac:ClassifiedTaxCategory/cbc:Percent', ns)
        line_tax_percent = line_tax_percent.text if line_tax_percent is not None else ''

        lines.append([line_id, item_name, quantity, amount, discount_amount, discount_percent_str])

    return {
        'id': invoice_id,
        'date': issue_date,
        'currency': currency,
        'buyer_reference': buyer_reference,
        'note': note,
        'invoice_type_code': invoice_type_code,
        'supplier_name': supplier_name,
        'supplier_address': supplier_addr_str,
        'customer_name': customer_name,
        'customer_address': customer_addr_str,
        'contact_name': contact_name,
        'contact_phone': contact_phone,
        'contact_email': contact_email,
        'payment_means_code': payment_means_code,
        'payment_account': payment_account,
        'payment_terms': payment_terms,
        'tax_subtotals': tax_subtotals,
        'line_extension_amount': line_extension_amount,
        'tax_exclusive_amount': tax_exclusive_amount,
        'tax_inclusive_amount': tax_inclusive_amount,
        'total_tax': total_tax,
        'total_amount': total_amount,
        'lines': lines
    }

def generate_pdf(data, output_file):
    # 1 cm ≈ 28.35 points
    left_margin = 15.00
    doc = SimpleDocTemplate(output_file, pagesize=letter, leftMargin=left_margin, rightMargin=left_margin, bottomMargin=50)
    styles = getSampleStyleSheet()
    story = []

    # Header
    story.append(Paragraph(f"Invoice {data['id']}", styles['Heading1']))
    story.append(Paragraph(f"Issue Date: {data['date']}", styles['Normal']))
    story.append(Paragraph(f"Currency: {data['currency']}", styles['Normal']))
    story.append(Paragraph(f"Buyer Reference: {data['buyer_reference']}", styles['Normal']))
    story.append(Paragraph(f"Invoice Type Code: {data['invoice_type_code']}", styles['Normal']))
    story.append(Spacer(1, 12))

    # Note
    if data['note'] != 'N/A':
        story.append(Paragraph(f"Note: {data['note']}", styles['Normal']))
        story.append(Spacer(1, 12))

    # Supplier
    story.append(Paragraph("Supplier:", styles['Heading2']))
    story.append(Paragraph(f"Name: {data['supplier_name']}", styles['Normal']))
    story.append(Paragraph(f"Address: {data['supplier_address']}", styles['Normal']))
    story.append(Spacer(1, 12))

    # Customer
    story.append(Paragraph("Customer:", styles['Heading2']))
    story.append(Paragraph(f"Name: {data['customer_name']}", styles['Normal']))
    story.append(Paragraph(f"Address: {data['customer_address']}", styles['Normal']))
    story.append(Spacer(1, 12))

    # Contact Information
    story.append(Paragraph("Contact Information:", styles['Heading2']))
    story.append(Paragraph(f"Name: {data['contact_name']}", styles['Normal']))
    story.append(Paragraph(f"Phone: {data['contact_phone']}", styles['Normal']))
    story.append(Paragraph(f"Email: {data['contact_email']}", styles['Normal']))
    story.append(Spacer(1, 12))

    # Payment Information
    story.append(Paragraph("Payment Information:", styles['Heading2']))
    story.append(Paragraph(f"Payment Means Code: {data['payment_means_code']}", styles['Normal']))
    story.append(Paragraph(f"Account: {data['payment_account']}", styles['Normal']))
    story.append(Paragraph(f"Payment Terms: {data['payment_terms']}", styles['Normal']))
    story.append(Spacer(1, 12))

    # Invoice Lines
    story.append(Paragraph("Invoice Lines:", styles['Heading2']))
    if data['lines']:
        table_data = [['Line ID', 'Item Name', 'Quantity', 'Line Amount', 'Discount Amount', 'Discount %']] + data['lines']
        table = Table(table_data, colWidths=[50, 200, 60, 80, 100, 80])
        table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), colors.grey),
            ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
            ('ALIGN', (0, 0), (-1, -1), 'CENTER'),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('BOTTOMPADDING', (0, 0), (-1, 0), 12),
            ('BACKGROUND', (0, 1), (-1, -1), colors.beige),
            ('GRID', (0, 0), (-1, -1), 1, colors.black),
            ('VALIGN', (0, 0), (-1, -1), 'TOP'),
            ('FONTSIZE', (0, 0), (-1, -1), 6),
            ('LEFTPADDING', (1, 0), (1, -1), 2),
            ('RIGHTPADDING', (1, 0), (1, -1), 2)
        ]))
        story.append(table)
    else:
        story.append(Paragraph("No lines found.", styles['Normal']))
    story.append(Spacer(1, 12))

    # Tax Subtotals
    if data['tax_subtotals']:
        story.append(Paragraph("Tax Subtotals:", styles['Heading2']))
        for subtotal in data['tax_subtotals']:
            story.append(Paragraph(f"Taxable Amount: {subtotal['taxable_amount']} {data['currency']}, Tax Amount: {subtotal['tax_amount']} {data['currency']}, Tax %: {subtotal['tax_percent']}, Category: {subtotal['tax_category']}", styles['Normal']))
        story.append(Spacer(1, 12))

    # Totals
    story.append(Paragraph("Totals:", styles['Heading2']))
    story.append(Paragraph(f"Line Extension Amount: {data['line_extension_amount']} {data['currency']}", styles['Normal']))
    story.append(Paragraph(f"Tax Exclusive Amount: {data['tax_exclusive_amount']} {data['currency']}", styles['Normal']))
    story.append(Paragraph(f"Tax Inclusive Amount: {data['tax_inclusive_amount']} {data['currency']}", styles['Normal']))
    story.append(Paragraph(f"Total Tax: {data['total_tax']} {data['currency']}", styles['Normal']))
    story.append(Paragraph(f"Payable Amount: {data['total_amount']} {data['currency']}", styles['Normal']))

    def onPage(canvas, doc):
        canvas.saveState()
        canvas.setFont('Helvetica', 9)
        page_num = canvas.getPageNumber()
        text = f"Page {page_num}"
        canvas.drawRightString(letter[0] - 28.35, 25, text)
        canvas.restoreState()

    doc.build(story, onFirstPage=onPage, onLaterPages=onPage)

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print("Usage: python xml_to_invoice_pdf.py <input.xml> <output.pdf>")
        sys.exit(1)

    xml_file = sys.argv[1]
    pdf_file = sys.argv[2]

    try:
        data = parse_invoice(xml_file)
        generate_pdf(data, pdf_file)
        print(f"PDF generated successfully: {pdf_file}")
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)