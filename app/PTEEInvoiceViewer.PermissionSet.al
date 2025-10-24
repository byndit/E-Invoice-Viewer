permissionset 50600 "PTE E-Invoice-Viewer"
{
    Assignable = true;
    Permissions = tabledata "PTE E-Invoice Header" = RIMD,
        tabledata "PTE E-Invoice Line" = RIMD,
        table "PTE E-Invoice Header" = X,
        table "PTE E-Invoice Line" = X,
        report "PTE E-Invoice Viewer" = X,
        codeunit "PTE After Import Into Doc." = X;
}