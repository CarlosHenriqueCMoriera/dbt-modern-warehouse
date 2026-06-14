{% snapshot customers_snapshot %}

{{
    config(
        target_schema='public',
        unique_key='customer_id',
        strategy='timestamp',
        updated_at='updated_at',
    )
}}

select
    id as customer_id,
    first_name,
    last_name,
    current_timestamp as updated_at
from {{ ref('raw_customers') }}

{% endsnapshot %}
