--Script to find students reported as not engaged but have a grade other than FN
--DESC SZRATND;
--desc sfvstms
/*
This report attempts to find students whose reported grade for a class isn't    ----edited by Trey Dalton, Systems Analyst II 6.10.21
compatible with their reported engagement for that class i.e. they received 
an FN grade, but were marked as attending that class, or they have a B grade, 
and were marked as not attending.

added instructor last and first name -- 5.8.2023 Kevin Thomas, Registrar
added PoT prompt and prompt for LDA ---5.15.2024 Trey Dalton, TSD Systems Analyst II
added a filters to exclude AU grades and non FN, W grades that have "Stopped Attending"...12.19.2024
added an additional "or" in the Select area to look for grades of F with an LDA greater than the LDA date but used SFRSTCR instead of SFVSTMS ...kt...3.12.2025




VIP NOTE - This report was rewritten/reorganized by IR Director Derrick Dupuis in March 2025 to remove derived tables and clean up issues that
           had developed since creation...13-MAR-2025...kt

	- Adjusted by Derrick Dupuis (IR Director) to include FA grades and make the LDA date dynamic (instead of a prompt we had to remember).  He pulled the last date of the WV
          registration code on SFARSTS since that is the last day a student can withdraw each part of ter...3-JUN-2025...kt
           
           
VIP NOTE 2 - Per Jenn Byrd (FA Director) and Kerri L. (Assisant Director of FA) we can adjust FA grades with an LDA past the deadline 
             to an F since that is our policy...kt...31-MAY-2025

*/


SELECT REPLACE(atrm.STVTERM_DESC,'Term ','') AS TERM_DESC,
    sect.SSBSECT_PTRM_CODE AS COURSE_PTRM,
    iden.SPRIDEN_ID AS STUDENT_ID,
    iden.SPRIDEN_FIRST_NAME AS STUDENT_FIRST_NAME,
    iden.SPRIDEN_LAST_NAME AS STUDENT_LAST_NAME,
    sect.SSBSECT_CRN AS COURSE_CRN,
    sect.SSBSECT_SUBJ_CODE AS COURSE_SUBJECT,
    sect.SSBSECT_CRSE_NUMB AS COURSE_NUMBER,
    sect.SSBSECT_SEQ_NUMB AS COURSE_SECTION,
    chrt.SHRTCKG_GRDE_CODE_FINAL AS FINAL_GRADE,
    atnd.SZRATND_LAST_ATTEND AS LAST_DAY_ATTEND,
    atnd.SZRATND_ATTENDING_IND AS REPORTED_ENGAGEMENT,
    fidn.SPRIDEN_FIRST_NAME AS FACULTY_FIRST_NAME,
    fidn.SPRIDEN_LAST_NAME AS FACULTY_LAST_NAME,
    frsts.SFRRSTS_END_DATE AS LAST_DAY_TO_W_FOR_PoT
FROM (
-- Final Student Grades
    SELECT *
    FROM SHRTCKN
        LEFT JOIN SHRTCKG ON SHRTCKN_PIDM = SHRTCKG_PIDM
            AND SHRTCKN_TERM_CODE = SHRTCKG_TERM_CODE
            AND SHRTCKN_SEQ_NO = SHRTCKG_TCKN_SEQ_NO
            AND SHRTCKG_SEQ_NO = (
                SELECT MAX(bb.SHRTCKG_SEQ_NO)
                FROM SHRTCKG bb
                WHERE SHRTCKN_PIDM = bb.SHRTCKG_PIDM
                    AND SHRTCKN_TERM_CODE = bb.SHRTCKG_TERM_CODE
                    AND SHRTCKN_SEQ_NO = bb.SHRTCKG_TCKN_SEQ_NO
            )
    WHERE SHRTCKG_GRDE_CODE_FINAL NOT IN ('TNR','X','I','AU')
) chrt
-- Last Attended
LEFT JOIN SZRATND atnd ON chrt.SHRTCKN_PIDM = atnd.SZRATND_PIDM
    AND chrt.SHRTCKN_TERM_CODE = atnd.SZRATND_TERM_CODE
    AND chrt.SHRTCKN_CRN = atnd.SZRATND_CRN
-- Student Identifiers
LEFT JOIN SPRIDEN iden ON chrt.SHRTCKN_PIDM = iden.SPRIDEN_PIDM
    AND iden.SPRIDEN_CHANGE_IND IS NULL
-- Term Descriptions
LEFT JOIN STVTERM atrm ON chrt.SHRTCKN_TERM_CODE = atrm.STVTERM_CODE
-- Section Information
LEFT JOIN SSBSECT sect ON chrt.SHRTCKN_TERM_CODE = sect.SSBSECT_TERM_CODE
    AND chrt.SHRTCKN_CRN = sect.SSBSECT_CRN
-- Faculty Section Assignment
LEFT JOIN SIRASGN asgn ON chrt.SHRTCKN_TERM_CODE = asgn.SIRASGN_TERM_CODE
    AND chrt.SHRTCKN_CRN = asgn.SIRASGN_CRN
    AND asgn.SIRASGN_PRIMARY_IND = 'Y'
-- Faculty Identifiers
LEFT JOIN SPRIDEN fidn ON asgn.SIRASGN_PIDM = fidn.SPRIDEN_PIDM
    AND fidn.SPRIDEN_CHANGE_IND IS NULL
-- Last W Date
LEFT JOIN SFRRSTS frsts ON chrt.SHRTCKN_TERM_CODE = frsts.SFRRSTS_TERM_CODE
    AND chrt.SHRTCKN_PTRM_CODE = frsts.SFRRSTS_PTRM_CODE
    AND frsts.SFRRSTS_RSTS_CODE = 'WV'
-- Report Organization
WHERE chrt.SHRTCKN_TERM_CODE = :ENTER_TERM
    AND (
        (chrt.SHRTCKG_GRDE_CODE_FINAL NOT IN ('FN','W') AND atnd.SZRATND_ATTENDING_IND NOT IN ('Y','S'))
        OR (chrt.SHRTCKG_GRDE_CODE_FINAL IN ('FN') AND atnd.SZRATND_ATTENDING_IND IN ('Y','S'))
        OR (chrt.SHRTCKG_GRDE_CODE_FINAL IN ('FA') AND atnd.SZRATND_LAST_ATTEND > frsts.SFRRSTS_END_DATE)
        OR (chrt.SHRTCKG_GRDE_CODE_FINAL IN ('F') AND atnd.SZRATND_LAST_ATTEND <= frsts.SFRRSTS_END_DATE)
    )
ORDER BY iden.SPRIDEN_LAST_NAME,
    iden.SPRIDEN_FIRST_NAME,
    sect.SSBSECT_PTRM_CODE,
    sect.SSBSECT_SUBJ_CODE,
    sect.SSBSECT_CRSE_NUMB,
    sect.SSBSECT_SEQ_NUMB
;