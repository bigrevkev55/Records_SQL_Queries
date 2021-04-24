SELECT '    ' as MinorCode,
       '    ' as MinorDesc,
       1 as Sort_By
  FROM DUAL
UNION
SELECT DISTINCT STVMAJR_CODE as MinorCode,
       STVMAJR_CODE || ' - ' || STVMAJR_DESC as MinorDesc,
       2 as Sort_By
  FROM SATURN.STVMAJR STVMAJR
 WHERE STVMAJR_VALID_MINOR_IND = 'Y'
   AND :parm_DD_SelectedTerm.TERM_CODE_KEY is not null
   AND STVMAJR_CODE <> 'XXXX'
ORDER BY Sort_By, MinorCode


