


NOTE:  NOT THE BEST SCRIPT ANYMORE...see "SFAALST - All in One Discrepencies 2.sql" instead.  






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
--           3.  Changed the sort order on all queries and added additional queries...kt...5/12/21


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
--and   sfrstcr_ptrm_code = :Part_of_Term
--and   sfrstcr_ptrm_code IN ('6','RA1', '1', 'R', 'O')
and   sfrstcr_ptrm_code IN ('7', 'RA2')
--and   ssbsect_subj_code = 'ENGL'
--and   ssbsect_crse_numb IN ('1010','1020')
--and   sfrstcr_grde_code = :Grade
and   sfrstcr_grde_code not in  ('FN', 'W') --Do not look for W grades as its possible to never attend
                                            --but withdraw from the class, thus resulting in a W grade.
and   sfrstcr_last_attend = :Day_Before_First_Date
order by spriden_last_name,spriden_first_name, sfrstcr_ptrm_code, ssbsect_subj_code,ssbsect_crse_numb,ssbsect_seq_numb;




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
--and   sfrstcr_ptrm_code = :Part_of_Term
--and   sfrstcr_ptrm_code IN ('1', 'R', 'O')
--and   sfrstcr_ptrm_code IN ('6','RA1')
and   sfrstcr_ptrm_code IN ('7', 'RA2')
--and   ssbsect_subj_code = 'ENGL'
--and   ssbsect_crse_numb IN ('1010','1020')
--and   sfrstcr_grde_code = :Grade
and   sfrstcr_grde_code = 'F'
and   sfrstcr_last_attend <= :Enter_Date -- Date Format: DD-MON-YYYY
and   sfrstcr_last_attend >= :First_Day_of_Term --The previous script finds grades that need to be FN so this prompt was added to not return LDA before the term begins.
order by spriden_last_name,spriden_first_name, sfrstcr_ptrm_code, ssbsect_subj_code,ssbsect_crse_numb,ssbsect_seq_numb;

--Script to Find "FA" Grades that should be "F" Grades as LDA is after last day to earn FA
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
--and   sfrstcr_ptrm_code = :Part_of_Term
--and   sfrstcr_ptrm_code IN ('1', 'R', 'O')
--and   sfrstcr_ptrm_code IN ('6','RA1')
and   sfrstcr_ptrm_code IN ('7', 'RA2')
--and   ssbsect_subj_code = 'ENGL'
--and   ssbsect_crse_numb IN ('1010','1020')
--and   sfrstcr_grde_code = :Grade
and   sfrstcr_grde_code = 'FA'
and   sfrstcr_last_attend > :Enter_Date -- Date Format: DD-MON-YYYY
order by spriden_last_name,spriden_first_name, sfrstcr_ptrm_code, ssbsect_subj_code,ssbsect_crse_numb,ssbsect_seq_numb;

--desc sfrstcr;

/*
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
order by spriden_last_name,spriden_first_name, sfrstcr_ptrm_code, ssbsect_subj_code,ssbsect_crse_numb,ssbsect_seq_numb;

*/

--Script to find students reported as not engaged but have a grade other than FN
--DESC SZRATND;
/*
This report attempts to find students whose reported grade for a class isn't    ----edited by Trey Dalton, Systems Analyst II 6.10.21
compatible with their reported engagement for that class i.e. they received 
an FN grade, but were marked as attending that class, or they have a B grade, 
and were marked as not attending.
*/
select  distinct spriden_id student_id
        , spriden_last_name last_name
        , spriden_first_name first_name
        , sfvstms_crn crn
        , sfvstms_ptrm_code part_of_term
        , sfvstms_subj_code subject
        , sfvstms_crse_numb course_number
        , sfvstms_seq_numb section 
        , shrtckg_grde_code_final grade
        , sfvstms_last_attend lda
        , sfvstms_attending_ind reported_engagement        
from    spriden
        , sfvstms 
        , shrtckg
        , shrtckn
where   spriden_change_ind is null
and     sfvstms_pidm = spriden_pidm
and     shrtckg_pidm = spriden_pidm
and     shrtckn_pidm = spriden_pidm
and     sfvstms_term_code = :term_code
and     shrtckg_term_code = :term_code
and     shrtckn_term_code = :term_code
and     shrtckn_crn = sfvstms_crn
and     ((
                shrtckg_grde_code_final not in ('FN', 'W')
                and sfvstms_attending_ind not in ('Y') --edited by Trey Dalton on 12/13/2021 to remove 'S' attendence indicators from this NOT IN statement
        )
or      (
                shrtckg_grde_code_final in ('FN')
                and sfvstms_attending_ind in ('Y','S')
        ))
and     shrtckn_term_code = :term_code
and     shrtckn_seq_no = shrtckg_tckn_seq_no
and     shrtckg_seq_no = (
                                select max(a.shrtckg_seq_no)
                                from shrtckg a
                                where a.shrtckg_pidm = shrtckg.shrtckg_pidm
                                and a.shrtckg_term_code = shrtckg.shrtckg_term_code
                                and a.shrtckg_tckn_seq_no = shrtckg.shrtckg_tckn_seq_no
                         )
order by 2, 3, 5, 6, 7, 8
;
;


--Script to find students not reported attending but have a grade of FN
--DESC SZRATND;
select spriden_id as "ID",
       spriden_last_name as "Last Name",
       spriden_first_name as "First Name",
       ssbsect_crn as "CRN",
       sfrstcr_ptrm_code as "Part-Of-Term",
       ssbsect_subj_code as "Subject",
       ssbsect_crse_numb as "Crse Numb",
       ssbsect_seq_numb as "Section",
       sfrstcr_grde_code as "Grade",
       sfrstcr_last_attend as "LDA",
       SZRATND_ATTENDING_IND as "Reported Engagement"
from spriden,ssbsect,sfrstcr, SZRATND
where spriden_change_ind IS NULL
and  spriden_pidm = szratnd_pidm
and  SZRATND_CRN = ssbsect_crn
and   spriden_pidm = sfrstcr_pidm
and   sfrstcr_term_code = ssbsect_term_code
and   sfrstcr_crn = ssbsect_crn
and   sfrstcr_term_code = :Term
--and   sfrstcr_term_code = szratnd_term_code
--and   sfrstcr_ptrm_code = :Part_of_Term
--and   sfrstcr_ptrm_code IN ('6','RA1')
--and   ssbsect_subj_code = 'ENGL'
--and   ssbsect_crse_numb IN ('1010','1020')
--and   sfrstcr_grde_code = :Grade
and   sfrstcr_grde_code  in ('FN')
and  SZRATND_ATTENDING_IND = 'Y'

--and   sfrstcr_last_attend > :Enter_Date -- Date Format: DD-MON-YYYY
--and   sfrstcr_last_attend = :Day_Before_First_Date
order by spriden_last_name,spriden_first_name, sfrstcr_ptrm_code, ssbsect_subj_code,ssbsect_crse_numb,ssbsect_seq_numb;

















