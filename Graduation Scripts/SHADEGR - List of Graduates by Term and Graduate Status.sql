
-- Created By: Kevin Thomas, Assistant Registrar
--       Date: January 11, 2018
--    Purpose: Pulls a list of graduated for a prompted term and graduate status code.
select spriden_id as "ID",
       spriden_last_name as "Last Name",
       spriden_first_name as "First Name",
       shrdgmr_term_code_grad as "Grad Term",
       shrdgmr_degs_code as "Award Status",
       shrdgmr_grst_code as "Grad Code",
       shrdgmr_grad_date as "Grad Date",
       shrdgmr_acyr_code_bulletin as "Catalog",
       shrdgmr_program as "Program Code",
       shrdgmr_degc_code as "Degree",
       shrdgmr_majr_code_1 as "Major",
       shrdgmr_majr_code_conc_1 as "Conc",
       goremal_emal_code as Email,
       GOREMAL_EMAIL_ADDRESS as "NSCC Email"
       
from spriden,shrdgmr,goremal
where spriden_change_ind IS NULL
and   spriden_pidm = shrdgmr_pidm
and   shrdgmr_term_code_grad = :Grad_Term
--and   shrdgmr_term_code_grad IN (:Term1,:Term2,:Term3)
--and   shrdgmr_term_code_grad IN ('201580','201610','201650')
--and   shrdgmr_grst_code = 'GR'
--and   shrdgmr_grst_code = :Grad_Code
and   shrdgmr_grst_code IN ('GR','RTS')
and   shrdgmr_grst_code IS NOT NULL
--and   shrdgmr_program = :Program_Code
--and   shrdgmr_program = 'AAS_ECED'
and   shrdgmr_degc_code NOT IN ('ACRT1','ACRT2')
--and   shrdgmr_degc_code = :Degree
and spriden_pidm = GOREMAL_PIDM
and goremal_emal_code IN ('CAMP')--'PERS')
and   (goremal_status_ind IS NULL OR goremal_status_ind <> 'I')
order by spriden_last_name,spriden_first_name,shrdgmr_degc_code,shrdgmr_program;