clear
set more off
set graphics off

// For Replicators: If you want to run this file outside of the main 
// programme, proceed as follows:
// 1. Comment out the following code chunk
// 2. Uncomment the programme
// 3. Replace the file-path inside the programme

global output $path/output

foreach subfolder in circuit_tables circuit_introduction spillovers {
cap mkdir "${output}/`subfolder'"
}

global data data
global district_data ready_districts
global circuit_data ready_circuits

use $data/$circuit_data, clear

// cap program drop load_circuit_drop_globals
// program load_circuit_drop_globals
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
// 	adopath + "${path}/schemes_grec"
// 	set scheme aspen, perm
// 	grstyle init
// 	grstyle set plain, horizontal grid
//
// 	*********************
// 	*** output folder ***
// 	*********************
//
// 	global output $path/output
//	
// 	foreach subfolder in circuit_tables circuit_introduction spillovers {
//     cap mkdir "${output}/`subfolder'"
// 	}
//	
// 	************
// 	*** data ***
// 	************
//
// 	global data data
// 	global district_data ready_districts
// 	global circuit_data ready_circuits
//
// 	use $data/$circuit_data, clear
//
//
// end
//
// load_circuit_drop_globals

qui do "$path/code/new_programs.do"

cap log using "$output/output_tables.log", replace


***************
*** buttons ***
***************

global enet_selection=1

* Tables A.1(ab), A.2(a), A.3, A.5
global balances=1

* Table 1
global table1=1

* Tables A.8, A.9, A.10, A.11, A.12, A.13
global circuit_rc_sum3_part1=1
global circuit_rc_sum3_part2=1

* Table A.6
global circuit_rc_manne_share=1


if ${enet_selection}==1 {

	cap log using "$output/enet_circuit.log", replace

// 	load_circuit_drop_globals

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

* balances 
* Figures A.1(ab), A.2(a), A.3, A.5
if ${balances}==1 {

	global left_vars x_republican x_unity x_crossa  x_pssenate x_pslc x_pssc x_pshouse x_psg x_psgo x_psenate x_psatty x_pprivate x_pmayor x_plocct x_phouse x_pgov
	global right_vars x_pda x_pcc x_pccoun x_pausa  x_pag x_pada x_pgovt x_black  x_b10s x_b20s x_b30s x_b40s x_b50s x_pbank x_pmag

	eststo clear
	preserve
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
	eststo everattend2: reg everattend x_republican x_pssenate x_pslc x_pshouse x_psg x_psgo x_psenate x_psatty x_pmayor x_plocct x_phouse x_pda x_pcc x_pausa x_pada x_pgovt x_black x_b10s x_b20s x_b30s x_b50s x_pbank x_pmag
	estadd local enet "X", replace

	eststo attendyear1: reg attend_year x_republican x_unity x_crossa  x_pssenate x_pslc x_pssc x_pshouse x_psg x_psgo x_psenate x_psatty x_pprivate x_pmayor x_plocct x_phouse x_pgov x_pda x_pcc x_pccoun x_pausa  x_pag x_pada x_pgovt x_black  x_b10s x_b20s x_b30s x_b40s x_b50s x_pbank x_pmag
	estadd local allvars "X", replace

	** manually add enet covars from attend_year_elastic
	eststo attendyear2: reg attend_year x_psatty x_pgov x_b10s x_b20s x_b40s x_b50s
	estadd local enet "X", replace

	esttab everattend* attendyear* using "$output/circuit_introduction/circuit_judge_level_balance.csv", b(3) se(4) ar2 nogaps replace plain star(+ 0.10 * 0.05 ** 0.01) parentheses


	esttab everattend* attendyear* using "$output/circuit_introduction/circuit_judge_level_balance_left.tex", replace type noisily ///
	keep($left_vars) se obs label ///
	star(+ 0.10 * 0.05 ** 0.01) ///
	mlabels(none) ///
	mgroups("Ever Attend" "Attendance Year", pattern(1 0 1 0) span ///
			prefix(\multicolumn{@span}{c}{\uline{\textit{) suffix(}}})) ///
	stats(allvars enet N r2_a, labels("All Variables" "Post Elastic Net" "N" "adj. R-sq") fmt(0 0 0 3)) ///
	nonotes substitute(_ \_ [1em] ) booktabs


	esttab everattend* attendyear* using "$output/circuit_introduction/circuit_judge_level_balance_right.tex", replace type noisily ///
	keep($right_vars) se obs label ///
	star(+ 0.10 * 0.05 ** 0.01) ///
	nonumbers mlabels(1 2 3 4, prefix("(") suffix("\text{ cont.})")) ///
	mgroups("Ever Attend" "Attendance Year", pattern(1 0 1 0) span ///
			prefix(\multicolumn{@span}{c}{\uline{\textit{) suffix(}}})) ///
	stats(allvars enet N r2_a, labels("All Variables" "Post Elastic Net" "N" "adj. R-sq") fmt(0 0 0 3)) ///
	nonotes substitute(_ \_ [1em] ) booktabs


	restore


	* Tab geniis and topic
	preserve 
	keep if year>1969 & year<2006

	label var geniss1 "Songer Topic"
	label define geniss1 1 "Criminal Appeal" 2 "Civil Rights" 3 "First Amendment" 4 "Due Process" 5 "Privacy" 6 "Labor" 7 "Regulation" 9 "Miscellaneous", replace 
	label values geniss1 geniss1

	eststo clear 
	tab geniss1, sort
	tab topic, sort 
	duplicates drop caseid, force 
	estpost tab geniss1, sort
	ereturn list  
	eststo m1

	esttab using "$output/circuit_introduction/geniss_tab.csv", cells("b(label(freq)) pct(fmt(2))") nogaps nostar not nonumber noobs  replace
	eststo clear
	estpost tab topic, sort
	ereturn list 
	eststo m2
	esttab using "$output/circuit_introduction/topic_tab.csv", cells("b(label(freq)) pct(fmt(2))") varlabels(`e(labels)', blist(Tota))  nogaps nostar not nonumber noobs  replace
	restore

	* sum outcomes
	eststo clear
	estpost su y_labor_epa_lose y_convote_econ y_convote_nonecon y_cons_antitrust2 y_ellickson_vec econ_pp_17
	esttab  using "$output/circuit_introduction/circuit_outcomes_sum.csv", cells("count mean sd") noobs replace


	* table A.5
	eststo clear 

	eststo ellickson_manne1: reghdfe y_ellickson_vec manne if  is_author & manne_post == 0 [aw=WJT], absorb(circuityear) cluster(judgefe) nocons
	estadd local circuityearfe "X", replace
	estadd local neverattend "X", replace
	estadd local notyetattend "X", replace

	eststo ellickson_manne2: reghdfe y_ellickson_vec manne x_republican x_b*s if  is_author & manne_post == 0 [aw=WJT], absorb(circuityear) cluster(judgefe) nocons
	estadd local circuityearfe "X", replace
	estadd local neverattend "X", replace
	estadd local notyetattend "X", replace

	eststo ellickson_attend1: reghdfe y_ellickson_vec attend_year if  is_author & manne_post == 0 [aw=WJT], absorb(circuityear) cluster(judgefe) nocons
	estadd local circuityearfe "X", replace
	estadd local neverattend "", replace
	estadd local notyetattend "X", replace

	eststo ellickson_attend2: reghdfe y_ellickson_vec attend_year x_republican x_b*s if  is_author & manne_post == 0 [aw=WJT], absorb(circuityear) cluster(judgefe) nocons
	estadd local circuityearfe "X", replace
	estadd local neverattend "", replace
	estadd local notyetattend "X", replace

	eststo labor_manne1: reghdfe y_labor_epa_lose manne if manne_post == 0 [aw=WJT], absorb(circuityear) cluster(judgefe) nocons
	estadd local circuityearfe "X", replace
	estadd local neverattend "X", replace
	estadd local notyetattend "X", replace

	eststo labor_manne2: reghdfe y_labor_epa_lose manne x_republican x_b*s if manne_post == 0 [aw=WJT], absorb(circuityear) cluster(judgefe) nocons
	estadd local circuityearfe "X", replace
	estadd local neverattend "X", replace
	estadd local notyetattend "X", replace

	eststo labor_attend1: reghdfe y_labor_epa_lose attend_year if  manne_post == 0 [aw=WJT], absorb(circuityear) cluster(judgefe) nocons
	estadd local circuityearfe "X", replace
	estadd local neverattend "", replace
	estadd local notyetattend "X", replace

	eststo labor_attend2: reghdfe y_labor_epa_lose attend_year x_republican x_b*s if manne_post == 0 [aw=WJT], absorb(circuityear) cluster(judgefe) nocons 
	estadd local circuityearfe "X", replace
	estadd local neverattend "", replace
	estadd local notyetattend "X", replace

	label var manne "Ever-Attender"
	label var attend_year "Attendance Year"
	label var x_republican "Republican"

	forvalues i = 1/5 {
		label var x_b`i'0s "Born in 19`i'0s"
	}

	esttab * using "$output/circuit_introduction/new-balance.csv", ///
	r2 replace star(+ 0.10 * 0.05 ** 0.01) parentheses plain b(3) se(4) nogaps

	esttab * using "$output/circuit_introduction/new-balance.tex", ///
	replace type noisily ///
	b(3) se(4) ///
	order(manne attend_year x_republican x_b*s) se obs numbers label ///
	prehead(`"\begin{center}"' ///
			\resizebox{\textwidth}{!}{ ///
			\begin{tabular}{l*{8}{c}} ///
			\toprule ///
			) ///
	mlabels(none) ///
	mgroups("Economics Language" "Labor/EPA decision", pattern(1 0 0 0 1 0 0 0) span ///
			prefix(\multicolumn{@span}{c}{\uline{\textit{) suffix(}}})) ///
	posthead("\cmidrule(lr){2-5} \cmidrule(lr){6-9}") ///
	prefoot("\cmidrule(lr){1-5} \cmidrule(lr){6-9}") ///
	stats(circuityearfe neverattend notyetattend N r2,  ///
		  labels("Circuit-Year FE" "Never-Attenders" "Not-Yet-Attenders" "N" "R-sq") fmt(0 0 0 0 3)) /// 
	postfoot(`"\bottomrule"' ///
			\end{tabular} ///
			} ///
			\end{center} ///
			) ///
	nonotes starlevels(+ .1 * .05 ** .01) ///
	substitute([1em] )

}





* Globals and vars gen
global globals_and_vars=1
if ${globals_and_vars}==1 {

	
	* Globals FE
	global paperv4_enetc8 "i.year#c.(x_plocct x_pccoun x_b10s x_b20s x_b30s x_b40s x_b50s)"
	global new_enetc8 "i.year#c.(x_pgovt x_b10s x_b20s x_b40s x_b50s)"

	* global enetc8 "i.five_year#c.(x_pgovt x_b10s x_b20s x_b40s x_b50s)"

	** jun16 bios enet
	global enetc8 "i.five_year#c.(x_psatty x_pgov x_b10s x_b20s x_b40s x_b50s)"
	global basefe "circuityear judgefe" 

	* summary graphs
	cap gen laborepa=y_labor_epa_lose
	cap gen convecon= y_convote_econ
	cap gen convnonecon= y_convote_nonecon
	cap gen antitrust2= y_cons_antitrust2
	cap gen ellickson=y_ellickson_vec
	cap gen convote2=convote
	replace convote2=0 if convote==-1
	replace convote2=0.5 if convote==0
	cap gen manne_postXecon=manne_post*econ_case
	
	cap gen wjt5=WJT
	cap winsor2 wjt5, replace cuts(5 95)
	
	sum peer_manne_share, det
	gen lt_mediantpeer_man_sh = peer_manne_share <r(p50) if peer_manne_share!=.

	gen two_year = year - mod(year,2)
	gen three_year = year - mod(year,3)
	gen four_year = year - mod(year,4)
	gen five_year = year - mod(year,5)
	gen six_year = year - mod(year,6)

}


** Table 1
// global table1=1
if ${table1}==1{

	eststo clear

	foreach outcome in  ellickson {

		foreach sample_restriction in mw6 manne {

			* baseline
			eststo `outcome'_`sample_restriction'_base: reghdfe `outcome' manne_post if `sample_restriction' == 1 & econ_case==1 & author==1 [aw=WJT], absorb($basefe)  cluster(judgefe) noconstant 
			estadd ysumm, mean sd
			* pre1987
			eststo `outcome'_`sample_restriction'_pre1987: reghdfe `outcome' manne_post if `sample_restriction' == 1 & year<1987 & econ_case==1 & author==1  [aw=WJT], absorb($basefe)  cluster(judgefe) noconstant 
			estadd ysumm, mean sd			

		
		}
	}

	foreach outcome in laborepa convecon convnonecon {

		* baseline
		eststo `outcome'_mw6_base:   reghdfe `outcome' manne_post if mw6 == 1 [aw=WJT], absorb($basefe)  cluster(judgefe) noconstant 
		estadd ysumm, mean sd
		estadd local courtyearfe "X", replace
		estadd local judgefe "X", replace
		estadd local shortrun "Short Run", replace
		estadd local pre1987 "", replace

		* pre1987
		eststo `outcome'_mw6_pre1987: reghdfe `outcome' manne_post if mw6 == 1 & year<1987 [aw=WJT], absorb($basefe)  cluster(judgefe) noconstant 
		estadd ysumm, mean sd	
		estadd local courtyearfe "X", replace
		estadd local judgefe "X", replace
		estadd local shortrun "Short Run", replace
		estadd local pre1987 "X", replace
		
		* baseline
		eststo `outcome'_manne_base: reghdfe `outcome' manne_post if manne == 1 [aw=WJT], absorb($basefe)  cluster(judgefe) noconstant 
		estadd ysumm, mean sd
		estadd local courtyearfe "X", replace
		estadd local judgefe "X", replace
		estadd local shortrun "Long Run", replace
		estadd local pre1987 "", replace
		
		* pre1987
		eststo `outcome'_manne_pre1987: reghdfe `outcome' manne_post if manne == 1 & year<1987 [aw=WJT], absorb($basefe)  cluster(judgefe) noconstant 
		estadd ysumm, mean sd	
		estadd local courtyearfe "X", replace
		estadd local judgefe "X", replace
		estadd local shortrun "Long Run", replace
		estadd local pre1987 "X", replace		
	}


	label var manne_post "Post Manne"

	* Tables	add N, r-squared, mean of outcome, and SD of outcome ---- 
	esttab * using "$output/circuit_tables/table1.csv", cells(b(star fmt(%9.3f)) se(par)) stats(p r2_a ymean ysd N, labels(P-value "Adj. R-squared" Y-mean Y-sd N)) starlevels(+ 0.10 * 0.05 ** 0.01) nodepvar replace plain


	{
		esttab ellickson_* labor* using "$output/circuit_tables/table1.tex", ///
		replace type noisily ///
		b(3) se(4) ///
		keep(manne_post) se obs numbers label ///
		prehead(`"\begin{center}"' ///
				\resizebox{\textwidth}{!}{ ///
				\begin{tabular}{l*{8}{c}} ///
				\toprule ///
				) ///
		mlabels(none) ///
		mgroups("Economics Langugage" "Voting against regulators", pattern(1 0 0 0 1 0 0 0) ///
				span prefix(\multicolumn{@span}{c}{\uline{\textit{) suffix(}}})) ///
		posthead("\cmidrule(lr){2-5} \cmidrule(lr){6-9}") ///
		prefoot("\cmidrule(lr){1-5} \cmidrule(lr){6-9}") ///
		stats(N, labels("N") fmt(0)) ///
		postfoot("") ///
		nonotes nostar 

		esttab convecon_* convnonecon_* using "$output/circuit_tables/table1.tex", ///
		append type noisily ///
		b(3) se(4) ///
		keep(manne_post) se obs label ///
		prehead("") ///
		nonumbers mlabels(9 10 11 12 13 14 15 16, prefix("(") suffix(")")) ///
		mgroups("Conservative Vote (Econ case)" "Conservative Vote (Non-Econ case)", pattern(1 0 0 0 1 0 0 0) ///
				span prefix(\multicolumn{@span}{c}{\uline{\textit{) suffix(}}})) ///
		posthead("\cmidrule(lr){2-5} \cmidrule(lr){6-9}") ///
		prefoot("\cmidrule(lr){1-5} \cmidrule(lr){6-9}") ///
		stats(N courtyearfe judgefe shortrun pre1987, ///
		      labels("N" "Court-Year FE" "Judge FE" "Sample" "Pre-1987") fmt(0)) ///
		postfoot(`"\bottomrule"' ///
				\end{tabular} ///
				} ///
				\end{center} ///
				) ///
		nonotes nostar

	}


}

* Tables A.8, A.9, A.10, A.11, A.12, A.13
// global circuit_rc_sum3_part1=1
if ${circuit_rc_sum3_part1}==1 {

	cap gen wjt1=WJT
	cap winsor2 wjt1, replace cuts(1 99)

	encode topic, gen(topic_enc)
	egen econcircuityear=group(econ_case circuit year)
	egen econcircuitjudge=group(econ_case circuit judgefe)
	cap gen cites_tot=pct_cites_total
	cap gen cites_out=pct_cites_outside
	cap gen rea_bush_cit=reagan_bush_sc_appt_cites

	eststo clear

	foreach outcome in ellickson {
		foreach sample_restriction in one {

			* baseline
			eststo `outcome'_`sample_restriction'_base: reghdfe `outcome' manne_post if `sample_restriction' == 1 & econ_case==1 & author==1 [aw=WJT], absorb($basefe)  cluster(judgefe) noconstant 
			estadd ysumm, mean sd

			* pre1987
			eststo `outcome'_`sample_restriction'_pre1987: reghdfe `outcome' manne_post if `sample_restriction' == 1 & year<1987 & econ_case==1 & author==1  [aw=WJT], absorb($basefe)  cluster(judgefe) noconstant 
			estadd ysumm, mean sd

			* party x 5year
			eststo `outcome'_`sample_restriction'_5party: reghdfe `outcome' manne_post if `sample_restriction' == 1 & econ_case==1 & author==1  [aw=WJT], absorb($basefe five_year#c.x_republican)  cluster(judgefe) noconstant
			estadd ysumm, mean sd

			* enet per 5year
			eststo `outcome'_`sample_restriction'_5enet: reghdfe `outcome' manne_post if `sample_restriction' == 1 & econ_case==1 & author==1  [aw=WJT],  absorb($basefe $enetc8)  cluster(judgefe) noconstant		
			estadd ysumm, mean sd

			* low peer share
			eststo `outcome'_`sample_restriction'_lowpeer: reghdfe `outcome' manne_post if `sample_restriction' == 1 & lt_mediantpeer_man_sh==1 & econ_case==1 & author==1 [aw=WJT],  absorb($basefe)  cluster(judgefe) noconstant
			estadd ysumm, mean sd

			* judgefe x peer_manne_share
			eststo `outcome'_`sample_restriction'_mannesh: reghdfe `outcome' manne_post if `sample_restriction' == 1 & econ_case==1 & author==1  [aw=WJT],  absorb($basefe circuitjudge#c.peer_manne_share)  cluster(judgefe) noconstant
			estadd ysumm, mean sd

			* topic /charge fe	
			eststo `outcome'_`sample_restriction'_topic: reghdfe `outcome' manne_post if `sample_restriction' == 1 & econ_case==1 & author==1  [aw=WJT], absorb($basefe topic)  cluster(judgefe) noconstant
			estadd ysumm, mean sd

			* no weight
			eststo `outcome'_`sample_restriction'_noweight: reghdfe `outcome' manne_post if `sample_restriction' == 1 & econ_case==1 & author==1 , absorb($basefe)  cluster(judgefe) noconstant
			estadd ysumm, mean sd

			* winsorized weights
			eststo `outcome'_`sample_restriction'_winw: reghdfe `outcome' manne_post if `sample_restriction' == 1 & econ_case==1 & author==1  [aw=wjt1], absorb($basefe)  cluster(judgefe) noconstant
			estadd ysumm, mean sd

			* robust se
			eststo `outcome'_`sample_restriction'_robust: reghdfe `outcome' manne_post if `sample_restriction' == 1 & econ_case==1 & author==1  [aw=WJT], absorb($basefe) vce(robust) noconstant
			estadd ysumm, mean sd

			* cluster circuityear and judge
			eststo `outcome'_`sample_restriction'_2cluster: reghdfe `outcome' manne_post if `sample_restriction' == 1 & econ_case==1 & author==1  [aw=WJT], absorb($basefe) cluster(judgefe circuityear) noconstant
			estadd ysumm, mean sd

			** ADD callaway sant'anna here
			eststo `outcome'_`sample_restriction'_santanna: reghdfe `outcome' manne_post if `sample_restriction' == 1 & econ_case==1 & author==1  [aw=WJT], absorb($basefe) cluster(judgefe circuityear) noconstant
			estadd ysumm, mean sd

			* Tables	add N, r-squared, mean of outcome, and SD of outcome ---- 
// 			esttab `outcome'_`sample_restriction'_* using "$output/circuit_tables/`outcome'_`sample_restriction'.csv", cells(b(star fmt(%9.3f)) se(par)) stats(p r2_a ymean ysd N, labels(P-value "Adj. R-squared" Y-mean Y-sd N)) starlevels(+ 0.10 * 0.05 ** 0.01) nodepvar replace plain
		
		}
	}



	foreach outcome in econ_pp_17 {
		foreach sample_restriction in one {

			* baseline
			eststo `outcome'_`sample_restriction'_base: reghdfe `outcome' manne_post if `sample_restriction' == 1 & non_econ_case==1 & author==1 [aw=WJT], absorb($basefe)  cluster(judgefe) noconstant 
			estadd ysumm, mean sd

			* pre1987
			eststo `outcome'_`sample_restriction'_pre1987: reghdfe `outcome' manne_post if `sample_restriction' == 1 & year<1987 & non_econ_case==1 & author==1  [aw=WJT], absorb($basefe)  cluster(judgefe) noconstant 
			estadd ysumm, mean sd

			* party x 5year
			eststo `outcome'_`sample_restriction'_5party: reghdfe `outcome' manne_post if `sample_restriction' == 1 & non_econ_case==1 & author==1  [aw=WJT], absorb($basefe five_year#c.x_republican)  cluster(judgefe) noconstant
			estadd ysumm, mean sd

			* enet per 5year
			eststo `outcome'_`sample_restriction'_5enet: reghdfe `outcome' manne_post if `sample_restriction' == 1 & non_econ_case==1 & author==1  [aw=WJT],  absorb($basefe $enetc8)  cluster(judgefe) noconstant
			estadd ysumm, mean sd

			* low peer share
			eststo `outcome'_`sample_restriction'_lowpeer: reghdfe `outcome' manne_post if `sample_restriction' == 1 & lt_mediantpeer_man_sh==1 & non_econ_case==1 & author==1 [aw=WJT],  absorb($basefe)  cluster(judgefe) noconstant
			estadd ysumm, mean sd

			* judgefe x peer_manne_share
			eststo `outcome'_`sample_restriction'_mannesh: reghdfe `outcome' manne_post if `sample_restriction' == 1 & non_econ_case==1 & author==1  [aw=WJT],  absorb($basefe circuitjudge#c.peer_manne_share)  cluster(judgefe) noconstant
			estadd ysumm, mean sd

			* topic /charge fe	
			eststo `outcome'_`sample_restriction'_topic: reghdfe `outcome' manne_post if `sample_restriction' == 1 & non_econ_case==1 & author==1  [aw=WJT], absorb($basefe topic)  cluster(judgefe) noconstant
			estadd ysumm, mean sd

			* no weight
			eststo `outcome'_`sample_restriction'_noweight: reghdfe `outcome' manne_post if `sample_restriction' == 1 & non_econ_case==1 & author==1 , absorb($basefe)  cluster(judgefe) noconstant
			estadd ysumm, mean sd

			* winsorized weights
			eststo `outcome'_`sample_restriction'_winw: reghdfe `outcome' manne_post if `sample_restriction' == 1 & non_econ_case==1 & author==1  [aw=wjt1], absorb($basefe)  cluster(judgefe) noconstant
			estadd ysumm, mean sd

			* robust se
			eststo `outcome'_`sample_restriction'_robust: reghdfe `outcome' manne_post if `sample_restriction' == 1 & non_econ_case==1 & author==1  [aw=WJT], absorb($basefe) vce(robust) noconstant
			estadd ysumm, mean sd

			* cluster circuityear and judge
			eststo `outcome'_`sample_restriction'_2cluster: reghdfe `outcome' manne_post if `sample_restriction' == 1 & non_econ_case==1 & author==1  [aw=WJT], absorb($basefe) cluster(judgefe circuityear) noconstant
			estadd ysumm, mean sd

			** ADD callaway sant'anna here
			eststo `outcome'_`sample_restriction'_santanna: reghdfe `outcome' manne_post if `sample_restriction' == 1 & non_econ_case==1 & author==1  [aw=WJT], absorb($basefe) cluster(judgefe circuityear) noconstant
			estadd ysumm, mean sd


			* Tables	add N, r-squared, mean of outcome, and SD of outcome ---- 				
// 			esttab `outcome'_`sample_restriction'_* using "$output/circuit_tables/`outcome'_`sample_restriction'.csv", cells(b(star fmt(%9.3f)) se(par)) stats(p r2_a ymean ysd N, labels(P-value "Adj. R-squared" Y-mean Y-sd N)) starlevels(+ 0.10 * 0.05 ** 0.01) nodepvar replace plain
		}
	}


	foreach outcome in laborepa convecon convnonecon {
		foreach sample_restriction in one {

			* baseline
			eststo `outcome'_`sample_restriction'_base: reghdfe `outcome' manne_post if `sample_restriction' == 1 [aw=WJT], absorb($basefe)  cluster(judgefe) noconstant 
			estadd ysumm, mean sd
			estadd local basefe "X", replace

			* pre1987
			eststo `outcome'_`sample_restriction'_pre1987: reghdfe `outcome' manne_post if `sample_restriction' == 1 & year<1987 [aw=WJT], absorb($basefe)  cluster(judgefe) noconstant 
			estadd ysumm, mean sd
			estadd local basefe "X", replace
			estadd local pre1987 "X", replace

			* party x 5year
			eststo `outcome'_`sample_restriction'_5party: reghdfe `outcome' manne_post if `sample_restriction' == 1 [aw=WJT], absorb($basefe five_year#c.x_republican)  cluster(judgefe) noconstant
			estadd ysumm, mean sd 
			estadd local basefe "X", replace
			estadd local partytimefe "X", replace

			* enet per 5year
			eststo `outcome'_`sample_restriction'_5enet: reghdfe `outcome' manne_post if `sample_restriction' == 1 [aw=WJT],  absorb($basefe $enetc8)  cluster(judgefe) noconstant
			estadd ysumm, mean sd
			estadd local basefe "X", replace
			estadd local enettimefe "X", replace

			* low peer share
			eststo `outcome'_`sample_restriction'_lowpeer: reghdfe `outcome' manne_post if `sample_restriction' == 1 & lt_mediantpeer_man_sh==1 [aw=WJT],  absorb($basefe)  cluster(judgefe) noconstant
			estadd ysumm, mean sd
			estadd local basefe "X", replace
			estadd local lowpeer "X", replace

			* circuitjudgefe x peer_manne_share
			eststo `outcome'_`sample_restriction'_mannesh: reghdfe `outcome' manne_post if `sample_restriction' == 1 [aw=WJT],  absorb($basefe circuitjudge#c.peer_manne_share)  cluster(judgefe) noconstant
			estadd ysumm, mean sd
			estadd local basefe "X", replace
			estadd local circuitjudgepeer "X", replace

			* topic /charge fe	
			eststo `outcome'_`sample_restriction'_topic: reghdfe `outcome' manne_post if `sample_restriction' == 1 [aw=WJT], absorb($basefe topic)  cluster(judgefe) noconstant
			estadd ysumm, mean sd
			estadd local basefe "X", replace
			estadd local topicfe "X", replace 

			* no weight
			eststo `outcome'_`sample_restriction'_noweight: reghdfe `outcome' manne_post if `sample_restriction' == 1, absorb($basefe)  cluster(judgefe) noconstant
			estadd ysumm, mean sd
			estadd local basefe "X", replace
			estadd local noweight "X", replace

			* winsorized weights
			eststo `outcome'_`sample_restriction'_winw: reghdfe `outcome' manne_post if `sample_restriction' == 1 [aw=wjt1], absorb($basefe)  cluster(judgefe) noconstant
			estadd ysumm, mean sd
			estadd local basefe "X", replace
			estadd local winsorw "X", replace

			* robust se
			eststo `outcome'_`sample_restriction'_robust: reghdfe `outcome' manne_post if `sample_restriction' == 1 [aw=WJT], absorb($basefe) vce(robust) noconstant
			estadd ysumm, mean sd
			estadd local basefe "X", replace
			estadd local robust "X", replace

			* cluster circuityear and judge
			eststo `outcome'_`sample_restriction'_2cluster: reghdfe `outcome' manne_post if `sample_restriction' == 1 [aw=WJT], absorb($basefe) cluster(judgefe circuityear) noconstant
			estadd ysumm, mean sd
			estadd local basefe "X", replace
			estadd local clustertw "X", replace

			** ADD callaway sant'anna here
			eststo `outcome'_`sample_restriction'_santanna: reghdfe `outcome' manne_post if `sample_restriction' == 1 [aw=WJT], absorb($basefe) cluster(judgefe circuityear) noconstant
			estadd ysumm, mean sd
			estadd local basefe "X", replace
			estadd local santanna "X", replace


			* Tables	add N, r-squared, mean of outcome, and SD of outcome ---- 
// 			esttab `outcome'_`sample_restriction'* using "$output/circuit_tables/`outcome'_`sample_restriction'.csv", cells(b(star fmt(%9.3f)) se(par)) stats(p r2_a ymean ysd N, labels(P-value "Adj. R-squared" Y-mean Y-sd N)) starlevels(+ 0.10 * 0.05 ** 0.01) nodepvar replace plain				
		}
	}

	** table in esttab
	{
		label var manne_post "Post Manne"

		esttab ellickson_one_* using "$output/circuit_tables/table_a8.tex", ///
		replace type noisily ///
		b(3) se(4) ///
		keep(manne_post) se obs label ///
		prehead(`"\begin{center}"' ///
				\resizebox{\textwidth}{!}{ ///
				\begin{tabular}{l*{12}{c}} ///
				\toprule ///
				) ///
		mlabels(none) ///
		numbers ///
		mgroups("A. Ellickson Embedding Similarity to Economics Langugage", pattern(1 0 0 0 0 0 0 0 0 0 0 0) ///
				span prefix(\multicolumn{@span}{c}{\uline{\textit{) suffix(}}})) ///
		posthead("\cmidrule(lr){2-13}") ///
		prefoot("\cmidrule(lr){1-13}") ///
		stats(N, labels("N") fmt(0)) ///
		postfoot("") ///
		nonotes starlevels(+ .1 * .05 ** .01) 

		esttab econ_pp_17_one_* using "$output/circuit_tables/table_a8.tex", ///
		append type noisily ///
		b(3) se(4) ///
		keep(manne_post) se obs label ///
		prehead("") ///
		nonumbers mlabels(13 14 15 16 17 18 19 20 21 22 23 24, prefix("(") suffix(")")) ///
		mgroups("B. ML-Predicted Similarity to Economics", pattern(1 0 0 0 0 0 0 0 0 0 0 0) ///
				span prefix(\multicolumn{@span}{c}{\uline{\textit{) suffix(}}})) ///
		posthead("\cmidrule(lr){2-13}") ///
		prefoot("\cmidrule(lr){1-13}") ///
		stats(N, labels("N") fmt(0)) ///
		postfoot("") ///
		nonotes starlevels(+ .1 * .05 ** .01) 

		esttab laborepa_one_* using "$output/circuit_tables/table_a8.tex", ///
		append type noisily ///
		b(3) se(4) ///
		keep(manne_post) se obs label ///
		prehead("") ///
		nonumbers mlabels(25 26 27 28 29 30 31 32 33 34 35 36, prefix("(") suffix(")")) ///
		mgroups("C. Labor/EPA Voting Against Regulatory Agencies", pattern(1 0 0 0 0 0 0 0 0 0 0 0) ///
				span prefix(\multicolumn{@span}{c}{\uline{\textit{) suffix(}}})) ///
		posthead("\cmidrule(lr){2-13}") ///
		prefoot("\cmidrule(lr){1-13}") ///
		stats(N, labels("N") fmt(0)) ///
		postfoot("") ///
		nonotes starlevels(+ .1 * .05 ** .01)

		esttab convecon_one_* using "$output/circuit_tables/table_a8.tex", ///
		append type noisily ///
		b(3) se(4) ///
		keep(manne_post) se obs label ///
		prehead("") ///
		nonumbers mlabels(37 38 39 40 41 42 43 44 45 46 47 48, prefix("(") suffix(")")) ///
		mgroups("D. Hand-Coded Conservative Votes (Economics Cases)", pattern(1 0 0 0 0 0 0 0 0 0 0 0) ///
				span prefix(\multicolumn{@span}{c}{\uline{\textit{) suffix(}}})) ///
		posthead("\cmidrule(lr){2-13}") ///
		prefoot("\cmidrule(lr){1-13}") ///
		stats(N, labels("N") fmt(0)) ///
		postfoot("") ///
		nonotes starlevels(+ .1 * .05 ** .01)

		esttab convnonecon_one_* using "$output/circuit_tables/table_a8.tex", ///
		append type noisily ///
		b(3) se(4) ///
		keep(manne_post) se obs label ///
		prehead("") ///
		nonumbers mlabels(49 50 51 52 53 54 55 56 57 58 59 60, prefix("(") suffix(")")) ///
		mgroups("E. Hand-Coded Conservative Votes (Non-Economics Cases)", pattern(1 0 0 0 0 0 0 0 0 0 0 0) ///
				span prefix(\multicolumn{@span}{c}{\uline{\textit{) suffix(}}})) ///
		posthead("\cmidrule(lr){2-13}") ///
		prefoot("\cmidrule(lr){1-13}") ///
		stats(N basefe pre1987 partytimefe enettimefe lowpeer ///
			  circuitjudgepeer topicfe noweight winsorw ///
			  robust clustertw santanna, ///
		      labels("N" "Circuit-Year/Judge FE" "Pre-1987" "Party-Time FE" "Enet-Time FE" "Low Peer Share" ///
		      	     "Circuit-Judge FE X Peer Share" "Case Topic FE" "No Weighting" "Winsorized Weights" ///
		      	     "Robust SE" "Two-Way Cluster SE's" "Callaway Santanna") fmt(0)) ///
		postfoot(`"\bottomrule"' ///
				\end{tabular} ///
				} ///
				\end{center} ///
				) ///
		nonotes starlevels(+ .1 * .05 ** .01)
	}


// 	global circuit_rc_sum3_part2=1
	if ${circuit_rc_sum3_part2}==1 {

		foreach outcome in ellickson {

			foreach sample_restriction in mw6 manne {

				* baseline
				eststo `outcome'_`sample_restriction'_base: reghdfe `outcome' manne_post if `sample_restriction' == 1 & econ_case==1 & author==1 [aw=WJT], absorb($basefe)  cluster(judgefe) noconstant 
				estadd ysumm, mean sd
				estadd local basefe "X", replace

				* pre1987
				eststo `outcome'_`sample_restriction'_pre1987: reghdfe `outcome' manne_post if `sample_restriction' == 1 & year<1987 & econ_case==1 & author==1 [aw=WJT], absorb($basefe)  cluster(judgefe) noconstant 
				estadd ysumm, mean sd
				estadd local basefe "X", replace
				estadd local pre1987 "X", replace

				* party x 5year
				eststo `outcome'_`sample_restriction'_5party: reghdfe `outcome' manne_post if `sample_restriction' == 1 & econ_case==1 & author==1 [aw=WJT], absorb($basefe five_year#c.x_republican)  cluster(judgefe) noconstant
				estadd ysumm, mean sd
				estadd local basefe "X", replace
				estadd local partytimefe "X", replace

				* enet per 5year
				eststo `outcome'_`sample_restriction'_5enet: reghdfe `outcome' manne_post if `sample_restriction' == 1 & econ_case==1 & author==1 [aw=WJT], absorb($basefe $enetc8)  cluster(judgefe) noconstant		
				estadd ysumm, mean sd
				estadd local basefe "X", replace
				estadd local enettimefe "X", replace

				* low peer share
				eststo `outcome'_`sample_restriction'_lowpeer: reghdfe `outcome' manne_post if `sample_restriction' == 1 & lt_mediantpeer_man_sh==1 & econ_case==1 & author==1 [aw=WJT], absorb($basefe)  cluster(judgefe) noconstant
				estadd ysumm, mean sd
				estadd local basefe "X", replace
				estadd local lowpeer "X", replace

				* judgefe x peer_manne_share
				eststo `outcome'_`sample_restriction'_mannesh: reghdfe `outcome' manne_post if `sample_restriction' == 1 & econ_case==1 & author==1 [aw=WJT], absorb($basefe circuitjudge#c.peer_manne_share)  cluster(judgefe) noconstant
				estadd ysumm, mean sd
				estadd local basefe "X", replace
				estadd local circuitjudgepeer "X", replace

				* topic /charge fe	
				eststo `outcome'_`sample_restriction'_topic: reghdfe `outcome' manne_post if `sample_restriction' == 1 & econ_case==1 & author==1 [aw=WJT], absorb($basefe topic)  cluster(judgefe) noconstant
				estadd ysumm, mean sd
				estadd local basefe "X", replace
				estadd local topicfe "X", replace

				* no weight
				eststo `outcome'_`sample_restriction'_noweight: reghdfe `outcome' manne_post if `sample_restriction' == 1 & econ_case==1 & author==1, absorb($basefe)  cluster(judgefe) noconstant
				estadd ysumm, mean sd
				estadd local basefe "X", replace
				estadd local noweight "X", replace

				* winsorized weights
				eststo `outcome'_`sample_restriction'_winw: reghdfe `outcome' manne_post if `sample_restriction' == 1 & econ_case==1 & author==1 [aw=wjt1], absorb($basefe)  cluster(judgefe) noconstant
				estadd ysumm, mean sd
				estadd local basefe "X", replace
				estadd local winsorw "X", replace

				* robust se
				eststo `outcome'_`sample_restriction'_robust: reghdfe `outcome' manne_post if `sample_restriction' == 1 & econ_case==1 & author==1 [aw=WJT], absorb($basefe) vce(robust) noconstant
				estadd ysumm, mean sd
				estadd local basefe "X", replace
				estadd local robust "X", replace

				* cluster circuityear and judge
				eststo `outcome'_`sample_restriction'_2cluster: reghdfe `outcome' manne_post if `sample_restriction' == 1 & econ_case==1 & author==1 [aw=WJT], absorb($basefe) cluster(judgefe circuityear) noconstant
				estadd ysumm, mean sd
				estadd local basefe "X", replace
				estadd local clustertw "X", replace

					
				* Tables	add N, r-squared, mean of outcome, and SD of outcome ---- 
// 				esttab `outcome'_`sample_restriction'* using "$output/circuit_tables/`outcome'_`sample_restriction'.csv", cells(b(star fmt(%9.3f)) se(par)) stats(p r2_a ymean ysd N, labels(P-value "Adj. R-squared" Y-mean Y-sd N)) starlevels(+ 0.10 * 0.05 ** 0.01) nodepvar replace plain
			
			}
		}

		foreach outcome in econ_pp_17 {
			foreach sample_restriction in mw6 manne {

				* baseline
				eststo `outcome'_`sample_restriction'_base: reghdfe `outcome' manne_post if `sample_restriction' == 1 & non_econ_case==1 & author==1 [aw=WJT], absorb($basefe)  cluster(judgefe) noconstant 
				estadd ysumm, mean sd
				estadd local basefe "X", replace

				* pre1987
				eststo `outcome'_`sample_restriction'_pre1987: reghdfe `outcome' manne_post if `sample_restriction' == 1 & year<1987 & non_econ_case==1 & author==1 [aw=WJT], absorb($basefe)  cluster(judgefe) noconstant 
				estadd ysumm, mean sd
				estadd local basefe "X", replace
				estadd local pre1987 "X", replace

				* party x 5year
				eststo `outcome'_`sample_restriction'_5party: reghdfe `outcome' manne_post if `sample_restriction' == 1 & non_econ_case==1 & author==1 [aw=WJT], absorb($basefe five_year#c.x_republican)  cluster(judgefe) noconstant
				estadd ysumm, mean sd
				estadd local basefe "X", replace
				estadd local partytimefe "X", replace

				* enet per 5year
				eststo `outcome'_`sample_restriction'_5enet: reghdfe `outcome' manne_post if `sample_restriction' == 1 & non_econ_case==1 & author==1 [aw=WJT], absorb($basefe $enetc8)  cluster(judgefe) noconstant
				estadd ysumm, mean sd
				estadd local basefe "X", replace
				estadd local enettimefe "X", replace

				* low peer share
				eststo `outcome'_`sample_restriction'_lowpeer: reghdfe `outcome' manne_post if `sample_restriction' == 1 & lt_mediantpeer_man_sh==1 & non_econ_case==1 & author==1 [aw=WJT], absorb($basefe)  cluster(judgefe) noconstant
				estadd ysumm, mean sd
				estadd local basefe "X", replace
				estadd local lowpeer "X", replace

				* judgefe x peer_manne_share
				eststo `outcome'_`sample_restriction'_mannesh: reghdfe `outcome' manne_post if `sample_restriction' == 1 & non_econ_case==1 & author==1 [aw=WJT], absorb($basefe circuitjudge#c.peer_manne_share)  cluster(judgefe) noconstant
				estadd ysumm, mean sd
				estadd local basefe "X", replace
				estadd local circuitjudgepeer "X", replace

				* topic /charge fe	
				eststo `outcome'_`sample_restriction'_topic: reghdfe `outcome' manne_post if `sample_restriction' == 1 & non_econ_case==1 & author==1 [aw=WJT], absorb($basefe topic)  cluster(judgefe) noconstant
				estadd ysumm, mean sd
				estadd local basefe "X", replace
				estadd local topicfe "X", replace

				* no weight
				eststo `outcome'_`sample_restriction'_noweight: reghdfe `outcome' manne_post if `sample_restriction' == 1 & non_econ_case==1 & author==1, absorb($basefe)  cluster(judgefe) noconstant
				estadd ysumm, mean sd
				estadd local basefe "X", replace
				estadd local noweight "X", replace

				* winsorized weights
				eststo `outcome'_`sample_restriction'_winw: reghdfe `outcome' manne_post if `sample_restriction' == 1 & non_econ_case==1 & author==1 [aw=wjt1], absorb($basefe)  cluster(judgefe) noconstant
				estadd ysumm, mean sd
				estadd local basefe "X", replace
				estadd local winsorw "X", replace

				* robust se
				eststo `outcome'_`sample_restriction'_robust: reghdfe `outcome' manne_post if `sample_restriction' == 1 & non_econ_case==1 & author==1 [aw=WJT], absorb($basefe) vce(robust) noconstant
				estadd ysumm, mean sd
				estadd local basefe "X", replace
				estadd local robust "X", replace

				* cluster circuityear and judge
				eststo `outcome'_`sample_restriction'_2cluster: reghdfe `outcome' manne_post if `sample_restriction' == 1 & non_econ_case==1 & author==1 [aw=WJT], absorb($basefe) cluster(judgefe circuityear) noconstant
				estadd ysumm, mean sd
				estadd local basefe "X", replace
				estadd local clustertw "X", replace

				* Tables	add N, r-squared, mean of outcome, and SD of outcome ---- 				
// 				esttab `outcome'_`sample_restriction'* using "$output/circuit_tables/`outcome'_`sample_restriction'.csv", cells(b(star fmt(%9.3f)) se(par)) stats(p r2_a ymean ysd N, labels(P-value "Adj. R-squared" Y-mean Y-sd N)) starlevels(+ 0.10 * 0.05 ** 0.01) nodepvar replace plain
			}
		}




		foreach outcome in laborepa convecon convnonecon {
			foreach sample_restriction in mw6 manne {

			* baseline
			eststo `outcome'_`sample_restriction'_base: reghdfe `outcome' manne_post if `sample_restriction' == 1 [aw=WJT], absorb($basefe) cluster(judgefe) noconstant 
			estadd ysumm, mean sd
			estadd local basefe "X", replace

			* pre1987
			eststo `outcome'_`sample_restriction'_pre1987: reghdfe `outcome' manne_post if `sample_restriction' == 1 & year<1987 [aw=WJT], absorb($basefe) cluster(judgefe) noconstant 
			estadd ysumm, mean sd
			estadd local basefe "X", replace
			estadd local pre1987 "X", replace

			* party x 5year
			eststo `outcome'_`sample_restriction'_5party: reghdfe `outcome' manne_post if `sample_restriction' == 1 [aw=WJT], absorb($basefe five_year#c.x_republican) cluster(judgefe) noconstant
			estadd ysumm, mean sd
			estadd local basefe "X", replace
			estadd local partytimefe "X", replace

			* enet per 5year
			eststo `outcome'_`sample_restriction'_5enet: reghdfe `outcome' manne_post if `sample_restriction' == 1 [aw=WJT], absorb($basefe $enetc8) cluster(judgefe) noconstant
			estadd ysumm, mean sd
			estadd local basefe "X", replace
			estadd local enettimefe "X", replace

			* low peer share
			eststo `outcome'_`sample_restriction'_lowpeer: reghdfe `outcome' manne_post if `sample_restriction' == 1 & lt_mediantpeer_man_sh==1 [aw=WJT], absorb($basefe) cluster(judgefe) noconstant
			estadd ysumm, mean sd
			estadd local basefe "X", replace
			estadd local lowpeer "X", replace

			* circuitjudgefe x peer_manne_share
			eststo `outcome'_`sample_restriction'_mannesh: reghdfe `outcome' manne_post if `sample_restriction' == 1 [aw=WJT], absorb($basefe circuitjudge#c.peer_manne_share) cluster(judgefe) noconstant
			estadd ysumm, mean sd
			estadd local basefe "X", replace
			estadd local circuitjudgepeer "X", replace

			* topic /charge fe	
			eststo `outcome'_`sample_restriction'_topic: reghdfe `outcome' manne_post if `sample_restriction' == 1 [aw=WJT], absorb($basefe topic) cluster(judgefe) noconstant
			estadd ysumm, mean sd
			estadd local basefe "X", replace
			estadd local topicfe "X", replace

			* no weight
			eststo `outcome'_`sample_restriction'_noweight: reghdfe `outcome' manne_post if `sample_restriction' == 1, absorb($basefe) cluster(judgefe) noconstant
			estadd ysumm, mean sd
			estadd local basefe "X", replace
			estadd local noweight "X", replace

			* winsorized weights
			eststo `outcome'_`sample_restriction'_winw: reghdfe `outcome' manne_post if `sample_restriction' == 1 [aw=wjt1], absorb($basefe) cluster(judgefe) noconstant
			estadd ysumm, mean sd
			estadd local basefe "X", replace
			estadd local winsorw "X", replace

			* robust se
			eststo `outcome'_`sample_restriction'_robust: reghdfe `outcome' manne_post if `sample_restriction' == 1 [aw=WJT], absorb($basefe) vce(robust) noconstant
			estadd ysumm, mean sd
			estadd local basefe "X", replace
			estadd local robust "X", replace

			* cluster circuityear and judge
			eststo `outcome'_`sample_restriction'_2cluster: reghdfe `outcome' manne_post if `sample_restriction' == 1 [aw=WJT], absorb($basefe) cluster(judgefe circuityear) noconstant
			estadd ysumm, mean sd
			estadd local basefe "X", replace
			estadd local clustertw "X", replace

			* Tables	add N, r-squared, mean of outcome, and SD of outcome ---- 
// 			esttab `outcome'_`sample_restriction'* using "$output/circuit_tables/`outcome'_`sample_restriction'.csv", cells(b(star fmt(%9.3f)) se(par)) stats(p r2_a ymean ysd N, labels(P-value "Adj. R-squared" Y-mean Y-sd N)) starlevels(+ 0.10 * 0.05 ** 0.01) nodepvar replace plain				
			}
		}


		** ellickson A.9 table in esttab
		esttab_circuit_appendix, outcome(ellickson) table_number(9)

		** econ_pp A.10 table in esttab
		esttab_circuit_appendix, outcome(econ_pp_17) table_number(10)

		** labor A.11 table in esttab
		esttab_circuit_appendix, outcome(laborepa) table_number(11)

		** convecon A.12 table in esttab
		esttab_circuit_appendix, outcome(convecon) table_number(12)

		** convecon A.13 table in esttab
		esttab_circuit_appendix, outcome(convnonecon) table_number(13)


	}

	eststo clear 

	eststo: reghdfe y_cons_antitrust2 manne_post if mw6 [aw=WJT], absorb($basefe) cluster(judgefe)
	estadd local basefe "X", replace

	eststo: reghdfe y_cons_antitrust2 manne_post if manne [aw=WJT], absorb($basefe) cluster(judgefe)
	estadd local basefe "X", replace

	eststo: reghdfe y_cons_antitrust2 manne_post if manne [aw=WJT], absorb($basefe_enet) cluster(judgefe)
	estadd local basefe "X", replace
	estadd local enettimefe "X", replace

	eststo: reghdfe antitrust3 manne_post if mw6 [aw=WJT], absorb($basefe) cluster(judgefe)
	estadd local basefe "X", replace

	eststo: reghdfe antitrust3 manne_post if manne [aw=WJT], absorb($basefe) cluster(judgefe)
	estadd local basefe "X", replace

	eststo: reghdfe antitrust3 manne_post if manne [aw=WJT], absorb($basefe_enet) cluster(judgefe)
	estadd local basefe "X", replace
	estadd local enettimefe "X", replace



	esttab est* using "$output/circuit_tables/antitrust_main.csv", cells(b(star fmt(%9.3f)) se(par)) stats(p r2_a ymean ysd N, labels(P-value "Adj. R-squared" Y-mean Y-sd N)) starlevels(+ 0.10 * 0.05 ** 0.01) nodepvar replace plain

	esttab est* using "$output/circuit_tables/antitrust_main.tex", replace type noisily ///
	keep(manne_post) se obs numbers label ///
	prehead(`"\begin{center}"' ///
			\resizebox{0.75\textwidth}{!}{ ///
			\begin{tabular}{l*{6}{c}} ///
			\toprule ///
			) ///
	mlabels(none) ///
	mgroups("Antitrust Measure 1" "Antitrust Measure 2", pattern(1 0 0 1 0 0) span ///
			prefix(\multicolumn{@span}{c}{\uline{\textit{) suffix(}}})) ///
	posthead("\cmidrule(lr){2-4} \cmidrule(lr){5-7}") ///
	prefoot("\cmidrule(lr){1-4} \cmidrule(lr){5-7}") ///
	stats(N basefe enettimefe, ///
		  labels("N" "Circuit-Year/Judge FE" "Enet-Time FE")) /// 
	postfoot(`"\bottomrule"' ///
			\end{tabular} ///
			} ///
			\end{center} ///
			) ///
	nonotes starlevels(+ 0.10 * 0.05 ** 0.01)


}	



**** Table A.6
global circuit_rc_manne_share=1
if ${circuit_rc_manne_share}==1 {


	* FOR PAPER -- 2
	local outcome y_ellickson_vec

	eststo clear 
	eststo ellickson1: reghdfe `outcome' peer_manne_share if is_author==1 [aw=WJT], nocons a(circuitjudge year)  cl(judgefe)
	estadd local circuitjudgefe "X", replace
	estadd local yearfe "X", replace
	estadd local econcase "", replace
	estadd local alljudges "X", replace
	estadd local neverattend "", replace
	estadd local attend "", replace

	eststo ellickson2: reghdfe `outcome' peer_manne_share if is_author==1 & econ_case==1 [aw=WJT], nocons a(circuitjudge year)  cl(judgefe)
	estadd local circuitjudgefe "X", replace
	estadd local yearfe "X", replace
	estadd local econcase "X", replace
	estadd local alljudges "X", replace
	estadd local neverattend "", replace
	estadd local attend "", replace

	eststo ellickson3: reghdfe `outcome' peer_manne_share if everattend == 0 & is_author==1 [aw=WJT], nocons a(circuitjudge year)  cl(judgefe)
	estadd local circuitjudgefe "X", replace
	estadd local yearfe "X", replace
	estadd local econcase "", replace
	estadd local alljudges "X", replace
	estadd local neverattend "", replace
	estadd local attend "", replace

	eststo ellickson4: reghdfe `outcome' peer_manne_share if everattend == 0 & is_author==1 & econ_case==1 [aw=WJT], nocons a(circuitjudge year)  cl(judgefe)
	estadd local circuitjudgefe "X", replace
	estadd local yearfe "X", replace
	estadd local econcase "X", replace
	estadd local alljudges "", replace
	estadd local neverattend "X", replace
	estadd local attend "", replace


	eststo ellickson5: reghdfe `outcome' peer_manne_share if everattend == 1 & is_author==1 [aw=WJT], nocons a(circuitjudge year)  cl(judgefe)
	estadd local circuitjudgefe "X", replace
	estadd local yearfe "X", replace
	estadd local econcase "", replace
	estadd local alljudges "", replace
	estadd local neverattend "", replace
	estadd local attend "X", replace

	eststo ellickson6: reghdfe `outcome' peer_manne_share if everattend == 1 & is_author==1 & econ_case==1 [aw=WJT], nocons a(circuitjudge year)  cl(judgefe)
	estadd local circuitjudgefe "X", replace
	estadd local yearfe "X", replace
	estadd local econcase "X", replace
	estadd local alljudges "", replace
	estadd local neverattend "", replace
	estadd local attend "X", replace

	local outcome y_labor_epa_lose

	eststo labor1: reghdfe `outcome' peer_manne_share  [aw=WJT], nocons a(circuitjudge year)  cl(judgefe)
	estadd local circuitjudgefe "X", replace
	estadd local yearfe "X", replace
	estadd local econcase "-", replace
	estadd local alljudges "X", replace
	estadd local neverattend "", replace
	estadd local attend "", replace

	eststo labor2: reghdfe `outcome' peer_manne_share if everattend == 0 [aw=WJT], nocons a(circuitjudge year)  cl(judgefe)
	estadd local circuitjudgefe "X", replace
	estadd local yearfe "X", replace
	estadd local econcase "-", replace
	estadd local alljudges "", replace
	estadd local neverattend "X", replace
	estadd local attend "", replace

	eststo labor3: reghdfe `outcome' peer_manne_share if everattend == 1  [aw=WJT], nocons a(circuitjudge year)  cl(judgefe)
	estadd local circuitjudgefe "X", replace
	estadd local yearfe "X", replace
	estadd local econcase "-", replace
	estadd local alljudges "", replace
	estadd local neverattend "", replace
	estadd local attend "X", replace

	esttab * using "$output/spillovers/table_a6.csv", b(3) se(4) r2 replace star(+ 0.10 * 0.05 ** 0.01) plain parentheses

	label var peer_manne_share "Peer Attendance"

	esttab * using "$output/spillovers/table_a6.tex", replace type noisily ///
	b(3) se(4) ///
	keep(peer_manne_share) se obs numbers label ///
	prehead(`"\begin{center}"' ///
			\resizebox{\textwidth}{!}{ ///
			\begin{tabular}{l*{9}{c}} ///
			\toprule ///
			) ///
	mlabels(none) ///
	mgroups("Effects on Economic Language" "Labor/EPA decision", pattern(1 0 0 0 0 0 1 0 0) span ///
			prefix(\multicolumn{@span}{c}{\uline{\textit{) suffix(}}})) ///
	posthead("\cmidrule(lr){2-7} \cmidrule(lr){8-10}") ///
	prefoot("\cmidrule(lr){1-7} \cmidrule(lr){8-10}") ///
	stats(circuitjudgefe yearfe econcase alljudges neverattend attend N r2, ///
		  labels("Circuit-Judge FE" "Year FE" "Econ Case" "All Judges" "Never-Attenders" "Attenders" "N" "R-sq") ///
		  fmt(0 0 0 0 0 0 0 3)) /// 
	postfoot(`"\bottomrule"' ///
			\end{tabular} ///
			} ///
			\end{center} ///
			) ///
	nonotes starlevels(+ .1 * .05 ** .01)
	
}

capture log close


