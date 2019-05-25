CLASS zcl_1coz_abstract_service DEFINITION
  PUBLIC
  ABSTRACT
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        i_host      TYPE string DEFAULT 'https://api-seller.ozon.ru/'
        i_client_id TYPE int4
        i_api_key   TYPE string.
    METHODS get_client
      RETURNING VALUE(ro_client) TYPE REF TO zcl_1coz_client.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA host TYPE string.
    DATA client_id TYPE int4.
    DATA api_key TYPE string.
    DATA client TYPE REF TO zcl_1coz_client.

ENDCLASS.



CLASS zcl_1coz_abstract_service IMPLEMENTATION.

  METHOD constructor.

    me->host = i_host.
    me->client_id = i_client_id.
    me->api_key = i_api_key.

  ENDMETHOD.
  METHOD get_client.

  ENDMETHOD.

ENDCLASS.
