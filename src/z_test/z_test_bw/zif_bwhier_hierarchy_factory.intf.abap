INTERFACE zif_bwhier_hierarchy_factory
  PUBLIC .
  METHODS create_new_hierarchy
    RETURNING
      VALUE(ro_hierarchy) TYPE REF TO zif_bwhier_hierarchy.
  METHODS load_bw_hierarchy
    IMPORTING
      iv_name             TYPE string
      iv_iobjnm           TYPE string
      iv_keydate          TYPE string
      iv_version          TYPE string
    RETURNING
      VALUE(ro_hierarhcy) TYPE REF TO zif_bwhier_hierarchy.
  METHODS save_hierarchy_to_bw_hierarchy
    IMPORTING
      iv_name      TYPE string
      iv_iobjnm    TYPE string
      iv_keydate   TYPE string
      iv_version   TYPE string
      io_hierarhcy TYPE REF TO zif_bwhier_hierarchy.
ENDINTERFACE.
