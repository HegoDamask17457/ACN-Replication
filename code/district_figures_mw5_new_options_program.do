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
// 	adopath + "${path}/schemes_grec"
// 	set scheme aspen, perm
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
//
// end 
//
// load_district_drop_globals

include code/new_programs.do

cap log using "$output/output_district_figures.log", replace

***************
*** buttons ***
***************

* Figure 5
global district_fig5=1

// * Figure A.33
global district_figa33=1

** Figure A.36
global district_rc_charge=1

** Figure A.37
**** Cluster se judge-districtyear
global district_rc_cljudgedistrictyear=1

* Globals and vars gen
global globals_and_vars=1
if ${globals_and_vars}==1 { 


	global coefplot_matrixes "(matrix(coefficients1),ci(ci51) offset(-0.15))"
	global coefplot_matrixes_merged2 "(matrix(coefficients1),ci(ci51) offset(-0.15) msize(medium)) (matrix(coefficients2),ci(ci52) msize(medium))"	

	* Globals FE for iteration

	* global enet_covars "x_psatty x_pprivate x_pgov x_b10s x_b20s x_b40s x_b50s"
	* global enet "i.five_year#c.(x_psatty x_pprivate x_pgov x_b10s x_b20s x_b40s x_b50s)"

	** jun16 bios enet
	global enet_covars "x_psatty x_b10s x_b20s x_b40s x_b50s"
	global enet "i.five_year#c.(x_psatty x_b10s x_b20s x_b40s x_b50s)" 

	global basefe "districtyear judgefe" 
	global basefe_enet "districtyear judgefe $enet"
	global basefe_exper2fe "districtyear judgefe one#c.exper one#c.exper2"
	global basefe_exper2fe_enet "districtyear judgefe one#c.exper one#c.exper2 $enet"

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

	gen manne_pre4 = manne_time <= -4
	gen manne_post4 = manne_time >= 4
	gen five_year = fiscalyear - mod(fiscalyear,5)


	cap drop manne_pre5
	gen manne_pre5 = manne_time <= -5
	drop manne_post5
	gen manne_post5 = manne_time >= 5
	gen manneWJT = manne == 1 & WJT < .07

}


* Figure 5
// global district_fig5=1
if ${district_fig5}==1 {
	
	foreach manne_window in manneWJT {

		new_options_program, manne_window(`manne_window')	

		
		* Two-in-one graphs

		** Labor/EPA
		eststo clear
		reghdfe any_sentence $lags if `manne_window' == 1 [aw=WJT], nocons a($basefe)  cl(judgefe)
		matlist r(table)	
		new_coefficients_program, spec(1) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
		tab attend_year if e(sample) == 1
		tab manne_post if e(sample) == 1	
		reghdfe any_sentence $lags if `manne_window' == 1 [aw=WJT], nocons a($basefe_enet)  cl(judgefe)
		new_coefficients_program, spec(2) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)		
		coefplot $coefplot_matrixes_merged2, $general_options_merged xtitle("Years Before and After Manne Attendance") ytitle("Effect on Any Prison Given") legend(order(2 "Judge FE's + District-Year FE's" 4 "+ Elastic Net Controls × 5-Year ") size(medsmall) ring(0) position(4)) ciopts(lwidth(0.4)) 
		graph export  "$output/district_all/district_anyprison_merged_`manne_window'_noexp.pdf", replace

	}

}




* Figure A.33
// global district_figa33=1
if ${district_figa33}==1 {


	foreach manne_window in manneWJT {

		new_options_program, manne_window(`manne_window')

		eststo clear		

		** Percentiles dummies of sentence
		ppmlhdfe sent_length_mp $lags if `manne_window' == 1, nocons a($basefe)  cl(judgefe)	
		new_coefficients_program, spec(1) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
		coefplot  $coefplot_matrixes, $general_options_merged  xtitle("Years Before and After Manne Attendance") ytitle("Effect on Prison Sentence Length") legend(order(2 "Judge FE's + District-Year FE's") size(medsmall) ring(0) position(4)) ciopts(lwidth(0.4)) keep(manne*) 
		graph export  "$output/district_all/district_sent_length_mp_merged_`manne_window'_poisson.pdf", replace	

	}

}



** Figure A.36

// global district_rc_charge=1
if ${district_rc_charge}==1 {


	foreach manne_window in manneWJT {

		new_options_program, manne_window(`manne_window')

		eststo clear

		** Any prison
		reghdfe any_sentence $lags if `manne_window' == 1 [aw=WJT], nocons a($basefe departmentofjusticeprogramcatego) cl(judgefe)
		matlist r(table)
		new_coefficients_program, spec(1) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
		tab attend_year if e(sample) == 1
		tab manne_post if e(sample) == 1

		reghdfe any_sentence $lags if `manne_window' == 1 [aw=WJT], nocons a($basefe_enet departmentofjusticeprogramcatego) cl(judgefe)
		new_coefficients_program, spec(2) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)

		coefplot $coefplot_matrixes_merged2, ///
			$general_options_merged ///
			xtitle("Years Before and After Manne Attendance") ///
			ytitle("Effect on Any Prison Given") ///
			legend(order(2 "Judge FE's + District-Year FE's" 4 "+ Elastic Net Controls × 5-Year") ///
			size(medsmall) ring(0) position(4)) ///
			ciopts(lwidth(0.4))

		graph export "$output/district_all/district_anysentence_merged_`manne_window'_iamr.pdf", replace
	}
		
}


** Figure A.37
**** Cluster se judge-districtyear
if ${district_rc_cljudgedistrictyear}==1 {
	
	foreach manne_window in manneWJT {

		new_options_program, manne_window(`manne_window')

		eststo clear

		** Any sentence
		reghdfe any_sentence $lags if `manne_window' == 1 [aw=WJT], nocons a($basefe) cl(judgefe districtyear)
		matlist r(table)
		new_coefficients_program, spec(1) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
		tab attend_year if e(sample) == 1
		tab manne_post if e(sample) == 1

		reghdfe any_sentence $lags if `manne_window' == 1 [aw=WJT], nocons a($basefe_enet) cl(judgefe districtyear)
		matlist r(table)
		new_coefficients_program, spec(2) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)

		coefplot $coefplot_matrixes_merged2, ///
			$general_options_merged ///
			xtitle("Years Before and After Manne Attendance") ///
			ytitle("Effect on Any Prison Given") ///
			legend(order(2 "Judge FE's + District-Year FE's" 4 "+ Elastic Net Controls × 5-Year") ///
			size(medsmall) ring(0) position(4)) ///
			ciopts(lwidth(0.4)) 

		graph export "$output/district_all/district_anyprison_merged_`manne_window'_cldistrictyear.pdf", replace
	}

}
****			



capture log close

