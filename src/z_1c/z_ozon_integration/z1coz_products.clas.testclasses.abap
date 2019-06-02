*"* use this source file for your ABAP unit test classes
CLASS lcl_test_001 DEFINITION CREATE PRIVATE FOR TESTING DURATION LONG RISK LEVEL HARMLESS.

  PUBLIC SECTION.
    METHODS test_get_products FOR TESTING.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_test_001 IMPLEMENTATION.

  METHOD test_get_products.

    DATA(lo_cut) = NEW z1coz_products( ).
    lo_cut->get_products( ).
  ENDMETHOD.

ENDCLASS.
