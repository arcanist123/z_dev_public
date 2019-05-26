"! <p class="shorttext synchronized" lang="en">service to connect to the ozon gateway</p>
CLASS z1coz_service DEFINITION
  PUBLIC
FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    CLASS-METHODS create_by_current_config
      RETURNING
        VALUE(r_result) TYPE REF TO z1coz_service.

    METHODS constructor
      IMPORTING
        iv_host_name TYPE string
        iv_client_id TYPE int4
        iv_api_key   TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
*    CONSTANTS:
*      BEGIN OF  gc_host_address,
*        production TYPE string VALUE `https://api-seller.ozon.ru/`,
*
*      END OF gc_host_address.
    DATA host TYPE string.
    DATA client_id TYPE int4.
    DATA api_key TYPE string.

    METHODS request_data
      IMPORTING
        iv_method     TYPE string
        iv_body       TYPE string
      RETURNING
        VALUE(r_data) TYPE string.

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



  METHOD request_data.



  ENDMETHOD.

ENDCLASS.
