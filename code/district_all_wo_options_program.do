clear
set more off
set graphics off

// For Replicators: If you want to run this file outside of the main 
// programme, proceed as follows:
// 1. Comment out the following code chunk
// 2. Uncomment the programme
// 3. Replace the file-path inside the programme

global output $path/output

foreach subfolder in district_tables district_all district_lgraphs_histograms introduction {
cap mkdir "${output}/`subfolder'"
}

global data data
global district_data ready_districts
global circuit_data ready_circuits

use $data/$district_data, clear


// cap program drop load_district_drop_globals
// program load_district_drop_globals
//
// 	macro drop _all 
//
// 	************
// 	** setup ***
// 	************
//
// * For Replicators: If you want to run only this file, uncomment the code chunk 
// * below and reset the path
//
// 	global path "/Users/.../replication_manne"
// 	cd "${path}"
//
// 	*********************
// 	*** output folder ***
// 	*********************
//
// 	global output $path/output
//	
// 	foreach subfolder in district_tables district_all district_lgraphs_histograms introduction {
//     cap mkdir "${output}/`subfolder'"
// 	}
//
//
// 	************
// 	*** data ***
// 	************
//
// 	global data data
// 	global district_data ready_districts
// 	global circuit_data ready_circuits
//
// 	use $data/$district_data, clear
//
// end 
//
// load_district_drop_globals


cap log using "$output/output_district.log", replace

***************
*** buttons ***
***************

* A.2(b) & A.6
* lgraphs histograms
global lgraphs_histograms=0

* Table A.4(ab) & A.2(b)
** balance tables
global balances=0

* table 2
global table2=0

* Figure A.35
global table2_coefplot_drop_districts=0

**** table  A.15
global district_rc_sum3=0

** Table A.17 left half
global table_a17_left=0

** fedsoc Table A.17 right half
global table_a17=0

**** table A.16 (don't run on a regular computer)
global district_rc_sum3_add_poi=0

*** figure A.17
global figure_a17=0


global enet_selection=0
if ${enet_selection}==1 {

	cap log using "$output/enet_district.log", replace

	preserve
	duplicates drop judgefe, force
	set seed 1993
	elasticregress manne x_republican x_unity x_crossa  x_pssenate x_pslc x_pssc x_pshouse x_psg x_psgo x_psenate x_psatty x_pprivate x_pmayor x_plocct x_phouse x_pgov x_pda x_pcc x_pccoun x_pausa  x_pag x_pada x_pgovt x_black  x_b10s x_b20s x_b30s x_b40s x_b50s x_pbank x_pmag 
	local manne_elastic = e(varlist_nonzero)
	elasticregress attend_year x_republican x_unity x_crossa x_pssenate x_pslc x_pssc x_pshouse x_psg x_psgo x_psenate x_psatty x_pprivate x_pmayor x_plocct x_phouse x_pgov x_pda x_pcc x_pccoun x_pausa x_pag x_pada x_pgovt x_black x_b10s x_b20s x_b30s x_b40s x_b50s x_pbank x_pmag if attend_year >0
	local attend_year_elastic = e(varlist_nonzero)
	restore

	di "`manne_elastic'"
	di "`attend_year_elastic'"

	cap log close
}


* Globals and vars gen
global globals_and_vars=1
if ${globals_and_vars}==1 { 


	global yline_style "yline(0, lpattern(dash) lcolor(gray))"

	* Globals FE for iteration

	* global enet_covars "x_psatty x_pprivate x_pgov x_b10s x_b20s x_b40s x_b50s"
	* global enet "i.five_year#c.(x_psatty x_pprivate x_pgov x_b10s x_b20s x_b40s x_b50s)"

	** jun16 bios enet
	global enet_covars "x_psatty x_b10s x_b20s x_b40s x_b50s"
	global enet "i.five_year#c.(x_psatty x_b10s x_b20s x_b40s x_b50s)" 
	
	global basefe "districtyear judgefe" 
	global basefe_exper2fe "districtyear judgefe one#c.exper one#c.exper2"
	global basefe_exper2fe_enet "districtyear judgefe one#c.exper one#c.exper2 $enet"
	global basefe_enet "districtyear judgefe $enet"

	* summary table
	replace manne_post = 0 if missing(manne_time)
	bys districtyear: egen manne_total = total(manne_post)
	egen districtjudge = group(judgefe districtcode)
	egen judgeyear = group(districtjudge fiscalyear)
	bys judgeyear: egen num_cases = total(one)
	bys districtyear: egen cytotal = total(one)
	gen peer_manne_share = (manne_total - manne_post * num_cases) / (cytotal - num_cases)

	cap gen wjt5=WJT
	cap winsor2 wjt5, replace cuts(5 95)
	cap gen drugcrime = substr(trac_leadcharge,1,2) == "21"	

	global lags "manne_L4 manne_L3 manne_L2 manne_0 manne_F1 manne_F2 manne_F3  manne_F4 manne_F5"

	gen manne_pre4 = manne_time <= -4
	gen manne_post4 = manne_time >= 4

	global lags "manne_pre4 manne_L3 manne_L2 manne_0 manne_F1 manne_F2 manne_F3 manne_post4"

	gen five_year = fiscalyear - mod(fiscalyear,5)

}
	

* Figures A.2(b) & A.6
// global lgraphs_histograms=1
if ${lgraphs_histograms}==1{

	hist fiscalyear, freq lcolor(teal) color(olive_teal) discrete barwidth(0.5) xlabel(1990 1995 2000 2005) ylabel(10000 "10k" 20000 "20k" 30000 "30k" 40000 "40k" 50000 "50k" 60000 "60k" 70000 "70k" 80000 "80k" 90000 "90k" 100000"100k" )
	graph export "$output/district_lgraphs_histograms/district_histogram.pdf", replace


	* Lgraphs winsor
	global lgraphs_wjt=1
	if ${lgraphs_wjt}==1 {
			
		cap gen wjt5=WJT
		cap gen wjt10=WJT
		cap winsor2 wjt5, replace cuts(5 95)
		cap winsor2 wjt10, replace cuts(10 90)
		cap gen year=fiscalyear
		label var year "Year"
		cap gen caseid=datacaseid
		foreach weight in wjt5 {

			preserve 
			expand 5
			duplicates tag, gen(tag)
			drop if tag==5
			bys caseid songername: gen id=_n
			replace year=year-2 if id==1 & year<=1992
			replace year=year-1 if id==2 & year<=1992
			replace year=year+1 if id==4 & year<1992
			replace year=year+2 if id==5 & year<1991
			drop if id==5 & year==1991
			drop if id==5 & year==1992
			drop if id==4 & year==1992
			*
			replace year=year-2 if id==1 & year>1994
			replace year=year-1 if id==2 & year>1993
			replace year=year+1 if id==4 & year>=1993
			replace year=year+2 if id==5 & year>=1993	
			drop if id==1 & year==1994
			drop if id==1 & year==1993
			drop if id==2 & year==1993
				foreach outcome in any_sentence {
				lgraph  `outcome' year if (inlist(attend_year,1993,1994,1995,1996,1997,1998) | !everattend) [aw=`weight'], by(everattend) xline(1992, lpattern(dash) lcolor(gray)) sep(0.01) legend(order(1 "Never-attenders" 2 "Attenders"))
				graph export "$output/district_lgraphs_histograms/lgraph_smoothed_over5_`outcome'_attendyear_w6_1995_`weight'.pdf", replace	
				}
			restore

		}	

	}

}

* Table A.4(ab) & A.2(b)
// global balances=1
if ${balances}==1 {

	global left_vars x_republican x_unity x_crossa  x_pssenate x_pslc x_pssc x_pshouse x_psg x_psgo x_psenate x_psatty x_pprivate x_pmayor x_plocct x_phouse x_pgov
	global right_vars x_pda x_pcc x_pccoun x_pausa  x_pag x_pada x_pgovt x_black  x_b10s x_b20s x_b30s x_b40s x_b50s x_pbank x_pmag

	preserve
	eststo clear
	keep everattend attend_year x_republican x_unity x_crossa  x_pssenate x_pslc x_pssc x_pshouse x_psg x_psgo x_psenate x_psatty x_pprivate x_pmayor x_plocct x_phouse x_pgov x_pda x_pcc x_pccoun x_pausa  x_pag x_pada x_pgovt x_black  x_b10s x_b20s x_b30s x_b40s x_b50s x_pbank x_pmag judgefe
	collapse (mean) everattend attend_year x_republican x_unity x_crossa  x_pssenate x_pslc x_pssc x_pshouse x_psg x_psgo x_psenate x_psatty x_pprivate x_pmayor x_plocct x_phouse x_pgov x_pda x_pcc x_pccoun x_pausa  x_pag x_pada x_pgovt x_black  x_b10s x_b20s x_b30s x_b40s x_b50s x_pbank x_pmag, by(judgefe)

	label var x_republican "Republican" 
	label var x_unity "Unified Appointment"
	label var x_crossa "Cross-Party Appt"
	label var x_pssenate "State Senator"
	label var x_pslc "State Lower Ct"
	label var x_pssc "State Sup Court"
	label var x_pshouse "State House"
	label var x_psg "Solicit Gen."
	label var x_psgo "Solicitor Gen. Off."
	label var x_psenate "U.S. Senator"
	label var x_psatty "State Atty. Gen."
	label var x_pprivate "Priv. Practice"
	label var x_pmayor "Mayor"
	label var x_plocct "Local Court"
	label var x_phouse "U.S. House"
	label var x_pgov "Governor"
	label var x_pda "District Atty"
	label var x_pcc "Congressional Counsel"
	label var x_pccoun "City Council"
	label var x_pausa "Asst U.S. Atty"
	label var x_pag "Atty General"
	label var x_pada "Asst Dist Atty"
	label var x_pgovt "Any Govt"
	label var x_black "Black"
	label var x_pbank "Bnktcy Judge"
	label var x_pmag "Magistrate"

	forvalues i = 1/5 {
		label var x_b`i'0s "Born in 19`i'0s"
	}

	eststo everattend1: reg everattend x_republican x_unity x_crossa  x_pssenate x_pslc x_pssc x_pshouse x_psg x_psgo x_psenate x_psatty x_pprivate x_pmayor x_plocct x_phouse x_pgov x_pda x_pcc x_pccoun x_pausa  x_pag x_pada x_pgovt x_black  x_b10s x_b20s x_b30s x_b40s x_b50s x_pbank x_pmag
	estadd local allvars "X", replace

	** manually add enet covars from manne_elastic
	eststo everattend2: reg everattend x_republican x_unity x_pslc x_pssc x_pshouse x_psgo x_psenate x_psatty x_pprivate x_pmayor x_plocct x_phouse x_pcc x_pausa x_pag x_pgovt x_black x_b10s x_b20s x_b30s x_b40s x_pmag
	estadd local enet "X", replace

	eststo attendyear1: reg attend_year x_republican x_unity x_crossa  x_pssenate x_pslc x_pssc x_pshouse x_psg x_psgo x_psenate x_psatty x_pprivate x_pmayor x_plocct x_phouse x_pgov x_pda x_pcc x_pccoun x_pausa  x_pag x_pada x_pgovt x_black  x_b10s x_b20s x_b30s x_b40s x_b50s x_pbank x_pmag
	estadd local allvars "X", replace

	** manually add enet covars from attend_year_elastic
	eststo attendyear2: reg attend_year x_psatty x_b10s x_b20s x_b40s x_b50s
	estadd local enet "X", replace


	esttab using "$output/introduction/district_judge_level_balance.csv", b(4) se(4) nogaps replace plain star(+ 0.10 * 0.05 ** 0.01) parentheses



	esttab * using "$output/introduction/district_judge_level_balance_left.tex", replace type noisily ///
	keep($left_vars) se obs label ///
	star(+ 0.10 * 0.05 ** 0.01) ///
	mlabels(none) ///
	mgroups("Ever Attend" "Attendance Year", pattern(1 0 1 0) span ///
			prefix(\multicolumn{@span}{c}{\uline{\textit{) suffix(}}})) ///
	stats(allvars enet N r2_a, labels("All Variables" "Post Elastic Net" "N" "adj. R-sq") fmt(0 0 0 3)) ///
	nonotes substitute(_ \_ [1em] ) booktabs


	esttab * using "$output/introduction/district_judge_level_balance_right.tex", replace type noisily ///
	keep($right_vars) se obs label ///
	star(+ 0.10 * 0.05 ** 0.01) ///
	nonumbers mlabels(1 2 3 4, prefix("(") suffix("\text{ cont.})")) ///
	mgroups("Ever Attend" "Attendance Year", pattern(1 0 1 0) span ///
			prefix(\multicolumn{@span}{c}{\uline{\textit{) suffix(}}})) ///
	stats(allvars enet N r2_a, labels("All Variables" "Post Elastic Net" "N" "adj. R-sq") fmt(0 0 0 3)) ///
	nonotes substitute(_ \_ [1em] ) booktabs


	restore 

// 	* Tab the main crime categories
// 	eststo clear
// 	estpost tab drug
// 	eststo m1
// 	estpost tab immigration
// 	eststo m2
// 	estpost tab fraud
// 	eststo m3
// 	estpost tab weapon
// 	eststo m4
// 	esttab using "$output/introduction/crime_type_tabs.csv", cells("b(label(freq)) pct(fmt(2))") varlabels(`e(labels)', blist(Tota))  nogaps nostar not nonumber noobs  replace

	* sum outcomes
	eststo clear
	estpost su any_sentence senttot0_log
	esttab  using "$output/introduction/district_outcomes_sum.csv", cells("count mean sd") noobs replace


}




* table 2
// global table2=1
if ${table2}==1{

	label var manne_post "Post Manne"
	label var any_sentence "Any Prison Given"

	cap rename sent_length_mp slength
	label var slength "Sentence Length"

	estimates clear
	eststo clear

	* baseline
	eststo any_sentence_all: reghdfe any_sentence manne_post if mw5 == 1 [aw=WJT], absorb($basefe)  cluster(judgefe) noconstant
	estadd local crimetype "All", replace
	estadd local courtyearfe "X", replace
	estadd local judgefe "X", replace

	* baseline
	eststo any_sentence_nondrug: reghdfe any_sentence manne_post if mw5 == 1 & drugcrime==0 [aw=WJT], absorb($basefe)  cluster(judgefe) noconstant 
	estadd local crimetype "Non-Drug", replace
	estadd local courtyearfe "X", replace
	estadd local judgefe "X", replace

	* baseline
	eststo any_sentence_drug: reghdfe any_sentence manne_post if mw5 == 1 & drugcrime==1 [aw=WJT], absorb($basefe)  cluster(judgefe) noconstant 
	estadd local crimetype "Drug", replace
	estadd local courtyearfe "X", replace
	estadd local judgefe "X", replace

	* baseline
	eststo slength_mw5_base:  ppmlhdfe slength manne_post if mw5 == 1, absorb($basefe)  cluster(judgefe) noconstant 
	estadd local crimetype "All", replace
	estadd local courtyearfe "X", replace
	estadd local judgefe "X", replace
			
	esttab * using "$output/district_tables/table2.csv", se obs numbers mtitles label scalar("crimetype Crime Type" "courtyearfe Court-Year FE" "judgefe Judge FE") plain parentheses star noisily replace

	esttab * using "$output/district_tables/table2.tex", replace type noisily ///
	keep(manne_post) se obs numbers label ///
	prehead(`"\begin{center}"' ///
			\resizebox{0.75\textwidth}{!}{ ///
			\begin{tabular}{l*{4}{c}} ///
			\toprule ///
			) ///
	mlabels(none) ///
	mgroups("Any Prison Given" "Sentence Length", pattern(1 0 0 1) span ///
			prefix(\multicolumn{@span}{c}{\uline{\textit{) suffix(}}})) ///
	posthead("\cmidrule(lr){2-4} \cmidrule(lr){5-5}") ///
	prefoot("\cmidrule(lr){1-4} \cmidrule(lr){5-5}") ///
	stats(N crimetype courtyearfe judgefe,  ///
		  labels("N" "Crime Type" "Court-Year FE" "Judge FE")) /// 
	postfoot(`"\bottomrule"' ///
			\end{tabular} ///
			} ///
			\end{center} ///
			) ///
	nonotes nostar

}



* Figure A.35 district_drop_districts
// global table2_coefplot_drop_districts=1
if ${table2_coefplot_drop_districts}==1{

	egen district = group(districtcode)

	reghdfe any_sentence manne_post if mw5 == 1 [aw=WJT], absorb($basefe)  cluster(judgefe) noconstant

	levelsof district if e(sample)
	local district_levels = r(levels)

	eststo clear
	foreach d of local district_levels {

	    eststo est_`d': reghdfe any_sentence manne_post if mw5 == 1 & district != `d' [aw=WJT], absorb($basefe)  cluster(judgefe) noconstant 

	}

	coefplot *, legend(off) xline(0, lpattern(dash) lcolor(black)) levels(95 90) ytitle("") mcolor(maroon) ciopts(color(gs2 gs1)) msize(small) msymbol(o) xscale(range(0))
	graph export "$output/district_all/coefplot_drop_districts.pdf", replace 

}



**** table  A.15
// global district_rc_sum3=1
if ${district_rc_sum3}==1 {	

	cap gen wjt1=WJT
	cap winsor2 wjt1, replace cuts(1 99)

	foreach outcome in any_sentence {
		foreach sample_restriction in one mw5 manne   {

			* baseline
			eststo `outcome'_`sample_restriction'_base:    reghdfe `outcome' manne_post if `sample_restriction' == 1 [aw=WJT], absorb($basefe)  cluster(judgefe) noconstant 
			estadd ysumm, mean sd
			estadd local basefe "X", replace

			* party x 5year
			eststo `outcome'_`sample_restriction'_5party:   reghdfe `outcome' manne_post if `sample_restriction' == 1 [aw=WJT], absorb($basefe five_year#c.x_republican)  cluster(judgefe) noconstant
			estadd ysumm, mean sd
			estadd local basefe "X", replace
			estadd local partytimefe "X", replace

			* enet per 5year
			eststo `outcome'_`sample_restriction'_5enet:   reghdfe `outcome' manne_post if `sample_restriction' == 1 [aw=WJT],  absorb($basefe_enet)  cluster(judgefe) noconstant
			estadd ysumm, mean sd
			estadd local basefe "X", replace
			estadd local enettimefe "X", replace

			* topic /charge fe	
			eststo `outcome'_`sample_restriction'_topic:   reghdfe `outcome' manne_post if `sample_restriction' == 1 [aw=WJT], absorb($basefe trac_leadcharge)  cluster(judgefe) noconstant
			estadd ysumm, mean sd
			estadd local basefe "X", replace
			estadd local topicfe "X", replace

			* no weight
			eststo `outcome'_`sample_restriction'_noweight:   reghdfe `outcome' manne_post if `sample_restriction' == 1, absorb($basefe)  cluster(judgefe) noconstant
			estadd ysumm, mean sd
			estadd local basefe "X", replace
			estadd local noweight "X", replace

			* winsorized weights
			eststo `outcome'_`sample_restriction'_winw:   reghdfe `outcome' manne_post if `sample_restriction' == 1 [aw=wjt1], absorb($basefe)  cluster(judgefe) noconstant
			estadd ysumm, mean sd
			estadd local basefe "X", replace
			estadd local winsorw "X", replace

			* robust se
			eststo `outcome'_`sample_restriction'_robust:   reghdfe `outcome' manne_post if `sample_restriction' == 1 [aw=WJT], absorb($basefe) vce(robust) noconstant
			estadd ysumm, mean sd
			estadd local basefe "X", replace
			estadd local robust "X", replace

			* cluster circuityear and judge
			eststo `outcome'_`sample_restriction'_2cluster:   reghdfe `outcome' manne_post if `sample_restriction' == 1 [aw=WJT], absorb($basefe) cluster(judgefe districtyear) noconstant
			estadd ysumm, mean sd
			estadd local basefe "X", replace
			estadd local clustertw "X", replace

			* Tables	add N, r-squared, mean of outcome, and SD of outcome ---- 
// 			esttab `outcome'_`sample_restriction'* using "$output/district_tables/`outcome'_`sample_restriction'.csv", cells(b(star fmt(%15.3f)) se(par)) stats(p r2_a ymean ysd N, labels(P-value "Adj. R-squared" Y-mean Y-sd N)) starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) nodepvar replace plain
		}
	}

	{
		label var manne_post "Post Manne"

		esttab any_sentence_mw5_* using "$output/district_tables/table_a15.tex", ///
		replace type noisily ///
		b(3) se(4) ///
		keep(manne_post) se obs label ///
		prehead(`"\begin{center}"' ///
				\resizebox{\textwidth}{!}{ ///
				\begin{tabular}{l*{8}{c}} ///
				\toprule ///
				) ///
		mlabels(none) ///
		numbers ///
		mgroups("A. Short-Run Effects on Attenders", pattern(1 0 0 0 0 0 0 0) ///
				span prefix(\multicolumn{@span}{c}{\uline{\textit{) suffix(}}})) ///
		posthead("\cmidrule(lr){2-9}") ///
		prefoot("\cmidrule(lr){1-9}") ///
		stats(N, labels("N (Sentences)") fmt(0)) ///
		postfoot("") ///
		nonotes starlevels(+ .1 * .05 ** .01) 

		esttab any_sentence_manne_* using "$output/district_tables/table_a15.tex", ///
		append type noisily ///
		b(3) se(4) ///
		keep(manne_post) se obs label ///
		prehead("") ///
		nonumbers mlabels(9 10 11 12 13 14 15 16, prefix("(") suffix(")")) ///
		mgroups("B. Long-Run Effects on Attenders", pattern(1 0 0 0 0 0 0 0) ///
				span prefix(\multicolumn{@span}{c}{\uline{\textit{) suffix(}}})) ///
		posthead("\cmidrule(lr){2-9}") ///
		prefoot("\cmidrule(lr){1-9}") ///
		stats(N, labels("N (Sentences)") fmt(0)) ///
		postfoot("") ///
		nonotes starlevels(+ .1 * .05 ** .01) 


		esttab any_sentence_one_* using "$output/district_tables/table_a15.tex", ///
		append type noisily ///
		b(3) se(4) ///
		keep(manne_post) se obs label ///
		prehead("") ///
		nonumbers mlabels(17 18 19 20 21 22 23 24, prefix("(") suffix(")")) ///
		mgroups("B. Long-Run Effects, Including Never-Attenders", pattern(1 0 0 0 0 0 0 0) ///
				span prefix(\multicolumn{@span}{c}{\uline{\textit{) suffix(}}})) ///
		posthead("\cmidrule(lr){2-9}") ///
		prefoot("\cmidrule(lr){1-9}") ///
		stats(N basefe partytimefe enettimefe ///
				topicfe noweight winsorw ///
				robust clustertw, ///
				labels("N (Sentences)" "Circuit-Year/Judge FE" "Party-Time FE" "Enet-Time FE" ///
					     "Charge FE" "No Weighting" "Winsorized Weights" ///
					     "Robust SE" "Two-Way Cluster SE's") fmt(0)) ///
		postfoot(`"\bottomrule"' ///
				\end{tabular} ///
				} ///
				\end{center} ///
				) ///
		nonotes starlevels(+ .1 * .05 ** .01)
	}


}	

** table A.17 left half
** i only have 1197 observations in this regressions as opposed to 1426 in Table A.17 left half
** districtcode is missing for a lot of observations
if ${table_a17_left}==1{



	use data/ready_elevated
	eststo clear
	eststo: reghdfe elevated  manne x_republican , absorb(decade_start districtfe) cl(songername) nocons
	eststo: reghdfe elevated c.manne##c.x_republican , absorb(decade_start districtfe) cl(songername) nocons
	eststo: reghdfe elevated c.manne##c.x_republican , absorb(decade_start districtfe x_b*s) cl(songername) nocons
	esttab 

	esttab using "$output/district_tables/elevated1.csv", se replace star(+ 0.10 * 0.05 ** 0.01)


}




** fedsoc results -- A.18 right half
if ${table_a17}==1{

	use $data/ready_fedsoc
	
	eststo clear
	
	eststo: reghdfe fedsoc manne x_republican , absorb(decade_start courtid) cl(songername) nocons
	eststo: reghdfe fedsoc manne##x_republican , absorb(decade_start courtid) cl(songername) nocons
	eststo: reghdfe fedsoc manne##x_republican , absorb(decade_start courtid x_b*s) cl(songername) nocons

	esttab using "$output/district_tables/fedsoc_manne.csv", se replace star(+ 0.10 * 0.05 ** 0.01)

}



**** table A.16
if ${district_rc_sum3_add_poi}==1 {	

	cap rename sent_length_mp slength
	cap gen wjt1=WJT
	cap winsor2 wjt1, replace cuts(1 99)

	foreach year in 1990 1995 2000 {
		foreach var in $enet_covars x_republican{
		cap gen `var'_`year'= `var' if fiscalyear==`year'
		replace `var'_`year'=0 if `var'_`year'==.
		}
	}

	
	global enet_manual ""

	foreach year in 1990 1995 2000 {
		foreach var in $enet_covars {
		global enet_manual "$enet_manual `var'_`year'"
		}
	}

	macro list enet_manual 

	foreach outcome in slength {
		foreach sample_restriction in one manne mw5 {

		* baseline
		eststo `outcome'_`sample_restriction'_base: ppmlhdfe `outcome' manne_post if `sample_restriction' == 1, absorb($basefe) cluster(judgefe) noconstant 
		estadd ysumm, mean sd
		estadd local basefe "X", replace

		* party x 5year (manual)
		eststo `outcome'_`sample_restriction'_5party_manual: ppmlhdfe `outcome' manne_post if `sample_restriction' == 1, absorb($basefe x_republican_1990 x_republican_1995 x_republican_2000) cluster(judgefe) noconstant
		estadd ysumm, mean sd
		estadd local basefe "X", replace
		estadd local partytimefe "X", replace

		* enet per 5year
		eststo `outcome'_`sample_restriction'_5enet: ppmlhdfe `outcome' manne_post if `sample_restriction' == 1, absorb(districtyear judgefe $enet_manual) cluster(judgefe) noconstant
		estadd ysumm, mean sd
		estadd local basefe "X", replace
		estadd local enettimefe "X", replace

		* topic /charge fe	
		eststo `outcome'_`sample_restriction'_topic: ppmlhdfe `outcome' manne_post if `sample_restriction' == 1, absorb($basefe trac_leadcharge) cluster(judgefe) noconstant
		estadd ysumm, mean sd
		estadd local basefe "X", replace
		estadd local topicfe "X", replace

		* robust se
		eststo `outcome'_`sample_restriction'_robust: ppmlhdfe `outcome' manne_post if `sample_restriction' == 1, absorb($basefe) vce(robust) noconstant
		estadd ysumm, mean sd
		estadd local basefe "X", replace
		estadd local robust "X", replace

		* cluster circuityear and judge
		eststo `outcome'_`sample_restriction'_2cluster: ppmlhdfe `outcome' manne_post if `sample_restriction' == 1, absorb($basefe) cluster(judgefe districtyear) noconstant
		estadd ysumm, mean sd
		estadd local basefe "X", replace
		estadd local clustertw "X", replace


		* Tables	add N, r-squared, mean of outcome, and SD of outcome ---- 
		esttab * using "$output/district_tables/`outcome'_`sample_restriction'_poisson_noweight.csv", cells(b(star fmt(%15.3f)) se(par)) stats(p r2_a ymean ysd N, labels(P-value "Adj. R-squared" Y-mean Y-sd N)) starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace nodepvar plain parentheses
		}
	}

	{
		label var manne_post "Post Manne"

		esttab slength_mw5_* using "$output/district_tables/table_a16.tex", ///
		replace type noisily ///
		b(3) se(4) ///
		keep(manne_post) se obs label ///
		prehead(`"\begin{center}"' ///
				\resizebox{\textwidth}{!}{ ///
				\begin{tabular}{l*{6}{c}} ///
				\toprule ///
				) ///
		mlabels(none) ///
		numbers ///
		mgroups("A. Short-Run Effects on Attenders", pattern(1 0 0 0 0 0 0 0) ///
				span prefix(\multicolumn{@span}{c}{\uline{\textit{) suffix(}}})) ///
		posthead("\cmidrule(lr){2-7}") ///
		prefoot("\cmidrule(lr){1-7}") ///
		stats(N, labels("N (Sentences)") fmt(0)) ///
		postfoot("") ///
		nonotes starlevels(+ .1 * .05 ** .01) 

		esttab slength_manne_* using "$output/district_tables/table_a16.tex", ///
		append type noisily ///
		b(3) se(4) ///
		keep(manne_post) se obs label ///
		prehead("") ///
		nonumbers mlabels(7 8 9 10 11 12, prefix("(") suffix(")")) ///
		mgroups("B. Long-Run Effects on Attenders", pattern(1 0 0 0 0 0 0 0) ///
				span prefix(\multicolumn{@span}{c}{\uline{\textit{) suffix(}}})) ///
		posthead("\cmidrule(lr){2-7}") ///
		prefoot("\cmidrule(lr){1-7}") ///
		stats(N, labels("N (Sentences)") fmt(0)) ///
		postfoot("") ///
		nonotes starlevels(+ .1 * .05 ** .01) 


		esttab slength_one_* using "$output/district_tables/table_a16.tex", ///
		append type noisily ///
		b(3) se(4) ///
		keep(manne_post) se obs label ///
		prehead("") ///
		nonumbers mlabels(13 14 15 16 17 18, prefix("(") suffix(")")) ///
		mgroups("B. Long-Run Effects, Including Never-Attenders", pattern(1 0 0 0 0 0 0 0) ///
				span prefix(\multicolumn{@span}{c}{\uline{\textit{) suffix(}}})) ///
		posthead("\cmidrule(lr){2-7}") ///
		prefoot("\cmidrule(lr){1-7}") ///
		stats(N basefe partytimefe enettimefe ///
				topicfe robust clustertw, ///
				labels("N (Sentences)" "Circuit-Year/Judge FE" "Party-Time FE" "Enet-Time FE" ///
					     "Charge FE" "Robust SE" "Two-Way Cluster SE's") fmt(0)) ///
		postfoot(`"\bottomrule"' ///
				\end{tabular} ///
				} ///
				\end{center} ///
				) ///
		nonotes starlevels(+ .1 * .05 ** .01)
	}



}	



preserve
**** figure A.17
// global figure_a17=1
if ${figure_a17}==1 {	

	set varabbrev off 
	use $data/$district_data, clear
	keep judgefe x_*  judgefe attend_year songername year_start districtcode
	duplicates drop judgefe attend_year songername year_start, force
	duplicates tag songername, gen(tag)
	keep if tag==0
	drop tag
	merge 1:n songername using $data/_district_econtext.dta,
	keep if _merge==3
	drop _merge

	* districtyear
	egen districtyear_civil=group(districtcode  year)

	* WJT
	bysort judgefe year: egen judgeyearcount = count(judgefe)
	gen WJT = 1 / judgeyearcount


	* experience
	bys judgefe: gen exper = year - year_start
	gen exper2 = exper^2

	* data cleaning for new dataset
	gen manne_time = year - attend_year
	gen manne_window = manne_time >= -3 & manne_time <= 3
	gen manne_window6 = manne_time >= -6 & manne_time <= 6
	gen manne_window5 = manne_time >= -5 & manne_time <= 5

	gen manne_L6 = manne_time == -6
	gen manne_L5 = manne_time == -5
	gen manne_L4 = manne_time == -4
	gen manne_L3 = manne_time == -3
	gen manne_L2 = manne_time == -2
	gen manne_L1 = manne_time == -1
	gen manne_0 = manne_time == 0
	gen manne_F1 = manne_time == 1
	gen manne_F2 = manne_time == 2
	gen manne_F3 = manne_time == 3
	gen manne_F4 = manne_time == 4
	gen manne_F5 = manne_time == 5
	gen manne_F6 = manne_time == 6

	gen mw6=manne_window6
	gen mw5=manne_window5

	gen one=1
	rename year fiscalyear

	gen manne = !missing(attend_year)
	gen manne_neg6 = manne_time <  -6
	gen manne_post6 = manne_time >  6 & !missing(manne_time)

	egen econsim_std = std(sim_score_2)
	gen random = runiform(0,1000)

	gen manne_post = manne_time > 0

	gen five_year = fiscalyear - mod(fiscalyear,5)

	* Globals FE for iteration

	* global enet_covars "x_psatty x_pprivate x_pgov x_b10s x_b20s x_b40s x_b50s"
	* global enet "i.five_year#c.(x_psatty x_pprivate x_pgov x_b10s x_b20s x_b40s x_b50s)"

	** jun16 bios enet
	global enet_covars "x_psatty x_b10s x_b20s x_b40s x_b50s"
	global enet "i.five_year#c.(x_psatty x_b10s x_b20s x_b40s x_b50s)" 

	* baseline
	eststo clear

	eststo estA: reghdfe econsim_std  manne_neg6 manne_L6 manne_L5 manne_L4 manne_L3 manne_L2 random manne_0 manne_F1 manne_F2 manne_F3 manne_F4 manne_F5 manne_F6 manne_post6 if manne , nocons a(judgefe districtyear_civil ) cl(songername)

	* coefplot estA,  vertical xline(6, lpattern(dash) lcolor(gray)) yline(0, lpattern(dash) lcolor(gray)) drop(manne_neg6 manne_post6)

	* e-net controls 
	eststo estB: reghdfe econsim_std  manne_neg6 manne_L6 manne_L5 manne_L4 manne_L3 manne_L2 random manne_0 manne_F1 manne_F2 manne_F3 manne_F4 manne_F5 manne_F6 manne_post6 if manne , nocons a(judgefe districtyear_civil $enet) cl(songername)

	* coefplot estB,  vertical xline(6, lpattern(dash) lcolor(gray)) yline(0, lpattern(dash) lcolor(gray)) drop(manne_neg6 manne_post6)

	* with weighting 
	reghdfe econsim_std  manne_neg6 manne_L6 manne_L5 manne_L4 manne_L3 manne_L2 random manne_0 manne_F1 manne_F2 manne_F3 manne_F4 manne_F5 manne_F6 manne_post6 if manne [aw=WJT], nocons a(judgefe districtyear_civil ) cl(songername)

	coefplot estA estB,  vertical xline(6, lpattern(dash) lcolor(gray)) yline(0, lpattern(dash) lcolor(gray)) drop(manne_neg6 manne_post6) xsize(6) legend(order(2 "Baseline" 4 "E-Net-Selected Controls")) xlabel(1 "-6" 2 "-5" 3 "-4" 4 "-3" 5 "-2" 6 "-1" 7 "0" 8 "1" 9 "2" 10 "3" 11 "4" 12 "5" 13 "6") xtitle("Years Before and After Manne Attendance") 

	graph export "$output/district_all/district_econsim_main.pdf", replace

}
restore


capture log close

