**************************************
*************** CIRCUIT **************
**************************************

clear
set more off
set graphics off

// For Replicators: If you want to run this file outside of the main 
// programme, proceed as follows:
// 1. Comment out the following code chunk
// 2. Uncomment the programme
// 3. Replace the file-path inside the programme

global output $path/output

foreach subfolder in paralleltrends {
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
// 	foreach subfolder in paralleltrends {
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

// load_circuit_drop_globals

qui do "$path/code/new_programs.do"

cap log using "$output/paralleltrends/output_paralleltrends.log", replace

***************
*** buttons ***
***************

* Figure 3-4
global paralleltrends1=1

* Globals and vars gen
global globals_and_vars=1
if ${globals_and_vars}==1 {

	* Globals graphs

	global coefplot_matrixes "(matrix(coefficients1),ci(ci51) msize(medium))"

	global coefplot_matrixes_merged3 "(matrix(coefficients1),ci(ci51) offset(-0.30) msize(medium) msymbol(Oh)) (matrix(coefficients2),ci(ci52) offset(-0.15) msize(medium) msymbol(Dh)) (matrix(coefficients3),ci(ci53) offset(0) msize(medium) msymbol(Th))"	
	global coefplot_matrixes_merged4 "(matrix(coefficients1),ci(ci51) offset(-0.45) msize(medium) msymbol(Oh)) (matrix(coefficients2),ci(ci52) offset(-0.30) msize(medium) msymbol(Dh)) (matrix(coefficients3),ci(ci53) offset(-0.15) msize(medium) msymbol(Th)) (matrix(coefficients4),ci(ci54) offset(0) msize(medium) msymbol(Sh))"	

	global coefplot_matrixes_convote4 "(matrix(coefficients1), ci(ci51) ciopts(color(maroon)) msize(medium) symbol(circle_hollow) color(maroon) offset(-0.65)) (matrix(coefficients2),ci(ci52) ciopts(color(maroon)) msize(medium) symbol(diamond_hollow) color(maroon) offset(-0.55)) (matrix(coefficients3),ci(ci53) ciopts(color(maroon)) msize(medium) symbol(square_hollow) color(maroon) offset(-0.45)) (matrix(coefficients4), ci(ci54) ciopts(color(maroon)) msize(medium) symbol(x) color(maroon) offset(-0.35)) (matrix(coefficients5),ci(ci55) ciopts(color(teal%80)) symbol(circle_hollow) msize(medium) color(teal%80) offset(-0.15)) (matrix(coefficients6),ci(ci56) ciopts(color(teal%80)) symbol(diamond_hollow) msize(medium) color(teal%80) offset(-0.05)) (matrix(coefficients7),ci(ci57) ciopts(color(teal%80)) symbol(square_hollow) msize(medium) color(teal%80) offset(0.05)) (matrix(coefficients8),ci(ci58) ciopts(color(teal%80)) symbol(x) msize(medium) color(teal%80) offset(0.15))"	

	global coefplot_matrixes_merged7 "(matrix(coefficients1),ci(ci51) offset(-0.30) msize(small) msymbol(Oh)) (matrix(coefficients2),ci(ci52) offset(-0.20) msize(small) msymbol(Dh)) (matrix(coefficients3),ci(ci53) offset(-0.10) msize(small) msymbol(Th)) (matrix(coefficients4),ci(ci54) offset(0) msize(small) msymbol(Sh)) (matrix(coefficients5),ci(ci55) offset(+0.10) msize(small) msymbol(Oh)) (matrix(coefficients6),ci(ci56) offset(+0.20) msize(small) msymbol(Dh)) (matrix(coefficients7),ci(ci57) offset(+0.30) msize(small) msymbol(Th))"


	global legendfour `"legend(order(2 "Judge FE’s + Circuit-Year FE’s" 4 "+ Elastic Net Controls × 5-Year " 6 "< 1987" 8 "+ Circuit-Judge FE's X Peers Share") ring(0) position(11) cols(2))"'

	
	* Globals FE
	global paperv4_enetc8 "i.year#c.(x_plocct x_pccoun x_b10s x_b20s x_b30s x_b40s x_b50s)"
	global new_enetc8 "i.year#c.(x_pgovt x_b10s x_b20s x_b40s x_b50s)"

	* global enetc8 "i.five_year#c.(x_pgovt x_b10s x_b20s x_b40s x_b50s)"
	
	** jun16 bios enet
	global enetc8 "i.five_year#c.(x_psatty x_pgov x_b10s x_b20s x_b40s x_b50s)"

	* Globals FE for iteration
	global basefe "circuityear judgefe" 
	global basefe_enetc8 "circuityear judgefe $enetc8"
	global basefe_exper2fe "circuityear judgefe one#c.exper one#c.exper2"
	global basefe_exper2fe_enetc8 "circuityear judgefe one#c.exper one#c.exper2 $enetc8"
	
	* new pretrend avg
	foreach var in y_labor_epa_lose y_convote_econ y_convote_nonecon y_cons_antitrust2 y_ellickson_vec econ_pp_17 {

		bys judgefe: egen y_pre_avg_`var' = mean(`var') if manne_L4 | manne_L3 | manne_L2
		bys judgefe: egen y_pre_avg2_`var' = mean(y_pre_avg_`var')
		gen y_pre_avg_miss_`var' = missing(y_pre_avg2_`var')
		replace y_pre_avg2_`var' = 0 if missing(y_pre_avg2_`var')
	}


	gen two_year = year - mod(year,2)
	gen three_year = year - mod(year,3)
	gen four_year = year - mod(year,4)
	gen five_year = year - mod(year,5)
	gen six_year = year - mod(year,6)
	gen seven_year = year - mod(year,7)

}




* Figure 3-4
global paralleltrends1=1
if ${paralleltrends1}==1 {
	
	foreach manne_window in mw6 {

		local manne_window mw6
	
		new_options_program, manne_window(`manne_window')

		** Labor/EPA
		reghdfe y_labor_epa_lose $lags if `manne_window' == 1 [aw=WJT], nocons a($basefe_hd) cl(judgefe)
		honestdid, numpre(4) coefplot mvec(0(0.01)0.1) delta(sd)
		graph export "$output/paralleltrends/spec1.pdf", replace

		reghdfe y_labor_epa_lose $lags if `manne_window' == 1 [aw=WJT], nocons a($basefe) cl(judgefe)
		new_coefficients_program, spec(1) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
		matrix var_cov = e(V)
		matrix coef = e(b)
// 		esttab matrix(var_cov) using "$output/paralleltrends/var-cov-main.csv", append plain
// 		esttab matrix(coef) using "$output/paralleltrends/coef-main.csv", append plain	


		reghdfe y_labor_epa_lose $lags if `manne_window' == 1 [aw=WJT], nocons a($basefe_enetc8_hd) cl(judgefe)
		honestdid, numpre(4) coefplot mvec(0(0.01)0.1) delta(sd)
		graph export "$output/paralleltrends/spec2.pdf", replace

		reghdfe y_labor_epa_lose $lags if `manne_window' == 1 [aw=WJT], nocons a($basefe_enetc8) cl(judgefe)
		new_coefficients_program, spec(2) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
		matrix var_cov = e(V)
		matrix coef = e(b)
// 		esttab matrix(var_cov) using "$output/paralleltrends/var-cov-main.csv", append plain
// 		esttab matrix(coef) using "$output/paralleltrends/coef-main.csv", append plain			


		reghdfe y_labor_epa_lose $lags if `manne_window' == 1 & year<1987 [aw=WJT], nocons a($basefe_hd) cl(judgefe)
		honestdid, numpre(4) coefplot mvec(0(0.01)0.1) delta(sd)
		graph export "$output/paralleltrends/spec3.pdf", replace

		reghdfe y_labor_epa_lose $lags if `manne_window' == 1 & year<1987 [aw=WJT], nocons a($basefe) cl(judgefe)
		new_coefficients_program, spec(3) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
		matrix var_cov = e(V)
		matrix coef = e(b)
// 		esttab matrix(var_cov) using "$output/paralleltrends/var-cov-main.csv", append plain
// 		esttab matrix(coef) using "$output/paralleltrends/coef-main.csv", append plain		


		reghdfe y_labor_epa_lose $lags if `manne_window' == 1 [aw=WJT], nocons a($basefe_hd circuitjudge##c.peer_manne_share) cl(judgefe)
		honestdid, numpre(4) coefplot mvec(0(0.01)0.1) delta(sd)
		graph export "$output/paralleltrends/spec4.pdf", replace

		reghdfe y_labor_epa_lose $lags if `manne_window' == 1 [aw=WJT], nocons a($basefe circuitjudge##c.peer_manne_share) cl(judgefe)
		new_coefficients_program, spec(4) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
		matrix var_cov = e(V)
		matrix coef = e(b)
// 		esttab matrix(var_cov) using "$output/paralleltrends/var-cov-main.csv", append plain
// 		esttab matrix(coef) using "$output/paralleltrends/coef-main.csv", append plain	



		coefplot $coefplot_matrixes_merged4, $general_options_merged xtitle("Years Before and After Manne Attendance") ytitle("Effect on Voting Against Labor/Environmental Agencies") $legendfour ciopts(lwidth(0.4))
// 		graph export "$output/paralleltrends/laborepa_main4.pdf", replace


		** Economics Language - ellickson vec
		foreach sample in econ_case {
			foreach author in author {

				local sample econ_case
				local author author
				local manne_window mw6

				reghdfe y_ellickson_vec $lags if `manne_window' == 1 & `author'==1 & `sample'==1 [aw=WJT], nocons a($basefe_hd) cl(judgefe)
				honestdid, numpre(4) coefplot mvec(0(0.01)0.1) delta(sd)
				graph export "$output/paralleltrends/spec5.pdf", replace

				reghdfe y_ellickson_vec $lags if `manne_window' == 1 & `author'==1 & `sample'==1 [aw=WJT], nocons a($basefe) cl(judgefe)
				new_coefficients_program, spec(1) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
				matrix var_cov = e(V)
				matrix coef = e(b)
// 				esttab matrix(var_cov) using "$output/paralleltrends/var-cov-main.csv", append plain
// 				esttab matrix(coef) using "$output/paralleltrends/coef-main.csv", append plain


				reghdfe y_ellickson_vec $lags if `manne_window' == 1 & `author'==1 & `sample'==1 [aw=WJT], nocons a($basefe_enetc8_hd) cl(judgefe)
				honestdid, numpre(4) coefplot mvec(0(0.01)0.1) delta(sd)
				graph export "$output/paralleltrends/spec6.pdf", replace

				reghdfe y_ellickson_vec $lags if `manne_window' == 1 & `author'==1 & `sample'==1 [aw=WJT], nocons a($basefe_enetc8) cl(judgefe)
				new_coefficients_program, spec(2) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
				matrix var_cov = e(V)
				matrix coef = e(b)
// 				esttab matrix(var_cov) using "$output/paralleltrends/var-cov-main.csv", append plain
// 				esttab matrix(coef) using "$output/paralleltrends/coef-main.csv", append plain


				reghdfe y_ellickson_vec $lags if `manne_window' == 1 & `author'==1 & `sample'==1 & year<1987 [aw=WJT], nocons a($basefe_hd) cl(judgefe)
				honestdid, numpre(4) coefplot mvec(0(0.01)0.1) delta(sd)
				graph export "$output/paralleltrends/spec7.pdf", replace

				reghdfe y_ellickson_vec $lags if `manne_window' == 1 & `author'==1 & `sample'==1 & year<1987 [aw=WJT], nocons a($basefe) cl(judgefe)
				new_coefficients_program, spec(3) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
				matrix var_cov = e(V)
				matrix coef = e(b)
// 				esttab matrix(var_cov) using "$output/paralleltrends/var-cov-main.csv", append plain
// 				esttab matrix(coef) using "$output/paralleltrends/coef-main.csv", append plain




				reghdfe y_ellickson_vec $lags if `manne_window' == 1 & `author'==1 & `sample'==1 [aw=WJT], nocons a($basefe_hd circuitjudge##c.peer_manne_share) cl(judgefe)
				honestdid, numpre(4) coefplot mvec(0(0.01)0.1) delta(sd)
				graph export "$output/paralleltrends/spec8.pdf", replace

				reghdfe y_ellickson_vec $lags if `manne_window' == 1 & `author'==1 & `sample'==1 [aw=WJT], nocons a($basefe circuitjudge##c.peer_manne_share) cl(judgefe)
				new_coefficients_program, spec(4) manne_window(`manne_window') lags_lincom_pre($lags_lincom_pre) lags_lincom_post($lags_lincom_post)
				matrix var_cov = e(V)
				matrix coef = e(b)
// 				esttab matrix(var_cov) using "$output/paralleltrends/var-cov-main.csv",  append plain
// 				esttab matrix(coef) using "$output/paralleltrends/coef-main.csv",  append plain

				coefplot $coefplot_matrixes_merged4, $general_options_merged xtitle("Years Before and After Manne Attendance") ytitle("Effect on Embedding Similarity to Economics Lexicon") $legendfour ciopts(lwidth(0.4))
// 				graph export "$output/paralleltrends/ellickson_vec_main4.pdf", replace

			}
		}



	}

}

global lags "manne_L5 manne_L4 manne_L3 manne_L2 manne_0 manne_F1 manne_F2 manne_F3 manne_F4 manne_F5 manne_F6"

reghdfe econ_pp_17 $lags if mw6 == 1 & author==1 & non_econ_case==1  [aw=WJT], nocons a($basefe_hd)  cl(judgefe)	
honestdid, numpre(4) coefplot mvec(0(0.01)0.1) delta(sd)
graph export "$output/paralleltrends/spec9.pdf", replace

reghdfe y_convote_econ $lags if mw6 == 1  [aw=WJT], nocons a($basefe_hd)  cl(judgefe)	
honestdid, numpre(4) coefplot mvec(0(0.01)0.1) delta(sd)
graph export "$output/paralleltrends/spec10.pdf", replace


reghdfe y_convote_nonecon $lags if mw6 == 1   [aw=WJT], nocons a($basefe_hd)  cl(judgefe)	
honestdid, numpre(4) coefplot mvec(0(0.01)0.1) delta(sd)
graph export "$output/paralleltrends/spec11.pdf", replace





****************************************************
***************        DISTRICT       **************
****************************************************

use $data/$district_data, clear


global basefe "districtyear judgefe" 
global basefe_hd "districtyear"
global lags "manne_pre4 manne_L3 manne_L2 manne_0 manne_F1 manne_F2 manne_F3 manne_post4"

* probs
egen tot_crime_type_temp=total(one) if departmentofjusticeprogramcatego!=""
egen tot_crime_type=max(tot_crime_type_temp)
foreach var in weapon drug immigration fraud {
egen prob_`var'_temp=total(one) if `var'==1
egen prob_`var'=max(prob_`var'_temp)
replace prob_`var'=prob_`var'/tot_crime_type
drop prob_`var'_temp
}
drop tot_crime_type_temp

gen sent_exp = exp(senttot0_log)-1
gen sent_ihs = asinh(sent_exp)

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


eststo clear 
eststo new: reghdfe any_sentence $lags if mw5 == 1 [aw=WJT], nocons a($basefe_hd)  cl(judgefe)
honestdid, numpre(3) coefplot mvec(0(0.01)0.1) delta(sd)
graph export "$output/paralleltrends/spec12.pdf", replace


eststo nr: reghdfe any_sentence manne_L5 manne_L4 manne_L3 manne_L2 manne_0 manne_F1 manne_F2 manne_F3 manne_F4 if mw5 == 1 [aw=WJT], nocons a($basefe_hd)  cl(judgefe)
honestdid, numpre(4) coefplot mvec(0(0.01)0.1) delta(sd)
graph export "$output/paralleltrends/spec13.pdf", replace

matrix var_cov = e(V)
matrix coef = e(b)
// esttab matrix(var_cov) using "$output/paralleltrends/district-var-cov-main.csv",  append plain
// esttab matrix(coef) using "$output/paralleltrends/district-coef-main.csv",  append plain


capture log close


