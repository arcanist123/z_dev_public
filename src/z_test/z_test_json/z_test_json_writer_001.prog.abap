*&---------------------------------------------------------------------*
*& Report z_test_json_writer_001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_test_json_writer_001.

TYPES
  :
  BEGIN OF t_material,
    material_name           TYPE string,
    material_line_number    TYPE string,
    material_quantity       TYPE string,
    material_price          TYPE string,
    material_sum            TYPE string,
    material_id             TYPE string,
    material_attribute_name TYPE string,
    material_ozon_id        TYPE string,
  END OF t_material.
TYPES tt_materials TYPE STANDARD TABLE OF t_material WITH EMPTY KEY.
TYPES:
  BEGIN OF t_document,
    date         TYPE string,
    invoice_code TYPE string,
    materials    TYPE tt_materials,
  END OF t_document.

DATA ls_document TYPE t_document.

DATA(out) = cl_demo_output=>new(
   )->begin_section(
   `Identity Transformation for JSON Writer` ).
DATA json_writer TYPE REF TO cl_sxml_string_writer.

out->begin_section(
  `Source JSON String` ).
DATA(json) = cl_abap_codepage=>convert_to(
               `{"TEXT":"Hello JSON!"}` ).
json_writer = cl_sxml_string_writer=>create(
                type = if_sxml=>co_xt_json ).
CALL TRANSFORMATION id SOURCE XML json
                       RESULT XML json_writer.
out->write_json( json_writer->get_output( ) ).

out->next_section(
  `Source JSON Reader` ).
DATA(json_reader) = cl_sxml_string_reader=>create( json ).
json_writer = cl_sxml_string_writer=>create(
                type = if_sxml=>co_xt_json ).
CALL TRANSFORMATION id SOURCE XML json_reader
                       RESULT XML json_writer.
out->write_json( json_writer->get_output( ) ).

out->next_section(
  `Source JSON-XML` ).
DATA(xml_json) = cl_abap_codepage=>convert_to(
 `<object><str name="TEXT">Hello JSON!</str></object>` ).
json_writer = cl_sxml_string_writer=>create(
                type = if_sxml=>co_xt_json ).
CALL TRANSFORMATION id SOURCE root = ls_document
 RESULT XML json_writer.

out->write_json( json_writer->get_output( )
  )->display( ).
