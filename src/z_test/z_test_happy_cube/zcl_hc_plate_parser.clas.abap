CLASS zcl_hc_plate_parser DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
      BEGIN OF t_plate
        ,
        plate_index TYPE int4,
        plate       TYPE REF TO zcl_hc_plate,
      END OF t_plate.
    TYPES tt_plates TYPE STANDARD TABLE OF t_plate WITH DEFAULT KEY.

    CLASS-METHODS get_plates_manager
      IMPORTING
        iv_side_1_path   TYPE string
        iv_side_2_path   TYPE string
        iv_side_3_path   TYPE string
        iv_side_4_path   TYPE string
        iv_side_5_path   TYPE string
        iv_side_6_path   TYPE string
      EXPORTING
        eo_plate_manager TYPE REF TO zcl_hc_plate_manager
      RAISING
        zcx_exception.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_HC_PLATE_PARSER IMPLEMENTATION.


  METHOD get_plates_manager.
    "get the list of paths
    DATA lt_plates_path TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
    APPEND iv_side_1_path TO lt_plates_path.
    APPEND iv_side_2_path TO lt_plates_path.
    APPEND iv_side_3_path TO lt_plates_path.
    APPEND iv_side_4_path TO lt_plates_path.
    APPEND iv_side_5_path TO lt_plates_path.
    APPEND iv_side_6_path TO lt_plates_path.

    DATA(lo_plate_manager) = NEW zcl_hc_plate_manager( ).
    LOOP AT lt_plates_path ASSIGNING FIELD-SYMBOL(<ls_plate_path>).
      DATA lv_current_sequence TYPE zcl_hc_plate_manager=>typ_plate_index.
      lv_current_sequence = sy-tabix.
      CALL METHOD zcl_hc_plate_factory=>get_facets
        EXPORTING
          iv_plate_path   = <ls_plate_path>
        IMPORTING
          ev_facet_top    = DATA(lv_facet_top)
          ev_facet_left   = DATA(lv_facet_left)
          ev_facet_right  = DATA(lv_facet_right)
          ev_facet_bottom = DATA(lv_facet_bottom).
      CALL METHOD lo_plate_manager->create_plate_combinations
        EXPORTING
          iv_plate_index  = lv_current_sequence
          iv_facet_top    = lv_facet_top
          iv_facet_right  = lv_facet_right
          iv_facet_left   = lv_facet_left
          iv_facet_bottom = lv_facet_bottom.

    ENDLOOP.
    eo_plate_manager = lo_plate_manager.

  ENDMETHOD.
ENDCLASS.
