

              //To generate Median and Mean Values of holdings for families//
			        // holding asset for specific variables //
					
					//Total for All Families//
										
foreach y of varlist liquid_accounts cds savings_bonds ///
   bonds stocks mutual_funds retirement_account ///
   life_insurance_cash_value other_managed_assets other_financial_assets ///
   Total_Financial_Assets  {     
  /*"quietly" can be added as an option */ 
  quietly summarize `y' [weight=frequencyweight] if `y'~=0, detail	
    di r(p50)
//	di r(mean)
//	di r(sum)
	
 forval x = 1/6 {
  /*"quietly" can be added as an option */ 
  quietly summarize `y' [weight=frequencyweight] if `y'~=0 & income_percentile==`x', detail					
    di r(p50)
//	di r(mean)
//    di r(sum) 
	}	
	 forval x = 1/6 {
  /*"quietly" can be added as an option */ 
  quietly summarize `y' [weight=frequencyweight] if `y'~=0 & age==`x', detail					
    di r(p50)
//	di r(mean)
//	di r(sum)
	}
	  forval x = 1/5 {
  /*"quietly" can be added as an option */ 
  quietly summarize `y' [weight=frequencyweight] if `y'~=0 & family_structure==`x', detail					
    di r(p50)
//	di r(mean)
//  di r(sum)
	}
	 forval x = 1/4 {
  /*"quietly" can be added as an option */ 
  quietly summarize `y' [weight=frequencyweight] if `y'~=0 & education==`x', detail					
    di r(p50)
//	di r(mean)
//    di r(sum)
	}
	forval x = 1/2 {
  /*"quietly" can be added as an option */ 
quietly  summarize `y' [weight=frequencyweight] if `y'~=0 & race==`x', detail					
    di r(p50)
//	di r(mean)
//	di r(sum)
	}
	forval x = 1/4 {
  /*"quietly" can be added as an option */ 
 quietly summarize `y' [weight=frequencyweight] if `y'~=0 & work_status==`x', detail					
    di r(p50)
//	di r(mean)
//	di r(sum)
	}
	 forval x = 1/4 {
  /*"quietly" can be added as an option */ 
 quietly  summarize `y' [weight=frequencyweight] if `y'~=0 & occupation==`x', detail					
    di r(p50)
//	di r(mean)
//	di r(sum)
	}
	 forval x = 1/2 {
  /*"quietly" can be added as an option */ 
  quietly summarize `y' [weight=frequencyweight] if `y'~=0 & housing_status==`x', detail					
    di r(p50)
//	di r(mean)
//	di r(sum)
	} 
	 forval x = 1/5 {
  /*"quietly" can be added as an option */ 
  quietly summarize `y' [weight=frequencyweight] if `y'~=0 & net_worth_percentile==`x', detail					
    di r(p50)
// 	di r(mean)
//	di r(sum)
	}
	}		
     
  
