
cap program drop new_coefficients_program
program new_coefficients_program
	syntax, spec(numlist) manne_window(string) [lags_lincom_pre(string) lags_lincom_post(string)]
	if "`manne_window'"=="mw6" {
		matrix regmat`spec'=r(table)
		* reg coefficients
		matrix coefficients`spec'=regmat`spec'[1,1],regmat`spec'[1,2],regmat`spec'[1,3],regmat`spec'[1,4],0,regmat`spec'[1,5],regmat`spec'[1,6],regmat`spec'[1,7],regmat`spec'[1,8],regmat`spec'[1,9],regmat`spec'[1,10],regmat`spec'[1,11]
		matrix colnames coefficients`spec'=manne_L5 manne_L4 manne_L3 manne_L2 manne_L1 manne_0 manne_F1 manne_F2 manne_F3 manne_F4 manne_F5 manne_F6
		matrix rownames coefficients`spec'=b
		matlist regmat`spec'	
		* ci 			
		matrix ci5`spec'=regmat`spec'[5,1],regmat`spec'[5,2],regmat`spec'[5,3],regmat`spec'[5,4],0,regmat`spec'[5,5],regmat`spec'[5,6],regmat`spec'[5,7],regmat`spec'[5,8],regmat`spec'[5,9],regmat`spec'[5,10],regmat`spec'[5,11]\regmat`spec'[6,1],regmat`spec'[6,2],regmat`spec'[6,3],regmat`spec'[6,4],0,regmat`spec'[6,5],regmat`spec'[6,6],regmat`spec'[6,7],regmat`spec'[6,8],regmat`spec'[6,9],regmat`spec'[6,10],regmat`spec'[6,11]
		matrix dof=e(dof_table)
		global num_judgefe=dof[2,1]
		global sample_size=e(N)
		global xline "xline(4.85, lpattern(dash) lcolor(gray))"
		global xlabel "xlabel(0.85 "-5" 1.85 "-4" 2.85 "-3" 3.85 "-2" 4.85 "-1" 5.85 "0" 6.85 "1" 7.85 "2" 8.85 "3" 9.85 "4" 10.85 "5" 11.85 "6")"
		global general_options_merged "play(y_title_coefplot_no_legenda) graphregion(fcolor(white)) vertical yline(0, lpattern(dash) lcolor(gray)) $xline $xlabel xsize(8)"
		lincom $lags_lincom_pre
		lincom $lags_lincom_post
	}
	if "`manne_window'"=="mw5" {
		matrix regmat`spec'=r(table)
		matlist regmat`spec'
		* reg coefficients
		matrix coefficients`spec'=regmat`spec'[1,1],regmat`spec'[1,2],regmat`spec'[1,3],0,regmat`spec'[1,4],regmat`spec'[1,5],regmat`spec'[1,6],regmat`spec'[1,7],regmat`spec'[1,8]
		matrix colnames coefficients`spec'=manne_pre4 manne_L3 manne_L2 manne_L1 manne_0 manne_F1 manne_F2 manne_F3 manne_post4
		matrix rownames coefficients`spec'=b	
		matlist regmat`spec'
		* ci 			
		matrix ci5`spec'=regmat`spec'[5,1],regmat`spec'[5,2],regmat`spec'[5,3],0,regmat`spec'[5,4],regmat`spec'[5,5],regmat`spec'[5,6],regmat`spec'[5,7],regmat`spec'[5,8]\regmat`spec'[6,1],regmat`spec'[6,2],regmat`spec'[6,3],0,regmat`spec'[6,4],regmat`spec'[6,5],regmat`spec'[6,6],regmat`spec'[6,7],regmat`spec'[6,8]
		matrix dof=e(dof_table)
		global num_judgefe=dof[2,1]
		global sample_size=e(N)
		global xline "xline(3.85, lpattern(dash) lcolor(gray))"
		global xlabel "xlabel(0.85 "-4" 1.85 "-3" 2.85 "-2" 3.85 "-1" 4.85 "0" 5.85 "1" 6.85 "2" 7.85 "3" 8.85 "4")"
		global general_options_merged "play(y_title_coefplot_no_legenda) graphregion(fcolor(white)) vertical yline(0, lpattern(dash) lcolor(gray)) $xline $xlabel xsize(8)"
		lincom $lags_lincom_pre
		lincom $lags_lincom_post
	}
	if "`manne_window'"=="mw43" {

		matrix regmat`spec'=r(table)
		matlist regmat`spec'
		* reg coefficients
		matrix coefficients`spec'=regmat`spec'[1,1],regmat`spec'[1,2],0,regmat`spec'[1,3],regmat`spec'[1,4],regmat`spec'[1,5],regmat`spec'[1,6]
		matrix colnames coefficients`spec'=manne_L3 manne_L2 manne_L1 manne_0 manne_F1 manne_F2 manne_F3
		matrix rownames coefficients`spec'=b	
		matlist regmat`spec'
		* ci 			
		matrix ci5`spec'=regmat`spec'[5,1],regmat`spec'[5,2],0,regmat`spec'[5,3],regmat`spec'[5,4],regmat`spec'[5,5],regmat`spec'[5,6]\regmat`spec'[6,1],regmat`spec'[6,2],0,regmat`spec'[6,3],regmat`spec'[6,4],regmat`spec'[6,5],regmat`spec'[6,6]	
		matrix dof=e(dof_table)
		global num_judgefe=dof[2,1]
		global sample_size=e(N)
		global xline "xline(2.85, lpattern(dash) lcolor(gray))" 
		global xlabel "xlabel(0.85 "-3" 1.85 "-2" 2.85 "-1" 3.85 "0" 4.85 "1" 5.85 "2" 6.85 "3")"
		global general_options_merged "play(y_title_coefplot_no_legenda) graphregion(fcolor(white)) vertical yline(0, lpattern(dash) lcolor(gray)) $xline $xlabel xsize(8)"
		lincom $lags_lincom_pre
		lincom $lags_lincom_post
	}
	if "`manne_window'"=="manneWJT" | "`manne_window'"=="mw6combined" {
		matrix regmat`spec'=r(table)
		* reg coefficients
		matrix coefficients`spec'=regmat`spec'[1,1],regmat`spec'[1,2],regmat`spec'[1,3],regmat`spec'[1,4],0,regmat`spec'[1,5],regmat`spec'[1,6],regmat`spec'[1,7],regmat`spec'[1,8],regmat`spec'[1,9],regmat`spec'[1,10]
		matrix colnames coefficients`spec'=manne_pre5 manne_L4 manne_L3 manne_L2 manne_L1 manne_0 manne_F1 manne_F2 manne_F3 manne_F4 manne_post5
		matrix rownames coefficients`spec'=b
		matlist regmat`spec'
		matlist coefficients`spec'	
		* ci 			
		matrix ci5`spec'=regmat`spec'[5,1],regmat`spec'[5,2],regmat`spec'[5,3],regmat`spec'[5,4],0,regmat`spec'[5,5],regmat`spec'[5,6],regmat`spec'[5,7],regmat`spec'[5,8],regmat`spec'[5,9],regmat`spec'[5,10]\regmat`spec'[6,1],regmat`spec'[6,2],regmat`spec'[6,3],regmat`spec'[6,4],0,regmat`spec'[6,5],regmat`spec'[6,6],regmat`spec'[6,7],regmat`spec'[6,8],regmat`spec'[6,9],regmat`spec'[6,10]
		matrix dof=e(dof_table)
		global num_judgefe=dof[2,1]
		global sample_size=e(N)
		global xline "xline(4.85, lpattern(dash) lcolor(gray))"
		global xlabel "xlabel(0.85 "-5" 1.85 "-4" 2.85 "-3" 3.85 "-2" 4.85 "-1" 5.85 "0" 6.85 "1" 7.85 "2" 8.85 "3" 9.85 "4" 10.85 "5")"
		global general_options_merged "play(y_title_coefplot_no_legenda) graphregion(fcolor(white)) vertical yline(0, lpattern(dash) lcolor(gray)) $xline $xlabel xsize(8)"
		lincom $lags_lincom_pre
		lincom $lags_lincom_post
	}
	if "`manne_window'"=="mannecombined" {
		matrix regmat`spec'=r(table)
		* reg coefficients
		matrix coefficients`spec'=regmat`spec'[1,1],regmat`spec'[1,2],regmat`spec'[1,3],regmat`spec'[1,4],regmat`spec'[1,5],0,regmat`spec'[1,6],regmat`spec'[1,7],regmat`spec'[1,8],regmat`spec'[1,9],regmat`spec'[1,10],regmat`spec'[1,11],regmat`spec'[1,12]
		matrix colnames coefficients`spec'=manne_pre6 manne_L5 manne_L4 manne_L3 manne_L2 manne_L1 manne_0 manne_F1 manne_F2 manne_F3 manne_F4 manne_F5 manne_post6
		matrix rownames coefficients`spec'=b
		matlist regmat`spec'
		matlist coefficients`spec'	
		* ci 			
		matrix ci5`spec'=regmat`spec'[5,1],regmat`spec'[5,2],regmat`spec'[5,3],regmat`spec'[5,4],regmat`spec'[5,5],0,regmat`spec'[5,6],regmat`spec'[5,7],regmat`spec'[5,8],regmat`spec'[5,9],regmat`spec'[5,10],regmat`spec'[5,11],regmat`spec'[5,11]\regmat`spec'[6,1],regmat`spec'[6,2],regmat`spec'[6,3],regmat`spec'[6,4],regmat`spec'[6,5],0,regmat`spec'[6,6],regmat`spec'[6,7],regmat`spec'[6,8],regmat`spec'[6,9],regmat`spec'[6,10],regmat`spec'[6,11],regmat`spec'[6,12]
		matrix dof=e(dof_table)
		global num_judgefe=dof[2,1]
		global sample_size=e(N)
		global xline "xline(5.85, lpattern(dash) lcolor(gray))"
		global xlabel "xlabel(0.85 "-6" 1.85 "-5" 2.85 "-4" 3.85 "-3" 4.85 "-2" 5.85 "-1" 6.85 "0" 7.85 "1" 8.85 "2" 9.85 "3" 10.85 "4" 11.85 "5" 12.85 "6")"
		global general_options_merged "play(y_title_coefplot_no_legenda) graphregion(fcolor(white)) vertical yline(0, lpattern(dash) lcolor(gray)) $xline $xlabel xsize(8)"
		lincom $lags_lincom_pre
		lincom $lags_lincom_post
	}	
end

cap program drop new_options_program
program new_options_program
	syntax, manne_window(string)
	if "`manne_window'"=="mw6" {
		** four on left and seven on right
		global lags "manne_L5 manne_L4 manne_L3 manne_L2 manne_0 manne_F1 manne_F2 manne_F3 manne_F4 manne_F5 manne_F6"

		global lags_lincom_pre "manne_L5+manne_L4+manne_L3+manne_L2"
		global lags_lincom_post "manne_F1+manne_F2+manne_F3+manne_F4+manne_F5+manne_F6"
	}
	if "`manne_window'"=="mw5" {
		*** this is a spec with -4/-5 combined and 4/5 combined
		** three on left and five on right
		global lags "manne_pre4 manne_L3 manne_L2 manne_0 manne_F1 manne_F2 manne_F3 manne_post4"
		global lags_lincom_pre "manne_pre4+manne_L3+manne_L2"
		global lags_lincom_post "manne_F1+manne_F2+manne_F3+manne_post4"
	}
	if "`manne_window'"=="mw43" {
		global lags "manne_L3 manne_L2 manne_0 manne_F1 manne_F2 manne_F3"
		global lags_lincom_pre "manne_L3+manne_L2"
		global lags_lincom_post "manne_F1+manne_F2+manne_F3"
	}
	if "`manne_window'"=="manneWJT" {
		*** this is a spec with < -5 combined and > 5 combined with a restriction on WJT
		*** four on left and six on right
		global lags "manne_pre5 manne_L4 manne_L3 manne_L2 manne_0 manne_F1 manne_F2 manne_F3 manne_F4 manne_post5"
		global lags_lincom_pre "manne_pre5+manne_L4+manne_L3+manne_L2"
		global lags_lincom_post "manne_F1+manne_F2+manne_F3+manne_F4+manne_post5"
	}
	if "`manne_window'"=="mw6combined" {
		*** this is a spec with -5/-6 combined and 5/6 combined
		** four on left and six on right
		global lags "manne_pre5 manne_L4 manne_L3 manne_L2 manne_0 manne_F1 manne_F2 manne_F3 manne_F4 manne_post5"
		global lags_lincom_pre "manne_pre5+manne_L4+manne_L3+manne_L2"
		global lags_lincom_post "manne_F1+manne_F2+manne_F3+manne_F4+manne_post5"
	}
	if "`manne_window'"=="mannecombined" {
		*** this is a spec with < -6 combined and > 6 combined with a restriction on WJT
		** five on left and seven on right
		global lags "manne_pre6 manne_L5 manne_L4 manne_L3 manne_L2 manne_0 manne_F1 manne_F2 manne_F3 manne_F4 manne_F5 manne_post6"
		global lags_lincom_pre "manne_pre6+manne_L5+manne_L4+manne_L3+manne_L2"
		global lags_lincom_post "manne_F1+manne_F2+manne_F3+manne_F4+manne_F5+manne_post6"
	}
end

cap program drop esttab_circuit_appendix
program esttab_circuit_appendix
	syntax, outcome(varlist) table_number(numlist)

	label var manne_post "Post Manne"

	esttab `outcome'_mw6_* using "$output/circuit_tables/table_a`table_number'.tex", ///
	replace type noisily ///
	b(3) se(4) ///
	keep(manne_post) se obs label ///
	prehead(`"\begin{center}"' ///
			\resizebox{\textwidth}{!}{ ///
			\begin{tabular}{l*{11}{c}} ///
			\toprule ///
			) ///
	mlabels(none) ///
	numbers ///
	mgroups("A. Short-Run Effects on Attenders", pattern(1 0 0 0 0 0 0 0 0 0 0) ///
			span prefix(\multicolumn{@span}{c}{\uline{\textit{) suffix(}}})) ///
	posthead("\cmidrule(lr){2-12}") ///
	prefoot("\cmidrule(lr){1-12}") ///
	stats(N, labels("N") fmt(0)) ///
	postfoot("") ///
	nonotes starlevels(+ .1 * .05 ** .01) 

	esttab `outcome'_manne_* using "$output/circuit_tables/table_a`table_number'.tex", ///
	append type noisily ///
	b(3) se(4) ///
	keep(manne_post) se obs label ///
	prehead("") ///
	nonumbers mlabels(12 13 14 15 16 17 18 19 20 21 22, prefix("(") suffix(")")) ///
	mgroups("B. Long-Run Effects on Attenders", pattern(1 0 0 0 0 0 0 0 0 0 0) ///
			span prefix(\multicolumn{@span}{c}{\uline{\textit{) suffix(}}})) ///
	posthead("\cmidrule(lr){2-12}") ///
	prefoot("\cmidrule(lr){1-12}") ///
	stats(N basefe pre1987 partytimefe enettimefe lowpeer ///
		  circuitjudgepeer topicfe noweight winsorw ///
		  robust clustertw, ///
	      labels("N" "Circuit-Year/Judge FE" "Pre-1987" "Party-Time FE" "Enet-Time FE" "Low Peer Share" ///
	      	     "Circuit-Judge FE X Peer Share" "Case Topic FE" "No Weighting" "Winsorized Weights" ///
	      	     "Robust SE" "Two-Way Cluster SE's") fmt(0)) ///
	postfoot(`"\bottomrule"' ///
			\end{tabular} ///
			} ///
			\end{center} ///
			) ///
	nonotes starlevels(+ .1 * .05 ** .01)

end