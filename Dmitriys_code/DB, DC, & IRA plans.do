   //Code to calculate percentage of people who hold each asset//

foreach x of varlist have_dbplan have_dcplancj have_ira_keogh {
      foreach y of varlist income_percentile age family_structure education ///
	  race work_status occupation housing_status net_worth_percentile {
     tabulate `y' `x' [weight=frequency_weight_round], row
}
}
 
 //Code used to calculate mean, median, and sum (currently, sum is displayed)//
            
						

//Total for All Families//
										
 foreach y of varlist defined_contribution ira_keogh {     
  /*"quietly" can be added as an option */ 
 quietly summarize `y' [weight=frequencyweight] if `y'~=0, detail					
//    di r(p50)
//	di r(mean)
	di r(sum)
	}										
			
                             //Income Percentile//
			
foreach y of varlist defined_contribution ira_keogh {
     forval x = 1/6 {
  /*"quietly" can be added as an option */ 
 quietly summarize `y' [weight=frequencyweight] if `y'~=0 & income_percentile==`x', detail					
//    di r(p50)
//	di r(mean)
  di r(sum)
	}
}

                               //Age of Head//
							   
foreach y of varlist defined_contribution ira_keogh {
     forval x = 1/6 {
  /*"quietly" can be added as an option */ 
 quietly summarize `y' [weight=frequencyweight] if `y'~=0 & age==`x', detail					
//    di r(p50)
//	di r(mean)
	di r(sum)
	}
}

                          //Family Structure//

foreach y of varlist defined_contribution ira_keogh {
     forval x = 1/5 {
  /*"quietly" can be added as an option */ 
 quietly summarize `y' [weight=frequencyweight] if `y'~=0 & family_structure==`x', detail					
//    di r(p50)
//	di r(mean)
	di r(sum)
	}
}

                           //Education of Head//
						   
foreach y of varlist defined_contribution ira_keogh {
     forval x = 1/4 {
  /*"quietly" can be added as an option */ 
 quietly summarize `y' [weight=frequencyweight] if `y'~=0 & education==`x', detail					
//    di r(p50)
//	di r(mean)
	di r(sum)
	}
}

                          //Race of Ethnicity//

foreach y of varlist defined_contribution ira_keogh {
     forval x = 1/2 {
  /*"quietly" can be added as an option */ 
  quietly summarize `y' [weight=frequencyweight] if `y'~=0 & race==`x', detail					
//    di r(p50)
//	di r(mean)
	di r(sum)
	}
}

                        //Current Work Status of Head//
						
foreach y of varlist defined_contribution ira_keogh{
     forval x = 1/4 {
  /*"quietly" can be added as an option */ 
 quietly  summarize `y' [weight=frequencyweight] if `y'~=0 & work_status==`x', detail					
//    di r(p50)
//	di r(mean)
	di r(sum) 
	}
}

                     //Current Occupation Status of Head//
					 
foreach y of varlist defined_contribution ira_keogh {
     forval x = 1/4 {
  /*"quietly" can be added as an option */ 
 quietly summarize `y' [weight=frequencyweight] if `y'~=0 & occupation==`x', detail					
//    di r(p50)
//	di r(mean)
	di r(sum)
	}
}

                             //Housing Status//
							 
foreach y of varlist defined_contribution ira_keogh {
     forval x = 1/2 {
  /*"quietly" can be added as an option */ 
 quietly summarize `y' [weight=frequencyweight] if `y'~=0 & housing_status==`x', detail					
//   di r(p50)
//	di r(mean)
	di r(sum)
	}
}

                          //Net Worth Percentile//
						  
foreach y of varlist defined_contribution ira_keogh{
     forval x = 1/5 {
  /*"quietly" can be added as an option */ 
 quietly summarize `y' [weight=frequencyweight] if `y'~=0 & net_worth_percentile==`x', detail					
//    di r(p50)
//	di r(mean)
	di r(sum)
	}
}

      //Mean and Median information for for all families holding a particular asset//
sum  defined_contribution [weight=frequency_weight_round] if defined_contribution~=0, detail
