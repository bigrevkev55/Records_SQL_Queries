select	sgbstdn_majr_code_1,
	sgbstdn_dept_code,
	count(*)
from	sgbstdn s
where	sgbstdn_term_code_eff = 
	(
		select	max(sgbstdn_term_code_eff)
		from	sgbstdn
		where	sgbstdn_pidm = s.sgbstdn_pidm
	)
and	sgbstdn_pidm in
	(
		select	sfrstcr_pidm
		from	sfrstcr
		where	sfrstcr_term_code in ('202010','202050','202080')
		and	sfrstcr_rsts_code like 'R%'
	)
group by sgbstdn_majr_code_1, sgbstdn_dept_code
order by 1,2;
