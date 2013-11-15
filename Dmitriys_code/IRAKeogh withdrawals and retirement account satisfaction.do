//**IRA/Keogh withdrawals and retirement account satisfaction**//

//To calculate the number of people who withdrew money from their IRA/Keogh accounts//

tab X6557 [weight=frequency_weight_round] if X6557~=0

//to calculate the mean value of the withdrawal//

summarize X6558 [weight=frequency_weight_round] if X6558>=1


//Retirement Income Satisfaction//
tab X3023 [weight=frequency_weight_round] 
