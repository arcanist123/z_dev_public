CLASS z_test_number_distrib DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
    METHODS constructor.
    METHODS get_random_10
      RETURNING VALUE(r_result) TYPE int4.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: go_rng TYPE REF TO cl_abap_random.
    METHODS get_random_16
      RETURNING
        VALUE(r_result) TYPE int4.
ENDCLASS.



CLASS z_test_number_distrib IMPLEMENTATION.

  METHOD constructor.

    go_rng = cl_abap_random=>create( cl_abap_random=>seed( ) ).

  ENDMETHOD.



  METHOD get_random_10.

    WHILE 1 = 1.
      DATA(lv_random) = me->get_random_16( ).
      IF NOT ( lv_random > 10 ).
        r_result = lv_random.
        EXIT.
      ENDIF.
    ENDWHILE.
  ENDMETHOD.


  METHOD get_random_16.
    r_result = go_rng->intinrange(  low            = 1    " lower bound of interval
                                    high           = 16    ).

  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
    TYPES:
      BEGIN OF ts_distribution,
        value TYPE int4,
        count TYPE int4,
      END OF ts_distribution.
    DATA lt_distribution TYPE SORTED TABLE OF ts_distribution WITH UNIQUE KEY value.
    DO 1000000 TIMES.
      COLLECT VALUE ts_distribution(
          value = me->get_random_10( )
          count = 1
      ) INTO lt_distribution.

    ENDDO.

    WRITE: 'Success'.


  ENDMETHOD.

ENDCLASS.
