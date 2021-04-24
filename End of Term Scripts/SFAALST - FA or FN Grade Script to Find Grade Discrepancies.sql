--   Author: Lance Woodard, Registrar
--  Created: October 18, 2017
--  Purpose: This script provides a list of student who earned an "FA" or "F"
--           but the LDA may mean that the grades need to be changed. TBR policy
--           states that a student who has an LDA 3/4th of the way through the term
--           should get an "FA" any date after this the student should get an "F". 
--     Edit: 1.  If the LDA
--           is before the start of the term the student should have an FN becuse
--           that means they are marked as non-attending...kt...12/15/2020.  
--           2.  Added a script at the top that does a better job of looking for courses that should be an FN.  
--           Previously, we were only looking for F grades that should be FN but this script looks for LDA 
--           that does not have a grade of FN.  ...kt...1/7/2021



--Script to find grades that should be FN (LDA the day before class starts)
select spriden_id as "ID",
       spriden_last_name as "Last Name",
       spriden_first_name as "First Name",
       ssbsect_crn as "CRN",
       sfrstcr_ptrm_code as "Part-Of-Term",
       ssbsect_subj_code as "Subject",
       ssbsect_crse_numb as "Crse Numb",
       ssbsect_seq_numb as "Section",
       sfrstcr_grde_code as "Grade",
       sfrstcr_last_attend as "LDA"
from spriden,ssbsect,sfrstcr
where spriden_change_ind IS NULL
and   spriden_pidm = sfrstcr_pidm
and   sfrstcr_term_code = ssbsect_term_code
and   sfrstcr_crn = ssbsect_crn
and   sfrstcr_term_code = :Term
and   sfrstcr_ptrm_code = :Part_of_Term
--and   sfrstcr_ptrm_code IN ('6','RA1')
--and   ssbsect_subj_code = 'ENGL'
--and   ssbsect_crse_numb IN ('1010','1020')
--and   sfrstcr_grde_code = :Grade
and   sfrstcr_grde_code not in  ('FN', 'W') --Do not look for W grades as its possible to never attend
                                            --but withdraw from the class, thus resulting in a W grade.
and   sfrstcr_last_attend = :Day_Before_First_Date
order by ssbsect_subj_code,ssbsect_crse_numb,ssbsect_seq_numb,spriden_last_name,spriden_first_name;




--Script to Find "F" Grades that should be "FA" Grades
select spriden_id as "ID",
       spriden_last_name as "Last Name",
       spriden_first_name as "First Name",
       ssbsect_crn as "CRN",
       sfrstcr_ptrm_code as "Part-Of-Term",
       ssbsect_subj_code as "Subject",
       ssbsect_crse_numb as "Crse Numb",
       ssbsect_seq_numb as "Section",
       sfrstcr_grde_code as "Grade",
       sfrstcr_last_attend as "LDA"     
from spriden,ssbsect,sfrstcr
where spriden_change_ind IS NULL
and   spriden_pidm = sfrstcr_pidm
and   sfrstcr_term_code = ssbsect_term_code
and   sfrstcr_crn = ssbsect_crn
and   sfrstcr_term_code = :Term
and   sfrstcr_ptrm_code = :Part_of_Term
--and   sfrstcr_ptrm_code IN ('6','RA1')
--and   ssbsect_subj_code = 'ENGL'
--and   ssbsect_crse_numb IN ('1010','1020')
--and   sfrstcr_grde_code = :Grade
and   sfrstcr_grde_code = 'F'
and   sfrstcr_last_attend <= :Enter_Date -- Date Format: DD-MON-YYYY
and   sfrstcr_last_attend >= :First_Day_of_Term --The previous script finds grades that need to be FN so this prompt was added to not return LDA before the term begins.
order by ssbsect_subj_code,ssbsect_crse_numb,ssbsect_seq_numb,spriden_last_name,spriden_first_name;

--Script to Find "FA" Grades that should be "F" Grades
select spriden_id as "ID",
       spriden_last_name as "Last Name",
       spriden_first_name as "First Name",
       ssbsect_crn as "CRN",
       sfrstcr_ptrm_code as "Part-Of-Term",
       ssbsect_subj_code as "Subject",
       ssbsect_crse_numb as "Crse Numb",
       ssbsect_seq_numb as "Section",
       sfrstcr_grde_code as "Grade",
       sfrstcr_last_attend as "LDA"
from spriden,ssbsect,sfrstcr
where spriden_change_ind IS NULL
and   spriden_pidm = sfrstcr_pidm
and   sfrstcr_term_code = ssbsect_term_code
and   sfrstcr_crn = ssbsect_crn
and   sfrstcr_term_code = :Term
and   sfrstcr_ptrm_code = :Part_of_Term
--and   sfrstcr_ptrm_code IN ('6','RA1')
--and   ssbsect_subj_code = 'ENGL'
--and   ssbsect_crse_numb IN ('1010','1020')
--and   sfrstcr_grde_code = :Grade
and   sfrstcr_grde_code = 'FA'
and   sfrstcr_last_attend > :Enter_Date -- Date Format: DD-MON-YYYY
order by ssbsect_subj_code,ssbsect_crse_numb,ssbsect_seq_numb,spriden_last_name,spriden_first_name;

--desc sfrstcr;


--Script to find grades that should be FN (LDA the day before class starts)
select spriden_id as "ID",
       spriden_last_name as "Last Name",
       spriden_first_name as "First Name",
       ssbsect_crn as "CRN",
       sfrstcr_ptrm_code as "Part-Of-Term",
       ssbsect_subj_code as "Subject",
       ssbsect_crse_numb as "Crse Numb",
       ssbsect_seq_numb as "Section",
       sfrstcr_grde_code as "Grade",
       sfrstcr_last_attend as "LDA"
from spriden,ssbsect,sfrstcr
where spriden_change_ind IS NULL
and   spriden_pidm = sfrstcr_pidm
and   sfrstcr_term_code = ssbsect_term_code
and   sfrstcr_crn = ssbsect_crn
and   sfrstcr_term_code = :Term
and   sfrstcr_ptrm_code = :Part_of_Term
--and   sfrstcr_ptrm_code IN ('6','RA1')
--and   ssbsect_subj_code = 'ENGL'
--and   ssbsect_crse_numb IN ('1010','1020')
--and   sfrstcr_grde_code = :Grade
and   sfrstcr_grde_code not in ('FN', 'W')
--and   sfrstcr_last_attend > :Enter_Date -- Date Format: DD-MON-YYYY
and   sfrstcr_last_attend = :Day_Before_First_Date
order by ssbsect_subj_code,ssbsect_crse_numb,ssbsect_seq_numb,spriden_last_name,spriden_first_name;