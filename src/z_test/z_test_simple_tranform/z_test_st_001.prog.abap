*&---------------------------------------------------------------------*
*& Report z_test_st_001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_test_st_001.
CLASS demo DEFINITION CREATE PRIVATE.

  PUBLIC SECTION.
    CLASS-METHODS main.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS demo IMPLEMENTATION.

  METHOD main.
*    DATA xml TYPE string.

    DATA : BEGIN OF outer_struct ,
             col1 TYPE c LENGTH 20,
             BEGIN OF inner_struct,
               col1 TYPE c LENGTH 20,
               col2 TYPE c LENGTH 20,
             END OF inner_struct,
           END OF outer_struct.

    outer_struct-col1 = 'John'.
    outer_struct-inner_struct-col1 = 'will'.
    outer_struct-inner_struct-col2 = 'come'.



     DATA(out) = cl_demo_output=>new( ).
     TRY.
         "Serialization
         CALL TRANSFORMATION z_test_st_001
           SOURCE outer_struct = outer_struct
           RESULT XML data(xml).
         out->write_xml( xml ).
         "Deserialization
*         CALL TRANSFORMATION demo_st_structure
*           SOURCE XML xml
*           RESULT para = result.
*         IF result = struc1.
*            out->write_text( 'Symmetric transformation!' ).
*         ENDIF.
       CATCH cx_st_error.
         out->write_text( 'Error in Simple Transformation' ).
     ENDTRY.
     out->display( ).
  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.
  demo=>main( ).
