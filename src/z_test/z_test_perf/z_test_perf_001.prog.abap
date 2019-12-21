*&---------------------------------------------------------------------*
*& Report z_test_perf_001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_test_perf_001.

CLASS lcl_test_performance DEFINITION CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS main.
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES tt_test_data TYPE STANDARD TABLE OF int4
        WITH EMPTY KEY.
    METHODS get_test_sample
      RETURNING
        VALUE(r_result) TYPE tt_test_data.

ENDCLASS.

CLASS lcl_test_performance IMPLEMENTATION.

  METHOD main.

    DATA(lt_one_million_rows) = me->get_test_sample(  ).
    GET TIME STAMP FIELD DATA(lv_timestamp).
    WRITE:/ lv_timestamp.



  ENDMETHOD.


  METHOD get_test_sample.

  ENDMETHOD.

ENDCLASS.
