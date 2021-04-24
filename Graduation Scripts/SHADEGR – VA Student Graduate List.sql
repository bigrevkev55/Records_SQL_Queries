-- Created By: Lance Woodard, Registrar
--      Date: December 16, 2014
--   Purpose: Provide a list of graduates/potential graduates who are VA Students.
--            Pormpts for VA Code and Graduation Term.
select DISTINCT spriden_ID      as "ID",
       spriden_last_name        as "Last Name",
       spriden_first_name       as "First Name",
       stvvetc_desc             as "Veteran Type",
       shrdgmr_term_code_grad   as "Grad Term",
       shrdgmr_grst_code        as "Grad Status",
       shrdgmr_degc_code        as "Degree",
--       stvdegc_desc             as "Degree Description",
       shrdgmr_majr_code_1      as "Major",
--       stvmajr_desc             as "Major Description",
       shrdgmr_majr_code_conc_1 as "Conc"
from spriden,sgrvetn,shrdgmr,stvvetc,stvmajr,stvdegc
where spriden_change_ind IS NULL
and   spriden_pidm = shrdgmr_pidm
and   shrdgmr_pidm = sgrvetn_pidm
--and   sgrvetn_vetc_code = :Veteran_Code
and   sgrvetn_vetc_code IS NOT NULL
and   sgrvetn_vetc_code = stvvetc_code
and   shrdgmr_degc_code = stvdegc_code
and   shrdgmr_majr_code_1 = stvmajr_code
--and   shrdgmr_majr_code_conc_1 = stvmajr_code
and   shrdgmr_term_code_grad = :Grad_Term
--and   shrdgmr_term_code_grad IN (:Grad_Term1,:Grad_Term2,:Grad_Term3)
--and   shrdgmr_term_code_grad = sgrvetn_term_code_va
and   shrdgmr_grst_code IN ('GR','RTS')
--and   shrdgmr_grst_code IS NOT NULL --GR for Graduated
and   shrdgmr_degc_code  NOT IN ('ACRT1','ACRT2') -- Exclude Academic Certificates
order by spriden_last_name,spriden_first_name;