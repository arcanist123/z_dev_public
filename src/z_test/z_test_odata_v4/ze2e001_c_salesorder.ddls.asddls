@AbapCatalog.sqlViewName: 'ZE2E001CSO'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'OData V4 Demo Service - SalesOrder Root'
define view ZE2E001_C_SalesOrder
  as select from SEPM_I_SalesOrder_E
 
  association [1..*] to Ze2e001_C_Salesorderitem as _Item on _Item.SalesOrder = $projection.SalesOrder
  association [0..*] to SEPM_I_SalesOrderText_E  as _Text on $projection.SalesOrder = _Text.SalesOrder
 
{
      //SEPM_I_SalesOrder_E
  key SalesOrder,
      CreatedByUser,
      CreationDateTime,
      LastChangedByUser,
      LastChangedDateTime,
      IsCreatedByBusinessPartner,
      IsLastChangedByBusinessPartner,
      Customer,
      CustomerContact,
      TransactionCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      GrossAmountInTransacCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      NetAmountInTransactionCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      TaxAmountInTransactionCurrency,
      SalesOrderLifeCycleStatus,
      SalesOrderBillingStatus,
      SalesOrderDeliveryStatus,
      SalesOrderOverallStatus,
      Opportunity,
      SalesOrderPaymentMethod,
      SalesOrderPaymentTerms,
      BillToParty,
      BillToPartyRole,
      ShipToParty,
      ShipToPartyRole,
      /* Associations */
      _Item,
      _Text
 
}
