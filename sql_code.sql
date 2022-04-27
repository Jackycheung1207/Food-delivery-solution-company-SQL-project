use food;

#Q1 list all the orders that were made in Taiwan
select * from orders
where country_name='Taiwan'; 

#Q2 Find the total GMV by country
select country_name, round( sum(gmv_local) , 2) as total_gmv
from food.orders
group by country_name;

#Q3 Find the top active vendor by GMV in each country
select country_name,vendor_name, total_gmv from (select o.country_name, v.vendor_name, round( sum(gmv_local),2) as total_gmv 
, row_number() over (partition by country_name order by sum(gmv_local) desc) as gmv_rank
from food.orders as o, food.vendors as v
where o.vendor_id = v.id
group by o.country_name,v.vendor_name) as ranks
where gmv_rank=1;
 

#Q4 Find the top 2 vendors per country, in each year available in the dataset
select date_local,country_name,vendor_name, total_gmv from (select o.country_name, v.vendor_name, o.date_local,round( sum(gmv_local),2) as total_gmv 
, row_number() over (partition by country_name,date_local order by sum(gmv_local) desc) as gmv_rank
from food.orders as o, food.vendors as v
where o.vendor_id = v.id
group by o.country_name,v.vendor_name,o.date_local) as ranks
where gmv_rank<=2
order by date_local;

# Q5 find the number of unsuccessful order per country, in each year available in the dataset
select date_local, country_name, count as unsuccessful_order_count from (select date_local, country_name, count(*) as count,
row_number() over (partition by country_name, date_local order by date_local asc) as num
from food.orders
where is_successful_order = 'False'
group by country_name,date_local
order by date_local asc) as temp ;

#6 find the number of unsuccessful order of vendor in each year available in the dataset
select date_local, country_name, vendor_name, count(vendor_name) as unsuccessful_order_count
from (select o.date_local, o.country_name,  o.is_successful_order, v.vendor_name,
row_number() over (partition by date_local, vendor_name ) as count
from food.orders as o, food.vendors as v
where o.vendor_id = v.id and o.is_successful_order = 'False'
order by date_local,country_name asc) as temp 
group by date_local,country_name, vendor_name;


