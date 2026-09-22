declare 
--outfilepath   varchar2(60) :='$DATA_HOME';
outfilepath   varchar2(60) :='DATALOAD_DIR';
outfilename   varchar2(60) :='st_records_sfbetrm_EL_to_WD_detail_'||to_char(sysdate,'YYYYMMDDHH24')||'.csv';
outfilehandle UTL_FILE.FILE_TYPE;
fileout       varchar2(30000);
fspdcount     number;
fsyrcode      varchar2(2);
cursor detail_cursor is
select distinct SPRIDEN_ID
||','||SUBSTR(SUBSTR(spriden_last_name,1,19) || ', ' ||spriden_first_name ||DECODE(spriden_mi,null,null,' ') ||
	      SUBSTR(spriden_mi,1,1),1,36) 
||','||SFBETRM.SFBETRM_ESTS_CODE 
from sfrstcr a,spriden,sfrwdrl,ssbsect,sfbetrm,
(SELECT * FROM spraddr where spraddr_atyp_code like 'LO'),
(SELECT * FROM GOREMAL WHERE GOREMAL_EMAL_CODE LIKE 'PERS'),
(SELECT * FROM SGRVETN WHERE SGRVETN_TERM_CODE_VA = &TERM),
(SELECT * FROM SGRSPRT WHERE SGRSPRT_TERM_CODE = &TERM),
(SELECT * FROM GORVISA) where ((sfbetrm_ests_code  not like 'W%')
 and (sfbetrm_ests_code  not like 'A%'))
 and sfbetrm_pidm not IN
     (SELECT sfrstcr_pidm from sfrstcr where (sfrstcr_rsts_code like 'R%'
        AND sfrstcr_term_code = &term) or (sfrstcr_rsts_code like 'A%' and sfrstcr_term_code = &term)
        or (sfrstcr_rsts_code like 'U%' and sfrstcr_term_code = &term))
and exists
(select 'X' from sfrstcr b where b.sfrstcr_pidm = sfbetrm_pidm and b.sfrstcr_term_code = sfbetrm_term_code)
and sfbetrm_term_code  = &term 
and a.sfrstcr_term_code  = &term
and sfbetrm_pidm = a.sfrstcr_pidm  
and sfbetrm_pidm = spraddr_pidm(+)
and sfbetrm_pidm = sgrvetn_pidm(+)
and sfbetrm_pidm = sgrsprt_pidm(+)
and sfbetrm_pidm = GORVISA_pidm(+)
and sfbetrm_pidm = spriden_pidm
and sfbetrm_pidm = sfrwdrl_pidm(+)
and sfbetrm_term_code = sfrwdrl_term_code (+)
and sfbetrm_pidm = goremal_pidm(+) 
and spriden_change_ind is null
and a.sfrstcr_term_code  = ssbsect_term_code
and a.sfrstcr_crn = ssbsect_crn;
 


-- Start the ball rolling
--
BEGIN
--
-- Prepare to read rows and write them to the file
--
open detail_cursor;
outfilehandle := UTL_FILE.FOPEN(outfilepath,outfilename,'W');
--
-- Fetch af_transaction_detail rows and add them to the file
--
LOOP
fetch detail_cursor into fileout;
exit when detail_cursor%notfound;
UTL_FILE.PUT_LINE(outfilehandle,fileout);
END LOOP;
--
-- Clean up
--
close detail_cursor;
UTL_FILE.FCLOSE(outfilehandle);
--
--
-- File exception handling
--
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
