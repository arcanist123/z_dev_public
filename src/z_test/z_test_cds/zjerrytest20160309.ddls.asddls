@AbapCatalog.sqlViewName: 'zjerrySQL0309'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'test 233'
@ObjectModel: {
  createEnabled,
  deleteEnabled,
  updateEnabled
}
define view Zjerrytest20160309
as select from spfli association [0..1] to scarr as _scarr
on _scarr.carrid = spfli.carrid {
      key spfli.carrid,
      key _scarr.carrname,
      key spfli.connid,
      spfli.cityfrom,
      spfli.cityto
} 
 