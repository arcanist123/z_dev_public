CLASS z_test_fpm_004_form DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES  if_fpm_guibb_form.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA gs_data TYPE sflight.
ENDCLASS.



CLASS z_test_fpm_004_form IMPLEMENTATION.
  METHOD if_fpm_guibb_form~check_config.

  ENDMETHOD.

  METHOD if_fpm_guibb_form~flush.
    FIELD-SYMBOLS: <ls_data> TYPE any.
    ASSIGN is_data->* TO <ls_data>.

    me->gs_data = <ls_data>.
  ENDMETHOD.

  METHOD if_fpm_guibb_form~get_data.
*    DATA : li_makt_line TYPE sflight.
*
*    li_makt_line = cs_data.  "cs_data contains the data
*
*    IF li_makt_line-carrid IS NOT INITIAL.
*
*      SELECT SINGLE * FROM sflight INTO cs_data WHERE carrid = li_makt_line-carrid .
*
*      ev_data_changed = abap_true.
*
*    ENDIF.
*
** Check if the "Start Over" Button in clicked ; If yes clear the contents
*
*    IF io_event->mv_event_id = 'FPM_GOTO_START'.
*
*      CLEAR cs_data.
*
*    ENDIF.

  ENDMETHOD.

  METHOD if_fpm_guibb_form~get_default_config.

  ENDMETHOD.

  METHOD if_fpm_guibb_form~get_definition.

* this method is for building field catalog and actions required in the form

* Local Varibale declarations

    DATA: li_action_line    TYPE fpmgb_s_actiondef.

* Prepare Field catalog

    eo_field_catalog ?= cl_abap_tabledescr=>describe_by_data( p_data = me->gs_data  )." Here we can use any flat strutures or local types

** Prepare actions
*
*    li_action_line-id       = 'GET_CARRID'.  " You can give wahtever name you want to the action ID
*
*    li_action_line-visible  = cl_wd_uielement=>e_visible-visible.
*
*    li_action_line-enabled  = abap_true.
*
*    li_action_line-imagesrc = 'ICON_ADDRESS'.                          " Image for actions
*
*    APPEND li_action_line TO et_action_definition.
  ENDMETHOD.

  METHOD if_fpm_guibb~get_parameter_list.

  ENDMETHOD.

  METHOD if_fpm_guibb~initialize.

  ENDMETHOD.

  METHOD if_fpm_guibb_form~process_event.
    IF io_event->mv_event_id  = 'RUN_REPORT'.
      io_event->mo_event_data->set_value( iv_key = 'CARRID'
                                          iv_value = gs_data-carrid ).


    ENDIF.

  ENDMETHOD.

ENDCLASS.
