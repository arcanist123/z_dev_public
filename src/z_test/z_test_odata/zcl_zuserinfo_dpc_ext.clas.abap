class ZCL_ZUSERINFO_DPC_EXT definition
  public
  inheriting from ZCL_ZUSERINFO_DPC
  create public .

public section.
protected section.

  methods USERCOLLECTION_GET_ENTITY
    redefinition .
  methods USERCOLLECTION_GET_ENTITYSET
    redefinition .
  methods USERCOLLECTION_CREATE_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZUSERINFO_DPC_EXT IMPLEMENTATION.


METHOD usercollection_create_entity.

  DATA: ls_request_input_data TYPE zcl_zuserinfo_mpc=>ts_zuserinfo,

        ls_userinfo           TYPE zuserinfo.

* Read Request Data

  io_data_provider->read_entry_data( IMPORTING es_data = ls_request_input_data ).

* Fill workarea to be inserted

  ls_userinfo-userid   = ls_request_input_data-userid.

  ls_userinfo-firstname = ls_request_input_data-firstname.

  ls_userinfo-lastname = ls_request_input_data-lastname.

  ls_userinfo-email    = ls_request_input_data-email.

  ls_userinfo-phone    = ls_request_input_data-phone.

  ls_userinfo-country  = ls_request_input_data-country.

* Insert Data in table ZUSERINFO

  INSERT zuserinfo FROM ls_userinfo.

  IF sy-subrc = 0.

    er_entity = ls_request_input_data. "fill exporting parameter er_entity

  endif.

  ENDMETHOD.


METHOD usercollection_get_entity.

  DATA: ls_key_tab  TYPE /iwbep/s_mgw_name_value_pair,

        lv_userid   TYPE zuserinfo-userid,

        ls_userinfo TYPE  zuserinfo.

*Get the key property values

  READ TABLE it_key_tab WITH KEY name = 'Userid' INTO ls_key_tab.

  lv_userid = ls_key_tab-value.

*Get the single record from ZUSERINFO and fill ER_ENTITY

  SELECT SINGLE * FROM zuserinfo INTO ls_userinfo WHERE userid = lv_userid.

  IF sy-subrc = 0.

    er_entity-userid    = ls_userinfo-userid.

    er_entity-firstname = ls_userinfo-firstname.

    er_entity-lastname  = ls_userinfo-lastname.

    er_entity-email     = ls_userinfo-email.

    er_entity-phone     = ls_userinfo-phone.

    er_entity-country   = ls_userinfo-country.

  ENDIF.

ENDMETHOD.


METHOD usercollection_get_entityset.

  DATA: lt_userinfo TYPE TABLE OF zuserinfo,

        ls_userinfo LIKE LINE OF lt_userinfo,

        ls_entity   LIKE LINE OF et_entityset.

*Get data from ZUSERINFO table

  SELECT * FROM zuserinfo INTO TABLE lt_userinfo.

*Fill ET_ENTITYSET

  LOOP AT lt_userinfo INTO  ls_userinfo .

    ls_entity-userid    = ls_userinfo-userid.

    ls_entity-firstname = ls_userinfo-firstname.

    ls_entity-lastname  = ls_userinfo-lastname.

    ls_entity-email     = ls_userinfo-email.

    ls_entity-phone     = ls_userinfo-phone.

    ls_entity-country  = ls_userinfo-country.

    APPEND ls_entity TO et_entityset.

  ENDLOOP.

ENDMETHOD.
ENDCLASS.
