*&---------------------------------------------------------------------*
*& Report z_salv_test_001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_salv_test_001.
*
*CLASS lcl_salv_model DEFINITION INHERITING FROM cl_salv_model_list.
*  PUBLIC SECTION.
*    DATA: o_control TYPE REF TO cl_salv_controller_model,
*          o_adapter TYPE REF TO cl_salv_adapter.
*    METHODS:
*      get_model
*        IMPORTING
*          io_model TYPE REF TO cl_salv_model,
*      get_controller,
*      get_adapter.
*  PRIVATE SECTION.
*    DATA: lo_model TYPE REF TO cl_salv_model.
*ENDCLASS.                    "LCL_SALV_MODEL DEFINITION
*
*
**----------------------------------------------------------------------*
** LCL_SALV_MODEL implementation
**----------------------------------------------------------------------*
*CLASS lcl_salv_model IMPLEMENTATION.
*  METHOD get_model.
**   save the model
*    lo_model = io_model.
*  ENDMETHOD.
*  METHOD get_controller.
**   save the controller
*    o_control = lo_model->r_controller.
*  ENDMETHOD.
*  METHOD get_adapter.
**   save the adapter from controller
*    o_adapter ?= lo_model->r_controller->r_adapter.
*  ENDMETHOD.
*ENDCLASS.                    "LCL_SALV_MODEL IMPLEMENTATION
*
*
*
**----------------------------------------------------------------------*
**       CLASS lcl_kbed_alv_control DEFINITION
**----------------------------------------------------------------------*
** Main ALV class controling KBED table display
**----------------------------------------------------------------------*
*CLASS lcl_kbed_alv_control DEFINITION.
**
*  PUBLIC SECTION.
*
*    METHODS:
**     load data
*      constructor
*        IMPORTING
*          it_kbed       TYPE bapiret2_t
*          icr_container TYPE REF TO cl_gui_custom_container
*          iv_dynnr      TYPE sydynnr,
*      refresh_alv
*        IMPORTING
*          it_kbed TYPE bapiret2_t, " ALV data table
**     generate ALV output grid
*      display_output.
*
*  PRIVATE SECTION.
*
*    DATA: pvcr_alv        TYPE REF TO cl_salv_table,
*          pvcr_salv_model TYPE REF TO lcl_salv_model,
**          pvt_kbed_alv    TYPE STANDARD TABLE OF lsty_kbed_alv,
*          pvcx_root       TYPE REF TO cx_root,
*          pvcr_columns    TYPE REF TO cl_salv_columns_table,
*          pvcr_funcs      TYPE REF TO cl_salv_functions_list,
*          pvcr_events     TYPE REF TO cl_salv_events_table,
*          pvcr_display    TYPE REF TO cl_salv_display_settings.
*
*    METHODS:
*      add_toolbar_function
*        IMPORTING
*          iv_name    TYPE c
*          iv_icon    TYPE string
*          iv_text    TYPE c
*          iv_tooltip TYPE c,
**       transform data
*      set_data
*        IMPORTING it_kbed TYPE bapiret2_t,
*      set_alv_func_tools,
*      set_layout,
*      set_toolbar,
*      set_columns,
**       event's method
*      on_link_click FOR EVENT link_click OF cl_salv_events_table IMPORTING row column, " event for checkbox
*      on_cell_doubleclick FOR EVENT double_click OF cl_salv_events_table IMPORTING row column, " normal double click/ hotspot is not needed in this case
*      on_added_function FOR EVENT added_function OF cl_salv_events_table IMPORTING e_salv_function.
*ENDCLASS.
*CLASS lcl_kbed_alv_control IMPLEMENTATION.
*  METHOD add_toolbar_function.
*
*  ENDMETHOD.
*
*  METHOD constructor.
*
*  ENDMETHOD.
*
*  METHOD display_output.
*    me->set_columns( ).
*    me->set_alv_func_tools( ).
*    me->set_layout( ).
*    me->set_toolbar( ).
*
*    DATA: lo_alv_mod TYPE REF TO cl_salv_model.
*
*    lo_alv_mod ?= me->pvcr_alv.
*    CREATE OBJECT pvcr_salv_model.
*    pvcr_salv_model->get_model( io_model = lo_alv_mod ).
*
*    me->pvcr_alv->display( ).   " SALV display method
*  ENDMETHOD.
*
*  METHOD on_added_function.
*
*  ENDMETHOD.
*
*  METHOD on_cell_doubleclick.
*
*  ENDMETHOD.
*
*  METHOD on_link_click.
*
*  ENDMETHOD.
*
*  METHOD refresh_alv.
*    DATA: lo_grid      TYPE REF TO cl_gui_alv_grid,
*          lo_full_adap TYPE REF TO cl_salv_grid_adapter. "cl_salv_fullscreen_adapter,
*
*    me->set_data( it_kbed ).
*    me->pvcr_salv_model->get_adapter( ).
*    lo_full_adap ?= me->pvcr_salv_model->o_adapter.
*    lo_grid = lo_full_adap->get_grid( ).
*    lo_grid->refresh_table_display( ).
*
*  ENDMETHOD.
*
*  METHOD set_alv_func_tools.
*
*  ENDMETHOD.
*
*  METHOD set_columns.
*
*  ENDMETHOD.
*
*  METHOD set_data.
*
*  ENDMETHOD.
*
*  METHOD set_layout.
*
*  ENDMETHOD.
*
*  METHOD set_toolbar.
*
*  ENDMETHOD.
*
*ENDCLASS.
*
*DATA: lo_report TYPE REF TO lcl_kbed_alv_control.
**----------------------------------------------------------------------*
** Start of selection
**----------------------------------------------------------------------*
*START-OF-SELECTION.
*  CREATE OBJECT lo_report
*    EXPORTING
*      it_kbed       = it_kbed
*      icr_container = icr_container
*      iv_dynnr      = sy-dynnr
*    .
*
*  lo_report->generate_output( ).
**----------------------------------------------------------------------*
** Start of selection
**----------------------------------------------------------------------*
*START-OF-SELECTION.
*  CREATE OBJECT lo_report.
*  lo_report->get_data( ).
*  lo_report->generate_output( ).
