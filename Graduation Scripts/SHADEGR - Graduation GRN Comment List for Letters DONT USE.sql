--Script to pull GRNs by prompted term.  
--Must be ran in Sql Developer as a Script (F5) and not a statement
--Copy output into Notepad, save by removing the * and adding .txt.

set  serveroutput on size 1000000
declare
p_termcode varchar2(6) := &termcode;
v_one_comment varchar2(60); -- save one comment from the cursor
v_all_comment varchar2(1206); -- hold up to 10 lines of comments and blanks
v_student_id spriden.spriden_id%type;
v_last_name spriden.spriden_last_name%type;
v_first_name spriden.spriden_first_name%type;
v_street_1 spraddr.spraddr_street_line1%type;
v_street_2 spraddr.spraddr_street_line2%type;
v_city spraddr.spraddr_city%type;
v_state spraddr.spraddr_stat_code%type;
v_zip spraddr.spraddr_zip%type;
v_email goremal.goremal_email_address%type;
cursor c_student_data is
select distinct spriden_id
,      rtrim(spriden_last_name) as "Last Name"
,      rtrim(spriden_first_name) as "First Name"
,      spraddr_street_line1 as "Address1"
,      spraddr_street_line2 as "Address2"
,      spraddr_city as "City"
,      spraddr_stat_code as "State"
,      spraddr_zip as "Zip"
,     (select goremal_email_address
       from   goremal
       where  goremal_pidm = spriden_pidm
       and    goremal_emal_code = 'CAMP'
       and    goremal_status_ind = 'A'
       and    rownum = 1
       ) as "Email"
from   spriden
,      spraddr c
,      spbpers
,      shrdgmr
--,      shrdgcm
,     (select spraddr_pidm
       ,      min(spraddr_atyp_code) as minatyp 
       from   spraddr 
       where  spraddr_status_ind is null 
       and    spraddr_to_date is null
       and    spraddr_atyp_code in ('LO','PR')
       and    spraddr_pidm in (select distinct shrdgmr_pidm 
                               from   shrdgmr
                               where  shrdgmr_term_code_grad = p_termcode
                               and    shrdgmr_grst_code = 'GRN')
       group by spraddr_pidm) b
where  spriden_change_ind is null 
and    spbpers_pidm = spriden_pidm
and    spbpers_dead_ind is null
and    spriden_entity_ind='P' 
and    b.spraddr_pidm = c.spraddr_pidm
and    c.spraddr_pidm = spriden_pidm
and    c.spraddr_atyp_code = b.minatyp
and    c.spraddr_status_ind is null
and    c.spraddr_to_date is null
and    spriden_pidm = shrdgmr_pidm
--and    spriden_pidm = shrdgcm_pidm
and    shrdgmr_term_code_grad = p_termcode
and    shrdgmr_grst_code = 'GRN'
--and    shrdgcm_comment LIKE '*%'
--    Some students have multiple active addresses with the same address type
and   spraddr_seqno =
     (select  min(spraddr_seqno)
      from    spraddr
      where   spraddr_pidm = spriden_pidm
      and     spraddr_atyp_code = b.minatyp
      and     spraddr_status_ind is null
      and    (spraddr_to_date is null or trunc(spraddr_to_date) > trunc(sysdate)))
order by rtrim(spriden_last_name)
         ||    ' '
         ||rtrim(spriden_first_name)
;
cursor c_get_comment is
select shrdgcm_comment 
from   shrdgcm, spriden
where  spriden_id = v_student_id
and    shrdgcm_pidm = spriden_pidm
and    spriden_change_ind is null
and    shrdgcm_comment LIKE '*%'
order  by shrdgcm_seqno;
begin
-- Write a header for Excel
dbms_output.put_line('Student ID|Last Name|First Name|Address1|Address2|City|State|Zip|Email|Comment1|Comment2|Comment3|Comment4|Comment5|Comment6|Comment7|Comment8|Comment9|Comment10');
-- Opem the cursor for ID, name, address and email
open c_student_data;
loop
fetch c_student_data into v_student_id
,                         v_last_name
,                         v_first_name
,                         v_street_1
,                         v_street_2
,                         v_city
,                         v_state
,                         v_zip
,                         v_email;
exit when c_student_data %notfound;
-- Open the cursor for comments
open c_get_comment;
v_all_comment := ''; -- initialize the field
v_one_comment := ''; -- initialize the field
loop
fetch c_get_comment into v_one_comment;
exit  when c_get_comment%notfound;
v_all_comment := v_all_comment||'|'||v_one_comment;
end   loop;
close c_get_comment;
if substr(v_all_comment,2,1) = '*' then -- only print students with comments
dbms_output.put_line(v_student_id
||'|'||                   v_last_name
||'|'||                   v_first_name
||'|'||                   v_street_1
||'|'||                   v_street_2
||'|'||                   v_city
||'|'||                   v_state
||'|'||                   v_zip
||'|'||                   v_email
||                        v_all_comment);
end if;
end loop;
close c_student_data;
end;