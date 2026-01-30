SELECT * FROM us_income.us_household_income;
SELECT * FROM us_income.us_household_income_statistics;

alter table us_household_income_statistics rename column `ï»¿id` to `ID`;

select id, count(id)
from us_household_income
group by id
having count(id) >1 ;

select * from us_household_income where id = '10226';

select *
from (
select row_id, id, 
row_number () over(partition by id order by id) rn
from us_household_income) duplicates
where rn >1 ;

set sql_safe_updates = 0;

delete from us_household_income
where row_id in(
	select row_id
	from (
		select row_id, id, 
		row_number () over(partition by id order by id) rn
		from us_household_income) duplicates
	where rn >1);
    
set sql_safe_updates = 1;

select id , count(id)
from us_income.us_household_income_statistics
group by id
having count(id) > 1;

select distinct state_name 
from us_income.us_household_income
order by 1 ;

update us_income.us_household_income
set state_name = 'Georgia'
where state_name = 'georia';

select * from us_income.us_household_income
where place = '0' or place = '' or place is null;

update us_income.us_household_income
set place = 'Autaugaville'
where county = 'Autauga County'
and city = 'Vinemont';

select type, count(type)
from us_income.us_household_income
group by type;

update us_income.us_household_income
set type = 'Borough'
where type = 'Boroughs';

select Aland, AWater
from us_income.us_household_income
where (Aland = '0' or Aland ='' or Aland is null) 
	and (Awater = '0' or Awater = '' or Awater is null);

select state_name, sum(Aland), sum(Awater)
from us_household_income
group by (state_name)
order by 2 desc;

select type, count(type),round(avg(mean),1), round(avg(median),1)
from us_household_income u
inner join us_income.us_household_income_statistics us
	on u.id = us.id
where mean <> 0
group by type
order by 4 desc
limit 20;

select * 
from us_household_income
where type = 'community';

select u.State_Name, city, round(avg(mean),1), round(avg(median),1)
from us_household_income u
inner join us_income.us_household_income_statistics us
	on u.id = us.id
group by u.State_Name, city
order by round(avg(mean),1) desc;

select *
from us_income.us_household_income_statistics
where mean = '0';

select u.id, u.state_name, county, city, place, type,
Aland, Awater, Lat, Lon, mean, median, stdev, sum_w
from us_household_income u
inner join us_income.us_household_income_statistics us
	on u.id = us.id
where mean > 0 and median > 0 and stdev > 0 and sum_w >0 
and type not in ('Municipality', 'CPD', 'County','Urban');