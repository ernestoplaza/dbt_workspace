# Part 2 Challenge 
The model which has been built in order to answer these three questions is called fct_globepay_transaction. This model is available inside the models folder and inside the gold folder. There is a yml file where is available all the information related to this model, therefore the data analyst could check all the documentation related to the model there. 
In the following paragraphs will be answered the 3 questions of the second part of the challenge:

## Question 1
### What is the acceptance rate over time?

This code is available in the file code_question_1.sql in the folder analyses.
To answer this question the field transaction_date and the field external_reference were included in the model fct_globepay_transaction. Here will be necessary to count the external references where the transaction_state field is equal to ACCEPTED and this number will be divided by the total number of external references. This rate will be rounded by 2. Moreover, this acceptance rate will be grouped by the transaction_date in order to know the evolution for this rate.
The output will be the shown below:

![](resources/ image1.png?raw=true)

<img title="Output question 1" src="resources/image1.png">

## Question 2
### List the countries where the amount of declined transactions went over $25M

This code is available in the file code_question_2.sql in the folder analyses.
To answer this question the fields iso_code_2_card_country, transaction_state and transaction_usd_amount were included in the model fct_globepay_transaction.
It will be needed group the fields iso_code_2_card_country and transaction_state in order to know the sum of the amount in USD which previously have been calculated in the fact model. Then, it will be filtered the countries when the amount is greater than 25 million of USD.
The output will be shown below:

![](resources/ image2.png?raw=true)

<img title="Output question 2" src="resources/image2.png">

## Question 3
### Which transactions are missing chargeback data?

This code is available in the file code_question_3.sql in the folder analyses.
For this question it has been considered that the missing chargeback data is when for the external reference there is no value available related to chargeback.
The fields external_reference and is_missing_chargeback were included in the model fct_globepay_transaction.
It will be shown the external reference when the boolean field is_missing_chargeback is equal to true, this field will have a value of true when the external reference which is in the acceptance table is not in the chargeback table, so for that external reference there is not chargeback information available.
The query will only show the external reference when is_missing_chargeback is true.
The output will be shown below:

![](resources/ image3.png?raw=true)

<img title="Output question 3" src="resources/image3.png">

In this case there are not external references that have mising chargeback data.