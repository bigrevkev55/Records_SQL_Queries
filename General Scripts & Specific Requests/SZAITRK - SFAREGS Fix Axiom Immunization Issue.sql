--Author: Kevin Thomas, Director of Admissions/Registrar
--Date:   20-OCT-2023
--Purpose: This query returns students that have registration in SFAREGS/SFRSTCR
--         but do not have HEPB marked as either received, refused, parent approved, or waived
--         on SZAITRK/SZRITRK.  This causes the immunization error message on SFAREGS when trying to 
--         adjust these students registration in SFAREGS.  

--Note:   This query is only looking at registration from 202380 and forward as this issue is the 
--        result of an Axiom process glitch that began in 202380.  This issue should be fixed eventually and then
--        this report will become obsolete.  


--desc szritrk;
--desc sfrstcr;
--desc szbitrk;


SELECT spriden_id A_NUMBER, spriden_last_name Last, spriden_first_name First, SZRITRK_USER_ID SZAITRK_USER_ID
from szritrk 
join spriden on szritrk_pidm = spriden_pidm
--inner join szbitrk on szritrk_pidm = szbitrk_pidm
where SZRITRK_pidm in (Select distinct sfrstcr_pidm from sfrstcr where sfrstcr_term_code > = '202380' and sfrstcr_bill_hr > '0')
      and spriden.spriden_change_ind is NULL
      and szritrk_immz_code = 'HEPB'
      and SZRITRK_RECEIVED_IND <> 'Y'
      and SZRITRK_REFUSED_IND  <> 'Y' 
      and SZRITRK_PARENT_APPROVED_IND <> 'Y'
      and SZRITRK_PROOF_WAIVED_IND <> 'Y'
      and szritrk.szritrk_proof_receive_date is NULL
      
order by spriden_last_name, spriden_first_name;









