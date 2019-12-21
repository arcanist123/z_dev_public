CLASS z_test_fpm_006_search DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES  if_fpm_guibb_search.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z_test_fpm_006_search IMPLEMENTATION.
  METHOD if_fpm_guibb_search~check_config.

  ENDMETHOD.

  METHOD if_fpm_guibb_search~flush.

  ENDMETHOD.

  METHOD if_fpm_guibb_search~get_data.

  ENDMETHOD.

  METHOD if_fpm_guibb_search~get_default_config.

  ENDMETHOD.

  METHOD if_fpm_guibb_search~get_definition.

    eo_field_catalog_attr ?= cl_abap_structdescr=>describe_by_name( 'SFLIGHT' ).

  ENDMETHOD.

  METHOD if_fpm_guibb~get_parameter_list.

  ENDMETHOD.

  METHOD if_fpm_guibb~initialize.

  ENDMETHOD.

  METHOD if_fpm_guibb_search~process_event.

  ENDMETHOD.

ENDCLASS.
