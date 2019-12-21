CLASS ztest_wd_cells_processor DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS get_areas
      IMPORTING
        i_me_gt_cells   TYPE ztest_wd_area=>tt_cells
      RETURNING
        VALUE(r_result) TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS get_rows
      IMPORTING
        i_me_gt_cells   TYPE ztest_wd_area=>tt_cells
      RETURNING
        VALUE(r_result) TYPE string.
    METHODS get_max_y_index
      IMPORTING
        i_me_gt_cells   TYPE ztest_wd_area=>tt_cells
        iv_current_row  TYPE i
      RETURNING
        value(r_result) TYPE int4.
ENDCLASS.



CLASS ztest_wd_cells_processor IMPLEMENTATION.

  METHOD get_areas.
    DATA(lt_rows) = me->get_rows( i_me_gt_cells ).
  ENDMETHOD.


  METHOD get_rows.
    DATA lv_current_row TYPE int4 VALUE 1.

    DATA(lv_max_y_index) = me->get_max_y_index( i_me_gt_cells = i_me_gt_cells
                                                iv_current_row = lv_current_row ).

*    LOOP AT i_me_gt_cells REFERENCE INTO DATA(ls_cell) WHERE y_from = lv_current_row.



*    ENDLOOP.

  ENDMETHOD.


  METHOD get_max_y_index.

  ENDMETHOD.

ENDCLASS.
