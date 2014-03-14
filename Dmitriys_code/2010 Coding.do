



                 //Create an ID variable to match the initial order//
			
gen id = _n			

                     //Year of the Survey//
					 

				
                       //Frequency Weights (Already generated in SCF 2007//
					   
generate frequencyweight = X42001/5			
label var frequencyweight fwt 		   
generate frequency_weight_round = round(frequencyweight)				   


**************************************************************************
*Demographic Information
**************************************************************************
						   
						//Creating the "Age of Head" Variable//  
gen age = X14

recode age 0/34 = 1 35/44=2 45/54=3 55/64=4 65/74=5 75/max=6

label define age 1 "Less than 35" 2 "35-44" 3 "45-54" 4 "55-64" 5 "65-74" 6 "75 or more"

label values age age

label variable age "Age of head (years)"


                         //Another Separation of the "Age of Head" variable//
						 
generate age2 = X14

recode age2 0/24 = 1 25/34 = 2 35/44=3 45/54=4 55/64=5 65/74=6 75/max=7

label define age2 1 "Less than 25" 2 "25-34" 3 "35-44" 4 "45-54" 5 "55-64" 6 "65-74" 7 "75 or more"

label values age2 age2

label variable age2 "Age of head"  


                         //Third Separation of Age - by 3-year increments//
generate age3 = X14
recode age3 0/24 = 1 25/27 = 2 28/30 = 3 31/33 = 4 34/36 = 5 37/39 = 6 ///
           40/42 = 7 43/45 = 8 46/48 = 9 49/51 = 10 52/54 = 11 55/57 = 12 58/60 = 13 ///
           61/63 = 14 64/66 = 15 67/69 = 16 70/max = 17
		   
label define age3 1 "Less than 25" 2 "25-27" 3 "28-30" 4 "31-33" 5 "34-36" 6 "37-39" ///
                  7 "40-42" 8 "43-45" 9 "46-48" 10 "49-51" 11 "52-54" 12 "55-57" ///
				  13 "58-60" 14 "61-63" 15 "64-66" 16 "67-69" 17 "70 and older"

label values age3 age3

label variable age3 "Age of head (3-year increments)" 		   
		   
		   
		   //Fourth Separation of Age - Includes only 4 cohorts//
		   
gen age4 = X14

recode age4 0/34 = 1 35/44=2 45/54=3 55/max=4

label define age4 1 "Less than 35" 2 "35-44" 3 "45-54" 4 "55 or more"

label values age4 age4

label variable age4 "Age of head (years)"

order age4, after(age3)
		   
		   
		     //Fifth Separation of Age - cohorts separated by 5-year increments//

generate age5 = X14
recode age5 0/24 = 1 25/29 = 2 30/34 = 3 35/39 = 4 40/44 = 5 45/49 = 6 ///
           50/54 = 7 55/59 = 8 60/64 = 9 65/69 = 10 70/74 = 11 75/max = 12 
		   
label define age5 1 "Less than 25" 2 "25-29" 3 "30-34" 4 "35-39" 5 "40-44" 6 "45-49" ///
                  7 "50-54" 8 "55-59" 9 "60-64" 10 "65-69" 11 "70-74" 12 "75 and older"

label values age5 age5

label variable age5 "Age of head (5-year increments)" 		
		   
		   
                           //Summarized total income by age//

// by age, sort: summarize X5729 [weight= frequencyweight] , detail (not used in coding, just to test if it works)

                    //Creating the "Education of Head" Variable//
						   
gen college = 4 if X5904==1
replace college =3 if X5901>=13 & X5904==5
replace college =2 if X5901<=12 & X5902==1
replace college = 2 if X5901<=12 & X5902==2
replace college = 1 if college==.

rename college education 
label define education 1 "No High School Diploma" 2 "High School Diploma" 3 "Some College" 4 "College Degree" 

label values education education

label variable education  "Education of Head"

                      //Creating the "Marital Status of Head" Variable//

 gen marital_status =X8023
replace marital_status = 2 if X8023!=1 | X8023!=2 //(every variable in marital_status becomes 2)
replace marital_status = 1 if X8023==1 | X8023==2 //(married or living together people are coded as 1)

label define marital_status 1 "Married/Living with Partner" 2 "Neither Married nor Living with Partner"
label values marital_status marital_status
label variable marital_status "Marital Status of Head"


                  //Creating "Labor Force Participation of Head" Variable//

gen labor_force_particip =1
replace labor_force_particip = 0 if ((X4100>=50 & X4100<=80) | X4100==97)

label define labor_force_particip 1 "Working in some way" 0 "Not Working at all"
label values labor_force_particip labor_force_particip
label variable labor_force_particip "Labor Force Participation of Head"


                           //Children Variable// (Note: this variable would slightly differ from the one in the 
						  //  SCF because "Foster Children" variable is not included in the public dataset) //

gen children = 0
replace children =1 if (X108==4 | X114==4 | X120==4 | X126==4 |X132==4 |X202==4 |X208==4 |X214==4 |X220==4 | X226==4)

label define children 1 "Yes" 0 "No"
label values children children
label variable children "Children living in the Household"

                            //Family Structure//
							
gen family_structure = 0
replace family_structure = 1 if  marital_status ==2 & children==1
replace family_structure = 2 if marital_status ==2 & children==0 & age<=3
replace family_structure = 3 if marital_status ==2 & children==0 & age>3
replace family_structure = 4 if marital_status ==1 & children==1
replace family_structure = 5 if marital_status ==1 & children==0

label define family_structure 1 "Single with child(ren)" 2 "Single, no child, age less than 55" 3 "Single, no child, age 55 or more" 4 "Couple with child(ren)" 5 "Couple, no child"
label values family_structure family_structure
label variable family_structure "Family Structure"



                             
							            //"Race" Variable//
										
gen race = X6809
replace race = 1 if X6809==1
replace race = 2 if X6809~=1
replace race =2 if X7004==1
label define race 1 "White non-Hispanic" 2 "Nonwhite or Hispanic"

label values race race

label variable race "Race or Ethnicity of Respondent"



                                     //Current Work Status Variable//
									 
generate work_status = 0
replace work_status = 1 if X4106==1
replace work_status = 2 if X4106==2 | X4106==3 | X4106==4
replace work_status = 3 if X4100==50 | X4100==52
replace work_status = 3 if X4100==21 & X14>=65 | X4100==23  & X14>=65 | X4100==30 & X14>=65 | X4100==70 & X14>=65 | X4100==80 & X14>=65 | X4100==97 & X14>=65 | X4100==85 & X14>=65 | X4100== -7 & X14>=65
replace work_status = 4 if work_status==0 & X14<65

label define work_status 1 "Working for someone else" 2 "Self-Employed" 3 "Retired" 4 "Other Not Working" 

label values work_status work_status

label variable work_status "Current Work Status of Head"


                                   //Housing Status Variable//


generate housing_status = 2
replace housing_status = 1 if X508==1 | X508==2 | X601==1 | X601==2 | X601==3 | X701==1 | X701==3 | X701==4 | X701==5 | X701==6 | X701==8 | X701==-7 & X7133==1								   
					
label define housing_status 1 "Owner" 2 "Renter or other" 

label values housing_status housing_status

label variable housing_status "Housing Status"

  
  
                           //Current Occupation of head//
						   
generate occupation = 0
replace occupation =1 if X7401==1
replace occupation =2 if X7401==2 | X7401==3
replace occupation =3 if X7401==4 | X7401==5 | X7401==6
replace occupation =4 if X7401==0

label define occupation 1 "Managerial or professional" 2 "Technical, sales, or services" 3 "Other occupation" 4 "Retired or other not working" 

label values occupation occupation

label variable occupation "Current occupation of head"


                              //Reasons for Saving//

generate saving_reason = 0 

replace saving_reason = 1 if (X3006==-2 | X3006==-1)

replace saving_reason = 2 if (X3006==1 | X3006==2)

replace saving_reason = 3 if (X3006==3 | X3006==5 | X3006==6)

replace saving_reason = 4 if (X3006==11)

replace saving_reason = 5 if (X3006==12 | X3006==13 ///
 | X3006==14 | X3006==15 | X3006==16 | X3006==27 | X3006==29 | X3006==30 ///
 | X3006==9 | X3006==18 | X3006==20 | X3006==41)

replace saving_reason = 6 if (X3006==17 | X3006==22)

replace saving_reason = 7 if (X3006==23 | X3006==24 | X3006==25 ///
                            | X3006==32 | X3006==92 | X3006==93)
							
replace saving_reason = 8 if (X3006==21 | X3006==26 | X3006==28)

replace saving_reason = 9 if (X3006==31 | X3006==33 | X3006==40 ///
                            | X3006==90 | X3006==91 | X3006==-7)
							
label define saving_reason 1 "Can't Save" 2 "Education" 3 "Family" ///
    4 "Home" 5 "Purchases" 6 "Retirement" 7 "Liquidity/Future" ///
    8 "Investment" 9 "No Particular Reason"  

 label values saving_reason saving_reason
label variable saving_reason "Reasons for Saving"							



* "Urbanicity" and "Census Region" are not included in the public dataset

**********************************************************************
*Financial Info
**********************************************************************

                           //Income (3-Step Process)//
						   
		   //1) Convert retirement withdrawals into yearly frequency//

generate newX6464 = X6464
replace newX6464 = newX6464 * 12 if X6465 == 4
replace newX6464 = 0 if newX6464<0

generate newX6469 = X6469
replace newX6469 = newX6469 * 12 if X6470 == 4
replace newX6469 = 0 if newX6469<0

generate newX6474 = X6474
replace newX6474 = newX6474 * 12 if X6475 == 4
replace newX6474 = 0 if newX6474<0

generate newX6479 = X6479
replace newX6479 = newX6479 * 12 if X6480 == 4
replace newX6479 = 0 if newX6479<0


generate newX6965 = X6965
replace newX6965 = newX6965 * 12 if X6966 == 4
replace newX6965 = newX6965 * 4 if X6966 == 5 //conversion of quarterly observations //
replace newX6965 = 0 if newX6965<0

generate newX6971 = X6971
replace newX6971 = newX6971 * 12 if X6972 == 4
replace newX6971 = 0 if newX6971<0

generate newX6977 = X6977
replace newX6977 = newX6977 * 12 if X6978 == 4
replace newX6977 = 0 if newX6977<0

generate newX6983 = X6983
replace newX6983 = newX6983 * 12 if X6984 == 4
replace newX6983 = 0 if newX6983<0


         //2) Generate Retirement Withdrawals variable//

generate retirement = 0
foreach x of varlist X6558 X6566 X6574 newX6464- newX6983 {
replace retirement = retirement + `x' if `x'>0
}

       //3) Create an income variable by combining income and Retirement withdrawals//
generate income = X5729 
replace income = 0 if income<0
replace income = income + retirement
drop newX6464- newX6983
label variable income "Income"
label variable retirement "Retirement Accounts Withdrawal"
rename retirement retirement_withdrawal


                          //Income Components//
		                     //Wage Income//
							 
generate wage_income = X5702
label variable wage_income "Income from Wages"

                    //Interest/Dividend Income//
					
generate interest_dividend_income = X5706 + X5708 + X5710
label variable interest_dividend_income "Income from Interests/Dividends"

                    //Business, Farm, Self-Employment Income//
					
generate business_farm_income = X5704 + X5714
label variable business_farm_income "Business/Farm Income"

                        //Capital Gains Income//
						
generate capital_gains_income = X5712						
label variabl capital_gains_income "Income from Capital Gains"

              //Social Security/Retirement Income//
			  
generate ss_retirement_income = X5722
replace ss_retirement_income = ss_retirement_income + retirement
label variable ss_retirement_income "Social Security/Retirement Income"			  						   

	 			   //Transfers or Other Income//

generate transfer_other_income = X5716 + X5718 + X5720 + X5724
label variable transfer_other_income "Transfer or Other Income"	
		
		                 //Components Combined//
generate income_components = X5702 + X5704+X5714 +X5706+X5708+X5710 +X5712+X5722 ///
                    + X5716+X5718+X5720+X5724
					
						  
			     //Normal Year Income Variable//
generate normal_income = X5729
replace normal_income =X7362 if X7650~=3



                               //"Percentile of Income" Variable//


sort income normal_income, stable
xtile income2 = income, nq(6)
label define income2 1 "Less than 20" 2 "20-39.9" 3 "40-59.9" 4 "60-79.9" 5 "80-89.9"  6 "90-100"

label values income2 income2

label variable income2 "Percentile of Income"
rename income2 income_percentile


                             //Families that Save//
					

generate saving = X7510
replace saving = X7508 if X7508>0
replace saving = 3 if X7510==2 & X7509==1
replace saving = 1 if saving==2

label define saving 1 "Don't Save" 3 "Save" 

label values saving saving

label variable saving "Did your family save?"

rename saving family_saving


                               //Savings Account//

generate savings_account =  max(0,X3730*(X3732 ~= (4 30))) ///
        +max(0,X3736*(X3738 ~= (4 30))) ///
        +max(0,X3742*(X3744~= (4 30)))+max(0,X3748*(X3750~= (4 30))) ///
        +max(0,X3754*(X3756~= (4 30)))+max(0,X3760*(X3762 ~= (4 30))) ///
        +max(0,X3765)

label variable savings_account "Value of Savings Accounts"
                          

						    //Do you have a Savings Account//
						  
 
generate have_savings = 0

replace have_savings = 1 if savings_account~=0   

label define have_savings 1 "Yes" 0 "No" 

label values have_savings have_savings

label variable have_savings "Do you have any Savings or Money Market Accounts?"


                              //Checking account//
							  
							  
generate checking = max(0,X3506)*(X3507==5)+max(0,X3510)*(X3511==5) ///
      +max(0,X3514)*(X3515==5)+max(0,X3518)*(X3519==5) ///
	  +max(0,X3522)*(X3523==5)+max(0,X3526)*(X3527==5) ///	 
      +max(0,X3529)*(X3527==5) 

label variable checking "Value of a Checking Account"


                    //Do you have a Checking Account//
						  
generate have_checking = 0  

replace have_checking = 1 if checking ~=0

label define have_checking 1 "Yes" 0 "No" 

label values have_checking have_checking

label variable have_checking "Do you have a Checking Account?"


                //Reason for Choosing Main Checking Account//

generate checking_account_reason = 10 

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

label values checking_account_reason checking_account_reason

label variable checking_account_reason "Reason For Choosing Main Checking Account"							       
			
			
			                //Money Owed//
					   
					   
generate owed_any_money = X4017   

label define owed_any_money 1 "Yes" 5 "No" 

label values owed_any_money owed_any_money

label variable owed_any_money "Are you owed any money by friends, relatives, or others?"
					   
		
		                 //Other Substantial Assets//
						 
generate miscellaneous_assets = X4019  

label define miscellaneous_assets 1 "Yes" 5 "No" 

label values miscellaneous_assets miscellaneous_assets

label variable miscellaneous_assets "Do you own any other Miscellaneous Assets?"


                         //Amount of Miscellaneous Assets combined (both "Money Owed" and "Other Substantial Assets")	 
						 
generate other_asset = X4018 + X4022 + X4026 + X4030

label variable other_asset "Miscellaneous Asset Amount"		


                             //Other Debt//
							 
generate other_debt = X4031  

label define other_debt 1 "Yes" 5 "No" 

label values other_debt other_debt

label variable other_debt "Do you owe any money not recorded earlier?"
                           

 
                       // //Money Market Accounts// //
						    
					 //Money Market Deposit Accounts//
 
 
generate mmda = max(0,X3506)*((X3507==1)*(11<=X9113<=13)) ///
        +max(0,X3510)*((X3511==1)*(11<=X9114<=13)) ///
        +max(0,X3514)*((X3515==1)*(11<=X9115<=13)) ///
        +max(0,X3518)*((X3519==1)*(11<=X9116<=13)) ///
        +max(0,X3522)*((X3523==1)*(11<=X9117<=13)) ///
        +max(0,X3526)*((X3527==1)*(11<=X9118<=13)) ///
        +max(0,X3529)*((X3527==1)*(11<=X9118<=13)) ///
        +max(0,X3730*(X3732 == (4 30))*(X9259>=11 & X9259<=13)) ///
        +max(0,X3736*(X3738 == (4 30))*(X9260>=11 & X9260<=13)) ///		
        +max(0,X3742*(X3744 == (4 30))*(X9261>=11 & X9261<=13)) ///
        +max(0,X3748*(X3750 == (4 30))*(X9262>=11 & X9262<=13)) ///
        +max(0,X3754*(X3756 == (4 30))*(X9263>=11 & X9263<=13)) ///
        +max(0,X3760*(X3762 == (4 30))*(X9264>=11 & X9264<=13)) 

label variable mmda "Money Market Deposit Accounts"

         				 //Money Market Mutual Funds//
						 
generate mmmf = max(0,X3506)*((X3507==1)*(X9113<11 | X9113>13)) ///
        +max(0,X3510)*((X3511==1)*(X9114<11 | X9114>13)) ///
        +max(0,X3514)*((X3515==1)*(X9115<11 | X9115>13)) ///
        +max(0,X3518)*((X3519==1)*(X9116<11 | X9116>13)) ///
        +max(0,X3522)*((X3523==1)*(X9117<11 | X9117>13)) ///
        +max(0,X3526)*((X3527==1)*(X9118<11 | X9118>13)) ///
        +max(0,X3529)*((X3527==1)*(X9118<11 | X9118>13)) ///
        +max(0,X3730*(X3732 == (4 30))*(X9259<11 | X9259>13)) ///
        +max(0,X3736*(X3738 == (4 30))*(X9260<11 | X9260>13)) ///
        +max(0,X3742*(X3744 == (4 30))*(X9261<11 | X9261>13)) ///
        +max(0,X3748*(X3750 == (4 30))*(X9262<11 | X9262>13)) ///
        +max(0,X3754*(X3756 == (4 30))*(X9263<11 | X9263>13)) ///
        +max(0,X3760*(X3762 == (4 30))*(X9264<11 | X9264>13)) 

label variable mmmf "Money Market Mutual Funds"		
 
                          //Combined Money Market Account Value//
						 				 
generate mma = mmda + mmmf

label variable mma "Value of a Money Market Account"
                                   
               
			                    
			               //Value of a Brokerage Account//
						  
generate brokerage = max(0, X3930)
label variable brokerage "Value of a Brokerage Account"

                             //Have Brokerage Account//
							

generate have_brokerage_account = X3923   

label define have_brokerage_account 1 "Yes" 5 "No" 

label values have_brokerage_account have_brokerage_account

label variable have_brokerage_account "Do you have a brokerage account?"


                                //Trading in the Past Year//
								
generate trading_past_year = 1 if X3928>0
recode trading (mis=0)

label define trading_past_year 1 "Yes" 0 "No" 

label values trading_past_year trading_past_year

label variable trading_past_year "Have you traded in the past year?"
								

                   //All Types of Transaction Accounts (Liquid Assets)//

				   
generate liquid_accounts = 0
replace liquid_accounts = mma+ brokerage+checking+ savings_account

label variable liquid_accounts "Total Value of Transaction Accounts (Liquid Assets)"			   
		
		
generate have_liquid_accounts = 0
replace have_liquid_accounts = 1 if liquid_accounts~=0  | X3501==1 | X3727==1 | X3929==1 

label define have_liquid_accounts 1 "Yes" 0 "No" 

label values have_liquid_accounts have_liquid_accounts

label variable have_liquid_accounts "Do you have any type of a Transaction Account?"

replace liquid_accounts = max(have_liquid_accounts, liquid_accounts) //Includes accounts with zero balance - they are labeled as 1//


                             //Certificates of Deposit//

generate cds =  max(0, X3721)
label variable cds "Value of Certificates of Deposit"							  
							  
					     //Have Certificates of Deposits//     

generate have_cd = X3719   

label define have_cd 1 "Yes" 5 "No" 

label values have_cd have_cd

label variable have_cd "Do you have any Certificates of Deposits?"

							  
							 //Value of Mutual Funds// 
							

generate stock_mutual_funds = max(0, X3822) if X3821==1
recode stock_mutual_funds (mis=0)

generate taxfree_bond_mutual_funds = max(0, X3824) if X3823==1
recode taxfree_bond_mutual_funds (mis=0)

generate govt_bond_mutual_funds = max(0, X3826) if X3825==1
recode govt_bond_mutual_funds (mis=0)

generate other_bond_mutual_funds = max(0, X3828) if X3827==1
recode other_bond_mutual_funds (mis=0)

generate combination_mutual_funds = max(0, X3830) if X3829==1
recode combination_mutual_funds (mis=0)

generate other_mutual_funds = max(0, X7787) if X7785==1
recode other_mutual_funds (mis=0)

generate mutual_funds = stock_mutual_funds + taxfree_bond_mutual_funds + govt_bond_mutual_funds + other_bond_mutual_funds + combination_mutual_funds + other_mutual_funds

label variable mutual_funds "Total Value of Mutual Funds"

                                  //Mutual Funds//
																
generate have_mutual_funds = 0

replace have_mutual_funds = 1 if mutual_funds~=0  

label define have_mutual_funds 1 "Yes" 0 "No" 

label values have_mutual_funds have_mutual_funds

label variable have_mutual_funds "Do you have any Mutual Funds or Hedge Funds?"


                    //Value of Stocks (and the number of Companies)//

generate stocks = max(0, X3915)

label variable stocks "Total Value of Stocks"

generate n_stocks = X3914

label variable n_stocks "Number of Companies in which Hold Stock"
					

                          //Have Publicly Traded Stock//										 
										 
generate have_public_stock = X3913   

label define have_public_stock 1 "Yes" 5 "No" 

label values have_public_stock have_public_stock

label variable have_public_stock "Do you own any publicly traded stock?"
																				
							  
					  //Value of Bonds (excluding bond funds and savings bonds)//

					  
generate taxexempt_bonds = X3910 
recode taxexempt_bonds (mis=0)
 
generate mortgagebacked_bonds = X3906
recode mortgagebacked_bonds (mis=0)

generate govt_bonds = X3908
recode govt_bonds (mis=0)

generate corporate_and_foreign_bonds = X7634+X7633
recode corporate_and_foreign_bonds (mis=0)

generate bonds = taxexempt_bonds + mortgagebacked_bonds + govt_bonds + corporate_and_foreign_bonds
label variable bonds "Total Value of Bonds"					  
							  
				     //Have Bonds other than savings bonds//
									 
									 
generate have_other_bonds = X3903   

label define have_other_bonds 1 "Yes" 5 "No" 

label values have_other_bonds have_other_bonds

label variable have_other_bonds "Do you have any other corporate, municipal, or government bonds?"


							  //Retirement Account Total//
							  
			     		  //IRA/Keogh Retirement Account//    
						  
generate ira_keogh = X6551+X6559+X6567+X6552+X6560+X6568+X6553+X6561+X6569+X6554+X6562+X6570
label variable ira_keogh "IRA/Keogh Retirement Account"


                              //Have IRA and Keogh Accounts//

generate have_ira_keogh = X3601   

label define have_ira_keogh 1 "Yes" 5 "No" 

label values have_ira_keogh have_ira_keogh

label variable have_ira_keogh "Do you have any IRA or Keogh Account?"

replace have_ira_keogh = 0 if X3601 ==5
label define have_ira_keogh 1 "Yes" 0 "No", replace

                                 //Future Pensions//
								 
generate future_pension = max(0, X5604) + max(0, X5612) + max(0, X5620) + max(0, X5628)
label variable future_pension "Future Pensions"

                                 //Current Pensions//
								 
generate current_pension = X6462+X6467+X6472+X6477+X6957
label variable current_pension "Current Pension Account"                    		  


                                     //Job Pension// 

generate job_pension1 = 0
replace job_pension1 = X11032 if (X11000==1 ///
   | X11001==2 | X11001==3 | X11001==4 | X11001==6 | X11001==20 | X11001==21 ///
   | X11001==22 | X11001==26 | X11025==1 | X11031==1)          
replace job_pension1 = 0 if X11032==-1


generate job_pension2 = 0
replace job_pension2 = X11132 if (X11100==1 ///
   | X11101==2 | X11101==3 | X11101==4 | X11101==6 | X11101==20 | X11101==21 ///
   | X11101==22 | X11101==26 | X11125==1 | X11131==1)          
replace job_pension2 = 0 if X11132==-1

generate job_pension4 = 0
replace job_pension4 = X11332 if (X11300==1 ///
   | X11301==2 | X11301==3 | X11301==4 | X11301==6 | X11301==20 | X11301==21 ///
   | X11301==22 | X11301==26 | X11325==1 | X11331==1)          
replace job_pension4 = 0 if X11332==-1

generate job_pension5 = 0
replace job_pension5 = X11432 if (X11400==1 ///
   | X11401==2 | X11401==3 | X11401==4 | X11401==6 | X11401==20 | X11401==21 ///
   | X11401==22 | X11401==26 | X11425==1 | X11431==1)          
replace job_pension5 = 0 if X11432==-1

generate job_pension = job_pension1 + job_pension2 + job_pension4 ///
                     + job_pension5
					 
label variable job_pension "Pension from the Current Job"					 

                                    //Have Job Pension//
									  
generate have_job_pension = 0   

replace have_job_pension = 1 if job_pension~=0

label define have_job_pension 1 "Yes" 0 "No" 

label values have_job_pension have_job_pension

label variable have_job_pension "Do you have Pension from Current Job?"


                              //Account-type Pension Plans//

generate peneq1 = 0
replace peneq1 = peneq1 + job_pension1*(X11036==1 + (X11036==3)*(X11037/10000) + (X11036==30)*(X11037/10000))

generate peneq2 = 0
replace peneq2 = peneq2 + job_pension2*(X11136==1 + (X11136==3)*(X11137/10000) + (X11136==30)*(X11137/10000))

generate peneq4 = 0
replace peneq4 = peneq4 + job_pension4*(X11336==1 + (X11336==3)*(X11337/10000) + (X11336==30)*(X11337/10000))

generate peneq5 = 0
replace peneq5 = peneq5 + job_pension5*(X11436==1 + (X11436==3)*(X11437/10000) + (X11436==30)*(X11437/10000))

generate peneq = peneq1 + peneq2 + peneq4 + peneq5
                                  
                //Respondent's thrift account is equal to the first 3 job pensions//
				
generate rthrift = job_pension1 + job_pension2

                //Spouse's thrift account is equal to the last 3 job pensions//
				
generate sthrift = job_pension4 + job_pension5
 
                 //Thrift account is equal to the respondent's and spouse's thrift accounts combined //
				                    // (which is also equal to 6 job pensions //
									
generate thrift = rthrift + sthrift

                   //Respondent's equity is equal to the first 3 pension equities//
generate req = peneq1 + peneq2

                       //Spouse equity is equal to the last 3 pension equities//
generate seq = peneq4 + peneq5					

 
                                   //Pension Mopups//                                   
generate pmopup = 0
replace pmopup = X11259 if X11259>0
replace pmopup = X11259 if (X11259>0 & (X11000==1 ///
                                     | X11100==1 ///
	| X11001==2 | X11001==3 | X11001==4 | X11001==6 | X11001==20 | X11001==21 | X11001==22 | X11001==26 ///
	| X11101==2 | X11101==3 | X11101==4 | X11101==6 | X11101==20 | X11101==21 | X11101==22 | X11101==26 ///
	| X11031==1 | X11131==1 | X11025==1 | X11125==1))
	
replace pmopup = 0 if (X11259>0 & X11000~=0 & X11100~=0 & X11031~=0 & X11131~=0)

replace pmopup = X11559 if X11559>0
replace pmopup = X11559 if (X11559>0 & (X11300==1 ///
                                     | X11400==1 ///
	| X11301==2 | X11301==3 | X11301==4 | X11301==6 | X11301==20 | X11301==21 | X11301==22 | X11301==26 ///
	| X11401==2 | X11401==3 | X11401==4 | X11401==6 | X11401==20 | X11401==21 | X11401==22 | X11401==26 ///
	| X11331==1 | X11431==1 | X11325==1 | X11425==1))
	
replace pmopup = 0 if (X11559>0 & X11300~=0 & X11400~=0 & X11331~=0 & X11431~=0)
	
replace thrift = thrift + pmopup if X11259>0
replace thrift = thrift + pmopup if X11559>0

replace peneq = (peneq + pmopup*(req/rthrift)) if req>0 & X11259>0
replace peneq = (peneq + pmopup/2) if req<=0 & X11259>0

replace peneq = (peneq + pmopup*(seq/sthrift)) if seq>0 & X11559>0
replace peneq = (peneq + pmopup/2) if seq<=0 & X11559>0


drop rthrift sthrift req seq 


         //Sum of IRA/Keogh, Thrift, Future Pension, and Current Pension Accounts//
			            			  
generate retirement_account = ira_keogh + thrift + future_pension + current_pension
label variable retirement_account "Total of IRA/Keogh, Thrift, Future Pension, and Current Pension Accounts"

                              //Have Retirement Account//
								  
generate have_retirement_account = 0

replace have_retirement_account = 1 if retirement_account~=0

label define have_retirement_account 1 "Yes" 0 "No" 

label values have_retirement_account have_retirement_account

label variable have_retirement_account "Do you have a Retirement Account?"


                           **        //Pension Plans//         **
								   
								   //Any Pension Plan//
								 
generate any_pension_plan = 1 if X4135==1 | X4735==1 | X5313==1 | X5601==1
recode any_pension_plan (mis=0)

label define any_pension_plan 1 "Yes" 0 "No" 

label values any_pension_plan any_pension_plan

label variable any_pension_plan "Any Type of Pension (either head or spouse)"

rename any_pension_plan have_any_pension_plan


								 //Defined Benefit Plan (Current Job)//      

generate dbplancj = 1 if(X11000==5 & X11001~=30) | X11001==1 | (X11100==5 & X11101~=30)|X11101==1 | (X11300==5 & X11301~=30) | X11301==1 | (X11400==4 & X11401~=30) | X11401==1 | (X5316==1 & X6461==5) | (X5324==1 & X6466==5) | (X5332==1 & X6471==5) | (X5416==1 & X6476==5) 
recode dbplancj (mis=0)

label define dbplancj 1 "Yes" 0 "No" 

label values dbplancj dbplancj

label variable dbplancj "Defined benefit pension on a current job (either head or spouse)"
rename dbplancj  have_dbplancj

                               //Defined Contribution Plan (Current Job)//      

generate dcplancj = 1 if X11032>0 | X11132>0 | X11332>0 | X11432>0 | X11032==-1 | X11132==-1 | X11332==-1 | X11432==-1 | (X5316==1 & X6461==1) | (X5324==1 & X6466==1) | (X5332==1 & X6471==1) | (X5416==1 & X6476==1)

recode dcplancj (mis=0)

label define dcplancj 1 "Yes" 0 "No" 

label values dcplancj dcplancj

label variable dcplancj "Defined contribution pension on a current job (either head or spouse)"
rename dcplancj have_dcplancj


               //Defined Benefit Plan from either the current job or the past job (either head or spouse)//
			   
generate have_dbplan = 1 if have_dbplancj==1 | (X6461==5 | X6466==5 | X6471==5 | X6476==5) | (X5603==1 | X5603==3 | X5611==1 | X5611==3 | X5619==1 | X5619==3 | X5627==1 | X5627==3)
 
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
								 
generate savings_bonds = X3902
label variable savings_bonds "Total Value of Savings Bonds"


                                   //Savings Bonds//
									 
									 
generate have_savings_bonds = X3901   

label define have_savings_bonds 1 "Yes" 5 "No" 

label values have_savings_bonds have_savings_bonds

label variable have_savings_bonds "Do you have any U.S. government savings bonds?"


      //Cash Value of Life Insurance (Note: this does not include term insurance//

generate life_insurance_cash_value = max(0, X4006)
label variable life_insurance_cash_value "Total Cash Value of Life Insurance"


                            //Have Life Insurance//
							
							
generate have_life_insurance = 0

replace have_life_insurance = 1 if life_insurance_cash_value~=0  

label define have_life_insurance 1 "Yes" 0 "No" 

label values have_life_insurance have_life_insurance

label variable have_life_insurance "Do you have any Life Insurance?"



                               //Value of Other Managed Assets//
								  
								   //Annuity Accounts//
generate annuities = max(0, X6577)
label variable annuities "Total Value of Annuities"                                                                        

generate have_annuity = X6815   

label define have_annuity 1 "Yes" 5 "No" 

label values have_annuity have_annuity

label variable have_annuity "Do you have assets in an Annuity Account?"

                      //Trusts/Other Managed Investment Accounts//
generate trusts = max(0, X6587)
label variable trusts "Total Value of Trusts"
					
generate have_trust_mia = X6827   

label define have_trust_mia 1 "Yes" 5 "No" 

label values have_trust_mia have_trust_mia

label variable have_trust_mia "Do you have assets in a Trust or a Managed Investment Account?"					
									
			//Annuities and Trusts/Other Managed Investment Accounts//						
generate other_managed_assets = annuities + trusts
label variable other_managed_assets "Value of Other Managed Assets (Annuities + Trusts)"

                      //Have Other Managed Assets//

generate have_other_managed_assets = 0
replace have_other_managed_assets = 1 if other_managed_assets~=0

label define have_other_managed_assets 1 "Yes" 0 "No" 

label values have_other_managed_assets have_other_managed_assets

label variable have_other_managed_assets "Do you have Annuities, Trusts, or Other Managed Investment Accounts?"	
			  

                         //Value of Other Financial Assets//

 generate other_financial_assets = X4018
 replace other_financial_assets =  other_financial_assets + X4022 if X4020==61
 replace other_financial_assets =  other_financial_assets + X4022 if X4020==62
 replace other_financial_assets =  other_financial_assets + X4022 if X4020==63
 replace other_financial_assets =  other_financial_assets + X4022 if X4020==64
 replace other_financial_assets =  other_financial_assets + X4022 if X4020==65
 replace other_financial_assets =  other_financial_assets + X4022 if X4020==66
 replace other_financial_assets =  other_financial_assets + X4022 if X4020==71
 replace other_financial_assets =  other_financial_assets + X4022 if X4020==72
 replace other_financial_assets =  other_financial_assets + X4022 if X4020==73
 replace other_financial_assets =  other_financial_assets + X4022 if X4020==74
 replace other_financial_assets =  other_financial_assets + X4022 if X4020==77
 replace other_financial_assets =  other_financial_assets + X4022 if X4020==80
 replace other_financial_assets =  other_financial_assets + X4022 if X4020==81
 replace other_financial_assets =  other_financial_assets + X4022 if X4020==-7
 
 replace other_financial_assets =  other_financial_assets + X4026 if X4024==61
 replace other_financial_assets =  other_financial_assets + X4026 if X4024==62
 replace other_financial_assets =  other_financial_assets + X4026 if X4024==63
 replace other_financial_assets =  other_financial_assets + X4026 if X4024==64
 replace other_financial_assets =  other_financial_assets + X4026 if X4024==65
 replace other_financial_assets =  other_financial_assets + X4026 if X4024==66
 replace other_financial_assets =  other_financial_assets + X4026 if X4024==71
 replace other_financial_assets =  other_financial_assets + X4026 if X4024==72
 replace other_financial_assets =  other_financial_assets + X4026 if X4024==73
 replace other_financial_assets =  other_financial_assets + X4026 if X4024==74
 replace other_financial_assets =  other_financial_assets + X4026 if X4024==77
 replace other_financial_assets =  other_financial_assets + X4026 if X4024==80
 replace other_financial_assets =  other_financial_assets + X4026 if X4024==81
 replace other_financial_assets =  other_financial_assets + X4026 if X4024==-7
 
 replace other_financial_assets =  other_financial_assets + X4030 if X4028==61
 replace other_financial_assets =  other_financial_assets + X4030 if X4028==62
 replace other_financial_assets =  other_financial_assets + X4030 if X4028==63
 replace other_financial_assets =  other_financial_assets + X4030 if X4028==64
 replace other_financial_assets =  other_financial_assets + X4030 if X4028==65
 replace other_financial_assets =  other_financial_assets + X4030 if X4028==66
 replace other_financial_assets =  other_financial_assets + X4030 if X4028==71
 replace other_financial_assets =  other_financial_assets + X4030 if X4028==72
 replace other_financial_assets =  other_financial_assets + X4030 if X4028==73
 replace other_financial_assets =  other_financial_assets + X4030 if X4028==74
 replace other_financial_assets =  other_financial_assets + X4030 if X4028==77
 replace other_financial_assets =  other_financial_assets + X4030 if X4028==80
 replace other_financial_assets =  other_financial_assets + X4030 if X4028==81
 replace other_financial_assets =  other_financial_assets + X4030 if X4028==-7

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
						  
						
generate equity_in_stock = stocks+stock_mutual_funds + .5*combination_mutual_funds+ other_mutual_funds + ///
	    (X6551+X6552+X6553+X6554)*((X6555==1)+(X6555==3 | X6555==30)*(max(0,X6556)/10000)) + ///
        (X6559+X6560+X6561+X6562)*((X6563==1)+(X6563==3 | X6563==30)*(max(0,X6564)/10000))+ ///
        (X6567+X6568+X6569+X6570)*((X6571==1)+(X6571==3 | X6571==30)*(max(0,X6572)/10000))+ ///
        annuities*((X6581==1)+(X6581==3 | X6581==30)*(max(0,X6582)/10000))+ ///
        trusts*((X6591==1)+(X6591==3 | X6591==30)*(max(0,X6592)/10000))+peneq+ ///
        (X6461==1)*X6462*((X6933==1)+(X6933==3 | X6933==30)*(max(0,X6934)/10000))+ ///
        (X6466==1)*X6467*((X6937==1)+(X6937==3 | X6937==30)*(max(0,X6938)/10000))+ ///
        (X6471==1)*X6472*((X6941==1)+(X6941==3 | X6941==30)*(max(0,X6942)/10000))+ ///
        (X6476==1)*X6477*((X6945==1)+(X6945==3 | X6945==30)*(max(0,X6946)/10000))+ ///
        X5604*((X6962==1)+(X6962==3 | X6962==30)*(max(0,X6963)/10000))+ ///
        X5612*((X6968==1)+(X6968==3 | X6968==30)*(max(0,X6969)/10000))+ ///
        X5620*((X6974==1)+(X6974==3 | X6974==30)*(max(0,X6975)/10000))+ ///
        X5628*((X6980==1)+(X6980==3 | X6980==30)*(max(0,X6981)/10000))+ ///
        X3730*((X7074==1)+(X7074==3 | X7074==30)*(max(0,X7075)/10000))+ ///
        X3736*((X7077==1)+(X7077==3 | X7077==30)*(max(0,X7078)/10000))+ ///
        X3742*((X7080==1)+(X7080==3 | X7080==30)*(max(0,X7081)/10000))+ ///
        X3748*((X7083==1)+(X7083==3 | X7083==30)*(max(0,X7084)/10000))+ ///
        X3754*((X7086==1)+(X7086==3 | X7086==30)*(max(0,X7087)/10000))+ ///
        X3760*((X7089==1)+(X7089==3 | X7089==30)*(max(0,X7090)/10000))
	 
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
				   
generate reteq=((0+X6551+X6552+X6553+X6554)*((X6555==1) ///
        +(X6555==3 | X6555==30)*(max(0,X6556)/10000))+ ///
        (0+X6559+X6560+X6561+X6562)*((X6563==1) ///
        +(X6563==3 | X6563==30)*(max(0,X6564)/10000))+ ///
        (0+X6567+X6568+X6569+X6570)*((X6571==1) ///
        +(X6571==3 | X6571==30)*(max(0,X6572)/10000)))+ ///
        peneq+(X6461==1)*X6462*((X6933==1)+(X6933==3 | X6933==30)*(max(0,X6934)/10000))+ ///
        (X6466==1)*X6467*((X6937==1)+(X6937==3 | X6937==30)*(max(0,X6938)/10000))+ ///
        (X6471==1)*X6472*((X6941==1)+(X6941==3 | X6941==30)*(max(0,X6942)/10000))+ ///
        (X6476==1)*X6477*((X6945==1)+(X6945==3 | X6945==30)*(max(0,X6946)/10000))+ ///
        X5604*((X6962==1)+(X6962==3 | X6962==30)*(max(0,X6963)/10000))+ ///
        X5612*((X6968==1)+(X6968==3 | X6968==30)*(max(0,X6969)/10000))+ ///
        X5620*((X6974==1)+(X6974==3 | X6974==30)*(max(0,X6975)/10000))+ ///
        X5628*((X6980==1)+(X6980==3 | X6980==30)*(max(0,X6981)/10000))			
		
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
										  
generate vehicles = max(0, X8166) + max(0, X8167) + max(0, X8168) + max(0, X8188) ///
 + max(0, X2422) + max(0, X2506) + max(0, X2606) + max(0, X2623)
  
label variable vehicles "Total Value of Vehicles"
  
 
generate have_vehicles = 1 if vehicles>0

recode have_vehicles (mis=0) 
 
label define have_vehicles 1 "Yes" 0 "No" 

label values have_vehicles have_vehicles

label variable have_vehicles "Do you have any Vehicles?"


       //Value and Number of Owned Vehicles (not leased or supplied by business)//
  
                          //Have an owned vehicle//
generate own_vehicle = 0

replace own_vehicle = 1 if X2201==1

label define own_vehicle 1 "Yes" 0 "No" 

label values own_vehicle  own_vehicle

label variable  own_vehicle "Do you own any Vehicles?"

                           //Number of owned vehicles//

generate number_owned_vehicles = X2202		

label variable number_owned_vehicles "Number of owned vehicles"				  

                          //Value of owned vehicles//
						  
generate value_owned_vehicles = X8166+X8167+X8168+X8188

label variable value_owned_vehicles "Value of owned vehicles"	
 
 
                          //Farm Business//
						
replace X507= 0 if X507==-1
replace X507= 9000 if X507>9000

generate farmbus = 0 

replace farmbus= ((X507/10000) * (X513+X526-X805-X905-X1005)) if X507>0
replace farmbus = (farmbus - X1108*X507/10000) if X1103==1
replace farmbus = (farmbus - X1119*X507/10000) if X1114==1
replace farmbus = (farmbus - X1130*X507/10000) if X1125==1 

label variable farmbus "Value of a Farm Business"
	   

                //Value and number of Houses (Primary Residence)//
									
generate houses = (X604 + X614 + X623 + X716) + ((10000 - max(0, X507))/10000) * (X513 + X526)

label variable houses "Value of Houses (Primary Residence)"
generate have_houses = 0

replace have_houses = 1 if houses>0

label define have_houses 1 "Yes" 0 "No" 

label values have_houses have_houses

label variable have_houses "Do you own any Houses?"


                          //Homeownership Class//
							 
generate homeownership_class = 2
replace homeownership_class = 1 if X508==1 | X508==2 | X601==1 | X601==2 | X601==3 ///
 | X701==1 | X701==3 | X701==4 | X701==5 | X701==6 | X701==8 | (X701==-1 & X7133==1)
 
label define homeownership_class 1 "Owns Ranch/Farm/Mobile Home/House/Condo/Coop/etc" 2 "Otherwise" 

label values homeownership_class homeownership_class

label variable homeownership_class "Homeownership Class"



                      //Other Residential Real Estate//
						  
generate other_residential_real_estate = max(X1405, X1409) + ///
max(X1505, X1509) + max(0, X1619) 


replace other_residential_real_estate = other_residential_real_estate + (max(0, X1706) * (X1705/10000)) if X1703==12 | X1703==14 | X1703==21 ///
 | X1703==22 | X1703==25 | X1703==40 | X1703==41 | X1703==42 | X1703==43 ///
 | X1703==44 | X1703==49 | X1703==50 | X1703==52 | X1703==999

 
replace other_residential_real_estate = other_residential_real_estate + (max(0, X1806) * (X1805/10000)) if X1803==12 | X1803==14 | X1803==21 ///
 | X1803==22 | X1803==25 | X1803==40 | X1803==41 | X1803==42 | X1803==43 ///
 | X1803==44 | X1803==49 | X1803==50 | X1803==52 | X1803==999
  
replace other_residential_real_estate = other_residential_real_estate +  max(0, X2002)

label variable other_residential_real_estate "Value of Other Residential Real Estate"


generate have_other_res_real_estate = 0

replace have_other_res_real_estate  = 1 if other_residential_real_estate~=0

label define have_other_res_real_estate  1 "Yes" 0 "No" 

label values have_other_res_real_estate have_other_res_real_estate 

label variable have_other_res_real_estate  "Do you own any other Residential Real Estate?"



                     //Net Equity in Nonresidential Real Estate//

generate non_res_real_estate = 0

replace non_res_real_estate = non_res_real_estate + (max(0, X1706) * (X1705/10000)) if X1703==1 | X1703==2 ///
| X1703==3 | X1703==4 | X1703==5 | X1703==6 | X1703==7 | X1703==10 | X1703==11 | X1703==13 ///
| X1703==15 | X1703==24 | X1703==45 | X1703==46 | X1703==47 | X1703==48 | X1703==51 ///
| X1703==-7

replace non_res_real_estate = non_res_real_estate + (max(0, X1806) * (X1805/10000)) if X1803==1 | X1803==2 ///
| X1803==3 | X1803==4 | X1803==5 | X1803==6 | X1803==7 | X1803==10 | X1803==11 | X1803==13 ///
| X1803==15 | X1803==24 | X1803==45 | X1803==46 | X1803==47 | X1803==48 | X1803==51 ///
| X1803==-7

replace non_res_real_estate = non_res_real_estate + max(0, X2012)

replace non_res_real_estate = non_res_real_estate - (X1715 * (X1705/10000)) if X1703==1 | X1703==2 ///
| X1703==3 | X1703==4 | X1703==5 | X1703==6 | X1703==7 | X1703==10 | X1703==11 | X1703==13 ///
| X1703==15 | X1703==24 | X1703==45 | X1703==46 | X1703==47 | X1703==48 | X1703==51 ///
| X1703==-7

replace non_res_real_estate = non_res_real_estate - (X1815 * (X1805/10000)) if X1803==1 | X1803==2 ///
| X1803==3 | X1803==4 | X1803==5 | X1803==6 | X1803==7 | X1803==10 | X1803==11 | X1803==13 ///
| X1803==15 | X1803==24 | X1803==45 | X1803==46 | X1803==47 | X1803==48 | X1803==51 ///
| X1803==-7

replace non_res_real_estate = non_res_real_estate - X2016

label variable non_res_real_estate "Net Equity in Nonresidential Real Estate"


 //Installment Loan Correction to non-residential real estate//
 
replace non_res_real_estate = . if non_res_real_estate==0  //eXcluding 0 values from operation//

replace non_res_real_estate = non_res_real_estate - X2723 if (X2710==78) 
replace non_res_real_estate = non_res_real_estate - X2740 if (X2727==78)
replace non_res_real_estate = non_res_real_estate - X2823 if (X2810==78)
replace non_res_real_estate = non_res_real_estate - X2840 if (X2827==78)
replace non_res_real_estate = non_res_real_estate - X2923 if (X2910==78)
replace non_res_real_estate = non_res_real_estate - X2840 if (X2927==78)

replace non_res_real_estate = 0 if non_res_real_estate==.  //including 0 values back//


generate have_non_res_real_estate = 0

replace have_non_res_real_estate  = 1 if non_res_real_estate~=0

label define have_non_res_real_estate  1 "Yes" 0 "No" 

label values have_non_res_real_estate have_non_res_real_estate 

label variable have_non_res_real_estate  "Do you own any Nonresidential Real Estate?"


           //Value of Businesses (both with active and non-active interests)//
   //Note: active and non-active interests can be further separated - see SCF SAS code//
						

generate business = 0 
/*replace business = business + max(0, X3129) + max(0, X3124) ///
 - max(0, X3126) * (X3127==5) + max(0, X3121) * (X3122==1) + max(0, X3121) * (X3122==6) ///
 + max(0, X3229) + max(0, X3224) - max(0, X3226) * (X3227==5) ///
 + max(0, X3221)*(X3222==1) + max(0, X3221)*(X3222==6) ///
 + max(0, X3335) + farmbus + max(0, X3408) + max(0, X3412) ///
 + max(0, X3416) + max(0, X3420) + max(0, X3452) + max(0, X3428) */

 label variable business "Total Value of Business Interests"


generate have_business_assets = 0

replace have_business_assets  = 1 if (X3103==1 | X3401==1)

label define have_business_assets  1 "Yes" 0 "No" 

label values have_business_assets  have_business_assets 

label variable have_business_assets  "Do you have any Business Assets?"

                         //Active Business//
						 
generate actbus = 0
replace actbus = max(0, X3129) + max(0, X3124) ///
 - max(0, X3126) * (X3127==5) + max(0, X3121) * (X3122==1) + max(0, X3121) * (X3122==6) ///
 + max(0, X3229) + max(0, X3224) - max(0, X3226) * (X3227==5) ///
 + max(0, X3221)*(X3222==1) + max(0, X3221)*(X3222==6) ///
 + max(0, X3335) + farmbus 
 
 label variable actbus "Value of Active Business Interests"
 
                            //Non-Active Business//
 generate nonactbus = 0
 /*replace nonactbus = max(0,X3408)+max(0,X3412)+max(0,X3416)+max(0,X3420)+ ///
        max(0,X3452)+max(0,X3428)*/
 

                 //Value of Other Nonfinancial Assets//

generate other_non_financial_assets = 0

replace other_non_financial_assets = other_non_financial_assets + X4022 ///
+ X4026 + X4030 - other_financial_assets + X4018

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
  
generate newvar = max(0, X1136)*(X1108*(X1103==1) + X1119*(X1114==1) + X1130*(X1125==1))/(X1108+X1119+X1130)
recode newvar (mis=0)

generate newvar2 = X1108*(X1103==1) + X1119*(X1114==1) + X1130*(X1125==1)

generate heloc1 = newvar+newvar2

generate newvar3 = max(0, X1136)*(X1108*(X1103==1)+ X1119*(X1114==1)+X1130*(X1125==1))/(X1108+X1119+X1130)
recode newvar3 (mis=0)

generate newvar4 = X805+X905+X1005+ X1108*(X1103==1)+X1119*(X1114==1)+X1130*(X1125==1)

generate mrthel1 = newvar3 + newvar4


generate heloc2 = 0

generate mrthel2 = X805 + X905 + X1005 + .5*(max(0, X1136))*(houses>0)


generate heloc = heloc1 if (X1108 +X1119 + X1130)>=1 
replace heloc = heloc2 if (X1108 +X1119 + X1130)<1

generate mrthel = mrthel1 if (X1108 +X1119 + X1130)>=1 
replace mrthel = mrthel2 if (X1108 +X1119 + X1130)<1

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

replace first_lien_mortgage = 1 if X805>0

label define first_lien_mortgage  1 "Yes" 0 "No" 

label values  first_lien_mortgage first_lien_mortgage

label variable first_lien_mortgage  "Do you have First-Lien (Primary) Mortgage?"					 
  
  
          //Purchase Loan - First Mortgage (First-Lien)//

generate purchase_loan_mortgage = 0

replace purchase_loan_mortgage = 1 if ((X802>0 & X7137==0) | X7137==8)

label define purchase_loan_mortgage  1 "Yes" 0 "No" 

label values  purchase_loan_mortgage purchase_loan_mortgage

label variable purchase_loan_mortgage  "Do you have owe a Purchase Loan for your First Mortgage?"


                           //Refinancing// 
						   
generate refinancing = 0

replace refinancing = 1 if (X7137>0 & X7137~=8)

label define refinancing  1 "Yes" 0 "No" 

label values  refinancing refinancing

label variable refinancing  "Did you ever Refinance?"


                            //EXtracting Equity from Refinancing//
							
generate eXtract_equity_refinancing = 0

replace eXtract_equity_refinancing = 1 if (X7137==2 | X7137==3 | X7137==4)

label define eXtract_equity_refinancing 1 "Yes" 0 "No" 

label values  eXtract_equity_refinancing eXtract_equity_refinancing

label variable eXtract_equity_refinancing  "Did you ever eXtract equity from Refinancing?"							


                        //Second/Third Mortgage//
							
generate second_mortgage = 0

replace second_mortgage = 1 if ((X905+X1005)>0)

label define second_mortgage 1 "Yes" 0 "No" 

label values  second_mortgage second_mortgage

label variable second_mortgage  "Did you ever eXtract equity from Refinancing?"
  
  
  **************************************break*********************
  
  
                         //Other Lines of Credit//
						  
generate othloc1 = 	X1108*(X1103~=1)+ X1119*(X1114~=1)+ X1130*(X1125~=1) ///
 + max(0, X1136)*(X1108*(X1103~=1)+ X1119*(X1114~=1) ///
 + X1130*(X1125~=1))/(X1108+X1119+X1130)					  
          
generate othloc2 = ((houses<=0)+.5*(houses>0))*(max(0, X1136))
	  
generate othloc = othloc1 if (X1108 +X1119 + X1130)>=1 
replace othloc = othloc2 if (X1108 +X1119 + X1130)<1

label variable othloc "Other Lines of Credit"

drop othloc1 othloc2


                         //Have Other Lines of Credit//

generate have_other_loc = 0
replace have_other_loc = 1 if othloc > 0

label define have_other_loc  1 "Yes" 0 "No" 

label values  have_other_loc have_other_loc

label variable have_other_loc  "Do you have Other Lines of Credit?"

  

                     //Debt for Other Residential Property//
					
  generate mortgage1 = X1715*(X1705/10000) if X1703==12 |  X1703==14 |  X1703==21 | ///
   X1703==22 |  X1703==25 |  X1703==40 |  X1703==41 |  X1703==42 |  X1703==43 | ///
    X1703==44 |  X1703==49 |  X1703==50 |  X1703==52 |  X1703==999 
  
 recode mortgage1 (mis=0)

 generate mortgage2 = X1815*(X1805/10000) if X1803==12 |  X1803==14 |  X1803==21 | ///
   X1803==22 |  X1803==25 |  X1803==40 |  X1803==41 |  X1803==42 |  X1803==43 | ///
    X1803==44 |  X1803==49 |  X1803==50 |  X1803==52 |  X1803==999 
  
 recode mortgage2 (mis=0)

 
generate other_residential_debt = X1417+X1517+X1621+mortgage1+mortgage2+X2006

replace other_residential_debt = (other_residential_debt + X2723*(X2710==78)+X2740*(X2727==78) /// 
       +X2823*(X2810==78)+X2840*(X2827==78)+X2923*(X2910==78) ///
	   +X2940*(X2927==78)) if (non_res_real_estate==0 & other_residential_real_estate>0)
 
replace other_residential_debt = other_residential_debt + X2723*(X2710==67)+X2740*(X2727==67) /// 
       +X2823*(X2810==67)+X2840*(X2827==67)+X2923*(X2910==67)+X2940*(X2927==67) ///
	   if other_residential_real_estate>0

label variable other_residential_debt "Debt for Other Residential Property"


                             //Have Other Residential Debt//

generate have_other_residential_debt = 0
replace have_other_residential_debt = 1 if other_residential_debt > 0

label define have_other_residential_debt  1 "Yes" 0 "No" 

label values have_other_residential_debt have_other_residential_debt

label variable have_other_residential_debt  "Do you have Other Residential Debt?" 



                      //Credit Card Debt (Credit Card Balance)//
							  
generate credit_card_balance = max(0, X427)+max(0, X413)+max(0, X421) ///
 +max(0, X430)+max(0, X7575)
 
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
										 		
generate install = X2218+X2318+X2418+X7169+X2424+X2519+X2619+X2625+X7183 ///
  +X7824+X7847+X7870+X7924 +X7947+X7970+X7179+X1044+X1215+X1219
  
replace install = install + X2723*(X2710==78)+X2740*(X2727==78) ///
 +X2823*(X2810==78)+X2840*(X2827==78)+X2923*(X2910==78) ///
 +X2940*(X2927==78) if (FLAG781==0 & FLAG782==0)
 
 replace install = install+X2723*(X2710==67)+X2740*(X2727==67) /// 
 + X2823*(X2810==67)+X2840*(X2827==67)+X2923*(X2910==67) ///
 + X2940*(X2927==67) if (FLAG67==0)
 
replace install = install + X2723*(X2710~=67 | X2710~=78) /// 
+X2740*(X2727~=67 | X2727~=78)+X2823*(X2810~=67 | X2810~=78) /// 
+X2840*(X2827~=67 | X2827~=78)+X2923*(X2910~=67 | X2910~=78) ///
+X2940*(X2927~=67 | X2927~=78)

label variable install "Installment Debt"


         //Have Any Installment Debt//

generate have_installment_debt = 0
replace have_installment_debt = 1 if install > 0

label define have_installment_debt  1 "Yes" 0 "No" 

label values have_installment_debt have_installment_debt

label variable have_installment_debt  "Do you have any Installment Debt?" 

			
			//Margin Loans//
				
generate margin_loans = max(0, X3932)
label variable margin_loans "Margin Loans"

            
			//Pension Loans not Reported Earlier//
				
generate pension_loan_1 = max(0,X11027)*(X11070==5)
generate pension_loan_2 = max(0,X11127)*(X11170==5)
generate pension_loan_4 = max(0,X11327)*(X11370==5)
generate pension_loan_5 = max(0,X11427)*(X11470==5)
generate pension_loan_3 = 0
generate pension_loan_6 = 0


                   //Other Debts (Combines loans against pensions, //
			 // loans against life insurance, margin loans, miscellaneous)// 
			 
generate other_loan_debt = 0
replace other_loan_debt = pension_loan_1 + pension_loan_2 ///
+ pension_loan_4 + pension_loan_5 + max(0, X4010) ///
+ max(0, X4032) + margin_loans

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

xtile net_worth_percentile = NET_WORTH, nq(5)
 //These numbers are adjusted to frequency weights//

label define net_worth_percentile 1 "Less than 25" 2 "25-49.9" 3 "50-74.9" 4 "75-89.9" 5 "90-100" 

label values net_worth_percentile net_worth_percentile

label variable net_worth_percentile "Percentile of Net Worth"

*****************************************************************************
*Capital Gains
*****************************************************************************

                      //Principal Residence Capital Gains//
					
generate kghouse = max(X513, X526, X604, X614, X623, X716) ///
- max(X607, X617, X627+X631, X635, X717) - X1202

label variable kghouse "Principal Residence Capital Gains"
					   

					   
                        //Other Real Estate Capital Gains//
						
generate kgore = (X1705/10000)*(X1706 - X1709)+(X1805/10000)*(X1806 - X1809) ///
                 + (X2002-X2003)+(X2012-X2013) 

label variable kgore "Other Real Estate Capital Gains"					   


                            //Businesses Capital Gains//
						 
/*generate kgbus = (X3129-X3130)+(X3229-X3230)+(X3408-X3409) ///
 +(X3412-X3413)+(X3416-X3417)+(X3420-X3421)+(X3452-X3453)+(X3428-X3429)

label variable kgbus "Businesses Capital Gains"*/


                  //Adjustment for capital gains on farm businesses// 
				
generate farmbus_kg = 0
replace farmbus_kg = ((X507/10000)*kghouse) if X507>0

*replace kghouse = (kghouse - farmbus_kg) if X507>0

*replace kgbus = (kgbus + farmbus_kg) if X507>0


                    //Stocks And Mutual Funds Capital Gains//
			  
generate kgstmf = (X3918-X3920)+(X3833-X3835)

label variable kgstmf "Stocks and Mutual Funds Capital Gains"


                //Total Capital Gains/Losses//

/*generate kgtotal = kghouse + kgore + kgbus + kgstmf 

label variable kgtotal "Total Capital Gains/Losses"*/

				
                //Have Capital Gains/Losses//
						  
/*generate have_capital_gains = 0 
replace have_capital_gains = 1 if kgtotal ~= 0

label define have_capital_gains  1 "Yes" 0 "No" 

label values have_capital_gains have_capital_gains

label variable have_capital_gains  "Do you have any Capital Gains/Losses?"       */



			//Value of Equity (Stocks + Mutual Funds)//
			
generate equity = stocks + mutual_funds
label variable equity "Value of Equity (Stocks + Mutual Funds)"

                      //Have Equity//

generate have_equity = 0
replace have_equity = 1 if equity~=0

label define have_equity 1 "Yes" 0 "No" 

label values have_equity have_equity

label variable have_equity "Do you have Equity (Stocks + Mutual Funds)?"	
                     
	//Specific definition for a defied-benefit account - different from regular //
	//defined benefit because it asks the respondents who have an actual account,//
	//which is not many people and does not give an accurate defined benefit number//
	//(in essence, it asks a different question, just surveying those respondents who//
	//maintain their own, specific defined benefit account, so it doesn't encompass// 
	//those who who are under the defined benefit plan but do not own a specific account//

/*generate defined_benefit = max(0, X11032)*((X11000==4 & X11001~=30)|X11001==1) ///
       + max(0, X11132)*((X11100==4 & X11101~=30)|X11101==1) ///
	   + max(0, X11332)*((X11300==4 & X11301~=30)|X11301==1) ///
	   + max(0, X11432)*((X11400==4 & X11401~=30)|X11401==1) ///
	   + max(0, X6462)*(X5316==1 & X6461==5) ///
	   + max(0, X6467)*(X5324==1 & X6466==5) ///
	   + max(0, X6472)*(X5332==1 & X6471==5) ///
	   + max(0, X6477)*(X5416==1 & X6476==5) ///
*/
generate defined_contribution = max(0, X11032)*(11032>0 | X11032==-1) ///
        + max(0, X11132)*(X11132>0 | X11132==-1) ///
		+ max(0, X11332)*(X11332>0 | X11332==-1) ///
		+ max(0, X11432)*(X11432>0 | X11432==-1) ///        
		+ max(0, X6462)*(X5316==1 & X6461==1) ///
		+ max(0, X6467)*(X5324==1 & X6466==1) ///
		+ max(0, X6472)*(X5332==1 & X6471==1) ///
		+ max(0, X6477)*(X5416==1 & X6476==1) ///  
		
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


	//Precautionary Savings//
	

generate precautionary_saving = X7187	

replace precautionary_saving = 0 if X7187==-1

label variable precautionary_saving "Precautionary Saving"	
	
	
	
	//Respondents with Either DC or IRA/Keogh Assets//

generate have_dc_or_ira_keogh = 0
replace have_dc_or_ira_keogh = 1 if have_dcplancj~=0| have_ira_keogh ~=5
label variable have_dc_or_ira_keogh "Have DC or IRA/Keogh assets"



                   //Respondents with DB and DC/IRA/Keogh Assets//

generate have_db_and_dcirakeogh = 0
replace have_db_and_dcirakeogh = 1 if have_dbplan~=0 & have_dc_or_ira_keogh~=0
label variable have_db_and_dcirakeogh "Have DB and DC/IRA/Keogh assets"
	

						//Respondents with Neither Plan//
						
generate dont_have_any_plans = 0
replace dont_have_any_plans = 1 if have_dc_or_ira_keogh == 0 & have_dbplan==0					
label variable dont_have_any_plans "Have no DB, DC, or IRA/Keogh Assets"
	

		//Respondents with all three plans (DB, DC, and IRA/Keogh)//
 
generate have_all_3_plans = 0
replace have_all_3_plans = 1 if have_dbplan~=0 & have_dcplancj~=0 & have_ira_keogh~=0
label variable have_all_3_plans "Have all three plans (DB, DC, and IRA/Keogh)"	
	
// Risky bonds are not included but can be calculated as a sum of corporate bonds
// (X7634), foreign bonds (X7633), and mortgage-backed bonds (X3906).


//Shopping Around variable -> X7111//


	                //Total Non-Retirement Financial Assets//

generate Total_Non_Ret_Financial_Assets = liquid_accounts + cds + mutual_funds + stocks + bonds ///
   + savings_bonds + life_insurance_cash_value + other_managed_assets ///
  + other_financial_assets
  
label variable Total_Non_Ret_Financial_Assets "Total Non-Retirement Financial Assets"  

                      //Have Any Non-Retirement Financial Assets//
							  
generate Have_Any_NonRet_Financial_Assets = 0
replace Have_Any_NonRet_Financial_Assets = 1 if Total_Non_Ret_Financial_Assets~=0

label define Have_Any_NonRet_Financial_Assets 1 "Yes" 0 "No" 

label values Have_Any_NonRet_Financial_Assets Have_Any_NonRet_Financial_Assets

label variable Have_Any_NonRet_Financial_Assets "Do you have Any Non-Retirement Financial Assets?"		
					  
