/*===========================================================================
Author:  Kevin Thomas, Director of Admissions/College Registrar
         Assisted by Microsoft M365 Copilot

Date:    08-MAY-2026

Purpose:
   This query is used to investigate student Admit Term and Student Type
   (STYP) issues by displaying one record per effective-dated SGBSTDN
   record. Results show Admit, STYP, and program data associated with
   each effective term.

   The query also includes:
     - A Prior College indicator (Y/N)
     - High School graduation date (if on file)
     - First NSCC Coursework Term
     - Coursework in SGBSTDN Effective Term indicator (Y/N)

   The First NSCC Coursework Term represents the earliest term in which
   the student had active NSCC registration activity (excluding dropped
   registrations). This allows comparison between the student's admit
   term and their actual first term of enrollment.

   The Coursework in SGBSTDN Effective Term indicator identifies whether
   the student had at least one active registration during the specific
   SGBSTDN effective term represented by the row. Students with only
   dropped registrations in that term will display 'N'.

Key Logic Notes:
   - One row is returned per SGBSTDN effective term.
   - Prior college indicator is based on existence of SORPCOL records.
   - HS graduation date reflects the most recent date on SORHSCH.
   - First NSCC Coursework Term is determined from the earliest
     SFRSTCR_TERM_CODE where the student has a registration status
     that is not a drop (RSTS_CODE not like 'D%').
   - Coursework in SGBSTDN Effective Term is Y if the student has
     at least one non-dropped SFRSTCR registration in the
     SGBSTDN_TERM_CODE_EFF term.

Edits:
   - Edited so that one row is returned for each effective SGBSTDN term.
     Previously, the query returned one row per admit term, which could
     obscure the student's original Admit Type and Student Type when
     reviewing multiple cohorts for IR and Census reporting.
     ...kt...09/10/2026

   - Replaced ADMIT_TERM_ENROLLED_IND with
     FIRST_NSCC_COURSEWORK_TERM to identify the earliest term in which
     the student enrolled in coursework at NSCC.
     ...kt...09/10/2026

   - Added COURSEWORK_IN_SGASTDN_TERM to identify whether the student
     had active coursework in the SGBSTDN effective term represented
     by the row.
     ...kt...09/10/2026

Input Required:
   :StudentID  -- Banner ID (e.g., A########)

===========================================================================*/

SELECT r.spriden_id id
     , r.spriden_first_name first
     , r.spriden_last_name last
     , s.sgbstdn_term_code_admit admit_term
     , s.sgbstdn_term_code_eff sgastdn_term
     , s.sgbstdn_admt_code ad_type
     , s.sgbstdn_styp_code st_type
     , s.sgbstdn_degc_code_1 degc
     , s.sgbstdn_majr_code_1 majr
     , s.sgbstdn_majr_code_conc_1 conc

     -- First Term with NSCC Coursework
     , (
           SELECT MIN(f.sfrstcr_term_code)
           FROM sfrstcr f
           WHERE f.sfrstcr_pidm = s.sgbstdn_pidm
             AND f.sfrstcr_rsts_code NOT LIKE 'D%'
       ) AS first_nscc_coursework_term

     -- Coursework in SGBSTDN Effective Term
     , CASE
           WHEN EXISTS (
               SELECT 1
               FROM sfrstcr f
               WHERE f.sfrstcr_pidm = s.sgbstdn_pidm
                 AND f.sfrstcr_term_code = s.sgbstdn_term_code_eff
                 AND f.sfrstcr_rsts_code NOT LIKE 'D%'
           )
           THEN 'Y'
           ELSE 'N'
       END AS coursework_in_sgastdn_term

     -- Prior College Work Flag
     , CASE
           WHEN EXISTS (
               SELECT 1
               FROM sorpcol p
               WHERE p.sorpcol_pidm = s.sgbstdn_pidm
           )
           THEN 'Y'
           ELSE 'N'
       END AS transfer_work

     -- High School Graduation Date
     , (
           SELECT MAX(h.sorhsch_graduation_date)
           FROM sorhsch h
           WHERE h.sorhsch_pidm = s.sgbstdn_pidm
       ) AS hs_graduation_date

FROM sgbstdn s

JOIN spriden r
  ON r.spriden_pidm = s.sgbstdn_pidm
 AND r.spriden_change_ind IS NULL

WHERE r.spriden_id = :Student_ID

-- Stable max-effective-term filter
/*
AND (s.sgbstdn_pidm,
     s.sgbstdn_term_code_admit,
     s.sgbstdn_term_code_eff)

IN (
    SELECT s2.sgbstdn_pidm,
           s2.sgbstdn_term_code_admit,
           MAX(s2.sgbstdn_term_code_eff)
    FROM sgbstdn s2
    GROUP BY s2.sgbstdn_pidm,
             s2.sgbstdn_term_code_admit
)
*/

ORDER BY s.sgbstdn_term_code_eff DESC;


