select
  external_reference
from {{ ref('fct_globepay_transaction') }}
where is_missing_chargeback is true
