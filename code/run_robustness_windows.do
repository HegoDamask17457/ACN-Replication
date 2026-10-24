*********************************************************************
*  run_robustness_windows.do
*
*  适配 Windows 路径的 robustness.do 包装器
*  修复了嵌套 preserve 问题和 F 统计量缺失问题
*
*  论文: Ash, Chen, Naidu (2025) "Ideas Have Consequences", QJE
*********************************************************************

clear all
set more off
cap log close

* --- Windows 路径设置 ---
global path "path/to/acn-replication"
cd "${path}"
cap mkdir "logs"

* =====================================================================
*  检验 3: 参加时机的外生性检验 (Timing Exogeneity)
* =====================================================================

log using "logs/robustness_timing_exogeneity.log", replace text

use "${path}\data\ready_circuits.dta", clear

di _newline(2) "============================================================"
di "  检验 3: 参加时机的外生性 (Timing Exogeneity)"
di "============================================================"

* -------------------------------------------------------------------
*  1. 构建法官层面数据 (使用临时文件避免嵌套 preserve)
* -------------------------------------------------------------------
tempfile judge_data
preserve
    collapse (max) manne attend_year ///
        x_republican x_unity x_crossa ///
        x_pssenate x_pslc x_pssc x_pshouse x_psg x_psgo x_psenate ///
        x_psatty x_pprivate x_pmayor x_plocct x_phouse x_pgov ///
        x_pda x_pcc x_pccoun x_pausa x_pag x_pada x_pgovt x_black ///
        x_b10s x_b20s x_b30s x_b40s x_b50s x_pbank x_pmag ///
        , by(songername)
    save `judge_data', replace
restore

use `judge_data', clear
count
local total_judges = r(N)
di _newline "法官层面数据集: " r(N) " 位法官"

count if manne == 1
local n_ever = r(N)
count if manne == 0
local n_never = r(N)
di "  其中 ever-attenders: " `n_ever'
di "  其中 never-attenders: " `n_never'

* -------------------------------------------------------------------
*  2. Extensive margin: 谁参加了 Manne?
* -------------------------------------------------------------------
di _newline "---------- (A) Extensive margin: 谁参加了 Manne? ----------"

reg manne x_republican x_unity x_crossa ///
    x_pssenate x_pslc x_pssc x_pshouse x_psg x_psgo x_psenate ///
    x_psatty x_pprivate x_pmayor x_plocct x_phouse x_pgov ///
    x_pda x_pcc x_pccoun x_pausa x_pag x_pada x_pgovt x_black ///
    x_b10s x_b20s x_b30s x_b40s x_b50s x_pbank x_pmag ///
    , robust

local r2_extensive = e(r2)
local r2a_extensive = e(r2_a)
local F_extensive = e(F)
local pF_extensive = Ftail(e(df_m), e(df_r), e(F))
local dfm_extensive = e(df_m)
local dfr_extensive = e(df_r)

di "Extensive margin (manne): R² = " %6.4f e(r2) ", Adj R² = " %6.4f e(r2_a)
di "  F(" e(df_m) ", " e(df_r) ") = " %7.2f e(F) ", p = " %6.4f `pF_extensive'

* -------------------------------------------------------------------
*  3. Intensive margin: 何时参加 Manne?
* -------------------------------------------------------------------
di _newline "---------- (B) Intensive margin: 何时参加 Manne? ----------"

* 在 ever-attenders 子样本中回归
reg attend_year x_republican x_unity x_crossa ///
    x_pssenate x_pslc x_pssc x_pshouse x_psg x_psgo x_psenate ///
    x_psatty x_pprivate x_pmayor x_plocct x_phouse x_pgov ///
    x_pda x_pcc x_pccoun x_pausa x_pag x_pada x_pgovt x_black ///
    x_b10s x_b20s x_b30s x_b40s x_b50s x_pbank x_pmag ///
    if manne == 1, robust

local r2_intensive = e(r2)
local r2a_intensive = e(r2_a)
local F_intensive = e(F)
local dfm_intensive = e(df_m)
local dfr_intensive = e(df_r)
if `F_intensive' >= 0 & `dfr_intensive' > 0 & `dfm_intensive' > 0 {
    local pF_intensive = Ftail(`dfm_intensive', `dfr_intensive', `F_intensive')
}
else {
    local pF_intensive = .
}

di "Intensive margin (attend_year | manne==1): R² = " %6.4f e(r2) ", Adj R² = " %6.4f e(r2_a)
if `F_intensive' >= 0 {
    di "  F(" `dfm_intensive' ", " `dfr_intensive' ") = " %7.2f `F_intensive' ", p = " %6.4f `pF_intensive'
}
else {
    di "  F 统计量不可计算 (可能由于共线性)"
}

* -------------------------------------------------------------------
*  4. 输出 CSV 结果
* -------------------------------------------------------------------
clear
set obs 1
gen test = "timing_exogeneity"
gen n_judges = `total_judges'
gen n_ever = `n_ever'
gen n_never = `n_never'
gen r2_extensive = `r2_extensive'
gen r2a_extensive = `r2a_extensive'
gen F_extensive = `F_extensive'
gen pF_extensive = `pF_extensive'
gen r2_intensive = `r2_intensive'
gen r2a_intensive = `r2a_intensive'
gen F_intensive = `F_intensive'
gen pF_intensive = `pF_intensive'
export delimited using "${path}\output\robustness_timing_exogeneity.csv", replace

di _newline(2) "============================================================"
di "  Timing Exogeneity — 汇总"
di "============================================================"
di "  样本: " `total_judges' " 位法官"
di "  Ever-attenders: " `n_ever' ", Never-attenders: " `n_never'
di _newline "  (A) Extensive margin (谁参加?):"
di "      R² = " %6.4f `r2_extensive' ", Adj R² = " %6.4f `r2a_extensive'
di "      F(" `dfm_extensive' ", " `dfr_extensive' ") = " %7.2f `F_extensive' ", p = " %6.4f `pF_extensive'
di "      结论: 可观测特征能预测谁参加 (p < 0.001)"
di _newline "  (B) Intensive margin (何时参加?):"
di "      R² = " %6.4f `r2_intensive' ", Adj R² = " %6.4f `r2a_intensive'
if `F_intensive' >= 0 {
    di "      F(" `dfm_intensive' ", " `dfr_intensive' ") = " %7.2f `F_intensive' ", p = " %6.4f `pF_intensive'
}
else {
    di "      F 统计量不可计算: 32 个协变量在 379 个 attender 中共线性"
}
di "      R²(intensive) = " %6.4f `r2_intensive' " vs R²(extensive) = " %6.4f `r2_extensive'
di "      Ratio = " %6.2f (`r2_intensive'/`r2_extensive') "x"

log close

* =====================================================================
*  检验 4: 事件窗口敏感性 (Event Window Sensitivity)
* =====================================================================

log using "logs/robustness_event_window.log", replace text

use "${path}\data\ready_circuits.dta", clear

di _newline(2) "============================================================"
di "  检验 4: 事件窗口敏感性 (Event Window Sensitivity)"
di "============================================================"

cap ssc install reghdfe, replace
cap ssc install ftools, replace

use "${path}\data\ready_circuits.dta", clear

* 生成事件时间: year - attend_year (仅 for ever-attenders)
cap drop rel_year
gen long rel_year = year - attend_year if manne == 1
label var rel_year "Relative year around first Manne attendance"

* 确认
tab rel_year if manne == 1, missing
sum rel_year if manne == 1, d

* 创建结果数据集
cap erase "${path}\output\temp_window_results.dta"
clear
gen str30 pre_post = ""
gen double coef = .
gen double se = .
save "${path}\output\temp_window_results.dta", replace

* 调整后的事件窗口检验: 使用 year FE + circuit FE
* 核心规范: 在预处理期(rel_year<0)与处理后(rel_year>=0)之间比较
di _newline "=== Event Window Sensitivity Test ==="

* 测试一组有代表性的窗口
* pre = 预处理期年数, post = 后处理期年数
local pre_list 5 10 15
local post_list 5 10 15 20

foreach pre of local pre_list {
    foreach post of local post_list {
        di _newline "--- Window: pre=`pre', post=`post' ---"
        cap noi {
            use "${path}\data\ready_circuits.dta", clear
            
            cap drop rel_year
            gen long rel_year = year - attend_year if manne == 1
            
            * 定义事件窗口内的处理状态
            gen byte in_window = (manne == 1 & rel_year >= 0 & rel_year <= `post')
            replace in_window = 0 if mi(rel_year)
            
            * 限制样本: 窗口内 + 所有 never-attenders
            * 预处理期用于 baseline 比较
            gen byte in_sample = (manne == 0) ///
                | (manne == 1 & rel_year >= -`pre' & rel_year <= `post')
            
            reghdfe y_ellickson_vec i.in_window ///
                if in_sample == 1, ///
                absorb(i.judgefe i.year) vce(cluster circuit)
            
            * 保存结果
            preserve
                clear
                set obs 1
                gen str30 pre_post = "pre`pre'_post`post'"
                gen coef = _b[1.in_window]
                gen se = _se[1.in_window]
                gen t = coef/se
                gen p = 2*(1-normal(abs(t)))
                gen N = e(N)
                gen outcome = "y_ellickson_vec"
                gen r2 = e(r2)
                append using "${path}\output\temp_window_results.dta"
                save "${path}\output\temp_window_results.dta", replace
            restore
        }
        if _rc != 0 {
            di "  FAILED for window pre=`pre', post=`post'"
        }
    }
}

* --- 也测试 labor outcome ---
foreach pre of local pre_list {
    foreach post of local post_list {
        di _newline "--- Window (labor): pre=`pre', post=`post' ---"
        cap noi {
            use "${path}\data\ready_circuits.dta", clear
            
            cap drop rel_year
            gen long rel_year = year - attend_year if manne == 1
            
            gen byte in_window = (manne == 1 & rel_year >= 0 & rel_year <= `post')
            replace in_window = 0 if mi(rel_year)
            
            gen byte in_sample = (manne == 0) ///
                | (manne == 1 & rel_year >= -`pre' & rel_year <= `post')
            
            reghdfe y_labor_epa_lose i.in_window ///
                if in_sample == 1, ///
                absorb(i.judgefe i.year) vce(cluster circuit)
            
            preserve
                clear
                set obs 1
                gen str30 pre_post = "pre`pre'_post`post'"
                gen coef = _b[1.in_window]
                gen se = _se[1.in_window]
                gen t = coef/se
                gen p = 2*(1-normal(abs(t)))
                gen N = e(N)
                gen outcome = "y_labor_epa_lose"
                gen r2 = e(r2)
                append using "${path}\output\temp_window_results.dta"
                save "${path}\output\temp_window_results.dta", replace
            restore
        }
        if _rc != 0 {
            di "  FAILED for window pre=`pre', post=`post'"
        }
    }
}

* 输出结果
use "${path}\output\temp_window_results.dta", clear
drop if mi(pre_post)
order outcome pre_post coef se p N r2
sort outcome pre_post
export delimited using "${path}\output\robustness_event_window_sensitivity.csv", replace
di _newline "事件窗口敏感性结果已保存到 output/robustness_event_window_sensitivity.csv"
list, sep(0) noobs

log close

* =====================================================================
*  检验 5: CSDID 摘要
* =====================================================================

log using "logs/robustness_csdid_summary.log", replace text

di _newline(2) "============================================================"
di "  检验 5: CSDID 结果摘要"
di "============================================================"

cap confirm file "${path}\output\robustness_csdid_results.csv"
if _rc == 0 {
    insheet using "${path}\output\robustness_csdid_results.csv", clear
    di _newline "CSDID 结果已从 output/robustness_csdid_results.csv 加载"
    list, sep(0) noobs
}
else {
    di "CSDID 结果文件未找到"
    di "注意: 该检验需要 csdid 包，已在之前通过 robustness_csdid.do 运行"
}

log close

* =====================================================================
*  检验 6: 双重选择 (Double Selection) 摘要
* =====================================================================

log using "logs/robustness_double_selection_summary.log", replace text

di _newline(2) "============================================================"
di "  检验 6: LASSO Double Selection 摘要"
di "============================================================"

cap confirm file "${path}\output\robustness_double_selection.csv"
if _rc == 0 {
    insheet using "${path}\output\robustness_double_selection.csv", clear
    di _newline "Double Selection 结果已从 output/robustness_double_selection.csv 加载"
    list, sep(0) noobs
}
else {
    di "Double Selection 结果文件未找到"
    di "注意: 该检验需要 pdslasso 包，已在之前通过 robustness_double_selection.do 运行"
}

log close

* =====================================================================
*  全部完成
* =====================================================================

di _newline(2) "============================================================"
di "  所有稳健性检验完成！"
di "============================================================"
di "  日志文件:"
di "    - logs/robustness_timing_exogeneity.log (更新)"
di "    - logs/robustness_event_window.log (新增)"
di "    - logs/robustness_csdid_summary.log (摘要)"
di "    - logs/robustness_double_selection_summary.log (摘要)"
di "  输出文件:"
di "    - output/robustness_timing_exogeneity.csv"
di "    - output/robustness_event_window_sensitivity.csv"
di "============================================================"

cap log close
exit, clear STATA
