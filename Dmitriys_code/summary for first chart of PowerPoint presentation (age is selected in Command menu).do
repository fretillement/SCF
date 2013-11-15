preserve
summarize income [weight=frequencyweight] if income~=0, detail					
    di r(p50)
restore


preserve
summarize NET_WORTH [weight=frequencyweight] if NET_WORTH~=0, detail					
    di r(p50)	
restore
	
	
preserve
summarize equity [weight=frequencyweight] if equity~=0, detail					
    di r(p50)	
restore


preserve
summarize retirement_account [weight=frequencyweight] if retirement_account~=0, detail					
    di r(p50)	
restore


tabulate have_retirement_account [weight=frequency_weight_round]


preserve
summarize home_equity [weight=frequencyweight] if home_equity~=0, detail					
    di r(p50)	
restore
