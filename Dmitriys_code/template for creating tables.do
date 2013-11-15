                               //Template for creating charts//

							   
*************************************************************
**Table 1 family income, percentage of families that saved, 
**and distribution of families by selected characteristics
*************************************************************							   
**Summarizing Income**
           
			 //Income Percentile//

summarize income [weight=frequencyweight], detail

tabulate family_saving [weight=frequency_weight_round]

forval x = 1/6 {
summarize income [weight=frequencyweight] if income_percentile==`x', detail
}

forval x = 1/6 {
tabulate family_saving [weight=frequency_weight_round] if income_percentile==`x'
}

tabulate income_percentile [weight=frequency_weight_round]

                    //Age of Head//

forval x = 1/6 {
summarize income [weight=frequencyweight] if age==`x', detail
}

forval x = 1/6 {
tabulate family_saving [weight=frequency_weight_round] if age==`x'
}

 tabulate age [weight=frequency_weight_round]
 
 
                //Family Structure//
 
 forval x = 1/5 {
summarize income [weight=frequencyweight] if family_structure==`x', detail
}

forval x = 1/5 {
tabulate family_saving [weight=frequency_weight_round] if family_structure==`x'
}

 tabulate family_structure [weight=frequency_weight_round]

 
                      //Education of Head//
					  
 forval x = 1/4 {
summarize income [weight=frequencyweight] if education==`x', detail
}

forval x = 1/4 {
tabulate family_saving [weight=frequency_weight_round] if education==`x'
}

 tabulate education [weight=frequency_weight_round]					  
 
 
                //Race or Ethnicity//
				
 forval x = 1/2 {
summarize income [weight=frequencyweight] if race==`x', detail
}

forval x = 1/2 {
tabulate family_saving [weight=frequency_weight_round] if race==`x'
}

tabulate race [weight=frequency_weight_round]
	

	          //Current Work Status of Head//
			  

forval x = 1/4 {
summarize income [weight=frequencyweight] if work_status==`x', detail
}

forval x = 1/4 {
tabulate family_saving [weight=frequency_weight_round] if work_status==`x'
}

 tabulate work_status [weight=frequency_weight_round]	
	

              //Current Occupation Status of Head//
			  

forval x = 1/4 {
summarize income [weight=frequencyweight] if occupation==`x', detail
}

forval x = 1/4 {
tabulate family_saving [weight=frequency_weight_round] if occupation==`x'
}

 tabulate occupation [weight=frequency_weight_round]		
	
	
              //Housing Status//
				
 forval x = 1/2 {
summarize income [weight=frequencyweight] if housing_status==`x', detail
}

forval x = 1/2 {
tabulate family_saving [weight=frequency_weight_round] if housing_status==`x'
}

tabulate housing_status [weight=frequency_weight_round]
		
		
		
		//Net Worth Percentile//
				
 forval x = 1/5 {
summarize income [weight=frequencyweight] if net_worth_percentile==`x', detail
}

forval x = 1/5 {
tabulate family_saving [weight=frequency_weight_round] if net_worth_percentile==`x'
}

tabulate net_worth_percentile [weight=frequency_weight_round]
		
	/*	

*********************************************************************************
**Table 2 family income distributed by income
**sources, by percentile of net worth
*********************************************************************************



	 //Create average numbers// 
	 
	 forvalues x = 1/5 {
summarize income_components [weight=frequencyweight] if net_worth_percentile==`x'
generate newvartotalincome`x' = r(mean)


summarize wage_income [weight=frequencyweight] if net_worth_percentile==`x'
generate newvarwageincome`x' = r(mean)


summarize interest_dividend_income [weight=frequencyweight] if net_worth_percentile==`x'
generate newvarinterestincome`x' = r(mean)


summarize business_farm_income [weight=frequencyweight] if net_worth_percentile==`x'
generate newvarbusinessincome`x' = r(mean)


summarize capital_gains_income [weight=frequencyweight] if net_worth_percentile==`x'
generate newvarcapitalgainsincome`x' = r(mean)


summarize ss_retirement_income [weight=frequencyweight] if net_worth_percentile==`x'
generate newvarssretirementincome`x' = r(mean)


summarize transfer_other_income [weight=frequencyweight] if net_worth_percentile==`x'
generate newvartransferincome`x' = r(mean)

               //Generate Percentages//
generate wageratio`x' = newvarwageincome`x' / newvartotalincome`x'

generate interestratio`x' = newvarinterestincome`x' / newvartotalincome`x'

generate businessratio`x' = newvarbusinessincome`x' / newvartotalincome`x'

generate capitalratio`x' = newvarcapitalgainsincome`x' / newvartotalincome`x'

generate retirementratio`x' = newvarssretirementincome`x' / newvartotalincome`x'

generate transferratio`x' = newvartransferincome`x' / newvartotalincome`x'


di wageratio`x' "  " interestratio`x' "  " businessratio`x' "  " ///
   capitalratio`x' "  " retirementratio`x' "  " transferratio`x' 

                //Dropping extra variables//

drop newvarwageincome`x' newvarinterestincome`x' newvarbusinessincome`x' newvarcapitalgainsincome`x' newvarssretirementincome`x' newvartransferincome`x'

}


    
                      //Data for All Families//

summarize income_components [weight=frequencyweight]
generate newvartotalincome_all = r(mean)


summarize wage_income [weight=frequencyweight] 
generate newvarwageincome_all = r(mean)


summarize interest_dividend_income [weight=frequencyweight] 
generate newvarinterestincome_all = r(mean)


summarize business_farm_income [weight=frequencyweight]
generate newvarbusinessincome_all = r(mean)


summarize capital_gains_income [weight=frequencyweight]
generate newvarcapitalgainsincome_all = r(mean)


summarize ss_retirement_income [weight=frequencyweight]
generate newvarssretirementincome_all = r(mean)


summarize transfer_other_income [weight=frequencyweight]
generate newvartransferincome_all = r(mean)

               //Generate Percentages//
generate wageratio_all = newvarwageincome_all / newvartotalincome_all

generate interestratio_all = newvarinterestincome_all / newvartotalincome_all

generate businessratio_all = newvarbusinessincome_all / newvartotalincome_all

generate capitalratio_all = newvarcapitalgainsincome_all / newvartotalincome_all

generate retirementratio_all = newvarssretirementincome_all / newvartotalincome_all

generate transferratio_all = newvartransferincome_all / newvartotalincome_all

di  wageratio_all "  " interestratio_all "  " businessratio_all "  " ///
    capitalratio_all "  " retirementratio_all "  " transferratio_all


                //Dropping extra variables//

drop newvarwageincome_all newvarinterestincome_all newvarbusinessincome_all newvarcapitalgainsincome_all newvarssretirementincome_all newvartransferincome_all



*******************************************************************************
**Table 3 reasons respondents gave as most important for their families' saving
*******************************************************************************

tabulate saving_reason [weight=frequency_weight_round]

		
			
*******************************************************************
**Table 4 family net worth, by selected characteristics of families
*******************************************************************							   
**Summarizing Net Worth**
          
		      	 //Income Percentile//

summarize NET_WORTH [weight=frequency_weight_round], detail


forval x = 1/6 {
summarize NET_WORTH [weight=frequencyweight] if income_percentile==`x', detail
}


                    //Age of Head//

forval x = 1/6 {
summarize NET_WORTH [weight=frequencyweight] if age==`x', detail
}
 
 
                //Family Structure//
 
 forval x = 1/5 {
summarize NET_WORTH [weight=frequencyweight] if family_structure==`x', detail
}

 
                      //Education of Head//
					  
 forval x = 1/4 {
summarize NET_WORTH [weight=frequencyweight] if education==`x', detail
}

 
                //Race or Ethnicity//
				
 forval x = 1/2 {
summarize NET_WORTH [weight=frequencyweight] if race==`x', detail
}
	

	          //Current Work Status of Head//
			  

forval x = 1/4 {
summarize NET_WORTH [weight=frequencyweight] if work_status==`x', detail
}


              //Current Occupation Status of Head//
			  

forval x = 1/4 {
summarize NET_WORTH [weight=frequencyweight] if occupation==`x', detail
}
 
	
                       //Housing Status//
				
 forval x = 1/2 {
summarize NET_WORTH [weight=frequencyweight] if housing_status==`x', detail
}		
		
		
	               	//Net Worth Percentile//
				
 forval x = 1/5 {
summarize NET_WORTH [weight=frequencyweight] if net_worth_percentile==`x', detail
}


*/

/*
*****************************************************
**Table 5 Value of financial assets of all families,
**distributed by type of asset
*****************************************************

summarize Total_Financial_Assets [weight=frequencyweight]
generate newvar_total_financial_assets = r(mean)

foreach x of varlist liquid_accounts cds savings_bonds bonds stocks ///
      mutual_funds retirement_account life_insurance_cash_value ///
	   other_managed_assets other_financial_assets {

summarize `x' [weight=frequencyweight]
generate newvar_`x' = r(mean)



generate `x'_value = newvar_`x' / newvar_total_financial_assets


drop newvar_`x'
}

summarize TOTAL_ASSETS [weight=frequencyweight]
generate newvar_total_assets = r(mean)

generate financial_share = newvar_total_financial_assets / newvar_total_assets



*****************************************************************************
**Table 6 (part 1 - percentage of families holding asset) family holdings of
**financial assets, by selected characteristics of families and type of asset
*****************************************************************************

 //To generate numbers for all families//
 
foreach x of varlist have_liquid_accounts have_cd have_savings_bonds ///
   have_other_bonds have_public_stock have_mutual_funds have_retirement_account ///
   have_life_insurance have_other_managed_assets have_other_financial_assets ///
   Have_Any_Financial_Assets {

tabulate `x' [weight=frequency_weight_round]

}

                 //To generate Percentage of Families holding asset//
				            //  for specific Variables//
						  
foreach x of varlist have_liquid_accounts have_cd have_savings_bonds ///
   have_other_bonds have_public_stock have_mutual_funds have_retirement_account ///
   have_life_insurance have_other_managed_assets have_other_financial_assets ///
   Have_Any_Financial_Assets {
      foreach y of varlist income_percentile age family_structure education ///
	  race work_status occupation housing_status net_worth_percentile {
     tabulate `y' `x' [weight=frequency_weight_round], row
}
}
           
	
*****************************************************************************
**Table 6 (part 2 - median and mean values of holdings) family holdings of
**financial assets, by selected characteristics of families and type of asset
*****************************************************************************

              //To generate Median and Mean Values of holdings for families//
			        // holding asset for specific variables //
//"Template for creating tables Table 6" provides a better-written solution but//
          //it does not provide a way to run individual categories like here//
					
					//Total for All Families//
										
foreach y of varlist liquid_accounts cds savings_bonds ///
   bonds stocks mutual_funds retirement_account ///
   life_insurance_cash_value other_managed_assets other_financial_assets ///
   Total_Financial_Assets {     
  /*"quietly" can be added as an option */ 
  summarize `y' [weight=frequencyweight] if `y'~=0, detail					
    di r(p50)
	di r(mean)
	di r(sum)
	}										
			
                             //Income Percentile//
			
foreach y of varlist liquid_accounts cds savings_bonds ///
   bonds stocks mutual_funds retirement_account ///
   life_insurance_cash_value other_managed_assets other_financial_assets ///
   Total_Financial_Assets {
     forval x = 1/6 {
  /*"quietly" can be added as an option */ 
  summarize `y' [weight=frequencyweight] if `y'~=0 & income_percentile==`x', detail					
    di r(p50)
	di r(mean)
	di r(sum)
	}
}

                               //Age of Head//
foreach y of varlist liquid_accounts cds savings_bonds ///
   bonds stocks mutual_funds retirement_account ///
   life_insurance_cash_value other_managed_assets other_financial_assets ///
   Total_Financial_Assets {
     forval x = 1/6 {
  /*"quietly" can be added as an option */ 
  summarize `y' [weight=frequencyweight] if `y'~=0 & age==`x', detail					
    di r(p50)
	di r(mean)
	di r(sum)
	}
}

                          //Family Structure//

foreach y of varlist liquid_accounts cds savings_bonds ///
   bonds stocks mutual_funds retirement_account ///
   life_insurance_cash_value other_managed_assets other_financial_assets ///
   Total_Financial_Assets {
     forval x = 1/5 {
  /*"quietly" can be added as an option */ 
  summarize `y' [weight=frequencyweight] if `y'~=0 & family_structure==`x', detail					
    di r(p50)
	di r(mean)
	di r(sum)
	}
}

                           //Education of Head//
foreach y of varlist liquid_accounts cds savings_bonds ///
   bonds stocks mutual_funds retirement_account ///
   life_insurance_cash_value other_managed_assets other_financial_assets ///
   Total_Financial_Assets {
     forval x = 1/4 {
  /*"quietly" can be added as an option */ 
  summarize `y' [weight=frequencyweight] if `y'~=0 & education==`x', detail					
    di r(p50)
	di r(mean)
	di r(sum)
	}
}

                          //Race of Ethnicity//

foreach y of varlist liquid_accounts cds savings_bonds ///
   bonds stocks mutual_funds retirement_account ///
   life_insurance_cash_value other_managed_assets other_financial_assets ///
   Total_Financial_Assets {
     forval x = 1/2 {
  /*"quietly" can be added as an option */ 
  summarize `y' [weight=frequencyweight] if `y'~=0 & race==`x', detail					
    di r(p50)
	di r(mean)
	di r(sum)
	}
}

                        //Current Work Status of Head//
foreach y of varlist liquid_accounts cds savings_bonds ///
   bonds stocks mutual_funds retirement_account ///
   life_insurance_cash_value other_managed_assets other_financial_assets ///
   Total_Financial_Assets {
     forval x = 1/4 {
  /*"quietly" can be added as an option */ 
  summarize `y' [weight=frequencyweight] if `y'~=0 & work_status==`x', detail					
    di r(p50)
	di r(mean)
	di r(sum) 
	}
}

                     //Current Occupation Status of Head//
foreach y of varlist liquid_accounts cds savings_bonds ///
   bonds stocks mutual_funds retirement_account ///
   life_insurance_cash_value other_managed_assets other_financial_assets ///
   Total_Financial_Assets {
     forval x = 1/4 {
  /*"quietly" can be added as an option */ 
  summarize `y' [weight=frequencyweight] if `y'~=0 & occupation==`x', detail					
    di r(p50)
	di r(mean)
	di r(sum)
	}
}

                             //Housing Status//
foreach y of varlist liquid_accounts cds savings_bonds ///
   bonds stocks mutual_funds retirement_account ///
   life_insurance_cash_value other_managed_assets other_financial_assets ///
   Total_Financial_Assets {
     forval x = 1/2 {
  /*"quietly" can be added as an option */ 
  summarize `y' [weight=frequencyweight] if `y'~=0 & housing_status==`x', detail					
    di r(p50)
	di r(mean)
	di r(sum)
	}
}

                          //Net Worth Percentile//
foreach y of varlist liquid_accounts cds savings_bonds ///
   bonds stocks mutual_funds retirement_account ///
   life_insurance_cash_value other_managed_assets other_financial_assets ///
   Total_Financial_Assets {
     forval x = 1/5 {
  /*"quietly" can be added as an option */ 
  summarize `y' [weight=frequencyweight] if `y'~=0 & net_worth_percentile==`x', detail					
    di r(p50)
	di r(mean)
	di r(sum)
	}
}



************************************************************
**Table 7 Direct and indirect family holdings of stock

** use EQUITY where EQUITY is greater than 0
*************************************************************


************************************************************
**Table 8 Value of nonfinancial assets of all families
************************************************************

** Value of Non-financial assets of all families, distributed by type of asset

summarize Total_Nonfinancial_Assets [weight=frequencyweight]
generate newvar_total_nonfinancial_assets = r(mean)

foreach x of varlist vehicles houses other_residential_real_estate ///
  non_res_real_estate business other_non_financial_assets {

summarize `x' [weight=frequencyweight]
generate v_`x' = r(mean)



generate `x'_v = v_`x' / newvar_total_nonfinancial_assets
di `x'_v

drop v_`x'
}

summarize TOTAL_ASSETS [weight=frequencyweight]
generate newvar_total_assets = r(mean)

generate nonfinancial_share = newvar_total_nonfinancial_assets / newvar_total_assets

di nonfinancial_share


******************************************************************
**Table 9 Family holdings of nonfinancial assets, by selected characteristics
** of families and type of asset
****************************************************************** 


*****************************************************************************
**Part 1 - percentage of families holding asset) family holdings of
**financial assets, by selected characteristics of families and type of asset
*****************************************************************************

         //To generate numbers for all families//
 
foreach x of varlist have_vehicles have_houses have_other_res_real_estate ///
  have_non_res_real_estate have_business_assets have_other_nonfin_assets ///
  have_nonfin_assets HAVE_ANY_ASSETS {

tabulate `x' [weight=frequency_weight_round]

}

                 //To generate Percentage of Families holding asset//
				            //  for specific Variables//
						  
foreach x of varlist have_vehicles have_houses have_other_res_real_estate ///
  have_non_res_real_estate have_business_assets have_other_nonfin_assets ///
  have_nonfin_assets HAVE_ANY_ASSETS {
      foreach y of varlist income_percentile age family_structure education ///
	  race work_status occupation housing_status net_worth_percentile {
     tabulate `y' `x' [weight=frequency_weight_round], row
}
}
           
	
*****************************************************************************
**Part 2 - median and mean values of family holdings of
**financial assets, by selected characteristics of families and type of asset
*****************************************************************************

              //To generate Median and Mean Values of holdings for families//
			        // holding asset for specific variables //
//"Template for creating tables Table 6" provides a better-written solution but//
          //it does not provide a way to run individual categories like here//
					
					//Total for All Families//
										
foreach y of varlist vehicles houses other_residential_real_estate ///
  non_res_real_estate business other_non_financial_assets ///
  Total_Nonfinancial_Assets TOTAL_ASSETS {     
  /*"quietly" can be added as an option */ 
  summarize `y' [weight=frequencyweight] if `y'~=0, detail					
    di r(p50)
	di r(mean)
	di r(sum)
	}										
			
                             //Income Percentile//
			
foreach y of varlist vehicles houses other_residential_real_estate ///
  non_res_real_estate business other_non_financial_assets ///
  Total_Nonfinancial_Assets TOTAL_ASSETS {
     forval x = 1/6 {
  /*"quietly" can be added as an option */ 
  summarize `y' [weight=frequencyweight] if `y'~=0 & income_percentile==`x', detail					
    di r(p50)
	di r(mean)
	di r(sum)
	}
}

                               //Age of Head//
							   
foreach y of varlist vehicles houses other_residential_real_estate ///
  non_res_real_estate business other_non_financial_assets ///
  Total_Nonfinancial_Assets TOTAL_ASSETS {
     forval x = 1/6 {
  /*"quietly" can be added as an option */ 
  summarize `y' [weight=frequencyweight] if `y'~=0 & age==`x', detail					
    di r(p50)
	di r(mean)
	di r(sum)
	}
}

                          //Family Structure//

foreach y of varlist vehicles houses other_residential_real_estate ///
  non_res_real_estate business other_non_financial_assets ///
  Total_Nonfinancial_Assets TOTAL_ASSETS {
     forval x = 1/5 {
  /*"quietly" can be added as an option */ 
  summarize `y' [weight=frequencyweight] if `y'~=0 & family_structure==`x', detail					
    di r(p50)
	di r(mean)
	di r(sum)
	}
}

                           //Education of Head//
						   
foreach y of varlist vehicles houses other_residential_real_estate ///
  non_res_real_estate business other_non_financial_assets ///
  Total_Nonfinancial_Assets TOTAL_ASSETS {
     forval x = 1/4 {
  /*"quietly" can be added as an option */ 
  summarize `y' [weight=frequencyweight] if `y'~=0 & education==`x', detail					
    di r(p50)
	di r(mean)
	di r(sum)
	}
}

                          //Race of Ethnicity//

foreach y of varlist vehicles houses other_residential_real_estate ///
  non_res_real_estate business other_non_financial_assets ///
  Total_Nonfinancial_Assets TOTAL_ASSETS {
     forval x = 1/2 {
  /*"quietly" can be added as an option */ 
  summarize `y' [weight=frequencyweight] if `y'~=0 & race==`x', detail					
    di r(p50)
	di r(mean)
	di r(sum)
	}
}

                        //Current Work Status of Head//
						
foreach y of varlist vehicles houses other_residential_real_estate ///
  non_res_real_estate business other_non_financial_assets ///
  Total_Nonfinancial_Assets TOTAL_ASSETS {
     forval x = 1/4 {
  /*"quietly" can be added as an option */ 
  summarize `y' [weight=frequencyweight] if `y'~=0 & work_status==`x', detail					
    di r(p50)
	di r(mean)
	di r(sum) 
	}
}

                     //Current Occupation Status of Head//
					 
foreach y of varlist vehicles houses other_residential_real_estate ///
  non_res_real_estate business other_non_financial_assets ///
  Total_Nonfinancial_Assets TOTAL_ASSETS {
     forval x = 1/4 {
  /*"quietly" can be added as an option */ 
  summarize `y' [weight=frequencyweight] if `y'~=0 & occupation==`x', detail					
    di r(p50)
	di r(mean)
	di r(sum)
	}
}

                             //Housing Status//
							 
foreach y of varlist vehicles houses other_residential_real_estate ///
  non_res_real_estate business other_non_financial_assets ///
  Total_Nonfinancial_Assets TOTAL_ASSETS {
     forval x = 1/2 {
  /*"quietly" can be added as an option */ 
  summarize `y' [weight=frequencyweight] if `y'~=0 & housing_status==`x', detail					
    di r(p50)
	di r(mean)
	di r(sum)
	}
}

                          //Net Worth Percentile//
						  
foreach y of varlist vehicles houses other_residential_real_estate ///
  non_res_real_estate business other_non_financial_assets ///
  Total_Nonfinancial_Assets TOTAL_ASSETS {
     forval x = 1/5 {
  /*"quietly" can be added as an option */ 
  summarize `y' [weight=frequencyweight] if `y'~=0 & net_worth_percentile==`x', detail					
    di r(p50)
	di r(mean)
	di r(sum)
	}
}



//This code tabulates age and the housing status, providing appropriate frequencies and percentages//
           // tab age housing_status [weight=frequency_weight_round], cell //




Sample Code that divides retirement_account by any other variable (total assets,
 total financial assets, etc), separated for different demographic categories (this case
 provides a ratio of retirement accounts to total_financial_assets for different age categories)
 
 forval x = 1/6 {
quietly summarize retirement_account [weight=frequencyweight] if age==`x', detail
generate m_retirement_account`x' = r(mean)
quietly summarize Total_Financial_Assets [weight=frequencyweight] if age==`x', detail
generate m_financial_assets`x' = r(mean)

di m_retirement_account`x' /  m_financial_assets`x'

} 


 Code that produces mean values for retirement accounts (among those who do have
 an account), separated by 18 different age categories
 
      forval x = 1/18 {
  /*"quietly" can be added as an option */ 
  quietly summarize retirement_account [weight=frequencyweight] if retirement_account~=0 & age2==`x'					  
	
	//di r(p50) median//  --> you can calculate median values
	di r(mean) //mean//
	//di r(sum) //sum//   --> you can calculate total value of the retirement accounts
}

Code that gives the percentage of people who do hold a retirement account, 
 separated by 18 different age categories

   tabulate age2 have_retirement_account [weight=frequency_weight_round], row
   
   
   
   Code that separates by demographics those respondents who have retirement
       accounts from those who don't (retirement accounts can be changed to any
	    other variable, such as equity, stocks, etc.)
		
		 foreach y of varlist income_percentile age family_structure education ///
	     race work_status occupation housing_status net_worth_percentile {
         tabulate `y' [weight=frequency_weight_round] if retirement_account~=0
	     tabulate `y' [weight=frequency_weight_round] if retirement_account==0
	      }
   
   
   
      //Financial allocation comparison of those who have a retirement account//
	            //with those who do not have a retirement account//
				
generate total_finassets = liquid_accounts + cds + mutual_funds  ///
             + stocks + bonds + savings_bonds + life_insurance_cash_value ///
			 + other_managed_assets + other_financial_assets
				
summarize total_finassets [weight=frequencyweight] if retirement_account~=0  //the second iteration converts this line to retirement_account==0//
generate newvar_total_finassets = r(mean)

foreach x of varlist liquid_accounts cds savings_bonds bonds stocks ///
      mutual_funds life_insurance_cash_value ///
	   other_managed_assets other_financial_assets {

summarize `x' [weight=frequencyweight] if retirement_account~=0 //the second iteration converts this line to retirement_account==0//
generate newvar_`x' = r(mean)

quietly generate `x'_value = newvar_`x' / newvar_total_finassets

drop newvar_`x'
di `x'_value
}



//Sheet 15 Coding (Comparing respondents who do not have retirement accounts with those 
                                         who do) //

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

