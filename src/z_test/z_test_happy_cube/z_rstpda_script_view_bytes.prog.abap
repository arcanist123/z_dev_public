*<SCRIPT:PERSISTENT>
REPORT  rstpda_script_template.

*<SCRIPT:HEADER>
*<SCRIPTNAME>Z_RSTPDA_SCRIPT_VIEW_BYTES</SCRIPTNAME>
*<SCRIPT_CLASS>LCL_DEBUGGER_SCRIPT</SCRIPT_CLASS>
*<SCRIPT_COMMENT>z_RSTPDA_SCRIPT_view_bytes</SCRIPT_COMMENT>
*<SINGLE_RUN>X</SINGLE_RUN>

*</SCRIPT:HEADER>

*<SCRIPT:PRESETTINGS>

*</SCRIPT:PRESETTINGS>

*<SCRIPT:SCRIPT_CLASS>
*---------------------------------------------------------------------*
*       CLASS lcl_debugger_script DEFINITION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcl_debugger_script DEFINITION INHERITING FROM  cl_tpda_script_class_super  .

  PUBLIC SECTION.
    METHODS: prologue  REDEFINITION,
             init    REDEFINITION,
             script  REDEFINITION,
             end     REDEFINITION.

ENDCLASS.                    "lcl_debugger_script DEFINITION
*---------------------------------------------------------------------*
*       CLASS lcl_debugger_script IMPLEMENTATION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcl_debugger_script IMPLEMENTATION.
  METHOD prologue.
*** generate abap_source (source handler for ABAP)
    super->prologue( ).
  ENDMETHOD.                    "prolog

  METHOD init.
*** insert your initialization code here
  ENDMETHOD.                    "init
  METHOD script.
****************************************************************
*Interface (CLASS = CL_TPDA_SCRIPT_DATA_DESCR / METHOD = GET_SIMPLE_VALUE )
*Importing
*        REFERENCE( P_VAR_NAME ) TYPE TPDA_VAR_NAME
*Returning
*        VALUE( P_VAR_VALUE ) TYPE TPDA_VAR_VALUE
****************************************************************

*TRY.
data lv_value type string.
CALL METHOD CL_TPDA_SCRIPT_DATA_DESCR=>GET_SIMPLE_VALUE
  EXPORTING
    P_VAR_NAME  = '<LS_CUBE_WALL>'
  RECEIVING
    P_VAR_VALUE = lv_value
    .


*** insert your script code here
  me->break( ).

  ENDMETHOD.                    "script
  METHOD end.
*** insert your code which shall be executed at the end of the scripting (before trace is saved)
*** here

  ENDMETHOD.                    "end
ENDCLASS.                    "lcl_debugger_script IMPLEMENTATION
*</SCRIPT:SCRIPT_CLASS>

*</SCRIPT:PERSISTENT>
