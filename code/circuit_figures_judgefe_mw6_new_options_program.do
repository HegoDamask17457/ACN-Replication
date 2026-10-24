clear
set more off
set graphics off

// For Replicators: If you want to run this file outside of the main 
// programme, proceed as follows:
// 1. Comment out the following code chunk
// 2. Uncomment the programme
// 3. Replace the file-path inside the programme

global output $path/output

cap mkdir "${output}"
foreach subfolder in circuit_appendix circuit_main lgraphs_histograms calibration_plots {
cap mkdir "${output}/`subfolder'"
}

global data data
global district_data ready_districts
global circuit_data ready_circuits

* Copy coefplot recording file for figure titles
capture copy "${path}/schemes_grec/y_title_coefplot_no_legenda.grec" "y_title_coefplot_no_legenda.grec", replace

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
//
// 	copy "${path}/schemes_grec/y_title_coefplot_no_legenda.grec" "y_title_coefplot_no_legenda.grec", replace
//
// 	*********************
// 	*** output folder ***
// 	*********************
//	
// 	global output $path/output
//	
// 	cap mkdir "${output}"
// 	foreach subfolder in circuit_appendix circuit_main lgraphs_histograms calibration_plots {
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
// end 
//
// load_circuit_drop_globals


qui do "$path/code/new_programs.do"

cap log using "$output/output_figures.log", replace

***************
*** buttons ***
***************

global globals_and_vars=1

* Figures 1, 2 and A.9
global lgraphs_histograms=1

* Figure 3-4
global circuit_rc_main4=1

* Figure A.3(ab), A.18, A.20(ab), A.21(ab), A.30, A.35(abc)
global circuit_rc_main4_part2=1

* Lgraphs winsor A.4 & A.5
global lgraphs_wjt=1

* A.12 & A.26
**** Excluding some circuits
global circuit_rc_dropcircuits=1

* A.13 & A.27
**** Topic fixed effect
global circuit_rc_topicfe=1

* A.14 & A.28
**** Cluster se judge-circuityear
global circuit_rc_cljudgecircuityear=1

* A.16 & A.30
**** elasticnetXyear robustness
global elasticnet_robustness=1

* A.18, A.19
global circuit_calibration_plots=1

* A.31
global circuit_a31=1

* A.23
global circuit_fig_23=1

* A.11 & A.25
**** Other window
global circuit_rc_other_window=1

* A.15 & A.29
**** drop other lags
global circuit_lags=1

* combined specs
global combined_specs=1

* Globals and vars gen
// global globals_and_vars=1
if ${globals_and_vars}==1 {

	* Globals graphs

	global coefplot_matrixes "(matrix(coefficients1),ci(ci51) msize(medium))"

	global coefplot_matrixes_merged2 "(matrix(coefficients1),ci(ci51) offset(-0.15) msize(medium)) (matrix(coefficients2),ci(ci52) msize(medium))"	

	global coefplot_matrixes_merged3 "(matrix(coefficients1),ci(ci51) offset(-0.30) msize(medium) msymbol(Oh)) (matrix(coefficients2),ci(ci52) offset(-0.15) msize(medium) msymbol(Dh)) (matrix(coefficients3),ci(ci53) offset(0) msize(medium) msymbol(Th))"	
	global coefplot_matrixes_merged4 "(matrix(coefficients1),ci(ci51) offset(-0.45) msize(medium) msymbol(Oh)) (matrix(coefficients2),ci(ci52) offset(-0.30) msize(medium) msymbol(Dh)) (matrix(coefficients3),ci(ci53) offset(-0.15) msize(medium) msymbol(Th)) (matrix(coefficients4),ci(ci54) offset(0) msize(medium) msymbol(Sh))"	

	global coefplot_matrixes_convote3 "(matrix(coefficients1), ci(ci51) ciopts(color(maroon)) msize(medium) symbol(circle_hollow) color(maroon) offset(-0.65)) (matrix(coefficients2),ci(ci52) ciopts(color(maroon)) msize(medium) symbol(diamond_hollow) color(maroon) offset(-0.55)) (matrix(coefficients3),ci(ci53) ciopts(color(maroon)) msize(medium) symbol(square_hollow) color(maroon) offset(-0.45)) (matrix(coefficients4),ci(ci54) ciopts(color(teal%80)) symbol(circle_hollow) msize(medium) color(teal%80) offset(-0.15)) (matrix(coefficients5),ci(ci55) ciopts(color(teal%80)) symbol(diamond_hollow) msize(medium) color(teal%80) offset(-0.05)) (matrix(coefficients6),ci(ci56) ciopts(color(teal%80)) symbol(square_hollow) msize(medium) color(teal%80) offset(0.05))"	

	global coefplot_matrixes_convote4 "(matrix(coefficients1), ci(ci51) ciopts(color(maroon)) msize(medium) symbol(circle_hollow) color(maroon) offset(-0.65)) (matrix(coefficients2),ci(ci52) ciopts(color(maroon)) msize(medium) symbol(diamond_hollow) color(maroon) offset(-0.55)) (matrix(coefficients3),ci(ci53) ciopts(color(maroon)) msize(medium) symbol(square_hollow) color(maroon) offset(-0.45)) (matrix(coefficients4), ci(ci54) ciopts(color(maroon)) msize(medium) symbol(x) color(maroon) offset(-0.35)) (matrix(coefficients5),ci(ci55) ciopts(color(teal%80)) symbol(circle_hollow) msize(medium) color(teal%80) offset(-0.15)) (matrix(coefficients6),ci(ci56) ciopts(color(teal%80)) symbol(diamond_hollow) msize(medium) color(teal%80) offset(-0.05)) (matrix(coefficients7),ci(ci57) ciopts(color(teal%80)) symbol(square_hollow) msize(medium) color(teal%80) offset(0.05)) (matrix(coefficients8),ci(ci58) ciopts(color(teal%80)) symbol(x) msize(medium) color(teal%80) offset(0.15))"	

	global coefplot_matrixes_merged7 "(matrix(coefficients1),ci(ci51) offset(-0.30) msize(small) msymbol(Oh)) (matrix(coefficients2),ci(ci52) offset(-0.20) msize(small) msymbol(Dh)) (matrix(coefficients3),ci(ci53) offset(-0.10) msize(small) msymbol(Th)) (matrix(coefficients4),ci(ci54) offset(0) msize(small) msymbol(Sh)) (matrix(coefficients5),ci(ci55) offset(+0.10) msize(small) msymbol(Oh)) (matrix(coefficients6),ci(ci56) offset(+0.20) msize(small) msymbol(Dh)) (matrix(coefficients7),ci(ci57) offset(+0.30) msize(small) msymbol(Th))"

	global yline_style "yline(0, lpattern(dash) lcolor(gray))"

	global legendthree `"legend(order(2 "Judge FE's + Circuit-Year FE's" 4 "+ Elastic Net Controls × 5-Year " 6 "< 1987") ring(0) position(11) cols(2))"'

	global legendfour `"legend(order(2 "Judge FE's + Circuit-Year FE's" 4 "+ Elastic Net Controls × 5-Year " 6 "< 1987" 8 "+ Circuit-Judge FE's X Peers Share") ring(0) position(11) cols(2))"'
	
	* Globals FE
	global paperv4_enetc8 "i.year#c.(x_plocct x_pccoun x_b10s x_b20s x_b30s x_b40s x_b50s)"
	global new_enetc8 "i.year#c.(x_pgovt x_b10s x_b20s x_b40s x_b50s)"

	* global enetc8 "i.five_year#c.(x_pgovt x_b10s x_b20s x_b40s x_b50s)"
	
	** jun16 bios enet
	global enetc8 "i.five_year#c.(x_psatty x_pgov x_b10s x_b20s x_b40s x_b50s)"

	global basefe "circuityear judgefe" 
	global basefe_enetc8 "circuityear judgefe $enetc8"

	* new pretrend avg
	foreach var in y_labor_epa_lose y_convote_econ y_convote_nonecon y_cons_antitrust2 y_ellickson_vec econ_pp_17 {

		bys judgefe: egen y_pre_avg_`var' = mean(`var') if manne_L4 | manne_L3 | manne_L2
		bys judgefe: egen y_pre_avg2_`var' = mean(y_pre_avg_`var')
		gen y_pre_avg_miss_`var' = missing(y_pre_avg2_`var')
		replace y_pre_avg2_`var' = 0 if missing(y_pre_avg2_`var')
	}

	foreach y in y_labor_epa_lose {
		
		bys judgefe: egen `y'_pre1_1 = mean(`y') if manne_time == -1
		bys judgefe: egen `y'_pre1 = mean(`y'_pre1_1)
		gen `y'_premiss1 = missing(`y'_pre1)
		replace `y'_pre1 = 0 if `y'_premiss1


		bys judgefe: egen `y'_pre2_1 = mean(`y') if manne_time == -2
		bys judgefe: egen `y'_pre2 = mean(`y'_pre2_1)
		gen `y'_premiss2 = missing(`y'_pre2)
		replace `y'_pre2 = 0 if `y'_premiss2

		bys judgefe: egen `y'_pre3_1 = mean(`y') if manne_time == -3
		bys judgefe: egen `y'_pre3 = mean(`y'_pre3_1)
		gen `y'_premiss3 = missing(`y'_pre3)
		replace `y'_pre3 = 0 if `y'_premiss3

		bys judgefe: egen `y'_pre4_1 = mean(`y') if manne_time == -4
		bys judgefe: egen `y'_pre4 = mean(`y'_pre4_1)
		gen `y'_premiss4 = missing(`y'_pre4)
		replace `y'_pre4 = 0 if `y'_premiss4

		bys judgefe: egen `y'_pre5_1 = mean(`y') if manne_time == -5
		bys judgefe: egen `y'_pre5 = mean(`y'_pre5_1)
		gen `y'_premiss5 = missing(`y'_pre5)
		replace `y'_pre5 = 0 if `y'_premiss5

		bys judgefe: egen `y'_pre6_1 = mean(`y') if manne_time == -6
		bys judgefe: egen `y'_pre6 = mean(`y'_pre6_1)
		gen `y'_premiss6 = missing(`y'_pre6)
		replace `y'_pre6 = 0 if `y'_premiss6

		bys judgefe: egen `y'_pre0_1 = mean(`y') if manne_time == 0
		bys judgefe: egen `y'_pre0 = mean(`y'_pre0_1)
		gen `y'_premiss0 = missing(`y'_pre0)
		replace `y'_pre0 = 0 if `y'_premiss0

		bys judgefe: egen `y'_post1_1 = mean(`y') if manne_time == 1
		bys judgefe: egen `y'_post1 = mean(`y'_post1_1)
		gen `y'_postmiss1 = missing(`y'_post1)
		replace `y'_post1 = 0 if `y'_postmiss1

		bys judgefe: egen `y'_post2_1 = mean(`y') if manne_time == 2
		bys judgefe: egen `y'_post2 = mean(`y'_post2_1)
		gen `y'_postmiss2 = missing(`y'_post2)
		replace `y'_post2 = 0 if `y'_postmiss2

		bys judgefe: egen `y'_post3_1 = mean(`y') if manne_time == 3
		bys judgefe: egen `y'_post3 = mean(`y'_post3_1)
		gen `y'_postmiss3 = missing(`y'_post3)
		replace `y'_post3 = 0 if `y'_postmiss3

		bys judgefe: egen `y'_post4_1 = mean(`y') if manne_time == 4
		bys judgefe: egen `y'_post4 = mean(`y'_post4_1)
		gen `y'_postmiss4 = missing(`y'_post4)
		replace `y'_post4 = 0 if `y'_postmiss4

		bys judgefe: egen `y'_post5_1 = mean(`y') if manne_time == 5
		bys judgefe: egen `y'_post5 = mean(`y'_post5_1)
		gen `y'_postmiss5 = missing(`y'_post5)
		replace `y'_post5 = 0 if `y'_postmiss5

		bys judgefe: egen `y'_post6_1 = mean(`y') if manne_time == 6
		bys judgefe: egen `y'_post6 = mean(`y'_post6_1)
		gen `y'_postmiss6 = missing(`y'_post6)
		replace `y'_post6 = 0 if `y'_postmiss6

	}


	gen two_year = year - mod(year,2)
	gen three_year = year - mod(year,3)
	gen four_year = year - mod(year,4)
	gen five_year = year - mod(year,5)
	gen six_year = year - mod(year,6)
	gen seven_year = year - mod(year,7)

}


// Figures 1, 2, A.2(1) and A.9
// global lgraphs_histograms=1
if ${lgraphs_histograms}==1{

	preserve
	bys caseid: gen id=_n
	keep if id==1
	drop id
	hist year, xlabel(1970 1975 1980 1985 1990 1995 2000 2005) ylabel(2000 4000 6000 8000) freq lcolor(teal) color(olive_teal) discrete barwidth(0.5)
	graph export "$output/lgraphs_histograms/circuit_histogram.pdf", replace
	restore

	preserve
	
	use $data/ready_lgraphs.dta, clear

	lgraph has_manne2 has_manne year if year >= 1950, wide graphregion(fcolor(white)) xtitle("Year") xlabel(1950 1976 1998 2010) ytitle("Proportion of Cases") xline(1976, lcolor(gray) lpattern(dash)) xline(1998, lcolor(gray) lpattern(dash)) legend(order(1 "Ever-Attender On Panel" 2 "Previous-Attender on Panel") position(6) cols(2)) xsize(8) lopt(msize(small)  msymbol(circle_hollow))
	graph export "$output/lgraphs_histograms/lgraph_has_manne_year.pdf", replace

	lgraph convote yearnorm econ_case if yearnorm >= 1950 & yearnorm <= 2002, errortype(se) graphregion(fcolor(white)) xtitle("Year") xlabel(1950 1976 1998) ytitle("Hand-coded Vote Conservativeness") xline(1976, lcolor(gray) lpattern(dash)) xline(1998, lcolor(gray) lpattern(dash)) legend(order(1 "Non-Econ Cases" 2 "Econ Cases") position(6) cols(2)) xsize(8) lopt(msize(small)  msymbol(circle_hollow))
	graph export "$output/lgraphs_histograms/lgraph_convote_rate.pdf", replace


	lgraph y_ellickson_vec yearnorm econ_case if  yearnorm >= 1950 , errortype(se) graphregion(fcolor(white)) xtitle("Year") xlabel(1950 1976 1998 2010) ytitle("Case Similarity to Ellickson-Words Vector") legend(order(1 "Non-Econ Cases" 2 "Econ Cases") position(6) cols(2)) xline(1976, lcolor(gray) lpattern(dash)) xline(1998, lcolor(gray) lpattern(dash)) xsize(8) lopt(msize(small) msymbol(circle_hollow))
	graph export "$output/lgraphs_histograms/lgraph_ellickson_vec.pdf", replace

	restore
}


* Figures 3 & 4
// global circuit_rc_main4=1
if ${circuit_rc_main4}==1 {
	
	foreach manne_window in mw6 {
	
		new_options_program, manne_window(`manne_window')	
				
		** Labor/EPA
		reghdfe y_labor_epa_lose $lags if `manne_window' == 1 [aw=WJT], nocons a($basefe)  cl(judgefe)			
		new_coefficients_program, spec(1) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
		reghdfe y_labor_epa_lose $lags if `manne_window' == 1 [aw=WJT], nocons a($basefe_enetc8)  cl(judgefe)	
		new_coefficients_program, spec(2) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
		reghdfe y_labor_epa_lose $lags if `manne_window' == 1 & year<1987 [aw=WJT], nocons a($basefe)  cl(judgefe)
		new_coefficients_program, spec(3) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)	
		reghdfe y_labor_epa_lose $lags if `manne_window' == 1 [aw=WJT], nocons a($basefe circuitjudge##c.peer_manne_share)  cl(judgefe)
		new_coefficients_program, spec(4) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
		coefplot $coefplot_matrixes_merged4, $general_options_merged xtitle("Years Before and After Manne Attendance") ytitle("Effect on Voting Against Labor/Environmental Agencies") $legendfour ciopts(lwidth(0.4))
		graph export "$output/circuit_main/laborepa_main4.pdf", replace


		** Economics Language - ellickson vec
		foreach sample in econ_case {
			foreach author in author {
				reghdfe y_ellickson_vec $lags if `manne_window' == 1 & `author'==1 & `sample'==1  [aw=WJT], nocons a($basefe)  cl(judgefe)
				new_coefficients_program, spec(1) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
				reghdfe y_ellickson_vec $lags if `manne_window' == 1 & `author'==1 & `sample'==1  [aw=WJT], nocons a($basefe_enetc8)  cl(judgefe)	
				new_coefficients_program, spec(2) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
				reghdfe y_ellickson_vec $lags if `manne_window' == 1 & `author'==1 & `sample'==1 & year<1987 [aw=WJT], nocons a($basefe)  cl(judgefe)
				new_coefficients_program, spec(3) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)	
				reghdfe y_ellickson_vec $lags if `manne_window' == 1 & `author'==1 & `sample'==1  [aw=WJT], nocons a($basefe circuitjudge##c.peer_manne_share)  cl(judgefe)	
				new_coefficients_program, spec(4) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
				coefplot $coefplot_matrixes_merged4, $general_options_merged xtitle("Years Before and After Manne Attendance") ytitle("Effect on Embedding Similarity to Economics Lexicon") $legendfour ciopts(lwidth(0.4))
				graph export "$output/circuit_main/ellickson_vec_main4.pdf", replace
			}
		}

	}

}




* Figure A.3(ab), A.20, A.21(ab), A.22(ab), A.38(abc)
// global circuit_rc_main4_part2=1
if ${circuit_rc_main4_part2}==1 {
	
	foreach manne_window in mw6 {

		new_options_program, manne_window(`manne_window')	

		** y_orig
		reghdfe y_orig $lags if `manne_window' == 1 & econ_case==1 & author==1 [aw=WJT], nocons a($basefe) cl(judgefe)
		new_coefficients_program, spec(1) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
		reghdfe y_orig $lags if `manne_window' == 1 & econ_case==1 & author==1 [aw=WJT], nocons a($basefe_enetc8) cl(judgefe)
		new_coefficients_program, spec(2) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
		reghdfe y_orig $lags if `manne_window' == 1 & year<1987 & econ_case==1 & author==1 [aw=WJT], nocons a($basefe) cl(judgefe)
		new_coefficients_program, spec(3) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
		qui coefplot $coefplot_matrixes_merged3, $general_options_merged  xtitle("Years Before and After Manne Attendance") ytitle("Effect on Bill of Rights Citations") $legendthree ciopts(lwidth(0.4))
		graph export "$output/circuit_appendix/y_orig_main3.pdf", replace
		
		** y_sim_law
		reghdfe y_sim_law $lags if `manne_window' == 1 & econ_case==1 & author==1 [aw=WJT], nocons a($basefe)  cl(judgefe)			
		new_coefficients_program, spec(1) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
		reghdfe y_sim_law $lags if `manne_window' == 1 & econ_case==1 & author==1 [aw=WJT], nocons a($basefe_enetc8)  cl(judgefe)	
		new_coefficients_program, spec(2) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
		reghdfe y_sim_law $lags if `manne_window' == 1 & year<1987 & econ_case==1 & author==1 [aw=WJT], nocons a($basefe)  cl(judgefe)
		new_coefficients_program, spec(3) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)	
		qui coefplot $coefplot_matrixes_merged3, $general_options_merged  xtitle("Years Before and After Manne Attendance") ytitle("Effect on Similarity to Law Journals") $legendthree ciopts(lwidth(0.4))
		graph export "$output/circuit_appendix/y_sim_law_main3.pdf", replace

		** reagan_bush_sc_appt_cites
		reghdfe reagan_bush_sc_appt_cites $lags if `manne_window' == 1 [aw=WJT], nocons a($basefe)  cl(judgefe)			
		new_coefficients_program, spec(1) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
		reghdfe reagan_bush_sc_appt_cites $lags if `manne_window' == 1 [aw=WJT], nocons a($basefe_enetc8)  cl(judgefe)	
		new_coefficients_program, spec(2) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
		reghdfe reagan_bush_sc_appt_cites $lags if `manne_window' == 1 & year<1987 [aw=WJT], nocons a($basefe)  cl(judgefe)
		new_coefficients_program, spec(3) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)	
		reghdfe reagan_bush_sc_appt_cites $lags if `manne_window' == 1 [aw=WJT], nocons a($basefe circuitjudge##c.peer_manne_share)  cl(judgefe)
		new_coefficients_program, spec(4) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
		qui coefplot $coefplot_matrixes_merged4, $general_options_merged  xtitle("Years Before and After Manne Attendance") ytitle("Effect on Citations to Reagan/Bush's Nominee") $legendfour ciopts(lwidth(0.4))
		graph export "$output/circuit_appendix/reagan_bush_sc_appt_cites_main4.pdf", replace

		foreach sample in econ_case non_econ_case{
			
			** cites_out
			reghdfe pct_cites_outside $lags if `manne_window' == 1 & `sample'==1 [aw=WJT], nocons a($basefe)  cl(judgefe)			
			new_coefficients_program, spec(1) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
			reghdfe pct_cites_outside $lags if `manne_window' == 1 & `sample'==1 [aw=WJT], nocons a($basefe_enetc8)  cl(judgefe)	
			new_coefficients_program, spec(2) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
			reghdfe pct_cites_outside $lags if `manne_window' == 1 & year<1987 & `sample'==1 [aw=WJT], nocons a($basefe)  cl(judgefe)
			new_coefficients_program, spec(3) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)	
			reghdfe pct_cites_outside $lags if `manne_window' == 1 & `sample'==1 [aw=WJT], nocons a($basefe circuitjudge##c.peer_manne_share)  cl(judgefe)
			new_coefficients_program, spec(4) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)	
			qui coefplot $coefplot_matrixes_merged4, $general_options_merged  xtitle("Years Before and After Manne Attendance") ytitle("Effect on Outside of Circuit Citations") $legendfour ciopts(lwidth(0.4))
			graph export "$output/circuit_appendix/pct_cites_outside_`sample'_main4.pdf", replace

		}


		** Statistic language
		reghdfe wc_statistics $lags if `manne_window' == 1 & econ_case==1 & author==1 [aw=WJT], nocons a($basefe)  cl(judgefe)			
		new_coefficients_program, spec(1) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
		reghdfe wc_statistics $lags if `manne_window' == 1 & econ_case==1 & author==1 [aw=WJT], nocons a($basefe_enetc8)  cl(judgefe)	
		new_coefficients_program, spec(2) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
		reghdfe wc_statistics $lags if `manne_window' == 1 & year<1987 & econ_case==1 & author==1 [aw=WJT], nocons a($basefe)  cl(judgefe)
		new_coefficients_program, spec(3) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)		
		qui coefplot $coefplot_matrixes_merged3, $general_options_merged  xtitle("Years Before and After Manne Attendance") ytitle("Effect on Statistic Jargon Counts") $legendthree ciopts(lwidth(0.4))
		graph export "$output/circuit_appendix/wc_statistics_main3_econ_authors.pdf", replace

		** Quantitative language
		reghdfe y_count_dc $lags if `manne_window' == 1 & econ_case==1 & author==1 [aw=WJT], nocons a($basefe)  cl(judgefe)			
		new_coefficients_program, spec(1) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
		reghdfe y_count_dc $lags if `manne_window' == 1 & econ_case==1 & author==1 [aw=WJT], nocons a($basefe_enetc8)  cl(judgefe)	
		new_coefficients_program, spec(2) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
		reghdfe y_count_dc $lags if `manne_window' == 1 & year<1987 & econ_case==1 & author==1 [aw=WJT], nocons a($basefe)  cl(judgefe)
		new_coefficients_program, spec(3) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)	
		qui coefplot $coefplot_matrixes_merged3, $general_options_merged  xtitle("Years Before and After Manne Attendance") ytitle("Effect on Quantitative Jargon Counts") $legendthree ciopts(lwidth(0.4))
		graph export "$output/circuit_appendix/y_count_dc_main3_econ_authors.pdf", replace


		** Econ_case
		eststo clear 
		eststo: reghdfe econ_case manne [aw=WJT], absorb(circuityear) cluster(judgefe) nocons
		eststo: reghdfe econ_case manne_post if manne [aw=WJT], absorb(circuityear judgefe ) cluster(judgefe) nocons
		eststo: reghdfe econ_case manne_post if mw6 [aw=WJT], absorb(circuityear judgefe ) cluster(judgefe) nocons
		coefplot est*, xline(0, lpattern(dash) lcolor(gray)) legend(order(2 "Manne" 4 "Manne Post" 6 "Manne Post"))
		graph export "$output/circuit_appendix/circuit_econ_cases_merged_`manne_window'.pdf", replace
		eststo clear

		** author
		eststo clear 
		eststo: reghdfe author manne if econ_case==1 [aw=WJT], absorb(circuityear) cluster(judgefe) nocons
		eststo: reghdfe author manne_post if manne & econ_case==1 [aw=WJT], absorb(circuityear judgefe ) cluster(judgefe) nocons
		eststo: reghdfe author manne_post if mw6 & econ_case==1 [aw=WJT], absorb(circuityear judgefe ) cluster(judgefe) nocons
		coefplot est*, xline(0, lpattern(dash) lcolor(gray)) legend(order(2 "Manne" 4 "Manne Post" 6 "Manne Post"))
		graph export "$output/circuit_appendix/circuit_author_econ_cases_merged_`manne_window'.pdf", replace
		eststo clear
		

		** Economics Language - econ_pp_17
		foreach sample in non_econ_case {

			foreach author in author {

				reghdfe econ_pp_17 $lags if `manne_window' == 1 & `author'==1 & `sample'==1  [aw=WJT], nocons a($basefe)  cl(judgefe)	
				new_coefficients_program, spec(1) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
				reghdfe econ_pp_17 $lags if `manne_window' == 1 & `author'==1 & `sample'==1  [aw=WJT], nocons a($basefe_enetc8)  cl(judgefe)	
				new_coefficients_program, spec(2) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
				reghdfe econ_pp_17 $lags if `manne_window' == 1 & `author'==1 & `sample'==1 & year<1987 [aw=WJT], nocons a($basefe)  cl(judgefe)
				new_coefficients_program, spec(3) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)	
				coefplot $coefplot_matrixes_merged3, $general_options_merged xtitle("Years Before and After Manne Attendance") ytitle("Effect on ML-Predicted Relation to Economics") $legendthree ciopts(lwidth(0.4))
				graph export "$output/circuit_appendix/econ_pp_17_main3.pdf", replace

			}
		}
	}

}



* Figure A.4 & A.5
// global lgraphs_wjt=1
if ${lgraphs_wjt}==1 {
		
	label var year "Year"
	cap gen wjt5=WJT
	cap gen wjt10=WJT
	winsor2 wjt5, replace cuts(5 95)
	winsor2 wjt10, replace cuts(10 90)
	
	foreach weight in wjt5 {
	*
	* SEPARATED SMOOTHING
	preserve 
	expand 5
	duplicates tag, gen(tag)
	drop if tag==5
	bys caseid songername: gen id=_n
	replace year=year-2 if id==1 & year<=1975
	replace year=year-1 if id==2 & year<=1975
	replace year=year+1 if id==4 & year<1975
	replace year=year+2 if id==5 & year<1974	
	drop if id==5 & year==1974	
	drop if id==5 & year==1975	
	drop if id==4 & year==1975	
	*
	replace year=year-2 if id==1 & year>1977
	replace year=year-1 if id==2 & year>1976
	replace year=year+1 if id==4 & year>=1976
	replace year=year+2 if id==5 & year>=1976
	drop if id==1 & year==1977
	drop if id==1 & year==1976	
	drop if id==2 & year==1976
		foreach outcome in y_labor_epa_lose y_ellickson_vec {
		lgraph  `outcome' year if (inlist(attend_year,1976,1977,1978,1979,1980) | !everattend) & inrange(year,1970,1986) [aw=`weight'], by(everattend)  xline(1975, lpattern(dash) lcolor(gray)) sep(0.01) legend(order(1 "Never-attenders" 2 "Attenders") position(6) cols(2))
		graph export "$output/lgraphs_histograms/lgraph_smoothed_over5_`outcome'_attendyear_w5_1976,1977,1978,1979,1980_`weight'.pdf", replace
		}
	restore
	*
	preserve 
	expand 5
	duplicates tag, gen(tag)
	drop if tag==5
	bys caseid songername: gen id=_n
	replace year=year-2 if id==1 & year<=1980
	replace year=year-1 if id==2 & year<=1980
	replace year=year+1 if id==4 & year<1980
	replace year=year+2 if id==5 & year<1979
	drop if id==5 & year==1979
	drop if id==5 & year==1980	
	drop if id==4 & year==1980	
	*
	replace year=year-2 if id==1 & year>1982
	replace year=year-1 if id==2 & year>1981
	replace year=year+1 if id==4 & year>=1981
	replace year=year+2 if id==5 & year>=1981	
	drop if id==1 & year==1982
	drop if id==1 & year==1981	
	drop if id==2 & year==1981
		foreach outcome in y_labor_epa_lose y_ellickson_vec {
		lgraph  `outcome' year if (inlist(attend_year,1981,1982,1984,1986,1987) | !everattend) & inrange(year,1976,1992) [aw=`weight'], by(everattend) xline(1980, lpattern(dash) lcolor(gray)) sep(0.01) legend(order(1 "Never-attenders" 2 "Attenders") position(6) cols(2))
		graph export "$output/lgraphs_histograms/lgraph_smoothed_over5_`outcome'_attendyear_w5_1981,1982,1984,1986,1987_`weight'.pdf", replace
		}
	restore	
	*
	preserve 
	expand 5
	duplicates tag, gen(tag)
	drop if tag==5
	bys caseid songername: gen id=_n
	replace year=year-2 if id==1 & year<=1987
	replace year=year-1 if id==2 & year<=1987
	replace year=year+1 if id==4 & year<1987
	replace year=year+2 if id==5 & year<1986
	drop if id==5 & year==1986
	drop if id==5 & year==1987
	drop if id==4 & year==1987
	*
	replace year=year-2 if id==1 & year>1989
	replace year=year-1 if id==2 & year>1988
	replace year=year+1 if id==4 & year>=1988
	replace year=year+2 if id==5 & year>=1988	
	drop if id==1 & year==1989
	drop if id==1 & year==1988	
	drop if id==2 & year==1988
		foreach outcome in y_labor_epa_lose y_ellickson_vec {
		lgraph  `outcome' year if (inlist(attend_year,1988,1989,1990,1991,1992) | !everattend) & inrange(year,1982,1998) [aw=`weight'], by(everattend) xline(1987, lpattern(dash) lcolor(gray)) sep(0.01) legend(order(1 "Never-attenders" 2 "Attenders") position(6) cols(2))
		graph export "$output/lgraphs_histograms/lgraph_smoothed_over5_`outcome'_attendyear_w5_1988,1989,1990,1991,1992_`weight'.pdf", replace
		}
	restore	
	*
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
		foreach outcome in y_labor_epa_lose y_ellickson_vec {
		lgraph  `outcome' year if (inlist(attend_year,1993,1994,1995,1996,1997,1998) | !everattend) & inrange(year,1987,2003) [aw=`weight'], by(everattend) xline(1992, lpattern(dash) lcolor(gray)) sep(0.01) legend(order(1 "Never-attenders" 2 "Attenders") position(6) cols(2))
		graph export "$output/lgraphs_histograms/lgraph_smoothed_over5_`outcome'_attendyear_w6_1993,1994,1995,1996,1997,1998_`weight'.pdf", replace	
		}
	restore
	*
	}	
*
}



* A.12 & A.26
**** Excluding some circuits
// global circuit_rc_dropcircuits=1
if ${circuit_rc_dropcircuits}==1 {

	preserve 
	drop if inlist(circuit,2,8,9,12)	

// 	foreach manne_window in mw6 {
//
// 		new_options_program, manne_window(`manne_window')	
// 		*	
// 		** Labor/EPA
// 		reghdfe y_labor_epa_lose $lags if `manne_window' == 1 [aw=WJT], nocons a($basefe)  cl(judgefe)			
// 		new_coefficients_program, spec(1) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
// 		reghdfe y_labor_epa_lose $lags if `manne_window' == 1 [aw=WJT], nocons a($basefe_enetc8)  cl(judgefe)	
// 		new_coefficients_program, spec(2) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
// 		reghdfe y_labor_epa_lose $lags if `manne_window' == 1 & year<1987 [aw=WJT], nocons a($basefe)  cl(judgefe)
// 		new_coefficients_program, spec(3) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)	
// 		reghdfe y_labor_epa_lose $lags if `manne_window' == 1 [aw=WJT], nocons a($basefe circuitjudge##c.peer_manne_share)  cl(judgefe)
// 		new_coefficients_program, spec(4) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)	
// 		coefplot $coefplot_matrixes_merged4, $general_options_merged  xtitle("Years Before and After Manne Attendance") ytitle("Effect on Voting Against Labor/Environmental Agencies") $legendfour ciopts(lwidth(0.4))
// 		graph export "$output/circuit_appendix/circuit_laborepa_merged_`manne_window'_nocirc.pdf", replace
//
// 		foreach sample in econ_case {
// 			foreach author in author {	
// 				** Economics Language - ellickson vec
// 				reghdfe y_ellickson_vec $lags if `manne_window' == 1 & `author'==1 & `sample'==1  [aw=WJT], nocons a($basefe)  cl(judgefe)	
// 				new_coefficients_program, spec(1) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
// 				reghdfe y_ellickson_vec $lags if `manne_window' == 1 & `author'==1 & `sample'==1  [aw=WJT], nocons a($basefe_enetc8)  cl(judgefe)	
// 				new_coefficients_program, spec(2) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
// 				reghdfe y_ellickson_vec $lags if `manne_window' == 1 & `author'==1 & `sample'==1 & year<1987 [aw=WJT], nocons a($basefe)  cl(judgefe)
// 				new_coefficients_program, spec(3) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)	
// 				reghdfe y_ellickson_vec $lags if `manne_window' == 1 & `author'==1 & `sample'==1  [aw=WJT], nocons a($basefe circuitjudge##c.peer_manne_share)  cl(judgefe)	
// 				new_coefficients_program, spec(4) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)	
// 				coefplot $coefplot_matrixes_merged4, $general_options_merged xtitle("Years Before and After Manne Attendance") ytitle("Effect on Embedding Similarity to Economics Lexicon") $legendfour ciopts(lwidth(0.4))
// 				graph export "$output/circuit_appendix/circuit_ellickson_vec_merged_`author'_`sample'_`manne_window'_nocirc.pdf", replace		
// 			}
// 		}	
// 	}

	restore


	gen circuit_drop = circuit == 2 | circuit == 8 | circuit == 9 | circuit == 12

	eststo clear
	forvalues c = 0/12 {

	    eststo est_`c': reghdfe y_ellickson_vec manne_post if mw6 == 1 & is_author == 1 & econ_case == 1 & circuit != `c' [aw=WJT], nocons a(circuityear judgefe)  cl(judgefe)
	}

	eststo est_drop: reghdfe y_ellickson_vec manne_post if mw6 == 1 & is_author == 1 & econ_case == 1 & !circuit_drop [aw=WJT], nocons a(circuityear judgefe)  cl(judgefe)
	coefplot (est_0, rename(manne_post=drop_0) \ ///
			 est_1, rename(manne_post=drop_1) \ ///
			 est_2, rename(manne_post=drop_2) \ ///
			 est_3, rename(manne_post=drop_3) \ ///
			 est_4, rename(manne_post=drop_4) \ ///
			 est_5, rename(manne_post=drop_5) \ ///
			 est_6, rename(manne_post=drop_6) \ ///
			 est_7, rename(manne_post=drop_7) \ ///
			 est_8, rename(manne_post=drop_8) \ ///
			 est_9, rename(manne_post=drop_9) \ ///
			 est_10, rename(manne_post=drop_10) \ ///
			 est_11, rename(manne_post=drop_11) \ ///
			 est_12, rename(manne_post=drop_12) \ ///
			 est_drop, rename(manne_post=drop_4courts)), legend(off) xline(0, lpattern(dash) lcolor(black)) levels(95 90) ytitle("") mcolor(maroon) ciopts(color(gs2 gs1))
	graph export "$output/circuit_appendix/ellickson_circuit_drop_mw6.pdf", replace


	eststo clear
	forvalues c = 0/12 {
		
		eststo est_`c': reghdfe y_labor_epa_lose manne_post if mw6 == 1 & circuit != `c' [aw=WJT], nocons a(circuityear judgefe)  cl(judgefe)
	}

	eststo est_drop: reghdfe y_labor_epa_lose manne_post if mw6 == 1 & !circuit_drop [aw=WJT], nocons a(circuityear judgefe)  cl(judgefe)

	coefplot (est_0, rename(manne_post=drop_0) \ ///
			 est_1, rename(manne_post=drop_1) \ ///
			 est_2, rename(manne_post=drop_2) \ ///
			 est_3, rename(manne_post=drop_3) \ ///
			 est_4, rename(manne_post=drop_4) \ ///
			 est_5, rename(manne_post=drop_5) \ ///
			 est_6, rename(manne_post=drop_6) \ ///
			 est_7, rename(manne_post=drop_7) \ ///
			 est_8, rename(manne_post=drop_8) \ ///
			 est_9, rename(manne_post=drop_9) \ ///
			 est_10, rename(manne_post=drop_10) \ ///
			 est_11, rename(manne_post=drop_11) \ ///
			 est_12, rename(manne_post=drop_12) \ ///
			 est_drop, rename(manne_post=drop_4courts)), legend(off) xline(0, lpattern(dash) lcolor(black)) levels(95 90) ytitle("") mcolor(maroon) ciopts(color(gs2 gs1))
	graph export "$output/circuit_appendix/laborepa_circuit_drop_mw6.pdf", replace

}

* Figures A.13 & A.27
**** Topic fixed effect
// global circuit_rc_topicfe=1
if ${circuit_rc_topicfe}==1 {


	foreach manne_window in mw6 {

		new_options_program, manne_window(`manne_window')	

		** Labor/EPA
		reghdfe y_labor_epa_lose $lags if `manne_window' == 1 [aw=WJT], nocons a($basefe topic)  cl(judgefe)			
		new_coefficients_program, spec(1) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
		reghdfe y_labor_epa_lose $lags if `manne_window' == 1 [aw=WJT], nocons a($basefe_enetc8 topic)  cl(judgefe)	
		new_coefficients_program, spec(2) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
		reghdfe y_labor_epa_lose $lags if `manne_window' == 1 & year<1987 [aw=WJT], nocons a($basefe topic)  cl(judgefe)
		new_coefficients_program, spec(3) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)	
		coefplot $coefplot_matrixes_merged3, $general_options_merged  xtitle("Years Before and After Manne Attendance") ytitle("Effect on Voting Against Labor/Environmental Agencies") $legendthree ciopts(lwidth(0.4))
		graph export "$output/circuit_appendix/circuit_laborepa_merged_`manne_window'_topicfe.pdf", replace
			
		foreach sample in econ_case {
			foreach author in author {	
			** Economics Language - ellickson vec
			reghdfe y_ellickson_vec $lags if `manne_window' == 1 & `author'==1 & `sample'==1  [aw=WJT], nocons a($basefe topic)  cl(judgefe)	
			new_coefficients_program, spec(1) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
			reghdfe y_ellickson_vec $lags if `manne_window' == 1 & `author'==1 & `sample'==1  [aw=WJT], nocons a($basefe_enetc8 topic)  cl(judgefe)	
			new_coefficients_program, spec(2) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
			reghdfe y_ellickson_vec $lags if `manne_window' == 1 & `author'==1 & `sample'==1 & year<1987 [aw=WJT], nocons a($basefe topic)  cl(judgefe)
			new_coefficients_program, spec(3) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)	
			coefplot $coefplot_matrixes_merged3, $general_options_merged xtitle("Years Before and After Manne Attendance") ytitle("Effect on Embedding Similarity to Economics Lexicon") $legendthree ciopts(lwidth(0.4))
			graph export  "$output/circuit_appendix/circuit_ellickson_vec_merged_`author'_`sample'_`manne_window'_topicfe.pdf", replace			
			}
		}
	}	

}	


* A.14 & A.28
**** Cluster se judge-circuityear
// global circuit_rc_cljudgecircuityear=1
if ${circuit_rc_cljudgecircuityear}==1 {
	
	foreach manne_window in mw6 {

		new_options_program, manne_window(`manne_window')	

		** Labor/EPA
		reghdfe y_labor_epa_lose $lags if `manne_window' == 1 [aw=WJT], nocons a($basefe)  cl(judgefe circuityear)			
		new_coefficients_program, spec(1) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
		reghdfe y_labor_epa_lose $lags if `manne_window' == 1 [aw=WJT], nocons a($basefe_enetc8)  cl(judgefe circuityear)	
		new_coefficients_program, spec(2) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
		reghdfe y_labor_epa_lose $lags if `manne_window' == 1 & year<1987 [aw=WJT], nocons a($basefe)  cl(judgefe circuityear)
		new_coefficients_program, spec(3) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
		coefplot $coefplot_matrixes_merged3, $general_options_merged  xtitle("Years Before and After Manne Attendance") ytitle("Effect on Voting Against Labor/Environmental Agencies") $legendthree ciopts(lwidth(0.4))
		graph export "$output/circuit_appendix/circuit_laborepa_merged_`manne_window'_clcircuityear.pdf", replace

		foreach sample in econ_case {
			foreach author in author {
				** Economics Language - ellickson vec
				reghdfe y_ellickson_vec $lags if `manne_window' == 1 & `author'==1 & `sample'==1  [aw=WJT], nocons a($basefe)  cl(judgefe circuityear)	
				new_coefficients_program, spec(1) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
				reghdfe y_ellickson_vec $lags if `manne_window' == 1 & `author'==1 & `sample'==1  [aw=WJT], nocons a($basefe_enetc8)  cl(judgefe circuityear)	
				new_coefficients_program, spec(2) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
				reghdfe y_ellickson_vec $lags if `manne_window' == 1 & `author'==1 & `sample'==1 & year<1987 [aw=WJT], nocons a($basefe)  cl(judgefe circuityear)
				new_coefficients_program, spec(3) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)	
				coefplot $coefplot_matrixes_merged3, $general_options_merged xtitle("Years Before and After Manne Attendance") ytitle("Effect on Embedding Similarity to Economics Lexicon") $legendthree ciopts(lwidth(0.4))
				graph export "$output/circuit_appendix/circuit_ellickson_vec_merged_`author'_`sample'_`manne_window'_clcircuityear.pdf", replace	
			}
		}		
	}

}




* elasticnetXyear robustness
* Figures 16 & 30
// global elasticnet_robustness=1
if ${elasticnet_robustness}==1 {

	foreach manne_window in mw6 {
	
		new_options_program, manne_window(`manne_window')	

				
		** Labor/EPA
		reghdfe y_labor_epa_lose $lags if `manne_window' == 1 [aw=WJT], nocons a(circuityear judgefe i.year##c.(x_pgovt x_b10s x_b20s x_b30s x_b40s x_b50s))  cl(judgefe)	
		new_coefficients_program, spec(1) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
		reghdfe y_labor_epa_lose $lags if `manne_window' == 1 [aw=WJT], nocons a(circuityear judgefe i.two_year##c.(x_pgovt x_b10s x_b20s x_b30s x_b40s x_b50s))  cl(judgefe)	
		new_coefficients_program, spec(2) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
		reghdfe y_labor_epa_lose $lags if `manne_window' == 1 [aw=WJT], nocons a(circuityear judgefe i.three_year##c.(x_pgovt x_b10s x_b20s x_b30s x_b40s x_b50s))  cl(judgefe)	
		new_coefficients_program, spec(3) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
		reghdfe y_labor_epa_lose $lags if `manne_window' == 1 [aw=WJT], nocons a(circuityear judgefe i.four_year##c.(x_pgovt x_b10s x_b20s x_b30s x_b40s x_b50s))  cl(judgefe)	
		new_coefficients_program, spec(4) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
		reghdfe y_labor_epa_lose $lags if `manne_window' == 1 [aw=WJT], nocons a(circuityear judgefe i.five_year##c.(x_pgovt x_b10s x_b20s x_b30s x_b40s x_b50s))  cl(judgefe)	
		new_coefficients_program, spec(5) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
		reghdfe y_labor_epa_lose $lags if `manne_window' == 1 [aw=WJT], nocons a(circuityear judgefe i.six_year##c.(x_pgovt x_b10s x_b20s x_b30s x_b40s x_b50s))  cl(judgefe)	
		new_coefficients_program, spec(6) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
		reghdfe y_labor_epa_lose $lags if `manne_window' == 1 [aw=WJT], nocons a(circuityear judgefe i.seven_year##c.(x_pgovt x_b10s x_b20s x_b30s x_b40s x_b50s))  cl(judgefe)	
		new_coefficients_program, spec(7) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
		coefplot $coefplot_matrixes_merged7, $general_options_merged xtitle("Years Before and After Manne Attendance") ytitle("Effect on Voting Against Labor/Environmental Agencies") legend(order(2 "1-year X Enet" 4 "2-year X Enet" 6 "3-year X Enet" 8 "4-year X Enet" 10 "5-year X Enet" 12 "6-year X Enet" 14 "7-year X Enet") size(small) ring(0) position(11) cols(2)) ciopts(lwidth(0.4))
		graph export  "$output/circuit_appendix/laborepa_elasticnet_year.pdf", replace



		** Economics Language - ellickson vec
		foreach sample in econ_case {
			foreach author in author {

				** Labor/EPA
				reghdfe y_ellickson_vec $lags if `manne_window' == 1 & `author'==1 & `sample'==1  [aw=WJT], nocons a(circuityear judgefe i.year##c.(x_pgovt x_b10s x_b20s x_b30s x_b40s x_b50s))  cl(judgefe)	
				new_coefficients_program, spec(1) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
				reghdfe y_ellickson_vec $lags if `manne_window' == 1 & `author'==1 & `sample'==1  [aw=WJT], nocons a(circuityear judgefe i.two_year##c.(x_pgovt x_b10s x_b20s x_b30s x_b40s x_b50s))  cl(judgefe)	
				new_coefficients_program, spec(2) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
				reghdfe y_ellickson_vec $lags if `manne_window' == 1 & `author'==1 & `sample'==1  [aw=WJT], nocons a(circuityear judgefe i.three_year##c.(x_pgovt x_b10s x_b20s x_b30s x_b40s x_b50s))  cl(judgefe)	
				new_coefficients_program, spec(3) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
				reghdfe y_ellickson_vec $lags if `manne_window' == 1 & `author'==1 & `sample'==1  [aw=WJT], nocons a(circuityear judgefe i.four_year##c.(x_pgovt x_b10s x_b20s x_b30s x_b40s x_b50s))  cl(judgefe)	
				new_coefficients_program, spec(4) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
				reghdfe y_ellickson_vec $lags if `manne_window' == 1 & `author'==1 & `sample'==1  [aw=WJT], nocons a(circuityear judgefe i.five_year##c.(x_pgovt x_b10s x_b20s x_b30s x_b40s x_b50s))  cl(judgefe)	
				new_coefficients_program, spec(5) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
				reghdfe y_ellickson_vec $lags if `manne_window' == 1 & `author'==1 & `sample'==1  [aw=WJT], nocons a(circuityear judgefe i.six_year##c.(x_pgovt x_b10s x_b20s x_b30s x_b40s x_b50s))  cl(judgefe)	
				new_coefficients_program, spec(6) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)	
				reghdfe y_ellickson_vec $lags if `manne_window' == 1 & `author'==1 & `sample'==1  [aw=WJT], nocons a(circuityear judgefe i.seven_year##c.(x_pgovt x_b10s x_b20s x_b30s x_b40s x_b50s))  cl(judgefe)	
				new_coefficients_program, spec(7) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)			
				coefplot $coefplot_matrixes_merged7, $general_options_merged xtitle("Years Before and After Manne Attendance") ytitle("Effect on Embedding Similarity to Economics Lexicon") legend(order(2 "1-year X Enet" 4 "2-year X Enet" 6 "3-year X Enet" 8 "4-year X Enet" 10 "5-year X Enet" 12 "6-year X Enet" 14 "7-year X Enet") size(small) ring(0) position(11) cols(2)) ciopts(lwidth(0.4))
				graph export  "$output/circuit_appendix/ellickson_vec_elasticnet_year.pdf", replace
			}
		}
	}


}


* Figure A.31
// global circuit_a31=1
if ${circuit_a31}==1 {

	foreach manne_window in mw6 {

		new_options_program, manne_window(`manne_window')	


		** Hand-Coded Conservative Votes
		reghdfe y_convote_econ $lags if `manne_window' == 1  [aw=WJT], nocons a($basefe)  cl(judgefe)	
		new_coefficients_program, spec(1) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
		reghdfe y_convote_econ $lags if `manne_window' == 1  [aw=WJT], nocons a($basefe_enetc8)  cl(judgefe)	
		new_coefficients_program, spec(2) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
		reghdfe y_convote_econ $lags if `manne_window' == 1 & year<1987  [aw=WJT], nocons a($basefe)  cl(judgefe)	
		new_coefficients_program, spec(3) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)	
		reghdfe y_convote_nonecon $lags if `manne_window' == 1   [aw=WJT], nocons a($basefe)  cl(judgefe)	
		new_coefficients_program, spec(4) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
		reghdfe y_convote_nonecon $lags if `manne_window' == 1   [aw=WJT], nocons a($basefe_enetc8)  cl(judgefe)	
		new_coefficients_program, spec(5) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
		reghdfe y_convote_nonecon $lags if `manne_window' == 1 & year<1987  [aw=WJT], nocons a($basefe)  cl(judgefe)	
		new_coefficients_program, spec(6) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)	
		coefplot $coefplot_matrixes_convote3, $general_options_merged ///
			xtitle("Years Before and After Manne Attendance") ytitle("Effect on Conservative Vote") legend(order(2 "Econ: Judge FE's + Circuit-Year FE's" 8 "Non-Econ: Judge FE's + Circuit-Year FE's" 4 "Econ: + Elastic Net Controls × 5-Year" 10 "Non-Econ: + Elastic Net Controls × 5-Year" 6 "Econ: < 1987" 12 "Non-Econ: < 1987") size(small) ring(0) position(11) cols(2)) ciopts(lwidth(0.5))
		graph export "$output/circuit_appendix/convotepooled`manne_window'_main8.pdf", replace

	}


}





* A.23
global circuit_fig_23=1
if ${circuit_fig_23}==1{

		
	**** New pretrend avg
	global circuit_rc_pretrendavg=1
	if ${circuit_rc_pretrendavg}==1 {

		foreach manne_window in mw6 {

			new_options_program, manne_window(`manne_window')	

			* Single graphs
			local y y_labor_epa_lose
			reghdfe y_labor_epa_lose $lags if `manne_window' == 1 [aw=WJT], nocons a(two_year##c.(y_pre_avg2_y_labor_epa_lose y_pre_avg_miss_y_labor_epa_lose `y'_premiss1) $basefe)  cl(judgefe)			
			new_coefficients_program, spec(1) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)	
			coefplot $coefplot_matrixes, $general_options_merged xtitle("Years Before and After Manne Attendance") ytitle("Effect on Voting Against Labor/Environmental Agencies") legend(off)
			graph export "$output/circuit_appendix/pretrend_avg_circuit_laborepa_`manne_window'.pdf", replace

	
		}
	}	



	**** New spec for laborepa and antitrust - pre_post_missings
	global circuit_rc_newspec=1
	if ${circuit_rc_newspec}==1 {
		
		foreach manne_window in mw6 {

			new_options_program, manne_window(`manne_window')	

			** Labor/EPA	
			local y y_labor_epa_lose
			reghdfe `y' $lags if `manne_window' == 1  [aw=WJT], nocons a($basefe two_year##c.(`y'_premiss2 `y'_premiss1 `y'_premiss0 `y'_postmiss1 `y'_postmiss2)) cl(judgefe)
			new_coefficients_program, spec(1) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
			coefplot $coefplot_matrixes, $general_options_merged xtitle("Years Before and After Manne Attendance") ytitle("Effect on Voting Against Labor/Environmental Agencies")  legend(off)
			macro drop dot coef_post coef_pre se_pre se_post
			graph export "$output/circuit_appendix/pre_post_missings_circuit_laborepa_`manne_window'.pdf", replace
		

		
		}
	}



}


* Figures A.18, A.19
// global circuit_calibration_plots=1
if ${circuit_calibration_plots}==1 {

	*// make calibration plot econ_pp_17 ~ econ_case
	binscatter econ_case econ_pp_17 , xtitle("ML-Predicted Econ Probability (Standardized)") ytitle("Probability on Econ Topic") xsize(6)
	graph export "$output/calibration_plots/econ_case-econ_pp-17.pdf", replace

	*// binscatter econ_pp_17 ~ ellickson_embedding
	binscatter econ_pp_17 y_ellickson_vec , ytitle("ML-Predicted Econ Probability (Standardized)") xtitle("Embedding Similarity to Economics") xsize(6)
	graph export "$output/calibration_plots/ellickson-econ_pp-17.pdf", replace

}




* Figures A.11 & A.25
**** Other window
// global circuit_rc_other_window=1
if ${circuit_rc_other_window}==1 {	

	cap drop balanced_L4 
	bys songername: egen balanced_L4 = total(manne_L4)

	cap drop balanced4_3
	gen balanced4_3=1 if balanced_L4 > 0 & balanced_L3>0 & balanced_L2>0 & balanced_L1>0 & balanced_0>0 & balanced_F1>0 & balanced_F2>0 & balanced_F3>0 

	cap drop mw43
	gen mw43 = manne_time >= -4 & manne_time <= 3


	foreach manne_window in mw43 {

		new_options_program, manne_window(`manne_window')	
		

		** Labor/EPA
		reghdfe y_labor_epa_lose $lags if `manne_window' == 1 & balanced4_3==1 [aw=WJT], nocons a($basefe)  cl(judgefe)		
		matlist r(table)
		new_coefficients_program, spec(1) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
		reghdfe y_labor_epa_lose $lags if `manne_window' == 1 & balanced4_3==1 [aw=WJT], nocons a($basefe_enetc8)  cl(judgefe)	
		new_coefficients_program, spec(2) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
		reghdfe y_labor_epa_lose $lags if `manne_window' == 1 & balanced4_3==1 & year<1987 [aw=WJT], nocons a($basefe)  cl(judgefe)
		new_coefficients_program, spec(3) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)	
		coefplot $coefplot_matrixes_merged3, $general_options_merged xtitle("Years Before and After Manne Attendance") ytitle("Effect on Voting Against Labor/Environmental Agencies") $legendthree ciopts(lwidth(0.4))
		graph export "$output/circuit_appendix/circuit_laborepa_merged_`manne_window'_nopeer.pdf", replace
		
		
		foreach sample in econ_case {
			foreach author in author {			
			** Economics Language - ellickson vec
			reghdfe y_ellickson_vec $lags if `manne_window' == 1 & balanced4_3==1 & `author'==1 & `sample'==1  [aw=WJT], nocons a($basefe)  cl(judgefe)	
			new_coefficients_program, spec(1) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
			reghdfe y_ellickson_vec $lags if `manne_window' == 1 & balanced4_3==1 & `author'==1 & `sample'==1  [aw=WJT], nocons a($basefe_enetc8)  cl(judgefe)	
			new_coefficients_program, spec(2) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
			reghdfe y_ellickson_vec $lags if `manne_window' == 1 & balanced4_3==1 & `author'==1 & `sample'==1 & year<1987 [aw=WJT], nocons a($basefe)  cl(judgefe)
			new_coefficients_program, spec(3) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)	
			coefplot $coefplot_matrixes_merged3, $general_options_merged xtitle("Years Before and After Manne Attendance") ytitle("Effect on Embedding Similarity to Economics Lexicon") $legendthree ciopts(lwidth(0.4))
			graph export  "$output/circuit_appendix/circuit_ellickson_vec_merged_`author'_`sample'_`manne_window'_nopeer.pdf", replace			
			}
		}				
		
	}


}


* drop other lags
* Figures A.15 & A.29
// global circuit_lags=1
if ${circuit_lags}==1 {
	
	foreach manne_window in mw6 {
				
		** Labor/EPA

		eststo clear

		** drop L6
		eststo woL6: reghdfe y_labor_epa_lose manne_L5 manne_L4 manne_L3 manne_L2 manne_0 manne_F1 manne_F2 manne_F3 manne_F4 manne_F5 manne_F6 if `manne_window' == 1 [aw=WJT], nocons a($basefe)  cl(judgefe)

		** drop L5
		eststo woL5: reghdfe y_labor_epa_lose manne_L6 manne_L4 manne_L3 manne_L2 manne_0 manne_F1 manne_F2 manne_F3 manne_F4 manne_F5 manne_F6 if `manne_window' == 1 [aw=WJT], nocons a($basefe)  cl(judgefe)

		** drop L4
		eststo woL4: reghdfe y_labor_epa_lose manne_L6 manne_L5 manne_L3 manne_L2 manne_0 manne_F1 manne_F2 manne_F3 manne_F4 manne_F5 manne_F6 if `manne_window' == 1 [aw=WJT], nocons a($basefe)  cl(judgefe)

		coefplot woL6 woL5 woL4, vertical xtitle("Years Before and After Manne Attendance") ytitle("Effect on Voting Against Labor/Environmental Agencies") order(-6 -5 -4 -3 -2 0 1 2 3 4 5 6) ciopts(lwidth(0.4))  rename(manne_L6 = -6 manne_L5 = -5 manne_L4 = -4 manne_L3= -3 manne_L2 = -2 manne_0=0 manne_F1 = 1 manne_F2 = 2 manne_F3 = 3 manne_F4 = 4 manne_F5 = 5 manne_F6 = 6) legend(order(2 "Without L6 & L1" 4 "Without L5 & L1" 6 "Without L4 & L1") cols(3) ring(0) position(11)) play("y_title_coefplot_no_legenda.grec") $yline_style
		graph export "$output/circuit_appendix/laborepa_main4_lags.pdf", replace


		* Economics Language - ellickson vec
		foreach sample in econ_case {
			foreach author in author {

				* drop L6
				eststo woL6: reghdfe y_ellickson_vec manne_L5 manne_L4 manne_L3 manne_L2 manne_0 manne_F1 manne_F2 manne_F3 manne_F4 manne_F5 manne_F6 if `manne_window' == 1 & `author'==1 & `sample'==1  [aw=WJT], nocons a($basefe)  cl(judgefe)

				* drop L5
				eststo woL5: reghdfe y_ellickson_vec manne_L6 manne_L4 manne_L3 manne_L2 manne_0 manne_F1 manne_F2 manne_F3 manne_F4 manne_F5 manne_F6 if `manne_window' == 1 & `author'==1 & `sample'==1  [aw=WJT], nocons a($basefe)  cl(judgefe)

				* drop L4
				eststo woL4: reghdfe y_ellickson_vec manne_L6 manne_L5 manne_L3 manne_L2 manne_0 manne_F1 manne_F2 manne_F3 manne_F4 manne_F5 manne_F6 if `manne_window' == 1 & `author'==1 & `sample'==1  [aw=WJT], nocons a($basefe)  cl(judgefe)

				coefplot woL6 woL5 woL4, vertical xtitle("Years Before and After Manne Attendance") ytitle("Effect on Embedding Similarity to Economics Lexicon") order(-6 -5 -4 -3 -2 0 1 2 3 4 5 6) ciopts(lwidth(0.4))  rename(manne_L6 = -6 manne_L5 = -5 manne_L4 = -4 manne_L3= -3 manne_L2 = -2 manne_0=0 manne_F1 = 1 manne_F2 = 2 manne_F3 = 3 manne_F4 = 4 manne_F5 = 5 manne_F6 = 6) legend(order(2 "Without L6 & L1" 4 "Without L5 & L1" 6 "Without L4 & L1") cols(3) ring(0) position(11)) play("y_title_coefplot_no_legenda.grec") $yline_style
				graph export "$output/circuit_appendix/ellickson_vec_main4_lags.pdf", replace
			}
		}

	}

}





