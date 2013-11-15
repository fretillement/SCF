                              
 //This code provides broad averages but can't be used to separate by demographics,//
            // as it gives the same mean value to all of the observations//
/*
summarize retirement_account [weight=frequencyweight]
generate mean_retirement_account = r(mean)

summarize Total_Financial_Assets [weight=frequencyweight] 
generate mean_total_financial_assets = r(mean)

generate percent_financial_share = mean_retirement_account / mean_total_financial_assets



summarize Total_Nonfinancial_Assets [weight=frequencyweight]
generate mean_nonfinancial_assets = r(mean)

generate percent_nonfinancial_share = mean_retirement_account / mean_nonfinancial_assets



summarize TOTAL_ASSETS [weight=frequencyweight]
generate mean_total_assets = r(mean)

generate percent_total_share = mean_retirement_account / mean_total_assets
*/

                
                         //This code provides specific demographic averages//

                                    //Numbers for all families//
						    
quietly summarize retirement_account [weight=frequencyweight], detail
generate all_retiremenet_account = r(mean)
quietly summarize TOTAL_ASSETS [weight=frequencyweight], detail
generate all_financial_assets = r(mean)

di all_retiremenet_account / all_financial_assets

						 
                  //Retirement Accounts as a percentage of Total Assets//

				  
forval x = 1/6 {
quietly summarize retirement_account [weight=frequencyweight] if income_percentile==`x', detail
generate income_retirement_account`x' = r(mean)
quietly summarize TOTAL_ASSETS [weight=frequencyweight] if income_percentile==`x', detail
quietly generate income_financial_assets`x' = r(mean)

di income_retirement_account`x' /  income_financial_assets`x'
}				  
				  
forval x = 1/6 {
quietly summarize retirement_account [weight=frequencyweight] if age==`x', detail
generate age_retirement_account`x' = r(mean)
quietly summarize TOTAL_ASSETS [weight=frequencyweight] if age==`x', detail
quietly generate age_financial_assets`x' = r(mean)

di age_retirement_account`x' /  age_financial_assets`x'
} 

 forval x = 1/5 {
quietly summarize retirement_account [weight=frequencyweight] if family_structure==`x', detail
generate family_retiremenet_account`x' = r(mean)
quietly summarize TOTAL_ASSETS [weight=frequencyweight] if family_structure==`x', detail
generate family_financial_assets`x' = r(mean)

di family_retiremenet_account`x' / family_financial_assets`x'
}

forval x = 1/4 {
quietly summarize retirement_account [weight=frequencyweight] if education==`x', detail
generate education_retiremenet_account`x' = r(mean)
quietly summarize TOTAL_ASSETS [weight=frequencyweight] if education==`x', detail
generate education_financial_assets`x' = r(mean)

di education_retiremenet_account`x' / education_financial_assets`x'
}

forval x = 1/2 {
quietly summarize retirement_account [weight=frequencyweight] if race==`x', detail
generate race_retiremenet_account`x' = r(mean)
quietly summarize TOTAL_ASSETS [weight=frequencyweight] if race==`x', detail
generate race_financial_assets`x' = r(mean)

di race_retiremenet_account`x' / race_financial_assets`x'
}

forval x = 1/4 {
quietly summarize retirement_account [weight=frequencyweight] if work_status==`x', detail
generate work_retiremenet_account`x' = r(mean)
quietly summarize TOTAL_ASSETS [weight=frequencyweight] if work_status==`x', detail
generate work_financial_assets`x' = r(mean)

di work_retiremenet_account`x' / work_financial_assets`x'
}

forval x = 1/4 {
quietly summarize retirement_account [weight=frequencyweight] if occupation==`x', detail
generate occupation_retiremenet_account`x' = r(mean)
quietly summarize TOTAL_ASSETS [weight=frequencyweight] if occupation==`x', detail
generate occupation_financial_assets`x' = r(mean)

di occupation_retiremenet_account`x' / occupation_financial_assets`x'
}

forval x = 1/2 {
quietly summarize retirement_account [weight=frequencyweight] if housing_status==`x', detail
generate housing_retiremenet_account`x' = r(mean)
quietly summarize TOTAL_ASSETS [weight=frequencyweight] if housing_status==`x', detail
generate housing_financial_assets`x' = r(mean)

di housing_retiremenet_account`x' / housing_financial_assets`x'
}

forval x = 1/5 {
quietly summarize retirement_account [weight=frequencyweight] if net_worth_percentile==`x', detail
generate net_worth_retiremenet_account`x' = r(mean)
quietly summarize TOTAL_ASSETS [weight=frequencyweight] if net_worth_percentile==`x', detail
generate net_worth_financial_assets`x' = r(mean)

di net_worth_retiremenet_account`x' / net_worth_financial_assets`x'
}


