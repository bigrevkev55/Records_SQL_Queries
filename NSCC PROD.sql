
select distinct SHRTRCE_pidm, SHRTRCE_ACTIVITY_DATE from shrtrce
where SHRTRCE_CREDIT_HOURS = '0' and shrtrce_repeat_course is null;

select distinct spriden_id from spriden where spriden_pidm = '289852';

desc shrtrce;

select spriden_id from spriden where spriden_pidm = '376991';

select * from shrtrce where shrtrce_pidm = (select distinct spriden_pidm from spriden where spriden_id = 'A00679273');

desc shrgrde;
select * from shrgrde;

select * from shrgrde where shrgrde_gpa_ind = 'N';

select * from shrtgpa where shrtgpa_pidm = (Select distinct spriden_pidm from spriden where spriden_id = 'A00679273');
