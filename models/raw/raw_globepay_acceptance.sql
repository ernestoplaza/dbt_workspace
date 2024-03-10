select
    external_ref,
    status,
    source,
    ref,
    date_time,
    state,
    cvv_provided,
    amount,
    country,
    currency,
    rates
from {{ source('source_dataset', 'globepay_acceptance_report') }}
