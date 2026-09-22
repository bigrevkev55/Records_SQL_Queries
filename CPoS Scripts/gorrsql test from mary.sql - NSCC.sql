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
		and (c.SGBSTDN_MAJR_CODE_CONC_1 in ('UAC','UBIO','UBA','UCH','UCE','UCS','UECL','UEE','UFIN','UIS','UMNG','UMKT',
		'UMTH','UME','UNFS','UPHY','UPHP','UPOT','UPPT','USEM','SUCH','ASTC','BIED','CHED','HTSC')
		or c.SGBSTDN_MAJR_CODE_CONC_1_2 in ('UAC','UBIO','UBA','UCH','UCE','UCS','UECL','UEE','UFIN','UIS','UMNG','UMKT',
		'UMTH','UME','UNFS','UPHY','UPHP','UPOT','UPPT','USEM','SUCH','ASTC','BIED','CHED','HTSC')
		or c.sgbstdn_program_1 in ('AAS_ADTH','AAS_CCEN','AAS_ECED','CERT_ARDT','CERT_CCTE')
		or c.sgbstdn_program_2 in ('AAS_ADTH','AAS_CCEN','AAS_ECED','CERT_ARDT','CERT_CCTE')) 
		) OR
--MATH 1710
		((ssbsect_subj_code = 'MATH' and ssbsect_crse_numb ='1710') 
		and (c.SGBSTDN_MAJR_CODE_CONC_1 in ('UCH','UPOT','UPPT','BIED')
		or c.SGBSTDN_MAJR_CODE_CONC_1_2 in ('UCH','UPOT','UPPT','BIED'))
		) OR
--MATH 1130,1710
		((ssbsect_subj_code = 'MATH' and ssbsect_crse_numb IN ('1130','1710'))
		and (c.SGBSTDN_MAJR_CODE_CONC_1 in ('UECL','UPHP')
		or c.SGBSTDN_MAJR_CODE_CONC_1_2 in ('UECL','UPHP'))
		) OR
--MATH 1710,1730
		((ssbsect_subj_code = 'MATH' and ssbsect_crse_numb IN ('1710','1730'))
		and (c.SGBSTDN_MAJR_CODE_CONC_1 in ('UBIO')
		or c.SGBSTDN_MAJR_CODE_CONC_1_2 in ('UBIO'))
		) OR
--MATH 1720,1730
		((ssbsect_subj_code = 'MATH' and ssbsect_crse_numb IN ('1720','1730'))
		and (c.SGBSTDN_MAJR_CODE_CONC_1 in ('UCE','UCS','UEE','UMTH','UME','UPHY','USEM','ASTC','CHED')
		or c.SGBSTDN_MAJR_CODE_CONC_1_2 in ('UCE','UCS','UEE','UMTH','UME','UPHY','USEM','ASTC','CHED'))
		)
	)
		
