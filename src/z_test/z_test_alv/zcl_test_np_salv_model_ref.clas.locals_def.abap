*----------------------------------------------------------------------*
* Event handler ALV events
*----------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    METHODS:
      on_after_refresh FOR EVENT after_refresh OF cl_gui_alv_grid
        IMPORTING
            sender,
      on_toolbar      FOR EVENT toolbar      OF cl_gui_alv_grid
        IMPORTING
            e_object
            e_interactive
            sender.
    DATA: t_salv TYPE STANDARD TABLE OF REF TO cl_salv_table.
ENDCLASS.                    "lcl_event_handler DEFINITION

CLASS lcl_salv_model_list DEFINITION INHERITING FROM cl_salv_model_base.

  PUBLIC SECTION.

    CLASS-METHODS:
      get_grid
        IMPORTING
          io_salv_model          TYPE REF TO cl_salv_model
        RETURNING
          VALUE(ro_gui_alv_grid) TYPE REF TO cl_gui_alv_grid
        RAISING
          cx_salv_msg.

ENDCLASS.
