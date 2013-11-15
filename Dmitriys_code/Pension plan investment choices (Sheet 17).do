
//**Note that for later years all of the "X"s that are capitalized need to be lower-case**//


//"Do you have any choices about how your pension plan is invested?"//
preserve

drop if	X11034==0 & X11334==0

generate yesoptions = 0

replace yesoptions = 2 if X11034==5	| X11334==5

replace yesoptions = 1 if X11034==1 | X11334==1

label define yesoptions  1 "Yes" 2 "No" 0 "Limited Choice"

label values yesoptions yesoptions

label variable yesoptions "Do you have any choices about how pension plan is invested?"

tab yesoptions [weight=frequency_weight_round]

restore

              //"Do you know how your pension plan is invested?"//
preserve

drop if	X11035==0 & X11335==0

generate yesoptions = 0

replace yesoptions = 2 if X11035==5	| X11335==5

replace yesoptions = 1 if X11035==1 | X11335==1

label define yesoptions  1 "Yes" 2 "No" 0 "Limited Knowledge"

label values yesoptions yesoptions

label variable yesoptions "Do you know how your pension plan is invested?"

tab yesoptions [weight=frequency_weight_round]

restore
