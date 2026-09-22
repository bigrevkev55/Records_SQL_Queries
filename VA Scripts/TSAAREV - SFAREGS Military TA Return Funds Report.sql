--Author:  Kevin Thomas, Registrar
--Date:    12-DEC-2021
--Purpose: This query is to inform the Bursar Office if funds need to be returned for 
--         students that are using Military TA, based on the DOD MoU
--Edits:   switched the script from looking at the temporary registration table (SFTREGS) to the permant
--         registration table (SFRSTCR)



--desc tbraccd;
--desc sftregs;

select sfrstcr_TERM_CODE as "Term",
       spriden_id as "A Number",
       spriden_last_name as "Last", 
       spriden_first_name as "First",
       sfrstcr_crn as "CRN",
       sfrstcr_BILL_HR as "Bill Hours",
       sfrstcr_RSTS_CODE as "Registration Code",
       case when sfrstcr_rsts_code like 'D%'  then 'Dropped'
            when sfrstcr_rsts_code like 'R%' then 'Registered'
            when sfrstcr_rsts_code like 'W%' then 'Withdrawn'
            else 'Other'
            end as "Registration Status",
       case when sfrstcr_RSTS_CODE like 'D%' then 'Yes'  --only looking for drops because withdrawals don't require $ to be returned
       end as "TA Funds to be Returned?"
from spriden,sfrstcr--, tbraccd 
where --spriden_change_ind is NULL
      --and tbraccd_pidm = spriden_pidm
      --and tbraccd_term_code = '202180'
      --and 
      spriden_pidm in (select distinct tbraccd_pidm 
                            from TBRACCD 
                            where tbraccd_term_code = :Term
                            and TBRACCD_Detail_code in('T094', 'T110', 'T148', 'T437', 'T436'))
     and spriden_change_ind is NULL
     and sfrstcr_term_code=:Term
     and sfrstcr_pidm = spriden_pidm
order by spriden_last_name, spriden_first_name;
