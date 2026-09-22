select 'Y' 
from scrlevl a 
where a.scrlevl_levl_code = 'DS' 
	and a.scrlevl_subj_code = :SUBJ_CODE 
	and a.scrlevl_crse_numb = :CRSE_NUMB 
	and a.scrlevl_eff_term = 
	(select max(b.scrlevl_eff_term) 
	from scrlevl b 
		where b.scrlevl_levl_code = 'DS' 
		and b.scrlevl_crse_numb = a.scrlevl_crse_numb 
		and b.scrlevl_subj_code = a.scrlevl_subj_code 
		and b.scrlevl_eff_term <= :TERM_CODE) 
UNION
--Hidden Prerequisite Courses
 
select 'Y' 
from sgbstdn c, ssbsect, sfrstcr
where ssbsect_crn=sfrstcr_crn 
	and ssbsect_term_code=sfrstcr_term_code 
	and ssbsect_crn=sfrstcr_crn 
	and ssbsect_ptrm_code=sfrstcr_ptrm_code 
	and ssbsect_subj_code = :SUBJ_CODE 
	and ssbsect_crse_numb = :CRSE_NUMB 
	and ssbsect_term_code = :TERM_CODE 
	and sfrstcr_pidm = c.sgbstdn_pidm 
	and sfrstcr_pidm = :CPOS_PIDM 
	and c.sgbstdn_term_code_eff=
	(select max(d.sgbstdn_term_code_eff) 
		from sgbstdn d
			where c.sgbstdn_pidm=d.sgbstdn_pidm 
			and d.sgbstdn_term_code_eff <= :TERM_CODE) 
	and
	(
--MATH 1000
		((ssbsect_subj_code = 'MATH' and ssbsect_crse_numb = '1000')
		and (c.SGBSTDN_MAJR_CODE_CONC_1 in ('UAC','UECL','UPHY','UBIO','UEE')
		or c.SGBSTDN_MAJR_CODE_CONC_1 in ('UAC','UECL','UPHY','UBIO','UEE')) 
		) OR
--MATH 1200,1720
		((ssbsect_subj_code = 'MATH' and ssbsect_crse_numb IN ('1200','1720'))
		and (c.sgbstdn_program_1 in ()
		or c.sgbstdn_program_2 in ())
		) OR
--CHEM 1010,1110
		((ssbsect_subj_code = 'CHEM' and ssbsect_crse_numb IN ('1010','1110')) 
		and (c.sgbstdn_program_1 in ()
		or c.sgbstdn_program_2 in (
))
		) OR
--MATH 1630,1710
		((ssbsect_subj_code = 'MATH' and ssbsect_crse_numb IN ('1630','1710')) 
		and (c.sgbstdn_program_1 in ()
		or c.sgbstdn_program_2 in ())		
		) OR
--MATH 1710, 1720, 1730
		((ssbsect_subj_code = 'MATH' and ssbsect_crse_numb IN ('1710','1720','1730')) 
		and (c.sgbstdn_program_1 in ()
		or c.sgbstdn_program_2 in ())
		) OR
--MATH 1710, 1720, 1730, 1830
		((ssbsect_subj_code = 'MATH' and ssbsect_crse_numb IN ('1710','1720','1730','1830')) 
		and (c.sgbstdn_program_1 in ()
		or c.sgbstdn_program_2 in ()) 
		) OR
--MATH 1710
		((ssbsect_subj_code = 'MATH' and ssbsect_crse_numb ='1710') 
		and (c.sgbstdn_program_1 = ''
		or c.sgbstdn_program_2 = '')
		)
	)
		
