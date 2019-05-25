CLASS z_1c_process_symbols DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-METHODS create
      RETURNING
        VALUE(r_result) TYPE REF TO z_1c_process_symbols.
    METHODS process_symbols
      IMPORTING
        iv_xstring TYPE xstring.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z_1c_process_symbols IMPLEMENTATION.

  METHOD create.

    CREATE OBJECT r_result.

  ENDMETHOD.
  METHOD process_symbols.
    DATA(conv) = cl_abap_conv_in_ce=>create( encoding   = 'UTF-8'
                                             input      = iv_xstring ).
    DATA lv_string TYPE string.
    conv->read( EXPORTING n     = xstrlen( iv_xstring )
                IMPORTING data  = lv_string ).


    TYPES:
      BEGIN OF t_symbol,
        character TYPE c LENGTH 1,
      END OF     t_symbol.
    DATA lt_symbols TYPE STANDARD TABLE OF t_symbol WITH EMPTY KEY.
    lt_symbols = VALUE #(
        FOR i = strlen( lv_string ) - 1 THEN  i - 1 UNTIL i = 0 (
            character = lv_string+i(1)
        ) ).

    SORT lt_symbols BY character.
    DELETE ADJACENT DUPLICATES FROM lt_symbols COMPARING character.





  ENDMETHOD.

ENDCLASS.
