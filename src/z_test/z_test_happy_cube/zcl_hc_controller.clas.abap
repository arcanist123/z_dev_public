CLASS zcl_hc_controller DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS main
      IMPORTING
        iv_side_1_path TYPE string
        iv_side_2_path TYPE string
        iv_side_3_path TYPE string
        iv_side_4_path TYPE string
        iv_side_5_path TYPE string
        iv_side_6_path TYPE string
      RAISING
        zcx_exception.
  PROTECTED SECTION.
  PRIVATE SECTION.


ENDCLASS.



CLASS ZCL_HC_CONTROLLER IMPLEMENTATION.


  METHOD main.
    DATA: lt_plates TYPE zcl_hc_plate_parser=>tt_plates.

    CALL METHOD zcl_hc_plate_parser=>get_plates_manager
      EXPORTING
        iv_side_1_path   = iv_side_1_path
        iv_side_2_path   = iv_side_2_path
        iv_side_3_path   = iv_side_3_path
        iv_side_4_path   = iv_side_4_path
        iv_side_5_path   = iv_side_5_path
        iv_side_6_path   = iv_side_6_path
      IMPORTING
        eo_plate_manager = DATA(lo_plate_manager).
    DATA lo_plate_mer TYPE REF TO zcl_hc_plate_merger.
    CREATE OBJECT lo_plate_mer
      EXPORTING
        io_plate_manager = lo_plate_manager.

    CALL METHOD lo_plate_mer->merge_plates
      IMPORTING
        et_merged_cubes = DATA(lt_merged_cubes).

    LOOP AT lt_merged_cubes ASSIGNING FIELD-SYMBOL(<ls_merged_cube>).
      WRITE: | { <ls_merged_cube>-wall_1-plate_index } { <ls_merged_cube>-wall_1-position } { <ls_merged_cube>-wall_1-is_inverted } |.
      WRITE: | { <ls_merged_cube>-wall_2-plate_index } { <ls_merged_cube>-wall_2-position } { <ls_merged_cube>-wall_2-is_inverted } |.
      WRITE: | { <ls_merged_cube>-wall_3-plate_index } { <ls_merged_cube>-wall_3-position } { <ls_merged_cube>-wall_3-is_inverted } |.
      WRITE: | { <ls_merged_cube>-wall_4-plate_index } { <ls_merged_cube>-wall_4-position } { <ls_merged_cube>-wall_4-is_inverted } |.
      WRITE: | { <ls_merged_cube>-wall_5-plate_index } { <ls_merged_cube>-wall_5-position } { <ls_merged_cube>-wall_5-is_inverted } |.
      WRITE: | { <ls_merged_cube>-wall_6-plate_index } { <ls_merged_cube>-wall_6-position } { <ls_merged_cube>-wall_6-is_inverted } |.
      write /.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
