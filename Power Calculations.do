clear all
global main "/Users/apple/Desktop/UDESA/Cuarto Año/Segundo Cuatrimestre/Economia Aplicada/TUTORIALES/Tutorial 8"

cd "/Users/apple/Desktop/UDESA/Cuarto Año/Segundo Cuatrimestre/Economia Aplicada/TUTORIALES/Tutorial 8"
use "$main/Nicaragua.dta"

set obs 2000
sort formulario
gen n=_n
scalar p=0.5

sum income_r1
scalar sigmasq=r(Var)
gen mde = (invttail(n-2, 0.025) + invttail(n-2,0.20))*((sigmasq/ (n*p*(1-p)))^0.5)

*1)	What is the minimum sample size that allows us to reach our target MDE (a difference of 2000 in income)? Create a scalar containing our target MDE (mde_target), and summarize our n variable for all values of n  that generate an MDE at least as small as our target MDE.

scalar mde_target=2000
sum n if mde>=mde_target
tabstat n if mde>=mde_target, save statistics(mean sd min max) columns(statistics)

matrix A=r(StatTotal)
* Transpose
mat A=A'

frmttable using PS8_1, varlabels statmat(A) sdec(2,2,0,0) title("PS8_Ejercicio1")ctitles("Variable name" "Mean", "Standard Deviation", "Minimum", "Maximum (Obs)") dwide replace

*2)	Get the same minimum sample size using the power command in Stata (power twomeans… – help power for more information).

sum mde
power twomeans 2825.236 (2000), power(0.8) sd(4874.854)

*3)	Let’s see if we can lower the MDE through stratification. We’ll create strata based on the type of farmer (rubro denotes the type of farmer). Estimate the variance of the income after removing the variation due to each strata. •	Hint: Run a regression of income_r1 on the strata dummies, and then obtain the variance of income after conditioning on the strata dummies. •	You can obtain the variance of income after conditioning on the strata dummies by multiplying the unconditional variance by 1-R2 from this regression. The R2 is saved in a local macro after running the regression.

tab rubro, gen (rubro_) 
reg income_r1 rubro_1 rubro_2 rubro_3 
outreg2 using regresion2.doc, word dec(3) nocons replace
scalar var_conditioned=sigmasq*(1-0.2844)
display var_conditioned

*4)	Create a new MDE variable based on the stratified experiment. Note that we now have different degrees of freedom (N-6, we’ll be estimating the intercept (1), the ATE (2), the coefficient on the strata dummies (3, 4), and the interaction between the treatment dummy and the strata dummies (5, 6).

gen mde_stratified = (invttail(n-6, 0.025) + invttail(n-6,0.20))*((89049696/ (n*p*(1-p)))^0.5)

*5)	What sample size allows us to reach our target MDE under the stratified design?

scalar mde_stratified=2000 
sum n if mde_stratified>=mde_stratified
tabstat n if mde>=mde_target, save statistics(mean sd min max) columns(statistics)

matrix A=r(StatTotal)
* Transpose
mat A=A'

frmttable using PS8_5, varlabels statmat(A) sdec(2,2,0,0) title("PS8_Ejercicio5")ctitles("Variable name" "Mean", "Standard Deviation", "Minimum", "Maximum (Obs)") dwide replace

*6)	Get the same number using the Stata command power (Hint: use the sd of income after conditioning on the strata).

power twomeans  2314.075 (2000), power(0.8) sd(2959.221)

*7)	Graph the two MDE variables to show how the effect of sample size on the MDE depends on whether or not we stratify. Create your graph using the twoway command. You should have two line plots on your graph, and in each one you will graph the MDE against sample size. Create labels for the MDEs so that someone looking at the graph can get a basic idea of what the two different line plots are showing.[1] Comment.

twoway (line mde n, lcolor(yellow)) (line mde_stratified n, lcolor(orange)) if mde<3500, legend(label(1 "mde") label(2 "mde_stratified")) ytitle("MDE") title("The Effect of Sample Size on the MDE")



 
