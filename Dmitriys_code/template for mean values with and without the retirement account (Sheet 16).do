
    //Create new Financial Assets variable that excludes retirement account//
generate Total_Financial_Assets2 = liquid_accounts + cds + mutual_funds + stocks + bonds ///
   + savings_bonds + life_insurance_cash_value + other_managed_assets ///
  + other_financial_assets

             //Create new Total Assets variable that excludes retirement account//
generate TOTAL_ASSETS2 = Total_Nonfinancial_Assets + Total_Financial_Assets2 

preserve

keep if have_retirement_account==1

foreach x of varlist Total_Financial_Assets2 Total_Nonfinancial_Assets TOTAL_ASSETS2 TOTAL_DEBT {

 quietly summarize `x' [weight=frequencyweight], detail 					
    di r(p50)
	di r(mean)
	
	}
	
	restore
	
preserve	

keep if have_retirement_account==0

foreach x of varlist Total_Financial_Assets2 Total_Nonfinancial_Assets TOTAL_ASSETS2 TOTAL_DEBT {

 quietly summarize `x' [weight=frequencyweight], detail 					
    di r(p50)
	di r(mean)
	
	}
	
	restore

preserve

keep if have_retirement_account==1

foreach x of varlist Total_Financial_Assets Total_Nonfinancial_Assets TOTAL_ASSETS TOTAL_DEBT {

 quietly summarize `x' [weight=frequencyweight], detail 					
    di r(p50)
	di r(mean)
	
	}
	
	restore
