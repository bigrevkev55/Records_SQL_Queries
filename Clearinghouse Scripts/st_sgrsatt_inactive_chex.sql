------------------------------------------------------------------------------------------------------------------
-- SQL script to inactivate the CHEX attribute for all students who currently have it.
--   Current attributes are those which are found on the highest term for a student on SGRSATT
--   We inactivate them here in one of 3 ways:
--          Copy existing attributes other than CHEX forward to the parameter term if such attributes existing
--          Insert a null attribute code for the paramter term if no other active attributes existing
--          Update the CHEX record to contain a null attribute code if it is effective for the parameter term
--
-- Parameters: Effective term for which to end the attribute
--
-- Module History:
-- created 06/25/2019 by Chuck Hackney
--
------------------------------------------------------------------------------------------------------------------
--carry existing attributes forward for people who have CHEX and other attributes in their highest attribute term.
insert into sgrsatt (sgrsatt_pidm, sgrsatt_term_code_eff, sgrsatt_atts_code, sgrsatt_activity_date)
(select distinct sgrsatt_pidm
 ,               '&term'
 ,               sgrsatt_atts_code
 ,               sysdate
 from sgrsatt s
 where sgrsatt_atts_code <> 'CHEX'
 and sgrsatt_term_code_eff = (select max(sgrsatt_term_code_eff)
                              from sgrsatt
                              where sgrsatt_pidm = s.sgrsatt_pidm
                              and sgrsatt_term_code_eff <= '&term')
 and sgrsatt_term_code_eff <> '&term'
 and exists (select 'x'
             from sgrsatt
             where sgrsatt_pidm = s.sgrsatt_pidm
             and sgrsatt_term_code_eff = s.sgrsatt_term_code_eff
             and sgrsatt_atts_code = 'CHEX'));
--insert null attribute for people who have only CHEX in their highest attribute term.
insert into sgrsatt (sgrsatt_pidm, sgrsatt_term_code_eff, sgrsatt_atts_code, sgrsatt_activity_date)
 (select distinct sgrsatt_pidm
 ,               '&term'
 ,               null
 ,               sysdate
 from sgrsatt s
 where sgrsatt_atts_code = 'CHEX'
 and sgrsatt_term_code_eff = (select max(sgrsatt_term_code_eff)
                              from sgrsatt
                              where sgrsatt_pidm = s.sgrsatt_pidm
                              and sgrsatt_term_code_eff <= '&term')
 and sgrsatt_term_code_eff <> '&term'
 and not exists (select 'x'
                 from sgrsatt
                 where sgrsatt_pidm = s.sgrsatt_pidm
                 and sgrsatt_term_code_eff = s.sgrsatt_term_code_eff
                 and sgrsatt_atts_code <> 'CHEX'));
--update CHEX attribute to null for parameter term
update sgrsatt  set sgrsatt_atts_code = null
where sgrsatt_atts_code = 'CHEX'
and sgrsatt_term_Code_eff = '&term';
commit;
/
