
         tabout  income_percentile age family_structure education ///
		 race work_status occupation housing_status ///
		 net_worth_percentile have_dcplancj [aweight=frequency_weight_round] ///
         using  table1.txt, /// 
         c(row) f(1c 1p 1p) clab(_ _ _) ///  
         layout(rb) h3(nil) ///
		 replace  
