with gold_layer as (
    select
        count(external_reference) as external_reference,
        'test' as test
    from
        {{ ref('fct_globepay_transaction') }}
),
trusted_layer as (
    select
        count(external_reference) as external_reference,
        'test' as test
    from
        {{ ref('trusted_globepay_acceptance') }}
)
select
    trusted_layer.external_reference as trusted_layer_external_reference,
    gold_layer.external_reference as gold_layer_external_reference
from
    trusted_layer
    join gold_layer using (test)
where
    trusted_layer.external_reference != gold_layer.external_reference