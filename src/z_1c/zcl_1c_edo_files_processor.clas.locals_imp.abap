*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations


CLASS lcl_edo_parser IMPLEMENTATION.

  METHOD create.


    CREATE OBJECT r_result
      EXPORTING
        iv_edo = iv_edo.


  ENDMETHOD.

  METHOD constructor.


    DATA: obj TYPE REF TO cl_abap_conv_in_ce,

          len TYPE int4.

    TRY.

        CALL METHOD cl_abap_conv_in_ce=>create
          EXPORTING
            input       = iv_edo
            encoding    = '1504'
            replacement = ''
          RECEIVING
            conv        = obj.

      CATCH cx_parameter_invalid_range .

      CATCH cx_sy_codepage_converter_init .

    ENDTRY.

    len = xstrlen( iv_edo ).

    TRY.
        DATA lv_string TYPE string.
        CALL METHOD obj->read
          EXPORTING
            n    = len
          IMPORTING
            data = lv_string.

      CATCH cx_sy_conversion_codepage .

      CATCH cx_sy_codepage_converter_init .

      CATCH cx_parameter_invalid_type .

      CATCH cx_parameter_invalid_range .

    ENDTRY.
    me->__gv_edo = lv_string.

  ENDMETHOD.



  METHOD get_elements.

**-- Create the Main Factory
    DATA(lo_ixml) = cl_ixml=>create( ).

**-- CREATE the Initial document
    DATA(lo_ixml_document) = lo_ixml->create_document( ).

**-- CREATE a stream factory
    DATA(lo_ixml_stream_factory) = lo_ixml->create_stream_factory( ).

**-- CREATE an INPUT stream
    DATA(lo_ixml_istream)       = lo_ixml_stream_factory->create_istream_string( string = me->__gv_edo ).

**-- CREATE a parser
    DATA(lo_ixml_parser) = lo_ixml->create_parser(
         document       = lo_ixml_document
         istream        = lo_ixml_istream
         stream_factory = lo_ixml_stream_factory
     ).

**-- CHECK errors IN parsing
    IF lo_ixml_parser->parse( ) <> 0.
      IF lo_ixml_parser->num_errors( ) <> 0.
        DATA(lv_error_count) = lo_ixml_parser->num_errors( ).
        DATA(lv_index) = 0.
*        WHILE lv_index < lv_error_count.
*          lif_ixml_parse_error = lif_ixml_parser->get_error( index = lv_index ).
*          APPEND INITIAL LINE TO lt_xml_error ASSIGNING <fs_xml_error>.
*          <fs_xml_error>column_name = lif_ixml_parse_error>get_column( ).
*          <fs_xml_error>line = lif_ixml_parse_error>get_line( ).
*          <fs_xml_error>reason = lif_ixml_parse_error>get_reason( ).
*          lv_index = lv_index + 1.
*        ENDWHILE.
      ENDIF.
    ENDIF.

**-- Close the Input Stream after Parsing
    lo_ixml_istream->close( ).


    "get the top nodes
    DATA(lo_children)  = lo_ixml_document->get_children( ).
    DATA(lo_iterator) = lo_children->create_iterator( ).


    DATA lx_processing_finished TYPE abap_bool.
    WHILE lx_processing_finished = abap_false.
      DATA(lo_next_node) = lo_iterator->get_next( ).
      IF lo_next_node IS BOUND.
        DATA(lv_name) = lo_next_node->get_name( ).
        IF lv_name = __gc_node_names-file.
          CALL METHOD get_element_from_file
            EXPORTING
              io_file_node = lo_next_node
            IMPORTING
              et_elements  = et_elements.
        ENDIF.

      ELSE.
        lx_processing_finished = abap_true.
      ENDIF.
    ENDWHILE.

    LOOP AT et_elements ASSIGNING FIELD-SYMBOL(<ls_element>).
      <ls_element>-document = lo_ixml_document.

    ENDLOOP.

  ENDMETHOD.






  METHOD get_element_from_file.
    "get the children of file
    DATA(lo_children) = io_file_node->get_children( ).
    DATA(lo_iterator)  = lo_children->create_iterator( ).
    DATA(lx_processing_finished) = abap_false.
    WHILE lx_processing_finished = abap_false.

      DATA(lo_next_node) = lo_iterator->get_next( ).
      IF lo_next_node IS BOUND.
        IF lo_next_node->get_name( ) = __gc_node_names-document.
          CALL METHOD me->get_element_from_document
            EXPORTING
              io_file_node = lo_next_node
            IMPORTING
              et_elements  = et_elements.
        ENDIF.
      ELSE.
        lx_processing_finished  = abap_true.
      ENDIF.
    ENDWHILE.

  ENDMETHOD.


  METHOD get_element_from_document.
    DATA(lo_iterator) = io_file_node->get_children( )->create_iterator( ).
    DATA(lx_processing_finished) = abap_false.
    WHILE lx_processing_finished = abap_false.
      DATA(lo_next_node) = lo_iterator->get_next( ).
      IF lo_next_node IS  BOUND.
        DATA(lv_name) = lo_next_node->get_name( ).
        IF lv_name = __gc_node_names-material_table.
          CALL METHOD get_element_from_mat_table
            EXPORTING
              io_materials_table = lo_next_node
            IMPORTING
              et_elements        = et_elements.

        ENDIF.
      ELSE.
        lx_processing_finished = abap_true.
      ENDIF.
    ENDWHILE.

  ENDMETHOD.


  METHOD get_element_from_mat_table.
    DATA(lo_iterator) = io_materials_table->get_children( )->create_iterator( ).
    DATA(lx_processing_finished) = abap_false.
    WHILE lx_processing_finished = abap_false.
      DATA(lo_node_next) = lo_iterator->get_next( ).
      IF lo_node_next IS BOUND.
        DATA(lv_name) = lo_node_next->get_name( ).
        IF lv_name = __gc_node_names-material_element.
          CALL METHOD me->get_element_attr
            EXPORTING
              io_element       = lo_node_next
            IMPORTING
              ev_price         = DATA(lv_price)
              ev_quantity      = DATA(lv_quantity)
              ev_material_name = DATA(lv_material_name).
          "save the element
          APPEND VALUE t_element(
              node = lo_node_next
              price = lv_price
              quantity = lv_quantity
              material_name = lv_material_name
          ) TO et_elements.

        ENDIF.
      ELSE.
        lx_processing_finished = abap_true.
      ENDIF.
    ENDWHILE.


  ENDMETHOD.


  METHOD get_element_attr.
    DATA(lo_interator) = io_element->get_attributes( )->create_iterator( ).
    DATA(lx_processing_finished) = abap_false.
    WHILE lx_processing_finished = abap_false.
      DATA(lo_next_attribute)  = lo_interator->get_next( ).
      IF lo_next_attribute IS BOUND.
        "check if the name of the attribute pass
        DATA(lv_name)  = lo_next_attribute->get_name( ).

        IF lv_name = __gc_node_names-quantity.
          ev_quantity = lo_next_attribute->get_value( ).
        ENDIF.

        IF lv_name = __gc_node_names-price.
          ev_price  = lo_next_attribute->get_value( ).

        ENDIF.

        IF lv_name = __gc_node_names-material_name.
          ev_material_name = lo_next_attribute->get_value( ).
        ENDIF.

      ELSE.
        lx_processing_finished = abap_true.
      ENDIF.
    ENDWHILE.




  ENDMETHOD.

ENDCLASS.

CLASS lcl_sales_order_parser DEFINITION FINAL CREATE PRIVATE.

  PUBLIC SECTION.
    TYPES:
      BEGIN OF t_sales_order,
        material_name TYPE string,
        material_id   TYPE string,
        material_size TYPE string,
        price         TYPE decfloat34,
        quantity      TYPE decfloat34,
        adjusted      TYPE abap_bool,
      END OF t_sales_order.
    TYPES tt_sales_order TYPE STANDARD TABLE OF t_sales_order WITH DEFAULT KEY.
    CLASS-METHODS create
      IMPORTING
        iv_files_sales_order TYPE xstring
      RETURNING
        VALUE(r_result)      TYPE REF TO lcl_sales_order_parser.

    METHODS get_details
      RETURNING
        VALUE(rt_sales_order_details) TYPE tt_sales_order.
  PROTECTED SECTION.

  PRIVATE SECTION.
    CLASS-DATA go_instance TYPE REF TO lcl_sales_order_parser.

    DATA gv_saves_order TYPE string.
    METHODS constructor
      IMPORTING
        iv_files_sales_order TYPE xstring.
ENDCLASS.

CLASS lcl_sales_order_parser IMPLEMENTATION.

  METHOD constructor.
*    me->gv_saves_order = iv_files_sales_order.



    DATA: obj TYPE REF TO cl_abap_conv_in_ce,

          len TYPE int4.

    TRY.

        CALL METHOD cl_abap_conv_in_ce=>create
          EXPORTING
            input       = iv_files_sales_order
            encoding    = 'UTF-8'
            replacement = ''
          RECEIVING
            conv        = obj.

      CATCH cx_parameter_invalid_range .

      CATCH cx_sy_codepage_converter_init .

    ENDTRY.

    len = xstrlen( iv_files_sales_order ).

    TRY.
        DATA lv_string TYPE string.
        CALL METHOD obj->read
          EXPORTING
            n    = len
          IMPORTING
            data = lv_string.

      CATCH cx_sy_conversion_codepage .

      CATCH cx_sy_codepage_converter_init .

      CATCH cx_parameter_invalid_type .

      CATCH cx_parameter_invalid_range .

    ENDTRY.
    me->gv_saves_order = lv_string.

  ENDMETHOD.

  METHOD get_details.
    "split the file into lines
    SPLIT me->gv_saves_order AT cl_abap_char_utilities=>cr_lf INTO TABLE DATA(lt_sales_order_strtab).
    DATA lt_sales_order_details LIKE rt_sales_order_details.


    "split each line
    LOOP AT lt_sales_order_strtab ASSIGNING FIELD-SYMBOL(<ls_sales_order_line>).
      SPLIT <ls_sales_order_line> AT cl_abap_char_utilities=>horizontal_tab INTO TABLE DATA(lt_line_components).

      APPEND VALUE lcl_sales_order_parser=>t_sales_order(
          material_name = lt_line_components[ 2 ]
          material_size = lt_line_components[ 3 ]
          material_id   = lt_line_components[ 1 ]
          price         = CONV decfloat34( lt_line_components[ 5 ] )
          quantity      = CONV decfloat34( lt_line_components[ 9 ] )
      ) TO lt_sales_order_details.


    ENDLOOP.

    DELETE lt_sales_order_details WHERE material_name IS INITIAL.
    "return the results of processing
    rt_sales_order_details = lt_sales_order_details.
  ENDMETHOD.


  METHOD create.
    IF go_instance IS BOUND.

    ELSE.
      go_instance = NEW lcl_sales_order_parser( iv_files_sales_order ).
    ENDIF.

    r_result = go_instance.
  ENDMETHOD.



ENDCLASS.

CLASS lcl_ozon_processor DEFINITION FINAL CREATE PRIVATE.

  PUBLIC SECTION.
    TYPES:
      BEGIN OF t_ozon_detail,
        material_id   TYPE string,
        material_size TYPE string,
        ozon_id       TYPE string,
      END OF t_ozon_detail.
    TYPES tt_ozon_details TYPE STANDARD TABLE OF t_ozon_detail WITH DEFAULT KEY.
    CLASS-METHODS create
      IMPORTING
        iv_files_ozon   TYPE xstring
      RETURNING
        VALUE(r_result) TYPE REF TO lcl_ozon_processor.
    METHODS get_ozon_details
      RETURNING
        VALUE(rt_ozon_details) TYPE tt_ozon_details.
  PROTECTED SECTION.

  PRIVATE SECTION.
    CLASS-DATA go_instance TYPE REF TO  lcl_ozon_processor.
    DATA gv_file_ozon TYPE string.
    METHODS constructor
      IMPORTING
        iv_files_ozon TYPE xstring.


ENDCLASS.

CLASS lcl_ozon_processor IMPLEMENTATION.

  METHOD get_ozon_details.
    "get the lines of the file
    SPLIT me->gv_file_ozon AT cl_abap_char_utilities=>newline INTO TABLE DATA(lt_ozon_lines).

    DATA lt_ozon_details LIKE rt_ozon_details.
    DATA ls_ozon_detail LIKE LINE OF lt_ozon_details.


    LOOP AT lt_ozon_lines ASSIGNING FIELD-SYMBOL(<ls_ozon_line>).
      REPLACE ALL OCCURRENCES OF '"' IN <ls_ozon_line> WITH space.

      SPLIT <ls_ozon_line> AT ';' INTO TABLE DATA(lt_line_components).

      "get the material key and name
      SPLIT lt_line_components[ 1 ] AT '_' INTO TABLE DATA(lt_material_components).

      "the last component is material size
      ls_ozon_detail-material_size  = to_upper( condense( lt_material_components[ lines( lt_material_components ) ] ) ).


      "remove the last component
      DELETE lt_material_components INDEX lines( lt_material_components ) .
      CONCATENATE LINES OF lt_material_components INTO ls_ozon_detail-material_id SEPARATED BY '_'.
      ls_ozon_detail-material_id =  to_upper( condense( ls_ozon_detail-material_id ) ).

      "set the ozon id
      ls_ozon_detail-ozon_id = condense( lt_line_components[ 2 ] ).

      APPEND ls_ozon_detail TO lt_ozon_details.
    ENDLOOP.

    "return the results of processing
    rt_ozon_details = lt_ozon_details.


  ENDMETHOD.
  METHOD constructor.

    DATA: obj TYPE REF TO cl_abap_conv_in_ce,

          len TYPE int4.

    TRY.

        CALL METHOD cl_abap_conv_in_ce=>create
          EXPORTING
            input       = iv_files_ozon
            encoding    = 'UTF-8'
            replacement = ''
          RECEIVING
            conv        = obj.

      CATCH cx_parameter_invalid_range .

      CATCH cx_sy_codepage_converter_init .

    ENDTRY.

    len = xstrlen( iv_files_ozon ).

    TRY.
        DATA lv_string TYPE string.
        CALL METHOD obj->read
          EXPORTING
            n    = len
          IMPORTING
            data = lv_string.

      CATCH cx_sy_conversion_codepage .

      CATCH cx_sy_codepage_converter_init .

      CATCH cx_parameter_invalid_type .

      CATCH cx_parameter_invalid_range .

    ENDTRY.
    me->gv_file_ozon = lv_string.

  ENDMETHOD.

  METHOD create.
    IF go_instance IS BOUND.
    ELSE.
      go_instance = NEW lcl_ozon_processor( iv_files_ozon ).
    ENDIF.

    r_result = go_instance.

  ENDMETHOD.


ENDCLASS.
