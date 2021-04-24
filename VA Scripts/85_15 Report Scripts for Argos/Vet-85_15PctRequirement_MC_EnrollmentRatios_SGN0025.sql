--********************************************************************************************************************************
-- DataBlock Name: Veterans - 85/15% Requirement (SGN0025)
-- Folder:         Student - General\Veteran Dashboards and Reports
--
-- Banner Product: ST
-- Author:         Janae Peterson
-- Date Created:   03/30/2015
-- Work Order:     156974
--
-- Description:
--     Report that was designed to be run for the Department of Veterans Affairs by the 30th day of the term to meet the
--     Code of Federal Regulations (38 CFR 21.4201) requirements. To meet these requirements it should be run on the college
--     of Basic and Applied Sciences Aerospace department. However, the DataBlock has been designed so that it will run for
--     any college and department selection based on the selected term. If minors are selected, students having these minors
--     will also be included no matter what major they have. However, if all colleges and all departments are selected, the
--     student's primary program will be displayed only. Produces both a roster of students as well as the ratio.
--
-- Banner Tables Used:
--     SATURN.SFBETRM, SATURN.SGRVETN, SATURN.SPRIDEN, SATURN.SFRSTCR, SATURN.SARADAP, SATURN.SGBSTDN, SATURN.STVTERM,
--     SATURN.STVMAJR, SATURN.STVCOLL, SATURN.STVDEPT, MTOBJECTS.ARGOS_SPBPERS
--
-- Parameters:
--     Term, One or All Colleges, One, Multiple or All Departments, and an optional parameter for One or More Minors
--
-- Output:
--     Preview Ratios Dashboard
--     Program Name, VA Supported Students, Non-Supported Students, Total Enrollment FTE, VA STudent % (FTE), Data of Calculation
--
-- Revision History
--
-- 1.  JEP 03/01/2017 - Updated for all colleges and all departments selections for a Compliance Survey that Ray needs to
--     participate in. Also changed the program name logic in the report query and preview ratios SQL variable.
--
-- 2. JEP 05/28/2019 - Ray Howell received a new template for reporting the 85/15% ratios. Because of this, we had to make a few
--    changes to the report as reporting definitions slightly changed. For instance, we moved VETC_CODEs of N, X, and I to
--    non-supported.
--
-- 3.
--
--********************************************************************************************************************************

--Preview the data for the 85 percent Enrollment Ratios worksheet and offer print option in CSV format.
SELECT distinct ProgramName,
       SUM(VAStudentsFTPT) as Num_VAStudents_FTE,
       SUM(NonVAStudentsFTPT) as Num_NonVAStudents_FTE,
       SUM(VAStudentsFTPT) + SUM(NonVAStudentsFTPT) as TotalEnrollment_FTE,
       (SUM(VAStudentsFTPT)/(SUM(VAStudentsFTPT) + SUM(NonVAStudentsFTPT)))*100 as VAStudentPct_FTE,
       TO_CHAR(sysdate,'MM/DD/YYYY HH12:MI:SS') as DateofCalculation
  FROM
(
  (
  SELECT distinct EnrollmentCohort.PIDM_KEY,
         --Get the program name for the program in the selected department. This may be program 1 or program 2.
         CASE
              --All Colleges and All Departments are selected
              WHEN :parm_LB_SelectedCollege.COLLEGECDE = 'AC' AND :college_cb_allDepartments = 'Y' THEN --AND EnrollmentCohort.FirstMinorCode IS NULL AND EnrollmentCohort.SecondMinorCode IS NULL THEN
                   CASE WHEN EnrollmentCohort.FirstConcCode IS NOT NULL THEN
                             (EnrollmentCohort.FirstDegree || ' ' ||
                             (select trim(STVMAJR_DESC) from STVMAJR where STVMAJR_CODE = EnrollmentCohort.FirstMajorCode) || ': ' ||
                             (select trim(STVMAJR_DESC) from STVMAJR where STVMAJR_CODE = EnrollmentCohort.FirstConcCode))
                        ELSE (EnrollmentCohort.FirstDegree || ' ' ||
                             (select trim(STVMAJR_DESC) from STVMAJR where STVMAJR_CODE = EnrollmentCohort.FirstMajorCode))
                   END
              --A Single College and All Departments are selected
              WHEN :parm_LB_SelectedCollege.COLLEGECDE <> 'AC' AND :college_cb_allDepartments = 'Y' AND EnrollmentCohort.FirstMinorCode IS NULL AND EnrollmentCohort.SecondMinorCode IS NULL THEN
                   CASE
                        --Single college selected and that college is stored in the first college field
                        WHEN EnrollmentCohort.FirstCollegeCode = :parm_LB_SelectedCollege.COLLEGECDE THEN
                             CASE WHEN EnrollmentCohort.FirstConcCode IS NOT NULL THEN
                                       (EnrollmentCohort.FirstDegree || ' ' ||
                                       (select trim(STVMAJR_DESC) from STVMAJR where STVMAJR_CODE = EnrollmentCohort.FirstMajorCode) || ': ' ||
                                       (select trim(STVMAJR_DESC) from STVMAJR where STVMAJR_CODE = EnrollmentCohort.FirstConcCode))
                                  ELSE (EnrollmentCohort.FirstDegree || ' ' ||
                                       (select trim(STVMAJR_DESC) from STVMAJR where STVMAJR_CODE = EnrollmentCohort.FirstMajorCode))
                             END
                        --Single college selected and that college is stored in the second college field
                        WHEN EnrollmentCohort.SecondCollegeCode = :parm_LB_SelectedCollege.COLLEGECDE THEN
                             CASE WHEN EnrollmentCohort.SecondConcCode IS NOT NULL THEN
                                       (CASE WHEN EnrollmentCohort.SecondDegree IS NULL THEN EnrollmentCohort.FirstDegree ELSE EnrollmentCohort.SecondDegree END || ' ' ||
                                       (select trim(STVMAJR_DESC) from STVMAJR where STVMAJR_CODE = EnrollmentCohort.SecondMajorCode) || ': ' ||
                                       (select trim(STVMAJR_DESC) from STVMAJR where STVMAJR_CODE = EnrollmentCohort.SecondConcCode))
                                  ELSE
                                       (CASE WHEN EnrollmentCohort.SecondDegree IS NULL THEN EnrollmentCohort.FirstDegree ELSE EnrollmentCohort.SecondDegree END || ' ' ||
                                       (select trim(STVMAJR_DESC) from STVMAJR where STVMAJR_CODE = EnrollmentCohort.SecondMajorCode))
                             END
                   END
              --A Single College and one or more but not all Departments are selected and the department is stored in the first deparment field.
              WHEN :college_cb_allDepartments = 'N' AND EnrollmentCohort.FirstDeptCode = :Parm_LB_SelectedDept.DEPTCODE THEN
                   CASE WHEN EnrollmentCohort.FirstConcCode IS NOT NULL THEN
                             (EnrollmentCohort.FirstDegree || ' ' ||
                             (select trim(STVMAJR_DESC) from STVMAJR where STVMAJR_CODE = EnrollmentCohort.FirstMajorCode) || ': ' ||
                             (select trim(STVMAJR_DESC) from STVMAJR where STVMAJR_CODE = EnrollmentCohort.FirstConcCode))
                        ELSE
                             (EnrollmentCohort.FirstDegree || ' ' ||
                             (select trim(STVMAJR_DESC) from STVMAJR where STVMAJR_CODE = EnrollmentCohort.FirstMajorCode))
                   END
              --A Single College and one or more but not all Departments are selected and the department is stored in the second deparment field.
              WHEN :college_cb_allDepartments = 'N' AND EnrollmentCohort.SecondDeptCode = :Parm_LB_SelectedDept.DEPTCODE THEN
                   CASE WHEN EnrollmentCohort.SecondConcCode IS NOT NULL THEN
                             (CASE WHEN EnrollmentCohort.SecondDegree IS NULL THEN EnrollmentCohort.FirstDegree ELSE EnrollmentCohort.SecondDegree END || ' ' ||
                             (select trim(STVMAJR_DESC) from STVMAJR where STVMAJR_CODE = EnrollmentCohort.SecondMajorCode) || ': ' ||
                             (select trim(STVMAJR_DESC) from STVMAJR where STVMAJR_CODE = EnrollmentCohort.SecondConcCode))
                        ELSE
                             (CASE WHEN EnrollmentCohort.SecondDegree IS NULL THEN EnrollmentCohort.FirstDegree ELSE EnrollmentCohort.SecondDegree END || ' ' ||
                             (select trim(STVMAJR_DESC) from STVMAJR where STVMAJR_CODE = EnrollmentCohort.SecondMajorCode))
                   END
              --A Single College and one or more but not all Departments and one or more minors are selected and the selected minor is stored in the first minor field.
              WHEN EnrollmentCohort.FirstMinorCode is not null THEN
                   ('Selected Minor: ' ||
                   (select trim(STVMAJR_DESC) from STVMAJR where STVMAJR_CODE = EnrollmentCohort.FirstMinorCode))
              --A Single College and one or more but not all Departments and one or more minors are selected and the selected minor is stored in the second minor field.
              WHEN EnrollmentCohort.SecondMinorCode is not null THEN
                   ('Selected Minor: ' ||
                   (select trim(STVMAJR_DESC) from STVMAJR where STVMAJR_CODE = EnrollmentCohort.SecondMinorCode))
         END AS ProgramName,
         EnrollmentCohort.FirstProgram,
         EnrollmentCohort.SecondProgram,
         EnrollmentCohort.FirstMinorCode,
         EnrollmentCohort.SecondMinorCode,
         --The Ratios worksheet states to get the FTE, add the number part-time students divided by two to the number of full-time students.
         --    Every two part-time students equal one full-time student.
         --CCS JEP 5/28/2019 - Moved VETC_CODEs of N, X, and I to non-supported due to new template and definitions.
         --CCD CASE WHEN VeteranInfo.VETC_CODE IN ('A','B','C','D','F','G','I','T','N','E','P','Q','U') THEN
         CASE WHEN VeteranInfo.VETC_CODE IN ('A','B','C','D','F','G','T','E','P','Q','U') THEN
              CASE WHEN EnrollmentCohort.Level_Code = 'UG' THEN (CASE WHEN EnrollmentCohort.CREDIT_HRS >= 12 THEN 1 ELSE 0.5 END)
                   WHEN EnrollmentCohort.Level_Code = 'GR' THEN (CASE WHEN EnrollmentCohort.CREDIT_HRS >= 9 THEN 1 ELSE 0.5 END)
              END
              ELSE 0
         END as VAStudentsFTPT,
         --CCD CASE WHEN VeteranInfo.VETC_CODE IS NULL THEN
         CASE WHEN VeteranInfo.VETC_CODE IS NULL OR VeteranInfo.VETC_CODE IN ('I','N','X') THEN
              CASE WHEN EnrollmentCohort.Level_Code = 'UG' THEN (CASE WHEN EnrollmentCohort.CREDIT_HRS >= 12 THEN 1 ELSE 0.5 END)
                   WHEN EnrollmentCohort.Level_Code = 'GR' THEN (CASE WHEN EnrollmentCohort.CREDIT_HRS >= 9 THEN 1 ELSE 0.5 END)
              END
              ELSE 0
         END as NonVAStudentsFTPT
         --CCE JEP 5/28/2019 - Moved VETC_CODEs of N, X, and I to non-supported due to new template and definitions.
    FROM
  -- EnrollmentCohort
    (SELECT DISTINCT
           SFBETRM.SFBETRM_PIDM AS PIDM_KEY,
           SPRIDEN.SPRIDEN_ID AS MTSU_ID,
           substr(trim(SPRIDEN.SPRIDEN_FIRST_NAME),1,1) as FirstInit,
           substr(trim(SPRIDEN.SPRIDEN_MI),1,1) as MiddleInit,
           trim(SPRIDEN.SPRIDEN_LAST_NAME) as LastName,
           substr(trim(SPBPERS_SSN),length(trim(SPBPERS_SSN))-3,4) as SSN,
           SFBETRM.SFBETRM_TERM_CODE as TERM_CODE,
           SGBSTDN.SGBSTDN_LEVL_CODE AS Level_Code,
           SGBSTDN_PROGRAM_1 AS FirstProgram,
           SGBSTDN_COLL_CODE_1 AS FirstCollegeCode,
           SGBSTDN_DEPT_CODE AS FirstDeptCode,
           SGBSTDN_MAJR_CODE_1 AS FirstMajorCode,
           SGBSTDN_MAJR_CODE_CONC_1 AS FirstConcCode,
           SGBSTDN_DEGC_CODE_1 AS FirstDegree,
           CASE WHEN SGBSTDN_MAJR_CODE_MINR_1 = :Parm_LB_SelectedMinor.MINORCODE THEN SGBSTDN_MAJR_CODE_MINR_1 END as FirstMinorCode,
           SGBSTDN_PROGRAM_2 AS SecondProgram,
           SGBSTDN_COLL_CODE_2 AS SecondCollegeCode,
           CASE
                WHEN SGBSTDN_DEPT_CODE_2 IS NULL THEN SGBSTDN_DEPT_CODE_1_2
                ELSE SGBSTDN_DEPT_CODE_2
           END AS SecondDeptCode,
           CASE
                WHEN SGBSTDN_MAJR_CODE_2 IS NULL THEN SGBSTDN_MAJR_CODE_1_2
                ELSE SGBSTDN_MAJR_CODE_2
           END AS SecondMajorCode,
           --JEP 2/11/2016 - Update CASE LOGIC because it was not always pulling in the second concentration if it was stored in the
           --    SGBSTDN_MAJR_CODE_CONC_1_2 field rather than the SGBSTDN_MAJR_CODE_CONC_121 field.
           CASE
                WHEN SGBSTDN_MAJR_CODE_2 IS NOT NULL THEN SGBSTDN_MAJR_CODE_CONC_2
                WHEN SGBSTDN_MAJR_CODE_2 IS NULL AND SGBSTDN_MAJR_CODE_CONC_121 IS NOT NULL THEN SGBSTDN_MAJR_CODE_CONC_121
                WHEN SGBSTDN_MAJR_CODE_2 IS NULL AND SGBSTDN_MAJR_CODE_CONC_1_2 IS NOT NULL THEN SGBSTDN_MAJR_CODE_CONC_1_2
                ELSE SGBSTDN_MAJR_CODE_CONC_2
           END AS SecondConcCode,
           SGBSTDN_DEGC_CODE_2 AS SecondDegree,
           CASE
                WHEN SGBSTDN_MAJR_CODE_MINR_2_2 = :Parm_LB_SelectedMinor.MINORCODE THEN SGBSTDN_MAJR_CODE_MINR_2_2
                WHEN SGBSTDN_MAJR_CODE_MINR_2 = :Parm_LB_SelectedMinor.MINORCODE THEN SGBSTDN_MAJR_CODE_MINR_2
                WHEN SGBSTDN_MAJR_CODE_MINR_1_2 = :Parm_LB_SelectedMinor.MINORCODE THEN SGBSTDN_MAJR_CODE_MINR_1_2
           END AS SecondMinorCode,
         --Student Credit Hours
         (select Sum( SFRSTCR.SFRSTCR_CREDIT_HR )
            from SATURN.SFRSTCR SFRSTCR
           where SFRSTCR.SFRSTCR_TERM_CODE = :parm_DD_SelectedTerm.TERM_CODE_KEY
             and SFRSTCR.SFRSTCR_PIDM = SFBETRM.SFBETRM_PIDM
             and (SFRSTCR.SFRSTCR_RSTS_CODE like 'R%' OR
                  SFRSTCR.SFRSTCR_RSTS_CODE LIKE 'U%' OR
                  SFRSTCR.SFRSTCR_RSTS_CODE LIKE 'AU')
         ) as CREDIT_HRS
      FROM SATURN.SPRIDEN SPRIDEN,
           SATURN.SFBETRM SFBETRM,
           SATURN.SARADAP SARADAP,
           SATURN.SGBSTDN SGBSTDN,
           MTOBJECTS.ARGOS_SPBPERS SPBPERS
     WHERE SFBETRM.SFBETRM_TERM_CODE = :parm_DD_SelectedTerm.TERM_CODE_KEY
  --     AND SFBETRM.SFBETRM_ESTS_CODE = 'EL'
       AND :cmd_Go is not null
       AND (SFBETRM.SFBETRM_PIDM IN
              (SELECT distinct SFRSTCR.SFRSTCR_PIDM
                 FROM SATURN.SFRSTCR SFRSTCR
                WHERE (SFRSTCR.SFRSTCR_RSTS_CODE LIKE 'R%' OR
                       SFRSTCR.SFRSTCR_RSTS_CODE LIKE 'U%' OR
                       SFRSTCR.SFRSTCR_RSTS_CODE LIKE 'AU')
                  AND SFRSTCR.SFRSTCR_TERM_CODE = :parm_DD_SelectedTerm.TERM_CODE_KEY)
           )
       AND SARADAP.SARADAP_TERM_CODE_ENTRY (+) = :parm_DD_SelectedTerm.TERM_CODE_KEY
       AND
           (SARADAP.SARADAP_APST_CODE (+) <> 'I'  AND
            SARADAP.SARADAP_APST_CODE (+) <> 'R'  AND
            SARADAP.SARADAP_APST_CODE (+) <> 'W')
       AND SFBETRM.SFBETRM_PIDM = SARADAP.SARADAP_PIDM (+)
       AND SFBETRM.SFBETRM_PIDM = SGBSTDN.SGBSTDN_PIDM
       AND SGBSTDN.SGBSTDN_LEVL_CODE IN ('UG', 'GR')     --NOT GET DS STUDENTS
       --Student has a major in the selected college and department or the student has the selected minor(s).
       AND (
            --selected college or major
            (
             (SGBSTDN.SGBSTDN_COLL_CODE_1 = :parm_LB_SelectedCollege.COLLEGECDE OR
              SGBSTDN.SGBSTDN_COLL_CODE_2 = :parm_LB_SelectedCollege.COLLEGECDE OR
              :parm_LB_SelectedCollege.COLLEGECDE = 'AC'
             ) AND --selected department(s)
             (SGBSTDN.SGBSTDN_DEPT_CODE = :Parm_LB_SelectedDept.DEPTCODE OR
              SGBSTDN.SGBSTDN_DEPT_CODE_2 = :Parm_LB_SelectedDept.DEPTCODE OR
              SGBSTDN.SGBSTDN_DEPT_CODE_1_2 = :Parm_LB_SelectedDept.DEPTCODE OR
              :college_cb_allDepartments = 'Y')
            ) OR --selected minor
             ((SGBSTDN_MAJR_CODE_MINR_1 is not null and SGBSTDN_MAJR_CODE_MINR_1 = :Parm_LB_SelectedMinor.MINORCODE) OR
              (SGBSTDN_MAJR_CODE_MINR_1_2 is not null and SGBSTDN_MAJR_CODE_MINR_1_2 = :Parm_LB_SelectedMinor.MINORCODE) OR
              (SGBSTDN_MAJR_CODE_MINR_2 is not null and SGBSTDN_MAJR_CODE_MINR_2 = :Parm_LB_SelectedMinor.MINORCODE) OR
              (SGBSTDN_MAJR_CODE_MINR_2_2 is not null and SGBSTDN_MAJR_CODE_MINR_2_2 = :Parm_LB_SelectedMinor.MINORCODE))
           )
       AND SGBSTDN.SGBSTDN_TERM_CODE_EFF =
           (SELECT MAX(B.SGBSTDN_TERM_CODE_EFF) AS MAX_TERM_CODE
              FROM SATURN.SGBSTDN B
             WHERE B.SGBSTDN_TERM_CODE_EFF <= :parm_DD_SelectedTerm.TERM_CODE_KEY
               AND B.SGBSTDN_PIDM = SGBSTDN.SGBSTDN_PIDM
           )
       AND SFBETRM.SFBETRM_PIDM = SPRIDEN.SPRIDEN_PIDM
       AND SPRIDEN.SPRIDEN_CHANGE_IND IS NULL
       AND SFBETRM.SFBETRM_PIDM = SPBPERS.SPBPERS_PIDM
    ) EnrollmentCohort,
  -- VeteranInfo
       (SELECT distinct SGRVETN.SGRVETN_PIDM AS PIDM_KEY,
               SGRVETN.SGRVETN_TERM_CODE_VA AS TERM_CODE,
               SGRVETN.SGRVETN_CERT_HOURS AS CERT_HOURS,
               SGRVETN.SGRVETN_CERT_DATE AS CERT_DATE,
               SGRVETN.SGRVETN_VETC_CODE as VETC_CODE
          FROM SATURN.SGRVETN SGRVETN
         --CCS JEP 5/28/2019 - Moved VETC_CODEs of N, X, and I to non-supported due to new template and definitions.
         --CCD WHERE SGRVETN.SGRVETN_VETC_CODE In ('A','B','C','D','F','G','I','T','N','E','P','Q','U')
         WHERE SGRVETN.SGRVETN_VETC_CODE In ('A','B','C','D','F','G','I','T','N','E','P','Q','U','X')
         --CCE JEP 5/28/2019 - Moved VETC_CODEs of N, X, and I to non-supported due to new template and definitions.
           AND SGRVETN.SGRVETN_TERM_CODE_VA = :parm_DD_SelectedTerm.TERM_CODE_KEY
       ) VeteranInfo
   WHERE EnrollmentCohort.PIDM_KEY = VeteranInfo.PIDM_KEY (+)
     AND EnrollmentCohort.TERM_CODE = VeteranInfo.TERM_CODE (+)
  )
    UNION
  (
  SELECT Distinct EnrollmentCohort.PIDM_KEY,
         --Assign a program name for the Totals row.
         'Totals' AS ProgramName,
         EnrollmentCohort.FirstProgram,
         EnrollmentCohort.SecondProgram,
         EnrollmentCohort.FirstMinorCode,
         EnrollmentCohort.SecondMinorCode,
         --The Ratios worksheet states to get the FTE, add the number part-time students divided by two to the number of full-time students.
         --    Every two part-time students equal one full-time student.
         --CCS JEP 5/28/2019 - Moved VETC_CODEs of N, X, and I to non-supported due to new template and definitions.
         --CCD CASE WHEN VeteranInfo.VETC_CODE IN ('A','B','C','D','F','G','I','T','N','E','P','Q','U') THEN
         CASE WHEN VeteranInfo.VETC_CODE IN ('A','B','C','D','F','G','T','E','P','Q','U') THEN
              CASE WHEN EnrollmentCohort.Level_Code = 'UG' THEN (CASE WHEN EnrollmentCohort.CREDIT_HRS >= 12 THEN 1 ELSE 0.5 END)
                   WHEN EnrollmentCohort.Level_Code = 'GR' THEN (CASE WHEN EnrollmentCohort.CREDIT_HRS >= 9 THEN 1 ELSE 0.5 END)
              END
              ELSE 0
         END as VAStudentsFTPT,
         --CCD CASE WHEN VeteranInfo.VETC_CODE IS NULL THEN
         CASE WHEN VeteranInfo.VETC_CODE IS NULL OR VeteranInfo.VETC_CODE IN ('I','N','X') THEN
              CASE WHEN EnrollmentCohort.Level_Code = 'UG' THEN (CASE WHEN EnrollmentCohort.CREDIT_HRS >= 12 THEN 1 ELSE 0.5 END)
                   WHEN EnrollmentCohort.Level_Code = 'GR' THEN (CASE WHEN EnrollmentCohort.CREDIT_HRS >= 9 THEN 1 ELSE 0.5 END)
              END
              ELSE 0
         END as NonVAStudentsFTPT
         --CCE JEP 5/28/2019 - Moved VETC_CODEs of N, X, and I to non-supported due to new template and definitions.
    FROM
  -- EnrollmentCohort
    (SELECT DISTINCT
           SFBETRM.SFBETRM_PIDM AS PIDM_KEY,
           SPRIDEN.SPRIDEN_ID AS MTSU_ID,
           substr(trim(SPRIDEN.SPRIDEN_FIRST_NAME),1,1) as FirstInit,
           substr(trim(SPRIDEN.SPRIDEN_MI),1,1) as MiddleInit,
           trim(SPRIDEN.SPRIDEN_LAST_NAME) as LastName,
           substr(trim(SPBPERS_SSN),length(trim(SPBPERS_SSN))-3,4) as SSN,
           SFBETRM.SFBETRM_TERM_CODE as TERM_CODE,
           SGBSTDN.SGBSTDN_LEVL_CODE AS Level_Code,
           SGBSTDN_PROGRAM_1 AS FirstProgram,
           SGBSTDN_COLL_CODE_1 AS FirstCollegeCode,
           SGBSTDN_DEPT_CODE AS FirstDeptCode,
           SGBSTDN_MAJR_CODE_1 AS FirstMajorCode,
           SGBSTDN_MAJR_CODE_CONC_1 AS FirstConcCode,
           SGBSTDN_DEGC_CODE_1 AS FirstDegree,
           CASE WHEN SGBSTDN_MAJR_CODE_MINR_1 = :Parm_LB_SelectedMinor.MINORCODE THEN SGBSTDN_MAJR_CODE_MINR_1 END as FirstMinorCode,
           SGBSTDN_PROGRAM_2 AS SecondProgram,
           SGBSTDN_COLL_CODE_2 AS SecondCollegeCode,
           CASE
                WHEN SGBSTDN_DEPT_CODE_2 IS NULL THEN SGBSTDN_DEPT_CODE_1_2
                ELSE SGBSTDN_DEPT_CODE_2
           END AS SecondDeptCode,
           CASE
                WHEN SGBSTDN_MAJR_CODE_2 IS NULL THEN SGBSTDN_MAJR_CODE_1_2
                ELSE SGBSTDN_MAJR_CODE_2
           END AS SecondMajorCode,
           --JEP 2/11/2016 - Update CASE LOGIC because it was not always pulling in the second concentration if it was stored in the
           --    SGBSTDN_MAJR_CODE_CONC_1_2 field rather than the SGBSTDN_MAJR_CODE_CONC_121 field.
           CASE
                WHEN SGBSTDN_MAJR_CODE_2 IS NOT NULL THEN SGBSTDN_MAJR_CODE_CONC_2
                WHEN SGBSTDN_MAJR_CODE_2 IS NULL AND SGBSTDN_MAJR_CODE_CONC_121 IS NOT NULL THEN SGBSTDN_MAJR_CODE_CONC_121
                WHEN SGBSTDN_MAJR_CODE_2 IS NULL AND SGBSTDN_MAJR_CODE_CONC_1_2 IS NOT NULL THEN SGBSTDN_MAJR_CODE_CONC_1_2
                ELSE SGBSTDN_MAJR_CODE_CONC_2
           END AS SecondConcCode,
           SGBSTDN_DEGC_CODE_2 AS SecondDegree,
           CASE
                WHEN SGBSTDN_MAJR_CODE_MINR_2_2 = :Parm_LB_SelectedMinor.MINORCODE THEN SGBSTDN_MAJR_CODE_MINR_2_2
                WHEN SGBSTDN_MAJR_CODE_MINR_2 = :Parm_LB_SelectedMinor.MINORCODE THEN SGBSTDN_MAJR_CODE_MINR_2
                WHEN SGBSTDN_MAJR_CODE_MINR_1_2 = :Parm_LB_SelectedMinor.MINORCODE THEN SGBSTDN_MAJR_CODE_MINR_1_2
           END AS SecondMinorCode,
         --Student Credit Hours
         (select Sum( SFRSTCR.SFRSTCR_CREDIT_HR )
            from SATURN.SFRSTCR SFRSTCR
           where SFRSTCR.SFRSTCR_TERM_CODE = :parm_DD_SelectedTerm.TERM_CODE_KEY
             and SFRSTCR.SFRSTCR_PIDM = SFBETRM.SFBETRM_PIDM
             and (SFRSTCR.SFRSTCR_RSTS_CODE like 'R%' OR
                  SFRSTCR.SFRSTCR_RSTS_CODE LIKE 'U%' OR
                  SFRSTCR.SFRSTCR_RSTS_CODE LIKE 'AU')
         ) as CREDIT_HRS
      FROM SATURN.SPRIDEN SPRIDEN,
           SATURN.SFBETRM SFBETRM,
           SATURN.SARADAP SARADAP,
           SATURN.SGBSTDN SGBSTDN,
           MTOBJECTS.ARGOS_SPBPERS SPBPERS
     WHERE SFBETRM.SFBETRM_TERM_CODE = :parm_DD_SelectedTerm.TERM_CODE_KEY
  --     AND SFBETRM.SFBETRM_ESTS_CODE = 'EL'
       AND :cmd_Go is not null
       AND (SFBETRM.SFBETRM_PIDM IN
              (SELECT distinct SFRSTCR.SFRSTCR_PIDM
                 FROM SATURN.SFRSTCR SFRSTCR
                WHERE (SFRSTCR.SFRSTCR_RSTS_CODE LIKE 'R%' OR
                       SFRSTCR.SFRSTCR_RSTS_CODE LIKE 'U%' OR
                       SFRSTCR.SFRSTCR_RSTS_CODE LIKE 'AU')
                  AND SFRSTCR.SFRSTCR_TERM_CODE = :parm_DD_SelectedTerm.TERM_CODE_KEY)
           )
       AND SARADAP.SARADAP_TERM_CODE_ENTRY (+) = :parm_DD_SelectedTerm.TERM_CODE_KEY
       AND
           (SARADAP.SARADAP_APST_CODE (+) <> 'I'  AND
            SARADAP.SARADAP_APST_CODE (+) <> 'R'  AND
            SARADAP.SARADAP_APST_CODE (+) <> 'W')
       AND SFBETRM.SFBETRM_PIDM = SARADAP.SARADAP_PIDM (+)
       AND SFBETRM.SFBETRM_PIDM = SGBSTDN.SGBSTDN_PIDM
       AND SGBSTDN.SGBSTDN_LEVL_CODE IN ('UG', 'GR')     --NOT GET DS STUDENTS
       --Student has a major in the selected college and department or the student has the selected minor(s).
       AND (
            --selected college or major
            (
             (SGBSTDN.SGBSTDN_COLL_CODE_1 = :parm_LB_SelectedCollege.COLLEGECDE OR
              SGBSTDN.SGBSTDN_COLL_CODE_2 = :parm_LB_SelectedCollege.COLLEGECDE OR
              :parm_LB_SelectedCollege.COLLEGECDE = 'AC'
             ) AND --selected department(s)
             (SGBSTDN.SGBSTDN_DEPT_CODE = :Parm_LB_SelectedDept.DEPTCODE OR
              SGBSTDN.SGBSTDN_DEPT_CODE_2 = :Parm_LB_SelectedDept.DEPTCODE OR
              SGBSTDN.SGBSTDN_DEPT_CODE_1_2 = :Parm_LB_SelectedDept.DEPTCODE OR
              :college_cb_allDepartments = 'Y')
            ) OR --selected minor
             ((SGBSTDN_MAJR_CODE_MINR_1 is not null and SGBSTDN_MAJR_CODE_MINR_1 = :Parm_LB_SelectedMinor.MINORCODE) OR
              (SGBSTDN_MAJR_CODE_MINR_1_2 is not null and SGBSTDN_MAJR_CODE_MINR_1_2 = :Parm_LB_SelectedMinor.MINORCODE) OR
              (SGBSTDN_MAJR_CODE_MINR_2 is not null and SGBSTDN_MAJR_CODE_MINR_2 = :Parm_LB_SelectedMinor.MINORCODE) OR
              (SGBSTDN_MAJR_CODE_MINR_2_2 is not null and SGBSTDN_MAJR_CODE_MINR_2_2 = :Parm_LB_SelectedMinor.MINORCODE))
           )
       AND SGBSTDN.SGBSTDN_TERM_CODE_EFF =
           (SELECT MAX(B.SGBSTDN_TERM_CODE_EFF) AS MAX_TERM_CODE
              FROM SATURN.SGBSTDN B
             WHERE B.SGBSTDN_TERM_CODE_EFF <= :parm_DD_SelectedTerm.TERM_CODE_KEY
               AND B.SGBSTDN_PIDM = SGBSTDN.SGBSTDN_PIDM
           )
       AND SFBETRM.SFBETRM_PIDM = SPRIDEN.SPRIDEN_PIDM
       AND SPRIDEN.SPRIDEN_CHANGE_IND IS NULL
       AND SFBETRM.SFBETRM_PIDM = SPBPERS.SPBPERS_PIDM
    ) EnrollmentCohort,
  -- VeteranInfo
       (SELECT distinct SGRVETN.SGRVETN_PIDM AS PIDM_KEY,
               SGRVETN.SGRVETN_TERM_CODE_VA AS TERM_CODE,
               SGRVETN.SGRVETN_CERT_HOURS AS CERT_HOURS,
               SGRVETN.SGRVETN_CERT_DATE AS CERT_DATE,
               SGRVETN.SGRVETN_VETC_CODE as VETC_CODE
          FROM SATURN.SGRVETN SGRVETN
         --CCS JEP 5/28/2019 - Moved VETC_CODEs of N, X, and I to non-supported due to new template and definitions.
         --CCD WHERE SGRVETN.SGRVETN_VETC_CODE In ('A','B','C','D','F','G','I','T','N','E','P','Q','U')
         WHERE SGRVETN.SGRVETN_VETC_CODE In ('A','B','C','D','F','G','I','T','N','E','P','Q','U','X')
         --CCS JEP 5/28/2019 - Moved VETC_CODEs of N, X, and I to non-supported due to new template and definitions.
           AND SGRVETN.SGRVETN_TERM_CODE_VA = :parm_DD_SelectedTerm.TERM_CODE_KEY
       ) VeteranInfo
   WHERE EnrollmentCohort.PIDM_KEY = VeteranInfo.PIDM_KEY (+)
     AND EnrollmentCohort.TERM_CODE = VeteranInfo.TERM_CODE (+)
  )
)
GROUP BY ProgramName
ORDER BY ProgramName