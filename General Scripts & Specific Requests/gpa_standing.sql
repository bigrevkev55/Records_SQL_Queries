--overall gpa is over the minimum and standing is probation or suspension
select spriden_id as "A Number"
,      spriden_last_name as "Last Name"
,      spriden_first_name as "First Name"
,      shrttrm_astd_code_end_of_term as "Standing"
,      shrlgpa_gpa_hours as "Cumulative GPA Hours"
,      shrlgpa_gpa as "Cumulative GPA"
,      shrlgpa_levl_code as "Cumulative GPA Level"
,      tgpa_hours as "Term GPA Hours"
,      tgpa_gpa as "Term GPA"
from shrttrm s
,    shrlgpa
,    spriden
,    (select shrtgpa_pidm as tgpa_pidm
     ,      shrtgpa_gpa_hours as tgpa_hours
     ,      shrtgpa_gpa as tgpa_gpa
     from shrtgpa
     where shrtgpa_term_code = '202080'
     and shrtgpa_gpa_type_ind = 'I')
where shrttrm_term_code = '202080'
and spriden_pidm = shrttrm_pidm
and spriden_change_ind is null
and tgpa_pidm (+) = shrttrm_pidm
and shrttrm_astd_code_end_of_term in (select stvastd_code
                                      from stvastd
                                      where stvastd_probation_ind = 'Y')
and shrlgpa_pidm = shrttrm_pidm
and shrlgpa_gpa_type_ind = 'O'
and (  (shrlgpa_gpa_hours > 14 and shrlgpa_gpa_hours <=26 and shrlgpa_gpa >= 1)
    or (shrlgpa_gpa_hours > 26 and shrlgpa_gpa_hours <=40 and shrlgpa_gpa >= 1.4)
    or (shrlgpa_gpa_hours > 40 and shrlgpa_gpa_hours <=48 and shrlgpa_gpa >= 1.7)
    or (shrlgpa_gpa_hours > 48 and shrlgpa_gpa_hours <=56 and shrlgpa_gpa >= 1.9)
    or (shrlgpa_gpa_hours > 56  and shrlgpa_gpa >= 2))
union
--overall gpa is below the minimum and standing is normal
select spriden_id as "A Number"
,      spriden_last_name as "Last Name"
,      spriden_first_name as "First Name"
,      shrttrm_astd_code_end_of_term as "Standing"
,      shrlgpa_gpa_hours as "Cumulative GPA Hours"
,      shrlgpa_gpa as "Cumulative GPA"
,      shrlgpa_levl_code as "Cumulative GPA Level"
,      tgpa_hours as "Term GPA Hours"
,      tgpa_gpa as "Term GPA"
from shrttrm s
,    shrlgpa
,    spriden
,    (select shrtgpa_pidm as tgpa_pidm
     ,      shrtgpa_gpa_hours as tgpa_hours
     ,      shrtgpa_gpa as tgpa_gpa
     from shrtgpa
     where shrtgpa_term_code = '202080'
     and shrtgpa_gpa_type_ind = 'I')
where shrttrm_term_code = '202080'
and spriden_pidm = shrttrm_pidm
and spriden_change_ind is null
and tgpa_pidm (+) = shrttrm_pidm
and shrttrm_astd_code_end_of_term in (select stvastd_code
                                      from stvastd
                                      where stvastd_probation_ind = 'N')
and shrlgpa_pidm = shrttrm_pidm
and shrlgpa_gpa_type_ind = 'O'
and (  (shrlgpa_gpa_hours > 14 and shrlgpa_gpa_hours <=26 and shrlgpa_gpa < 1)
    or (shrlgpa_gpa_hours > 26 and shrlgpa_gpa_hours <=40 and shrlgpa_gpa < 1.4)
    or (shrlgpa_gpa_hours > 40 and shrlgpa_gpa_hours <=48 and shrlgpa_gpa < 1.7)
    or (shrlgpa_gpa_hours > 48 and shrlgpa_gpa_hours <=56 and shrlgpa_gpa < 1.9)
    or (shrlgpa_gpa_hours > 56  and shrlgpa_gpa < 2))
union
--overall is below minimum, term is over 2.0, and status is suspended
select spriden_id as "A Number"
,      spriden_last_name as "Last Name"
,      spriden_first_name as "First Name"
,      shrttrm_astd_code_end_of_term as "Standing"
,      shrlgpa_gpa_hours as "Cumulative GPA Hours"
,      shrlgpa_gpa as "Cumulative GPA"
,      shrlgpa_levl_code as "Cumulative GPA Level"
,      tgpa_hours as "Term GPA Hours"
,      tgpa_gpa as "Term GPA"
from shrttrm s
,    shrlgpa
,    spriden
,    (select shrtgpa_pidm as tgpa_pidm
     ,      shrtgpa_gpa_hours as tgpa_hours
     ,      shrtgpa_gpa as tgpa_gpa
     from shrtgpa
     where shrtgpa_term_code = '202080'
     and shrtgpa_gpa_type_ind = 'I')
where shrttrm_term_code = '202080'
and spriden_pidm = shrttrm_pidm
and spriden_change_ind is null
and tgpa_pidm (+) = shrttrm_pidm
and shrttrm_astd_code_end_of_term in ('4S','2S','3S','SU')
and shrlgpa_pidm = shrttrm_pidm
and shrlgpa_gpa_type_ind = 'O'
and (  (shrlgpa_gpa_hours > 14 and shrlgpa_gpa_hours <=26 and shrlgpa_gpa < 1)
    or (shrlgpa_gpa_hours > 26 and shrlgpa_gpa_hours <=40 and shrlgpa_gpa < 1.4)
    or (shrlgpa_gpa_hours > 40 and shrlgpa_gpa_hours <=48 and shrlgpa_gpa < 1.7)
    or (shrlgpa_gpa_hours > 48 and shrlgpa_gpa_hours <=56 and shrlgpa_gpa < 1.9)
    or (shrlgpa_gpa_hours > 56  and shrlgpa_gpa < 2))
and (nvl(tgpa_hours,0) <> 0 and tgpa_gpa >= 2);