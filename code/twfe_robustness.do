
use data/ready_circuits, clear

capture mkdir "$output/twfe/"

//////////////////////////////////////////
// twowayfeweights diagnostic from de Chaisemartin & D'Haultfœuille
/////////////////////////////////////////

* Globals and vars gen
global globals_and_vars=1
	if ${globals_and_vars}==1 {
	* Globals graphs
	global convote_options "graphregion(fcolor(white)) vertical legend(off) yline(0, lpattern(dash) lcolor(gray))"
	global coefplot_matrixes "(matrix(coefficients),ci(ci5) offset(-0.15)) (matrix(pretrend), offset(-0.15) noci recast(line) lpattern(dash) lcolor(blue) lwidth(0.15))"
	*global coefplot_matrixes_merged "(matrix(coefficients1),ci(ci51) ciopts(color(olive_teal)) color(olive_teal) offset(-0.30) msize(medium)) (matrix(coefficients2),ci(ci52) ciopts(color(ltblue)) color(ltblue) offset(-0.15) msize(medium)) (matrix(coefficients3),ci(ci53) ciopts(color(cranberry)) color(cranberry) offset(0) msize(large))"	 WITH PROMINENT ENET
	global coefplot_matrixes_merged "(matrix(coefficients1),ci(ci51) offset(-0.30) msize(medium)) (matrix(coefficients2),ci(ci52) offset(-0.15) msize(medium)) (matrix(coefficients3),ci(ci53) offset(0) msize(large))"	
	global coefplot_matrixes_merged_at "(matrix(coefficients1),ci(ci51) offset(-0.30) msize(medium)) (matrix(coefficients2),ci(ci52) offset(-0.15) msize(medium))"	
	global coefplot_matrixes_convote "(matrix(coefficients1_econ), ci(ci51_econ) ciopts(color(maroon)) msize(medium) symbol(circle_hollow) color(maroon) offset(-0.40)) (matrix(coefficients2_econ),ci(ci52_econ) ciopts(color(maroon)) msize(medium) symbol(diamond_hollow) color(maroon) offset(-0.30)) (matrix(coefficients1_nonecon),ci(ci51_nonecon) ciopts(color(teal)) symbol(circle_hollow) msize(medium) color(teal) offset(-0.05)) (matrix(coefficients2_nonecon),ci(ci52_nonecon) ciopts(color(teal)) symbol(diamond_hollow) msize(medium) color(teal) offset(0.05))"	
	*global coefplot_matrixes_convote "(matrix(coefficients1_econ), ci(ci51_econ) ciopts(color(maroon)) msize(medium) symbol(circle_hollow) color(maroon) offset(-0.45)) (matrix(coefficients2_econ),ci(ci52_econ) ciopts(color(maroon)) msize(medium) symbol(diamond_hollow) color(maroon) offset(-0.40)) (matrix(coefficients1_nonecon),ci(ci51_nonecon) ciopts(color(teal)) symbol(circle_hollow) msize(medium) color(teal) offset(0.05)) (matrix(coefficients2_nonecon),ci(ci52_nonecon) ciopts(color(teal)) symbol(diamond_hollow) msize(medium) color(teal) offset(0.10))"
	*global coefplot_matrixes "(matrix(coefficients),ci(ci5))"
	global coefplot_matrixes_double "(matrix(coefficients_econ), ci(ci5_econ)) (matrix(coefficients_nonecon), ci(ci5_nonecon))"
	* Globals FE
	* 	global enetc8 "i.year#c.(x_pssc x_psatty x_plocct x_pccoun x_b10s x_b20s x_b30s x_b40s x_b50s)" older one before july rerun
	global enetc8 "i.year#c.(x_plocct x_pccoun x_b10s x_b20s x_b30s x_b40s x_b50s)"
	* Globals FE for iteration
	global cohortfe "attend_year#c.year"
	global basefe "circuityear judgefe" 
	global basefe_enetc8 "circuityear judgefe $enetc8"
	global basefe_exper2fe "circuityear judgefe one#c.exper one#c.exper2"
	global basefe_exper2fe_enetc8 "circuityear judgefe one#c.exper one#c.exper2 $enetc8"
	global basefe_exper2fe_cohortfe "circuityear judgefe one#c.(exper exper2) attend_year#c.year"
	*global basefe_exper2fe_cohortfe "circuityear judgefe one#c.exper one#c.exper2 attend_year#c.year"
	global basefe_exper2fe_cohortfe_enetc8 "circuityear judgefe one#c.(exper exper2) attend_year#c.year $enetc8"
	* Globals of globals for FE
	global fes1 "basefe_exper2fe"
	global fes2 "basefe basefe_exper2fe basefe_exper2fe_enetc8"
	global fes3 "basefe_exper2fe_cohortfe basefe_exper2fe_cohortfe_enetc8"
	* Globals outcomes
	global outcome_2 y_labor_epa_lose y_convote_econ y_convote_nonecon y_ellickson_avg y_ellickson_vec j_posner_cited y_cons_antitrust econ_predicted_prob
	global outcome y_labor_epa_lose y_convote_econ y_convote_nonecon y_ellickson_avg y_ellickson_vec j_posner_cited y_cons_antitrust econ_predicted_prob
	
	* useful vars
	gen mw5nl=mw5
	gen mw5nr=mw5
	}
*


tempfile results
postfile pf str32 outcome str10 spec ///
    double beta natts npos nneg sumwpos sumwneg ///
    using "`results'", replace


foreach outcome in y_labor_epa_lose y_convote_econ y_convote_nonecon {

    // mw6 sample
    twowayfeweights `outcome' judgefe year manne_post if mw6==1, ///
        controls(year judgefe) weight(WJT) type(feS)

    // grab 3×2 results matrix
    matrix M = e(M)

    post pf ("`outcome'") ("mw6") ///
        (e(beta))          /// coefficient
        (M[3,1])           /// total ATTs
        (M[1,1])           /// # positive
        (M[2,1])           /// # negative
        (M[1,2])           /// Σ positive weights
        (M[2,2])           /// Σ negative weights

    // full sample
    twowayfeweights `outcome' judgefe year manne_post, ///
        controls(year judgefe) weight(WJT) type(feS)

    matrix M = e(M)

    post pf ("`outcome'") ("full") ///
        (e(beta)) (M[3,1]) (M[1,1]) (M[2,1]) (M[1,2]) (M[2,2])
}


foreach outcome in y_ellickson_vec {

    // mw6 sample
    twowayfeweights `outcome' judgefe year manne_post if mw6==1 & econ_case & is_author == 1, ///
        controls(year judgefe) weight(WJT) type(feS)

    // grab 3×2 results matrix
    matrix M = e(M)

    post pf ("`outcome'") ("mw6") ///
        (e(beta))          /// coefficient
        (M[3,1])           /// total ATTs
        (M[1,1])           /// # positive
        (M[2,1])           /// # negative
        (M[1,2])           /// Σ positive weights
        (M[2,2])           /// Σ negative weights

    // full sample
    twowayfeweights `outcome' judgefe year manne_post  if econ_case & is_author == 1, ///
        controls(year judgefe) weight(WJT) type(feS)

    matrix M = e(M)

    post pf ("`outcome'") ("full") ///
        (e(beta)) (M[3,1]) (M[1,1]) (M[2,1]) (M[1,2]) (M[2,2])
}


postclose pf

use "`results'", clear
list  

export delimited "$output/twfe/twowayfeweights_results.csv", replace

//////////////////////////////////////////
// TWFE diagnostic from Jakiela
/////////////////////////////////////////

clear
use data/ready_circuits


gen manne_post_ever_attend = manne_post
replace manne_post_ever_attend = . if   attend_year ==.
gen manne_post_es6= manne_post_ever_attend
replace manne_post_es6= . if   manne_window6==0

local outcome y_labor_epa_lose y_convote_econ y_convote_nonecon y_ellickson_vec

gen ellick_sample = is_author & econ_case

local d manne_post_es6

eststo clear
foreach y in  `outcome' {
	
	if "`y'" == "y_ellickson_vec" {
		preserve 
		keep if ellick_sample 
	}
	*// look for negative weights by looking for negative residuals of treatment within treatment obs*/
	reghdfe  `d' [aw=WJT] if `y' !=. ,  a(circuityear judgefe ) cluster(judgefe) resid(res_d_`y')
	bys `d': sum (res_d_`y') [aw=WJT],d
	gen negw_t_`y'=(`d'==1 &`y' !=. & res_d_`y' <0)
	gen negw_c_`y'=(`d'==0 &`y' !=. & res_d_`y' >0)
	gen noneg_`y'= !negw_t_`y' & !negw_c_`y'
	sum negw_t_`y' [aw=WJT] if `d'==1 &`y' !=.
	local negmean_`y' = round(`r(mean)',.01)
	* twoway (kdensity res_d_`y' [aw=WJT] if `y' !=. & `d'==1) (kdensity res_d_`y' [aw=WJT] if `y' !=. & `d'==0, xline(0) text(5 .3 "Share treated w neg. weight `mean'"))
	*graph export "jakiela\\`y'_`d'_residuals_kdensity.png", replace

	****// if just issue of heterogeneity in variance, should see U-shape in year***/
	tab year [aw=WJT] if `d'==1 &`y' !=. & res_d_`y' <0
	sum year [aw=WJT] if `d'==1 &`y' !=. & res_d_`y' <0,d
	gen medy_`y' = `r(p50)'

	 *// test for heterogeneity by looking at residual correlation within treatment and control obs*/
	reghdfe  `y' [aw=WJT] if `y' !=. & `d'!=.,  a(circuityear judgefe ) cluster(judgefe) resid(res_y_`y')
	gen txres_d_`y' = `d'*res_d_`y'

	reg res_y_`y' res_d_`y' `d' txres_d_`y' [aw=WJT], cluster(judgefe)
	eststo
	local txbeta_`y' = _b[txres_d_`y']
	local het_beta_`y' = `negmean_`y'' * `txbeta_`y''
	estadd scalar Share_Neg_Resids = `negmean_`y''
	estadd scalar Het_X_Share_Neg_Resids = `het_beta_`y''
	* binscatter res_y_`y' res_d_`y' [aw=WJT], by(`d' ) line(qfit)
	*graph export "jakiela\\`y'_`d'_res_bytreat.png", replace
	
	if "`y'" == "y_ellickson_vec" {
		restore			
	}

}

* esttab using "output/twfe/jakiela_`d'.tex", keep(txres_d_*) se replace stats(Share_Neg_Resids Het_X_Share_Neg_Resids)
esttab using "output/twfe/jakiela_results.csv", keep(txres_d_*) se replace stats(Share_Neg_Resids Het_X_Share_Neg_Resids)
drop medy_* negw_* noneg_* res* txres*



//////////////////////////////////////////
// stacked DD results for Table A.8
/////////////////////////////////////////

use data/ready_circuits, clear


* Globals and vars gen ---- PLUS SPECIFIC VARS FOR stacked DD
global globals_and_vars=1
	if ${globals_and_vars}==1 {
	* Globals graphs
	global convote_options "graphregion(fcolor(white)) vertical legend(off) yline(0, lpattern(dash) lcolor(gray))"
	global coefplot_matrixes "(matrix(coefficients),ci(ci5) offset(-0.15)) (matrix(pretrend), offset(-0.15) noci recast(line) lpattern(dash) lcolor(blue) lwidth(0.15))"
	*global coefplot_matrixes_merged "(matrix(coefficients1),ci(ci51) ciopts(color(olive_teal)) color(olive_teal) offset(-0.30) msize(medium)) (matrix(coefficients2),ci(ci52) ciopts(color(ltblue)) color(ltblue) offset(-0.15) msize(medium)) (matrix(coefficients3),ci(ci53) ciopts(color(cranberry)) color(cranberry) offset(0) msize(large))"	 WITH PROMINENT ENET
	global coefplot_matrixes_merged "(matrix(coefficients1),ci(ci51) offset(-0.30) msize(medium)) (matrix(coefficients2),ci(ci52) offset(-0.15) msize(medium)) (matrix(coefficients3),ci(ci53) offset(0) msize(large))"
	global coefplot_matrixes_merged_at "(matrix(coefficients1),ci(ci51) offset(-0.30) msize(medium)) (matrix(coefficients2),ci(ci52) offset(-0.15) msize(medium))"
	global coefplot_matrixes_convote "(matrix(coefficients1_econ), ci(ci51_econ) ciopts(color(maroon)) msize(medium) symbol(circle_hollow) color(maroon) offset(-0.40)) (matrix(coefficients2_econ),ci(ci52_econ) ciopts(color(maroon)) msize(medium) symbol(diamond_hollow) color(maroon) offset(-0.30)) (matrix(coefficients1_nonecon),ci(ci51_nonecon) ciopts(color(teal)) symbol(circle_hollow) msize(medium) color(teal) offset(-0.05)) (matrix(coefficients2_nonecon),ci(ci52_nonecon) ciopts(color(teal)) symbol(diamond_hollow) msize(medium) color(teal) offset(0.05))"
	*global coefplot_matrixes_convote "(matrix(coefficients1_econ), ci(ci51_econ) ciopts(color(maroon)) msize(medium) symbol(circle_hollow) color(maroon) offset(-0.45)) (matrix(coefficients2_econ),ci(ci52_econ) ciopts(color(maroon)) msize(medium) symbol(diamond_hollow) color(maroon) offset(-0.40)) (matrix(coefficients1_nonecon),ci(ci51_nonecon) ciopts(color(teal)) symbol(circle_hollow) msize(medium) color(teal) offset(0.05)) (matrix(coefficients2_nonecon),ci(ci52_nonecon) ciopts(color(teal)) symbol(diamond_hollow) msize(medium) color(teal) offset(0.10))"
	*global coefplot_matrixes "(matrix(coefficients),ci(ci5))"
	global coefplot_matrixes_double "(matrix(coefficients_econ), ci(ci5_econ)) (matrix(coefficients_nonecon), ci(ci5_nonecon))"
	* Globals FE
	* 	global enetc8 "i.year#c.(x_pssc x_psatty x_plocct x_pccoun x_b10s x_b20s x_b30s x_b40s x_b50s)" older one before july rerun
	global enetc8 "i.year#c.(x_plocct x_pccoun x_b10s x_b20s x_b30s x_b40s x_b50s)"
	* Globals FE for iteration
	global cohortfe "attend_year#c.year"
	global basefe "circuityear judgefe"
	global basefe_enetc8 "circuityear judgefe $enetc8"
	global basefe_exper2fe "circuityear judgefe one#c.exper one#c.exper2"
	global basefe_exper2fe_enetc8 "circuityear judgefe one#c.exper one#c.exper2 $enetc8"
	global basefe_exper2fe_cohortfe "circuityear judgefe one#c.(exper exper2) attend_year#c.year"
	*global basefe_exper2fe_cohortfe "circuityear judgefe one#c.exper one#c.exper2 attend_year#c.year"
	global basefe_exper2fe_cohortfe_enetc8 "circuityear judgefe one#c.(exper exper2) attend_year#c.year $enetc8"
	* Globals of globals for FE
	global fes1 "basefe_exper2fe"
	global fes2 "basefe basefe_exper2fe basefe_exper2fe_enetc8"
	global fes3 "basefe_exper2fe_cohortfe basefe_exper2fe_cohortfe_enetc8"
	* Globals outcomes
	global outcome_2 y_labor_epa_lose y_convote_econ y_convote_nonecon y_ellickson_avg y_ellickson_vec j_posner_cited y_cons_antitrust econ_predicted_prob
	global outcome y_labor_epa_lose y_convote_econ y_convote_nonecon y_ellickson_avg y_ellickson_vec j_posner_cited y_cons_antitrust econ_predicted_prob

	* useful vars
	gen mw5nl=mw5
	gen mw5nr=mw5


* NEW VARS ******************************************************************
bys judgefe: egen first_year=min(year) /* note first_year is different from appointment year */
bys judgefe: egen last_year=max(year)

gen balanced_w=1 if first_year<=attend_year-6 & last_year>=attend_year+6

levelsof attend_year, local(treat)
global attend_years `treat'

forvalues num=6/6{
	foreach s of global attend_years{
	gen balanced_`num'w`s'=1 if first_year<=`s'-`num' & last_year>=`s'+`num'
	}
}
	foreach s of global attend_years{
	gen inwindow_6w`s'=.
	replace inwindow_6w`s'=1 if attend_year==`s'
	replace inwindow_6w`s'=1 if attend_year==`s'+1
	replace inwindow_6w`s'=1 if attend_year==`s'+2
	replace inwindow_6w`s'=1 if attend_year==`s'+3
	replace inwindow_6w`s'=1 if attend_year==`s'+4
	replace inwindow_6w`s'=1 if attend_year==`s'+5
	replace inwindow_6w`s'=1 if attend_year==`s'+6
	replace inwindow_6w`s'=1 if attend_year==`s'-1
	replace inwindow_6w`s'=1 if attend_year==`s'-2
	replace inwindow_6w`s'=1 if attend_year==`s'-3
	replace inwindow_6w`s'=1 if attend_year==`s'-4
	replace inwindow_6w`s'=1 if attend_year==`s'-5
	replace inwindow_6w`s'=1 if attend_year==`s'-6
	}
	foreach s of global attend_years{
	gen outwindow_6w`s'=.
	replace outwindow_6w`s'=1 if attend_year>`s'+6
	}
	foreach s of global attend_years{
	gen outbiwindow_6w`s'=.
	replace outbiwindow_6w`s'=1 if attend_year>`s'+6 |attend_year<`s'-6
	}
cap gen non_treat = manne==0  //change: indicator for non treated variables


levelsof attend_year, local(treat)
global attend_years `treat'

forvalues num=6/6{
	foreach s of global attend_years{
	gen sample2_`num'w_`s'=.
	replace sample2_`num'w_`s'=1 if non_treat==1 & balanced_`num'w`s'==1
	}
}

forvalues num=6/6{
	foreach s of global attend_years{
	gen sample3_`num'w_`s'=.
	replace sample3_`num'w_`s'=1 if non_treat==1
	replace sample3_`num'w_`s'=1 if manne==1 & balanced_`num'w`s'==1
	}
}

forvalues num=6/6{
	foreach s of global attend_years{
	gen sample6_`num'w_`s'=.
	replace sample6_`num'w_`s'=1 if manne==1
	}
}

forvalues num=6/6{
	foreach s of global attend_years{
	gen sample12_`num'w_`s'=.
	replace sample12_`num'w_`s'=1 if manne==1 & outbiwindow_6w`s'==1
	}
}

forvalues num=6/6{
	foreach s of global attend_years{
	gen sample13_`num'w_`s'=.
	replace sample13_`num'w_`s'=1 if manne==0
	}
}

forvalues num=6/6{
	foreach s of global attend_years{
	gen sample_attend_pre1987_`num'w_`s'=.
	replace sample_attend_pre1987_`num'w_`s'=1 if manne==0
	replace sample_attend_pre1987_`num'w_`s'=1 if manne==1 & attend_year<1987
	}
}

forvalues num=6/6{
	foreach s of global attend_years{
	gen sample_attend_post1987_`num'w_`s'=.
	replace sample_attend_post1987_`num'w_`s'=1 if manne==0
	replace sample_attend_post1987_`num'w_`s'=1 if manne==1 & attend_year>1987
	}
}

* save post_prep.dta, replace

global aggregation "attend_year"
global manne_window "mw6"
global clust "cl(judgefe)"

	}
*

local control_group 12
local aggregation "attend_year"
local manne_window "mw6"
local clust "cl(judgefe)"

levelsof `aggregation', local(treat)
global treat `treat'
global lags_leads "manne_L6 manne_L5 manne_L4 manne_L3 manne_L2 manne_0 manne_F1 manne_F2 manne_F3 manne_F4 manne_F5 manne_F6"
global outcome y_labor_epa_lose y_convote_econ y_convote_nonecon y_ellickson_vec econ_pp_17

*
file open dd_stacked using "$output/twfe/stacked_dd_results.tsv", write replace
file write dd_stacked  "Variable" _tab "Average dd coef" _tab "Average dd se" _tab "Average dd pvalue" _tab "N" _n
file close dd_stacked

foreach outcome of global outcome {
if "`outcome'"== "y_ellickson_vec" {
local author="author"
local sample="econ_case"
}
if "`outcome'"== "econ_pp_17" {
local author="author"
local sample="non_econ_case"
}
if "`outcome'"!="econ_pp_17" & "`outcome'"!="y_ellickson_vec" {
local author=1
local sample=1
}

di "`manne_window'"
di `author'
di `sample'
di "`outcome'"

local counter_`outcome'=0
eststo clear
foreach s of global treat {
di `s'
local counter_`outcome'=`counter_`outcome''+1
di `counter_`outcome''
cap qui: reghdfe `outcome' manne_post  if (`aggregation'== `s' & `manne_window' == 1 & `author'==1 & `sample'==1) |(sample`control_group'_6w_`s'==1 & `author'==1 & `sample'==1) [aw=WJT], nocons absorb($basefe) `clust'
count if (`aggregation'== `s' & `manne_window' == 1 & `author'==1 & `sample'==1) |(sample`control_group'_6w_`s'==1 & `author'==1 & `sample'==1)
local weight_`counter_`outcome''=r(N)
local s_`outcome'_`counter_`outcome''	=e(b)[1,1]
local se_`outcome'_`counter_`outcome''	=sqrt(e(V)[1,1])
local df_`outcome'_`counter_`outcome''	=e(df_r)
}
local average_dd_`outcome'=0
local average_se_dd_`outcome'=0
local average_df_dd_`outcome'=0
local total_sample_`outcome'=0
	forvalues num=1/`counter_`outcome''{
	local s_`outcome'_`num'	=`s_`outcome'_`num''*`weight_`num''
	local se_`outcome'_`num'	=`se_`outcome'_`num''*`weight_`num''
	local df_`outcome'_`num'	=`df_`outcome'_`num''*`weight_`num''
	}
	forvalues num=1/`counter_`outcome''{
	local total_sample_`outcome'=`total_sample_`outcome''+`weight_`num''
	local average_dd_`outcome'=`average_dd_`outcome''+`s_`outcome'_`num''
	local average_se_dd_`outcome'=`average_se_dd_`outcome''+`se_`outcome'_`num''
	local average_df_dd_`outcome'=`average_df_dd_`outcome''+`df_`outcome'_`num''
	}
local average_dd_`outcome'=`average_dd_`outcome''/`total_sample_`outcome''
local average_se_dd_`outcome'=`average_se_dd_`outcome''/`total_sample_`outcome''
local average_df_dd_`outcome'=`average_df_dd_`outcome''/`total_sample_`outcome''
local average_p_dd_`outcome' = (2 * ttail(`average_df_dd_`outcome'', abs(`average_dd_`outcome''/`average_se_dd_`outcome'')))
file open 	dd_stacked using "$output/twfe/stacked_dd_results.tsv", write append
file write	dd_stacked 		 "`outcome'" _tab  "`average_dd_`outcome''"	_tab  "`average_se_dd_`outcome''" _tab "`average_p_dd_`outcome''" _tab "`total_sample_`outcome''" _n
file close 	dd_stacked

}
*






