select * from status
select * from demographics
select * from services
select * from location

select
count(s.Customer_ID) as Total_Customers,
sum(s.Churn_Value) as Churned_Customers,
cast(sum(s.Churn_Value)*100.0/count(*) as decimal(10,2)) as Churn_Rate,
sum(case when s.Churn_Value=0 then 1 else 0 end) as Active_Customers,
sum(case when s.Customer_Status='Stayed' then 1 else 0 end) as Stayed_Customers,
cast(sum(case when s.Customer_Status='Stayed' then 1 else 0 end)*100.0/count(*) as decimal(10,2)) as Stay_Rate,
sum(case when s.Customer_Status='Joined' then 1 else 0 end) as New_Customers,
cast(sum(case when s.Customer_Status='Joined' then 1 else 0 end)*100.0/count(*) as decimal(10,2)) as New_Rate,
cast(avg(cast(s.Satisfaction_Score as float)) as decimal(10,2)) as Avg_Satisfaction_Score,
cast(avg(case when s.Churn_Value=1 then cast(s.Satisfaction_Score as float) end) as decimal(10,2)) as Avg_Satisfaction_Churned,
sum(case when s.Churn_Score>=80 then 1 else 0 end) as High_Risk_Customers
from status s

--Churn by Gender 
select
Gender as Gender,
count(s.Customer_ID) as Total_Customers,
sum(Churn_Value) as Churned_Customers,
cast(sum(Churn_Value)*100.0/count(*) as decimal(10,2)) as Churn_Rate
from demographics d
join status s
on d.Customer_ID = s.Customer_ID
group by Gender

--Churn by Age
select
case
when Age < 30 then 'Under_30'
when Age between 30 and 50 then '30_50'
else 'Above_50'
end as Age_Group,
count(*) as Total_Customers,
sum(Churn_Value) as Churned_Customers,
cast(sum(Churn_Value)*100.0/count(*) as decimal(10,2)) as Churn_Rate
from demographics d
join status s
on d.Customer_ID=s.Customer_ID
group by
case
when Age < 30 then 'Under_30'
when Age between 30 and 50 then '30_50'
else 'Above_50'
end

--Churn by Contract 
select
se.Contract as Contract_Type,
count(s.Customer_ID) as Total_Customers,
sum(s.Churn_Value) as Churned_Customers,
cast(sum(s.Churn_Value)*100.0/count(*) as decimal(10,2)) as Churn_Rate
from services se
join status s
on se.Customer_ID = s.Customer_ID
group by se.Contract

--Churn by Internet 
select
se.Internet_Type as Internet_Type,
count(s.Customer_ID) as Total_Customers,
sum(Churn_Value) as Churned_Customers,
cast(sum(Churn_Value)*100.0/count(*) as decimal(10,2)) as Churn_Rate
from services se
join status s
on se.Customer_ID = s.Customer_ID
group by Internet_Type

--Churn by Tech Support
select
Premium_Tech_Support as Tech_Support,
count(s.Customer_ID) as Total_Customers,
sum(Churn_Value) as Churned_Customers,
cast(sum(Churn_Value)*100.0/count(*) as decimal(10,2)) as Churn_Rate
from services se
join status s
on se.Customer_ID = s.Customer_ID
group by Premium_Tech_Support

--Churn by Online Security
select
Online_Security as Online_Security,
count(s.Customer_ID) as Total_Customers,
sum(Churn_Value) as Churned_Customers,
cast(sum(Churn_Value)*100.0/count(*) as decimal(10,2)) as Churn_Rate
from services se
join status s
on se.Customer_ID = s.Customer_ID
group by Online_Security

--Churn by Offer
select
Offer as Offer,
sum(case when s.Customer_Status='Stayed' then 1 else 0 end) as Stayed_Customers,
sum(case when s.Customer_Status='Churned' then 1 else 0 end) as Churned_Customers,
cast(sum(case when s.Customer_Status='Churned' then 1 else 0 end) * 100.0
    / count(*)as decimal(10,2)) as Churn_Rate,
cast(sum(case when s.Customer_Status='Stayed' then 1 else 0 end) * 100.0
   / count(*)as decimal(10,2)) as Stay_Rate
from services se
join status s
on se.Customer_ID=s.Customer_ID
group by Offer
order by Churn_Rate desc

--churn by Satisfaction Score
select
Satisfaction_Score as Satisfaction_Score,
count(*) as Total_Customers,
sum(Churn_Value) as Churned_Customers
from status
group by Satisfaction_Score
order by Satisfaction_Score

--Churn Category
select
Churn_Category as Churn_Category,
count(*) as Churned_Customers,
cast(count(*) * 100.0 / sum(count(*)) over() as decimal(10,2)) as Churn_Rate
from status
where Churn_Value=1
group by Churn_Category
order by Churned_Customers desc

--Churn by region
select top 6
l.City as City,
count(s.Customer_ID) as Total_Customers,
sum(s.Churn_Value) as Churned_Customers,
cast(sum(s.Churn_Value) * 100.0 / count(s.Customer_ID) as decimal(10,2)) as Churn_Rate
from location l
join status s
on l.Customer_ID = s.Customer_ID
group by l.City
order by Churned_Customers desc