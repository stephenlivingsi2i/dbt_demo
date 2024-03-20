select
    order_id,
    customer_id,
    quantity,
    order_date,
    status,
    amount,
  {{ rupees_to_dollars('amount') }} as amount_dollers

from dbtdb.public.orders
