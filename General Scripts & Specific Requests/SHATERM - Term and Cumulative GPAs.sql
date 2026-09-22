--Author:  Kevin Thomas, Registrar
--Date:    30-AUG-2026
--Purpose: This query seeks to return each students term GPA and Cumulative Graduation GPA


--desc shrtgpa;
--desc shrlgpa;

select
id.spriden_id as "Student ID",
id.spriden_last_name as "Last",
id.spriden_first_name as "First",
tgpa.shrtgpa_term_code as "GPA Term",
--tgpa.shrtgpa_levl_code as "GPA Level",
--tgpa.shrtgpa_gpa_type_ind as "GPA TYPE",
to_char (tgpa.shrtgpa_GPA, '0.00') as "Term GPA",

to_char (cgpa.SHRLGPA_GPA, '0.00') as "Cumulative GPA"

--tgpa
from 

--STUDENT SELECTION
(
    select spriden_pidm, spriden_id, spriden_last_name, spriden_first_name
    from spriden 
    where spriden_id= 'A00495006'
            and spriden_change_ind is NULL
)id

-- TERM GPA
left join (
    select shrtgpa.* 
    from shrtgpa   
    where shrtgpa_gpa_type_ind = 'C'
          and shrtgpa_GPA > 0 --has to have a least 1 hour factored into term GPA to be returned
) tgpa on tgpa.shrtgpa_pidm = id.spriden_pidm

-- Cumulative GPA
LEFT JOIN (
    SELECT SHRLGPA.* 
    FROM SHRLGPA
    WHERE SHRLGPA_LEVL_CODE = 'UG'
    AND SHRLGPA_GPA_TYPE_IND = 'O' -- NSCC and Transfer (graduation GPA)
    --AND lgpa.SHRLGPA_GPA_TYPE_IND = 'C' -- DE and UG NSCC (suspension GPA)
    --AND lgpa.SHRLGPA_GPA_TYPE_IND = 'I' -- UG NSCC (internal GPA)
) cgpa ON cgpa.SHRLGPA_PIDM = id.spriden_pidm   