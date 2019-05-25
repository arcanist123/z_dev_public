@AbapCatalog.sqlViewName: 'ZINVOICEITEMS'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View for "Use-cds-view" tutorial'
define view Z_Invoice_Items
  as select from sepm_sddl_so_invoice_item
{
  //sepm_sddl_so_invoice_item

  header.buyer.company_name,
  sepm_sddl_so_invoice_item.sales_order_invoice_key,
  sepm_sddl_so_invoice_item.currency_code,
  sepm_sddl_so_invoice_item.gross_amount,

@EndUserText.quickInfo: 'Paid'  
cast(
    case header.payment_status
        when 'P' then 'X'
        else ' '
    end
as zso_invoice_payment_status )

as payment_status,

//* Associations *//
  header
}
