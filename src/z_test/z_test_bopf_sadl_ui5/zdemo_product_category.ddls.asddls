@AbapCatalog.sqlViewName: 'ZD_PROD_CATEGORY'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Product category'
define view zdemo_product_category
  as select distinct from /bobf/d_pr_root
{
  category
}
