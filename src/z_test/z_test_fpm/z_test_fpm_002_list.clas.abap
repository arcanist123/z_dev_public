CLASS z_test_fpm_002_list DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_fpm_guibb_list.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA lt_sflight TYPE STANDARD TABLE OF sflight.
ENDCLASS.



CLASS z_test_fpm_002_list IMPLEMENTATION.
  METHOD if_fpm_guibb_list~check_config.

  ENDMETHOD.

  METHOD if_fpm_guibb_list~flush.

  ENDMETHOD.

  METHOD if_fpm_guibb_list~get_data.
    ct_data = me->lt_sflight.
    ev_data_changed = abap_true.

  ENDMETHOD.

  METHOD if_fpm_guibb_list~get_default_config.
    io_layout_config->set_settings(

    EXPORTING

    iv_height_mode_ats = if_fpm_list_types=>cs_height_mode_ats-all_rows

    ).
  ENDMETHOD.

  METHOD if_fpm_guibb_list~get_definition.
    DATA lt_sflight TYPE STANDARD TABLE OF sflight.

    DATA ls_field_description LIKE LINE OF et_field_description.

    eo_field_catalog = CAST #( cl_abap_tabledescr=>describe_by_data( p_data = lt_sflight ) ).

    DATA(lo_sflight_line_descr) = CAST cl_abap_structdescr( eo_field_catalog->get_table_line_type( ) ).

    LOOP AT lo_sflight_line_descr->components ASSIGNING FIELD-SYMBOL(<ls_sflight_line_descr>).

      ls_field_description-name = <ls_sflight_line_descr>-name.
      ls_field_description-allow_aggregation = abap_true.
      ls_field_description-allow_filter = abap_true.
      ls_field_description-allow_sort = abap_true.
      APPEND ls_field_description TO et_field_description.

    ENDLOOP.
  ENDMETHOD.

  METHOD if_fpm_guibb~get_parameter_list.

  ENDMETHOD.

  METHOD if_fpm_guibb~initialize.

  ENDMETHOD.

  METHOD if_fpm_guibb_list~process_event.
    IF io_event->mv_event_id = 'RUN_REPORT'.
      DATA lv_carrid TYPE sflight-carrid.
      io_event->mo_event_data->get_value(   EXPORTING iv_key    = 'CARRID'
                                            IMPORTING ev_value  = lv_carrid ).

      IF lv_carrid IS NOT INITIAL.
        SELECT * FROM sflight INTO CORRESPONDING FIELDS OF TABLE @lt_sflight WHERE carrid = @lv_carrid.
      ENDIF.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
