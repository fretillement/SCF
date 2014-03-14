	clear

forvalues y = 2007(3)2010 {
	use "M:/SCF/SCF Data/`y'/`y'_raw.dta", clear
	do "M:/SCF/SCF Code/Dmitriys_code/2010 Coding"

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
	gen ores_mortgdebt = X1715+X1815+X1915
	label var ores_mortgdebt "Mortgage debt on investment real estate/vacation homes" 

	*Investment in non-residential real estate
	gen nonres_inv = X1709+X1809+X1909
	label var nonres_inv "Investment in non-residential real estate" 

	label var id "HH Unit ID" 
	sort id
	local varlist frequencyweight year principal_res_val tot_res_inv tot_fin_assets net_worth pres_mortgdebt ores_mortgdebt nonres_inv
	export excel `varlist' using "M:/SCF/SCF Data/inv_profilev2.xls", sheet("`y'") firstrow(varlabels)  
}

