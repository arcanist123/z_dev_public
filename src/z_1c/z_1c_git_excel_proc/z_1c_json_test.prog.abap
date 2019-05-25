*&---------------------------------------------------------------------*
*& Report z_1c_json_test
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_1c_json_test.

CLASS demo DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS main.
ENDCLASS.

CLASS demo IMPLEMENTATION.
  METHOD main.
    DATA(out) = cl_demo_output=>new(
      )->begin_section(
      `XML Results for CALL TRANSFORMATION` ).
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

    DATA ls_document TYPE t_document.
    ls_document-organisation_name = 'some name'.
    ls_document-groups = VALUE #( ( name =  `group1` )  ( name =  `group2` )  ).

    "JSON writer
    out->next_section( `JSON Writer` ).
    DATA(json_writer) = cl_sxml_string_writer=>create(
                                type = if_sxml=>co_xt_json ).
    CALL TRANSFORMATION id SOURCE root = ls_document
                           RESULT XML json_writer.
    out->write_json( json_writer->get_output( )
      )->display( ).
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  demo=>main( ).
