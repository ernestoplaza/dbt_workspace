# Part 1 Challenge
In this document will be answered the questions related to the first part of the challenge.

## Preliminary data exploration

The following points have been developed in the preliminary data exploration:

- All the string fields looks good in terms of consistency, anyway it will be applied an upper function in order to ensure this consistency in future values. This will be applied in the trusted layer which will be explained below

- It was checked that the values of the external_reference field were unique and not null in the raw information. This will be the primary key that will be used to cross information between the acceptance and chargeback data, therefore it is needed to check that. Anyway, it will be applied a dedup with a macro that will be explained in the 4th paragraph that will ensure that there is not duplicated rows, due to this field must be unique for each one

- There is a json field called rates in the globepay_acceptance_report file. There will be a dimension model that will shows each currency and exchange rate for transaction.

In a preliminary data exploration it was checked that currently, the possible currency values are USD, CAD, EUR, MXN and GBP. Therefore, each transaction will show the exchange rates for these currencies.
The code made for this exploration was the following:

```
select distinct
    upper(currency)
from {{ ref('raw_globepay_acceptance') }}
```

## Summary of your model architecture

In this model architecture will be 3 layers:

### Raw layer

This layer receives the sources which have been defined in the yml sources.yml in the folder models and raw.

In this layer will be information in a raw format without any transformation applied. These models are inside the folder models and in the folder raw and they will have the prefix *raw-*

### Trusted layer

This layer receives the data which is in the raw layer.
In this layer will be made a dedup in order to ensure that there are not duplicated rows in this layer. Moreover it will be applied an upper function with string fields in order to ensure the consistency, in addition to apply the right naming convention for each field which comes from the raw layer.
This layer will be the base to build the models in the next layer, the gold layer. These models are inside the folder models and in the folder trusted and they will have the prefix *trusted-*

### Gold layer

This layer receives the data which is in the trusted layer.
In this layer will be built the dimension and the fact tables depending on the source which provides the information, in this case all the models have the same source, **globepay**. These models are inside the folder models and in the folder gold and they will have the prefix *dim-* or *fct* depending on if it is a dimension or a fact model

In the trusted and gold layer could be included a folder called intermediate where any table which includes any transformation will be used for the models in each layer. These intermediate models will have an own schema.

## Lineage graphs

The lineage is key in order to understand how each model is built, this helps to debug any error and identifies any inconsistency in the data which is reported.

In the following paragraphs will be shown the lineage for each model:

### Trusted_globepay_acceptance

In the below image is shown the lineage for the model trusted_globepay_acceptance, which the upstream dependency is raw_globepay_acceptance and the dependencies downstream are dim_globepay_exchange_rate and fct_globepay_transaction. It was included as well an expected values test in the field iso_code_3_transaction_currency due to the model dim_globepay_exchange_rate was made following this criteria:

![Lineage Trusted_globepay_acceptance model](https://github.com/ernestoplaza/dbt_workspace/blob/master/resources/trusted_globepay_acceptande_lineage.png)

### Trusted_globepay_chargeback

In the below image is shown the lineage for the model trusted_globepay_chargeback, which the upstream dependency is raw_globepay_chargeback and the dependency downstream is fct_globepay_transaction:

![Lineage Trusted_globepay_chargeback model](https://github.com/ernestoplaza/dbt_workspace/blob/master/resources/trusted_globepay_chargeback_lineage.png)

### Dim_globepay_exchange_rate

In the below image is shown the lineage for the model dim_globepay_exchange_rate, which the upstream dependency is trusted_globepay_acceptance and the dependency downstream is fct_globepay_transaction. This model will have a not null test for the primary key external reference, however there will not have the unique test here due to there will be for each currency the value of the exchange rate for each external reference.

Moreover, in this model only will have the exchange rate values for the currencies USD, CAD, EUR, MXN and GBP. The reason, why only these currencies have been included in this table, has been explained in the paragraph *preliminary data exploration*:

![Lineage Dim_globepay_exchange_rate model](https://github.com/ernestoplaza/dbt_workspace/blob/master/resources/dim_globepay_echange_rate_lineage.png)

### Fct_globepay_transaction

In the below image is shown the lineage for the model fct_globepay_transaction, which the upstream dependencies are trusted_globepay_acceptance, trusted_globepay_chargeback and dim_globepay_exchange_rate. Moreover, this model will have two tests, unique and not null for the primary key external_reference

![Lineage Fct_globepay_transaction model](https://github.com/ernestoplaza/dbt_workspace/blob/master/resources/fct_globepay_transaction_lineage.png)

## Tips around macros, data validation, and documentation

In the following paragraphs will be developed each point:

### Macros
The dbt macros are useful in order to avoid replicate code using parameters in order to generate that code depending on those parameters. In this project has been included a macro called deduped_ref which has been documented in a yml that will be used when a dedup it is needed to avoid duplicated rows. In this project this has been used in the trusted layer where the goal is to avoid duplicated information. 

### Data validation
The data quality is key in order to ensure that all the information which is used is tested and validated. In this case, all the unique keys in the models will have a unique and not null test in each yml file and it is key to ensure that the number of unique keys is the same in the change of layer trusted and gold. Related to this, it was included a test which is in the test folder called assert_fct_globepay_transaction_trusted_globepay_acceptance which ensures that the number of external references are the same in fct_globepay_transaction model and in trusted_globepay_acceptance which is the model used as from in fct_globepay_transaction

### Documentation
It is key to keep consistency in the documentation of the models due to whenever it is needed to use a model this documentation will be used. There is a dbt package which is useful for this which is called codegen. This package has been included in the package yml and allows to generate ymls of the models without effort, moreover it is possible to use the descriptions of the fields in the upstream models. In the folder analysis has been included a template called template_codegen, the only parameter needed is the model name and put the parameter upstream_descriptions as true if the goal is to use the descriptions of the upstream models, this will generate consistency between the layers.