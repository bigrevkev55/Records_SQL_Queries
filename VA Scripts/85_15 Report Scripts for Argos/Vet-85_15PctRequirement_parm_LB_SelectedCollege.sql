SELECT 'AC' as collegecde,
       :varAllColleges as COLLEGE,
       0 as sort_by
  FROM SYS.DUAL DUAL
 WHERE :parm_DD_SelectedTerm.TERM_CODE_KEY is not null
UNION ALL
select distinct SGBSTDN_COLL_CODE_1 as collegecde,
       SGBSTDN_COLL_CODE_1 || ' - ' || stvcoll_desc AS COLLEGE,
       CASE WHEN SGBSTDN_COLL_CODE_1 = '00' THEN 2 ELSE 1 END AS SORT_BY
  from SATURN.SFBETRM SFBETRM,
       SATURN.SGBSTDN SGBSTDN,
       STVCOLL STVCOLL
 where SFBETRM.SFBETRM_PIDM = SGBSTDN.SGBSTDN_PIDM
        and SGBSTDN_COLL_CODE_1 = STVCOLL_CODE
   AND :parm_DD_SelectedTerm.TERM_CODE_KEY is not null
        and (SFBETRM.SFBETRM_PIDM IN
              (SELECT distinct SFRSTCR.SFRSTCR_PIDM
                 FROM SATURN.SFRSTCR SFRSTCR
                WHERE (SFRSTCR.SFRSTCR_RSTS_CODE LIKE 'R%' OR
                       SFRSTCR.SFRSTCR_RSTS_CODE LIKE 'U%' OR
                       SFRSTCR.SFRSTCR_RSTS_CODE LIKE 'AU')
                   AND SFRSTCR.SFRSTCR_TERM_CODE = :parm_DD_SelectedTerm.TERM_CODE_KEY)
            )
        and SFBETRM.SFBETRM_TERM_CODE = :parm_DD_SelectedTerm.TERM_CODE_KEY
        and SGBSTDN.SGBSTDN_TERM_CODE_EFF =
            (SELECT MAX(B.SGBSTDN_TERM_CODE_EFF) AS MAX_TERM_CODE
               FROM SATURN.SGBSTDN B
              WHERE B.SGBSTDN_TERM_CODE_EFF <= :parm_DD_SelectedTerm.TERM_CODE_KEY
                AND B.SGBSTDN_PIDM = SGBSTDN.SGBSTDN_PIDM)
 order by SORT_BY, COLLEGE