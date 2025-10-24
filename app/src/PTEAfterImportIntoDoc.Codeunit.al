codeunit 50600 "PTE After Import Into Doc."
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Import Attachment - Inc. Doc.", OnAfterImportAttachment, '', false, false)]
    local procedure OnAfterImportAttachment(var IncomingDocumentAttachment: Record "Incoming Document Attachment")
    var
        IncomingDocument: Record "Incoming Document";
        EInvoiceViewer: Report "PTE E-Invoice Viewer";
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        InStr: InStream;
        AttachmentInStr: InStream;
    begin
        IncomingDocument.Get(IncomingDocumentAttachment."Incoming Document Entry No.");
        if IncomingDocument."Data Exchange Type" = '' then
            exit;
        if not IncomingDocumentAttachment."Main Attachment" then
            exit;
        if IncomingDocumentAttachment.Type <> IncomingDocumentAttachment.Type::XML then
            exit;
        if not IncomingDocumentAttachment.GetContent(TempBlob) then
            exit;
        TempBlob.CreateInStream(AttachmentInStr, TextEncoding::UTF8);
        EInvoiceViewer.LoadRecords(AttachmentInStr);
        TempBlob.CreateOutStream(OutStr, TextEncoding::UTF8);
        EInvoiceViewer.SaveAs('', ReportFormat::PDF, OutStr);
        TempBlob.CreateInStream(InStr, TextEncoding::UTF8);
        IncomingDocument.AddAttachmentFromStream(IncomingDocumentAttachment, 'E-Invoice', 'pdf', InStr);
    end;
}
