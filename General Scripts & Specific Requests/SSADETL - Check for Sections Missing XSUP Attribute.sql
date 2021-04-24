--  Author: Lance Woodard, Registrar
--    Date: October 12, 2012
-- Purpose: This script checks SSADETL for 2nd session courses as they
--          should have the "XSUP" attribute code toc ount for supplemental
--          reporting.
select distinct ssrattr_term_code as "Term",
       ssrattr_crn as "CRN",
       ssbsect_subj_code as "Subj",
       ssbsect_crse_numb as "Numb",
       ssbsect_seq_numb as "Section",
       ssbsect_enrl as "Enrolled",
       ssbsect_ptrm_code as "PTRM Code"
from ssbsect,ssrattr
where ssrattr_term_code = '&Term'
and   ssrattr_crn = ssbsect_crn
and   ssbsect_term_code = ssrattr_term_code
--and   ssbsect_ptrm_code = '&Part_of_Term'
and   ssbsect_ptrm_code IN ('7','RA2')
--and   ssbsect_crn||ssbsect_term_code in
and   ssbsect_crn||ssbsect_term_code not in
      (select ssrattr_crn||ssrattr_term_code
       from ssrattr
       where ssrattr_attr_code = 'XSUP')
order by ssbsect_subj_code,ssbsect_crse_numb,ssbsect_seq_numb;

desc ssbsect;

-- Script for courses starting after census
select ssbsect_term_code as "Term",
       ssbsect_camp_code as "Campus",
       ssbsect_ssts_code as "Status",
       ssbsect_ptrm_code as "Ptrm Code",
       ssbsect_crn as "CRN",
       ssbsect_subj_code as "Subject",
       ssbsect_crse_numb as "Crse Numb",
       ssbsect_seq_numb as "Section",
       ssbsect_ptrm_start_date as "Begin Date",
       ssbsect_ptrm_end_date as "End Date",
       ssbsect_max_enrl as "Max Enrl",
       ssbsect_enrl as "Actual Enrl"
from ssbsect
where  ssbsect_term_code = '&Term'
--and    ssbsect_ptrm_code = '&Ptrm_Code'
and    ssbsect_ssts_code = 'A'
and    ssbsect_ptrm_start_date >= '&DATE' -- after census date courses
order by ssbsect_subj_code,ssbsect_crse_numb,ssbsect_seq_numb;