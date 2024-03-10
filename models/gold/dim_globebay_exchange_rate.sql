with all_exchanges_rates as (
    select
        external_reference,
        json_value(transaction_rates, '$.CAD') as cad_exchange_rate,
        json_value(transaction_rates, '$.EUR') as eur_exchange_rate,
        json_value(transaction_rates, '$.USD') as usd_exchange_rate,
        json_value(transaction_rates, '$.MXN') as mxn_exchange_rate,
        json_value(transaction_rates, '$.GBP') as gbp_exchange_rate
    from {{ ref('trusted_globepay_acceptance') }}
),

unpivot_exchange_rates as (
    select
        *
    from all_exchanges_rates
    unpivot(
        exchange_rate for iso_code_3_exchange_rate_currency in
            (
                cad_exchange_rate as 'CAD',
                eur_exchange_rate as 'EUR',
                usd_exchange_rate as 'USD',
                mxn_exchange_rate as 'MXN',
                gbp_exchange_rate as 'GBP'
            )
        )
)

select
    external_reference,
    cast(exchange_rate as float64) as exchange_rate,
    iso_code_3_exchange_rate_currency
from unpivot_exchange_rates