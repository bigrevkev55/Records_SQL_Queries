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
		and (c.sgbstdn_program_1 in ('UARS_AA','UENG_AA','UFL_AA','UHST_AA','UPAA_UPAA','UAC_AS',
			'UAB_AS','UAS_AS','AUDP_UPAS','UBIO_AS','UBA_AS','UCH_AS','UCE_AS','CANM_UPAS',
			'UCJ_AS','ECE_UPAS','UECB_AS','EDUC_UPAS','UEE_AS','UEX_AS','UFIN_AS','GRDS_UPAS',
			'UHST_AS','UIS_AS','UKI_AS','UMNG_AS','UMKT_AS','UMC_AS','UMTH_AS','UME_AS','UPHY_AS',
			'UPS_AS','MATC_UPAS','DEHY_UPAS','UPHP_AS','LAW_UPAS','PMTE_UPAS','UPOT_AS','UPPT_AS',
			'USCM_AS','UPAS_UPAS','BSOC_APT','CHOP_CHET','CCLD_MCIT','CCYB_MCIT','CDAD_MEST',
			'EETE','ELCM','LABT_CHET','LGOC_APT','MECH','MDA','MDOC_APT','CPM_MEST','TAD','TCT',
			'CNC','TEMF','ELCF','TMD','TMMF','ML1','PLMB','TTE') 
		or c.sgbstdn_program_2 in ('UARS_AA','UENG_AA','UFL_AA','UHST_AA','UPAA_UPAA','UAC_AS',
			'UAB_AS','UAS_AS','AUDP_UPAS','UBIO_AS','UBA_AS','UCH_AS','UCE_AS','CANM_UPAS',
			'UCJ_AS','ECE_UPAS','UECB_AS','EDUC_UPAS','UEE_AS','UEX_AS','UFIN_AS','GRDS_UPAS',
			'UHST_AS','UIS_AS','UKI_AS','UMNG_AS','UMKT_AS','UMC_AS','UMTH_AS','UME_AS','UPHY_AS',
			'UPS_AS','MATC_UPAS','DEHY_UPAS','UPHP_AS','LAW_UPAS','PMTE_UPAS','UPOT_AS','UPPT_AS',
			'USCM_AS','UPAS_UPAS','BSOC_APT','CHOP_CHET','CCLD_MCIT','CCYB_MCIT','CDAD_MEST',
			'EETE','ELCM','LABT_CHET','LGOC_APT','MECH','MDA','MDOC_APT','CPM_MEST','TAD','TCT',
			'CNC','TEMF','ELCF','TMD','TMMF','ML1','PLMB','TTE')) 
		) OR
--MATH 1200,1720
		((ssbsect_subj_code = 'MATH' and ssbsect_crse_numb IN ('1200','1720'))
		and (c.sgbstdn_program_1 in ('UPHP_AS','UPPT_AS')
		or c.sgbstdn_program_2 in ('UPHP_AS','UPPT_AS'))
		) OR
--CHEM 1010,1110
		((ssbsect_subj_code = 'CHEM' and ssbsect_crse_numb IN ('1010','1110')) 
		and (c.sgbstdn_program_1 in ('UARS_AA','UENG_AA','UFL_AA','UHST_AA','UPAA_UPAA','UAC_AS',
		'AHS_UPAS','AUDP_UPAS','UBA_AS','USPC_AS','CANM_UPAS','UCJ_AS','ECE_UPAS','UECB_AS',
		'EDUC_UPAS','UEX_AS','UFIN_AS','GRDS_UPAS','UHST_AS','UIS_AS','UMNG_AS','UMKT_AS','UMTH_AS',
		'UPS_AS','MATC_UPAS','DEHY_UPAS','LAW_UPAS','UPOT_AS','UPPT_AS','SW_UPAS','USOC_AS','SLM_UPAS',
		'USCM_AS','UPAS_UPAS','CCLD_MCIT','CCYB_MCIT', 'LENF','MDA','NUR','PARA')
		or c.sgbstdn_program_2 in ('UARS_AA','UENG_AA','UFL_AA','UHST_AA','UPAA_UPAA','UAC_AS',
		'AHS_UPAS','AUDP_UPAS','UBA_AS','USPC_AS','CANM_UPAS','UCJ_AS','ECE_UPAS','UECB_AS','EDUC_UPAS',
		'UEX_AS','UFIN_AS','GRDS_UPAS','UHST_AS','UIS_AS','UMNG_AS','UMKT_AS','UMTH_AS','UPS_AS',
		'MATC_UPAS','DEHY_UPAS','LAW_UPAS','UPOT_AS','UPPT_AS','SW_UPAS','USOC_AS','SLM_UPAS','USCM_AS',
		'UPAS_UPAS', 'CCLD_MCIT','CCYB_MCIT', 'LENF','MDA','NUR','PARA'))
		) OR
--MATH 1630,1710
		((ssbsect_subj_code = 'MATH' and ssbsect_crse_numb IN ('1630','1710')) 
		and (c.sgbstdn_program_1 in ('UAS_AS','UAB_AS','PMTE_UPAS')
		or c.sgbstdn_program_2 in ('UAS_AS','UAB_AS','PMTE_UPAS'))		
		) OR
--MATH 1710, 1720, 1730
		((ssbsect_subj_code = 'MATH' and ssbsect_crse_numb IN ('1710','1720','1730')) 
		and (c.sgbstdn_program_1 in ('UBIO_AS','UCH_AS','UEE_AS','UMTH_AS','UME_AS', 'UPHY_AS',
		'MATC_AS','UPHP_AS','PMTE_UPAS')
		or c.sgbstdn_program_2 in ('UBIO_AS','UCH_AS','UEE_AS','UMTH_AS','UME_AS', 'UPHY_AS',
		'MATC_AS','UPHP_AS','PMTE_UPAS'))
		) OR
--MATH 1710, 1720, 1730, 1830
		((ssbsect_subj_code = 'MATH' and ssbsect_crse_numb IN ('1710','1720','1730','1830')) 
		and (c.sgbstdn_program_1 in ('UCE_AS','UKI_AS')
		or c.sgbstdn_program_2 in ('UCE_AS','UKI_AS')) 
		) OR
--MATH 1710
		((ssbsect_subj_code = 'MATH' and ssbsect_crse_numb ='1710') 
		and (c.sgbstdn_program_1 = 'UPOT_AS'
		or c.sgbstdn_program_2 = 'UPOT_AS')
		)
	)
		
