*********************************************************************
*  descriptive_statistics.do
*
*  Generates the moments reported in
*    descriptive_report/descriptive_statistics_report.tex
*
*  For each .dta file shipped in ../data/ this script
*    1. opens the file,
*    2. prints `describe` so the variable list / labels are on record,
*    3. loops over the substantively meaningful variables and prints
*       one summary line per variable in a pipe-delimited format
*       (STAT|var|N|mean|sd|min|max) that is easy to grep out of the
*       log and paste into the LaTeX tables.
*
*  This file is self-contained: it does NOT depend on main.do.  Just
*  set `path' on the first non-comment line below and run.
*
*  Author: produced for the descriptive-statistics report,
*          Ash, Chen, Naidu (2025), QJE replication archive.
*********************************************************************

clear all
set more off
set linesize 250
capture log close

* ---------------------------------------------------------------------
* SET ME: absolute path to the Replication-Archive folder
* ---------------------------------------------------------------------
global path "path/to/acn-replication"

cd "${path}"
global data    "data"
global outdir  "logs"
cap mkdir "${outdir}"
log using "${outdir}/descriptive_statistics.log", replace text

*---------------------------------------------------------------------
* small helper: print one STAT line per variable
*---------------------------------------------------------------------
cap program drop sumline
program define sumline
    syntax varname
    qui sum `varlist', detail
    di "STAT|`varlist'|" %14.0f r(N) "|" %16.6g r(mean) ///
        "|" %16.6g r(sd) "|" %16.6g r(min) "|" %16.6g r(max)
end


*=====================================================================
*  1. ready_circuits.dta  -- circuit-court judge-case panel
*=====================================================================
di as text _newline(2) "==== ready_circuits ===="
use "${data}/ready_circuits.dta", clear
count
describe, fullnames

local v_circ ///
    year circuit term WJT econ_case non_econ_case author is_author ///
    convote manne has_manne manne_post manne_time attend_year ///
    mw5 mw6 manne_window5 manne_window6 ///
    y_orig y_labor_epa_lose y_ellickson_vec y_sim_law y_crim_affirm ///
    y_convote_econ y_convote_nonecon y_cons_antitrust y_cons_antitrust2 ///
    antitrust3 y_count_dc wc_statistics econ_pp_17 x_rep_pp_17 ///
    lec_cites lec_cited cons_dissent ///
    reagan_bush_sc_appt_cites reagan_bush_sc_appt_cited ///
    pct_cites_total pct_cites_outside peer_manne_share ///
    manne_votes_share ever_votes_share manne_judges_share ever_judges_share ///
    x_republican x_unity x_crossa everattend exper exper2 ///
    yearnorm case_load_year ///
    govt_labor govt_immig govt_environ govt_lose repub geniss1

foreach v of local v_circ {
    cap sumline `v'
    if _rc {
        di "STAT|`v'|NOT_FOUND"
    }
}


*=====================================================================
*  2. ready_districts.dta  -- federal-district criminal-defendant panel
*=====================================================================
di as text _newline(2) "==== ready_districts ===="
use "${data}/ready_districts.dta", clear
count
describe, fullnames

local v_dis ///
    fiscalyear any_sentence senttot0_log sent_length_mp ///
    manne manne_post manne_time attend_year ///
    mw5 mw6 manne_window5 manne_window6 ///
    WJT WJ exper exper2 elevated everattend ///
    immigration drug fraud weapon ///
    x_republican x_unity x_crossa x_democrat ///
    full case_load_year

foreach v of local v_dis {
    cap sumline `v'
    if _rc {
        di "STAT|`v'|NOT_FOUND"
    }
}


*=====================================================================
*  3. ready_lgraphs.dta  -- long-run time-series panel
*=====================================================================
di as text _newline(2) "==== ready_lgraphs ===="
use "${data}/ready_lgraphs.dta", clear
count
describe, fullnames

local v_lg ///
    year govt_tax repub dissenter econ_case is_author convote WJT ///
    yearnorm y_labor_epa_lose y_ellickson_vec ///
    manne_post has_manne has_manne2

foreach v of local v_lg {
    cap sumline `v'
    if _rc {
        di "STAT|`v'|NOT_FOUND"
    }
}


*=====================================================================
*  4. ready_elevated.dta  -- judge-level elevation panel
*=====================================================================
di as text _newline(2) "==== ready_elevated ===="
use "${data}/ready_elevated.dta", clear
count
describe, fullnames

local v_el ///
    ayear elevated_year earliest_year attend_year decade_start ///
    manne elevated x_republican ///
    x_b10s x_b20s x_b30s x_b40s x_b50s

foreach v of local v_el {
    cap sumline `v'
    if _rc {
        di "STAT|`v'|NOT_FOUND"
    }
}


*=====================================================================
*  5. ready_fedsoc.dta  -- judge-level Federalist Society panel
*=====================================================================
di as text _newline(2) "==== ready_fedsoc ===="
use "${data}/ready_fedsoc.dta", clear
count
describe, fullnames

local v_fs ///
    circuit attend_year year_start appointment_year decade_start ///
    manne fedsoc x_republican x_democrat x_unity x_crossa ///
    x_b10s x_b20s x_b30s x_b40s x_b50s

foreach v of local v_fs {
    cap sumline `v'
    if _rc {
        di "STAT|`v'|NOT_FOUND"
    }
}


*=====================================================================
*  6. _district_econtext.dta  -- district-opinion language scores
*=====================================================================
di as text _newline(2) "==== _district_econtext ===="
use "${data}/_district_econtext.dta", clear
count
describe, fullnames

local v_ec year sim_score_1 sim_score_2
foreach v of local v_ec {
    cap sumline `v'
    if _rc {
        di "STAT|`v'|NOT_FOUND"
    }
}

log close
di as text _newline(1) "Done. See ${outdir}/descriptive_statistics.log"
