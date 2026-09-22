--Author: Unknown
--Date:   Unknown
--Purpose: This query returns students who used a fee waiver with the Bursar's
--         office and need their registration code updated on SFAREGS for proper
--         reporting to TBR.  
--Edits:   Added "Registration Code" column which tells the user which registration
--         code to use on SFAREGS based on the exempt code column.  These codes can 
--         be fouund on SFARSTS...kt (NSCC Regsitrar)...12/21/2022.
--
--         Changed the sort order to the activity date (desc) to more easily identify 
--         second session students using the waiver...kt...10/29/2024
--
--         Reverted sort order back to Registration Code then last name for less 
--         human error when processing in SFAREGS...kt...9/9/2026


--desc tbbestu;
select spriden_id AS "ID",
       spriden_last_name AS "Last_Name",
       spriden_first_name AS "First_Name",
       tbbestu_exemption_code AS "Exempt_Code",
       CASE
       WHEN tbbestu_exemption_code = 1000 then 'R1'
       WHEN tbbestu_exemption_code = 1500 then 'R2'
       WHEN tbbestu_exemption_code = 800 then 'R3'
       WHEN tbbestu_exemption_code = 2300 then 'Enter WEPT on SGASADD'
       WHEN tbbestu_exemption_code = 2400 then 'No processing needed per Lance W note dated 8/31/15'
       ELSE 'SEE SFARSTS'
       End AS "Registration code",       
       tbbestu_max_student_amount AS "Amount",
--       tbbestu_del_ind as "Delete Ind",
--       tbbestu_exemption_priority AS "Exempt_Priority",
       tbbestu_user_id AS "User_ID",
       tbbestu_activity_date AS "Activity_Date"
from spriden,tbbestu
where spriden_change_ind IS NULL
and   spriden_pidm = tbbestu_pidm
and   tbbestu_term_code = :Term
and   tbbestu_exemption_code IN ('1000','800','1500','2300') -- 2400: No Coding Needed as TBR is looking at TSAEXPP
--and   tbbestu_exemption_code IN ('400','500') -- 400 = Audit; 500 = Credit
and   tbbestu_del_ind IS NULL
order by tbbestu_exemption_code,spriden_last_name,spriden_first_name;