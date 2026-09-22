set serveroutput on
DECLARE
v_pidm number;
v_id spriden.spriden_id%type;
v_name varchar2(120);
v_date sfrstcr.sfrstcr_rsts_date%type;
v_term varchar2(10) := '&term';
cursor c_students is
select distinct  spriden_pidm
      ,spriden_id
      ,spriden_last_name ||', '||spriden_first_name
from spriden
,    sfbetrm s
where exists(select 'x'
             from sfrstcr 
             where (sfrstcr_rsts_code like 'W%' or sfrstcr_rsts_code like 'D%' )
             and sfrstcr_rsts_code <> 'WL'
             and sfrstcr_term_code = v_term
             and sfrstcr_pidm = s.sfbetrm_pidm)
and not exists (select 'x'
                from sfrstcr c
                where  (sfrstcr_rsts_code like 'R%' or sfrstcr_rsts_code like 'U%' or sfrstcr_rsts_code like 'A%')
                and sfrstcr_term_code = v_term
                and sfrstcr_pidm = s.sfbetrm_pidm
                and not exists (select 'x'
                                from szratnd
                                where szratnd_last_attend is not null
                                and szratnd_crn = c.sfrstcr_crn
                                and szratnd_term_code = c.sfrstcr_term_code
                                and szratnd_pidm = c.sfrstcr_pidm))
and sfbetrm_ests_code = 'EL'
and spriden_pidm = sfbetrm_pidm
and sfbetrm_term_code = v_term
and spriden_change_ind is null;
BEGIN
open c_students;
loop
    fetch c_students into v_pidm, v_id, v_name;
    exit when c_students%notfound;
    select max (ddate) into v_date from (select max(szratnd_last_attend) as ddate
                                         from szratnd
                                         where szratnd_pidm = v_pidm
                                         and szratnd_term_code = v_term
                                         union
                                         select max(sfrstcr_rsts_date) as ddate
                                         from sfrstcr
                                         where sfrstcr_pidm = v_pidm
                                         and sfrstcr_term_code = v_term
                                         and sfrstcr_rsts_code like 'W%'
                                         and sfrstcr_rsts_code <> 'WL');
    update sfbetrm
    set sfbetrm_ests_code = 'WD'
       ,sfbetrm_ests_date = v_date
    where sfbetrm_pidm = v_pidm
    and sfbetrm_term_code = v_term
    and sfbetrm_ests_code = 'EL';
    dbms_output.put_line(v_id||'  '||to_char(v_date)||'  '||v_name);
end loop;
commit;
end;
/