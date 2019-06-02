"! <p class="shorttext synchronized" lang="en">service to connect to the ozon gateway</p>
CLASS z1coz_service DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE .

  PUBLIC SECTION.
    TYPES:
      BEGIN OF  t_item,
        offer_id   TYPE string,
        product_id TYPE string,
      END OF t_item.
    TYPES tt_items TYPE STANDARD TABLE OF t_item WITH EMPTY KEY.
    TYPES:
      BEGIN OF ts_result,
        items TYPE tt_items,
        total TYPE int4,
      END OF ts_result.

    CLASS-METHODS create_by_current_config
      RETURNING
        VALUE(r_result) TYPE REF TO z1coz_service .
    METHODS constructor
      IMPORTING
        !iv_host_name TYPE string
        !iv_client_id TYPE int4
        !iv_api_key   TYPE string .
    METHODS request_data
      IMPORTING
        !iv_method       TYPE string
        !iv_request_body TYPE string
      RETURNING
        VALUE(rs_data)   TYPE ts_result .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA host TYPE string.
    DATA client_id TYPE string.
    DATA api_key TYPE string.
    METHODS get_http_client
      IMPORTING
        iv_method       TYPE string
      RETURNING
        VALUE(r_result) TYPE  REF TO if_http_client .
    METHODS get_json_responce
      IMPORTING
        io_http_client  TYPE REF TO if_http_client
        iv_request_body TYPE string
      RETURNING
        VALUE(r_result) TYPE string
      RAISING
        cx_parameter_invalid_range
        cx_parameter_invalid_type
        cx_sy_codepage_converter_init
        cx_sy_conversion_codepage .
    METHODS parse_json_to_abap
      IMPORTING
        iv_json_responce TYPE string
      RETURNING
        VALUE(r_result)  TYPE ts_result.



ENDCLASS.



CLASS z1coz_service IMPLEMENTATION.


  METHOD constructor.

    me->host = iv_host_name.
    me->client_id = iv_client_id.
    me->api_key = iv_api_key.

  ENDMETHOD.


  METHOD create_by_current_config.

    DATA(ls_active_config) = z1coz_config_service=>create( )->get_active_config( ).
    r_result = NEW #( iv_api_key    = ls_active_config-api_key
                      iv_client_id  = ls_active_config-client_id
                      iv_host_name  = ls_active_config-host_name  ).

  ENDMETHOD.


  METHOD get_http_client.
    "get the test client to obtain the absolute url
    CALL METHOD cl_http_client=>create
      EXPORTING
        host               = me->host    " Logical destination (specified in function call)
      IMPORTING
        client             = DATA(lo_test_client)   " HTTP Client Abstraction
      EXCEPTIONS
        argument_not_found = 1
        plugin_not_active  = 2
        internal_error     = 3
        OTHERS             = 4.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    DATA(lv_url) = lo_test_client->create_abs_url(  protocol    = 'https'    " Protocol Name (e.g. http)
                                                    host        = me->host    " Host name
                                                    port        = `443`
                                                    path        = iv_method ).

    cl_http_client=>create_by_url(  EXPORTING   url                =  lv_url
                                    IMPORTING   client             =  DATA(lo_client)   " HTTP Client Abstraction
                                    EXCEPTIONS  argument_not_found = 1
                                                plugin_not_active  = 2
                                                internal_error     = 3
                                                OTHERS             = 4 ).
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    r_result = lo_client.

  ENDMETHOD.


  METHOD request_data.

    DATA(lo_http_client) = me->get_http_client( iv_method ).
    DATA(lv_json_responce) = get_json_responce( io_http_client  = lo_http_client
                                                iv_request_body = iv_request_body ).
    rs_data = me->parse_json_to_abap( lv_json_responce ).

  ENDMETHOD.

  METHOD get_json_responce.

    DATA(lo_rest_client) = NEW cl_rest_http_client( io_http_client = io_http_client  ).
    lo_rest_client->if_rest_client~set_request_header( iv_name = `Client-Id` iv_value = me->client_id ).
    lo_rest_client->if_rest_client~set_request_header( iv_name = `Api-Key` iv_value = me->api_key ).

    DATA(lo_request) = lo_rest_client->if_rest_client~create_request_entity( ).

    DATA(lo_conv) = cl_abap_conv_out_ce=>create( ).
    lo_conv->write( data = iv_request_body ).
    lo_request->set_binary_data( lo_conv->get_buffer( ) ).

    lo_request->set_content_type( `application/json` ).

    lo_rest_client->if_rest_resource~post( lo_request ).

    DATA(lo_response) = lo_rest_client->if_rest_client~get_response_entity( ).
    DATA(lv_http_status) = lo_response->get_header_field( '~status_code' ).
    DATA(lv_response) = lo_response->get_string_data( ).

    lo_rest_client->if_rest_client~close( ).

    r_result = lv_response.

  ENDMETHOD.



  METHOD parse_json_to_abap.

    TYPES:
      BEGIN OF t_result,
        result TYPE ts_result,
      END OF t_result.

    DATA ls_result TYPE t_result.
    /ui2/cl_json=>deserialize(  EXPORTING   json = iv_json_responce
                                CHANGING    data = ls_result ).

    r_result = ls_result-result.
  ENDMETHOD.

ENDCLASS.
