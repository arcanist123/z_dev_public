CLASS zcl_test_exchage DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
    TYPES:
      BEGIN OF t_group,
        name TYPE string,
      END OF t_group.
    TYPES tt_groups TYPE STANDARD TABLE OF t_group WITH EMPTY KEY.
    TYPES:
      BEGIN OF t_document,
        organisation_name TYPE string,
        groups            TYPE tt_groups,
      END OF t_document.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_test_exchage IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA ls_document TYPE t_document.
    ls_document-organisation_name = 'some name'.
    ls_document-groups = VALUE #( ( name =  `group1` )  ( name =  `group2` )  ).
    DATA(json_writer) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_json ).

    CALL TRANSFORMATION id
      SOURCE root = ls_document
      RESULT XML json_writer.
    DATA(l_string) =  CONV string( json_writer->get_output( ) ).
    DATA(out_cust) = cl_demo_output=>new( ).
    out_cust->write_json( json_writer->get_output( ) ).
  ENDMETHOD.

ENDCLASS.
