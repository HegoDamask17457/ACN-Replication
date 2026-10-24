*********************************************************************
*  sample_composition.do
*
*  目的：统计样本构成——总观测数、总法官数、Manne参加法官数
*  用于理解对照组选取问题
*********************************************************************

clear all
set more off
cap log close

* --- 路径设置 ---
global path "path/to/acn-replication"
cd "${path}"
log using "logs/sample_composition.log", replace text

* =====================================================================
*  1. 上诉法院样本 (ready_circuits.dta)
* =====================================================================
use "data/ready_circuits.dta", clear

di _newline(2) "========== 上诉法院 (Circuit Courts) =========="

* 总观测数
count
di "总观测数: " r(N)

* 总法官数 (unique songername)
distinct songername
di "总法官数 (unique songername): " r(ndistinct)

* 参加了 Manne 的法官数
preserve
    collapse (max) manne_ever = manne, by(songername)
    count if manne_ever == 1
    di "参加 Manne 的法官数: " r(N)

    count
    di "总法官数 (judge-level): " r(N)

    * 比例
    count if manne_ever == 1
    local attended = r(N)
    count
    local total = r(N)
    di "参加比例: " %5.1f (`attended'/`total'*100) "%"
restore

* 分观测：以 manne_post 计
count if manne_post == 1
di "观测中 manne_post==1 的数量: " r(N)
count if manne == 1
di "观测中 manne==1 的数量: " r(N)

* =====================================================================
*  2. 地方法院样本 (ready_districts.dta)
* =====================================================================
use "data/ready_districts.dta", clear

di _newline(2) "========== 地方法院 (District Courts) =========="

count
di "总观测数: " r(N)

distinct songername
di "总法官数 (unique songername): " r(ndistinct)

preserve
    collapse (max) manne_ever = manne, by(songername)
    count if manne_ever == 1
    di "参加 Manne 的法官数: " r(N)

    count
    di "总法官数 (judge-level): " r(N)

    count if manne_ever == 1
    local attended = r(N)
    count
    local total = r(N)
    di "参加比例: " %5.1f (`attended'/`total'*100) "%"
restore

* =====================================================================
*  3. 加入对照组讨论：从不参加者 vs 尚未参加者
* =====================================================================
use "data/ready_circuits.dta", clear

di _newline(2) "========== 对照组构成分析 =========="

* 从不参加 (never-takers)：manne == 0 的法官
preserve
    collapse (max) is_manne = manne, by(songername)
    count if is_manne == 0
    di "从不参加者 (never-attenders) 法官数: " r(N)
    count if is_manne == 1
    di "曾经参加者 (ever-attenders) 法官数: " r(N)
restore

* 在分析样本中，有多少观测来自 never-attenders vs ever-attenders
* 使用 mw6 样本窗（主回归窗口）
preserve
    keep if mw6 == 1
    count
    di "mw6 样本窗观测数: " r(N)

    * 按 manne 分组
    bysort manne: count
    di "  manne==0 (never-attenders in mw6): 需要确认"

    * 实际区分：观测中 manne==0 但 mw6==1 的是 not-yet-attenders
    * (因为 mw6 只对 event time 在±6的观测为1，never-attenders 的 manne_time 缺失，mw6 可能为. )
restore

log close
di _newline "Done. See logs/sample_composition.log"
