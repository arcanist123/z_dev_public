*&---------------------------------------------------------------------*
*& Report ZZZZZ
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zzzzz.

START-OF-SELECTION.

  TYPES:
    t_scarr    TYPE HASHED TABLE OF scarr
               WITH UNIQUE KEY carrid.

  TYPES:
    BEGIN OF MESH t_flights1,
      scarr   TYPE t_scarr ASSOCIATION _scarr TO scarr_2 ON carrid = carrid,
      scarr_2 TYPE t_scarr,
    END OF MESH t_flights1.

  DATA lt_flights1 TYPE t_flights1.

  LOOP AT lt_flights1-scarr\_scarr[  lt_flights1-scarr[ ]   ] INTO DATA(ls_).
  ENDLOOP.
