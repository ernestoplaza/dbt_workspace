select
    acceptance.external_reference,
    acceptance.transaction_date,
    acceptance.transaction_state,
    acceptance.iso_code_2_card_country,
    cast(
        round(
                acceptance.transaction_amount * dim_exchange.exchange_rate, 2
            ) as numeric
        ) as transaction_usd_amount,
    if(
        chargeback.external_reference is null,
        true,
        false
        ) as is_missing_chargeback
from {{ ref('trusted_globepay_acceptance') }} acceptance
left join {{ ref('dim_globebay_exchange_rate') }} dim_exchange
on acceptance.external_reference = dim_exchange.external_reference
and acceptance.iso_code_3_transaction_currency = dim_exchange.iso_code_3_exchange_rate_currency
left join {{ ref('trusted_globepay_chargeback') }} chargeback
on acceptance.external_reference = chargeback.external_reference
