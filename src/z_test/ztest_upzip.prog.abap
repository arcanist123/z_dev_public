*&———————————————————————*
*& Report  ZTEST_UNZIP
*& AUTHOR: Simone Milesi
*& CREATED ON: 18/02/2016
*&———————————————————————*
*& The report read a zip file from user's PC and unzip it, showing
*& the content into an alv list
*&———————————————————————*

REPORT ztest_unzip.
*&———————————————————————*
*&      Class Application
*&———————————————————————*
*        Text
*———————————————————————-*
CLASS application DEFINITION.
  PUBLIC SECTION.
    TYPES: BEGIN OF ty_file,
             name TYPE string,
             date TYPE d,
             time TYPE t,
             size TYPE i,
           END OF ty_file.
    TYPES: tty_files TYPE TABLE OF ty_file.

    CLASS-METHODS: execute,
      get_file CHANGING VALUE(c_file) TYPE string.
  PRIVATE SECTION.
    CLASS-DATA: t_out  TYPE filetable,
                l_out  TYPE file_table,
                files  TYPE filetable,
                t_file TYPE tty_files,
                cont   TYPE xstring,
                file   TYPE ty_file.
    CLASS-DATA: o_zip TYPE REF TO cl_abap_zip.
    CLASS-METHODS: show_alv,
      fill_out,
      upload_data.
ENDCLASS.
"application

PARAMETERS: p_file TYPE application=>ty_file-name OBLIGATORY.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  application=>get_file( CHANGING c_file = p_file ).

START-OF-SELECTION.
  application=>execute( ).
*&———————————————————————*
*&      Class (Implementation)  Application
*&———————————————————————*
*        Text
*———————————————————————-*
CLASS application IMPLEMENTATION.
  METHOD execute.
    upload_data( ).
    LOOP AT o_zip->files INTO file.
      CLEAR cont.
      o_zip->get( EXPORTING name = file-name
      IMPORTING content = cont ).
      fill_out( ).
    ENDLOOP.
    show_alv( ).
  ENDMETHOD.
  "execute
  METHOD fill_out.
    DATA: olen TYPE i,
          xtab TYPE TABLE OF x255,
          ls   TYPE string.
    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        buffer        = cont
      IMPORTING
        output_length = olen
      TABLES
        binary_tab    = xtab.
    CALL FUNCTION 'SCMS_BINARY_TO_STRING'
      EXPORTING
        input_length = olen
      IMPORTING
        text_buffer  = ls
      TABLES
        binary_tab   = xtab
      EXCEPTIONS
        failed       = 1
        OTHERS       = 2.
    IF sy-subrc <> 0.
      EXIT.
    ENDIF.

    DO.
      IF ls CA cl_abap_char_utilities=>cr_lf.
        SPLIT ls AT cl_abap_char_utilities=>cr_lf INTO l_out
        ls.
        APPEND l_out TO t_out.
      ELSE.
        EXIT.
      ENDIF.
    ENDDO.

    l_out = ls.
    APPEND l_out TO t_out.
  ENDMETHOD.
  "fill_out
  METHOD upload_data.
    DATA:flen  TYPE i,
         xhead TYPE xstring,
         xtab  TYPE TABLE OF x255.
    cl_gui_frontend_services=>gui_upload( EXPORTING filename = p_file
    filetype = 'BIN'
    IMPORTING filelength = flen

    CHANGING data_tab = xtab ).
    CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
      EXPORTING
        input_length = flen
      IMPORTING
        buffer       = xhead
      TABLES
        binary_tab   = xtab
      EXCEPTIONS
        failed       = 1
        OTHERS       = 2.
    IF sy-subrc <> 0 OR xhead IS INITIAL.
      IF o_zip IS NOT INITIAL.
        FREE o_zip.
      ENDIF.
    ENDIF.
    CREATE OBJECT o_zip.
    o_zip->load( xhead ).
  ENDMETHOD.
  "upload_data

  METHOD show_alv.
    DATA: salv      TYPE REF TO cl_salv_table,
          functions TYPE REF TO cl_salv_functions.
    cl_salv_table=>factory( IMPORTING r_salv_table = salv
    CHANGING t_table = t_out  ).
    functions = salv->get_functions( ).
    functions->set_all( abap_true ).
    salv->display( ).

  ENDMETHOD.
  "show_alv
  METHOD get_file.
    DATA: fresult TYPE file_table,
          rc      TYPE i.
    CLEAR files[].
    cl_gui_frontend_services=>file_open_dialog(
    CHANGING file_table = files
    rc        = rc ).
    IF files[] IS NOT INITIAL.
      CLEAR c_file.
      READ TABLE files INTO fresult INDEX 1.
      c_file = fresult.

    ENDIF.
  ENDMETHOD.
  "get_file
ENDCLASS.              "application
