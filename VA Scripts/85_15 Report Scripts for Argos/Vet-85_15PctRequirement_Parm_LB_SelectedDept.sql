SELECT NULL AS deptcode,
       :varAllDepts as DEPARTMENT,
       1 AS SORT_BY
  FROM SYS.DUAL DUAL
 WHERE :parm_DD_SelectedTerm.TERM_CODE_KEY is not null
   AND :college_cb_allDepartments = 'Y'
union all
SELECT distinct SGBSTDN_DEPT_CODE as DeptCode,
       SGBSTDN_DEPT_CODE ||' - ' || stvdept_desc as DEPARTMENT,
       2 AS SORT_BY
  FROM SATURN.SFBETRM SFBETRM,
       SATURN.SGBSTDN SGBSTDN,
       STVDEPT STVDEPT
 WHERE SFBETRM.SFBETRM_PIDM = SGBSTDN.SGBSTDN_PIDM
   AND SGBSTDN_DEPT_CODE = STVDEPT_CODE
   AND :parm_DD_SelectedTerm.TERM_CODE_KEY is not null
   AND :parm_LB_SelectedCollege.COLLEGECDE is not null
   AND :college_cb_allDepartments = 'N'
   AND (SGBSTDN.SGBSTDN_COLL_CODE_1 = :parm_LB_SelectedCollege.COLLEGECDE OR :parm_LB_SelectedCollege.COLLEGECDE = 'AC')
   AND (SFBETRM.SFBETRM_PIDM IN
            (SELECT distinct SFRSTCR.SFRSTCR_PIDM
               FROM SATURN.SFRSTCR SFRSTCR
              WHERE (SFRSTCR.SFRSTCR_RSTS_CODE LIKE 'R%' OR
                     SFRSTCR.SFRSTCR_RSTS_CODE LIKE 'U%' OR
                     SFRSTCR.SFRSTCR_RSTS_CODE LIKE 'AU')
                 AND SFRSTCR.SFRSTCR_TERM_CODE = :parm_DD_SelectedTerm.TERM_CODE_KEY)
       )
   AND SFBETRM.SFBETRM_TERM_CODE = :parm_DD_SelectedTerm.TERM_CODE_KEY
   AND SGBSTDN.SGBSTDN_TERM_CODE_EFF =
            (SELECT MAX(B.SGBSTDN_TERM_CODE_EFF) AS MAX_TERM_CODE
               FROM SATURN.SGBSTDN B
              WHERE B.SGBSTDN_TERM_CODE_EFF <= :parm_DD_SelectedTerm.TERM_CODE_KEY
                AND B.SGBSTDN_PIDM = SGBSTDN.SGBSTDN_PIDM)
ORDER BY sort_by, DEPARTMENT