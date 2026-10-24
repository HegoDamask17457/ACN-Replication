*********************************************
*************** Master Do-File **************
*********************************************

clear all
set more off
set graphics off
capture log close

************
** setup ***
************

* For Replicators: Change the working directory below

* ================================
* Windows 路径设置
* ================================

* 设置根目录（你的实际路径）
global path "path/to/acn-replication"

* 切换到根目录
cd "${path}"

* 开启日志
cap mkdir "${path}/logs"          // 如果 logs 不存在则创建
local datetime = subinstr(subinstr("`=c(current_date)'" + "-" + "`=c(current_time)'", " ", "_", .), ":", "-", .)
log using "${path}/logs/log_ACN_`datetime'", replace text

* 添加图形样式路径（如果 schemes_grec 存在）
cap confirm file "${path}/schemes_grec"
if _rc == 0 {
    adopath + "${path}/schemes_grec"
}
else {
    di as error "注意：schemes_grec 文件夹不存在，使用默认样式"
}

* ============================= Programs ==================================== */

cap program drop _all
if _rc == 0 {
    cap ssc install binscatter,        replace
    cap ssc install coefplot,          replace
    cap ssc install elasticregress,    replace
    cap ssc install estout,            replace
    cap ssc install gtools,            replace
    cap ssc install lgraph,            replace
    cap ssc install ppmlhdfe,          replace
    cap ssc install reghdfe,           replace
    cap ssc install twowayfeweights,   replace
    cap ssc install winsor2,           replace
    cap ssc install ftools,            replace
    cap ssc install egenmore,          replace
    cap ssc install honestdid,         replace
    cap ssc install grstyle,           replace
    * 注意：以上安装失败的包，若已存在于系统中则使用现有版本
}

* =========================== Run Subfiles ================================== */

do "code/circuit_figures_judgefe_mw6_new_options_program.do"
do "code/circuit_tables_judgefe.do"
do "code/district_figures_mw5_new_options_program.do"
do "code/district_all_wo_options_program.do"
do "code/twfe_robustness.do"
do "code/honest_trends.do"

* =========================== 复现项目的稳健性检验 ============================= */
do "code/robustness.do"

// Remove temporary grec file
erase "y_title_coefplot_no_legenda.grec"

capture log close
