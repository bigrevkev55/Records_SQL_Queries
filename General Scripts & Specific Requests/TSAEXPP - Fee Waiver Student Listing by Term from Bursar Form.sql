desc tbbestu;
select spriden_id AS "ID",
       spriden_last_name AS "Last_Name",
       spriden_first_name AS "First_Name",
       tbbestu_exemption_code AS "Exempt_Code",
       tbbestu_max_student_amount AS "Amount",
--       tbbestu_del_ind as "Delete Ind",
       tbbestu_exemption_priority AS "Exempt_Priority",
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