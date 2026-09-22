--PL/SQL process to create a CSV report of students who have been reported as stopped attending or never attended for
--all courses they are registered for in the given term and need to have their registration status updated to WU on szratnd
--Created by Chuck Hackney 12/21/2011
set serveroutput on
declare 
--outfilepath   varchar2(60) :='$DATA_HOME';
outfilepath   varchar2(60) :='DATALOAD_DIR';
outfilename   varchar2(60) :='st_records_sfbetrm_EL_to_WU.csv';
outfilehandle UTL_FILE.FILE_TYPE;
fileout       varchar2(30000);
term          varchar2(7) := '&term';
stu_count number := 0;
-- cursor to retrieve students to be added to the report
cursor students is 
  select distinct spriden_id||','||spriden_last_name||','||spriden_first_name||','||sfbetrm_ests_code
  from szratnd s
  ,    sfbetrm f
  ,    spriden
  ,    ssbsect
  where szratnd_term_code = term
  and   ssbsect_term_code = szratnd_term_code
  and   ssbsect_crn = szratnd_crn
  and   ssbsect_ptrm_code <> 'S'
  and   spriden_change_ind is null
  and   sfbetrm_ests_code = 'EL'
  and   spriden_pidm = szratnd_pidm
  and   sfbetrm_term_code = szratnd_term_code
  and   sfbetrm_pidm = szratnd_pidm
  and   szratnd_rsts_code like 'R%'
  -- all of the students records on szratnd indicate that they have either stopped attending or never attended courses for which they are registered
  and not exists (select szratnd_pidm
                ,      szratnd_term_code
                from szratnd
                where szratnd_attending_ind not in ('S','N')
                and szratnd_pidm = s.szratnd_pidm
                and szratnd_term_code = s.szratnd_term_code
                and szratnd_rsts_code like 'R%')
  and szratnd_pidm not in (select sfrstcr_pidm from sfrstcr 
                          where sfrstcr_pidm = s.szratnd_pidm
                          and sfrstcr_term_code = term
                          and sfrstcr_rsts_code like 'W%');
				
BEGIN
open students;
outfilehandle := UTL_FILE.FOPEN(outfilepath,outfilename,'W');
--write header line for the report
UTL_FILE.PUT_LINE(outfilehandle,'ID,Last Name,First Name,Enrollment Status');
-- loop through cursor writing a line to the report for each record
LOOP
  fetch students into fileout;
  exit when students%notfound;
  stu_count := stu_count + 1 ;
  UTL_FILE.PUT_LINE(outfilehandle,fileout);
END LOOP;
DBMS_OUTPUT.PUT_LINE(stu_count||' records found.');
close students;
--obligitory exception handling
EXCEPTION
  WHEN utl_file.invalid_mode THEN
    RAISE_APPLICATION_ERROR (-20051, 'Invalid Mode Parameter');
  WHEN utl_file.invalid_path THEN
    RAISE_APPLICATION_ERROR (-20052, 'Invalid File Location');
  WHEN utl_file.invalid_filehandle THEN
    RAISE_APPLICATION_ERROR (-20053, 'Invalid Filehandle');
  WHEN utl_file.invalid_operation THEN
    RAISE_APPLICATION_ERROR (-20054, 'Invalid Operation');
  WHEN utl_file.read_error THEN
    RAISE_APPLICATION_ERROR (-20055, 'Read Error');
  WHEN utl_file.internal_error THEN
    RAISE_APPLICATION_ERROR (-20057, 'Internal Error');
  WHEN utl_file.charsetmismatch THEN
    RAISE_APPLICATION_ERROR (-20058, 'Opened With FOPEN_NCHAR But Later I/O Inconsistent');
 WHEN utl_file.file_open THEN
    RAISE_APPLICATION_ERROR (-20059, 'File Already Opened');
 WHEN utl_file.invalid_maxlinesize THEN
    RAISE_APPLICATION_ERROR(-20060,'Line Size Exceeds 32K');
 WHEN utl_file.invalid_filename THEN
    RAISE_APPLICATION_ERROR (-20061, 'Invalid File Name');
 WHEN utl_file.access_denied THEN
    RAISE_APPLICATION_ERROR (-20062, 'File Access Denied By');
 WHEN utl_file.invalid_offset THEN
    RAISE_APPLICATION_ERROR (-20063,'FSEEK Param Less Than 0');
--
-- End of process
--
END;
/
