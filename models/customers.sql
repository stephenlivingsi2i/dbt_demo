{{
  config(
    materialized='table'
  )
}}

with customer as (

    select * from {{ ref('stg_customer') }}

),

orders as (

    select * from {{ ref('stg_orders') }}

),

customer_orders as (
    select
        customer_id,
        status,
        amount,
        amount_dollers,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders
    from orders
    group by (customer_id, status, amount, amount_dollers)
),

final as (
    select
        customer.customer_id,
        customer.name,
        customer_orders.status,
        customer_orders.amount,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        customer_orders.amount_dollers,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
        -- New transformation: Calculate total amount spent by each customer
        sum(orders.amount) as total_amount_spent
    from customer
    left join customer_orders using (customer_id)
    left join orders using (customer_id)
    group by 1, 2, 3, 4, 5, 6, 7, 8
)

select * from final