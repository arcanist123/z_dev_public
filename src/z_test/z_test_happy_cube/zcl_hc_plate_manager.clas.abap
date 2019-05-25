CLASS zcl_hc_plate_manager DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      typ_facet TYPE x LENGTH 1 .
    TYPES:
      typ_position TYPE n LENGTH 1 .
    TYPES:
      typ_plate_index TYPE n LENGTH 1 .

    TYPES:
      BEGIN OF t_plate,
        plate_index           TYPE typ_plate_index,
        position              TYPE typ_position,
        is_inverted           TYPE abap_bool,
        plate                 TYPE REF TO zcl_hc_plate,
        facet_top             TYPE zcl_hc_plate=>typ_facet,
        facet_top_inverted    TYPE zcl_hc_plate=>typ_facet,
        facet_bottom          TYPE zcl_hc_plate=>typ_facet,
        facet_bottom_inverted TYPE zcl_hc_plate=>typ_facet,
        facet_right           TYPE zcl_hc_plate=>typ_facet,
        facet_right_inverted  TYPE zcl_hc_plate=>typ_facet,
        facet_left            TYPE zcl_hc_plate=>typ_facet,
        facet_left_inverted   TYPE zcl_hc_plate=>typ_facet,
      END OF t_plate .
    TYPES:
      tt_plates TYPE SORTED TABLE OF t_plate WITH NON-UNIQUE KEY plate_index .

    CONSTANTS:
      BEGIN OF position,
        top    TYPE typ_position VALUE 1,
        right  TYPE typ_position VALUE 2,
        bottom TYPE typ_position VALUE 3,
        left   TYPE typ_position VALUE 4,
      END OF position .

    METHODS create_plate_combinations
      IMPORTING
        !iv_plate_index  TYPE typ_plate_index
        !iv_facet_top    TYPE typ_facet
        !iv_facet_right  TYPE typ_facet
        !iv_facet_left   TYPE typ_facet
        !iv_facet_bottom TYPE typ_facet .
    METHODS get_plates_by_index
      IMPORTING
        !iv_plate_index TYPE typ_plate_index
      EXPORTING
        !et_plates      TYPE tt_plates .

  PROTECTED SECTION.
  PRIVATE SECTION.

    CLASS-DATA _gt_plates TYPE tt_plates .

    METHODS get_inverted_versions
      IMPORTING
        !io_top_ni_plate TYPE REF TO zcl_hc_plate
        !iv_plate_index  TYPE typ_plate_index .

ENDCLASS.



CLASS ZCL_HC_PLATE_MANAGER IMPLEMENTATION.


  METHOD create_plate_combinations.

    "create instance of the plate based on the provided elememts
    DATA lo_top_ni_plate TYPE REF TO zcl_hc_plate.
    CREATE OBJECT lo_top_ni_plate
      EXPORTING
        iv_facet_top    = iv_facet_top
        iv_facet_right  = iv_facet_right
        iv_facet_left   = iv_facet_left
        iv_facet_bottom = iv_facet_bottom.
    APPEND VALUE t_plate(
      plate_index = iv_plate_index
      is_inverted = abap_false
      position = position-top
      plate = lo_top_ni_plate
      ) TO _gt_plates.

    "create rotated versions
    "get the right element
    CALL METHOD lo_top_ni_plate->rotate_right
      IMPORTING
        eo_rotated_plate = DATA(lo_right_ni_plate).


    "check if the plate after rotation is the same as before
    CALL METHOD lo_right_ni_plate->is_equal_to
      EXPORTING
        io_plate_to_check = lo_top_ni_plate
      IMPORTING
        ef_is_same        = DATA(lf_top_right_is_same).
    IF lf_top_right_is_same = abap_true.
      "in such case we don't need to add any other elements into the table
    ELSE.
      "the result of rotation is not the same as original element. save the result of rotation
      APPEND VALUE t_plate(
        plate_index = iv_plate_index
        is_inverted = abap_false
        position = position-right
        plate = lo_right_ni_plate
        ) TO _gt_plates.

      "get the bottom plate
      CALL METHOD lo_right_ni_plate->rotate_right
        IMPORTING
          eo_rotated_plate = DATA(lo_bottom_ni_plate).

      "check if bottom and top are the same
      CALL METHOD lo_top_ni_plate->is_equal_to
        EXPORTING
          io_plate_to_check = lo_bottom_ni_plate
        IMPORTING
          ef_is_same        = DATA(lf_top_bottom_same).
      IF lf_top_bottom_same = abap_true.
        "the bottom is the same as top. no need to add bottom then
      ELSE.
        "add the bottom plate
        APPEND VALUE t_plate(
          plate_index = iv_plate_index
          is_inverted = abap_false
          position = position-bottom
          plate = lo_bottom_ni_plate
          ) TO _gt_plates.

        "get left plate
        CALL METHOD lo_bottom_ni_plate->rotate_right
          IMPORTING
            eo_rotated_plate = DATA(lo_left_ni_plate).
        "add left plate
        APPEND VALUE t_plate(
          plate_index = iv_plate_index
          is_inverted = abap_false
          position = position-left
          plate = lo_left_ni_plate
          ) TO _gt_plates.

      ENDIF.

    ENDIF.

    "now try to get the inverted versions
    CALL METHOD get_inverted_versions
      EXPORTING
        io_top_ni_plate = lo_top_ni_plate
        iv_plate_index  = iv_plate_index.

    "update plates
    LOOP AT _gt_plates ASSIGNING FIELD-SYMBOL(<ls_plate>).
      <ls_plate>-facet_bottom = <ls_plate>-plate->gv_facet_bottom.
      <ls_plate>-facet_top = <ls_plate>-plate->gv_facet_top.
      <ls_plate>-facet_left = <ls_plate>-plate->gv_facet_left.
      <ls_plate>-facet_right = <ls_plate>-plate->gv_facet_right.

      CALL METHOD zcl_hc_plate=>mirror_facet
        EXPORTING
          iv_facet        = <ls_plate>-facet_bottom
        IMPORTING
          ev_facet_mirror = <ls_plate>-facet_bottom_inverted.

      CALL METHOD zcl_hc_plate=>mirror_facet
        EXPORTING
          iv_facet        = <ls_plate>-facet_top
        IMPORTING
          ev_facet_mirror = <ls_plate>-facet_top_inverted.

      CALL METHOD zcl_hc_plate=>mirror_facet
        EXPORTING
          iv_facet        = <ls_plate>-facet_left
        IMPORTING
          ev_facet_mirror = <ls_plate>-facet_left_inverted.

      CALL METHOD zcl_hc_plate=>mirror_facet
        EXPORTING
          iv_facet        = <ls_plate>-facet_right
        IMPORTING
          ev_facet_mirror = <ls_plate>-facet_right_inverted.

    ENDLOOP.
  ENDMETHOD.


  METHOD get_inverted_versions.

    "create inverted version of top plate
    CALL METHOD io_top_ni_plate->invert
      IMPORTING
        eo_inverted_plate = DATA(lo_top_inv_plate).

    CALL METHOD lo_top_inv_plate->rotate_right
      IMPORTING
        eo_rotated_plate = DATA(lo_right_inv_plate).

    CALL METHOD lo_right_inv_plate->rotate_right
      IMPORTING
        eo_rotated_plate = DATA(lo_bottom_inv_plate).

    CALL METHOD lo_bottom_inv_plate->rotate_right
      IMPORTING
        eo_rotated_plate = DATA(lo_left_inv_plate).

    "check if the inverted plate can be obtained by rotation
    CALL METHOD io_top_ni_plate->is_equal_to
      EXPORTING
        io_plate_to_check = lo_bottom_inv_plate
      IMPORTING
        ef_is_same        = DATA(lf_bottom_same).

    CALL METHOD io_top_ni_plate->is_equal_to
      EXPORTING
        io_plate_to_check = lo_top_inv_plate
      IMPORTING
        ef_is_same        = DATA(lf_top_same).

    CALL METHOD io_top_ni_plate->is_equal_to
      EXPORTING
        io_plate_to_check = lo_left_inv_plate
      IMPORTING
        ef_is_same        = DATA(lf_left_same).

    CALL METHOD io_top_ni_plate->is_equal_to
      EXPORTING
        io_plate_to_check = lo_right_inv_plate
      IMPORTING
        ef_is_same        = DATA(lf_right_same).

    IF lf_bottom_same = abap_true OR lf_left_same = abap_true OR lf_right_same = abap_true OR lf_top_same = abap_true.
      "inverted and non inverted elements are the same. no need to rotate inverted element
    ELSE.
      "save inverted top
      APPEND VALUE t_plate(
        plate_index = iv_plate_index
        is_inverted = abap_true
        position = position-top
        plate = lo_top_inv_plate
        ) TO _gt_plates.

      "generate and save right element

      APPEND VALUE t_plate(
        plate_index = iv_plate_index
        is_inverted = abap_true
        position = position-right
        plate = lo_right_inv_plate
        ) TO _gt_plates.

      "generate and save the bottom element

      APPEND VALUE t_plate(
        plate_index = iv_plate_index
        is_inverted = abap_true
        position = position-bottom
        plate = lo_bottom_inv_plate
        ) TO _gt_plates.

      "generate and save left element

      APPEND VALUE t_plate(
        plate_index = iv_plate_index
        is_inverted = abap_true
        position = position-left
        plate = lo_left_inv_plate
        ) TO _gt_plates.

    ENDIF.

  ENDMETHOD.


  METHOD get_plates_by_index.
    DATA lt_plates LIKE et_plates.
    APPEND LINES OF FILTER tt_plates( _gt_plates  WHERE plate_index = iv_plate_index  ) TO lt_plates.
    et_plates = lt_plates.
  ENDMETHOD.
ENDCLASS.
