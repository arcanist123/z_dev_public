CLASS zcl_test_np_salv_model_ref DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_alv_rm_grid_friend.
    CLASS-METHODS set_editable
      IMPORTING
        io_salv TYPE REF TO cl_salv_table .

    CLASS-METHODS get_grid
      IMPORTING
        !io_salv_model TYPE REF TO cl_salv_model
      RETURNING
        VALUE(eo_grid) TYPE REF TO cl_gui_alv_grid
      RAISING
        cx_salv_error .

  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-DATA o_event_h TYPE REF TO object.
ENDCLASS.



CLASS ZCL_TEST_NP_SALV_MODEL_REF IMPLEMENTATION.


  METHOD get_grid.

    DATA:  lo_error      TYPE REF TO cx_salv_msg.


    eo_grid = lcl_salv_model_list=>get_grid( io_salv_model ).

  ENDMETHOD.


  METHOD set_editable.

    DATA: lo_event_h TYPE REF TO lcl_event_handler.

    "Event handler
    IF zcl_test_np_salv_model_ref=>o_event_h IS NOT BOUND.
      CREATE OBJECT zcl_test_np_salv_model_ref=>o_event_h
        TYPE lcl_event_handler.
    ENDIF.

    lo_event_h ?= zcl_test_np_salv_model_ref=>o_event_h.
    DATA lf_object_already_present TYPE abap_bool VALUE abap_false.
    LOOP AT lo_event_h->t_salv ASSIGNING FIELD-SYMBOL(<ls>) WHERE table_line = io_salv.
      lf_object_already_present = abap_true.

    ENDLOOP.

    IF lf_object_already_present = abap_true.
    ELSE.
      APPEND io_salv TO lo_event_h->t_salv.
    ENDIF.


    "To gain an access to the underlying object and
    "  do the magic
    SET HANDLER lo_event_h->on_after_refresh
      FOR ALL INSTANCES
      ACTIVATION 'X'.

    "only for GRID, would need to add the toolbar buttons
    IF io_salv->get_display_object( ) = 3.
      SET HANDLER lo_event_h->on_toolbar
        FOR ALL INSTANCES
        ACTIVATION 'X'.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
