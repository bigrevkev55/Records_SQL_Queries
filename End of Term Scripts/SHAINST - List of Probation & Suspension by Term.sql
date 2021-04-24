select spriden_id,
       spriden_last_name,
       spriden_first_name,
       shrttrm_astd_code_end_of_term
from shrttrm,spriden
where spriden_change_ind IS NULL
and   spriden_pidm = shrttrm_pidm
and   shrttrm_term_code = :Term
--and   shrttrm_term_code IN ('201210','201250','201280')
and   shrttrm_astd_code_end_of_term <> '00'
--and   shrttrm_astd_code_end_of_term = :ASTD_Code
ORDER BY shrttrm_astd_code_end_of_term,spriden_last_name;