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



select*from pizzahut.pizzas;
* select*from pizzahut.order_details;
select*from pizzahut.orders;
* select*from pizzahut.pizza_types;