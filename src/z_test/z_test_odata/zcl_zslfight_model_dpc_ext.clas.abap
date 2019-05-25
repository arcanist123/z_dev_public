class ZCL_ZSLFIGHT_MODEL_DPC_EXT definition
  public
  inheriting from ZCL_ZSLFIGHT_MODEL_DPC
  create public .

public section.
protected section.

  methods SCARRSET_GET_ENTITY
    redefinition .
  methods SCARRSET_GET_ENTITYSET
    redefinition .
  methods SFLIGHTSET_GET_ENTITY
    redefinition .
  methods SFLIGHTSET_GET_ENTITYSET
    redefinition .
  methods SCARRSET_CREATE_ENTITY
    redefinition .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ZSLFIGHT_MODEL_DPC_EXT IMPLEMENTATION.


  METHOD scarrset_create_entity.
    DATA ls_scarr TYPE scarr.
    CALL METHOD io_data_provider->read_entry_data
      IMPORTING
        es_data = ls_scarr.

    INSERT INTO scarr VALUES ls_scarr.

  ENDMETHOD.


  METHOD scarrset_get_entity.
    READ TABLE it_key_tab ASSIGNING FIELD-SYMBOL(<ls_key>) WITH KEY name = 'Carrid'.
    IF <ls_key> IS ASSIGNED.
      SELECT SINGLE * FROM scarr INTO er_entity WHERE carrid = <ls_key>-value.
    ENDIF.

  ENDMETHOD.


  METHOD scarrset_get_entityset.
    DATA:ls_filter_select_options TYPE /iwbep/s_mgw_select_option,
         ls_select_option         TYPE /iwbep/s_cod_select_option.
    DATA lt_selectparams TYPE RANGE OF scarr-carrid.
    DATA ls_selectparams LIKE LINE OF lt_selectparams.


    LOOP AT it_filter_select_options INTO ls_filter_select_options.
      IF ls_filter_select_options-property EQ 'Carrid'.
        LOOP AT ls_filter_select_options-select_options INTO ls_select_option.
          ls_selectparams-sign = ls_select_option-sign.
          ls_selectparams-option = ls_select_option-option.
          ls_selectparams-low = ls_select_option-low.
          ls_selectparams-high = ls_select_option-high.
          APPEND ls_selectparams TO lt_selectparams.
        ENDLOOP.

      ENDIF.

    ENDLOOP.


    SELECT * FROM scarr INTO TABLE et_entityset WHERE carrid IN lt_selectparams.
  ENDMETHOD.


  METHOD sflightset_get_entity.

    "get the key parameters
    "get the carrid component
    READ TABLE it_key_tab ASSIGNING FIELD-SYMBOL(<ls_carrid>) WITH KEY name = 'Carrid'.
    READ TABLE it_key_tab ASSIGNING FIELD-SYMBOL(<ls_connid>) WITH KEY name = 'Connid'.
    READ TABLE it_key_tab ASSIGNING FIELD-SYMBOL(<ls_fldate>) WITH KEY name = 'Fldate'.

    IF <ls_carrid> IS ASSIGNED AND <ls_fldate> IS ASSIGNED AND <ls_connid> IS ASSIGNED .
      "expected
      SELECT SINGLE * FROM sflight INTO er_entity WHERE carrid = <ls_carrid>-value AND fldate = <ls_fldate>-value AND connid = <ls_connid>-value.

    ELSE.
      "not expected
      ASSERT 1 = 2.
    ENDIF.

  ENDMETHOD.


  METHOD sflightset_get_entityset.

    IF iv_filter_string IS INITIAL.
      SELECT * FROM sflight INTO TABLE et_entityset.
    ELSE.
      SELECT * FROM sflight INTO TABLE et_entityset WHERE (iv_filter_string).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
