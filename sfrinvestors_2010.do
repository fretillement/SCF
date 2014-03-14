clear
set maxvar 7000 
	
forvalues y = 2010(1)2010 { 

	/*This program extracts relevant information about families' residential
	investment in 2010*/ 

	*Prep raw data with Dmitry's code
	use "M:/SCF/SCF Data/`y'/`y'_raw.dta", clear
	generate year = `y'
	label variable year "Year"	
	quietly do "C:/Stata/Survey of Consumer Finances/Datasets and Code/Master Coding/2010 Coding.do"

	********************************************
	/*Construct variables not in Dmitry's code*/
	********************************************
	*Housing type (Single/multi-fam)

	*Total assets in real estate
	gen resre_inv = houses + other_residential_real_estate
	label var resre_inv "Investment in residential real estate"

	gen totalre_inv = resre_inv + non_res_real_estate
	label var totalre_inv "Total investment in real estate" 

	*Primary residence mortgage debt
	gen pres_mortgdebt = X805
	label var pres_mortgdebt "Mortgage debt (primary residence)" 

	*Primary residence debt from second and third mortgage
	gen pres_mortgdebt2 = X905 
	label var pres_mortgdebt2 "Second mortgage debt (primary residence)" 

	gen pres_mortgdebt3 = X1005 
	label var pres_mortgdebt3 "Third mortgage debt (primary residence)" 

	*Total primary residential real estate debt 
	gen totalpres_debt = pres_mortgdebt + pres_mortgdebt2 + pres_mortgdebt3
	label var totalpres_debt "Total primary residential real estate debt" 

	*Total debt from investment in real estate (primary res. and other)
	gen totalre_debt = totalpres_debt + other_residential_debt
	label var totalre_debt "Total debt from real estate investment" 
	************
	/*Outsheet*/ 
	************
	label var id "HH Unit ID" 
	sort id
	local varlist frequencyweight year houses TOTAL_ASSETS Total_Nonfinancial_Assets Total_Financial_Assets non_res_real_estate resre_inv totalre_inv NET_WORTH TOTAL_DEBT pres_mortgdebt pres_mortgdebt2 pres_mortgdebt3 totalpres_debt totalre_debt
	export excel id frequencyweight year houses TOTAL_ASSETS Total_Nonfinancial_Assets Total_Financial_Assets non_res_real_estate resre_inv totalre_inv NET_WORTH TOTAL_DEBT pres_mortgdebt pres_mortgdebt2 pres_mortgdebt3 totalpres_debt totalre_debt using "M:/SCF/SCF Data/inv_profile.xls", sheet("`y'") firstrow(varlabels)  

}
