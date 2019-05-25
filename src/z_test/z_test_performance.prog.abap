
*&---------------------------------------------------------------------*
*& Report  ZSIMPLE_BENCHMARK
*& Author: Sergio Ferrari
*&         ERPTech SpA
*& Version: 1.1  - 2006/01/19
*& - RDBMS - update SFLIGHT instead of INDX in order to compare to Java
*& Version: 1.0  - 2006/01/18
*& Title   Simple ABAP Benchmark
*&---------------------------------------------------------------------*
*& This is a simple ABAP utility that perform different kinds of
*& stress test against an SAP ABAP instance in order to allow
*& basic comparision between different installations/platforms
*&---------------------------------------------------------------------*
*& What about my system?:
*&  SFLIGHT is update for carrid = 'ZSF' AND connid BETWEEN 1 AND 100.
*&---------------------------------------------------------------------*
*& Supported releases:
*&  from R4.5B
*&---------------------------------------------------------------------*
*& Notes:
*&  process is serialized and multiple CPUs or multiple application
*&  servers are not fully used...
*&---------------------------------------------------------------------*
*& Texts:
*&  title     - Simple ABAP Benchmark
*&  Text symbols
*&    TIM - Time
*&    TST - Units
*&  Selection texts
*&    CPU - Execute CPU test
*&    DB  - Execute RDBMS test
*&    FSY - Execute File System test
*&    RAM - Execute RAM test
*&    TIME_SS -Runtime per UNIT


*&---------------------------------------------------------------------*
REPORT  z_test_performance..
TABLES: sflight.
TYPES: timeio_ss(2) TYPE n.
SELECTION-SCREEN BEGIN OF BLOCK tim WITH FRAME TITLE TEXT-tim.
PARAMETERS: time_ss TYPE timeio_ss DEFAULT '30'.
SELECTION-SCREEN END OF BLOCK tim.
SELECTION-SCREEN BEGIN OF BLOCK tst WITH FRAME TITLE TEXT-tst.
PARAMETERS: cpu AS CHECKBOX DEFAULT 'X'.
PARAMETERS: fsy AS CHECKBOX DEFAULT 'X'.
PARAMETERS: db  AS CHECKBOX DEFAULT 'X'.
PARAMETERS: ram AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN END OF BLOCK tst.

START-OF-SELECTION.
  WRITE: / 'Execution time per Unit: ', time_ss, 'seconds'.
                                                    "#EC NOTEXT  ULINE.
  SKIP.
* CPU
  IF cpu = 'X'.
    PERFORM cpu USING time_ss.
  ENDIF.
* File System
  IF fsy = 'X'.
    PERFORM file_system USING time_ss.
  ENDIF.
* RDBMS Update
  IF db = 'X'.
    PERFORM rdbms_update USING time_ss.
  ENDIF.
* RAM
  IF ram = 'X'.
    PERFORM ram USING time_ss.
  ENDIF.

*&---------------------------------------------------------------------*
*&      Form  cpu
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->MAX_EXECUTION_TIME_SS  text
*----------------------------------------------------------------------*
FORM cpu USING max_execution_time_ss TYPE timeio_ss .
  DATA: time_begin   TYPE t,
        " Begin
        time_end     TYPE t,
        " End
        time_elapsed TYPE t.
  " Elapsed time
  DATA: l_primes_count TYPE i.
  DATA: l_next_primes  TYPE i.
  DATA: l_half               TYPE f.
  DATA: l_mod                TYPE i.
  TYPES: BEGIN OF ty_line,           number TYPE i,  END OF ty_line.
  DATA: l_magic TYPE                   ty_line.
  DATA: t_magic TYPE STANDARD TABLE OF ty_line.
  DATA: l_max_execution_time TYPE t.
  ADD max_execution_time_ss TO l_max_execution_time.
* Begin of processing  GET TIME FIELD time_begin.
* Processing  l_magic-number = 2.
  APPEND l_magic TO t_magic.
  l_next_primes = 2.
  l_magic-number = 3.
  APPEND l_magic TO t_magic.
  l_next_primes = 3.
  WHILE time_elapsed <= l_max_execution_time.
    ADD 2 TO l_next_primes.
    "Only odd nu    l_half     = l_next_primes / 2.
*   Look for .
    .
    .
    LOOP AT t_magic INTO l_magic FROM 2.
      IF l_magic-number >  l_half.
        l_magic-number = l_next_primes.
        EXIT.
      ENDIF.
      l_mod = l_next_primes MOD l_magic-number.
      IF l_mod = 0.
        EXIT.
      ENDIF.
    ENDLOOP.
    IF l_magic-number = l_next_primes.
*     Got it      APPEND l_magic TO t_magic.
      ADD 1 TO l_primes_count.
    ENDIF.
*   Check execution time    GET TIME FIELD time_end.
    time_elapsed = time_end - time_begin.
  ENDWHILE.
* End of processing  DESCRIBE TABLE t_magic LINES l_primes_count.
  WRITE : /1  'CPU Power',                                  "#EC NOTEXT
   20 '- Primes found: ',                                   "#EC NOTEXT
   45 l_primes_count.
*  LOOP AT t_magic INTO l_magic.
*    WRITE: / l_magic-number.
*  ENDLOOP.
  FREE t_magic.
ENDFORM.
"cpu
*&---------------------------------------------------------------------*
*&
FORM  file_system USING time_ss.
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->MAX_EXECUTION_TIME_SS  text
*-------------------------------------------------------------
  DATA: time_begin   TYPE t,
        " Begin
        time_end     TYPE t,
        " End
        time_elapsed TYPE t.
  " Elapsed time
  CONSTANTS: file_name(128) TYPE c VALUE 'StressTest'.
  DATA:      l_max_block_size(16)  TYPE p.
  l_max_block_size = 10 * 1024 * 1024.
  "10 MB per bl  DATA: l_fsys_record(256) TYPE c.
  DATA: l_block_size(16)      TYPE p.
  DATA: l_tot_size(16)        TYPE p.
  DATA: l_max_execution_time TYPE t.
  ADD max_execution_time_ss TO l_max_execution_time.
  DO 256 TIMES.
    CONCATENATE l_fsys_record '0' INTO l_fsys_record.
  ENDDO.
* Begin of processing  GET TIME FIELD time_begin.
* Processing  WHILE time_elapsed <= l_max_execution_time.
  OPEN DATASET file_name FOR OUTPUT IN BINARY MODE.
  IF sy-subrc NE 0.
    WRITE : / 'Error opening file', "#EC NOTEXT                file_name, 'SY:-SUBRC=', sy-subrc.
    exit.
  ENDIF.
  CLEAR: l_block_size.
  WHILE l_block_size < l_max_block_size.
    TRANSFER l_fsys_record TO file_name.
    ADD 256 TO l_block_size.
  ENDWHILE.
  ADD l_block_size TO l_tot_size.
  CLOSE DATASET file_name.
  DELETE DATASET file_name.
*   Check execution time    GET TIME FIELD time_end.
  time_elapsed = time_end - time_begin.
ENDWHILE.
* End of processing  l_tot_size = l_tot_size / 1024 / 1024.
WRITE : /1  'File System - ', "#EC NOTEXT           20 '- Written Mbytes: ',                         "#EC NOTEXT           45(11) l_tot_size.
endform.
"file_system
*&---------------------------------------------------------------------*
*&
FORM  rdbms_update.
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->MAX_EXECUTION_TIME_SS  text
*-------------------------------------------------------------

  DATA:  time_begin   TYPE t,
         " Begin
         time_end     TYPE t,
         " End
         time_elapsed TYPE t.
  " Elapsed time
  CONSTANTS: l_carrid  TYPE s_carr_id VALUE 'ZSF'.
  DATA     : l_connid  TYPE s_conn_id VALUE 1.
  DATA:    : l_sflight TYPE sflight.
  DATA: l_rdbms_record(256) TYPE c.
  DATA:  l_updated_records  TYPE i.
  DATA: l_max_execution_time TYPE t.
  ADD max_execution_time_ss TO l_max_execution_time.
* Fill record  l_sflight-carrid      = l_carrid.
  l_sflight-connid      = l_connid.
  l_sflight-fldate      = '20060119'.
  l_sflight-price       = 100.
  l_sflight-currency    = 'EUR'.
  l_sflight-planetype   = 'A319'.
  l_sflight-seatsmax    = 100.
  l_sflight-seatsocc    = 89.
  l_sflight-paymentsum  = 1499.
*  l_sflight-seatsmax_b  = 0.
*  l_sflight-seatsocc_b  = 0.
*  l_sflight-seatsmax_f  = 0.
*  l_sflight-seatsocc_f  = 0.
* Begin of processing  GET TIME FIELD time_begin.
* Processing  WHILE time_elapsed <= l_max_execution_time.
  l_sflight-connid = 1.
  DELETE FROM sflight WHERE carrid = 'ZSF'                          AND connid BETWEEN 1 AND 100.
  DO 100 TIMES.
    ADD 1 TO l_sflight-connid.
    INSERT sflight FROM l_sflight.
  ENDDO.
  COMMIT WORK.
  ADD 100 TO l_updated_records.
*   Check execution time    GET TIME FIELD time_end.
  time_elapsed = time_end - time_begin.
ENDWHILE.
DELETE FROM sflight WHERE carrid = 'ZSF'                        AND connid BETWEEN 1 AND 100.
COMMIT WORK.
* End of processing  WRITE : /1  'RDBMS update',                               "#EC NOTEXT           20 '- Updated records: ',                        "#EC NOTEXT           45 l_updated_records.
ENDFORM.
"rdbms_ιpdate
*&---------------------------------------------------------------------*
*&      Form  ram
*&---------------------------------------------------------------------**       text*----------------------------------------------------------------------**      -->MAX_EXECUTION_TIME_SS  text*-------------------------------------------------------------
DATA:  time_begin TYPE t,               " Begin         time_end      TYPE t,               " End         time_elapsed  TYPE t.
       " Elapsed time  TYPES: BEGIN OF ty_line,           key(10)   TYPE n,           attr1(256) TYPE c,           attr2(256) TYPE c,         END OF ty_line.
       data:      line TYPE ty_line.
DATA: itab TYPE STANDARD TABLE OF ty_line.
DATA: l_key(10) TYPE n.
DATA: l_table_scans TYPE i.
DATA: l_max_execution_time TYPE t.
ADD max_execution_time_ss TO l_max_execution_time.
line-attr1 = line-attr2 = 'ABCDEFGHILMNOPQRSTUVZ'.
DO 1000000 TIMES.
  l_key = 1000000 - sy-index.
  line-key = l_key.
  APPEND line TO itab.
ENDDO.
* Begin of processing  GET TIME FIELD time_begin.
* Processing  WHILE time_elapsed <= l_max_execution_time.
READ TABLE itab INTO line WITH KEY key = 1.
l_table_scans = sy-index.
*   Check execution time    GET TIME FIELD time_end.
time_elapsed = time_end - time_begin.
ENDWHILE.
* end of processing  WRITE : /1  'RAM',           20 '- Table scans: ',                            "#EC NOTEXT           45 l_table_scans.
FREE itab.
ENDFORM.
"ram
