class ZCL_ZDROPDOWN_DPC_EXT definition
  public
  inheriting from ZCL_ZDROPDOWN_DPC
  create public .

public section.
protected section.

  methods SFLIGHTSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZDROPDOWN_DPC_EXT IMPLEMENTATION.


  METHOD sflightset_get_entityset.
    SELECT * FROM sflight INTO CORRESPONDING FIELDS OF TABLE et_entityset.
  ENDMETHOD.
ENDCLASS.
