*&---------------------------------------------------------------------*
*& Report z_test_ozon_api
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_test_ozon_api.

CLASS lcl_ozon_api DEFINITION CREATE PRIVATE.

  PUBLIC SECTION.
    CLASS-METHODS create
      RETURNING
        VALUE(r_result) TYPE REF TO lcl_ozon_api.
    METHODS constructor.
    METHODS main.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_ozon_api IMPLEMENTATION.

  METHOD constructor.

  ENDMETHOD.

  METHOD create.

    CREATE OBJECT r_result.

  ENDMETHOD.

  METHOD main.

    CALL METHOD cl_http_client=>create
      EXPORTING
        host               = 'cb-api.ozonru.me'
*       service            = service_str
*       proxy_host         = proxy_host
**        proxy_service      = proxy_service
*       scheme             = scheme
      IMPORTING
        client             = DATA(lo_client)
      EXCEPTIONS
        argument_not_found = 1
        internal_error     = 2
        plugin_not_active  = 3
        OTHERS             = 4.

    CALL METHOD lo_client->request->set_header_field
      EXPORTING
        name  = 'Client-Id'    " Name of the header field
        value = '466'.    " HTTP header field value
    CALL METHOD lo_client->request->set_header_field
      EXPORTING
        name  = 'Api-Key'    " Name of the header field
        value = '9753260e-2324-fde7-97f1-7848ed7ed097'.    " HTTP header field valu
    CALL METHOD lo_client->request->set_header_field
      EXPORTING
        name  = 'Content-Type'    " Name of the header field
        value = 'application/json'.    " HTTP header field valu

    DATA(lv_request) = lo_client->request->get_cdata( ).
*Send request
    CALL METHOD lo_client->send
      EXCEPTIONS
        http_communication_failure = 1
        http_invalid_state         = 2.
    DATA lt_fields TYPE tihttpnvp.
    CALL METHOD lo_client->request->get_header_fields
      CHANGING
        fields = lt_fields.    " Header fields
*Get return

    CALL METHOD lo_client->receive
      EXCEPTIONS
        http_communication_failure = 1
        http_invalid_state         = 2
        http_processing_failed     = 3.

* DO something with return
    DATA: http_status_code TYPE i,
          status_text      TYPE string.
    CALL METHOD lo_client->response->get_status
      IMPORTING
        code   = http_status_code
        reason = status_text.
    WRITE: / 'HTTP_STATUS_CODE = ',
    http_status_code,
    / 'STATUS_TEXT = ',
    status_text
    .
    DATA lv_result  TYPE string.

    CALL METHOD lo_client->response->get_cdata
      RECEIVING
        data = lv_result.
    WRITE:/ lv_result.


  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.
  lcl_ozon_api=>create( )->main( ).
