


*****There is a script written by IR that should be used instead of this one***


--USE THIS SCRIPT TO GET CALL CARDS FOR GRADUATION...this does not include GRN students...see below..kt...3/24/21
--TO FIND STUDENTS THAT HAVE THE MILT ATTRIBUTE ON SGASADD, UNCOMMENT OUT SGRSATT LINES
--GPA has been truncated after the 2nd degit past the decimal
--Added Honors Column and programmed it to add appropiate honor designation based on GPA...kt...4.11.2022
--Added ListAGG()function to put all current student attributes in the same field without having to create a separate row.   
--    and added a check for dual enrollment students based off admit type for 
--    most recent term in SAAADMS...kt...10.25.2022
--Changed the DE student check from most recent SAAADMS App to most recent app that is less than or equal to the grad term.  This will
--   prevent the DE indication from being NULL if the student has reapplied for a term after the updcoming graduation.  


--desc sgrsatt;
--desc saradap;
--desc sgrsatt;

SELECT
    ''                               AS call_card_no,
    spriden.spriden_id               AS student_id,
    spriden.spriden_last_name        AS last_name,
    spriden.spriden_first_name       AS first_name,
    trunc(
        shrlgpa.shrlgpa_gpa,
        2
    )                                AS "TRUNCATED GPA",
    CASE
        WHEN trunc(
                shrlgpa.shrlgpa_gpa,
                2
            ) > '3.49'
             AND trunc(
            shrlgpa.shrlgpa_gpa,
            2
        ) < '3.75' THEN
            'Cum Laude'
        WHEN trunc(
                shrlgpa.shrlgpa_gpa,
                2
            ) > '3.74'
             AND trunc(
            shrlgpa.shrlgpa_gpa,
            2
        ) < '3.9' THEN
            'Magna Cum Laude'
        WHEN trunc(
            shrlgpa.shrlgpa_gpa,
            2
        ) > '3.89' THEN
            'Summa Cum Laude'
    END                              AS "Honors",
    LISTAGG(SGRSATT_ATTS_CODE, ', ') 
    WITHIN GROUP
    (ORDER BY sgrsatt_atts_code)     AS "Attribute(s)", 
    ''                               AS "Cap and Gown",
    shrdgmr.shrdgmr_seq_no           AS deg_seq,
    shrdgmr.shrdgmr_term_code_grad   AS grad_term,
    shrdgmr.shrdgmr_grst_code        AS grad_status,
    shrdgmr.shrdgmr_degc_code        AS degree,
    shrdgmr.shrdgmr_majr_code_1      AS major_1,
    shrdgmr.shrdgmr_majr_code_conc_1 AS conc_1,
    CASE
        WHEN o.saradap_admt_code IN ( 'DE',
                                      'DM' ) THEN
            'Yes'
    END                              AS "Dual Enrollment"
FROM
    shrdgmr,
    sovlcur outter,
    spriden,
    shrlgpa,
    saradap o,
    sgrsatt o
WHERE
        shrdgmr.shrdgmr_pidm = outter.sovlcur_pidm
    AND shrdgmr.shrdgmr_seq_no = outter.sovlcur_key_seqno
    AND shrdgmr.shrdgmr_pidm = o.saradap_pidm
    AND shrdgmr.shrdgmr_pidm = spriden.spriden_pidm
    AND shrdgmr.shrdgmr_pidm = shrlgpa.shrlgpa_pidm
    AND shrdgmr.shrdgmr_pidm = o.sgrsatt_pidm
    AND shrdgmr.shrdgmr_term_code_grad IN ( :term_1,
                                            :term_2,
                                            :term_3 )
    AND shrdgmr.shrdgmr_grst_code != 'GRN'
    AND shrdgmr.shrdgmr_degc_code NOT IN ( 'ACRT1',
                                           'ACRT2' )
    AND outter.sovlcur_current_ind = 'Y'
    AND outter.sovlcur_active_ind = 'Y'
    AND outter.sovlcur_lmod_code = 'OUTCOME'
    AND spriden.spriden_change_ind IS NULL
    AND shrlgpa.shrlgpa_levl_code = 'UG'
    AND shrlgpa.shrlgpa_gpa_type_ind = 'O'
    AND o.sgrsatt_term_code_eff = (
        SELECT
            MAX(i.sgrsatt_term_code_eff)
        FROM
            sgrsatt i
        WHERE
            o.sgrsatt_pidm = i.sgrsatt_pidm
    )
     AND o.saradap_term_code_entry = (
        SELECT
            MAX(i.saradap_term_code_entry)
        FROM
            saradap i
        WHERE
            o.saradap_pidm = i.saradap_pidm                  
    )
    AND o.saradap_term_code_entry <= shrdgmr.shrdgmr_term_code_grad 
GROUP BY
    '',
    spriden.spriden_id,
    spriden.spriden_last_name,
    spriden.spriden_first_name,
    trunc(
        shrlgpa.shrlgpa_gpa,
        2
    ),
    CASE
            WHEN trunc(
                    shrlgpa.shrlgpa_gpa,
                    2
                ) > '3.49'
                 AND trunc(
                shrlgpa.shrlgpa_gpa,
                2
            ) < '3.75' THEN
                'Cum Laude'
            WHEN trunc(
                    shrlgpa.shrlgpa_gpa,
                    2
                ) > '3.74'
                 AND trunc(
                shrlgpa.shrlgpa_gpa,
                2
            ) < '3.9' THEN
                'Magna Cum Laude'
            WHEN trunc(
                shrlgpa.shrlgpa_gpa,
                2
            ) > '3.89' THEN
                'Summa Cum Laude'
    END,
    '',
    shrdgmr.shrdgmr_seq_no,
    shrdgmr.shrdgmr_term_code_grad,
    shrdgmr.shrdgmr_grst_code,
    shrdgmr.shrdgmr_degc_code,
    shrdgmr.shrdgmr_majr_code_1,
    shrdgmr.shrdgmr_majr_code_conc_1,
    CASE
        WHEN o.saradap_admt_code IN ( 'DE',
                                      'DM' ) THEN
                'Yes'
    END
ORDER BY
    grad_term,
    last_name,
    first_name,
    degree