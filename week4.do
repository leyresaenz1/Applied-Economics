clear all
global main "/Users/apple/Desktop/UDESA/Cuarto Año/SegundoCuatrimestre/Economia Aplicada/TUTORIALES/Tutorial 4"
global output "$main/output"
cd "$output"

//////////////////////////////////////////////////////////////////

*1. Repeat the simulation exercise including minor modifications
to show the following points. If you want, you can come up with
 a model of your own.

*a) What will happen to the standard errors of the regressors if you increase the sample? set obs 100
set obs 100
set seed 1234
gen intelligence=int(invnormal(uniform())*20+100)
gen education=int(intelligence/10+invnormal(uniform())*1)
corr education intelligence
gen a=int(invnormal(uniform())*2+10)
gen b=int(invnormal(uniform())*1+5)
gen u=int(invnormal(uniform())*1+7)
gen wage=3*intelligence+a+2*b+u

*Regresión del modelo y outreg
reg wage intelligence a b ,robust
outreg2 using regresion.doc, word dec(3) replace

*Copio el modelo pero con más observaciones
set obs 1000
set seed 1234
gen intelligence2=int(invnormal(uniform())*20+100)
gen education2=int(intelligence/10+invnormal(uniform())*1)
corr education intelligence
gen a2=int(invnormal(uniform())*2+10)
gen b2=int(invnormal(uniform())*1+5)
gen u2=int(invnormal(uniform())*1+7)
gen wage2=3*intelligence2+a2+2*b2+u2

*Regresión del modelo y outreg
reg wage2 intelligence2 a2 b2 ,robust
outreg2 using regresion2.doc, word dec(3) replace

*Regresiones de ambos modelos
*Conclusión: si se aumenta la muestra, los errores estándares de los regresores caen. Tiene que ver con la propia definición de error estándar. 

//////////////////////////////////////////////////////////////////

*b) What will happen to hte standard errors of the regressors if you increase the variance of "u" (the error term, not the residuals)?

clear all
set obs 100
set seed 1234
gen intelligence=int(invnormal(uniform())*20+100)
gen education=int(intelligence/10+invnormal(uniform())*1)
corr education intelligence
gen a=int(invnormal(uniform())*2+10)
gen b=int(invnormal(uniform())*1+5)
gen u=int(invnormal(uniform())*1+7)
gen wage=3*intelligence+a+2*b+u

reg wage intelligence a b ,robust
outreg2 using regresion3.doc, word dec(3) replace

*Genero otro error con mayor varianza (=10)
gen u2=int(invnormal(uniform())*10+7)
gen wage2=3*intelligence+a+2*b+u2

*Regresión del modelo y outreg
reg wage2 intelligence a b ,robust
outreg2 using regresion4.doc, word dec(3) replace

*Conclusión: los errores estándar aumentan al aumentar la varianza del error

//////////////////////////////////////////////////////////////////

*c) What will happen to the standard errors of the regressor if you increase the variance of X?
*Genero la misma variable X con una varianza de 40 en lugar de 20

gen intelligence2=int(invnormal(uniform())*40+120)
gen wage3=3*intelligence2+a+2*b+u

*Regresión del modelo y outreg
reg wage3 intelligence2 a b ,robust
outreg2 using regresion5.doc, word dec(3) replace

*Conclusión: el error estándar de la variable X (inteligencia) es bastante mayor cuando la varianza es mayor.

//////////////////////////////////////////////////////////////////

*d)The value of the sum of the residuals

reg wage intelligence a b , robust
predict y_hat_1
est store ols11
predict resid,res
egen sumres=sum(resid)
sum sumres

*El valor de la suma de los residuos es 2.661e-08

//////////////////////////////////////////////////////////////////

*e)Are the residuals orthogonal to the regressors? 
clear all
set obs 100
set seed 1234
gen intelligence=int(invnormal(uniform())*20+100)
hist intelligence, norm
gen education=int(intelligence/10+invnormal(uniform())*2)
hist education, norm
corr education intelligence
gen a=int(invnormal(uniform())*2+10)
gen b=int(invnormal(uniform())*1+5)
gen c=int(invnormal(uniform())*3+150)
gen u=int(invnormal(uniform())*1+7)
hist u, norm
sum intelligence education a b c u
gen wage=3*intelligence+a+2*b+c+u 

*Regresión del modelo y outreg
reg wage intelligence a b ,robust
outreg2 using regresion6.doc, word dec(3) replace

reg wage education intelligence ,robust
outreg2 using regresion7.doc, word dec(3) replace

reg wage education, robust
outreg2 using regresion8.doc, word dec(3) replace


//////////////////////////////////////////////////////////////////

*f)How does hight multicollinearity affect the estimation of Y?

reg wage intelligence a b 
predict y_hat_1
est store ols11

reg wage education intelligence a b 
predict y_hat_2
est store ols12

corr y_hat_1 y_hat_2
*Correlación=1 --> ambas regresiones son muy iguales

esttab ols11 ols12
suest ols11 ols12, robust
outreg2 using regresion9.doc, word dec(3) replace

//////////////////////////////////////////////////////////////////

*g)What happens if you run a regression with a non-random error in X? And if it would have been random?

clear all
set obs 100
set seed 1234
gen intelligence=int(invnormal(uniform())*20+120)
gen education=int(intelligence/10+invnormal(uniform())*1)
corr education intelligence
gen a=int(invnormal(uniform())*2+10)
gen b=int(invnormal(uniform())*1+5)
gen u=int(invnormal(uniform())*1+7)
gen wage=3*intelligence+a+2*b+u
gen intelligence_false=intelligence+2

reg wage intelligence a b
reg wage intelligence_false a b

*Si la regresión tiene un error "non-random", los parámetros estimados no cambian, y los errores estándar tampoco.

gen intelligence_random=intelligence+int(invnormal(uniform())*2+10)

reg wage intelligence a b
reg wage intelligence_random a b

*En este caso los parámetros se vieron más afectados pero igualmente son bastante "accurate". Los errores estándar son mayores. La constante cambió de 5.64 a -22.42

//////////////////////////////////////////////////////////////////

*h)What happens if you run a regression with a non-random error in Y? And if it would have been random?

gen wage_nonrandom=wage+5
reg wage intelligence a b 
reg wage_nonrandom intelligence a b

*La estimación de los parámetros y los erróres estándar se mantuvieron. La constante pasó de 5.64 a 10.64

gen wage_random=wage+(invnormal(uniform())*1+5)
reg wage intelligence a b 
reg wage_random intelligence a b

*La estimación de los parámetros se mantiene pero los erróres estándar crecieron. La constante pasó de 5.64 a 10.55

 
   
