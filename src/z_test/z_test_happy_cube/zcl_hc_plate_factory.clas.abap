CLASS zcl_hc_plate_factory DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE .

  PUBLIC SECTION.
    CLASS-METHODS get_facets
      IMPORTING
        iv_plate_path   TYPE string
      EXPORTING
        ev_facet_top    TYPE zcl_hc_plate=>typ_facet
        ev_facet_left   TYPE zcl_hc_plate=>typ_facet
        ev_facet_right  TYPE zcl_hc_plate=>typ_facet
        ev_facet_bottom TYPE zcl_hc_plate=>typ_facet
      RAISING
        zcx_exception.
  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES tt_string_matrix TYPE STANDARD TABLE OF string WITH DEFAULT KEY.

    CLASS-METHODS get_horizontal_facet
      IMPORTING
        iv_line             TYPE string
      EXPORTING
        ev_horizontal_facet TYPE zcl_hc_plate=>typ_facet
      RAISING
        zcx_exception.
    CLASS-METHODS get_vertical_facet
      IMPORTING
        iv_position       TYPE int4
        it_lines          TYPE zcl_hc_plate_factory=>tt_string_matrix
      EXPORTING
        ev_vertical_facet TYPE zcl_hc_plate=>typ_facet
      RAISING
        zcx_exception.
    CLASS-METHODS _get_facets
      IMPORTING
        it_lines        TYPE zcl_hc_plate_factory=>tt_string_matrix
      EXPORTING
        ev_facet_top    TYPE zcl_hc_plate=>typ_facet
        ev_facet_left   TYPE zcl_hc_plate=>typ_facet
        ev_facet_right  TYPE zcl_hc_plate=>typ_facet
        ev_facet_bottom TYPE zcl_hc_plate=>typ_facet
      RAISING
        zcx_exception.
    CLASS-METHODS load_the_data_from_path
      IMPORTING
        iv_plate_path      TYPE string
      RETURNING
        VALUE(rt_data_tab) TYPE zcl_hc_plate_factory=>tt_string_matrix
      RAISING
        zcx_exception.
ENDCLASS.



CLASS ZCL_HC_PLATE_FACTORY IMPLEMENTATION.


  METHOD get_facets.
    "get the plate data
    DATA lt_data_tab TYPE zcl_hc_plate_factory=>tt_string_matrix.
    lt_data_tab = load_the_data_from_path( iv_plate_path ).

    "convert data to facets
    CALL METHOD _get_facets
      EXPORTING
        it_lines        = lt_data_tab
      IMPORTING
        ev_facet_top    = ev_facet_top
        ev_facet_left   = ev_facet_left
        ev_facet_right  = ev_facet_right
        ev_facet_bottom = ev_facet_bottom.

  ENDMETHOD.


  METHOD get_horizontal_facet.
    DATA lv_counter TYPE int4 .
    WHILE lv_counter < 5.
      DATA(lv_character) = iv_line+lv_counter(1) .
      CASE lv_character.
        WHEN '0'.
          SET BIT lv_counter + 1 OF ev_horizontal_facet TO 0.
        WHEN '1'.
          SET BIT lv_counter + 1 OF ev_horizontal_facet TO 1.
        WHEN OTHERS.
          RAISE EXCEPTION TYPE zcx_exception.
      ENDCASE.
      lv_counter = lv_counter + 1.
    ENDWHILE.

  ENDMETHOD.


  METHOD get_vertical_facet.
    DATA lv_counter TYPE int4 VALUE 1.
    DATA lv_position LIKE iv_position.
    lv_position = iv_position - 1.
    WHILE lv_counter <= 5.
      DATA(lv_line) = it_lines[ lv_counter  ].
      DATA(lv_character) = lv_line+lv_position(1).
      CASE lv_character.
        WHEN '1'.
          SET BIT lv_counter OF ev_vertical_facet TO 1.
        WHEN '0'.
          SET BIT lv_counter OF ev_vertical_facet TO 0.
        WHEN OTHERS.
          RAISE EXCEPTION TYPE zcx_exception.
      ENDCASE.
      lv_counter = lv_counter + 1.
    ENDWHILE.

  ENDMETHOD.


  METHOD load_the_data_from_path.

    "load the data from path
    DATA lt_data_tab TYPE tt_string_matrix.
    CALL METHOD cl_gui_frontend_services=>gui_upload
      EXPORTING
        filename                = iv_plate_path " Name of file
      CHANGING
        data_tab                = rt_data_tab    " Transfer table for file contents
      EXCEPTIONS
        file_open_error         = 1
        file_read_error         = 2
        no_batch                = 3
        gui_refuse_filetransfer = 4
        invalid_type            = 5
        no_authority            = 6
        unknown_error           = 7
        bad_data_format         = 8
        header_not_allowed      = 9
        separator_not_allowed   = 10
        header_too_long         = 11
        unknown_dp_error        = 12
        access_denied           = 13
        dp_out_of_memory        = 14
        disk_full               = 15
        dp_timeout              = 16
        not_supported_by_gui    = 17
        error_no_gui            = 18
        OTHERS                  = 19.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    "parse the file data into side info
    LOOP AT rt_data_tab ASSIGNING FIELD-SYMBOL(<ls_data>).

      DATA(lv_line_length) = strlen( <ls_data> ).
      "ensure lines are having correct amount of symbols
      IF lv_line_length <> 5.
        RAISE EXCEPTION TYPE zcx_exception.
      ENDIF.
      "ensure that the middle parts of the plate are not having empty parts
      IF sy-tabix >= 2 AND sy-tabix <= 4.
        DATA(lv_middle_part) = <ls_data>+1(3).
        IF lv_middle_part <> '111'.
          RAISE EXCEPTION TYPE zcx_exception.
        ENDIF.
      ENDIF.

    ENDLOOP.


  ENDMETHOD.


  METHOD _get_facets.
    "get top facet
    DATA lv_top_facet LIKE ev_facet_top.
    CALL METHOD get_horizontal_facet
      EXPORTING
        iv_line             = it_lines[ 1 ]
      IMPORTING
        ev_horizontal_facet = lv_top_facet.

    "get bottom facet
    DATA lv_bottom_facet LIKE ev_facet_top.
    CALL METHOD get_horizontal_facet
      EXPORTING
        iv_line             = it_lines[ 5 ]
      IMPORTING
        ev_horizontal_facet = lv_bottom_facet.

    "get left facet
    DATA lv_left_facet LIKE ev_facet_top.
    CALL METHOD get_vertical_facet
      EXPORTING
        iv_position       = 1
        it_lines          = it_lines
      IMPORTING
        ev_vertical_facet = lv_left_facet.

    "get right facet
    DATA lv_right_facet LIKE ev_facet_top.
    CALL METHOD get_vertical_facet
      EXPORTING
        iv_position       = 5
        it_lines          = it_lines
      IMPORTING
        ev_vertical_facet = lv_right_facet.

    "return the results of processing
    ev_facet_bottom = lv_bottom_facet.
    ev_facet_top = lv_top_facet.
    ev_facet_right = lv_right_facet.
    ev_facet_left = lv_left_facet.

  ENDMETHOD.
ENDCLASS.
