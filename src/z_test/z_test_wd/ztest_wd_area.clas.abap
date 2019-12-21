CLASS ztest_wd_area DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES tt_cells TYPE STANDARD TABLE OF ztest_001 WITH EMPTY KEY.
    METHODS constructor
      IMPORTING it_cells TYPE tt_cells.
    METHODS get_definition.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA gt_cells TYPE ztest_wd_area=>tt_cells.
ENDCLASS.



CLASS ztest_wd_area IMPLEMENTATION.

  METHOD constructor.
    me->gt_cells = it_cells.
  ENDMETHOD.
  METHOD get_definition.
    DATA(lt_areas) = ztest_wd_cells_processor=>get_areas( me->gt_cells ).
  ENDMETHOD.

ENDCLASS.
