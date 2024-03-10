select
    external_ref as external_reference,
    status as transaction_status,
    upper(source) as transaction_source,
    ref as reference,
    date_time as transaction_date,
    upper(state) as transaction_state,
    cvv_provided as is_cvv_provided,
    amount as transaction_amount,
    upper(country) as iso_code_2_card_country,
    upper(currency) as iso_code_3_transaction_currency,
    rates as transaction_rates
from {{ deduped_ref('raw_globepay_acceptance', 'external_ref', 'date_time') }}
