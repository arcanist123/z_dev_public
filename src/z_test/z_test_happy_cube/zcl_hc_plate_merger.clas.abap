CLASS zcl_hc_plate_merger DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
      BEGIN OF t_cube_wall,
        plate_index  TYPE zcl_hc_plate_manager=>typ_plate_index,
        is_inverted  TYPE abap_bool,
        position     TYPE zcl_hc_plate_manager=>typ_position,
        plate        TYPE REF TO zcl_hc_plate,
        facet_top    TYPE zcl_hc_plate=>typ_facet,
        facet_bottom TYPE zcl_hc_plate=>typ_facet,
        facet_right  TYPE zcl_hc_plate=>typ_facet,
        facet_left   TYPE zcl_hc_plate=>typ_facet,
      END OF t_cube_wall .

    TYPES:
      BEGIN OF  t_cube,
        wall_1_plate_index TYPE zcl_hc_plate_manager=>typ_plate_index,
        wall_2_plate_index TYPE zcl_hc_plate_manager=>typ_plate_index,
        wall_3_plate_index TYPE zcl_hc_plate_manager=>typ_plate_index,
        wall_4_plate_index TYPE zcl_hc_plate_manager=>typ_plate_index,
        wall_5_plate_index TYPE zcl_hc_plate_manager=>typ_plate_index,
        wall_6_plate_index TYPE zcl_hc_plate_manager=>typ_plate_index,
        wall_1             TYPE t_cube_wall,
        wall_2             TYPE t_cube_wall,
        wall_3             TYPE t_cube_wall,
        wall_4             TYPE t_cube_wall,
        wall_5             TYPE t_cube_wall,
        wall_6             TYPE t_cube_wall,
      END OF t_cube .
    TYPES:
    tt_cube TYPE STANDARD TABLE OF t_cube WITH DEFAULT KEY .

    METHODS constructor
      IMPORTING
        io_plate_manager TYPE REF TO zcl_hc_plate_manager .
    METHODS merge_plates
      EXPORTING
        et_merged_cubes TYPE tt_cube.
  PROTECTED SECTION.
  PRIVATE SECTION.




    CONSTANTS gc_merged_line_full TYPE zcl_hc_plate=>typ_facet VALUE 'F8' ##NO_TEXT."11111
    CONSTANTS gc_merged_line_left_empt TYPE zcl_hc_plate=>typ_facet VALUE '78' ##NO_TEXT."01111
    CONSTANTS gc_merged_line_right_empt TYPE zcl_hc_plate=>typ_facet VALUE 'F0' ##NO_TEXT."11110
    CONSTANTS gc_merged_line_left_right_empt TYPE zcl_hc_plate=>typ_facet VALUE '70' ##NO_TEXT."01110

    DATA _go_plate_manager TYPE REF TO zcl_hc_plate_manager .
    DATA gt_plates TYPE zcl_hc_plate_parser=>tt_plates.
    METHODS construct_fifth_wall
      IMPORTING
        !io_plate_manager TYPE REF TO zcl_hc_plate_manager
      CHANGING
        !ct_cube          TYPE zcl_hc_plate_merger=>tt_cube .
    METHODS construct_first_wall
      IMPORTING
        !it_plates TYPE zcl_hc_plate_manager=>tt_plates
      CHANGING
        !ct_cube   TYPE zcl_hc_plate_merger=>tt_cube .
    METHODS construct_forth_wall
      IMPORTING
        !io_plate_manager TYPE REF TO zcl_hc_plate_manager
      CHANGING
        !ct_cube          TYPE zcl_hc_plate_merger=>tt_cube .
    METHODS construct_second_wall
      IMPORTING
        !io_plate_manager TYPE REF TO zcl_hc_plate_manager
      CHANGING
        !ct_cube          TYPE zcl_hc_plate_merger=>tt_cube .
    METHODS construct_six_wall
      IMPORTING
        !io_plate_manager TYPE REF TO zcl_hc_plate_manager
      CHANGING
        !ct_cube          TYPE zcl_hc_plate_merger=>tt_cube .
    METHODS construct_third_wall
      IMPORTING
        !io_plate_manager TYPE REF TO zcl_hc_plate_manager
      CHANGING
        !ct_cube          TYPE zcl_hc_plate_merger=>tt_cube .
    METHODS get_outstanding_plates
      IMPORTING
        !is_cube          TYPE zcl_hc_plate_merger=>t_cube
        !io_plate_manager TYPE REF TO zcl_hc_plate_manager
      EXPORTING
        !et_plates        TYPE zcl_hc_plate_manager=>tt_plates .
    METHODS merge_fifth_wall
      IMPORTING
        !is_cube   TYPE zcl_hc_plate_merger=>t_cube
        !it_plates TYPE zcl_hc_plate_manager=>tt_plates
      EXPORTING
        !et_cube   TYPE zcl_hc_plate_merger=>tt_cube .
    METHODS merge_forth_wall
      IMPORTING
        !is_cube   TYPE zcl_hc_plate_merger=>t_cube
        !it_plates TYPE zcl_hc_plate_manager=>tt_plates
      EXPORTING
        !et_cube   TYPE zcl_hc_plate_merger=>tt_cube .
    METHODS merge_second_wall
      IMPORTING
        !is_cube   TYPE zcl_hc_plate_merger=>t_cube
        !it_plates TYPE zcl_hc_plate_manager=>tt_plates
      EXPORTING
        !et_cube   TYPE zcl_hc_plate_merger=>tt_cube .
    METHODS merge_six_wall
      IMPORTING
        !is_cube   TYPE zcl_hc_plate_merger=>t_cube
        !it_plates TYPE zcl_hc_plate_manager=>tt_plates
      EXPORTING
        !et_cube   TYPE zcl_hc_plate_merger=>tt_cube .
    METHODS merge_third_wall
      IMPORTING
        !is_cube   TYPE zcl_hc_plate_merger=>t_cube
        !it_plates TYPE zcl_hc_plate_manager=>tt_plates
      EXPORTING
        !et_cube   TYPE zcl_hc_plate_merger=>tt_cube .
    METHODS merge_wall
      IMPORTING
        iv_merged_line TYPE zcl_hc_plate=>typ_facet
        iv_position    TYPE zcl_hc_plate=>typ_position
      CHANGING
        cs_wall        TYPE zcl_hc_plate_merger=>t_cube_wall .
    METHODS merge_two_facets
      IMPORTING
        iv_facet_1      TYPE zcl_hc_plate=>typ_facet
        iv_facet_2      TYPE zcl_hc_plate=>typ_facet
      EXPORTING
        ev_merged_facet TYPE zcl_hc_plate_manager=>typ_facet.
ENDCLASS.



CLASS ZCL_HC_PLATE_MERGER IMPLEMENTATION.


  METHOD constructor.
    me->_go_plate_manager = io_plate_manager.

  ENDMETHOD.


  METHOD construct_fifth_wall.
    DATA: lt_plates   TYPE zcl_hc_plate_manager=>tt_plates,
          lt_cube_tmp TYPE zcl_hc_plate_merger=>tt_cube,
          lt_cube     TYPE zcl_hc_plate_merger=>tt_cube.
    SORT ct_cube BY wall_1_plate_index wall_2_plate_index wall_3_plate_index wall_4_plate_index .
    LOOP AT ct_cube ASSIGNING FIELD-SYMBOL(<ls_cube>).
      AT NEW wall_4_plate_index.

        CALL METHOD get_outstanding_plates
          EXPORTING
            is_cube          = <ls_cube>
            io_plate_manager = io_plate_manager
          IMPORTING
            et_plates        = lt_plates.
      ENDAT.

      CALL METHOD merge_fifth_wall
        EXPORTING
          is_cube   = <ls_cube>
          it_plates = lt_plates
        IMPORTING
          et_cube   = lt_cube_tmp.
      APPEND LINES OF lt_cube_tmp TO lt_cube.

    ENDLOOP.
    ct_cube = lt_cube.
  ENDMETHOD.


  METHOD construct_first_wall.
    DATA ls_cube_wall LIKE LINE OF ct_cube.
    LOOP AT it_plates ASSIGNING FIELD-SYMBOL(<ls_plate>) WHERE position = zcl_hc_plate=>position-top.
      MOVE-CORRESPONDING <ls_plate> TO ls_cube_wall-wall_1.
      ls_cube_wall-wall_1_plate_index = <ls_plate>-plate_index.
      ls_cube_wall-wall_1-facet_bottom = <ls_plate>-plate->gv_facet_bottom.
      ls_cube_wall-wall_1-facet_left = <ls_plate>-plate->gv_facet_left.
      ls_cube_wall-wall_1-facet_right = <ls_plate>-plate->gv_facet_right.
      ls_cube_wall-wall_1-facet_top = <ls_plate>-plate->gv_facet_top.

      APPEND ls_cube_wall TO ct_cube.

    ENDLOOP.
  ENDMETHOD.


  METHOD construct_forth_wall.
    DATA lv_counter TYPE zcl_hc_plate_manager=>typ_plate_index VALUE 1.
    DATA lt_plates_temp TYPE zcl_hc_plate_manager=>tt_plates.
    DATA lt_plates TYPE zcl_hc_plate_manager=>tt_plates.
    DATA lt_cube_tmp TYPE zcl_hc_plate_merger=>tt_cube.
    DATA lt_cube LIKE ct_cube.
    SORT ct_cube BY wall_1_plate_index wall_2_plate_index wall_3_plate_index.
    LOOP AT ct_cube ASSIGNING FIELD-SYMBOL(<ls_cube>).
      AT NEW wall_3_plate_index.

        CALL METHOD get_outstanding_plates
          EXPORTING
            is_cube          = <ls_cube>
            io_plate_manager = io_plate_manager
          IMPORTING
            et_plates        = lt_plates.
      ENDAT.
      CALL METHOD merge_forth_wall
        EXPORTING
          is_cube   = <ls_cube>
          it_plates = lt_plates
        IMPORTING
          et_cube   = lt_cube_tmp.
      APPEND LINES OF lt_cube_tmp TO lt_cube.
    ENDLOOP.

    "return the results of processing
    ct_cube = lt_cube.
  ENDMETHOD.


  METHOD construct_second_wall.
    "get the combinations for the plate that is not part of the wall - meaning 2-6
    SORT ct_cube BY wall_1_plate_index.
    DATA lt_cube LIKE ct_cube.
    LOOP AT ct_cube ASSIGNING FIELD-SYMBOL(<ls_cube>).
      AT NEW  wall_1_plate_index.
        CALL METHOD get_outstanding_plates
          EXPORTING
            is_cube          = <ls_cube>
            io_plate_manager = io_plate_manager
          IMPORTING
            et_plates        = DATA(lt_plates).
      ENDAT.

      "we have all the possible plates

      DATA lt_cube_tmp LIKE ct_cube.
      CALL METHOD merge_second_wall
        EXPORTING
          is_cube   = <ls_cube>
          it_plates = lt_plates
        IMPORTING
          et_cube   = lt_cube_tmp.
      APPEND LINES OF lt_cube_tmp TO lt_cube.
    ENDLOOP.

    ct_cube = lt_cube.
  ENDMETHOD.


  METHOD construct_six_wall.
    DATA: lt_plates   TYPE zcl_hc_plate_manager=>tt_plates,
          lt_cube_tmp TYPE zcl_hc_plate_merger=>tt_cube,
          lt_cube     TYPE zcl_hc_plate_merger=>tt_cube.
    SORT ct_cube BY wall_1_plate_index wall_2_plate_index wall_3_plate_index wall_4_plate_index wall_5_plate_index .
    LOOP AT ct_cube ASSIGNING FIELD-SYMBOL(<ls_cube>).
      AT NEW wall_5_plate_index.

        CALL METHOD get_outstanding_plates
          EXPORTING
            is_cube          = <ls_cube>
            io_plate_manager = io_plate_manager
          IMPORTING
            et_plates        = lt_plates.
      ENDAT.
      CALL METHOD merge_six_wall
        EXPORTING
          is_cube   = <ls_cube>
          it_plates = lt_plates
        IMPORTING
          et_cube   = lt_cube_tmp.
      APPEND LINES OF lt_cube_tmp TO lt_cube.

    ENDLOOP.
    ct_cube = lt_cube.
  ENDMETHOD.


  METHOD construct_third_wall.

    DATA lt_plates_temp TYPE zcl_hc_plate_manager=>tt_plates.
    DATA lt_plates TYPE zcl_hc_plate_manager=>tt_plates.
    DATA: lt_cube_tmp TYPE zcl_hc_plate_merger=>tt_cube.
    DATA lt_cube LIKE ct_cube.
    SORT ct_cube BY wall_1_plate_index wall_2_plate_index .
    LOOP AT ct_cube ASSIGNING FIELD-SYMBOL(<ls_cube>).

      AT NEW wall_2_plate_index.
        CALL METHOD get_outstanding_plates
          EXPORTING
            is_cube          = <ls_cube>
            io_plate_manager = io_plate_manager
          IMPORTING
            et_plates        = lt_plates.

      ENDAT.

      CALL METHOD merge_third_wall
        EXPORTING
          is_cube   = <ls_cube>
          it_plates = lt_plates
        IMPORTING
          et_cube   = lt_cube_tmp.
      APPEND LINES OF lt_cube_tmp TO lt_cube.


    ENDLOOP.
    ct_cube = lt_cube.
  ENDMETHOD.


  METHOD get_outstanding_plates.
    DATA lt_plates LIKE et_plates.
    DATA lt_plates_tmp LIKE et_plates.
    DATA lv_counter TYPE zcl_hc_plate_manager=>typ_plate_index VALUE 1.
    WHILE lv_counter <= 6.
      IF lv_counter = is_cube-wall_1_plate_index OR
        lv_counter = is_cube-wall_2_plate_index OR
        lv_counter = is_cube-wall_3_plate_index OR
        lv_counter = is_cube-wall_4_plate_index OR
        lv_counter = is_cube-wall_5_plate_index OR
        lv_counter = is_cube-wall_6_plate_index.
      ELSE.
        CALL METHOD io_plate_manager->get_plates_by_index
          EXPORTING
            iv_plate_index = lv_counter
          IMPORTING
            et_plates      = lt_plates_tmp.
        APPEND LINES OF lt_plates_tmp TO lt_plates.
      ENDIF.

      lv_counter = lv_counter  + 1 .
    ENDWHILE.

    et_plates = lt_plates.

  ENDMETHOD.


  METHOD merge_fifth_wall.
    DATA ls_cube LIKE is_cube.
    ls_cube = is_cube.
    DATA lv_merge_1_5 TYPE zcl_hc_plate_manager=>typ_facet.
    DATA lv_merge_3_5 TYPE zcl_hc_plate_manager=>typ_facet.
    DATA lv_merge_4_5 TYPE zcl_hc_plate_manager=>typ_facet.
    DATA lt_cubes LIKE et_cube.


    LOOP AT it_plates ASSIGNING FIELD-SYMBOL(<ls_plate>).
      "check if we can insert the current plate into the third place
      CALL METHOD me->merge_two_facets
        EXPORTING
          iv_facet_1      = ls_cube-wall_1-facet_top
          iv_facet_2      = <ls_plate>-facet_bottom
        IMPORTING
          ev_merged_facet = lv_merge_1_5.
      CALL METHOD me->merge_two_facets
        EXPORTING
          iv_facet_1      = ls_cube-wall_3-facet_top
          iv_facet_2      = <ls_plate>-facet_right_inverted
        IMPORTING
          ev_merged_facet = lv_merge_3_5.
      CALL METHOD me->merge_two_facets
        EXPORTING
          iv_facet_1      = ls_cube-wall_4-facet_top
          iv_facet_2      = <ls_plate>-facet_left
        IMPORTING
          ev_merged_facet = lv_merge_4_5.

      GET BIT 1 OF lv_merge_1_5 INTO DATA(lv_control_1_left).
      GET BIT 5 OF lv_merge_1_5 INTO DATA(lv_control_1_right).
      GET BIT 1 OF lv_merge_3_5 INTO DATA(lv_conrol_3_left).
      GET BIT 5 OF lv_merge_4_5 INTO DATA(lv_conrol_4_right).


      IF lv_merge_1_5 <> '00'
      AND lv_merge_3_5 <> '00'
      AND lv_merge_4_5 <> '00'
      AND ( lv_control_1_left = 1 OR lv_conrol_4_right = 1 )
      AND ( lv_control_1_right = 1 OR lv_conrol_3_left = 1 ).

        MOVE-CORRESPONDING <ls_plate> TO ls_cube-wall_5.
        ls_cube-wall_5_plate_index = <ls_plate>-plate_index.
        CALL METHOD merge_wall
          EXPORTING
            iv_merged_line = lv_merge_1_5
            iv_position    = zcl_hc_plate=>position-top
          CHANGING
            cs_wall        = ls_cube-wall_1.
        CALL METHOD merge_wall
          EXPORTING
            iv_merged_line = lv_merge_1_5
            iv_position    = zcl_hc_plate=>position-bottom
          CHANGING
            cs_wall        = ls_cube-wall_5.

        CALL METHOD merge_wall
          EXPORTING
            iv_merged_line = lv_merge_3_5
            iv_position    = zcl_hc_plate=>position-top
          CHANGING
            cs_wall        = ls_cube-wall_3.
        CALL METHOD zcl_hc_plate=>mirror_facet
          EXPORTING
            iv_facet        = lv_merge_3_5
          IMPORTING
            ev_facet_mirror = DATA(lv_merge_3_5_mirror).
        CALL METHOD merge_wall
          EXPORTING
            iv_merged_line = lv_merge_3_5_mirror
            iv_position    = zcl_hc_plate=>position-right
          CHANGING
            cs_wall        = ls_cube-wall_5.

        CALL METHOD merge_wall
          EXPORTING
            iv_merged_line = lv_merge_4_5
            iv_position    = zcl_hc_plate=>position-top
          CHANGING
            cs_wall        = ls_cube-wall_4.
        CALL METHOD merge_wall
          EXPORTING
            iv_merged_line = lv_merge_4_5
            iv_position    = zcl_hc_plate=>position-left
          CHANGING
            cs_wall        = ls_cube-wall_5.
        APPEND ls_cube TO lt_cubes.
        "ensure that subsequent checks will work with the fresh copy of the cube
        ls_cube = is_cube.
      ENDIF.

    ENDLOOP.

    et_cube = lt_cubes.
  ENDMETHOD.


  METHOD merge_forth_wall.
    DATA ls_cube LIKE is_cube.
    ls_cube = is_cube.
    DATA lv_merge_line_1 TYPE zcl_hc_plate_manager=>typ_facet.
    DATA lv_merge_line_2 TYPE zcl_hc_plate_manager=>typ_facet.
    DATA lt_cubes LIKE et_cube.


    LOOP AT it_plates ASSIGNING FIELD-SYMBOL(<ls_plate>).
      "check if we can insert the current plate into the third place
      CALL METHOD me->merge_two_facets
        EXPORTING
          iv_facet_1      = ls_cube-wall_1-facet_left
          iv_facet_2      = <ls_plate>-facet_right
        IMPORTING
          ev_merged_facet = lv_merge_line_1.

      CALL METHOD me->merge_two_facets
        EXPORTING
          iv_facet_1      = ls_cube-wall_2-facet_left
          iv_facet_2      = <ls_plate>-facet_bottom_inverted
        IMPORTING
          ev_merged_facet = lv_merge_line_2.

      GET BIT 5 OF lv_merge_line_1 INTO DATA(lv_bit_1).
      GET BIT 1 OF lv_merge_line_2 INTO DATA(lv_bit_2).
      IF ( lv_merge_line_1 <> '00' )
      AND ( lv_merge_line_2 <> '00' )
      AND ( lv_bit_1 = 1 OR lv_bit_2 = 1 ).
        "this element can be inserted. insert in into the cube
        MOVE-CORRESPONDING <ls_plate> TO ls_cube-wall_4.
        ls_cube-wall_4_plate_index = <ls_plate>-plate_index.
        CALL METHOD merge_wall
          EXPORTING
            iv_merged_line = lv_merge_line_1
            iv_position    = zcl_hc_plate=>position-left
          CHANGING
            cs_wall        = ls_cube-wall_1.
        CALL METHOD merge_wall
          EXPORTING
            iv_merged_line = lv_merge_line_1
            iv_position    = zcl_hc_plate=>position-right
          CHANGING
            cs_wall        = ls_cube-wall_4.

        CALL METHOD zcl_hc_plate=>mirror_facet
          EXPORTING
            iv_facet        = lv_merge_line_2
          IMPORTING
            ev_facet_mirror = DATA(lv_merge_line_mirror).
        CALL METHOD merge_wall
          EXPORTING
            iv_merged_line = lv_merge_line_mirror
            iv_position    = zcl_hc_plate=>position-bottom
          CHANGING
            cs_wall        = ls_cube-wall_4.

        CALL METHOD merge_wall
          EXPORTING
            iv_merged_line = lv_merge_line_2
            iv_position    = zcl_hc_plate=>position-left
          CHANGING
            cs_wall        = ls_cube-wall_2.
        APPEND ls_cube TO lt_cubes.
        "ensure that subsequent checks will work with the fresh copy of the cube
        ls_cube = is_cube.
      ENDIF.

    ENDLOOP.

    et_cube = lt_cubes.
  ENDMETHOD.


  METHOD merge_plates.

    "get possible elements of 1 plate
    CALL METHOD _go_plate_manager->get_plates_by_index
      EXPORTING
        iv_plate_index = 1
      IMPORTING
        et_plates      = DATA(lt_plates).
    DATA lt_cube TYPE tt_cube.
    "first step - put the first element as a first wall
    CALL METHOD construct_first_wall
      EXPORTING
        it_plates = lt_plates
      CHANGING
        ct_cube   = lt_cube.

    "second step - attempt to attach an element to the second wall
    CALL METHOD construct_second_wall
      EXPORTING
        io_plate_manager = _go_plate_manager
      CHANGING
        ct_cube          = lt_cube.

    "third step - attempt to attach the third wall
    CALL METHOD construct_third_wall
      EXPORTING
        io_plate_manager = _go_plate_manager
      CHANGING
        ct_cube          = lt_cube.

    "forth step - attempt to attach the forth wall
    CALL METHOD construct_forth_wall
      EXPORTING
        io_plate_manager = _go_plate_manager
      CHANGING
        ct_cube          = lt_cube.

    "fifth step -
    CALL METHOD construct_fifth_wall
      EXPORTING
        io_plate_manager = _go_plate_manager
      CHANGING
        ct_cube          = lt_cube.

    "six step
    CALL METHOD construct_six_wall
      EXPORTING
        io_plate_manager = _go_plate_manager
      CHANGING
        ct_cube          = lt_cube.

    "return the results of processing
    et_merged_cubes = lt_cube.

  ENDMETHOD.


  METHOD merge_second_wall.

    DATA lv_merge_line TYPE  zcl_hc_plate=>typ_facet.
    DATA ls_cube LIKE is_cube.
    DATA lt_cube LIKE et_cube.

    ls_cube = is_cube.
    LOOP AT it_plates ASSIGNING FIELD-SYMBOL(<ls_plate>).
      "check if the current plate can be inserted into the wall
      lv_merge_line = ls_cube-wall_1-facet_bottom BIT-XOR <ls_plate>-plate->gv_facet_top.
      CALL METHOD me->merge_two_facets
        EXPORTING
          iv_facet_1      = ls_cube-wall_1-facet_bottom
          iv_facet_2      = <ls_plate>-facet_top
        IMPORTING
          ev_merged_facet = lv_merge_line.


      IF lv_merge_line <> '00'.
        "current combination is ok. merge bottom of first element with top of the second
        MOVE-CORRESPONDING <ls_plate> TO ls_cube-wall_2.
        ls_cube-wall_2_plate_index = <ls_plate>-plate_index.

        CALL METHOD me->merge_wall
          EXPORTING
            iv_merged_line = lv_merge_line
            iv_position    = zcl_hc_plate=>position-bottom
          CHANGING
            cs_wall        = ls_cube-wall_1.
        CALL METHOD me->merge_wall
          EXPORTING
            iv_merged_line = lv_merge_line
            iv_position    = zcl_hc_plate=>position-top
          CHANGING
            cs_wall        = ls_cube-wall_2.

        APPEND ls_cube TO lt_cube.
        "ensure that subsequent checks will work with the fresh copy of the cube
        ls_cube = is_cube.
      ELSE.


      ENDIF.
    ENDLOOP.

    et_cube = lt_cube.
  ENDMETHOD.


  METHOD merge_six_wall.


    DATA ls_cube LIKE is_cube.
    ls_cube = is_cube.
    DATA lv_merge_2_6 TYPE zcl_hc_plate_manager=>typ_facet.
    DATA lv_merge_5_6 TYPE zcl_hc_plate_manager=>typ_facet.
    DATA lv_merge_3_6 TYPE zcl_hc_plate_manager=>typ_facet.
    DATA lv_merge_4_6 TYPE zcl_hc_plate_manager=>typ_facet.

    DATA lt_cubes LIKE et_cube.


    LOOP AT it_plates ASSIGNING FIELD-SYMBOL(<ls_plate>).
      CALL METHOD me->merge_two_facets
        EXPORTING
          iv_facet_1      = ls_cube-wall_2-facet_bottom
          iv_facet_2      = <ls_plate>-facet_top
        IMPORTING
          ev_merged_facet = lv_merge_2_6.

      CALL METHOD me->merge_two_facets
        EXPORTING
          iv_facet_1      = ls_cube-wall_5-facet_top
          iv_facet_2      = <ls_plate>-facet_bottom
        IMPORTING
          ev_merged_facet = lv_merge_5_6.

      CALL METHOD me->merge_two_facets
        EXPORTING
          iv_facet_1      = ls_cube-wall_3-facet_right
          iv_facet_2      = <ls_plate>-facet_right_inverted
        IMPORTING
          ev_merged_facet = lv_merge_3_6.

      CALL METHOD me->merge_two_facets
        EXPORTING
          iv_facet_1      = ls_cube-wall_4-facet_left
          iv_facet_2      = <ls_plate>-facet_left_inverted
        IMPORTING
          ev_merged_facet = lv_merge_4_6.


      "check if we can insert the current plate into the third place
      GET BIT 1 OF lv_merge_2_6 INTO DATA(lv_bit_2_6_left).
      GET BIT 5 OF lv_merge_2_6 INTO DATA(lv_bit_2_6_right).
      GET BIT 1 OF lv_merge_3_6 INTO DATA(lv_bit_3_6_top).
      GET BIT 5 OF lv_merge_3_6 INTO DATA(lv_bit_3_6_bottom).
      GET BIT 1 OF lv_merge_4_6 INTO DATA(lv_bit_4_6_top).
      GET BIT 5 OF lv_merge_4_6 INTO DATA(lv_bit_4_6_bottom).
      GET BIT 1 OF lv_merge_5_6 INTO DATA(lv_bit_5_6_left).
      GET BIT 5 OF lv_merge_5_6 INTO DATA(lv_bit_5_6_right).
      IF lv_merge_2_6 <> '00'
        AND lv_merge_5_6 <> '00'
        AND lv_merge_3_6 <> '00'
        AND lv_merge_4_6 <> '00'
        AND ( lv_bit_2_6_right = 1 OR lv_bit_3_6_bottom = 1 )
        AND ( lv_bit_5_6_right = 1 OR lv_bit_3_6_top = 1 )
        AND ( lv_bit_2_6_left = 1 OR lv_bit_4_6_bottom = 1 )
        AND ( lv_bit_5_6_left = 1 OR lv_bit_4_6_top = 1 ).

        "this element can be inserted. insert in into the cube
        MOVE-CORRESPONDING <ls_plate> TO ls_cube-wall_6.
        ls_cube-wall_6_plate_index = <ls_plate>-plate_index.
        "since this is the last step - we dont need to actually merge the facets
        APPEND ls_cube TO lt_cubes.
        "ensure that subsequent checks will work with the fresh copy of the cube
        ls_cube = is_cube.
      ENDIF.

    ENDLOOP.

    et_cube = lt_cubes.

  ENDMETHOD.


  METHOD merge_third_wall.
    DATA ls_cube LIKE is_cube.
    ls_cube = is_cube.
    DATA lv_merge_line_1 TYPE zcl_hc_plate_manager=>typ_facet.
    DATA lv_merge_line_2 TYPE zcl_hc_plate_manager=>typ_facet.
    DATA lt_cubes LIKE et_cube.


    LOOP AT it_plates ASSIGNING FIELD-SYMBOL(<ls_plate>).
      CALL METHOD me->merge_two_facets
        EXPORTING
          iv_facet_1      = ls_cube-wall_1-facet_right
          iv_facet_2      = <ls_plate>-facet_left
        IMPORTING
          ev_merged_facet = lv_merge_line_1.
      CALL METHOD me->merge_two_facets
        EXPORTING
          iv_facet_1      = ls_cube-wall_2-facet_right
          iv_facet_2      = <ls_plate>-facet_bottom
        IMPORTING
          ev_merged_facet = lv_merge_line_2.

      "check if we can insert the current plate into the third place
      GET BIT 5 OF lv_merge_line_1 INTO DATA(lv_bit_line_1).
      GET BIT 1 OF lv_merge_line_2 INTO DATA(lv_bit_line_2).
      IF ( lv_merge_line_1 <> '00' )
      AND ( lv_merge_line_2 <> '00')
      AND ( lv_bit_line_1 = 1 OR lv_bit_line_2 = 1 ).
        "this element can be inserted. insert in into the cube
        MOVE-CORRESPONDING <ls_plate> TO ls_cube-wall_3.
        ls_cube-wall_3_plate_index = <ls_plate>-plate_index.

        CALL METHOD merge_wall
          EXPORTING
            iv_merged_line = lv_merge_line_1
            iv_position    = zcl_hc_plate=>position-right
          CHANGING
            cs_wall        = ls_cube-wall_1.
        CALL METHOD merge_wall
          EXPORTING
            iv_merged_line = lv_merge_line_1
            iv_position    = zcl_hc_plate=>position-left
          CHANGING
            cs_wall        = ls_cube-wall_3.

        CALL METHOD merge_wall
          EXPORTING
            iv_merged_line = lv_merge_line_2
            iv_position    = zcl_hc_plate=>position-right
          CHANGING
            cs_wall        = ls_cube-wall_2.
        CALL METHOD merge_wall
          EXPORTING
            iv_merged_line = lv_merge_line_2
            iv_position    = zcl_hc_plate=>position-bottom
          CHANGING
            cs_wall        = ls_cube-wall_3.

        APPEND ls_cube TO lt_cubes.
        "ensure that subsequent checks will work with the fresh copy of the cube
        ls_cube = is_cube.
      ENDIF.

    ENDLOOP.

    et_cube = lt_cubes.
  ENDMETHOD.


  METHOD merge_two_facets.
    DATA lv_merged_facet LIKE ev_merged_facet.
    "check if the facets can be merged
    "get all the places that are the same between 2 facets
    DATA(lv_merge_check) = iv_facet_1 BIT-AND iv_facet_2.

    IF lv_merge_check = '00'.
      "this is a valid case - we can merge this two facets since the facets can be inserted into each other
      DATA(lv_merge_result) = iv_facet_1 BIT-XOR iv_facet_2.
      "ensure that the middle part is populated
      DATA lv_middle_check LIKE iv_facet_1 VALUE '70'."01110
      DATA(lv_middle_check_result) = lv_merge_result BIT-AND lv_middle_check.

      IF lv_middle_check_result = lv_middle_check.
        "the merged facet has the values in the middle
        lv_merged_facet = lv_merge_result.
      ENDIF.
    ENDIF.

    "return the results of processing
    ev_merged_facet = lv_merged_facet.
  ENDMETHOD.


  METHOD merge_wall.
    DATA: lv_bit TYPE i.

    "adjust first element
    CASE iv_position.
      WHEN zcl_hc_plate=>position-top.
        GET BIT 1 OF iv_merged_line INTO lv_bit.
        SET BIT 1 OF cs_wall-facet_left TO lv_bit.
        cs_wall-facet_top = iv_merged_line.
        GET BIT 5 OF iv_merged_line INTO lv_bit.
        SET BIT 1 OF cs_wall-facet_right TO lv_bit.

      WHEN zcl_hc_plate=>position-right.
        GET BIT 1 OF iv_merged_line INTO lv_bit.
        SET BIT 5 OF cs_wall-facet_top TO lv_bit.
        cs_wall-facet_right = iv_merged_line.
        GET BIT 5 OF iv_merged_line INTO lv_bit.
        SET BIT 5 OF cs_wall-facet_bottom TO lv_bit.

      WHEN zcl_hc_plate=>position-bottom.
        GET BIT 1 OF iv_merged_line INTO lv_bit.
        SET BIT 5 OF cs_wall-facet_left TO lv_bit.
        cs_wall-facet_bottom = me->gc_merged_line_full.
        GET BIT 5 OF iv_merged_line INTO lv_bit.
        SET BIT 5 OF cs_wall-facet_right TO lv_bit.

      WHEN zcl_hc_plate=>position-left.
        GET BIT 1 OF iv_merged_line INTO lv_bit.
        SET BIT 1 OF cs_wall-facet_top TO lv_bit.
        cs_wall-facet_left = me->gc_merged_line_full.
        GET BIT 5 OF iv_merged_line INTO lv_bit.
        SET BIT 1 OF cs_wall-facet_bottom TO lv_bit.

    ENDCASE.
  ENDMETHOD.
ENDCLASS.
