use food;

# Q5 find the number of unsuccessful order per country, in each year available in the dataset
select date_local, country_name, count from (select date_local, country_name, count(*) as count,
row_number() over (partition by country_name, date_local order by date_local asc) as num
from food.orders
where is_successful_order = 'False'
group by country_name,date_local
order by date_local asc) as temp ;

#6 find the number of unsuccessful order of vendor in each year available in the dataset
select date_local, country_name, vendor_name, count(vendor_name) as count
from (select o.date_local, o.country_name,  o.is_successful_order, v.vendor_name,
row_number() over (partition by date_local, vendor_name ) as count
from food.orders as o, food.vendors as v
where o.vendor_id = v.id and o.is_successful_order = 'False'
order by date_local,country_name asc) as temp 
group by date_local,country_name, vendor_name;

#Q7 
select o.date_local, o.country_name, v.vendor_name,  o.is_successful_order,count(vendor_name) as count
from food.orders as o, food.vendors as v
where o.vendor_id = v.id and is_successful_order='TRUE'
group by date_local, vendor_name ,is_successful_order
order by date_local asc, country_name asc;

select date_local, country_name,vendor_name,is_successful_order,count(is_successful_order) 
from (select o.date_local, o.country_name, v.vendor_name,  o.is_successful_order
,row_number() over (partition by date_local,vendor_name,is_successful_order) as count
from food.orders as o, food.vendors as v
where o.vendor_id = v.id ) as temp 
group by date_local,vendor_name,is_successful_order;

select date_local,country_name,vendor_name, total_count
 from (select o.date_local, o.country_name, v.vendor_name,  o.is_successful_order,count(vendor_name) as total_count 
from food.orders as o, food.vendors as v
where o.vendor_id = v.id 
group by date_local, vendor_name )as temp;

select *, sum(count) as total 
from (select o.date_local, o.country_name, v.vendor_name,  o.is_successful_order,count(vendor_name) as count
from food.orders as o, food.vendors as v
where o.vendor_id = v.id 
group by date_local, vendor_name ,is_successful_order
order by date_local asc, country_name asc, count desc) as temp 
group by date_local, vendor_name ;
