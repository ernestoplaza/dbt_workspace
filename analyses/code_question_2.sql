select
  iso_code_2_card_country,
  transaction_state,
  sum(transaction_usd_amount) as sum_transaction_usd_amount
from {{ ref('fct_globepay_transaction') }}
group by
  iso_code_2_card_country,
  transaction_state
having
  sum_transaction_usd_amount >= 25000000
  and transaction_state = 'DECLINED'
