--Author:  Kevin Thomas, Registrar
--Date:    21-JUL-2022
--Purpose: This script attempts to find DE students that have the DUAL Rate on their max SGASTDN Term




--desc sgbstdn;

select spriden_id as "A Number",
       spriden_last_name as "Last",
       spriden_first_name as "First",
       SGBSTDN_TERM_CODE_EFF as "Max SGASTDN Effective Term",
       sgbstdn_rate_code as "Rate Code",
       sgbstdn_admt_code as "Admit Code",
       sgbstdn_program_1 as "Program Code"

from spriden, sgbstdn outter

Where spriden_pidm = sgbstdn_pidm
      and spriden_change_ind is NULL
      and spriden_pidm in (select distinct sfrstcr_pidm from sfrstcr where sfrstcr_term_code = :Term)
      and sgbstdn_rate_code = 'DUAL'
      and sgbstdn_term_code_eff = (select max(sgbstdn_term_code_eff) from sgbstdn i where outter.sgbstdn_pidm = i.sgbstdn_pidm)
      order by spriden_last_name, spriden_first_name;