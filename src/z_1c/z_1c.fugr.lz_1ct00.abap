*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 01.06.2019 at 11:52:40
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: Z1COZ_CONFIG....................................*
DATA:  BEGIN OF STATUS_Z1COZ_CONFIG                  .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_Z1COZ_CONFIG                  .
CONTROLS: TCTRL_Z1COZ_CONFIG
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *Z1COZ_CONFIG                  .
TABLES: Z1COZ_CONFIG                   .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
