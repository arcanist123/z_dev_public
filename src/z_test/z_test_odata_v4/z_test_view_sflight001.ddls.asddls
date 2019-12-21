@AbapCatalog.sqlViewName: 'ZSFLIGHT0001'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'z_test_view_sflight001'
define view z_test_view_sflight001 as select from sflight {
    //sflight 
    mandt, 
    carrid, 
    connid, 
    fldate, 
    price, 
    currency, 
    planetype, 
    seatsmax, 
    seatsocc, 
    paymentsum, 
    seatsmax_b, 
    seatsocc_b, 
    seatsmax_f, 
    seatsocc_f
}
