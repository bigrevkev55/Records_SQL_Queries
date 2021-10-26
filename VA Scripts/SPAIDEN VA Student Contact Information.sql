
--Author:  Kevin Thomas, Registrar
--Date:    21-OCT-2021
--Purpose: This query returns VA Students contact information by prompted term.
--         The output is intended to be used for Signal Vine texting system so
--         headings are named according to their standards.  


--desc sprtele

select spriden_id as "customer_id",
       spriden_last_name as "last_name",
       spriden_first_name as "first_name",
       GOREMAL_EMAIL_ADDRESS as "email",
       SGRVETN_TERM_CODE_VA  as "term",
       STVVETC_DESC as "va_type",
       SPRTELE_TELE_CODE   as "phone_type",
       --sprtele_status_ind as "Status",
       SPRTELE_PHONE_AREA || SPRTELE_PHONE_NUMBER as "phone"  
--desc sgrvetn;
--desc spriden;
from spriden, SGRVETN, stvvetc, goremal, sprtele
where spriden_pidm = sgrvetn_pidm
      and spriden_pidm = GOREMAL_PIDM(+)
      and spriden_pidm = sprtele_pidm(+)
      --and goremal_preferred_IND (+) = 'Y'
      and goremal_emal_code (+) = 'CAMP'
      and SGRVETN_VETC_CODE IS NOT NULL
      and SGRVETN_TERM_CODE_VA = :Term
      and stvvetc_code = sgrvetn_vetc_code
      and SPRIDEN_CHANGE_IND is NULL
      and sprtele_tele_code(+) = 'CE'
      and sprtele_status_ind is NULL
      
Order by spriden_last_name, spriden_first_name;