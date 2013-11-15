
                 //Create an ID variable to match the initial order//
			
gen id = _n			

                     //Year of the Survey//
					 
generate year = 2001
label variable year "Year of the Survey"
				
order id year, first
				
                       //Frequency Weights (Already generated in SCF 2007//
					   
generate frequencyweight = x42001/5					   
generate frequency_weight_round = round(frequencyweight)				   


**************************************************************************
*Demographic Information
**************************************************************************
						   
						//Creating the "Age of Head" Variable//  
gen age = x14

recode age 0/34 = 1 35/44=2 45/54=3 55/64=4 65/74=5 75/max=6

label define age 1 "Less than 35" 2 "35-44" 3 "45-54" 4 "55-64" 5 "65-74" 6 "75 or more"

label values age age

label variable age "Age of head (years)"


                    //Another Separation of the "Age of Head" variable//
						 
generate age2 = x14

recode age2 0/24 = 1 25/34 = 2 35/44=3 45/54=4 55/64=5 65/74=6 75/max=7

label define age2 1 "Less than 25" 2 "25-34" 3 "35-44" 4 "45-54" 5 "55-64" 6 "65-74" 7 "75 or more"

label values age2 age2

label variable age2 "Age of head"  


                   //Third Separation of Age - by 3-year increments//
generate age3 = x14
recode age3 0/24 = 1 25/27 = 2 28/30 = 3 31/33 = 4 34/36 = 5 37/39 = 6 ///
           40/42 = 7 43/45 = 8 46/48 = 9 49/51 = 10 52/54 = 11 55/57 = 12 58/60 = 13 ///
           61/63 = 14 64/66 = 15 67/69 = 16 70/max = 17
		   
label define age3 1 "Less than 25" 2 "25-27" 3 "28-30" 4 "31-33" 5 "34-36" 6 "37-39" ///
                  7 "40-42" 8 "43-45" 9 "46-48" 10 "49-51" 11 "52-54" 12 "55-57" ///
				  13 "58-60" 14 "61-63" 15 "64-66" 16 "67-69" 17 "70 and older"

label values age3 age3

label variable age3 "Age of head (3-year increments)" 		   
		   


                           //Summarized total income by age//

//by age, sort: summarize x5729 [weight= frequencyweight] , detail (not used in coding, just to test if it works)//

                    //Creating the "Education of Head" Variable//
						   
gen college = 4 if x5904==1
replace college =3 if x5901>=13 & x5904==5
replace college =2 if x5901<=12 & x5902==1
replace college = 2 if x5901<=12 & x5902==2
replace college = 1 if college==.

rename college education 
label define education 1 "No High School Diploma" 2 "High School Diploma" 3 "Some College" 4 "College Degree" 

label values education education

label variable education  "Education of Head"

                      //Creating the "Marital Status of Head" Variable//

 gen marital_status =x8023
replace marital_status = 2 if x8023!=1 | x8023!=2 //(every variable in marital_status becomes 2)
replace marital_status = 1 if x8023==1 | x8023==2 //(married or living together people are coded as 1)

label define marital_status 1 "Married/Living with Partner" 2 "Neither Married nor Living with Partner"
label values marital_status marital_status
label variable marital_status "Marital Status of Head"


                  //Creating "Labor Force Participation of Head" Variable//

gen labor_force_particip =1
replace labor_force_particip = 0 if ((x4100>=50 & x4100<=80) | x4100==97)

label define labor_force_particip 1 "Working in some way" 0 "Not Working at all"
label values labor_force_particip labor_force_particip
label variable labor_force_particip "Labor Force Participation of Head"


                           //Children Variable// (Note: this variable would slightly differ from the one in the 
						  //  SCF because "Foster Children" variable is not included in the public dataset) //

gen children = 0
replace children =1 if (x108==4 | x114==4 | x120==4 | x126==4 |x132==4 |x202==4 |x208==4 |x214==4 |x220==4)

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
										
gen race = x6809
replace race = 1 if x6809==1
replace race = 2 if x6809~=1

label define race 1 "White non-Hispanic" 2 "Nonwhite or Hispanic"

label values race race

label variable race "Race or Ethnicity of Respondent"



                           //Current Work Status Variable//
									 
generate work_status = 0
replace work_status = 1 if x4106==1
replace work_status = 2 if x4106==2 | x4106==3 | x4106==4
replace work_status = 3 if x4100==50 | x4100==52
replace work_status = 3 if x4100==21 & x14>=65 | x4100==23  & x14>=65 | x4100==30 & x14>=65 | x4100==70 & x14>=65 | x4100==80 & x14>=65 | x4100==97 & x14>=65 | x4100==85 & x14>=65 | x4100== -7 & x14>=65
replace work_status = 4 if work_status==0 & x14<65

label define work_status 1 "Working for someone else" 2 "Self-Employed" 3 "Retired" 4 "Other Not Working" 

label values work_status work_status

label variable work_status "Current Work Status of Head"


                                   //Housing Status Variable//


generate housing_status = 2
replace housing_status = 1 if x508==1 | x508==2 | x601==1 | x601==2 | x601==3 | x701==1 | x701==3 | x701==4 | x701==5 | x701==6 | x701==8 | x701==-7 & x7133==1								   
					
label define housing_status 1 "Owner" 2 "Renter or other" 

label values housing_status housing_status

label variable housing_status "Housing Status"

  
  
                           //Current Occupation of head//
						   
generate occupation = 0
replace occupation =1 if x7401==1
replace occupation =2 if x7401==2 | x7401==3
replace occupation =3 if x7401==4 | x7401==5 | x7401==6
replace occupation =4 if x7401==0

label define occupation 1 "Managerial or professional" 2 "Technical, sales, or services" 3 "Other occupation" 4 "Retired or other not working" 

label values occupation occupation

label variable occupation "Current occupation of head"


                      //Reasons for Saving//

generate saving_reason = 0 

replace saving_reason = 1 if (x3006==-2 | x3006==-1)

replace saving_reason = 2 if (x3006==1 | x3006==2)

replace saving_reason = 3 if (x3006==3 | x3006==5 | x3006==6)

replace saving_reason = 4 if (x3006==11)

replace saving_reason = 5 if (x3006==12 | x3006==13 ///
 | x3006==14 | x3006==15 | x3006==16 | x3006==27 | x3006==29 | x3006==30 ///
 | x3006==9 | x3006==18 | x3006==20 | x3006==41)

replace saving_reason = 6 if (x3006==17 | x3006==22)

replace saving_reason = 7 if (x3006==23 | x3006==24 | x3006==25 ///
                            | x3006==32 | x3006==92 | x3006==93)
							
replace saving_reason = 8 if (x3006==21 | x3006==26 | x3006==28)

replace saving_reason = 9 if (x3006==31 | x3006==33 | x3006==40 ///
                            | x3006==90 | x3006==91 | x3006==-7)
							
label define saving_reason 1 "Can't Save" 2 "Education" 3 "Family" ///
    4 "Home" 5 "Purchases" 6 "Retirement" 7 "Liquidity/Future" ///
    8 "Investment" 9 "No Particular Reason"  

 label values saving_reason saving_reason
label variable saving_reason "Reasons for Saving"							



* "Urbanicity" and "Census Region" are not included in the public dataset

**********************************************************************
*Financial Info
**********************************************************************

                           //Income//
						   
		   //(1-Step Process for years <=2001)//
generate income = max(0, x5729) 

label variable income "Income"


                          //Income Components//
		                     //Wage Income//
							 
generate wage_income = x5702
label variable wage_income "Income from Wages"

                    //Interest/Dividend Income//
					
generate interest_dividend_income = x5706 + x5708 + x5710
label variable interest_dividend_income "Income from Interests/Dividends"

                    //Business, Farm, Self-Employment Income//
					
generate business_farm_income = x5704 + x5714
label variable business_farm_income "Business/Farm Income"

                        //Capital Gains Income//
						
generate capital_gains_income = x5712						
label variabl capital_gains_income "Income from Capital Gains"

              //Social Security/Retirement Income//
			  
generate ss_retirement_income = x5722
label variable ss_retirement_income "Social Security/Retirement Income"			  						   

	 			   //Transfers or Other Income//

generate transfer_other_income = x5716 + x5718 + x5720 + x5724
label variable transfer_other_income "Transfer or Other Income"	
						 
						 //Components Combined//
generate income_components = x5702 + x5704+x5714 +x5706+x5708+x5710 +x5712+x5722 ///
                    + x5716+x5718+x5720+x5724
					
						 
				//Normal Year Income Variable//
generate normal_income = x5729
replace normal_income =x7362 if x7650~=3


                     //"Percentile of Income" Variable//


sort income normal_income, stable

generate income2 = 1 in 1/3346
replace income2 = 2 in 3347/6638
replace income2 = 3 in 6639/10097
replace income2 = 4 in 10098/13677
replace income2 = 5 in 13678/15664
replace income2 = 6 in 15665/22210

label define income2 1 "Less than 20" 2 "20-39.9" 3 "40-59.9" 4 "60-79.9" 5 "80-89.9"  6 "90-100"

label values income2 income2

label variable income2 "Percentile of Income"
rename income2 income_percentile


                             //Families that Save//
					

generate saving = x7510
replace saving = x7508 if x7508>0
replace saving = 3 if x7510==2 & x7509==1
replace saving = 1 if saving==2

label define saving 1 "Don't Save" 3 "Save" 

label values saving saving

label variable saving "Did your family save?"

rename saving family_saving

                                 //Savings Account//

generate savings_account = max(0,x3804)+max(0,x3807)+max(0,x3810)+max(0,x3813) ///
        +max(0,x3816)+max(0,x3818)

label variable savings_account "Value of Savings Accounts"

                           					
						    //Do you have a Savings Account//
						  
 
generate have_savings = 0

replace have_savings = 1 if savings_account~=0   

label define have_savings 1 "Yes" 0 "No" 

label values have_savings have_savings

label variable have_savings "Do you have any Savings or Money Market Accounts?"


                              //Checking account//
							  
							  
generate checking = max(0,x3506)*(x3507==5)+max(0,x3510)*(x3511==5) ///
      +max(0,x3514)*(x3515==5)+max(0,x3518)*(x3519==5) ///
	  +max(0,x3522)*(x3523==5)+max(0,x3526)*(x3527==5) ///	 
      +max(0,x3529)*(x3527==5) 

label variable checking "Value of a Checking Account"                     
					  
					   //Do you have a Checking Account//
						  
 
generate have_checking = 0  

replace have_checking = 1 if checking ~=0

label define have_checking 1 "Yes" 0 "No" 

label values have_checking have_checking

label variable have_checking "Do you have a Checking Account?"


                     //Reason for Choosing Main Checking Account//

generate checking_account_reason = 10 

replace checking_account_reason = 1 if x3530==3
replace checking_account_reason = 2 if x3530==7
replace checking_account_reason = 3 if x3530==6
replace checking_account_reason = 4 if x3530==1
replace checking_account_reason = 5 if x3530==11
replace checking_account_reason = 6 if x3530==35
replace checking_account_reason = 7 if x3530==14
replace checking_account_reason = 8 if x3530==8
replace checking_account_reason = 9 if x3530==9

label define checking_account_reason 1 "Location" 2 "Low Fee Balance" 3 "Many Services"  4 "Recommended by Friend/Family" 5 "Personal Relationship" 6 "Connection through Work/School" 7 "Always done business there" 8 "Safety" 9 "Convenience/Direct Deposit" 10 "Other"

label values checking_account_reason checking_account_reason

label variable checking_account_reason "Reason For Choosing Main Checking Account"                                           
                                                   
			
			                //Money Owed//
					   
					   
generate owed_any_money = x4017   

label define owed_any_money 1 "Yes" 5 "No" 

label values owed_any_money owed_any_money

label variable owed_any_money "Are you owed any money by friends, relatives, or others?"
					   
		
		                 //Other Substantial Assets//
						 
generate miscellaneous_assets = x4019  

label define miscellaneous_assets 1 "Yes" 5 "No" 

label values miscellaneous_assets miscellaneous_assets

label variable miscellaneous_assets "Do you own any other Miscellaneous Assets?"


                         //Amount of Miscellaneous Assets combined (both "Money Owed" and "Other Substantial Assets")	 
						 
generate other_asset = x4018 + x4022 + x4026 + x4030

label variable other_asset "Miscellaneous Asset Amount"		


                             //Other Debt//
							 
generate other_debt = x4031  

label define other_debt 1 "Yes" 5 "No" 

label values other_debt other_debt

label variable other_debt "Do you owe any money not recorded earlier?"
 
                           
 
                       // //Money Market Accounts// //
						    
					 //Money Market Deposit Accounts//
 
 
generate mmda = max(0,x3506)*((x3507==1)*(11<=x9113<=13)) ///
        +max(0,x3510)*((x3511==1)*(11<=x9114<=13)) ///
        +max(0,x3514)*((x3515==1)*(11<=x9115<=13)) ///
        +max(0,x3518)*((x3519==1)*(11<=x9116<=13)) ///
        +max(0,x3522)*((x3523==1)*(11<=x9117<=13)) ///
        +max(0,x3526)*((x3527==1)*(11<=x9118<=13)) ///
        +max(0,x3529)*((x3527==1)*(11<=x9118<=13)) ///
        +max(0,x3706)*(11<=x9131<=13)+max(0,x3711)*(11<=x9132<=13) ///
        +max(0,x3716)*(11<=x9133<=13)+max(0,x3718)*(11<=x9133<=13) 

label variable mmda "Money Market Deposit Accounts"

         				 //Money Market Mutual Funds//
						 
generate mmmf = max(0,x3506)*(x3507==1)*(x9113<11|x9113>13) ///
        +max(0,x3510)*(x3511==1)*(x9114<11|x9114>13) ///
        +max(0,x3514)*(x3515==1)*(x9115<11|x9115>13) ///
        +max(0,x3518)*(x3519==1)*(x9116<11|x9116>13) ///
        +max(0,x3522)*(x3523==1)*(x9117<11|x9117>13) ///
        +max(0,x3526)*(x3527==1)*(x9118<11|x9118>13) ///
        +max(0,x3529)*(x3527==1)*(x9118<11|x9118>13) ///
        +max(0,x3706)*(x9131<11|x9131>13)+max(0,x3711)*(x9132<11|x9132>13) ///
        +max(0,x3716)*(x9133<11|x9133>13)+max(0,x3718)*(x9133<11|x9133>13) 

label variable mmmf "Money Market Mutual Funds"		
 
                  //Combined Money Market Account Value//
						 				 
generate mma = mmda + mmmf

label variable mma "Value of a Money Market Account"
                                                  
			                    
			           //Value of a Brokerage Account//
						  
generate brokerage = max(0, x3930)
label variable brokerage "Value of a Brokerage Account"

                             //Have Brokerage Account//							

generate have_brokerage_account = x3923   

label define have_brokerage_account 1 "Yes" 5 "No" 

label values have_brokerage_account have_brokerage_account

label variable have_brokerage_account "Do you have a brokerage account?"


                         //Trading in the Past Year//
								
generate trading_past_year = 1 if x3928>0
recode trading (mis=0)

label define trading_past_year 1 "Yes" 0 "No" 

label values trading_past_year trading_past_year

label variable trading_past_year "Have you traded in the past year?"


                   //All Types of Transaction Accounts (Liquid Assets)//

				   
generate liquid_accounts = 0
replace liquid_accounts = mma+ brokerage+checking+ savings_account

label variable liquid_accounts "Total Value of Transaction Accounts (Liquid Assets)"			   
	
	
generate have_liquid_accounts = 0
replace have_liquid_accounts = 1 if liquid_accounts~=0  | x3501==1 | x3701==1 | x3801==1 | x3929==1 

label define have_liquid_accounts 1 "Yes" 0 "No" 

label values have_liquid_accounts have_liquid_accounts

label variable have_liquid_accounts "Do you have any type of a Transaction Account?"

replace liquid_accounts = max(have_liquid_accounts, liquid_accounts) //Includes accounts with zero balance - they are labeled as 1//


                              //Certificates of Deposit//

generate cds =  max(0, x3721)
label variable cds "Value of Certificates of Deposit"
							  
			    		   //Have Certificates of Deposits//     

generate have_cd = x3719   

label define have_cd 1 "Yes" 5 "No" 

label values have_cd have_cd

label variable have_cd "Do you have any Certificates of Deposits?"														  
							  
							  
							 //Value of Mutual Funds// 
							

generate stock_mutual_funds = max(0, x3822) if x3821==1
recode stock_mutual_funds (mis=0)

generate taxfree_bond_mutual_funds = max(0, x3824) if x3823==1
recode taxfree_bond_mutual_funds (mis=0)

generate govt_bond_mutual_funds = max(0, x3826) if x3825==1
recode govt_bond_mutual_funds (mis=0)

generate other_bond_mutual_funds = max(0, x3828) if x3827==1
recode other_bond_mutual_funds (mis=0)

generate combination_mutual_funds = max(0, x3830) if x3829==1
recode combination_mutual_funds (mis=0)


generate mutual_funds = stock_mutual_funds + taxfree_bond_mutual_funds + govt_bond_mutual_funds + other_bond_mutual_funds + combination_mutual_funds

label variable mutual_funds "Total Value of Mutual Funds"

                               //Mutual Funds//
																
generate have_mutual_funds = 0

replace have_mutual_funds = 1 if mutual_funds~=0  

label define have_mutual_funds 1 "Yes" 0 "No" 

label values have_mutual_funds have_mutual_funds

label variable have_mutual_funds "Do you have any Mutual Funds or Hedge Funds?"


               //Value of Stocks (and the number of Companies)//

generate stocks = max(0, x3915)

label variable stocks "Total Value of Stocks"

generate n_stocks = x3914

label variable n_stocks "Number of Companies in which Hold Stock"														  

                          //Have Publicly Traded Stock//
										 										 
generate have_public_stock = x3913   

label define have_public_stock 1 "Yes" 5 "No" 

label values have_public_stock have_public_stock

label variable have_public_stock "Do you own any publicly traded stock?"                                 
							  							  			
			
			//Value of Bonds (excluding bond funds and savings bonds)//

					  
generate taxexempt_bonds = x3910 
recode taxexempt_bonds (mis=0)
 
generate mortgagebacked_bonds = x3906
recode mortgagebacked_bonds (mis=0)

generate govt_bonds = x3908
recode govt_bonds (mis=0)

generate corporate_and_foreign_bonds = x7634+x7633
recode corporate_and_foreign_bonds (mis=0)

generate bonds = taxexempt_bonds + mortgagebacked_bonds + govt_bonds + corporate_and_foreign_bonds
label variable bonds "Total Value of Bonds"					  
   
				    //Have Bonds other than Savings bonds//
									 									 
generate have_other_bonds = x3903   

label define have_other_bonds 1 "Yes" 5 "No" 

label values have_other_bonds have_other_bonds

label variable have_other_bonds "Do you have any other corporate, municipal, or government bonds?"
 

							  
			    		  //Retirement Account Total//
							  
		     		  //IRA/Keogh Retirement Account//      
						  
generate ira_keogh = max(0, x3610)+ max(0, x3620)+ max(0, x3630)
label variable ira_keogh "IRA/Keogh Retirement Account"


                              //Have IRA and Keogh Accounts//

generate have_ira_keogh = x3601   

label define have_ira_keogh 1 "Yes" 5 "No" 

label values have_ira_keogh have_ira_keogh

label variable have_ira_keogh "Do you have any IRA or Keogh Account?"


                                 //Future Pensions//
								 
generate future_pension = max(0, x5604) + max(0, x5612) + max(0, x5620) + max(0, x5628) + max(0, x5636) + max(0, x5644)
label variable future_pension "Future Pensions"

                                 //Current Pensions//
								 
generate current_pension = x6462+x6467+x6472+x6477+x6482+x6487
label variable current_pension "Current Pension Account"


                            //Job Pension// 

generate job_pension1 = 0
replace job_pension1 = x4226 if (x4216==1 | x4216==2 | x4216==7 | x4216==11 ///
   | x4216==12 | x4216==18 | x4227==1 | x4231==1)
replace job_pension1 = 0 if x4226==-1

generate job_pension2 = 0
replace job_pension2 = x4326 if (x4316==1 | x4316==2 | x4316==7 | x4316==11 ///
   | x4316==12 | x4316==18 | x4327==1 | x4331==1)
replace job_pension2 = 0 if x4326==-1

generate job_pension3 = 0
replace job_pension3 = x4426 if (x4416==1 | x4416==2 | x4416==7 | x4416==11 ///
   | x4416==12 | x4416==18 | x4427==1 | x4431==1)
replace job_pension3 = 0 if x4426==-1

generate job_pension4 = 0
replace job_pension4 = x4826 if (x4816==1 | x4816==2 | x4816==7 | x4816==11 ///
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
								 
generate any_pension_plan = 1 if x4135==1 | x4735==1 | x5313==1 | x5601==1
recode any_pension_plan (mis=0)

label define any_pension_plan 1 "Yes" 0 "No" 

label values any_pension_plan any_pension_plan

label variable any_pension_plan "Any Type of Pension (either head or spouse)"

rename any_pension_plan have_any_pension_plan

								 //Defined Benefit Plan (Current Job)//      

generate dbplancj = 1 if (x4203==1 | x4303==1 | x4403==1 | x4803==1 ///
        | x4903==1 | x5003==1 | (x5316==1 & x6461==5) | (x5324==1 & x6466==5) /// 
        | (x5332==1 & x6471==5) | (x5416==1 & x6476==5) ///
		| (x5424==1 & x6481==5) | (x5432==1 & x6486==5))
recode dbplancj (mis=0)

label define dbplancj 1 "Yes" 0 "No" 

label values dbplancj dbplancj

label variable dbplancj "Defined benefit pension on a current job (either head or spouse)"
rename dbplancj  have_dbplancj

                               //Defined Contribution Plan (Current Job)//      

generate dcplancj = 1 if (x4203==2 | x4203==3) | (x4303==2 | x4303==3) ///
        | (x4403==2 | x4403==3) | (x4803==2 | x4803==3) | (x4903==2 | x4903==3) ///
		| (x5003==2 | x5003==3) | (x5316==1 & x6461==1) | (x5324==1 & x6466==1) ///
        | (x5332==1 & x6471==1) | (x5416==1 & x6476==1) /// 
        | (x5424==1 & x6481==1) | (x5432==1 & x6486==1)

recode dcplancj (mis=0)

label define dcplancj 1 "Yes" 0 "No" 

label values dcplancj dcplancj

label variable dcplancj "Defined contribution pension on a current job (either head or spouse)"
rename dcplancj have_dcplancj


               //Defined Benefit Plan from either the current job or the past job (either head or spouse)//
			   
generate have_dbplan = 1 if have_dbplancj==1 | (x6461==5 | x6466==5 | x6471==5 | x6476==5 | x6481==5 | x6486==5) | (x5603==1 | x5603==3 | x5611==1 | x5611==3 | x5619==1 | x5619==3 | x5627==1 | x5627==3 | x5635==1 | x5635==3 | x5643==1 | x5643==3)
 
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
label variable life_insurance_cash_value "Total Cash Value of Life Insurance"

                                //Have Life Insurance//
														
generate have_life_insurance = 0

replace have_life_insurance = 1 if life_insurance_cash_value~=0  

label define have_life_insurance 1 "Yes" 0 "No" 

label values have_life_insurance have_life_insurance

label variable have_life_insurance "Do you have any Life Insurance?"


                               //Value of Other Managed Assets//
								  
								   //Annuity Accounts//
generate annuities = max(0, x6820)
label variable annuities "Total Value of Annuities"                                                                        

generate have_annuity = x6815   

label define have_annuity 1 "Yes" 5 "No" 

label values have_annuity have_annuity

label variable have_annuity "Do you have assets in an Annuity Account?"

                      //Trusts/Other Managed Investment Accounts//
generate trusts = max(0, x6835)
label variable trusts "Total Value of Trusts"
					
generate have_trust_mia = x6827   

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
							
							
generate equity_in_stock = stocks + stock_mutual_funds + .5*combination_mutual_funds ///
  + ira_keogh*((x3631==2) +.5*(x3631==5 | x3631==6)+.3*(x3631==4)) ///
  + annuities*((x6826==1)+.5*(x6826==5 | x6826==6)+.3*(x6826==-7)) ///
  + trusts*((x6841==1)+.5*(x6841==5 | x6841==6)+.3*(x6841==-7)) ///
  + peneq ///
  + x6462*((x6463==1)+.5*(x6463==3))+x6467*((x6468==1)+.5*(x6468==3)) ///
  + x6472*((x6473==1)+.5*(x6473==3))+x6477*((x6478==1)+.5*(x6478==3)) ///
  + x6482*((x6483==1)+.5*(x6483==3))+x6487*((x6488==1)+.5*(x6488==3))

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
				   
generate reteq =ira_keogh*((x3631==2)+.5*(x3631==5|x3631==6)+.3*(x3631==4)) ///
      +peneq+x6462*((x6463==1)+.5*(x6463==3))+x6467*((x6468==1)+.5*(x6468==3)) ///
	  +x6472*((x6473==1)+.5*(x6473==3))+x6477*((x6478==1)+.5*(x6478==3)) ///
	  +x6482*((x6483==1)+.5*(x6483==3))+x6487*((x6488==1)+.5*(x6488==3))
		
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
										  
generate vehicles = max(0, x8166) + max(0, x8167) + max(0, x8168) + max(0, x8188) ///
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
						  
generate value_owned_vehicles = x8166+x8167+x8168+x8188

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
 | x701==1 | x701==3 | x701==4 | x701==5 | x701==6 | x701==8 | (x701==-1 & x7133==1)
 
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
  
 
               //Purchase Loan - First Mortgage (First-Lien)//

generate purchase_loan_mortgage = 0

replace purchase_loan_mortgage = 1 if ((x802>0 & x7137==0) | x7137==8)

label define purchase_loan_mortgage  1 "Yes" 0 "No" 

label values  purchase_loan_mortgage purchase_loan_mortgage

label variable purchase_loan_mortgage  "Do you have owe a Purchase Loan for your First Mortgage?"

                           //Refinancing// 
						   
generate refinancing = 0

replace refinancing = 1 if (x7137>0 & x7137~=8)

label define refinancing  1 "Yes" 0 "No" 

label values  refinancing refinancing

label variable refinancing  "Did you ever Refinance?"

                 //Extracting Equity from Refinancing//
							
generate extract_equity_refinancing = 0

replace extract_equity_refinancing = 1 if (x7137==2 | x7137==3 | x7137==4)

label define extract_equity_refinancing 1 "Yes" 0 "No" 

label values  extract_equity_refinancing extract_equity_refinancing

label variable extract_equity_refinancing  "Did you ever extract equity from Refinancing?"							

                        //Second/Third Mortgage//
							
generate second_mortgage = 0

replace second_mortgage = 1 if ((x905+x1005)>0)

label define second_mortgage 1 "Yes" 0 "No" 

label values  second_mortgage second_mortgage

label variable second_mortgage  "Did you ever extract equity from Refinancing?"
  
  
  ******************************break***********************
  
  
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
										 		
generate install = x2218+x2318+x2418+x7169+x2424+x2519+x2619+x2625+x7183 ///
  +x7824+x7847+x7870+x7924 +x7947+x7970+x7179+x1044+x1215+x1219
  
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

generate net_worth_percentile = 1 in 1/4511
replace net_worth_percentile = 2 in 4512/8549
replace net_worth_percentile = 3 in 8550/12522
replace net_worth_percentile = 4 in 12523/15175
replace net_worth_percentile = 5 in 15176/22210  

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
		+ max(0, x6462)*(x5316==1 & x6461==1) ///
		+ max(0, x6467)*(x5324==1 & x6466==1) ///
		+ max(0, x6472)*(x5332==1 & x6471==1) ///
		+ max(0, x6477)*(x5416==1 & x6476==1) ///
		+ max(0, x6482)*(x5424==1 & x6481==1) ///
		+ max(0, x6487)*(x5432==1 & x6486==1)	   

		
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
