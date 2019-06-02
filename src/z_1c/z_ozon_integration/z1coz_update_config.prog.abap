*&---------------------------------------------------------------------*
*& Report z1coz_update_config
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z1coz_update_config.

PARAMETERS p_host TYPE string .
PARAMETERS p_client TYPE string.
PARAMETERS p_key TYPE string LOWER CASE.

CLASS lcl_config DEFINITION CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        iv_host   TYPE string
        iv_client TYPE string
        iv_key    TYPE string.
    METHODS main.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA host TYPE string.
    DATA client TYPE string.
    DATA key TYPE string.

ENDCLASS.

CLASS lcl_config IMPLEMENTATION.

  METHOD constructor.
    me->host = iv_host.
    me->client = iv_client.
    me->key = iv_key.
  ENDMETHOD.

  METHOD main.
    DATA ls_config TYPE z1coz_config.
    ls_config-api_key = me->key.
    ls_config-client_id = me->client.
    ls_config-host_name = me->host.
    ls_config-guid = `123123123123123123`.
    ls_config-active = abap_true.
    MODIFY z1coz_config FROM ls_config.


  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.

  DATA(lo_config) = NEW lcl_config( iv_client   = p_client
                                    iv_host     = p_host
                                    iv_key      = p_key ).
  lo_config->main( ).
