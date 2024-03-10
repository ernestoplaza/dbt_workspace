select
    external_ref,
    status,
    source,
    chargeback
from {{ source('source_dataset', 'globepay_chargeback_report') }}
