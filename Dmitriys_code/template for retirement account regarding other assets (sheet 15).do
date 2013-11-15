

                     //Generating a Combined Bonds Variable//
					 
generate bonds2 = bonds + savings_bonds
generate have_bonds2 = 0
replace have_bonds2 = 1 if bonds2~=0 
label define have_bonds2 1 "Yes" 0 "No" 
label values have_bonds2 have_bonds2
label variable have_bonds2 "Do you own any bonds (both savings and other types)?"

//Generating a variable that accounts for other financial assets besides a retirement account, bonds, and equity//

generate other_financial_variables =  cds  ///
  + life_insurance_cash_value + other_managed_assets + other_financial_assets
generate have_other_financial_variables = 0 
replace have_other_financial_variables = 1 if other_financial_variables~=0 
label define have_other_financial_variables 1 "Yes" 0 "No" 
label values have_other_financial_variables have_other_financial_variables
label variable have_other_financial_variables "Do you have other financial variables (besides equity and bonds)?"


//Generating any financial assets (except retirement account) and any total assets (except retirement account)//

generate Total_Financial_Assets2 = liquid_accounts + cds + mutual_funds + stocks + bonds ///
   + savings_bonds + life_insurance_cash_value + other_managed_assets ///
  + other_financial_assets
generate have_total_financial_variables = 0 
replace have_total_financial_variables = 1 if Total_Financial_Assets2~=0 
label define have_total_financial_variables 1 "Yes" 0 "No" 
label values have_total_financial_variables have_total_financial_variables
label variable have_total_financial_variables "Do you own any financial variables (besides retirement account)?"

  
generate TOTAL_ASSETS2 = Total_Nonfinancial_Assets + Total_Financial_Assets2
generate HAVE_ANY_ASSETS2 = 0
replace HAVE_ANY_ASSETS2 = 1 if TOTAL_ASSETS2~=0
label define  HAVE_ANY_ASSETS2  1 "Yes" 0 "No" 
label values  HAVE_ANY_ASSETS2 HAVE_ANY_ASSETS2
label variable  HAVE_ANY_ASSETS2 "Do you own any Assets (besides a retirement account?"  
  
  
preserve
               //Generating data for people who have a retirement account//
                    
keep if have_retirement_account==1
tab have_equity [weight=frequency_weight_round]
tab have_bonds2 [weight=frequency_weight_round]
tab have_liquid_accounts [weight=frequency_weight_round]
tab have_other_financial_variables [weight=frequency_weight_round]
tab have_total_financial_variables [weight=frequency_weight_round]
tab have_nonfin_assets [weight=frequency_weight_round]
tab HAVE_ANY_ASSETS2 [weight=frequency_weight_round]
tab HAVE_ANY_DEBT [weight=frequency_weight_round]

restore

preserve
              //Generating data for people who do not have a retirement account//
			  
keep if have_retirement_account==0
tab have_equity [weight=frequency_weight_round]
tab have_bonds2 [weight=frequency_weight_round]
tab have_liquid_accounts [weight=frequency_weight_round]
tab have_other_financial_variables [weight=frequency_weight_round]
tab have_total_financial_variables [weight=frequency_weight_round]
tab have_nonfin_assets [weight=frequency_weight_round]
tab HAVE_ANY_ASSETS2 [weight=frequency_weight_round]
tab HAVE_ANY_DEBT [weight=frequency_weight_round]

restore


