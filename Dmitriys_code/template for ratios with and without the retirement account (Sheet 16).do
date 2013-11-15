
            //Create new Financial Assets variable that excludes retirement account//
generate Total_Financial_Assets2 = liquid_accounts + cds + mutual_funds + stocks + bonds ///
   + savings_bonds + life_insurance_cash_value + other_managed_assets ///
  + other_financial_assets

             //Create new Total Assets variable that excludes retirement account//
generate TOTAL_ASSETS2 = Total_Nonfinancial_Assets + Total_Financial_Assets2  
  
preserve  
  
   //Calculate Ratios of Financial Assets to Nonfinancial Assets (both with and //
     //without the retirement account) and the ratio of Total Debt to Total Assets//
	            //among those respondents who have any retirement accounts//
keep if have_retirement_account==1
  
quietly summarize Total_Financial_Assets2 [weight=frequencyweight] 
generate m_Total_Financial_Assets2 = r(mean)
quietly summarize Total_Nonfinancial_Assets [weight=frequencyweight]
generate m_Total_Nonfinancial_Assets = r(mean) 

di m_Total_Financial_Assets2 / m_Total_Nonfinancial_Assets


quietly summarize TOTAL_ASSETS2 [weight=frequencyweight] 
generate m_TOTAL_ASSETS2 = r(mean)
quietly summarize TOTAL_DEBT [weight=frequencyweight] 
generate m_TOTAL_DEBT = r(mean)

di m_TOTAL_DEBT / m_TOTAL_ASSETS2

  //This part includes retirement accounts and applies only to the respondents who//
         //have them (it doesn't make sense to include retirement accounts//
                     //for the respondents who don't have any//
quietly summarize Total_Financial_Assets [weight=frequencyweight] 
generate m_Total_Financial_Assets = r(mean)
di m_Total_Financial_Assets / m_Total_Nonfinancial_Assets

quietly summarize TOTAL_ASSETS [weight=frequencyweight] 
generate m_TOTAL_ASSETS = r(mean)
di m_TOTAL_DEBT / m_TOTAL_ASSETS

restore

preserve

 //Calculate Ratios of Financial Assets to Nonfinancial Assets (without the//
      //retirement account) and the ratio of Total Debt to Total Assets//
	  //among those respondents who do not have any retirement accounts//
keep if have_retirement_account==0
  
quietly summarize Total_Financial_Assets2 [weight=frequencyweight] 
generate m_Total_Financial_Assets2 = r(mean)
quietly summarize Total_Nonfinancial_Assets [weight=frequencyweight]
generate m_Total_Nonfinancial_Assets = r(mean) 

di m_Total_Financial_Assets2 / m_Total_Nonfinancial_Assets


quietly summarize TOTAL_ASSETS2 [weight=frequencyweight] 
generate m_TOTAL_ASSETS2 = r(mean)
quietly summarize TOTAL_DEBT [weight=frequencyweight] 
generate m_TOTAL_DEBT = r(mean)

di m_TOTAL_DEBT / m_TOTAL_ASSETS2

restore
