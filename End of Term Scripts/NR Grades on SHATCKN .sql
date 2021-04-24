--Author: Kevin Thomas (Edited from MTSU Missing Grades Script)
--Date:  12.24.2018
--Purpose:  This query will show students who have an NR grade that has not been changed.  Update term as needed.  


select count (distinct a.shrtckg_grde_code_final) sequence_number,
             spriden_id id,
             spriden_Last_name as "Last Name",
             spriden_First_Name as "First Name",
             a.SHRTCKN_CRN,
             a.shrtckn_subj_code subj, 
             a.shrtckn_crse_numb numb,
             a.shrtckn_term_code term
from spriden, SHRTCKG a, SHRTCKN a, scbcrse
where a.shrtckn_pidm = spriden_pidm
and a.shrtckn_pidm = shrtckg_pidm
and scbcrse_subj_code = a.shrtckn_subj_code
and scbcrse_crse_numb = a.shrtckn_crse_numb
and shrtckn_crn = a.shrtckn_crn
and shrtckn_term_code = :Term
and scbcrse_max_rpt_units  IS NULL
and a.shrtckn_repeat_course_ind is null
and a.shrtckn_term_code = shrtckg_term_code 
and a.shrtckn_seq_no = shrtckg_tckn_seq_no
and spriden_change_ind is NULL
and a.SHRTCKG_SEQ_NO =
(select max(b.SHRTCKG_SEQ_NO )
   from shrtckg B
  where b.shrtckg_pidm = a.shrtckg_pidm
      and b.shrtckg_tckn_seq_no = a.shrtckg_tckn_seq_no
      and b.shrtckg_term_code = a.shrtckg_term_code
      and a.SHRTCKG_GRDE_CODE_FINAL  
         in ('NR'))
group by spriden_id, a.shrtckn_subj_code, a.shrtckn_crse_numb, a.shrtckn_crn, spriden_Last_name, 
a.shrtckn_term_code, spriden_First_Name

having count (distinct a.shrtckg_grde_code_final) < 2
order by a.shrtckn_crn, a.shrtckn_subj_code, a.shrtckn_crse_numb, SPRIDEN_ID;





