
//**Note that all "X"s that are capitalized need to be lower-case in later SCF years**//


tab have_any_pension [weight=frequency_weight_round]

preserve

drop if X4135==0 & X4735==0

generate current_job_pension = 0

replace current_job_pension = 1 if X4135==1 | X4735==1

label define current_job_pension 1 "Yes" 0 "No"

label values current_job_pension current_job_pension

label variable current_job_pension "Do you have any pension, retirement, or savings plans connected with the current job?"

tab current_job_pension [weight=frequency_weight_round]

restore


preserve

drop if X4136==0 & X4736==0

generate employer_plan = 0

replace employer_plan = 1 if X4136==1 | X4736==1

label define employer_plan 1 "Yes" 0 "No"

label values employer_plan employer_plan

label variable employer_plan "Does your employer offer any pension, retirement, or savings plans?"

tab employer_plan [weight=frequency_weight_round]

restore


preserve

drop if X4137==0 & X4737==0

generate plan_eligible = 0

replace plan_eligible = 1 if X4137==1 | X4737==1

label define plan_eligible 1 "Yes" 0 "No"

label values plan_eligible plan_eligible

label variable plan_eligible "Are you eligible to be included in any of your job pension, retirement, or savings plans?"

tab plan_eligible [weight=frequency_weight_round]

restore

