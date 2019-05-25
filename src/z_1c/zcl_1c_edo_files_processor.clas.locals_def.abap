*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section
CLASS lcl_edo_parser DEFINITION CREATE PRIVATE.

  PUBLIC SECTION.
    TYPES:
      BEGIN OF t_element ,
        node          TYPE REF TO if_ixml_node,
        document      TYPE REF TO if_ixml_document,
        material_name TYPE string,
        price         TYPE decfloat34,
        quantity      TYPE decfloat34,
      END OF t_element.
    TYPES tt_element TYPE STANDARD TABLE OF t_element WITH DEFAULT KEY.
    CLASS-METHODS create
      IMPORTING
        iv_edo          TYPE xstring

      RETURNING
        VALUE(r_result) TYPE REF TO lcl_edo_parser.


    METHODS get_elements
      EXPORTING
        et_elements TYPE tt_element.


  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA __gv_edo TYPE string.


    CONSTANTS:
      BEGIN OF __gc_node_names ,
        file             TYPE string VALUE 'Файл',
        document         TYPE string VALUE 'Документ',
        material_table   TYPE string VALUE 'ТаблСчФакт',
        material_element TYPE string VALUE 'СведТов',
        quantity         TYPE string VALUE 'КолТов',
        price            TYPE string VALUE 'ЦенаТов',
        material_name    TYPE string VALUE 'НаимТов',
      END OF __gc_node_names.
    METHODS constructor
      IMPORTING
        iv_edo TYPE xstring.


    METHODS get_element_from_file
      IMPORTING
        io_file_node TYPE REF TO if_ixml_node
      EXPORTING
        et_elements  TYPE lcl_edo_parser=>tt_element.
    METHODS get_element_from_document
      IMPORTING
        io_file_node TYPE REF TO if_ixml_node
      EXPORTING
        et_elements  TYPE lcl_edo_parser=>tt_element.
    METHODS get_element_from_mat_table
      IMPORTING
        io_materials_table TYPE REF TO if_ixml_node
      EXPORTING
        et_elements        TYPE lcl_edo_parser=>tt_element.
    METHODS get_element_attr
      IMPORTING
        io_element       TYPE REF TO if_ixml_node
      EXPORTING
        ev_quantity      TYPE decfloat34
        ev_price         TYPE decfloat34
        ev_material_name TYPE string.

ENDCLASS.
