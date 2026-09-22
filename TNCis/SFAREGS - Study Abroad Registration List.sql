--   Author: Lance Woodard, Registrar
--  Created: April 17, 2012
--  Purpose: This script was created to pull a list of Study Abroad Students by Term.
select spriden_id as "ID",
       spriden_last_name as "Last Name",
       spriden_first_name as "First Name",
       sfrstcr_term_code as "Term",
       sfrstcr_crn as "CRN",
       ssbsect_subj_code as "Subj",
       ssbsect_crse_numb as "Crse Numb",
       ssbsect_seq_numb as "Section",
       stvcamp_desc as "Country",
       ssbsect_ptrm_code as "Ptrm",
       ssbsect_ptrm_start_date as "Begin Date",
       ssbsect_ptrm_end_date as "End Date",       
       ssbsect_schd_code as "Sch Type",
       ssbsect_insm_code as "Method"
from spriden,sfrstcr,ssbsect,stvcamp
where spriden_change_ind IS NULL
and   spriden_pidm = sfrstcr_pidm
and   sfrstcr_term_code = ssbsect_term_code
and   ssbsect_camp_code = stvcamp_code
and   sfrstcr_crn = ssbsect_crn
and   sfrstcr_term_code = '&Term'
and   ssbsect_seq_numb LIKE 'N9%'
-- Next line is used to search for students enrolled in a particular CRN
--and   ssbsect_crn IN ('83083','83084')
--and   ssbsect_crse_numb = '&Crse_Numb'
order by spriden_last_name,spriden_first_name,sfrstcr_crn;