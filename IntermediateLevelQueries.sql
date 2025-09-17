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
