-- Created By: Lance Woodard, Registrar
--       Date: March 7, 2013
--    Purpose: Pulls a list of courses from SSASECT by Term, Section Number, etc.
--             I initially created this to pull the Study Abroad courses,
--             which all have a section number of 800.
--       Note: Changed script to look for campus code description like 'TnCIS%'

select ssbsect_term_code       as "Term",
       ssbsect_crn             as "CRN",
       ssbsect_subj_code       as "Subj",
       ssbsect_crse_numb       as "Numb",
       scbcrse_title           as "Title",
       ssbsect_seq_numb        as "Section",
       ssbsect_ssts_code       as "Status",
       ssbsect_enrl            as "Enrollment",
       ssbsect_camp_code       as "Camp Code",
       stvcamp_desc            as "Camp Desc",
       ssbsect_ptrm_code       as "PTRM",
       ssbsect_ptrm_start_date as "Begin Date",
       ssbsect_ptrm_end_date   as "End Date",
       ssbsect_ptrm_weeks      as "Weeks"
--       ssbsect_voice_avail     as "Voice Response",
--       ssbsect_schd_code       as "Schedule Type",
--       ssbsect_insm_code       as "Instructional Method",
--       ssbsect_sapr_code       as "Approval"
from ssbsect,stvcamp,scbcrse
where  ssbsect_camp_code = stvcamp_code
and    scbcrse_subj_code = ssbsect_subj_code
and    scbcrse_crse_numb = ssbsect_crse_numb
and    ssbsect_term_code = :Term_1
--and    ssbsect_seq_numb  = :Section_Number
and    ssbsect_ssts_code = 'A'
and    stvcamp_desc like 'TnCIS%'
--and    ssbsect_term_code LIKE '%50'
--and    ssbsect_seq_numb IN ('N9%','800')
--and    ssbsect_camp_code = :Campus
--and    ssbsect_ptrm_code = :Part_of_Term
--and    ssbsect_seq_numb = '90'
--and   ssbsect_schd_code = 'FLD'
--and    ssbsect_ssts_code = 'C'
order by 6 desc, ssbsect_subj_code,ssbsect_crse_numb,ssbsect_seq_numb;

--desc stvcamp;
--desc scbcrse;
--desc ssbsect;