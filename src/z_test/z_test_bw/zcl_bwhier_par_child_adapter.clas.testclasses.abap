*"* use this source file for your ABAP unit test classes


class lcl_Test_001 definition for testing
  duration long
  risk level harmless
.
*?﻿<asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0">
*?<asx:values>
*?<TESTCLASS_OPTIONS>
*?<TEST_CLASS>lcl_Test_001
*?</TEST_CLASS>
*?<TEST_MEMBER>f_Cut
*?</TEST_MEMBER>
*?<OBJECT_UNDER_TEST>ZCL_BWHIER_PAR_CHILD_ADAPTER
*?</OBJECT_UNDER_TEST>
*?<OBJECT_IS_LOCAL/>
*?<GENERATE_FIXTURE>X
*?</GENERATE_FIXTURE>
*?<GENERATE_CLASS_FIXTURE>X
*?</GENERATE_CLASS_FIXTURE>
*?<GENERATE_INVOCATION>X
*?</GENERATE_INVOCATION>
*?<GENERATE_ASSERT_EQUAL>X
*?</GENERATE_ASSERT_EQUAL>
*?</TESTCLASS_OPTIONS>
*?</asx:values>
*?</asx:abap>
  private section.
    data:
      f_Cut type ref to zcl_Bwhier_Par_Child_Adapter.  "class under test

    class-methods: class_Setup.
    class-methods: class_Teardown.
    methods: setup.
    methods: teardown.
    methods: get_Hier_From_Parent_Child for testing.
endclass.       "lcl_Test_001


class lcl_Test_001 implementation.

  method class_Setup.



  endmethod.


  method class_Teardown.



  endmethod.


  method setup.


    create object f_Cut.
  endmethod.


  method teardown.



  endmethod.


  method get_Hier_From_Parent_Child.

    data it_Hier_Parent_Child type zcl_Bwhier_Par_Child_Adapter=>tt_Parent_Child_Hier.
    data ro_Hierarhy type ref to zif_Bwhier_Hierarchy.

    ro_Hierarhy = f_Cut->get_Hier_From_Parent_Child( it_Hier_Parent_Child ).

    cl_Abap_Unit_Assert=>assert_Equals(
      act   = ro_Hierarhy
      exp   = ro_Hierarhy          "<--- please adapt expected value
    " msg   = 'Testing value ro_Hierarhy'
*     level =
    ).
  endmethod.




endclass.
