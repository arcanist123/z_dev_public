CLASS z1c_entity_types DEFINITION PUBLIC CREATE PRIVATE FINAL.

  PUBLIC SECTION.
    TYPES ty_type TYPE string.
    CLASS-DATA json_to_upd TYPE REF TO z1c_entity_types READ-ONLY.
    CLASS-DATA json_to_excel   TYPE REF TO z1c_entity_types READ-ONLY.

    DATA value TYPE symsgty READ-ONLY.

    CLASS-METHODS class_constructor.
    METHODS constructor IMPORTING value TYPE ty_type.
    CLASS-METHODS get_entity_type
      IMPORTING
        iv_entity_type        TYPE ty_type
      RETURNING
        VALUE(ro_entity_type) TYPE REF TO z1c_entity_types
      RAISING
        zcx_exception.

  PRIVATE SECTION.

ENDCLASS.

CLASS z1c_entity_types IMPLEMENTATION.

  METHOD class_constructor.
    json_to_upd = NEW z1c_entity_types( 'JSON_TO_UPD' ).
    json_to_excel = NEW z1c_entity_types( 'JSON_TO_EXCEL' ).
  ENDMETHOD.

  METHOD constructor.
    me->value = value.
  ENDMETHOD.

  METHOD get_entity_type.


    ro_entity_type = COND #(
        WHEN iv_entity_type = json_to_excel->value THEN json_to_excel
        WHEN iv_entity_type = json_to_upd->value THEN json_to_upd
        ELSE THROW zcx_exception( MESSAGE e888(sabapdemos) WITH 'Illegal value!' ) ).

  ENDMETHOD.

ENDCLASS.
