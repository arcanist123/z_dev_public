//@AbapCatalog.sqlViewName: 'ZE2E001CSOI'
//@AbapCatalog.compiler.compareFilter: true
//@AccessControl.authorizationCheck: #CHECK
//@EndUserText.label: 'OData V4 Demo Service - SalesOrder Items'
//define view Ze2e001_C_Salesorderitem 
// as select from SEPM_I_SalesOrderItem_E
//  association [0..*] to SEPM_I_SalesOrderItemText_E as _Text on  $projection.SalesOrder     = _Text.SalesOrder
//                                                             and $projection.SalesOrderItem = _Text.SalesOrderItem
//{
//      //SEPM_I_SalesOrderItem_E
//  key SalesOrder,
//  key SalesOrderItem,
//      Product,
//      TransactionCurrency,
//      @Semantics.amount.currencyCode: 'TransactionCurrency'
//      GrossAmountInTransacCurrency,
//      @Semantics.amount.currencyCode: 'TransactionCurrency'
//      NetAmountInTransactionCurrency,
//      @Semantics.amount.currencyCode: 'TransactionCurrency'
//      TaxAmountInTransactionCurrency,
//      ProductAvailabilityStatus,
//      OpportunityItem,
//      /* Associations */
//      _Text
//} 
// 
@AbapCatalog.sqlViewName: 'ZE2E001CSOI'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'OData Demo Service - SalesOrder Items'
define view ZE2E001_C_SALESORDERITEM
  as select from ZE2E001_I_SalesOrderItem_E
 
  association [0..*] to SEPM_I_SalesOrderItemText_E as _Text on  $projection.SalesOrder     = _Text.SalesOrder
                                                             and $projection.SalesOrderItem = _Text.SalesOrderItem
 
 
{
     //ZE2E001_I_SalesOrderItem_E 
    key SalesOrder, 
     key SalesOrderItem, 
     Product, 
     TransactionCurrency, 
     @Semantics.amount.currencyCode: 'TransactionCurrency'
     GrossAmountInTransacCurrency, 
     @Semantics.amount.currencyCode: 'TransactionCurrency'
     NetAmountInTransactionCurrency, 
     @Semantics.amount.currencyCode: 'TransactionCurrency'
     TaxAmountInTransactionCurrency, 
     DeliveryDateTime, 
     QuantityUnit as Unit, 
     @Semantics.quantity.unitOfMeasure: 'Unit'
     Quantity, 
     /* Associations */ 
     //ZE2E001_I_SalesOrderItem_E 
     _Product, 
     _Text, 
     _TransactionCurrency 
 
 
} 
