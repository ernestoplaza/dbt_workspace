select
    external_ref as external_reference,
    status as transaction_status,
    upper(source) as transaction_source,
    chargeback as is_chargeback
from {{ deduped_ref('raw_globepay_chargeback', 'external_ref', 'status') }}