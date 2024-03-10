{%- macro deduped_ref(model_name, partition_field, order_field) -%}
(select *
from {{ ref(model_name) }}
qualify row_number() over (
        partition by {{ partition_field }}
        order by {{ order_field }} desc
    ) = 1)
{%- endmacro -%}
