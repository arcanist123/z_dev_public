CLASS zcl_1c_edo_files_processor DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE .

  PUBLIC SECTION.
    TYPES:
      BEGIN OF t_files,

        edo         TYPE xstring,
        sales_order TYPE xstring,
        ozon        TYPE xstring,

      END OF t_files
      .
    TYPES:
      BEGIN OF  t_invalid_elements,
        material_id   TYPE string,
        material_size TYPE string,
      END OF t_invalid_elements.
    TYPES tt_invalid_elements TYPE STANDARD TABLE OF t_invalid_elements WITH DEFAULT KEY.
    CLASS-METHODS create
      IMPORTING
        is_files        TYPE t_files
      RETURNING
        VALUE(r_result) TYPE REF TO zcl_1c_edo_files_processor.
    METHODS get_adjusted_edo
      EXPORTING
        rv_adjusted_edo     TYPE string
        et_invalid_elements TYPE tt_invalid_elements.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: __gs_files TYPE zcl_1c_edo_files_processor=>t_files.
    METHODS constructor
      IMPORTING
        is_files TYPE t_files.
ENDCLASS.



CLASS zcl_1c_edo_files_processor IMPLEMENTATION.


  METHOD create.
    r_result = NEW zcl_1c_edo_files_processor( is_files ).



  ENDMETHOD.


  METHOD get_adjusted_edo.
    "get the elements
    DATA(lo_edo_processor) = lcl_edo_parser=>create( __gs_files-edo ).
    CALL METHOD lo_edo_processor->get_elements
      IMPORTING
        et_elements = DATA(lt_xml_elements).

    "get the records from the sales order
    DATA(lo_sales_order_processor) = lcl_sales_order_parser=>create( __gs_files-sales_order  ).
    DATA(lt_sales_order_details) = lo_sales_order_processor->get_details( ).

    "get the records from the ozon file
    DATA(lt_ozon_details) = lcl_ozon_processor=>create( __gs_files-ozon )->get_ozon_details( ).

    "process each material
    LOOP AT lt_xml_elements ASSIGNING FIELD-SYMBOL(<ls_element>).
      "get the element corresponging to the current element
      READ TABLE lt_sales_order_details ASSIGNING FIELD-SYMBOL(<ls_sales_order_line>)
        WITH KEY
            material_name = <ls_element>-material_name
            price = <ls_element>-price
            quantity  = <ls_element>-quantity
            adjusted = abap_false.
      ASSERT sy-subrc = 0.

      "if found - mark it as adjusted
      <ls_sales_order_line>-adjusted = abap_true.

      "we have the sales order details. try to find the corresponding ozon id
      READ TABLE lt_ozon_details ASSIGNING FIELD-SYMBOL(<ls_ozon_details>)
        WITH KEY
          material_id = to_upper(  condense( <ls_sales_order_line>-material_id ) )
          material_size =  to_upper(  condense( <ls_sales_order_line>-material_size ) ).
      IF sy-subrc = 0.
        "we have ozon details. add them  into the xml document
        "create the new element
        DATA(lo_info) = <ls_element>-document->create_element_ns( name = 'ИнфПолФХЖ2' ).
        "add the new attributes into element
        CALL METHOD lo_info->set_attribute_ns
          EXPORTING
            name  = 'Значен'    " Name of Attribute
            value = <ls_ozon_details>-ozon_id.   " Attribute Value
        CALL METHOD lo_info->set_attribute_ns
          EXPORTING
            name  = 'Идентиф'     " Name of Attribute
            value = 'ID товара'.   " Attribute Value
        DATA(lo_last_child) = <ls_element>-node->get_last_child( ).
        <ls_element>-node->insert_child( new_child = lo_info ref_child = lo_last_child ).


      ELSE.
        "save the element as invalid
        APPEND VALUE t_invalid_elements(
            material_id   = <ls_sales_order_line>-material_id
            material_size = <ls_sales_order_line>-material_size
        ) TO et_invalid_elements.
      ENDIF.

    ENDLOOP.

    "once the elements were created, we need to get the string
    DATA(l_xml) = NEW cl_xml_document( ) .
    l_xml->create_with_dom( document = <ls_element>-document ).
    CALL METHOD l_xml->render_2_string
      IMPORTING
        stream = DATA(lv_document).

    rv_adjusted_edo = lv_document.


  ENDMETHOD.
  METHOD constructor.
    "save the instance
    __gs_files = is_files.
  ENDMETHOD.

ENDCLASS.
