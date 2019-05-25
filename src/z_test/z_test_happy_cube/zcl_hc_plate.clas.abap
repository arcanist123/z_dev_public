CLASS zcl_hc_plate DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      typ_facet TYPE x LENGTH 1 .
    TYPES:
      typ_position TYPE n LENGTH 1 .
    TYPES:
      BEGIN OF t_facet,
        position     TYPE typ_position,
        is_inverted  TYPE abap_bool,
        facet_top    TYPE typ_facet,
        facet_bottom TYPE typ_facet,
        facet_left   TYPE typ_facet,
        facet_right  TYPE typ_facet,
      END OF t_facet .
    TYPES:
      tt_facets_combination TYPE STANDARD TABLE OF t_facet WITH DEFAULT KEY .

    CONSTANTS:
      BEGIN OF position,
        top    TYPE typ_position VALUE 1,
        right  TYPE typ_position VALUE 2,
        bottom TYPE typ_position VALUE 3,
        left   TYPE typ_position VALUE 4,
      END OF position .
    DATA gv_facet_top TYPE typ_facet READ-ONLY .
    DATA gv_facet_bottom TYPE typ_facet READ-ONLY.
    DATA gv_facet_right TYPE typ_facet READ-ONLY.
    DATA gv_facet_left TYPE typ_facet READ-ONLY.

    METHODS constructor
      IMPORTING
        iv_facet_top    TYPE typ_facet
        iv_facet_right  TYPE typ_facet
        iv_facet_left   TYPE typ_facet
        iv_facet_bottom TYPE typ_facet .
    METHODS rotate_right
      EXPORTING
        eo_rotated_plate TYPE REF TO zcl_hc_plate.
    METHODS invert
      EXPORTING
        eo_inverted_plate TYPE REF TO zcl_hc_plate.
    METHODS is_equal_to
      IMPORTING
        io_plate_to_check TYPE REF TO zcl_hc_plate
      EXPORTING
        ef_is_same        TYPE abap_bool .
    CLASS-METHODS mirror_facet
      IMPORTING
        iv_facet        TYPE zcl_hc_plate=>typ_facet
      EXPORTING
        ev_facet_mirror TYPE zcl_hc_plate=>typ_facet .
  PROTECTED SECTION.
  PRIVATE SECTION.




ENDCLASS.



CLASS ZCL_HC_PLATE IMPLEMENTATION.


  METHOD constructor.

    me->gv_facet_top = iv_facet_top.
    me->gv_facet_bottom = iv_facet_bottom.
    me->gv_facet_right = iv_facet_right.
    me->gv_facet_left = iv_facet_left.

  ENDMETHOD.


  METHOD invert.

    "get the inverted top facet
    CALL METHOD me->mirror_facet
      EXPORTING
        iv_facet        = me->gv_facet_top
      IMPORTING
        ev_facet_mirror = DATA(lv_facet_top_mirrored).

    "get inverted bottom facet
    CALL METHOD me->mirror_facet
      EXPORTING
        iv_facet        = me->gv_facet_bottom
      IMPORTING
        ev_facet_mirror = DATA(lv_facet_bottom_mirrored).

    DATA lo_inverted_plate TYPE REF TO zcl_hc_plate.
    CREATE OBJECT lo_inverted_plate
      EXPORTING
        iv_facet_top    = lv_facet_top_mirrored
        iv_facet_right  = me->gv_facet_left
        iv_facet_left   = me->gv_facet_right
        iv_facet_bottom = lv_facet_bottom_mirrored.
    eo_inverted_plate = lo_inverted_plate.
  ENDMETHOD.


  METHOD is_equal_to.
    IF me->gv_facet_bottom = io_plate_to_check->gv_facet_bottom AND
      me->gv_facet_left = io_plate_to_check->gv_facet_left AND
      me->gv_facet_right = io_plate_to_check->gv_facet_right  AND
      me->gv_facet_top = io_plate_to_check->gv_facet_top   .
      "they are the same - return true
      ef_is_same = abap_true.
    ELSE.
      ef_is_same = abap_false.
    ENDIF.


  ENDMETHOD.


  METHOD mirror_facet.
    DATA lv_facet_mirror LIKE ev_facet_mirror.
    DATA: lv_bit TYPE i.
    "invert first bit
    GET BIT 1 OF iv_facet INTO lv_bit.
    SET BIT 5 OF lv_facet_mirror TO lv_bit.

    "invert second bit
    GET BIT 2 OF iv_facet INTO lv_bit.
    SET BIT 4 OF lv_facet_mirror TO lv_bit.

    "invert third bit
    GET BIT 3 OF iv_facet INTO lv_bit.
    SET BIT 3 OF lv_facet_mirror TO lv_bit.

    "invert forth bit
    GET BIT 4 OF iv_facet INTO lv_bit.
    SET BIT 2 OF lv_facet_mirror TO lv_bit.

    "invert fifth bit
    GET BIT 5 OF iv_facet INTO lv_bit.
    SET BIT 1 OF lv_facet_mirror TO lv_bit.

    "return the result
    ev_facet_mirror = lv_facet_mirror.

  ENDMETHOD.


  METHOD rotate_right.
    DATA lo_rotated_plate TYPE REF TO zcl_hc_plate.
    CALL METHOD mirror_facet
      EXPORTING
        iv_facet        = me->gv_facet_right
      IMPORTING
        ev_facet_mirror = DATA(lv_facet_bottom).
    CALL METHOD mirror_facet
      EXPORTING
        iv_facet        = me->gv_facet_left
      IMPORTING
        ev_facet_mirror = DATA(lv_facet_top).

    CREATE OBJECT lo_rotated_plate
      EXPORTING
        iv_facet_top    = lv_facet_top
        iv_facet_right  = me->gv_facet_top
        iv_facet_left   = me->gv_facet_bottom
        iv_facet_bottom = lv_facet_bottom.

    eo_rotated_plate = lo_rotated_plate.
  ENDMETHOD.
ENDCLASS.
