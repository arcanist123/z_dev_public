CLASS z1coz_config_service DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
      BEGIN OF ts_configuration,
        host_name TYPE string,
        api_key   TYPE string,
        client_id TYPE int4,
      END OF ts_configuration.
    CLASS-METHODS create
      RETURNING
        VALUE(r_result) TYPE REF TO z1coz_config_service.
    METHODS get_active_config
      RETURNING
        VALUE(r_result) TYPE ts_configuration.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z1coz_config_service IMPLEMENTATION.

  METHOD create.
    r_result = NEW #( ).
  ENDMETHOD.

  METHOD get_active_config.

    SELECT SINGLE FROM
        z1coz_config
    FIELDS
        host_name,
        api_key,
        client_id
    WHERE
        active = @abap_true
    INTO
        @r_result.


  ENDMETHOD.

ENDCLASS.
