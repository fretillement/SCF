/*In this program, we must: 
1. Recode the SCF datasets and variables for each year
2. Merge SCF datasets across years into one dataset
3. Run tabulations, taking into account the weights.*/ 

clear all
set maxvar 7000

***********************
/*Recode SCF datasets*/ 
***********************
****************
/*1992 Dataset*/
****************
use "M:/SCF Data/1992/p92i4.dta"
gen year = 1992
label var year "Survey Year"

*Frequency weights
	*Divide by 5 since there are 5 imputations per obs
	gen fwt = X42001/5					   
	gen fwt_round = round(fwt)	

*Demographic info
	*Age by category 1: Under 35 = 1
	gen age_cat1 = X14	
	recode age_cat1 0/34=1 35/44=2 45/54=3 55/64=4 65/74=5 75/max=6
	label define age_cat1 1 "Younger than 35" 2 "35-44" 3 "45-54" 4 "55-64" 5 "65-74" 6 "75 or older"
	label variable age_cat1 "Age of head"
	*Age by category 2: Under 24 = 1
	gen age_cat2 = X14 
	recode age_cat2 0/24 = 1 25/34 = 2 35/44=3 45/54=4 55/64=5 65/74=6 75/max=7
	label define age_cat2 1 "Less than 25" 2 "25-34" 3 "35-44" 4 "45-54" 5 "55-64" 6 "65-74" 7 "75 or more"
	label variable age_cat2 "Age of head"  
	*Age by 3-year increments 
	gen age_cat3 = X14
	recode age_cat3 0/24 = 1 25/27 = 2 28/30 = 3 31/33 = 4 34/36 = 5 37/39 = 6 ///
           40/42 = 7 43/45 = 8 46/48 = 9 49/51 = 10 52/54 = 11 55/57 = 12 58/60 = 13 ///
           61/63 = 14 64/66 = 15 67/69 = 16 70/max = 17		   
	label define age_cat3 1 "Less than 25" 2 "25-27" 3 "28-30" 4 "31-33" 5 "34-36" 6 "37-39" ///
                  7 "40-42" 8 "43-45" 9 "46-48" 10 "49-51" 11 "52-54" 12 "55-57" ///
				  13 "58-60" 14 "61-63" 15 "64-66" 16 "67-69" 17 "70 and older"
	label variable age_cat3 "Age of head in 3-year increments" 		   		   
	*Test summarizing income by age...
	*by age, sort: summarize x5729 [weight= frequencyweight] , detail (not used in coding, just to test if it works)//

	*Education	
	gen edu = 4 if X5904 //College degree
	replace edu = 3 if X5901>=13 & X5904==5 //Some college
	replace edu = 2 if X5901<=12 & X5902 //High school diploma or equivalent 
	replace edu = 1 if missing(edu) //No high school diploma
	label define edu 1 "No High School Diploma" 2 "High School Diploma" 3 "Some College" 4 "College Degree" 
	label var edu "Education category of head"
	
	*Marital status 
	gen mar = inlist(X8023, 1, 2) //Married or living together
	replace mar = 0 if !inlist(X8023, 1, 2) //Never married nor living together
	label define mar 1 "Married or living with partner" 0 "Neither married nor living with partner"
	label var mar "Marital status of head"

	*Labor force participation
	gen lfpart = (inrange(X4100, 11, 30) | (X4100 == 97))  
	label define lfpart 1 "Working in some way" 0 "Not Working at all"
	label variable lfpart "Labor force participation of head"

	*Children
	gen children = inlist(4, X108, X114, X120, X126, X132, X202, X214, X220, X226) 
	label define children 1 "Has at least one child" 0 "Has no children"
	label variable children "Children in the household"
							
	*Family structure
	gen famstrc = !mar & children
	replace famstrc = 2 if !mar & !children & age_cat1<=3
	replace famstrc = 3 if !mar & !children & age_cat1>3
	replace famstrc = 4 if mar & children 
	replace famstrc = 5 if mar & !children 
	label define famstrc 1 "Single with child(ren)" 2 "Single, no child, age less than 55" 3 "Single, no child, age 55 or more" 4 "Couple with child(ren)" 5 "Couple, no child"
	label variable famstrc "Family structure"
                          
	*Race 
	gen race = X5909==5
	label define race 1 "White non-Hispanic" 0 "Nonwhite or Hispanic"
	label variable race "Race or ethnicity of respondent"

	*Work status
	generate workstat = (X4106==1) //Works for someone else  
	replace workstat = 2 if inlist(X4106, 2, 3) //Self employed
	replace workstat = 3 if inlist(X4100,50, 52) | (X14>=65 & inlist(X4100, 21, 30, 70, 80, 97, -7)) //Retired
	replace workstat = 4 if !workstat & X14<65 //Not working for some other reason
	label define workstat 1 "Working for someone else" 2 "Self-Employed" 3 "Retired" 4 "Other Not Working" 
	label variable workstat "Current work status of head"

	*Housing status
	gen housingstat = inlist(X508, 1, 2) | inlist(X601, 1, 2, 3) | inlist(X701, 1, 3, 4, 5, 6)				
	label define housingstat 1 "Owner" 0 "Renter or other" 
	label variable housingstat "Housing status"

	*Occupation
	gen occ = 1 if X7401
	replace occ = 2 if inlist(X7401, 2, 3)
	replace occ = 3 if inlist(X7401, 4, 5, 6)
	replace occ = 4 if !X7401
	label define occ 1 "Managerial or professional" 2 "Technical, sales, or services" 3 "Other occupation" 4 "Retired or other not working" 
	label variable occ "Current occupation of head"

	*Reasons for saving
	gen reason2save = (X3006 ==-2| X3006 == -1) 
	replace reason2save = 2 if (X3006 | X3006 == 2)
	replace reason2save = 3 if inlist(X3006, 3, 5, 6)
	replace reason2save = 4 if X3006==11
	replace reason2save = 5 if (inrange(X3006, 12, 16) | inlist(X3006, 27, 29, 30, 9, 18, 20, 41))
	replace reason2save = 6 if inlist(X3006, 17, 22)
	replace reason2save = 7 if inrange(X3006, 23, 25) | inlist(X3006, 32, 92, 93)
	replace reason2save = 8 if inlist(X3006, 21, 26, 28)
	replace reason2save = 9 if inlist(X3006, 31, 33, 40, 90, 91, -7)
	label define reason2save 1 "Can't Save" 2 "Education" 3 "Family" ///
		4 "Home" 5 "Purchases" 6 "Retirement" 7 "Liquidity/Future" ///
		8 "Investment" 9 "No Particular Reason"  
	label variable reason2save "Reasons for saving"							

* "Urbanicity" and "Census Region" are not included in the public dataset

*Financial info 
	*Income: IMPORTANT: THE FOLLOWING STEP FOR YEARS BEFORE 2001 ONLY
	gen income = max(0, X5729) 
	label variable income "Income"

	*Income components 
		*Wage income								
		generate inc_wage = X5702
		label variable inc_wage "Income from wages"
		
		*Interest/dividend income					
		generate inc_intdiv = X5706 + X5708 + X5710
		label variable inc_intdiv "Income from interests/dividends"
        
		*Business, farm, self-employment income					
		generate inc_busfarmself = X5704 + X5714
		label variable inc_busfarmself "Business/ farm/ self-employment income"
        
		*Capital gains income				
		generate inc_capgains = X5712						
		label variable inc_capgains "Income from capital gains"

		*Social security/retirement income
		gen inc_retss = X5722
		label variable inc_retss "Social security/ retirement income" 
		
		*Transfers or other income
		gen inc_transoth = X5722
		label variable inc_transoth "Transfer or other income" 
		
		*Components combined (total income) 
		gen inc_totcomp = X5702 + X5704 + X5714 + X5706 + X5708 + X5710 + X5712 + X5722 + X5716 + X5718 + X5720 + X5724
		label variable inc_totcomp "Value of income components combined"

	*Normal income, yearly - HOW IS THIS DIFFERENT FROM income VAR?
	*gen income_normal = X5729
		
	*Income percentiles
	pctile inc_pctile = income, n(6)
	label define inc_pctile 1 "Less than 20" 2 "20-39.9" 3 "40-59.9" 4 "60-79.9" 5 "80-89.9"  6 "90-100"
	label var inc_pctile "Income percentile"

	*Saving habits
	gen famsaving = (X7510 ==3) 
	label def famsaving 1 "Has savings" 0 "Did not save"
	label variable famsaving "Family saving status" 
	
	*Savings accounts
	gen savings_account = max(0, X3804)+max(0, X3807)+max(0, X3810)+max(0, X3813)+max(0, X3816)+max(0, X3818)
	label var savings_account "Value of savings account" 
    gen havesavings = (savings_account != 0)
    label def havesavings 1 "Has savings account" 0 "No savings account"
	label var havesavings "Family has a savings or money market account" 

	*Checking accounts
	gen checking_account = max(0, X3506)*(X3507==5) + max(0, X3510)*(X3511==5) + max(0, X3514)*(X3515==5)+ max(0, X3518)*(X3519==5) + max(0, X3522)*(X3523==5) + max(0, X3526)*(X3527==5)
	label var checking_account "Value of checking account"
	gen havechecking = (checking_account != 0) 
	label define havechecking 1 "Yes" 0 "No" 
	label var havechecking "Family has a checking account" 

	*Reason for choosing main checking account
	gen checking_account_reason = 10 
	replace checking_account_reason = 1 if X3530==3
	replace checking_account_reason = 2 if X3530==7
	replace checking_account_reason = 3 if X3530==6
	replace checking_account_reason = 4 if X3530==1
	replace checking_account_reason = 5 if X3530==11
	replace checking_account_reason = 6 if X3530==35
	replace checking_account_reason = 7 if X3530==14
	replace checking_account_reason = 8 if X3530==8
	replace checking_account_reason = 9 if X3530==9
	label define checking_account_reason 1 "Location" 2 "Low Fee Balance" 3 "Many Services"  4 "Recommended by Friend/Family" 5 "Personal Relationship" 6 "Connection through Work/School" 7 "Always done business there" 8 "Safety" 9 "Convenience/Direct Deposit" 10 "Other"
	label variable checking_account_reason "Reason For choosing main checking account"

    *Money owed
	gen owedmoney = (X4017==1)
	label define owedmoney 1 "Yes" 0 "No"
	label var owedmoney "Household is owed money by friends, relatives, or others"
			         
	*Other substantial assets
	gen miscassets = X4018 + X4022 + X4026 + X4030
	label var miscassets "Value of miscellaneous assets" 
	gen hasmiscassets = (X4019==1) 
	label var hasmiscassets "Household owns miscellaneous assets"
	
	*Other debt
	gen otherdebt = (X4031 == 1)
	label define otherdebt 1 "Yes" 0 "No" 
	label variable otherdebt "Household owes other debt (not recorded earlier)"                          

	*Money market deposit accounts
	gen mmda = max(0, X3506)*((X3507==1)*inrange(X9113, 11, 13)) ///
	+ max(0, X3510)*((X3511==1)*inrange(X9114, 11, 13)) /// 
	+ max(0, X3514)*((X3515==1)*inrange(X9115, 11, 13)) ///
	+ max(0, X3518)*((X3519==1)*inrange(X9116, 11, 13)) ///
	+ max(0, X3522)*((X3523==1)*inrange(X9117, 11, 13)) ///	
	+ max(0, X3526)*((X3527==1)*inrange(X9118, 11, 13)) ///
	+ max(0, X3706)*inrange(11, X9131, 13)+max(0, X3711)*inrange(11, X9132, 13) ///
	+ max(0, X3716)*inrange(11, X9133, 13)+max(0, X3718)*inrange(11, X9133, 13)
	label variable mmda "Value in money market deposit accounts"

	*Money market mutual funds
	generate mmmf = max(0,X3506)*(X3507==1)*(X9113<11|X9113>13) ///
        +max(0,X3510)*(X3511==1)*(X9114<11|X9114>13) ///
        +max(0,X3514)*(X3515==1)*(X9115<11|X9115>13) ///
        +max(0,X3518)*(X3519==1)*(X9116<11|X9116>13) ///
        +max(0,X3522)*(X3523==1)*(X9117<11|X9117>13) ///
        +max(0,X3526)*(X3527==1)*(X9118<11|X9118>13) ///
        +max(0,X3529)*(X3527==1)*(X9118<11|X9118>13) ///
        +max(0,X3706)*(X9131<11|X9131>13)+max(0,X3711)*(X9132<11|X9132>13) ///
        +max(0,X3716)*(X9133<11|X9133>13)+max(0,X3718)*(X9133<11|X9133>13) 
	label variable mmmf "Value in money market mutual funds"		
 
	*Total money market account value
	gen mma = mmda + mmmf
	label var mma "Value of money market account" 

	*Brokerage account
	gen brokerage = max(0, X3930) 
	label var brokerage "Value of brokerage account"
	gen havebrokerage = X3923==1
	label define havebrokerage 1 "Yes" 0 "No" 
	label var havebrokerage "Household has brokerage account"
	
	*Past year trading
	gen trading_pastyr = X3928>0 
	recode trading_pastyr (mis = 0)
	label define trading_pastyr 1 "Yes" 0 "No" 
	label var trading_pastyr "Houshold traded in the past year" 
	
	*All types of transaction accounts (liquid assets)
	gen lqacc = mma + brokerage + checking_account + savings_account
	label var lqacc = "Total value of transaction accounts (liquid assets)" 
	gen have_lqacc = (lqacc != 0) | inlist(1, X3501, X3701, X3801, X3929)
	label define have_lqacc 1 "Yes" 0 "No" 
	label variable have_lqacc "Household has any type of transaction account"
	replace lqacc = max(have_lqacc, lqacc) //Includes accounts with zero balance - they are labeled as 1//

	*CDs (Certificates of Deposit)
	gen cds = max(0, X3721) 
	label var cds "Value of CDs"
	gen havecd = (X3719==1) 
	label var havecd "Household has certificates of deposit" 
	
	*Value of mutual funds
	gen mf_stock = max(0, X3822) if X3821
	gen mf_taxfreebond = max(0, X3822) if X3823						
	gen mf_govbond = max(0, X3826) if X3825
	gen mf_otherbond = max(0, X3828) if X3827
	gen mf_combo = max(0, X3830) if X3829
	recode mf_stock mf_taxfreebond mf_govbond mf_otherbond mf_combo (mis = 0) 
	gen mf = mf_stock + mf_taxfreebond + mf_govbond mf_otherbond + mf_combo 
	label var mf "Total value of mutual funds" 
	gen havemf = mf != 0
	label define havemf 1 "Yes" 0 "No" 
	label var mf "House hold has mutual funds or hedge funds" 

	*Value of stocks and number of companies 
	gen stocks = max(0, X3915)
	label var stocks "Total value of stocks" 
	generate nstocks = X3914
	label var nstocks "Number of companies in which family holds stock" 
	
	*Publicly traded stock
	gen havepublicstock = X3913 == 1
	label define havepublicstock 1 "Yes" 0 "No" 
	label var havepublicstock "Household owns publicly traded stock" 
	
	*Value of bonds (excluding bond funds and savings bonds)
	gen bonds_taxexempt = X3910
	gen bonds_mortgagebacked = X3906
	gen bonds_gov = X3908
	gen bonds_corpforeign = X7634 + X7633
	recode bonds_taxexempt bonds_mortgagebacked bonds_gov bonds_corpforeign (mis = 0) 
	gen bonds = bonds_taxexempt + bonds_mortgagebacked + bonds_gov + bonds_corpforeign
	label var bonds "Total value of bonds" 
	
	gen haveotherbonds = (X3903==1) 
	label def haveotherbonds 1 "Yes" 0 "No"
	label var haveotherbonds "Family owns corporate, municpal, or gov bonds" 

	*Retiremement account totals 
	generate ira_keogh = max(0, X3610)+ max(0, X3620)+ max(0, X3630)
	label ira_keogh "Value of IRA/Keogh retirement account"
	gen have_ira_keogh = X3601==1
	label define have_ira_keogh 1 "Yes" 0 "No" 
	label variable have_ira_keogh "Household has an IRA/Keogh account"    

	*Total future pensions
	gen pension_future = max(0, X5604) + max(0, X5612) + max(0, X5620) + max(0, X5628) + max(0, X5636) + max(0, X5644)
	label var pension_future "Future pension" 
	
	*Pension contributions
	gen penj1 = X
                     

                             //Job Pension// 
gen job_pension1 = 0 
gen job_pension1 = X4226 if inlist(X4216, 1, 2, 7, 11, 12, 13)|inlist(1, X4227, X4231)
replace job_pension1 = 0 if X4226 == -1

gen job_pension2 = 0
replace job_pension2 = X4326 if inlist(X4316, 1, 2, 7, 11, 12, 13)|inlist(1, X4327, X4331)
replace job_pension2 = 0 if X4326 == -1

gen job_pension3 = 0 
replace job_pension3 = X4426 if inlist(X4416, 1, 2, 7, 11, 12, 13)|inlist(1, X4427, X4431)
replace job_pension3 = 0 if X4426 == -1

gen job_pension4 = 0
replace job_pension4 = X4826 if inlist(X4816, 1, 2, 7, 11, 12, 13)|inlist(1, X4827, X4831)
replace job_pension4 = 0 if X4826 == -1



(x4816==1 | x4816==2 | x4816==7 | x4816==11 ///
   | x4816==12 | x4816==18 | x4827==1 | x4831==1)
replace job_pension4 = 0 if x4826==-1

generate job_pension5 = 0
replace job_pension5 = x4926 if (x4916==1 | x4916==2 | x4916==7 | x4916==11 ///
   | x4916==12 | x4916==18 | x4927==1 | x4931==1)
replace job_pension5 = 0 if x4926==-1

generate job_pension6 = 0
replace job_pension6 = x5026 if (x5016==1 | x5016==2 | x5016==7 | x5016==11 ///
   | x5016==12 | x5016==18 | x5027==1 | x5031==1)
replace job_pension6 = 0 if x5026==-1


generate job_pension = job_pension1 + job_pension2 + job_pension3 + job_pension4 ///
                     + job_pension5 + job_pension6
					 
label variable job_pension "Pension from the Current Job"					 

                                    //Have Job Pension//
									  
generate have_job_pension = 0   

replace have_job_pension = 1 if job_pension~=0

label define have_job_pension 1 "Yes" 0 "No" 

label values have_job_pension have_job_pension

label variable have_job_pension "Do you have Pension from Current Job?"


                       //Account-type Pension Plans//

generate peneq1 = 0
replace peneq1 = peneq1 + job_pension1*(x4234==1 + .5*(x4234==3))

generate peneq2 = 0
replace peneq2 = peneq2 + job_pension2*(x4334==1 + .5*(x4334==3))

generate peneq3 = 0
replace peneq3 = peneq3 + job_pension3*(x4434==1 + .5*(x4434==3))

generate peneq4 = 0
replace peneq4 = peneq4 + job_pension4*(x4834==1 + .5*(x4834==3))

generate peneq5 = 0
replace peneq5 = peneq5 + job_pension5*(x4934==1 + .5*(x4934==3))

generate peneq6 = 0
replace peneq6 = peneq6 + job_pension6*(x5034==1 + .5*(x5034==3))

generate peneq = peneq1 + peneq2 + peneq3 + peneq4 + peneq5 + peneq6
                                  
                //Respondent's thrift account is equal to the first 3 job pensions//
				
generate rthrift = job_pension1 + job_pension2 + job_pension3

                //Spouse's thrift account is equal to the last 3 job pensions//
				
generate sthrift = job_pension4 + job_pension5 + job_pension6
 
                 //Thrift account is equal to the respondent's and spouse's thrift accounts combined //
				                    // (which is also equal to 6 job pensions //
									
generate thrift = rthrift + sthrift

                   //Respondent's equity is equal to the first 3 pension equities//
generate req = peneq1 + peneq2 + peneq3

                       //Spouse equity is equal to the last 3 pension equities//
generate seq = peneq4 + peneq5 + peneq6						

 
                                   //Pension Mopups//                                   
generate pmopup = 0
replace pmopup = x4436 if x4436>0
replace pmopup = x4436 if (x4436>0 & (x4216==1 | x4216==2 | x4216==7 | x4216==11 ///
                                   | x4216==12 | x4216==18 | x4316==1 | x4316==2 ///
								   | x4316==7 | x4316==11 | x4316==12 | x4316==18 ///
	         | x4416==1 | x4416==2 | x4416==7 | x4416==11 | x4416==12 | x4416==18 ///
			 | x4231==1 | x4331==1 | x4431==1 | x4227==1 | x4327==1 | x4427==1))
	
replace pmopup = 0 if (x4436>0 & x4216~=0 & x4316~=0 & x4416~=0 & x4231~=0 & x4331~=0 & x4431~=0)


replace pmopup = x5036 if x5036>0
replace pmopup = x5036 if (x5036>0 & (x4816==1 | x4816==2 | x4816==7 | x4816==11 ///
                                   | x4816==12 | x4816==18 | x4916==1 | x4916==2 ///
								   | x4916==7 | x4916==11 | x4916==12 | x4916==18 ///
	         | x5016==1 | x5016==2 | x5016==7 | x5016==11 | x5016==12 | x5016==18 ///
			 | x4831==1 | x4931==1 | x5031==1 | x4827==1 | x4927==1 | x5027==1))
	
replace pmopup = 0 if (x5036>0 & x4816~=0 & x4916~=0 & x5016~=0 & x4831~=0 & x4931~=0 & x5031~=0)
	
replace thrift = thrift + pmopup if x4436>0
replace thrift = thrift + pmopup if x5036>0

replace peneq = (peneq + pmopup*(req/rthrift)) if req>0 & x4436>0
replace peneq = (peneq + pmopup/2) if req<=0 & x4436>0

replace peneq = (peneq + pmopup*(seq/sthrift)) if seq>0 & x5036>0
replace peneq = (peneq + pmopup/2) if seq<=0 & x5036>0


drop rthrift sthrift req seq 
	
	
                   //Sum of IRA/Keogh, Thrift, and Future Pension Accounts//			 
			  
generate retirement_account = ira_keogh + thrift + future_pension
label variable retirement_account "Total of IRA/Keogh, Thrift, and Future Pension Accounts"

                             //Have Retirement Account//
								  
generate have_retirement_account = 0

replace have_retirement_account = 1 if retirement_account~=0

label define have_retirement_account 1 "Yes" 0 "No" 

label values have_retirement_account have_retirement_account

label variable have_retirement_account "Do you have a Retirement Account?"


                      **        //Pension Plans//         **
								   
							   //Any Pension Plan//
								 
generate any_pension_plan = 1 if x4135==1 | x4735==1 | x5313==1 | x5601==1
recode any_pension_plan (mis=0)

label define any_pension_plan 1 "Yes" 0 "No" 

label values any_pension_plan any_pension_plan

label variable any_pension_plan "Any Type of Pension (either head or spouse)"

rename any_pension_plan have_any_pension_plan

								 //Defined Benefit Plan (Current Job)//      

generate dbplancj = 1 if x4203==1 | x4303==1 | x4403==1 | x4803==1 | x4903==1 ///
        | x5003==1 | x5316==1 | x5324==1 | x5332==1 | x5416==1 | x5424==1 | x5432==1

recode dbplancj (mis=0)

label define dbplancj 1 "Yes" 0 "No" 

label values dbplancj dbplancj

label variable dbplancj "Defined benefit pension on a current job (either head or spouse)"
rename dbplancj  have_dbplancj

                       //Defined Contribution Plan (Current Job)//      

generate dcplancj = 1 if (x4203==2 | x4203==3) | (x4303==2 | x4303==3) ///
        | (x4403==2 | x4403==3) | (x4803==2 | x4803==3) | (x4903==2 | x4903==3) ///
		| (x5003==2 | x5003==3)

recode dcplancj (mis=0)

label define dcplancj 1 "Yes" 0 "No" 

label values dcplancj dcplancj

label variable dcplancj "Defined contribution pension on a current job (either head or spouse)"
rename dcplancj have_dcplancj

               //Defined Benefit Plan from either the current job or the past job (either head or spouse)//
			   
generate have_dbplan = 1 if have_dbplancj==1 | x5314>0 | x5603==1 | x5603==3 ///
        | x5611==1 | x5611==3 | x5619==1 | x5619==3 | x5627==1 | x5627==3 ///
		| x5635==1 | x5635==3 | x5643==1 | x5643==3
		
recode have_dbplan (mis=0)

label define have_dbplan 1 "Yes" 0 "No" 

label values have_dbplan have_dbplan

label variable have_dbplan "Defined benefit pension on a current job or from past job (either head or spouse)"

 
     //Both Types of Pension Plan on a Current Job (either head or spouse)//
 
generate have_both_plans_current_job = 1 if have_dcplancj==1 & have_dbplancj==1

recode have_both_plans_current_job (mis=0)

label define have_both_plans_current_job 1 "Yes" 0 "No" 

label values have_both_plans_current_job have_both_plans_current_job

label variable have_both_plans_current_job "Both Types of Pension Plan on a Current Job (either head or spouse)"
 
 
                       //Value of Savings Bonds//
								 
generate savings_bonds = x3902
label variable savings_bonds "Total Value of Savings Bonds"


                            //Savings Bonds//
									 
									 
generate have_savings_bonds = x3901   

label define have_savings_bonds 1 "Yes" 5 "No" 

label values have_savings_bonds have_savings_bonds

label variable have_savings_bonds "Do you have any U.S. government savings bonds?"


      //Cash Value of Life Insurance (Note: this does not include term insurance//

generate life_insurance_cash_value = max(0, x4006)
label variable life_insurance "Total Cash Value of Life Insurance"

                            //Have Life Insurance//
														
generate have_life_insurance = 0

replace have_life_insurance = 1 if life_insurance_cash_value~=0  

label define have_life_insurance 1 "Yes" 0 "No" 

label values have_life_insurance have_life_insurance

label variable have_life_insurance "Do you have any Life Insurance?"


                  //Value of Other Managed Assets//	
	
generate other_managed_assets = max(0, x3942)
label variable other_managed_assets "Value of Other Managed Assets (Annuities + Trusts)"

generate have_other_managed_assets = 0
replace have_other_managed_assets = 1 if other_managed_assets~=0
label define have_other_managed_assets 1 "Yes" 0 "No" 
label values have_other_managed_assets have_other_managed_assets
label variable have_other_managed_assets "Do you have Annuities, Trusts, or Other Managed Investment Accounts?"	
			  
				                 //Value of Annuities//			   
generate annuities = (x3934==1) / max(1,((x3934==1)+(x3935==1)+(x3936==1)+(x3937==1)))
label variable annuities "Total Value of Annuities"

generate have_annuity = 0
replace have_annuity = 1 if annuities~=0
label define have_annuity 1 "Yes" 0 "No" 
label values have_annuity have_annuity
label variable have_annuity "Do you have assets in an Annuity Account?"
 
               //Value of Trusts/Managed Investment Accounts//
generate trusts = other_managed_assets - annuities
label variable trusts "Total Value of Trusts"

generate have_trust_mia = 0
replace have_trust_mia = 1 if trusts~=0
label define have_trust_mia 1 "Yes" 0 "No" 
label values have_trust_mia have_trust_mia
label variable have_trust_mia "Do you have assets in a Trust or a Managed Investment Account?"


                  //Value of Other Financial Assets//

 generate other_financial_assets = x4018
 replace other_financial_assets =  other_financial_assets + x4022 if x4020==61
 replace other_financial_assets =  other_financial_assets + x4022 if x4020==62
 replace other_financial_assets =  other_financial_assets + x4022 if x4020==63
 replace other_financial_assets =  other_financial_assets + x4022 if x4020==64
 replace other_financial_assets =  other_financial_assets + x4022 if x4020==65
 replace other_financial_assets =  other_financial_assets + x4022 if x4020==66
 replace other_financial_assets =  other_financial_assets + x4022 if x4020==71
 replace other_financial_assets =  other_financial_assets + x4022 if x4020==72
 replace other_financial_assets =  other_financial_assets + x4022 if x4020==73
 replace other_financial_assets =  other_financial_assets + x4022 if x4020==74
 replace other_financial_assets =  other_financial_assets + x4022 if x4020==77
 replace other_financial_assets =  other_financial_assets + x4022 if x4020==80
 replace other_financial_assets =  other_financial_assets + x4022 if x4020==81
 replace other_financial_assets =  other_financial_assets + x4022 if x4020==-7
 
 replace other_financial_assets =  other_financial_assets + x4026 if x4024==61
 replace other_financial_assets =  other_financial_assets + x4026 if x4024==62
 replace other_financial_assets =  other_financial_assets + x4026 if x4024==63
 replace other_financial_assets =  other_financial_assets + x4026 if x4024==64
 replace other_financial_assets =  other_financial_assets + x4026 if x4024==65
 replace other_financial_assets =  other_financial_assets + x4026 if x4024==66
 replace other_financial_assets =  other_financial_assets + x4026 if x4024==71
 replace other_financial_assets =  other_financial_assets + x4026 if x4024==72
 replace other_financial_assets =  other_financial_assets + x4026 if x4024==73
 replace other_financial_assets =  other_financial_assets + x4026 if x4024==74
 replace other_financial_assets =  other_financial_assets + x4026 if x4024==77
 replace other_financial_assets =  other_financial_assets + x4026 if x4024==80
 replace other_financial_assets =  other_financial_assets + x4026 if x4024==81
 replace other_financial_assets =  other_financial_assets + x4026 if x4024==-7
 
 replace other_financial_assets =  other_financial_assets + x4030 if x4028==61
 replace other_financial_assets =  other_financial_assets + x4030 if x4028==62
 replace other_financial_assets =  other_financial_assets + x4030 if x4028==63
 replace other_financial_assets =  other_financial_assets + x4030 if x4028==64
 replace other_financial_assets =  other_financial_assets + x4030 if x4028==65
 replace other_financial_assets =  other_financial_assets + x4030 if x4028==66
 replace other_financial_assets =  other_financial_assets + x4030 if x4028==71
 replace other_financial_assets =  other_financial_assets + x4030 if x4028==72
 replace other_financial_assets =  other_financial_assets + x4030 if x4028==73
 replace other_financial_assets =  other_financial_assets + x4030 if x4028==74
 replace other_financial_assets =  other_financial_assets + x4030 if x4028==77
 replace other_financial_assets =  other_financial_assets + x4030 if x4028==80
 replace other_financial_assets =  other_financial_assets + x4030 if x4028==81
 replace other_financial_assets =  other_financial_assets + x4030 if x4028==-7

label variable other_financial_assets "Value of Other Financial Assets"

                      //Have Other Financial Assets//

generate have_other_financial_assets = 0
replace have_other_financial_assets = 1 if other_financial_assets~=0

label define have_other_financial_assets 1 "Yes" 0 "No" 

label values have_other_financial_assets have_other_financial_assets

label variable have_other_financial_assets "Do you have any other Financial Assets?"


       //Total Financial Assets (adds all financial assets together)//

generate Total_Financial_Assets = liquid_accounts + cds + mutual_funds + stocks + bonds ///
  + retirement_account + savings_bonds + life_insurance_cash_value + other_managed_assets ///
  + other_financial_assets
  
label variable Total_Financial_Assets "Total Financial Assets"  

                            //Have Any Financial Assets//
							  
generate Have_Any_Financial_Assets = 0
replace Have_Any_Financial_Assets = 1 if Total_Financial_Assets~=0

label define Have_Any_Financial_Assets 1 "Yes" 0 "No" 

label values Have_Any_Financial_Assets Have_Any_Financial_Assets

label variable Have_Any_Financial_Assets "Do you have Any Financial Assets?"	


                 //Financial Assets (Equity) Invested in Stock//
							
							
generate equity_in_stock = stocks+stock_mutual_funds+.5*combination_mutual_funds ///
     + ira_keogh*((x3631==2)+.5*(x3631==5 | x3631==6)+.3*(x3631==4)) /// 
	 + other_managed_assets*((x3947==1)+.5*(x3947==5 | x3947==6) ///
	 +.3*(x3947==4 | x3947==-7)) + peneq

label variable equity_in_stock "Equity (Financial Assets) Invested in Stock"

                       //Have Stock (Financial Assets) Equity//							

generate have_equity_in_stock = 0

replace have_equity_in_stock = 1 if equity_in_stock>0
 
label define have_equity_in_stock 1 "Yes" 0 "No" 

label values have_equity_in_stock have_equity_in_stock

label variable have_equity_in_stock "Do you have any stock equity?"


     //Financial Assets (Equity) Directly held in Stocks and Mutual Funds//
		  
generate directly_held_equity = stocks + stock_mutual_funds + .5*combination_mutual_funds	

label variable directly_held_equity "Equity Directly held in Stocks and Mutual Funds"

           //Have Equity directly held in stocks and mutual funds//

generate have_directly_held_equity	= 0

replace have_directly_held_equity = 1 if directly_held_equity~=0 			   
 
label define have_directly_held_equity 1 "Yes" 0 "No" 

label values have_directly_held_equity have_directly_held_equity

label variable have_directly_held_equity "Do you have any equity directly held in Stocks and Mutual Funds?"	


                   //Equity in quasi-liquid retirement assets//
				   
generate reteq =ira_keogh*((x3631==2)+.5*(x3631==5|x3631==6)+.3*(x3631==4))+peneq
label variable reteq "Equity in quasi-liquid retirement assets"
				   
				   //Have equity in quasi-liquid retirement assets//

generate have_reteq	= 0

replace have_reteq = 1 if reteq~=0 			   
 
label define have_reteq 1 "Yes" 0 "No" 

label values have_reteq have_reteq

label variable have_reteq "Do you have any equity in quasi-liquid retirement assets?"	

	  		  
****************************************************************************
**Vehicles and Other Non-Financial Assets
****************************************************************************


                          //Value and Number of Vehicles// 
										  
generate vehicles = max(0, x8166) + max(0, x8167) + max(0, x8168) ///
 + max(0, x2422) + max(0, x2506) + max(0, x2606) + max(0, x2623)
  
label variable vehicles "Total Value of Vehicles"
  
 
generate have_vehicles = 1 if vehicles>0

recode have_vehicles (mis=0) 
 
label define have_vehicles 1 "Yes" 0 "No" 

label values have_vehicles have_vehicles

label variable have_vehicles "Do you have any Vehicles?"


       //Value and Number of Owned Vehicles (not leased or supplied by business)//
						
                          //Have an owned vehicle//
						  
generate own_vehicle = 0

replace own_vehicle = 1 if x2201==1

label define own_vehicle 1 "Yes" 0 "No" 

label values own_vehicle  own_vehicle

label variable  own_vehicle "Do you own any Vehicles?"

                           //Number of owned vehicles//

generate number_owned_vehicles = x2202		

label variable number_owned_vehicles "Number of owned vehicles"				  

                          //Value of owned vehicles//
						  
generate value_owned_vehicles = x8166+x8167+x8168

label variable value_owned_vehicles "Value of owned vehicles"	
  
 
                         //Farm Business//
						
replace x507= 0 if x507==-1
replace x507= 9000 if x507>9000

generate farmbus = 0 

replace farmbus= ((x507/10000) * (x513+x526-x805-x905-x1005)) if x507>0
replace farmbus = (farmbus - x1108*x507/10000) if x1103==1
replace farmbus = (farmbus - x1119*x507/10000) if x1114==1
replace farmbus = (farmbus - x1130*x507/10000) if x1125==1 

label variable farmbus "Value of a Farm Business"
	   

                //Value and number of Houses (Primary Residence)//
									
generate houses = (x604 + x614 + x623 + x716) + ((10000 - max(0, x507))/10000) * (x513 + x526)

label variable houses "Value of Houses (Primary Residence)"
generate have_houses = 0

replace have_houses = 1 if houses>0

label define have_houses 1 "Yes" 0 "No" 

label values have_houses have_houses

label variable have_houses "Do you own any Houses?"


                          //Homeownership Class//
							 
generate homeownership_class = 2
replace homeownership_class = 1 if x508==1 | x508==2 | x601==1 | x601==2 | x601==3 ///
 | x701==1 | x701==3 | x701==4 | x701==5 | x701==6 
 
label define homeownership_class 1 "Owns Ranch/Farm/Mobile Home/House/Condo/Coop/etc" 2 "Otherwise" 

label values homeownership_class homeownership_class

label variable homeownership_class "Homeownership Class"


                    //Other Residential Real Estate//
						  
generate other_residential_real_estate = max(x1405, x1409) + ///
max(x1505, x1509) + max(x1605, x1609) + max(0, x1619) 


replace other_residential_real_estate = other_residential_real_estate + (max(0, x1706) * (x1705/10000)) if x1703==12 | x1703==14 | x1703==21 ///
 | x1703==22 | x1703==25 | x1703==40 | x1703==41 | x1703==42 | x1703==43 ///
 | x1703==44 | x1703==49 | x1703==50 | x1703==52 | x1703==999

 
replace other_residential_real_estate = other_residential_real_estate + (max(0, x1806) * (x1805/10000)) if x1803==12 | x1803==14 | x1803==21 ///
 | x1803==22 | x1803==25 | x1803==40 | x1803==41 | x1803==42 | x1803==43 ///
 | x1803==44 | x1803==49 | x1803==50 | x1803==52 | x1803==999
 
replace other_residential_real_estate = other_residential_real_estate + (max(0, x1906) * (x1905/10000)) if x1903==12 | x1903==14 | x1903==21 ///
 | x1903==22 | x1903==25 | x1903==40 | x1903==41 | x1903==42 | x1903==43 ///
 | x1903==44 | x1903==49 | x1903==50 | x1903==52 | x1903==999
  
replace other_residential_real_estate = other_residential_real_estate +  max(0, x2002)

label variable other_residential_real_estate "Value of Other Residential Real Estate"


generate have_other_res_real_estate = 0

replace have_other_res_real_estate  = 1 if other_residential_real_estate~=0

label define have_other_res_real_estate  1 "Yes" 0 "No" 

label values have_other_res_real_estate have_other_res_real_estate 

label variable have_other_res_real_estate  "Do you own any other Residential Real Estate?"


                   //Net Equity in Nonresidential Real Estate//

generate non_res_real_estate = 0

replace non_res_real_estate = non_res_real_estate + (max(0, x1706) * (x1705/10000)) if x1703==1 | x1703==2 ///
| x1703==3 | x1703==4 | x1703==5 | x1703==6 | x1703==7 | x1703==10 | x1703==11 | x1703==13 ///
| x1703==15 | x1703==24 | x1703==45 | x1703==46 | x1703==47 | x1703==48 | x1703==51 ///
| x1703==-7

replace non_res_real_estate = non_res_real_estate + (max(0, x1806) * (x1805/10000)) if x1803==1 | x1803==2 ///
| x1803==3 | x1803==4 | x1803==5 | x1803==6 | x1803==7 | x1803==10 | x1803==11 | x1803==13 ///
| x1803==15 | x1803==24 | x1803==45 | x1803==46 | x1803==47 | x1803==48 | x1803==51 ///
| x1803==-7

replace non_res_real_estate = non_res_real_estate + (max(0, x1906) * (x1905/10000)) if x1903==1 | x1903==2 ///
| x1903==3 | x1903==4 | x1903==5 | x1903==6 | x1903==7 | x1903==10 | x1903==11 | x1903==13 ///
| x1903==15 | x1903==24 | x1903==45 | x1903==46 | x1903==47 | x1903==48 | x1903==51 ///
| x1903==-7

replace non_res_real_estate = non_res_real_estate + max(0, x2012)

replace non_res_real_estate = non_res_real_estate - (x1715 * (x1705/10000)) if x1703==1 | x1703==2 ///
| x1703==3 | x1703==4 | x1703==5 | x1703==6 | x1703==7 | x1703==10 | x1703==11 | x1703==13 ///
| x1703==15 | x1703==24 | x1703==45 | x1703==46 | x1703==47 | x1703==48 | x1703==51 ///
| x1703==-7

replace non_res_real_estate = non_res_real_estate - (x1815 * (x1805/10000)) if x1803==1 | x1803==2 ///
| x1803==3 | x1803==4 | x1803==5 | x1803==6 | x1803==7 | x1803==10 | x1803==11 | x1803==13 ///
| x1803==15 | x1803==24 | x1803==45 | x1803==46 | x1803==47 | x1803==48 | x1803==51 ///
| x1803==-7

replace non_res_real_estate = non_res_real_estate - (x1915 * (x1905/10000)) if x1903==1 | x1903==2 ///
| x1903==3 | x1903==4 | x1903==5 | x1903==6 | x1903==7 | x1903==10 | x1903==11 | x1903==13 ///
| x1903==15 | x1903==24 | x1903==45 | x1903==46 | x1903==47 | x1903==48 | x1903==51 ///
| x1903==-7

replace non_res_real_estate = non_res_real_estate - x2016

label variable non_res_real_estate "Net Equity in Nonresidential Real Estate"


 //Installment Loan Correction to non-residential real estate//
 
replace non_res_real_estate = . if non_res_real_estate==0  //excluding 0 values from operation//

replace non_res_real_estate = non_res_real_estate - x2723 if (x2710==78) 
replace non_res_real_estate = non_res_real_estate - x2740 if (x2727==78)
replace non_res_real_estate = non_res_real_estate - x2823 if (x2810==78)
replace non_res_real_estate = non_res_real_estate - x2840 if (x2827==78)
replace non_res_real_estate = non_res_real_estate - x2923 if (x2910==78)
replace non_res_real_estate = non_res_real_estate - x2840 if (x2927==78)

replace non_res_real_estate = 0 if non_res_real_estate==.  //including 0 values back//


generate have_non_res_real_estate = 0

replace have_non_res_real_estate  = 1 if non_res_real_estate~=0

label define have_non_res_real_estate  1 "Yes" 0 "No" 

label values have_non_res_real_estate have_non_res_real_estate 

label variable have_non_res_real_estate  "Do you own any Nonresidential Real Estate?"


       //Value of Businesses (both with active and non-active interests)//
   //Note: active and non-active interests can be further separated - see SCF SAS code//
						

generate business = 0 
replace business = business + max(0, x3129) + max(0, x3124) ///
 - max(0, x3126) * (x3127==5) + max(0, x3121) * (x3122==1) + max(0, x3121) * (x3122==6) ///
 + max(0, x3229) + max(0, x3224) - max(0, x3226) * (x3227==5) ///
 + max(0, x3221)*(x3222==1) + max(0, x3221)*(x3222==6) ///
 + max(0, x3329) + max(0, x3324) - max(0, x3326)*(x3327==5) ///
 + max(0, x3321)*(x3322==1) + max(0, x3321)*(x3322==6) ///
 + max(0, x3335) + farmbus + max(0, x3408) + max(0, x3412) ///
 + max(0, x3416) + max(0, x3420) + max(0, x3424) + max(0, x3428) 

 label variable business "Total Value of Business Interests"


generate have_business_assets = 0

replace have_business_assets  = 1 if (x3103==1 | x3401==1)

label define have_business_assets  1 "Yes" 0 "No" 

label values have_business_assets  have_business_assets 

label variable have_business_assets  "Do you have any Business Assets?"

                          //Active Business//
						 
generate actbus = 0
replace actbus = max(0, x3129) + max(0, x3124) ///
 - max(0, x3126) * (x3127==5) + max(0, x3121) * (x3122==1) + max(0, x3121) * (x3122==6) ///
 + max(0, x3229) + max(0, x3224) - max(0, x3226) * (x3227==5) ///
 + max(0, x3221)*(x3222==1) + max(0, x3221)*(x3222==6) ///
 + max(0, x3329) + max(0, x3324) - max(0, x3326)*(x3327==5) ///
 + max(0, x3321)*(x3322==1) + max(0, x3321)*(x3322==6) ///
 + max(0, x3335) + farmbus 
 
label variable actbus "Value of Active Business Interests"


             //Value of Other Nonfinancial Assets//

generate other_non_financial_assets = 0

replace other_non_financial_assets = other_non_financial_assets + x4022 ///
+ x4026 + x4030 - other_financial_assets + x4018

label variable other_non_financial_assets "Total Value of Other Nonfinancial Assets"


generate have_other_nonfin_assets = 0

replace have_other_nonfin_assets = 1 if other_non_financial_assets~=0

label define have_other_nonfin_assets  1 "Yes" 0 "No" 

label values have_other_nonfin_assets have_other_nonfin_assets 

label variable have_other_nonfin_assets  "Do you have any other Nonfinancial Assets?"


                 //Total Value of Nonfinancial Assets//

 generate Total_Nonfinancial_Assets = vehicle + houses + other_residential_real_estate ///
  + non_res_real_estate + business + other_non_financial_assets                
  
 label variable Total_Nonfinancial_Assets "Total Value of Nonfinancial Assets"
  
 
generate have_nonfin_assets = 0

replace have_nonfin_assets = 1 if Total_Nonfinancial_Assets~=0

label define  have_nonfin_assets  1 "Yes" 0 "No" 

label values  have_nonfin_assets  have_nonfin_assets 

label variable  have_nonfin_assets  "Do you own any Nonfinancial Assets?"


                          //TOTAL ASSETS//
 							   
generate TOTAL_ASSETS = Total_Nonfinancial_Assets + Total_Financial_Assets

label variable TOTAL_ASSETS "Total Value of Assets"


generate HAVE_ANY_ASSETS = 0

replace HAVE_ANY_ASSETS = 1 if TOTAL_ASSETS~=0

label define  HAVE_ANY_ASSETS  1 "Yes" 0 "No" 

label values  HAVE_ANY_ASSETS HAVE_ANY_ASSETS

label variable  HAVE_ANY_ASSETS "Do you own any Assets?"
  
  
 ****************************************************************************************** 
  //DEBT//
 ******************************************************************************************
  
                               //Housing Debt//
  
generate newvar = max(0, x1136)*(x1108*(x1103==1) + x1119*(x1114==1) + x1130*(x1125==1))/(x1108+x1119+x1130)
recode newvar (mis=0)

generate newvar2 = x1108*(x1103==1) + x1119*(x1114==1) + x1130*(x1125==1)

generate heloc1 = newvar+newvar2

generate newvar3 = max(0, x1136)*(x1108*(x1103==1)+ x1119*(x1114==1)+x1130*(x1125==1))/(x1108+x1119+x1130)
recode newvar3 (mis=0)

generate newvar4 = x805+x905+x1005+ x1108*(x1103==1)+x1119*(x1114==1)+x1130*(x1125==1)

generate mrthel1 = newvar3 + newvar4


generate heloc2 = 0

generate mrthel2 = x805 + x905 + x1005 + .5*(max(0, x1136))*(houses>0)


generate heloc = heloc1 if (x1108 +x1119 + x1130)>=1 
replace heloc = heloc2 if (x1108 +x1119 + x1130)<1

generate mrthel = mrthel1 if (x1108 +x1119 + x1130)>=1 
replace mrthel = mrthel2 if (x1108 +x1119 + x1130)<1

generate nh_mort = mrthel - heloc

label variable nh_mort "Housing Debt"

label variable mrthel "Value of all Home Secured Debt"

drop newvar newvar2 heloc1 newvar3 newvar4 mrthel1 heloc2 mrthel2
 
 
						//Home Equity Value//
				
generate home_equity = houses - mrthel

label variable home_equity "Value of Home Equity"

                            //Have Principal Residence Debt//

generate have_principal_residence_debt = 0
replace have_principal_residence_debt = 1 if mrthel>0 | heloc>0 | nh_mort>0

label define have_principal_residence_debt  1 "Yes" 0 "No" 

label values  have_principal_residence_debt have_principal_residence_debt 

label variable have_principal_residence_debt  "Do you have any Principal Residence Debt?"

  
                    //Have Principal Residence Debt by Type//
					 
                        //First-Lien (Primary) Mortgage//

generate first_lien_mortgage = 0

replace first_lien_mortgage = 1 if x805>0

label define first_lien_mortgage  1 "Yes" 0 "No" 

label values  first_lien_mortgage first_lien_mortgage

label variable first_lien_mortgage  "Do you have First-Lien (Primary) Mortgage?"
  
                          //Second/Third Mortgage//
							
generate second_mortgage = 0

replace second_mortgage = 1 if ((x905+x1005)>0)

label define second_mortgage 1 "Yes" 0 "No" 

label values  second_mortgage second_mortgage

label variable second_mortgage  "Did you ever extract equity from Refinancing?"
  
  
  //Note: Some of the Residence Variables are not available for year 1992//
  
  
  ***********************break**************
  
  
  
                    //Other Lines of Credit//
						  
generate othloc1 = 	x1108*(x1103~=1)+ x1119*(x1114~=1)+ x1130*(x1125~=1) ///
 + max(0, x1136)*(x1108*(x1103~=1)+ x1119*(x1114~=1) ///
 + x1130*(x1125~=1))/(x1108+x1119+x1130)					  
          
generate othloc2 = ((houses<=0)+.5*(houses>0))*(max(0, x1136))
	  
generate othloc = othloc1 if (x1108 +x1119 + x1130)>=1 
replace othloc = othloc2 if (x1108 +x1119 + x1130)<1

label variable othloc "Other Lines of Credit"

drop othloc1 othloc2


                    //Have Other Lines of Credit//

generate have_other_loc = 0
replace have_other_loc = 1 if othloc > 0

label define have_other_loc  1 "Yes" 0 "No" 

label values  have_other_loc have_other_loc

label variable have_other_loc  "Do you have Other Lines of Credit?"

  
                //Debt for Other Residential Property//
					
  generate mortgage1 = x1715*(x1705/10000) if x1703==12 |  x1703==14 |  x1703==21 | ///
   x1703==22 |  x1703==25 |  x1703==40 |  x1703==41 |  x1703==42 |  x1703==43 | ///
    x1703==44 |  x1703==49 |  x1703==50 |  x1703==52 |  x1703==999 
  
 recode mortgage1 (mis=0)

 generate mortgage2 = x1815*(x1805/10000) if x1803==12 |  x1803==14 |  x1803==21 | ///
   x1803==22 |  x1803==25 |  x1803==40 |  x1803==41 |  x1803==42 |  x1803==43 | ///
    x1803==44 |  x1803==49 |  x1803==50 |  x1803==52 |  x1803==999 
  
 recode mortgage2 (mis=0)

 generate mortgage3 = x1915*(x1905/10000) if x1903==12 |  x1903==14 |  x1903==21 | ///
   x1903==22 |  x1903==25 |  x1903==40 |  x1903==41 |  x1903==42 |  x1903==43 | ///
    x1903==44 |  x1903==49 |  x1903==50 |  x1903==52 |  x1903==999 
  
 recode mortgage3 (mis=0)

  
generate other_residential_debt = x1417+x1517+x1617+x1621+mortgage1+mortgage2+mortgage3+x2006

replace other_residential_debt = (other_residential_debt + x2723*(x2710==78)+x2740*(x2727==78) /// 
       +x2823*(x2810==78)+x2840*(x2827==78)+x2923*(x2910==78) ///
	   +x2940*(x2927==78)) if (non_res_real_estate==0 & other_residential_real_estate>0)
 
replace other_residential_debt = other_residential_debt + x2723*(x2710==67)+x2740*(x2727==67) /// 
       +x2823*(x2810==67)+x2840*(x2827==67)+x2923*(x2910==67)+x2940*(x2927==67) ///
	   if other_residential_real_estate>0

label variable other_residential_debt "Debt for Other Residential Property"


                             //Have Other Residential Debt//

generate have_other_residential_debt = 0
replace have_other_residential_debt = 1 if other_residential_debt > 0

label define have_other_residential_debt  1 "Yes" 0 "No" 

label values have_other_residential_debt have_other_residential_debt

label variable have_other_residential_debt  "Do you have Other Residential Debt?" 


                    //Credit Card Debt (Credit Card Balance)//
							  
generate credit_card_balance = max(0, x427)+max(0, x413)+max(0, x421) ///
 +max(0, x430)+max(0, x424)+max(0, x7575)
 
label variable credit_card_balance "Credit Card Balance"
 
                 //Have a Credit Card Balance (Credit Card Debt)//

generate have_credit_card_balance = 0
replace have_credit_card_balance = 1 if credit_card_balance > 0

label define have_credit_card_balance  1 "Yes" 0 "No" 

label values have_credit_card_balance have_credit_card_balance

label variable have_credit_card_balance  "Do you have Credit Card Balance?" 
                    
					//Credit Card Payments//
						
generate credit_card_payments = .025*credit_card_balance

label variable credit_card_payments "Credit Card Payments"

                        //FLAG Variables//

generate FLAG781 = 0
replace FLAG781 = 1 if non_res_real_estate~=0

generate FLAG782 = 0
replace FLAG782 = 1 if (FLAG781~=1 & other_residential_real_estate>0)

generate FLAG67 = 0
replace FLAG67= 1 if other_residential_real_estate>0


 //Installment Loans (can be further separated into vehicle loands, education loans//
	                  //  and other installment loans)//
										 		
generate install = x2218+x2318+x2418+x2424+x2519+x2619+x2625 ///
  +x7824+x7847+x7870+x7924+x7947+x7970+x1044+x1215+x1219
  
replace install = install + x2723*(x2710==78)+x2740*(x2727==78) ///
 +x2823*(x2810==78)+x2840*(x2827==78)+x2923*(x2910==78) ///
 +x2940*(x2927==78) if (FLAG781==0 & FLAG782==0)
 
 replace install = install+x2723*(x2710==67)+x2740*(x2727==67) /// 
 + x2823*(x2810==67)+x2840*(x2827==67)+x2923*(x2910==67) ///
 + x2940*(x2927==67) if (FLAG67==0)
 
replace install = install + x2723*(x2710~=67 | x2710~=78) /// 
+x2740*(x2727~=67 | x2727~=78)+x2823*(x2810~=67 | x2810~=78) /// 
+x2840*(x2827~=67 | x2827~=78)+x2923*(x2910~=67 | x2910~=78) ///
+x2940*(x2927~=67 | x2927~=78)

label variable install "Installment Debt"

         //Have Any Installment Debt//

generate have_installment_debt = 0
replace have_installment_debt = 1 if install > 0

label define have_installment_debt  1 "Yes" 0 "No" 

label values have_installment_debt have_installment_debt

label variable have_installment_debt  "Do you have any Installment Debt?" 

			
		    	//Margin Loans//
				
generate margin_loans = max(0, x3932)
label variable margin_loans "Margin Loans"

            
			//Pension Loans not Reported Earlier//
				
generate pension_loan_1 = max(0,x4229)*(x4230==5)
generate pension_loan_2 = max(0,x4329)*(x4330==5)
generate pension_loan_3 = max(0,x4429)*(x4430==5)
generate pension_loan_4 = max(0,x4829)*(x4830==5)
generate pension_loan_5 = max(0,x4929)*(x4930==5)
generate pension_loan_6 = max(0,x5029)*(x5030==5)


                  //Other Debts (Combines loans against pensions, //
			 // loans against life insurance, margin loans, miscellaneous)// 
			 
generate other_loan_debt = 0
replace other_loan_debt = pension_loan_1 + pension_loan_2 + pension_loan_3 ///
+ pension_loan_4 + pension_loan_5 + pension_loan_6 + max(0, x4010) ///
+ max(0, x4032) + margin_loans

label variable other_loan_debt "Other Debts"


              //Have Other Debt (similar to the "other_debt" variable //
           // but also includes additional loan debts not recorded there//

generate have_other_loan_debt = 0
replace have_other_loan_debt = 1 if other_loan_debt > 0

label define have_other_loan_debt  1 "Yes" 0 "No" 

label values have_other_loan_debt have_other_loan_debt

label variable have_other_loan_debt  "Do you have any Other Debt?" 


                             //TOTAL DEBT//
						
generate TOTAL_DEBT = mrthel + other_residential_debt + othloc ///
+ credit_card_balance + install + other_loan_debt
recode TOTAL_DEBT (mis=0)

label variable TOTAL_DEBT "Total Debt"

                          //Have ANY DEBT//
						  
generate HAVE_ANY_DEBT = 0 
replace HAVE_ANY_DEBT = 1 if TOTAL_DEBT > 0

label define HAVE_ANY_DEBT  1 "Yes" 0 "No" 

label values HAVE_ANY_DEBT HAVE_ANY_DEBT

label variable HAVE_ANY_DEBT  "Do you have any Debt?" 


        	//NET WORTH (Total)//
		
generate NET_WORTH = TOTAL_ASSETS - TOTAL_DEBT
label variable NET_WORTH "Net Worth (Total)"


   //Percentile of Net Worth Variable//
							 
sort NET_WORTH, stable

generate net_worth_percentile = 1 in 1/3644
replace net_worth_percentile = 2 in 3645/7108
replace net_worth_percentile = 3 in 7109/10421
replace net_worth_percentile = 4 in 10422/12891
replace net_worth_percentile = 5 in 12892/19530

label define net_worth_percentile 1 "Less than 25" 2 "25-49.9" 3 "50-74.9" 4 "75-89.9" 5 "90-100" 

label values net_worth_percentile net_worth_percentile

label variable net_worth_percentile "Percentile of Net Worth"

*****************************************************************************
*Capital Gains
*****************************************************************************

                      //Principal Residence Capital Gains//
					
generate kghouse = max(x513, x526, x604, x614, x623, x716) ///
- max(x607, x617, x627+x631, x635, x717) - x1202

label variable kghouse "Principal Residence Capital Gains"
					   
					   
                    //Other Real Estate Capital Gains//
						
generate kgore = (x1705/10000)*(x1706 - x1709)+(x1805/10000)*(x1806 - x1809) ///
 +(x1905/10000)*(x1906 - x1909)

label variable kgore "Other Real Estate Capital Gains"					   


                       //Businesses Capital Gains//
						 
generate kgbus = (x3129-x3130)+(x3229-x3230)+(x3329-x3330)+(x3408-x3409) ///
 +(x3412-x3413)+(x3416-x3417)+(x3420-x3421)+(x3424-x3425)+(x3428-x3429)

label variable kgbus "Businesses Capital Gains"


              //Adjustment for capital gains on farm businesses// 
				
generate farmbus_kg = 0
replace farmbus_kg = ((x507/10000)*kghouse) if x507>0

replace kghouse = (kghouse - farmbus_kg) if x507>0

replace kgbus = (kgbus + farmbus_kg) if x507>0


                 //Stocks And Mutual Funds Capital Gains//
			  
generate kgstmf = (x3918-x3920)+(x3833-x3835)

label variable kgstmf "Stocks and Mutual Funds Capital Gains"


                //Total Capital Gains/Losses//

generate kgtotal = kghouse + kgore + kgbus + kgstmf 

label variable kgtotal "Total Capital Gains/Losses"

				
                //Have Capital Gains/Losses//
						  
generate have_capital_gains = 0 
replace have_capital_gains = 1 if kgtotal ~= 0

label define have_capital_gains  1 "Yes" 0 "No" 

label values have_capital_gains have_capital_gains

label variable have_capital_gains  "Do you have any Capital Gains/Losses?"       


             //Value of Equity (Stocks + Mutual Funds)//
			
generate equity = stocks + mutual_funds
label variable equity "Value of Equity (Stocks + Mutual Funds)"

                          //Have Equity//

generate have_equity = 0
replace have_equity = 1 if equity~=0

label define have_equity 1 "Yes" 0 "No" 

label values have_equity have_equity

label variable have_equity "Do you have Equity (Stocks + Mutual Funds)?"	



                  //Defined Contribution//				   				   			
              
generate defined_contribution = max(0, x4226)*(x4203==2 | x4203==3) ///
		+ max(0, x4326)*(x4303==2 | x4303==3) ///
		+ max(0, x4426)*(x4403==2 | x4403==3) ///
		+ max(0, x4826)*(x4803==2 | x4803==3) ///
		+ max(0, x4926)*(x4903==2 | x4903==3) ///
		+ max(0, x5026)*(x5003==2 | x5003==3) ///
		 

                            
              
generate bonds2 = bonds + savings_bonds
generate transaction_account_cds = liquid_accounts + cds
generate other_finassets2 = life_insurance_cash_value + other_managed_assets + other_financial_assets

			  
//Have Income//
							
							
generate have_income = 0

replace have_income = 1 if income~=0  

label define have_income 1 "Yes" 0 "No" 

label values have_income have_income

label variable have_income "Do you have any Income?"
		
		
		//Have Net Worth//
							
							
generate have_net_worth = 0

replace have_net_worth = 1 if NET_WORTH~=0  

label define have_net_worth 1 "Yes" 0 "No" 

label values have_net_worth have_net_worth

label variable have_net_worth "Do you have any Net Worth?"



