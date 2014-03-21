	clear

forvalues y = 2007(3)2010 {
	use "M:/SCF/SCF Data/`y'/`y'_raw.dta", clear
	do "M:/SCF/SCF Code/Dmitriys_code/2010 Coding"

	*Gen id
	label var id "HH Unit ID" 
	sort id
	
	*Generate year variable
	generate year = `y'
	label variable year "Year"	

	*Value of principal residence 
	gen principal_res_val = X716
	label var principal_res_val "Value of principal residence" 

	*Residential investment: measured by purchase price  
	gen tot_res_inv = X2003+X607+X617+X627+X631+X717+X635
	label var tot_res_inv "Total residential investment" 

	*Value of total financial assets
	rename Total_Financial_Assets tot_fin_assets
	label var tot_fin_assets "Total financial assets" 

	*Net worth      
	rename NET_WORTH net_worth
	label var net_worth "Net Worth" 

	*Mortgage debt on primary residence
	gen pres_mortgdebt = X805
	label var pres_mortgdebt "Mortgage debt (primary residence)"

	*Mortgage debt on 2nd, 3rd homes/vacation properties
	if `y' == 2007 {
		gen ores_mortgdebt = X1715+X1815+X1915
	*Investment in non-residential real estate
		gen nonres_inv = X1709+X1809+X1909
		} 
	else{ 
		gen ores_mortgdebt = X1715+X1815
		gen nonres_inv = X1709+1909
	   }
	label var ores_mortgdebt "Mortgage debt on investment real estate/vacation homes"
	label var nonres_inv "Investment in non-residential real estate" 
	
	*Non-financial assets
	replace Total_Nonfinancial_Assets = Total_Nonfinancial_Assets - houses + principal_res_val
	rename Total_Nonfinancial_Assets tot_nonfin_assets
	
	***************************
	/*Compute median and mean*/
	***************************

	*Gen homeowner marker
	gen homeowner = (X701 ==1)
	*Gen marker for those WITH res inv. prop 
	gen hresinv = (tot_res_inv > 0) 
	*Gen marker for those WITH inv. prop in non-res real estate
	gen hnonres_invprop = (nonres_inv >0) 		
		
	*gen type = "Homeowners w/ residential inv. prop" 
	*drop if !homeowner & !hresinv
	*gen type = "Homeowners without residential inv prop" 
	*drop if !homeowners & hresinv
	*gen type = "Non-homeowners"
	*drop if homeowner
	gen type = "Anyone holding investment properties in non-res. real estate"
	drop if !hnonres_invprop
	
	*****************************************************
	/*Want to select non-zero observations: SCF OVERALL*/ 
	*****************************************************
	*Sum of all freq weights
	egen sumfwt = total(fwt)
	egen sumfwt_princres = total(fwt) if principal_res_val >0 
	egen sumfwt_totres = total(fwt) if tot_res_inv >0 
	egen sumfwt_finassets = total(fwt) if tot_fin_assets >0 
	egen sumfwt_networth = total(fwt) if net_worth >0
	egen sumfwt_presmortgd = total(fwt) if pres_mortgd >0 
	egen sumfwt_oresmortgd = total(fwt) if ores_mortgdebt >0
	egen sumfwt_nonfinassets = total(fwt) if tot_nonfin_assets >0
	
	*Principal residence value 
	egen mean_principalres = total(principal_res_val*fwt)
	replace mean_principalres = mean_principalres/sumfwt_princres  	
	quietly summarize principal_res_val [w=fwt], detail 
	gen med_principalres = r(p50) 
	label var med_principalres "Median principal residence vlaue" 	
	label var mean_principalres "Mean principal residence value" 

	*Total residential investment 
	egen mean_totresinv = total(tot_res_inv*fwt)  
	replace mean_totresinv = mean_totresinv/sumfwt_totres 
	quietly summarize tot_res_inv [w=fwt], detail 
	gen med_totresinv = r(p50) 
	label var med_totresinv "Median total residential investment"  	
	label var mean_totresinv "Mean total residential investment"
	 
	*Total financial assets 
	egen mean_totfinassets = total(tot_fin_assets*fwt)
	replace mean_totfinassets = mean_totfinassets/sumfwt_finassets
	quietly summarize tot_fin_assets [w=fwt], detail 
	gen med_totfinassets = r(p50) 
	label var med_totfinassets "Median total financial assets" 	
	label var mean_totfinassets "Mean total financial assets"	
	
	*Net worth
	egen mean_networth = total(net_worth*fwt) 
	replace mean_networth = mean_networth/sumfwt_networth 
	quietly summarize net_worth [w=fwt], detail 
	gen med_networth = r(p50) 
	label var med_networth "Median net worth" 	
	label var mean_networth "Mean net worth" 
	
	*Primary residence mortgage debt
	egen mean_presmortgd = total(pres_mortgd*fwt) 
	replace mean_presmortgd = mean_presmortgd/sumfwt_presmortgd
	quietly summarize pres_mortgd [w=fwt], detail 
	gen med_presmortgd = r(p50) 
	label var med_presmortgd "Median primary residence mortgage debt" 	
	label var mean_presmortgd "Mean primary residence mortgage debt" 
	
	*Other residential investment mortgage debt 
	egen mean_oresmortgd = total(ores_mortgdebt*fwt) 
	replace mean_oresmortgd = mean_oresmortgd/sumfwt_oresmortgd 
	quietly summarize ores_mortgdebt [w=fwt], detail 
	gen med_oresmortgd = r(p50) 
	label var med_oresmortgd "Median other res. investment mortgage debt" 	
	label var mean_oresmortgd "Mean other res. investment mortgage debt"
	
	*Non financial assets 
	egen mean_nonfinassets = total(tot_nonfin_assets*fwt) 
	replace mean_nonfinassets = mean_nonfinassets/sumfwt_nonfinassets 
	quietly summarize tot_nonfin_assets [w = fwt], detail
	gen med_nonfinassets = r(p50) 
	label var med_nonfinassets "Median total non-financial assets" 
	label var mean_nonfinassets "Mean total non-financial assets" 
		
	**************************
	/*Nonzero share of total*/ 
	**************************	
	*Primary residence mortgage debt 
	gen share_presmortgd = sumfwt_presmortgd/sumfwt 
	label var share_presmortgd "Share of non-zero mortgage debt" 
	
	*Total residential investment
	gen share_totresinv = sumfwt_totres/sumfwt 
	label var share_totresinv "Share of non-zero total residential investment" 
	
	*Other residential investment mortgage debt 
	gen share_othermortgdebt = sumfwt_oresmortgd/sumfwt 
	label var share_othermortgdebt "Share of non-zero other res. inv. mortgage debt" 
	
	*Financial assets 
	gen share_finassets = sumfwt_finassets/sumfwt 
	label var share_finassets "Share of non-zero financial assets" 
	
	*Net worth 
	gen share_networth = sumfwt_networth/sumfwt
	label var share_networth "Share of non-zero net worth" 
	
	*Non-financial assets
	gen share_nfinassets = sumfwt_nonfinassets/sumfwt
	label var share_nfinassets "Share of non-zero non-financial assets" 
	
	
	
	
	local varlist1 type share_presmortgd share_totresinv share_othermortgdebt share_finassets share_nfinassets med_totresinv med_totfinassets med_networth  med_presmortgd med_oresmortgd mean_principalres mean_totresinv mean_totfinassets mean_networth mean_presmortgd mean_oresmortgd
	keep `varlist1'
	duplicates drop 
	export excel `varlist1' using "M:/SCF/SCF Data/inv_profilev3.xls", sheet("`y'_h1") firstrow(varlabels) sheetmodify
	
	
}
