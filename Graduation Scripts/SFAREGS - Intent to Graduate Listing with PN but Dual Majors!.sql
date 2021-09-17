select spriden_id as "ID",
       spriden_last_name as "Last Name",
       spriden_first_name as "First Name",
       sgbstdn_term_code_eff as "Eff Term",
       sgbstdn_stst_code as "Status Code",
       sgbstdn_degc_code_1 as "Degree 1",
       sgbstdn_majr_code_1 as "Major 1",
       sgbstdn_majr_code_conc_1 as "Conc 1" ,
       sgbstdn_degc_code_2 as "Degree 2",
       sgbstdn_majr_code_2 as "Major 2",
       sgbstdn_majr_code_conc_2 as "Conc 2"
from spriden, sgbstdn
where spriden_change_ind IS NULL
and   spriden_pidm = sgbstdn_pidm
and   sgbstdn_term_code_eff = :Term
and   sgbstdn_stst_code = 'PN'
and   sgbstdn_majr_code_2 IS NOT NULL
order by spriden_last_name,spriden_first_name;