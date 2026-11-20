create database bank;
use bank;

#1.Year wise loan amount Stats
alter table finance_1 add column issue_year date;
set sql_safe_updates = 0;
UPDATE finance_1
SET issue_year = STR_TO_DATE(TRIM(issue_d), '%d-%m-%Y');
select year(issue_year) as "Year",sum(loan_amnt) as "Total Loan Amount" from finance_1 group by year(issue_year) order by year(issue_year);

#2.Grade and sub grade wise revol_bal
select f1.grade,f1.sub_grade,sum(f2.revol_bal) as "Total revol bal" from finance_1 f1 left join 
finance_2 f2 on f1.id = f2.id group by f1.grade,f1.sub_grade order by f1.grade,f1.sub_grade;

#3.Total Payment for Verified Status Vs Total Payment for Non Verified Status
select f1.verification_status,sum(f2.total_pymnt) as "Total Payments"
from finance_1 f1 left join finance_2 f2 on f1.id = f2.id group by f1.verification_status;

#4.State wise and last_credit_pull_d wise loan status
select f1.addr_state as State,f2.last_credit_pull_d as last_credit_pull_date,
f1.loan_status from finance_1 f1 left join finance_2 f2 on f1.id = f2.id 
group by f1.addr_state,f2.last_credit_pull_d,f1.loan_status order by state asc,last_credit_pull_d desc;

#5.Home ownership Vs last payment date stats
select f1.home_ownership,year(f2.last_payment_date) as last_payment_date,COUNT(*) AS total_loans_paid,
    SUM(f2.last_pymnt_amnt) AS total_last_payment_received from finance_1 f1 left join finance_2 f2 on f1.id = f2.id  WHERE 
    f2.last_payment_date IS NOT NULL group by f1.home_ownership,year(f2.last_payment_date) order by f1.home_ownership,last_payment_date asc;