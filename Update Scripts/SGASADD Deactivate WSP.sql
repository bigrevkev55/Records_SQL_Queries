insert into sgrsatt (SGRSATT_PIDM, SGRSATT_TERM_CODE_EFF, SGRSATT_ATTS_CODE, SGRSATT_ACTIVITY_DATE) 
(select distinct sfrstcr_pidm,sfrstcr_term_code,NULL,SYSDATE
from   sfrstcr, sgbstdn a, spriden, sgrsatt
where  sfrstcr_pidm = a.sgbstdn_pidm
and    sfrstcr_pidm = spriden_pidm
and    sfrstcr_pidm = sgrsatt_pidm
and    spriden_change_ind is null
and    sfrstcr_term_code = &term
and    a.sgbstdn_term_code_eff = (select max(b.sgbstdn_term_code_eff) from sgbstdn b
                                where  b.sgbstdn_pidm = a.sgbstdn_pidm)
and   (sgbstdn_program_1 not like 'NON_DEGREE'
       and sgbstdn_program_1 not like 'CERT%'
       and sgbstdn_program_1 not like 'NDCT%'
       and sgbstdn_program_1 not like 'CE%'
      )
-- and has active attribute codes
and   sfrstcr_pidm in (select sgrsatt_pidm from sgrsatt
                       where  sgrsatt_atts_code = 'WSP'
                       and    sgrsatt_pidm  not in (select x.sgrsatt_pidm from sgrsatt x
                                                    where  x.sgrsatt_atts_code is null)
                       and    sgrsatt_pidm  not in (select y.sgrsatt_pidm from sgrsatt y
                                                    where  y.sgrsatt_pidm = sgrsatt_pidm
                                                    and    y.sgrsatt_term_code_eff = sfrstcr_term_code)
                      )
-- and don't include people who have an ATTS_CODE other than WSP
and   sfrstcr_pidm  not in (select sgrsatt_pidm from sgrsatt
                        where  sgrsatt_atts_code is not null
                        and    sgrsatt_atts_code != 'WSP'))
;
/