
     //Distribution of a primary job pension plan (variable becomes x11036// 
	           //for years 2007 & 2004 and x4234 for years 1992-2001)//

keep if X11036==1 | X11036==2 | X11036==3

tab X11036 [weight=frequency_weight_round]

        //Proportion held in stocks among those pension plans that are split//
                  //(this question only goes back to 2004 and,//
               //for years 2004 & 2007, the variable is x11037)//
			   
drop if X11037==0
tab X11037 [weight=frequency_weight_round]
//then, just look at the distributions and subtract ranges as appropriate// 
