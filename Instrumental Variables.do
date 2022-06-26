******************************
*    Applied Economics       *
*          Week #5           *
*   Instrumental Variables   *
******************************

global main "/Users/apple/Desktop/UDESA/Cuarto Año/Segundo Cuatrimestre/Economia Aplicada/TUTORIALES/Tutorial 5"
global output "$main/output"
global input "$main/input"

cd "$output"

use "$input/poppy", clear

///////////////////////////////////////////////////
*1.	Generate the “Chinese presence” variable as specified in the paper.

gen chinese_presence = 1
replace chinese_presence = 0 if chinos1930hoy ==0 
br chinese_presence

///////////////////////////////////////////////////
*2.	Show descriptive statistics of the relevant variables (as in Table 1) with all the available variables. From now on, do not include Distrito Federal in the estimates.
drop if estado =="Distrito Federal"
tabstat chinese_presence cartel2010 cartel2005 distancia_km superficie_km POB_TOT_2015 IM_2015 TempMed_Anual PrecipAnual_med tempopium dalemanes distkmDF mindistcosta capestado pob1930cabec, save statistics(mean sd min max) columns(statistics)

matrix A=r(StatTotal)
* Transpose
mat A=A'

frmttable using Hola1, varlabels statmat(A) sdec(2,2,0,0) title("Estadistica Descriptiva, China")ctitles("Variable name" "Mean", "Standard Deviation", "Minimum", "Maximum") dwide replace

///////////////////////////////////////////////////		
*3.	Reproduce the least squares regressions in columns 3 to 6 of Table 5. All regressions are estimated using clustered errors (we will study this later in the course). Instead of using “robust” as an option, run “cluster(id_estado)”. 
* Run the fist stage and predict the residuals
reg cartel2010 chinese_presence, cluster(id_estado)
outreg2 using regresion1.doc, word dec(3) keep(chinese_presence) label nocons addtext(State dummies, Yes, Controls, No, Clusters, 31) replace

reg cartel2010 chinese_presence dalemanes tempopium TempMed_Anual PrecipAnual_med superficie_km POB_TOT_2015 distancia_km distkmDF, cluster(id_estado)
outreg2 using regresion1.doc, word dec(3) keep(chinese_presence) nocons addtext(State dummies, Yes, Controls, Yes, Clusters, 30) append

reg cartel2005 chinese_presence, cluster(id_estado)
outreg2 using regresion1.doc, word dec(3) keep(chinese_presence) nocons addtext(State dummies, Yes, Controls, No, Clusters, 31) append

reg cartel2005 chinese_presence dalemanes tempopium TempMed_Anual PrecipAnual_med superficie_km POB_TOT_2015 distancia_km distkmDF, cluster(id_estado)
outreg2 using regresion1.doc, word dec(3) keep(chinese_presence) nocons addtext(State dummies, Yes, Controls, Yes, Clusters, 30) append


///////////////////////////////////////////////////	
*4.	Reproduce the IV estimates in Table 7 using cartel presence in 2010 as the instrumented variable. Report the F statistics as in the paper. Is the instrument relevant? Note: we will call the second column of this table the “basic specification”. Also, reproduce Table 8. Explain intuitively what these estimations show.
*Tabla 7
ivregress 2sls IM_2015 i.id_estado (cartel2010 = chinese_presence), cluster(id_estado)
estat firststage
outreg2 using regresion2.doc, word dec(3) keep(cartel2010) nocons addtext(F-Test, 39.3753, State dummies, Yes, Controls, No, Clusters, 31) addnote (Notes:Standard errors clustered at the state level are shown in parentheses. Wild-bootstrapped p-values are shown in brackets (999 replications). The unit of observation is a municipality. The unit of cluster is a state. All models are estimated using Two Stages Least Squares. Cartel presence is instrumented using Chinese presence F-test is the F-test of excluded instruments (p-values are shown in parentheses). In Columns (2) to (4) the set of controls includes German presence, Poppy suitability, Average temperature, Average precipitation, Surface, Population in 1930, Distance to U.S., Distance to Mexico City, Distance to closest port, and Head of state. Column (5) further controls for Local population growth. Column (3) excludes municipalities located more than 100 km from U.S. border. Column (4) excludes municipalities located in the state of Sinaloa. *Significant at the 10% level. **Significant at the 5% level. ***Significant at the 1% level.) replace 

ivregress 2sls IM_2015 (cartel2010 = chinese_presence) dalemanes tempopium TempMed_Anual PrecipAnual_med superficie_km pob1930cabec distancia_km distkmDF capestado mindistcosta i.id_estado, cluster(id_estado)
estat firststage
outreg2 using regresion2.doc, word dec(3) keep(cartel2010) nocons addtext(F-Test, 7.7408, State dummies, Yes, Controls, Yes, Clusters, 30) append 

keep if distancia_km > 100
ivregress 2sls IM_2015 (cartel2010 = chinese_presence) dalemanes tempopium TempMed_Anual PrecipAnual_med superficie_km pob1930cabec distkmDF capestado mindistcosta i.id_estado, cluster (id_estado)
estat firststage
outreg2 using regresion2.doc, word dec(3) keep(cartel2010) nocons addtext(F-Test, 5.27083, State dummies, Yes, Controls, Yes, Clusters, 30) append 

drop if estado =="Sinaloa"
ivregress 2sls IM_2015 (cartel2010 = chinese_presence) dalemanes tempopium TempMed_Anual PrecipAnual_med superficie_km pob1930cabec distancia_km distkmDF capestado mindistcosta i.id_estado, cluster (id_estado)
estat firststage
outreg2 using regresion2.doc, word dec(3) keep(cartel2010) nocons addtext(F-Test, 5.77086, State dummies, Yes, Controls, Yes, Clusters, 29) append 

ivregress 2sls IM_2015 (cartel2010 = chinese_presence) dalemanes tempopium TempMed_Anual PrecipAnual_med superficie_km pob1930cabec distancia_km distkmDF capestado mindistcosta growthperc i.id_estado, cluster (id_estado)
estat firststage
outreg2 using regresion2.doc, word dec(3) keep(cartel2010) nocons addtext(F-Test, 7.64253, State dummies, Yes, Controls, Yes, Clusters, 30) append 

************************
**Instrument relevance**
************************

reg cartel2010 chinese_presence

* Test 
test chinese_presence


* Tabla 8
ivregress 2sls ANALF_2015 i.id_estado (cartel2010 = chinese_presence), cluster(id_estado)
estat firststage
outreg2 using regresion3.doc, keep(cartel2010) word label pvalue dec(3) nocons addtext (State dummies, Yes, Controls, No, Clusters, 30) addnote (Notes: Standard errors clustered at the state level are shown in parentheses. Wild-bootstrapped p-values are shown in brackets (999 replications). The unit of observation is a municipality. The unit of cluster is a state. All models are estimated using Two Stages Least Squares. Cartel presence is instrumented using Chinese presence. The set of controls includes German presence, Poppy suitability, Average temperature, Average precipitation, Surface, Population, Distance to U.S., Distance to Mexico City, Distance to closest port, and Head of state. *Significant at the 10% level. **Significant at the 5% level. ***Significant at the 1% level.) replace

ivregress 2sls SPRIM_2015 (cartel2010 = chinese_presence) dalemanes tempopium TempMed_Anual PrecipAnual_med superficie_km pob1930cabec distancia_km distkmDF capestado mindistcosta i.id_estado, cluster(id_estado)
estat firststage
outreg2 using regresion3.doc, keep(cartel2010) word label pvalue dec(3) nocons addtext (State dummies, Yes, Controls, Yes, Clusters, 30) append 

ivregress 2sls OVSDE_2015 (cartel2010 = chinese_presence) dalemanes tempopium TempMed_Anual PrecipAnual_med superficie_km pob1930cabec distkmDF capestado mindistcosta i.id_estado, cluster (id_estado)
estat firststage
outreg2 using regresion3.doc, keep(cartel2010) word label pvalue dec(3) nocons addtext (State dummies, Yes, Controls, Yes, Clusters, 30) append 

ivregress 2sls OVSEE_2015 (cartel2010 = chinese_presence) dalemanes tempopium TempMed_Anual PrecipAnual_med superficie_km pob1930cabec distancia_km distkmDF capestado mindistcosta i.id_estado, cluster (id_estado)
estat firststage
outreg2 using regresion3.doc, keep(cartel2010) word label pvalue dec(3) nocons addtext (State dummies, Yes, Controls, Yes, Clusters, 30) append 

ivregress 2sls OVSAE_2015 (cartel2010 = chinese_presence) dalemanes tempopium TempMed_Anual PrecipAnual_med superficie_km pob1930cabec distancia_km distkmDF capestado mindistcosta growthperc i.id_estado, cluster (id_estado)
estat firststage
outreg2 using regresion3.doc, keep(cartel2010) word label pvalue dec(3) nocons addtext (State dummies, Yes, Controls, Yes, Clusters, 30) append 

ivregress 2sls VHAC_2015 (cartel2010 = chinese_presence) dalemanes tempopium TempMed_Anual PrecipAnual_med superficie_km pob1930cabec distancia_km distkmDF capestado mindistcosta growthperc i.id_estado, cluster (id_estado)
estat firststage
outreg2 using regresion3.doc, keep(cartel2010) word label pvalue dec(3) nocons addtext (State dummies, Yes, Controls, Yes, Clusters, 30) append 

ivregress 2sls OVPT_2015 (cartel2010 = chinese_presence) dalemanes tempopium TempMed_Anual PrecipAnual_med superficie_km pob1930cabec distancia_km distkmDF capestado mindistcosta growthperc i.id_estado, cluster (id_estado)
estat firststage
outreg2 using regresion3.doc, keep(cartel2010) word label pvalue dec(3) nocons addtext (State dummies, Yes, Controls, Yes, Clusters, 30) append 

ivregress 2sls PL5000_2015 (cartel2010 = chinese_presence) dalemanes tempopium TempMed_Anual PrecipAnual_med superficie_km pob1930cabec distancia_km distkmDF capestado mindistcosta growthperc i.id_estado, cluster (id_estado)
estat firststage
outreg2 using regresion3.doc, keep(cartel2010) word label pvalue dec(3) nocons addtext (State dummies, Yes, Controls, Yes, Clusters, 30) append 

ivregress 2sls PO2SM_2015 (cartel2010 = chinese_presence) dalemanes tempopium TempMed_Anual PrecipAnual_med superficie_km pob1930cabec distancia_km distkmDF capestado mindistcosta growthperc i.id_estado, cluster (id_estado)
estat firststage
outreg2 using regresion3.doc, keep(cartel2010) word label pvalue dec(3) nocons addtext (State dummies, Yes, Controls, Yes, Clusters, 30) append 

////////////////////////////////////////////	
*5.	Can you test the instrument's exogeneity? If you knew that the instrument is exogenous, would you be able to test cartel presence exogeneity? Explain and perform the test. Is it useful? You can use, for instance, the basic specification.
********************
*** Hausman Test ***
********************
* Save the IV estimates
ivregress 2sls IM_2015 (cartel2010 = chinese_presence) dalemanes tempopium TempMed_Anual PrecipAnual_med superficie_km pob1930cabec distancia_km distkmDF capestado mindistcosta i.id_estado
est store iv

* Save the OLS estimates
reg IM_2015 cartel2010 dalemanes tempopium TempMed_Anual PrecipAnual_med superficie_km pob1930cabec distancia_km distkmDF capestado mindistcosta i.id_estado 
est store ols

hausman ols iv

*test de endogeneidad
ivregress 2sls IM_2015 (cartel2010 = chinese_presence) dalemanes tempopium TempMed_Anual PrecipAnual_med superficie_km pob1930cabec distancia_km distkmDF capestado mindistcosta i.id_estado, robust
estat endogenous 

*se rechaza la hipótesis nula

///////////////////////////////////////////////////	
*6.	Take the baseline IV specification and add "german presence” as an instrument. Perform an over-identifying restrictions test (Sargan-test or J-test). What is the conclusion?
*******************
*** Sargan test ***
*******************

* Estimate by IV and predict the residuals
ivregress 2sls IM_2015 (cartel2010 = chinese_presence dalemanes) tempopium TempMed_Anual PrecipAnual_med superficie_km pob1930cabec distancia_km distkmDF capestado mindistcosta i.id_estado, cluster(id_estado)
predict resid, residual

* Regress the residuals on all the exogenous variables (instruments and controls) 
reg resid tempopium TempMed_Anual PrecipAnual_med superficie_km pob1930cabec distancia_km distkmDF capestado mindistcosta i.id_estado, cluster(id_estado)

* Obtain the R2 and use it to compute the statistic S=nR2
ereturn list
display chi2tail(1,e(N)*e(r2))

