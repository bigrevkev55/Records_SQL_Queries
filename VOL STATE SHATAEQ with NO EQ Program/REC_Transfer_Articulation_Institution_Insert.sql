/*
  REC_Transfer_Articulation_Institutional_Insert.sql
  
  Purpose:  This script will insert records into the Transfer Articulation
            Institutional tables based on updates occuring with SHRTRCE for the
            current date. The REC_Transfer_Articulation_Student_Update MUST run
            prior to this code to ensure that the updated SHRTRCE values are present
            in the record.
  
            This process will cut down on the number of entries that Transfer personnel
            will be required to do in articulating student records.
           
  By         WO         Date             Description
  WOW     8435450    11/8/2019    Created
  WOW     8435450    12/3/2019    Modified to correct duplicate key on insert. Excluded "V" course from insert.
*/

-- Insert a record into the transfer institution table
-- for each combination of institution/transfer course
-- if it does not exist
SET SERVEROUTPUT ON;
DECLARE

--  l_title   VARCHAR2(30);

  CURSOR cu1 IS

      SELECT DISTINCT
        shrtrit_sbgi_code institution,
        shrtrcr_program program_code,
        shrtrcr_levl_code level_code,
        shrtrcr_trans_course_name subject,
        shrtrcr_trans_course_numbers course,
      --  shrtrcr_term_code,        taking this out for now 11/19/2019
--        '000000',          -- default to earliest term 11/19/2019
--        trunc(sysdate),
        shrtrcr_tcrse_title title,
        shrtrcr_trans_credit_hours low_hours,
        shrtrcr_trans_credit_hours high_hours  
--        ,'Y',
--        'A', --?? AC??
--        'TD-8435450',
--        'N'
      FROM
        shrtrcr
      JOIN
        shrtrit on shrtrcr_pidm = shrtrit_pidm and shrtrcr_trit_seq_no = shrtrit_seq_no
      WHERE
        trunc(shrtrcr_activity_date) = trunc(sysdate)
      -- wow 12/3/2019 Corrected code below to correct duplicate key issue
      --  and shrtrit_sbgi_code||shrtrcr_trans_course_name||shrtrcr_trans_course_numbers||shrtrcr_term_code not in
      --    (select shbtatc_sbgi_code||shbtatc_subj_code_trns||shbtatc_crse_numb_trns||shbtatc_term_code_eff_trns from shbtatc)
        and shrtrit_sbgi_code||shrtrcr_program||shrtrcr_levl_code||shrtrcr_trans_course_name||shrtrcr_trans_course_numbers||'000000' not in
          (select shbtatc_sbgi_code||shbtatc_program||shbtatc_tlvl_code||shbtatc_subj_code_trns||shbtatc_crse_numb_trns||shbtatc_term_code_eff_trns from shbtatc)
      -- per Sarah Tallman, exclude "V" shrtrit_sbgi_codes   12/9/19
        and shrtrit_sbgi_code not like 'V%'
      ORDER BY 
        shrtrit_sbgi_code,
        shrtrcr_program,
        shrtrcr_levl_code,
        shrtrcr_trans_course_name,
        shrtrcr_trans_course_numbers;

    TYPE Rec IS TABLE OF cu1%rowtype;
    aRec Rec;
    

BEGIN
dbms_output.enable(1000000);

-- Get the records to update
          
        FOR aRec IN cu1 LOOP
          BEGIN
              DBMS_OUTPUT.PUT_LINE('Processing SBGI_CODE: '|| aRec.institution || ' ' ||aRec.level_code|| ' ' || aRec.subject || ' '|| aRec.course);
              -- Insert record into the Institution table --
              INSERT INTO shbtatc 
                (shbtatc_sbgi_code, shbtatc_program, shbtatc_tlvl_code, shbtatc_subj_code_trns, shbtatc_crse_numb_trns, shbtatc_term_code_eff_trns, 
                shbtatc_activity_date, shbtatc_trns_title, shbtatc_trns_low_hrs, shbtatc_trns_high_hrs, shbtatc_trns_review_ind, shbtatc_tast_code, 
                shbtatc_user_id, shbtatc_protect_ind)                
              VALUES  (
                 aRec.institution,
                 aRec.program_code,
                 aRec.level_code,
                 aRec.subject,
                 aRec.course,
                 '000000',
                 trunc(sysdate),
                 aRec.title,
                 aRec.low_hours,
                 aRec.high_hours,
                 'Y',
                 'A',
                 'TD-8435450',
                 'N'
              ) ;
              
              -- Insert record into the Institution Equivalency table --

            INSERT INTO shrtatc 
              (shrtatc_sbgi_code, shrtatc_program, shrtatc_tlvl_code, shrtatc_subj_code_trns, shrtatc_crse_numb_trns, shrtatc_term_code_eff_trns, shrtatc_seqno, 
              shrtatc_activity_date, shrtatc_subj_code_inst, shrtatc_crse_numb_inst, shrtatc_inst_title, shrtatc_inst_credits_used, shrtatc_user_id)
            SELECT DISTINCT
              shrtrit_sbgi_code,
              shrtrcr_program,
              shrtrcr_levl_code,
              shrtrcr_trans_course_name,
              shrtrcr_trans_course_numbers,
              --shrtrcr_term_code,
              '000000',
              -- new2 fix below suggestion
              --shrtrce_trcr_seq_no,
              1,
              trunc(sysdate),
              shrtrce_subj_code,
              shrtrce_crse_numb,
              shrtrce_crse_title,
              shrtrce_credit_hours,
              'TD-8435450'
            FROM
              shrtrce
            JOIN
              shrtrit on shrtrce_pidm = shrtrit_pidm and shrtrce_trit_seq_no = shrtrit_seq_no
            JOIN
              shrtrcr on shrtrce_pidm = shrtrcr_pidm and shrtrce_trit_seq_no = shrtrcr_trit_seq_no and shrtrce_tram_seq_no = shrtrcr_tram_seq_no 
                and shrtrce_seq_no = shrtrcr_seq_no
            WHERE
            --  trunc(shrtrce_activity_date) = trunc(sysdate)
              trunc(shrtrcr_activity_date) = trunc(sysdate)  
            -- wow 12/3/2019 Corrected code below to correct duplicate key issue
            --  and shrtrit_sbgi_code||shrtrcr_trans_course_name||shrtrcr_trans_course_numbers||shrtrcr_term_code not in
            --    (select shrtatc_sbgi_code||shrtatc_subj_code_trns||shrtatc_crse_numb_trns||shrtatc_term_code_eff_trns from shrtatc)
            -- include fix 2 for sequence number of 1
              and shrtrit_sbgi_code||shrtrcr_program||shrtrcr_levl_code||shrtrcr_trans_course_name||shrtrcr_trans_course_numbers||'000000'||1 not in
                (select shrtatc_sbgi_code||shrtatc_program||shrtatc_tlvl_code||shrtatc_subj_code_trns||shrtatc_crse_numb_trns||shrtatc_term_code_eff_trns||shrtatc_seqno from shrtatc)
            -- per Sarah Tallman   12/9/19 
              and shrtrit_sbgi_code not like 'V%' 
              and shrtrit_sbgi_code = aRec.institution
              and rtrim(shrtrcr_program) = aRec.program_code
              and shrtrcr_levl_code = aRec.level_code
              and shrtrcr_trans_course_name = aRec.subject
              and shrtrcr_trans_course_numbers = aRec.course
              -- get the first record only in case there are duplicates
              and rownum = 1; 
              
              COMMIT;
              DBMS_OUTPUT.PUT_LINE('COMMITTED');
              
              EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN
                  DBMS_OUTPUT.PUT_LINE('DUPLICATE RECORD FOUND FOR LAST INSTITUTION/PROGRAM/LEVEL/SUBJECT/COURSE! NOT INSERTED.');
                  ROLLBACK;
                WHEN OTHERS THEN
                  dbms_output.put_line('Error occured in Institution/Equivalency process:'||to_char(sqlerrm)|| ' NOT INSERTED');  
                  ROLLBACK;  
            END;            
          END LOOP;

END;
/
