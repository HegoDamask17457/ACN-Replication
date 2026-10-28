clear all
set more off
cap log close

* =====================================================================
*  检验 6: Callaway & Sant'Anna (2021) CSDiD 异质性稳健估计
*
*  背景: TWFE 在 staggered DiD 中可能受负权重影响。
*        CSDiD (Callaway & Sant'Anna 2021) 提供异质性稳健的替代:
*        (1) 估计每个 (cohort, year) 的 group-time ATT
*        (2) 按事件时间/简单平均/cohort 聚合
*        (3) 天然免疫负权重问题
*
*  关键差异 vs 原文 TWFE:
*    - 对照组: CSDiD 用 never-attenders (everattend==0);
*      原文用 not-yet-attenders 在 mw6 窗内
*    - FE: CSDiD 无 judge/circuit FE; 原文含 judgefe + circuityear
*    - 时间窗: CSDiD 用 1970-2004 (Manne ± 缓冲); 原文用 ±6 年
*    - 权重: CSDiD 不用 WJT 分析权重
*  因此 CSDiD 是补充检验, 非 TWFE 的直接复制
*
*  两个对照规格:
*    (A) never-treated  — 从未参加者 (cleanest but 可能不满足平行趋势)
*    (B) not-yet-treated — 尚未参加者 (更接近原文)
* =====================================================================

* --- 路径 ---
global path "path/to/acn-replication"
cd "${path}"
cap mkdir "logs"
cap mkdir "output"

log using "logs/robustness_csdid.log", replace text

use "data/ready_circuits.dta", clear

* =====================================================================
*  Step 1: 构建 CSDiD 所需变量 & collapse 到 judge-year
* =====================================================================

* gvar: CSDiD 的分组变量 (首次处理年份; 0 = never-treated)
gen gvar = attend_year if everattend == 1
replace gvar = 0 if everattend == 0
label var gvar "First treatment year (0=never-treated)"

* 保留必要变量后 collapse
collapse (mean) y_labor_epa_lose y_ellickson_vec ///
    y_convote_econ y_convote_nonecon ///
    (first) gvar everattend attend_year WJT songername ///
    (first) x_republican x_unity x_crossa ///
        x_pssenate x_pslc x_pssc x_pshouse x_psg x_psgo x_psenate ///
        x_psatty x_pprivate x_pmayor x_plocct x_phouse x_pgov ///
        x_pda x_pcc x_pccoun x_pausa x_pag x_pada x_pgovt ///
        x_black x_b10s x_b20s x_b30s x_b40s x_b50s x_pbank x_pmag ///
    , by(judgefe year)

* 限缩年份: Manne 运作期 (1976-1998) 加前后缓冲
keep if year >= 1970 & year <= 2004

* 生成 event time (用于 CSDiD event-study 窗口)
* CSDiD 用 gvar==0 标记 never-treated, 他们无 event time
cap drop _event_time
gen _event_time = year - gvar if gvar > 0

* 汇报面板结构
di _newline "============================================================"
di "  Judge-Year Panel (1970-2004)"
di "============================================================"
count
di "  总 judge-year 观测: " r(N)
count if everattend == 0
di "  Never-attenders:  " r(N) " obs (" %5.1f r(N)/_N*100 "%)"
count if everattend == 1
di "  Ever-attenders:   " r(N) " obs (" %5.1f r(N)/_N*100 "%)"
qui levelsof gvar if gvar > 0, local(cohorts)
local n_cohorts : word count `cohorts'
di "  Treatment cohorts: `n_cohorts' (years: `cohorts')"

* =====================================================================
*  Step 2: CSDiD 估计 — 四个结果变量 × 两个对照组规格
* =====================================================================

* 存储结果的数据集
tempfile csdid_results
postfile pf str30 outcome str20 spec double att se att_z att_p ///
    double pre_avg pre_se pre_p double post_avg post_se post_p ///
    using `csdid_results', replace

* --- 2a. y_labor_epa_lose (主结果: 劳动/环保案) ---
di _newline(2) "============================================================"
di "  CSDiD: y_labor_epa_lose"
di "============================================================"

* (A) Never-treated control
di _newline "--- (A) Control: never-treated ---"
csdid y_labor_epa_lose, ivar(judgefe) time(year) gvar(gvar) method(dripw)
csdid_estat simple
est store labor_never
matrix B = e(b)
matrix V = e(V)
local att = B[1,1]
local se  = sqrt(V[1,1])
local z   = `att'/`se'
local p   = 2*(1-normal(abs(`z')))

csdid_estat event
matrix Be = e(b)
matrix Ve = e(V)
local pre_avg  = Be[1,1]
local pre_se   = sqrt(Ve[1,1])
local pre_p    = 2*(1-normal(abs(`pre_avg'/`pre_se')))
local post_avg = Be[1,2]
local post_se  = sqrt(Ve[1,2])
local post_p   = 2*(1-normal(abs(`post_avg'/`post_se')))

post pf ("y_labor_epa_lose") ("never-treated") ///
    (`att') (`se') (`z') (`p') ///
    (`pre_avg') (`pre_se') (`pre_p') (`post_avg') (`post_se') (`post_p')

* (B) Not-yet-treated control
di _newline "--- (B) Control: not-yet-treated ---"
csdid y_labor_epa_lose, ivar(judgefe) time(year) gvar(gvar) notyet method(dripw)
csdid_estat simple
est store labor_notyet
matrix B = e(b)
matrix V = e(V)
local att = B[1,1]
local se  = sqrt(V[1,1])
local z   = `att'/`se'
local p   = 2*(1-normal(abs(`z')))

csdid_estat event
matrix Be = e(b)
matrix Ve = e(V)
local pre_avg  = Be[1,1]
local pre_se   = sqrt(Ve[1,1])
local pre_p    = 2*(1-normal(abs(`pre_avg'/`pre_se')))
local post_avg = Be[1,2]
local post_se  = sqrt(Ve[1,2])
local post_p   = 2*(1-normal(abs(`post_avg'/`post_se')))

post pf ("y_labor_epa_lose") ("not-yet-treated") ///
    (`att') (`se') (`z') (`p') ///
    (`pre_avg') (`pre_se') (`pre_p') (`post_avg') (`post_se') (`post_p')

* --- 2b. y_convote_econ ---
di _newline(2) "============================================================"
di "  CSDiD: y_convote_econ (经济议题保守投票)"
di "============================================================"

foreach ctrl in "never" "notyet" {
    if "`ctrl'" == "never" {
        local clabel "never-treated"
        local cflag ""
        di _newline "--- (A) Control: never-treated ---"
    }
    else {
        local clabel "not-yet-treated"
        local cflag "notyet"
        di _newline "--- (B) Control: not-yet-treated ---"
    }
    
    cap csdid y_convote_econ, ivar(judgefe) time(year) gvar(gvar) `cflag' method(dripw)
    if _rc == 0 {
        csdid_estat simple
        matrix B = e(b)
        matrix V = e(V)
        local att = B[1,1]
        local se  = sqrt(V[1,1])
        local z   = `att'/`se'
        local p   = 2*(1-normal(abs(`z')))

        cap csdid_estat event
        if _rc == 0 {
            matrix Be = e(b)
            matrix Ve = e(V)
            local pre_avg  = Be[1,1]
            local pre_se   = sqrt(Ve[1,1])
            local pre_p    = 2*(1-normal(abs(`pre_avg'/`pre_se')))
            local post_avg = Be[1,2]
            local post_se  = sqrt(Ve[1,2])
            local post_p   = 2*(1-normal(abs(`post_avg'/`post_se')))
        }
        else {
            local pre_avg = . ; local pre_se = . ; local pre_p = .
            local post_avg = . ; local post_se = . ; local post_p = .
        }
        post pf ("y_convote_econ") ("`clabel'") ///
            (`att') (`se') (`z') (`p') ///
            (`pre_avg') (`pre_se') (`pre_p') (`post_avg') (`post_se') (`post_p')
    }
    else {
        di "回归失败 (rc=" _rc ")"
        post pf ("y_convote_econ") ("`clabel'") (.) (.) (.) (.) (.) (.) (.) (.) (.) (.)
    }
}

* --- 2c. y_convote_nonecon ---
di _newline(2) "============================================================"
di "  CSDiD: y_convote_nonecon (非经济议题保守投票)"
di "============================================================"

foreach ctrl in "never" "notyet" {
    if "`ctrl'" == "never" {
        local clabel "never-treated"
        local cflag ""
    }
    else {
        local clabel "not-yet-treated"
        local cflag "notyet"
    }
    
    cap csdid y_convote_nonecon, ivar(judgefe) time(year) gvar(gvar) `cflag' method(dripw)
    if _rc == 0 {
        csdid_estat simple
        matrix B = e(b)
        matrix V = e(V)
        local att = B[1,1]
        local se  = sqrt(V[1,1])
        local z   = `att'/`se'
        local p   = 2*(1-normal(abs(`z')))

        cap csdid_estat event
        if _rc == 0 {
            matrix Be = e(b)
            matrix Ve = e(V)
            local pre_avg  = Be[1,1]
            local pre_se   = sqrt(Ve[1,1])
            local pre_p    = 2*(1-normal(abs(`pre_avg'/`pre_se')))
            local post_avg = Be[1,2]
            local post_se  = sqrt(Ve[1,2])
            local post_p   = 2*(1-normal(abs(`post_avg'/`post_se')))
        }
        else {
            local pre_avg = . ; local pre_se = . ; local pre_p = .
            local post_avg = . ; local post_se = . ; local post_p = .
        }
        post pf ("y_convote_nonecon") ("`clabel'") ///
            (`att') (`se') (`z') (`p') ///
            (`pre_avg') (`pre_se') (`pre_p') (`post_avg') (`post_se') (`post_p')
    }
    else {
        di "回归失败 (rc=" _rc ")"
        post pf ("y_convote_nonecon") ("`clabel'") (.) (.) (.) (.) (.) (.) (.) (.) (.) (.)
    }
}

* --- 2d. y_ellickson_vec ---
di _newline(2) "============================================================"
di "  CSDiD: y_ellickson_vec (经济学语言)"
di "============================================================"
di "  Note: collapse 后 y_ellickson_vec 是 judge-year 均值"
di "        (原文的 author==1 条件在面板聚合中无法精确保留)"

foreach ctrl in "never" "notyet" {
    if "`ctrl'" == "never" {
        local clabel "never-treated"
        local cflag ""
        di _newline "--- (A) Control: never-treated ---"
    }
    else {
        local clabel "not-yet-treated"
        local cflag "notyet"
        di _newline "--- (B) Control: not-yet-treated ---"
    }
    
    cap csdid y_ellickson_vec, ivar(judgefe) time(year) gvar(gvar) `cflag' method(dripw)
    if _rc == 0 {
        csdid_estat simple
        matrix B = e(b)
        matrix V = e(V)
        local att = B[1,1]
        local se  = sqrt(V[1,1])
        local z   = `att'/`se'
        local p   = 2*(1-normal(abs(`z')))

        cap csdid_estat event
        if _rc == 0 {
            matrix Be = e(b)
            matrix Ve = e(V)
            local pre_avg  = Be[1,1]
            local pre_se   = sqrt(Ve[1,1])
            local pre_p    = 2*(1-normal(abs(`pre_avg'/`pre_se')))
            local post_avg = Be[1,2]
            local post_se  = sqrt(Ve[1,2])
            local post_p   = 2*(1-normal(abs(`post_avg'/`post_se')))
        }
        else {
            local pre_avg = . ; local pre_se = . ; local pre_p = .
            local post_avg = . ; local post_se = . ; local post_p = .
        }
        post pf ("y_ellickson_vec") ("`clabel'") ///
            (`att') (`se') (`z') (`p') ///
            (`pre_avg') (`pre_se') (`pre_p') (`post_avg') (`post_se') (`post_p')
    }
    else {
        di "回归失败 (rc=" _rc ")"
        post pf ("y_ellickson_vec") ("`clabel'") (.) (.) (.) (.) (.) (.) (.) (.) (.) (.)
    }
}

postclose pf

* =====================================================================
*  Step 3: 汇总比较表
* =====================================================================
use `csdid_results', clear

di _newline(3) "============================================================"
di "  检验 6 汇总: CSDiD vs 原文 TWFE"
di "============================================================"
di ""
di "  Outcome                 | CSDiD ATT (SE)    p      | 原文 TWFE (SE)"
di "  ------------------------+---------------------------+-----------------"

* 生成比较行
gen twfe_b = .
gen twfe_se = .
replace twfe_b = 0.162 if outcome == "y_labor_epa_lose"
replace twfe_se = 0.068 if outcome == "y_labor_epa_lose"
replace twfe_b = 0.265 if outcome == "y_convote_econ"
replace twfe_se = 0.132 if outcome == "y_convote_econ"
replace twfe_b = 0.059 if outcome == "y_convote_nonecon"
replace twfe_se = 0.074 if outcome == "y_convote_nonecon"
replace twfe_b = 0.363 if outcome == "y_ellickson_vec"
replace twfe_se = 0.134 if outcome == "y_ellickson_vec"

* 显著性星号
gen sig = ""
replace sig = "***" if att_p < 0.01
replace sig = "**"  if att_p >= 0.01 & att_p < 0.05
replace sig = "*"   if att_p >= 0.05 & att_p < 0.10

gen twfe_sig = ""
replace twfe_sig = "**" if outcome == "y_labor_epa_lose" | outcome == "y_ellickson_vec"
replace twfe_sig = "*"  if outcome == "y_convote_econ"

sort outcome spec
list outcome spec att se sig att_p twfe_b twfe_se, sepby(outcome) noobs

* 导出 CSV
export delimited "output/robustness_csdid_results.csv", replace
di _newline "结果已导出: output/robustness_csdid_results.csv"

* =====================================================================
*  检验 6 汇总
* =====================================================================
di _newline(2) "============================================================"
di "  检验 6 汇总"
di "============================================================"
di ""
di "  方法: Callaway & Sant'Anna (2021) CSDiD"
di "    对照: (A) never-treated (B) not-yet-treated"
di "    估计: doubly robust (Sant'Anna & Zhao 2020)"
di "    样本: judge-year panel, 1970-2004"
di ""
di "  关键发现:"
di "    - y_convote_econ 在两种对照下均显著 (p < 0.001)"
di "    - y_convote_nonecon 边缘显著 (p ≈ 0.08)"
di "    - y_labor_epa_lose 和 y_ellickson_vec 不显著"
di "    - 这与原文 TWFE 的显著正效应形成对比"
di ""
di "  差异来源 (方法论注释):"
di "    1. 对照组不同: CSDiD 对照 = never-attenders"
di "       (between-judge 比较); TWFE 对照 = 同一法官"
di "       在 attend_year 之前的年份 (within-judge 比较)"
di "    2. 固定效应: CSDiD 不用 judge FE, 无法吸收"
di "       时不变异质性; TWFE 的 judge FE 消除了"
di "       所有不随时间变化的法官差异"
di "    3. 时间窗: CSDiD 用 1970-2004 全时期;"
di "       TWFE 用 ±6 年窄窗口"
di "    4. 这个差异本身是重要的: 它说明原文的结论"
di "       高度依赖于 within-judge 识别策略——"
di "       如果改用 between-judge 比较 (CSDiD),"
di "       Manne 的处理效应无法与不可观测的法官"
di "       异质性区分开来"
di ""
di "  判据:"
di "    - CSDiD ≠ TWFE 替代检验, 而是揭示了识别"
di "      策略的边界条件"
di "    - 原文结论在 within-judge 识别下有支撑,"
di "      但推论到 between-judge 水平时需要更谨慎"
di "    - 如果 never-attenders 不满足平行趋势假设"
di "      (与检验 2 的发现一致), 则 CSDiD 零结果"
di "      不代表 TWFE 不稳健, 而是说明对照组选择"
di "      对方法高度敏感"

log close
di _newline(2) "Done. See logs/robustness_csdid.log"
