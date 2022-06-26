global main "/Users/apple/Desktop/UDESA/Cuarto Año/Segundo Cuatrimestre/Economia Aplicada/TUTORIALES/Tutorial 6"
global output "$main/output"
global input "$main/input"

cd "$output"

use "$input/hh_9198.dta" 

*PART 1
*The dataset for this part is “hh_9198.dta”, which is ready to be used. We want to look at the impact of program participation for females (dfmfd) on log total expenditures (generate this variable) using different levels of fixed effects. 
*a)	For each item listed below, if a regression with those fixed effects is identified, please run it, whereas, if it is not, discuss why they are impossible to include. Do not include any controls, only FE and female program participation. Analyze the significance of the coefficient, its t-statistic, p-value, and state where identification comes from in each case.  Present the regressions in one or two tables. (Tip: to generate the fixed effects, you could use the command: egen var = group(var1 var2)). 

*b)
gen ln_exptot = log(exptot)

reg ln_exptot dfmfd, robust
outreg2 using PS6.doc, word dec(5) nocons ctitle("b") keep(dfmfd) replace

*c)
xtset villid
xtreg ln_exptot dfmfd , fe i(villid) robust
outreg2 using PS6.doc, bdec(5) se rdec(5) ctitle("c") keep(dfmfd) append

*d)
xtset year
xtreg ln_exptot dfmfd , fe i(year) robust
outreg2 using PS6.doc, bdec(3) se rdec(3) ctitle("d") keep(dfmfd) append

*e)
xtset nh
xtreg ln_exptot dfmfd , fe i(nh) robust
outreg2 using PS6.doc, bdec(3) se rdec(3) ctitle("e") keep(dfmfd) append

*f)
reg ln_exptot dfmfd i.year i.villid, robust
outreg2 using PS6.doc, bdec(3) se rdec(3) ctitle("f") keep(dfmfd) append

*g)
reg ln_exptot dfmfd i.villid i.nh, robust
outreg2 using Regresion2.doc, bdec(3) se rdec(3) ctitle("g") keep(dfmfd) replace

*h)
reg ln_exptot dfmfd i.nh i.year, robust
outreg2 using PS6_1.doc, bdec(3) se rdec(3) ctitle("h") keep(dfmfd) append

*i)
egen vill_year = group(villid year)
xtset vill_year
xtreg ln_exptot dfmfd, fe i(vill_year) robust
outreg2 using PS6_1.doc, bdec(3) se rdec(3) ctitle("i") keep(dfmfd) append

*j)
egen vill_nh = group(villid nh)
xtset vill_nh
xtreg ln_exptot dfmfd, fe i(vill_nh) robust
outreg2 using PS6_1.doc, bdec(3) se rdec(3) ctitle("j") keep(dfmfd) append

*k)
egen nh_year = group(nh year)
xtset nh_year
xtreg ln_exptot dfmfd, fe i(nh_year) robust
outreg2 using PS6_1.doc, bdec(3) se rdec(3) ctitle("k") keep(dfmfd) append

*l)
reg ln_exptot dfmfd i.nh_year i.nh
outreg2 using PS6_1.doc, bdec(3) se rdec(3) ctitle("l") keep(dfmfd) append

