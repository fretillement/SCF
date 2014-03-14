clear
set maxvar 7000 

/*This program extracts relevant information about families' residential
invstment in 2007*/ 

*Prep raw data with Dmitry's code
use "M:/SCF/SCF Data/2007/2007_raw.dta", clear
quietly do "C:/Stata/Survey of Consumer Finances/Datasets and Code/Master Coding/2007 Coding.do"

********************************************
/*Construct variables not in Dmitry's code*/
********************************************
*Housing type (Single/multi-fam)

*Total assets in real estate
gen resre_inv = houses + other_residential_real_estate
label var resre_inv "Investment in residential real estate"

Washington (Reagan National), DC - DCAgen totalre_inv = resre_inv + non_res_real_estate
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
local varlist frequencyweight year houses TOTAL_ASSETS Total_Nonfinancial_Assets Total_Financial_Assets non_res_real_estate resre_inv totalre_inv NET_WORTH TOTAL_DEBT pres_mortgdebt pres_mortgdebt2 pres_mortgdebt3 totalpres_debt totalre_debt
export excel frequencyweight year houses TOTAL_ASSETS Total_Nonfinancial_Assets Total_Financial_Assets non_res_real_estate resre_inv totalre_inv NET_WORTH TOTAL_DEBT pres_mortgdebt pres_mortgdebt2 pres_mortgdebt3 totalpres_debt totalre_debt using "M:/SCF/SCF Data/inv_profile.xls", sheet("2007") firstrow(varlabels)  





