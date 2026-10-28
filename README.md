# Replication of Ash, Chen & Naidu, "Ideas Have Consequences" (*QJE* 2026)

Zichen Fang (Peking University; visiting student, University of Chicago)

This repository contains my replication of

> Ash, Elliott, Daniel L. Chen, and Suresh Naidu. "Ideas Have Consequences: The Impact of Law and Economics on American Justice." *Quarterly Journal of Economics* 141(1), 2026.

The paper uses a staggered difference-in-differences design to study whether attending the Manne Economics Institute for Federal Judges changes how U.S. federal judges write and decide cases.

**Report:** [`report/replication_report.pdf`](report/replication_report.pdf)

## Summary

- **Reproduced.** All seven main coefficients (four circuit-court, three district-court) are reproduced exactly, along with the paper's three TWFE diagnostics: the de Chaisemartin & D'Haultfœuille (2020) decomposition, the Jakiela (2021) diagnostic, and the Cengiz et al. (2019) stacked DD.
- **Extended.** I added five robustness checks that are not in the original paper:
  1. a never-attender placebo test (propensity-score matching);
  2. a treatment-timing exogeneity test;
  3. double-selection LASSO covariate selection (Belloni, Chernozhukov & Hansen 2014);
  4. an event-window sensitivity analysis;
  5. the Callaway & Sant'Anna (2021) heterogeneity-robust DiD estimator.
- **Finding.** The conservative-voting effects hold up under every identification strategy. The economics-language and case-outcome effects depend closely on the paper's within-judge TWFE design.

## Repository structure

```
code/
  main.do                  master script: runs the original pipeline, then robustness.do
  robustness.do            the five new robustness checks, including Callaway & Sant'Anna (my code)
  descriptive_statistics.do, sample_composition.do   (my code)
  circuit_*.do, district_*.do, new_programs.do, twfe_robustness.do, honest_trends.do
                           original authors' scripts, with minor path and quoting fixes
output/                    tables (.tex/.csv) and figures (.pdf) produced by the code
report/                    replication report (PDF and LaTeX source)
schemes_grec/              graph schemes from the original package
```

## Data

The data are **not** included in this repository. The six input files (`ready_circuits.dta`, `ready_districts.dta`, `ready_lgraphs.dta`, `ready_elevated.dta`, `ready_fedsoc.dta`, `_district_econtext.dta`) come from the authors' replication package for the *QJE* article. To run the code, put them in `data/`.

## Running

1. Set `global path` at the top of `code/main.do` (and `global root` in `code/robustness.do`) to the repository root.
2. Run `code/main.do` in Stata. The original analysis was run in Stata 18.5 MP. `main.do` installs the required SSC packages; `csdid`, `drdid`, and `pdslasso` are also needed for the robustness checks.

## Credits

The original code and data belong to Ash, Chen & Naidu. The scripts I wrote or modified are marked above. I used AI tools (Claude, DeepSeek) as research assistants, as noted in the report, and verified all code and results myself.
