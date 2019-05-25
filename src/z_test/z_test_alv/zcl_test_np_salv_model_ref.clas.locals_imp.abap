CLASS lcl_event_handler IMPLEMENTATION.
  METHOD on_after_refresh.
    DATA: lo_grid TYPE REF TO cl_gui_alv_grid.
    DATA: ls_layout TYPE lvc_s_layo.
    DATA: lo_salv TYPE REF TO cl_salv_table.

    TRY .
        LOOP AT t_salv INTO lo_salv.
          lo_grid = zcl_test_np_salv_model_ref=>get_grid( lo_salv ).
          CHECK lo_grid EQ sender.

          "deregister the event handler
          SET HANDLER me->on_after_refresh
            FOR ALL INSTANCES
            ACTIVATION space.

          "Set editable
          ls_layout-edit = 'X'.
          lo_grid->set_frontend_layout( ls_layout ).
          lo_grid->set_ready_for_input( 1 ).
        ENDLOOP.
      CATCH cx_salv_error.
    ENDTRY.
  ENDMETHOD.                    "on_AFTER_REFRESH
*
  METHOD on_toolbar.

    DATA: lo_grid TYPE REF TO cl_gui_alv_grid.
    DATA: ls_layout TYPE lvc_s_layo.
    DATA: mt_toolbar TYPE ttb_button.
    DATA: ls_toolbar LIKE LINE OF mt_toolbar.
    DATA: lo_salv TYPE REF TO cl_salv_table.


    TRY .
        LOOP AT t_salv INTO lo_salv.
          lo_grid = zcl_test_np_salv_model_ref=>get_grid( lo_salv ).

          IF lo_grid EQ sender.
            EXIT.
          ELSE.
            CLEAR lo_grid.
          ENDIF.
        ENDLOOP.
      CATCH cx_salv_msg.
        EXIT.
    ENDTRY.

    CHECK lo_grid IS BOUND.
    CHECK lo_grid->is_ready_for_input( ) = 1.


*... Toolbar Button CHECK
    CLEAR ls_toolbar.
    ls_toolbar-function    = cl_gui_alv_grid=>mc_fc_check.
    ls_toolbar-quickinfo  = TEXT-053.  "Eingaben prfen
    ls_toolbar-icon        = icon_check.
    ls_toolbar-disabled    = space.
    APPEND ls_toolbar TO mt_toolbar.


*... Toolbar Seperator
    CLEAR ls_toolbar.
    ls_toolbar-function    = '&&SEP01'.
    ls_toolbar-butn_type  = 3.
    APPEND ls_toolbar TO mt_toolbar.

*... Toolbar Button CUT
    CLEAR ls_toolbar.
    ls_toolbar-function    = cl_gui_alv_grid=>mc_fc_loc_cut.
    ls_toolbar-quickinfo  = TEXT-046.  "Ausschneiden
    ls_toolbar-icon        = icon_system_cut.
    ls_toolbar-disabled    = space.
    APPEND ls_toolbar TO mt_toolbar.

*... Toolbar Button COPY
    CLEAR ls_toolbar.
    ls_toolbar-function    = cl_gui_alv_grid=>mc_fc_loc_copy.
    ls_toolbar-quickinfo  = TEXT-045.                        " Kopieren
    ls_toolbar-icon        = icon_system_copy.
    ls_toolbar-disabled    = space.
    APPEND ls_toolbar TO mt_toolbar.

*... Toolbar Button PASTE OVER ROW
    CLEAR ls_toolbar.
    ls_toolbar-function    = cl_gui_alv_grid=>mc_fc_loc_paste.
    ls_toolbar-quickinfo  = TEXT-047.
    ls_toolbar-icon        = icon_system_paste.
    ls_toolbar-disabled    = space.
    APPEND ls_toolbar TO mt_toolbar.

*... Toolbar Button PASTE NEW ROW
    CLEAR ls_toolbar.
    ls_toolbar-function    = cl_gui_alv_grid=>mc_fc_loc_paste_new_row.
    ls_toolbar-quickinfo  = TEXT-063.
    ls_toolbar-icon        = icon_system_paste.
    ls_toolbar-disabled    = space.
    APPEND ls_toolbar TO mt_toolbar.

*... Toolbar Button UNDO
    CLEAR ls_toolbar.
    ls_toolbar-function    = cl_gui_alv_grid=>mc_fc_loc_undo.
    ls_toolbar-quickinfo  = TEXT-052.  "Rckgngig
    ls_toolbar-icon        = icon_system_undo.
    ls_toolbar-disabled    = space.
    APPEND ls_toolbar TO mt_toolbar.

*... Toolbar Separator
    CLEAR ls_toolbar.
    ls_toolbar-function    = '&&SEP02'.
    ls_toolbar-butn_type  = 3.
    APPEND ls_toolbar TO mt_toolbar.

*... Toolbar Button APPEND ROW
    CLEAR ls_toolbar.
    ls_toolbar-function    = cl_gui_alv_grid=>mc_fc_loc_append_row.
    ls_toolbar-quickinfo  = TEXT-054.  "Zeile anhngen
    ls_toolbar-icon        = icon_create.
    ls_toolbar-disabled    = space.
    APPEND ls_toolbar TO mt_toolbar.

*... Toolbar Button INSERT ROW
    CLEAR ls_toolbar.
    ls_toolbar-function    = cl_gui_alv_grid=>mc_fc_loc_insert_row.
    ls_toolbar-quickinfo  = TEXT-048.  "Zeile einfgen
    ls_toolbar-icon        = icon_insert_row.
    ls_toolbar-disabled    = space.
    APPEND ls_toolbar TO mt_toolbar.

*... Toolbar Button DELETE ROW
    CLEAR ls_toolbar.
    ls_toolbar-function    = cl_gui_alv_grid=>mc_fc_loc_delete_row.
    ls_toolbar-quickinfo  = TEXT-049.  "Zeile lschen
    ls_toolbar-icon        = icon_delete_row.
    ls_toolbar-disabled    = space.
    APPEND ls_toolbar TO mt_toolbar.

*... Toolbar Button COPY ROW
    CLEAR ls_toolbar.
    ls_toolbar-function    = cl_gui_alv_grid=>mc_fc_loc_copy_row.
    ls_toolbar-quickinfo  = TEXT-051.  "Duplizieren
    ls_toolbar-icon        = icon_copy_object.
    ls_toolbar-disabled    = space.
    APPEND ls_toolbar TO mt_toolbar.

*... Toolbar Separator
    CLEAR ls_toolbar.
    ls_toolbar-function    = '&&SEP03'.
    ls_toolbar-butn_type  = 3.
    APPEND ls_toolbar TO mt_toolbar.

    APPEND LINES OF mt_toolbar TO e_object->mt_toolbar.

  ENDMETHOD.                    "on_toolbar
ENDCLASS.                    "lcl_event_handler IMPLEMENTATION

CLASS lcl_salv_model_list IMPLEMENTATION.

  METHOD get_grid.
    DATA:
      lo_grid_adap TYPE REF TO cl_salv_grid_adapter,
      lo_fs_adap   TYPE REF TO cl_salv_fullscreen_adapter,
      lo_root      TYPE REF TO cx_root.

    TRY .
        lo_grid_adap ?= io_salv_model->r_controller->r_adapter.
      CATCH cx_root INTO lo_root.
        "could be fullscreen adaptper
        TRY .
            lo_fs_adap ?= io_salv_model->r_controller->r_adapter.
          CATCH cx_root INTO lo_root.
            RAISE EXCEPTION TYPE cx_salv_msg
              EXPORTING
                previous = lo_root
                msgid    = '00'
                msgno    = '001'
                msgty    = 'e'
                msgv1    = 'check previous exception'.
        ENDTRY.
    ENDTRY.

    IF lo_grid_adap IS NOT INITIAL.
      ro_gui_alv_grid = lo_grid_adap->get_grid( ).
    ELSEIF lo_fs_adap IS NOT INITIAL.
      ro_gui_alv_grid = lo_fs_adap->get_grid( ).
    ELSE.
      RAISE EXCEPTION TYPE cx_salv_msg
        EXPORTING
          msgid = '00'
          msgno = '001'
          msgty = 'w'
          msgv1 = 'adapter is not bound yet'.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
