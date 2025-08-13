create database pizzahut;

select*from pizzahut.pizzas;
select*from pizzahut.pizza_types;

-- For big databases we have to first create table in sql 
create table orders(
order_id int not null,
order_date date not null,
order_time time not null,
primary key (order_id));

select*from orders;

-- Q.1 Retrieve total number of orders placed
select count(order_id) as Total_Orders 
from pizzahut.orders;

-- Q.2 Calculate total revenue genrated from pizza sales.
SELECT ROUND(SUM(order_details.quantity * pizzas.price),2)	AS total_sales
FROM pizzahut.order_details JOIN
pizzahut.pizzas ON pizzas.pizza_id = order_details.pizza_id;

-- Q.3 Identify highest priced pizza
select pizza_types.name ,pizzas.price
from pizzahut.pizza_types join 
pizzahut.pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by price desc limit 1;

-- Q.4 Identify most common pizza size ordered
select pizzas.size , count(order_details.order_details_id) as order_count
from pizzas join order_details 
on pizzas.pizza_id=order_details.pizza_id
group by pizzas.size
order by  count(order_details.order_details_id) desc  ;

-- Q.5 5 most ordered pizza types along with their quantities
select pizza_types.name ,sum(order_details.quantity) as quantity
from pizza_types join pizzas 
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details 
on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.name order by  quantity desc limit 5;

-- Intermediate level queries 

-- Q.6 Join necessary tables to find the total quamtity of each pizza category ordered.
select pizza_types.category ,sum(order_details.quantity) as quantity
from pizza_types join pizzas 
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details on 
order_details.pizza_id=pizzas.pizza_id
group by pizza_types.category order by quantity desc;


-- Q.7 Determine distribution of orders by hour of day
select hour(order_time) ,count(order_id) from orders
group by hour (order_time);


-- Q.8 Category wise distribution of pizzas
select category ,count(pizza_type_id) from pizza_types
group by category ;
 

-- Q.9 Group orders by date and calculate avg no of pizzas ordered per day
select round(avg(quantity),0) as avg_pizza_perday from
(select orders.order_date, sum(order_details.quantity) as quantity
from orders join order_details on
orders.order_id=order_details.order_id
group by orders.order_date) as order_quantity;


-- Q.10 Detrmine top 3 most ordered pizza types based on revenue
select  pizza_types.name , sum(pizzas.price*order_details.quantity) as revenue 
from pizza_types join pizzas 
on pizzas.pizza_type_id=pizza_types.pizza_type_id 
join order_details
on order_details.pizza_id=pizzas.pizza_id
group by  pizza_types.name order by revenue desc limit 3;

-- Advanced level queries 

-- Q.11 Calculate percentage contribution of each pizza type to total revenue
SELECT pizza_types.category,ROUND((pizzas.price * order_details.quantity) / (SELECT SUM(order_details.quantity * pizzas.price) 
FROM order_details JOIN 
pizzas ON pizzas.pizza_id = order_details.pizza_id) * 100, 2) AS revenue_percentage
FROM pizza_types JOIN 
pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id 
JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY revenue_percentage DESC;


-- Q.12 Analyze cumulative revenue genrated over time
select order_date, sum(revenue) over(order by order_date) as cum_revenue
from 
(select orders.order_date, round(sum(order_details.quantity*pizzas.price),2) as revenue
from order_details join pizzas
on order_details.pizza_id=pizzas.pizza_id
join orders on
orders.order_id=order_details.order_id
group by orders.order_date) as sales ;


-- Q.13 Determine top 3 most ordered pizza types based on revenue for each category 
select name,revenue from
(select category,name,revenue,
rank() over(partition by category order by revenue desc) as rn from
(select pizza_types.category,pizza_types.name,sum((order_details.quantity)*pizzas.price)
as revenue 
from pizza_types join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details
on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.category,pizza_types.name) as a) as b
where rn<=3;

