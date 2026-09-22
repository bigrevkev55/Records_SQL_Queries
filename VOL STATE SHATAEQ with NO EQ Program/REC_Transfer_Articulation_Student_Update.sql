/*
  REC_Transfer_Articulation_Student_Update.sql
  
  This script will update the student articulation record (SHRTRCE) to the correct value
  when there is a difference between the old subject or old course and the new subject/course
  found on the VSCC_DW_SHRTRCE_EXTRACT join. This will enable SHRTRCE to reflect the correct 
  values. This code had to be done in a cursor due to being unable to generate a single
  record sub-query in a regular sql statement. 
           
  By:                 TICKET         Date:                   Description:
  
  Wanda Wilburn       8435450        11/8/2019                Created
*/

DECLARE

  l_title   VARCHAR2(30);

  CURSOR cu1 IS
      SELECT  
          new.shrtrce_subj_code new_subject, 
          new.shrtrce_crse_numb new_course,
          new.shrtrce_crse_title new_title,
          new.shrtrce_pidm pidm,
          new.shrtrce_trit_seq_no trit_seq_no,
          new.shrtrce_Tram_seq_no tram_seq_no,
          new.shrtrce_seq_no seq_no,
          new.shrtrce_trcr_seq_no trcr_seq_no,
          new.shrtrce_term_code_eff term
      FROM vscc_dw_shrtrce_extract new
      JOIN shrtrce old
          on old.shrtrce_pidm = new.shrtrce_pidm 
          and old.shrtrce_trit_seq_no = new.shrtrce_trit_seq_no 
          and old.shrtrce_Tram_seq_no = new.shrtrce_Tram_seq_no
          and old.shrtrce_seq_no = new.shrtrce_seq_no
          and old.shrtrce_trcr_seq_no = new.shrtrce_trcr_seq_no 
          and old.shrtrce_term_code_eff = new.shrtrce_term_code_eff
          and trunc(old.shrtrce_activity_date) = trunc(sysdate) 
--          and new.shrtrce_term_code_eff = '201850'
--          and new.shrtrce_pidm = 389324
      WHERE  
          old.shrtrce_subj_code <> new.shrtrce_subj_code or old.shrtrce_crse_numb <> new.shrtrce_crse_numb;    

    TYPE Rec IS TABLE OF cu1%rowtype;
    aRec Rec;
    
   FUNCTION EXTRACT_TITLE (pTerm in VARCHAR2, pSubject in VARCHAR2, pCourse in VARCHAR2) RETURN VARCHAR2
    IS
        l_result varchar2(30) DEFAULT ' ';
    BEGIN
        DBMS_OUTPUT.PUT_LINE('In Extract Title');
        SELECT 
            initcap(shrtckn_crse_title)
        INTO 
            l_result
        FROM
            shrtckn
        WHERE
            shrtckn_term_code = (
                SELECT
                    max(a.shrtckn_term_code)
                FROM
                    shrtckn a
                WHERE
                    a.shrtckn_term_code <= pTerm
            )
            AND shrtckn_subj_code = pSubject
            AND shrtckn_crse_numb = pCourse
            AND UPPER(shrtckn_crse_title) NOT LIKE '%HONORS%'
        ORDER BY shrtckn_activity_date DESC
        FETCH FIRST 1 ROWS ONLY
        ;
       RETURN NVL(l_result,' ');
       EXCEPTION
        WHEN NO_DATA_FOUND THEN 
          RETURN l_result;
    END EXTRACT_TITLE;  

BEGIN
dbms_output.enable(1000000);

-- Get the records to update
    OPEN cu1;
    LOOP
      FETCH cu1 BULK COLLECT INTO aRec LIMIT 1000;
      EXIT WHEN aRec.COUNT=0;
  
          FOR idx IN  aRec.FIRST..aRec.LAST LOOP
          
            l_title :=EXTRACT_TITLE(aRec(idx).term,aRec(idx).new_subject,aRec(idx).new_course);
    
            UPDATE SHRTRCE
            SET SHRTRCE_SUBJ_CODE = aRec(idx).new_subject,
                SHRTRCE_CRSE_NUMB = aRec(idx).new_course,
            --    SHRTRCE_CRSE_TITLE = aRec(idx).new_title,
                SHRTRCE_CRSE_TITLE = l_title,
                SHRTRCE_ACTIVITY_DATE = sysdate,
                SHRTRCE_USER_ID = 'TD-8435450'
            WHERE
                SHRTRCE_PIDM = aRec(idx).pidm
                AND SHRTRCE_TERM_CODE_EFF = aRec(idx).term
                AND SHRTRCE_TRIT_SEQ_NO = aRec(idx).trit_seq_no
                AND SHRTRCE_TRAM_SEQ_NO = aRec(idx).tram_seq_no
                AND SHRTRCE_SEQ_NO = aRec(idx).seq_no
                AND SHRTRCE_TRCR_SEQ_NO = aRec(idx).trcr_seq_no;
    
          END LOOP;

    END LOOP;
    CLOSE cu1;
    COMMIT;
    
    
    
EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line('error occured in update process:'||to_char(sqlerrm));
END;
/
