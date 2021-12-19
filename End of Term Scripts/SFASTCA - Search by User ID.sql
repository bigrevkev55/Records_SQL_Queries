--Created By: Lance Woodard
--      Date: August 13, 2014
--   Purpose: This scripts should be run after students are dropped for failed
--            or unmet pre-requisites (SFRRGAM) to produce their campus email
--            for notification to the student.
--    Edited: 1.  Edited by Kevin Thomas, Assistant Registrar on 08-MAY-2019 (Changed acitivty dates, User name, and added a term prompt).
--            2.  Added a sub query to search and see if the student is a Dual Enrollment Student (DE)...kt...11.20.21  


select distinct spriden_id as "ID",
       CASE WHEN EXISTS (
                        select SORHSCH_DPLM_CODE, sorhsch_pidm
                         from sorhsch
                         where SORHSCH_DPLM_CODE = 'DE'
                         and sorhsch_pidm = spriden_pidm
       )
       
       THEN 'Y'
       ELSE 'N'
       End AS "DE Student?",
       spriden_last_name as "Last Name",
       spriden_first_name as "First Name",
       --spriden_last_name as "Last Name",
       goremal_email_address as "Email",
       sfrstca_term_code as "Term",
--       sfrstca_rsts_code as "Reg Code",
--       sfrstca_rsts_date as "RSTS Date",
--       sfrstca_crn as "CRN",
--       sfrstca_subj_code as "SUBJ",
--       sfrstca_crse_numb as "Crse Numb",
--       sfrstca_seq_number as "Seq No",
       sfrstca_user as "User",
       sfrstca_activity_date as "Date"
from spriden,sfrstca,goremal
where spriden_change_ind IS NULL
and   spriden_pidm = sfrstca_pidm
and   sfrstca_pidm = goremal_pidm
and   sfrstca_term_code = :TERM
and   sfrstca_user in ('THOMAS_K', 'KOVACS_A')
and   sfrstca_activity_date > = '13-MAY-2021' 
and   sfrstca_rsts_code = 'DD'
and   sfrstca_source_cde = 'BASE'
and   goremal_emal_code = 'CAMP'
--and   spriden_ID <> 'Stu_ID'
order by spriden_last_name,spriden_first_name;