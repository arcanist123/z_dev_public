@AbapCatalog.sqlViewName: 'z20160310'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'consume view test '
@ObjectModel: {
  type: #CONSUMPTION,
  compositionRoot,
  semanticKey: ['Actor'],
  createEnabled,
  deleteEnabled,
  updateEnabled
}
define view Zjerrytest20160310 as select from Zjerrytest20160309 {
    key Zjerrytest20160309.carrid as Jerryid,
    key Zjerrytest20160309.carrname as name,
    key Zjerrytest20160309.cityfrom as startLocation,
    key Zjerrytest20160309.cityto as target,
    key Zjerrytest20160309.connid
} 
 