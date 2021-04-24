select distinct STVTERM.STVTERM_CODE as "TERM_CODE_KEY",
       STVTERM.STVTERM_DESC as "TERM_DESC",
       STVTERM.STVTERM_FA_PROC_YR as "FinAidYr_Code"
  from SATURN.STVTERM STVTERM
 where STVTERM.STVTERM_CODE >= '200780'
       and STVTERM.STVTERM_START_DATE < ADD_MONTHS(sysdate,2)
 order by STVTERM.STVTERM_CODE desc