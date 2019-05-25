REPORT zepm_data_generator.

PARAMETERS p_create TYPE abap_bool DEFAULT abap_false AS CHECKBOX.

IF p_create = abap_true.

  NEW zcl_epm_data_generator( )->execute( ).
  WRITE text-001.

ELSE.

  WRITE text-002.

ENDIF.
