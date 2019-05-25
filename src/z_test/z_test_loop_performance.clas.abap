CLASS z_test_loop_performance DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS main
      IMPORTING
        p_rows TYPE i DEFAULT 1000.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z_TEST_LOOP_PERFORMANCE IMPLEMENTATION.


  METHOD main.

    DATA:
      i_cdpos     TYPE STANDARD TABLE OF cdpos INITIAL SIZE 0,
      i_cdpos1    TYPE STANDARD TABLE OF cdpos INITIAL SIZE 0,
      ls_cdpos    TYPE cdpos,
      ls_cdpos1   TYPE cdpos,
      lv_sta_time TYPE timestampl,
      lv_end_time TYPE timestampl,
      lv_diff_w   TYPE p DECIMALS 5,
      lv_no       TYPE i.
    FIELD-SYMBOLS:
          <lfs_cdpos>  TYPE cdpos.

* Get entries from Change Log Item table
    DATA lv_rows TYPE i.
    lv_rows = p_rows.
    SELECT * UP TO @lv_rows ROWS FROM cdpos
      INTO TABLE @i_cdpos.

* Sorting for BINARY Search
    SORT i_cdpos BY objectclas.
* Keeping a copy in another table
    i_cdpos1[] = i_cdpos[].


* Start time
    GET TIME STAMP FIELD lv_sta_time.
* Scenario1: Parallel Cursor with DELETE within LOOP (The driver table rows are deleted)
    LOOP AT i_cdpos INTO ls_cdpos.
      READ TABLE i_cdpos TRANSPORTING NO FIELDS
                         WITH KEY objectclas = ls_cdpos-objectclas
                         BINARY SEARCH.
      IF sy-subrc EQ 0.
        LOOP AT i_cdpos INTO ls_cdpos1 FROM sy-tabix.
          IF ls_cdpos-objectclas NE ls_cdpos1-objectclas.
            EXIT.
          ELSEIF ls_cdpos1-chngind EQ 'I'.
*   DELETING with INDEX
            DELETE i_cdpos INDEX sy-tabix.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDLOOP.
* End time
    GET TIME STAMP FIELD lv_end_time.
* Time taken for LOOP and DELETE
    lv_diff_w = lv_end_time - lv_sta_time.
    WRITE: /(25) 'DELETE Inside Loop', lv_diff_w.
* Entries left in table
    lv_no = lines( i_cdpos ).
* Number of entries DELETED
    lv_no = lv_rows - lv_no.
    WRITE:/(25) 'No of entries deleted', lv_no.


    CLEAR: lv_no, lv_sta_time, lv_end_time, lv_diff_w, ls_cdpos.
* Start time
    GET TIME STAMP FIELD lv_sta_time.
* Parallel Cursor with MARKING of rows to be DELETED
* Actual DELETE outside of the LOOP
    LOOP AT i_cdpos1 INTO ls_cdpos.
      READ TABLE i_cdpos1 TRANSPORTING NO FIELDS
                          WITH KEY objectclas = ls_cdpos-objectclas
                          BINARY SEARCH.
      IF sy-subrc EQ 0.
        LOOP AT i_cdpos1 ASSIGNING <lfs_cdpos> FROM sy-tabix.
          IF ls_cdpos-objectclas NE <lfs_cdpos>-objectclas.
            EXIT.
          ELSEIF <lfs_cdpos>-chngind EQ 'I'.
* MARKING the ROW to be DELETED.
* Outside the LOOP, objectclas field would be used to identify
            CLEAR <lfs_cdpos>-objectclas.
          ENDIF.

        ENDLOOP.
      ENDIF.
    ENDLOOP.
* DELETE the MARKED rows at one shot
    DELETE i_cdpos1 WHERE objectclas IS INITIAL.

* End time
    GET TIME STAMP FIELD lv_end_time.
* Time taken for LOOP and DELETE
    lv_diff_w = lv_end_time - lv_sta_time.
    WRITE: /(25) 'DELETE Outside Loop', lv_diff_w.
* Entries left in table (this should be same as above)
    lv_no = lines( i_cdpos1 ).
* Number of entries DELETED
    lv_no = lv_rows - lv_no.
    WRITE:/(25) 'No of entries deleted', lv_no.


  ENDMETHOD.
ENDCLASS.
