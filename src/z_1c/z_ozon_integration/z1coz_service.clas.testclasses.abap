*"* use this source file for your ABAP unit test classes

CLASS lcl_test_001 DEFINITION CREATE PUBLIC FOR TESTING.

  PUBLIC SECTION.
    METHODS  test_service FOR TESTING.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_test_001 IMPLEMENTATION.

  METHOD test_service .

    DATA(lo_service) = z1coz_service=>create_by_current_config( ).

    DATA lv_method TYPE string VALUE `/v1/product/list`.
    DATA lv_body TYPE string VALUE `{"language":"RU"}`.
    DATA(lv_data) = lo_service->request_data(   iv_method = lv_method
                                                iv_request_body   = lv_body ).




  ENDMETHOD.

ENDCLASS.
