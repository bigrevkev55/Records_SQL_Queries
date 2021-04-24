-- Script to Pull Graduate Data from Banner to Import into Diplomas on Demand
-- Must translate state to full name for import
-- Must add column for template: Template AA/AS (AA/AFA/AS/AST), Template AAS, and 
-- Template Technical Certificate (for technical and academic)
select distinct spriden_id as "Student ID" -- Added Spriden ID...LLW 4-16-11
,      spriden_first_name       as "First Name"
,      spriden_mi               as "Middle Name"
,      spriden_last_name        as "Last Name"
--,       rtrim(spriden_first_name)
--    ||     ' '
--    ||     rtrim(spriden_mi)
--    ||     ' '
--    ||     rtrim(spriden_last_name) as "Full Name"
,      SHRDGMR_TERM_CODE_GRAD   as "Term"
--,      SOVLCUR_KEY_SEQNO        as "Deg_Seq"
--,      SHRDGMR_DEGS_CODE        as "Award_Status"
--,      SHRDGMR_GRST_CODE        as "Degree_Status"
--,      SHRDGMR_PROGRAM          as "Program_Code"
,      SHRDGMR_DEGC_CODE        as "Degree 1"
,      SHRDGMR_MAJR_CODE_1      as "Major 1"
,      SHRDGMR_MAJR_CODE_CONC_1 as "Concentration"
,      nvl(honr_code,' ')    as "Honor 1" -- modified 2013-08-22.pak
--,      GOREMAL_EMAIL_ADDRESS || ';'   as "E-mail"  -- Added 2/15/12 Printed MyNSCC E-mail with Semicolon after it...LLW
,      spraddr_street_line1     as "Address 1"
,      spraddr_street_line2     as "Address 2"
,      spraddr_city             as "City"
--,      spraddr_stat_code        as "State/Province"
,      stvstat_desc             as "State/Province" --Added 5/13/16 to State Code Description
,      spraddr_zip              as "Postal Code"
from  spriden
,     stvstat --Added 5/13/16 to pull State Code Description
--,     goremal
,     spraddr c
,     shrdgmr
,     (select shrdgih_pidm -- added subquery 2013-08-22.pak
       ||     shrdgih_dgmr_seq_no honr_key
       ,      stvhonr_code honr_code
       from   shrdgih
       ,      stvhonr
       where  shrdgih_honr_code = stvhonr_code
      )
,     sovlcur a

,    (select spraddr_pidm
      ,      min(spraddr_atyp_code) as minatyp 
      from   spraddr 
      where  spraddr_status_ind is null 
      and    spraddr_to_date is null
      and    spraddr_atyp_code in ('LO','PR')
      group by spraddr_pidm) b 
where spriden_change_ind is null 
and   spriden_entity_ind='P' 
and   C.spraddr_pidm = shrdgmr_pidm -- changed b.spraddr_pidm to c.spraddr_pidm 2011-04-15.PAK
and   c.spraddr_pidm = spriden_pidm
and   c.spraddr_pidm = sovlcur_pidm
--and   c.spraddr_pidm = shrdgih_pidm -- removed 2013-08-22.pak
and   c.spraddr_pidm = b.spraddr_pidm -- added 2011-04-15.PAK
--and   c.spraddr_pidm = goremal_pidm -- added 2/15/12...LLW
and   c.spraddr_atyp_code = b.minatyp
and   c.spraddr_status_ind is null
and   c.spraddr_to_date is null
and   c.spraddr_stat_code = stvstat_code
-- and   shrdgih_honr_code = stvhonr_code -- removed 2013-08-22.pak
and   shrdgmr_pidm||shrdgmr_seq_no = honr_key(+) -- added 2013-08-22.pak
AND SHRDGMR_TERM_CODE_GRAD = :Grad_Term
--AND SHRDGMR_TERM_CODE_GRAD IN (:Grad_Term_1,:Grad_Term_2,:Grad_Term_3)
--and spriden_id IN ('A00473718','A00335522','A00510014','A00485287','A00484228','A00484230','A00404467','A00378403')
AND SHRDGMR_GRST_CODE IN ('GR','RTS')
--and SHRDGMR_PROGRAM IN ('CERT_AAS_GE','CERT_UNPA_GE') -- Added 6/2/14 to only import General Education Certificates...LLW
--and SHRDGMR_PROGRAM = :Program_Code --Added 5/16/16 to prompt for specific program code...LLW
and SHRDGMR_PROGRAM NOT IN ('CERT_AAS_GE','CERT_UNPA_GE') -- Added 2/15/12 to exclude General Education Certificates...LLW 
--and goremal_emal_code = 'CAMP' -- Added 2/15/12 to include Student MyNSCC E-mail...LLW
AND SOVLCUR_SEQNO = (select max(sovlcur_seqno) from sovlcur where sovlcur_pidm = a.sovlcur_pidm)
order by SHRDGMR_DEGC_CODE,spriden_last_name,spriden_first_name;