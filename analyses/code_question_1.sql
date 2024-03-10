select
  date(transaction_date) as transaction_date,
  round(count(distinct
  case
    when
      transaction_state = 'ACCEPTED' then external_reference
    else null
    end) / count(distinct external_reference), 2) as acceptance_rate
from {{ ref('fct_globepay_transaction') }}
