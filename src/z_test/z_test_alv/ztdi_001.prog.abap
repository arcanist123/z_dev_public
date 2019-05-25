*&---------------------------------------------------------------------*
*& Report ztdi_001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztdi_001.

DATA: r_dock_container TYPE REF TO cl_gui_docking_container,
      r_salv_table     TYPE REF TO cl_salv_table.

DATA: it_sflight TYPE sflight OCCURS 0,
      it_spfli   TYPE spfli   OCCURS 0.

DATA: count TYPE i.

START-OF-SELECTION.
  SELECT * FROM sflight INTO TABLE it_sflight UP TO 10 ROWS.
  SELECT * FROM spfli INTO TABLE it_spfli UP TO 10 ROWS.

  CALL SCREEN 0200.

MODULE pbo OUTPUT.
  SET PF-STATUS space.

  IF count IS INITIAL.
    CREATE OBJECT r_dock_container
      EXPORTING
        side   = cl_gui_docking_container=>dock_at_bottom
      EXCEPTIONS
        OTHERS = 1.

    CALL METHOD r_dock_container->set_height
      EXPORTING
        height = 170.

    CALL METHOD cl_salv_table=>factory
      EXPORTING
        r_container  = r_dock_container
      IMPORTING
        r_salv_table = r_salv_table
      CHANGING
        t_table      = it_sflight.

*  ALV Display
    r_salv_table->display( ).
  ELSE.

    r_dock_container->free( ).   "this is crucial to release proxy object of docking container
    CLEAR r_dock_container.   "and clear a reference variable (with these two statements your control will disapear from screen)

    "now you can create a new one and bound a new ALV to it
    CREATE OBJECT r_dock_container
      EXPORTING
        side   = cl_gui_docking_container=>dock_at_bottom
      EXCEPTIONS
        OTHERS = 1.

    CALL METHOD r_dock_container->set_height
      EXPORTING
        height = 170.


    CALL METHOD cl_salv_table=>factory
      EXPORTING
        r_container  = r_dock_container
      IMPORTING
        r_salv_table = r_salv_table
      CHANGING
        t_table      = it_spfli.

*  ALV Display
    r_salv_table->display( ).
  ENDIF.

  ADD 1 TO count .
ENDMODULE.
