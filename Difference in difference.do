clear all
global main "/Users/apple/Desktop/UDESA/Cuarto Año/Segundo Cuatrimestre/Economia Aplicada/TUTORIALES/Tutorial 9/PS9"

cd "/Users/apple/Desktop/UDESA/Cuarto Año/Segundo Cuatrimestre/Economia Aplicada/TUTORIALES/Tutorial 9/PS9"

use "castle.dta"

* define global macros
global crime1 jhcitizen_c jhpolice_c murder homicide  robbery assault burglary larceny motor robbery_gun_r 
global demo blackm_15_24 whitem_15_24 blackm_25_44 whitem_25_44 //demographics
global lintrend trend_1-trend_51 //state linear trend
global region r20001-r20104  //region-quarter fixed effects
global exocrime l_larceny l_motor // exogenous crime rates
global spending l_exp_subsidy l_exp_pubwelfare
global xvar l_police unemployrt poverty l_income l_prisoner l_lagprisoner $demo $spending

label variable post "Year of treatment"
xi: xtreg l_homicide i.year $region $xvar $lintrend post [aweight=popwt], fe vce(cluster sid)

* Event study regression with the year of treatment (lag0) as the omitted category.
xi: xtreg l_homicide  i.year $region lead9 lead8 lead7 lead6 lead5 lead4 lead3 lead2 lead1 lag1-lag5 [aweight=popwt], fe vce(cluster sid)

label variable l_burglary "Log (Burglary Rate)"
label variable l_robbery "Log (Robbery Rate)"
label variable l_assault "Log (Aggravated Assault Rate)"
label variable pre2_cdl "0 to 2 years before adoption of castle doctrine law"

* EJERCICIO 1
//// PANEL  A ////

//// OLS - Weighted by State Population /////

*PRIMER COLUMNA
xi: xtreg l_burglary post i.year [aweight=popwt], fe vce(cluster sid)
outreg2 using PS9.doc, word dec(5) se rdec(5) nocons ctitle("1") title("OLS - Weighted by State Population") keep(post) addnote(Notes: Each column in each panel represents a separate regression. The unit of observation is state-year. Robust standard errors are clustered at the state level. Time-varying controls include policing and incarceration rates, welfare and public assistance spending, median income, poverty rate, unemployment rate, and demographics. Contemporaneous crime rates include larceny and motor vehicle theft rates.*Significant at the 10% level**Significant at the 5% level ***Significant at the 1% level) 
label replace

*SEGUNDA COLUMNA
xi: xtreg l_burglary post i.year $region [aweight=popwt], fe vce(cluster sid)
outreg2 using PS9.doc, bdec(5) se rdec(5) nocons ctitle("2") keep(post) label append

*TERCERA COLUMNA
xi: xtreg l_burglary post i.year $xvar $region [aweight=popwt], fe vce(cluster sid)
outreg2 using PS9.doc, bdec(5) se rdec(5) nocons ctitle("3") keep(post) label append

*CUARTA COLUMNA
xi: xtreg l_burglary post pre2_cdl i.year $xvar $region [aweight=popwt], fe vce(cluster sid)
outreg2 using PS9.doc, bdec(5) se rdec(5) nocons ctitle("4") keep(post pre2_cdl) label append


*QUINTA COLUMNA
xi: xtreg l_burglary post $exocrime i.year $xvar $region [aweight=popwt], fe vce(cluster sid)
outreg2 using PS9.doc, bdec(5) se rdec(5) nocons ctitle("5") keep(post) label append

*SEXTA COLUMNA
xi: xtreg l_burglary post  i.year $lintrend $xvar $region [aweight=popwt], fe vce(cluster sid)
outreg2 using PS9.doc, bdec(5) se rdec(5) nocons ctitle("6") keep(post) label append

//// OLS - Unweighted /////

*SÉPTIMA COLUMNA
xi: xtreg l_burglary post i.year, fe vce(cluster sid)
outreg2 using PS9.doc, bdec(5) se rdec(5) nocons ctitle("7") title("OLS - Unweighted") keep(post) label append

*OCTAVA COLUMNA
xi: xtreg l_burglary post i.year $region , fe vce(cluster sid)
outreg2 using PS9.doc, bdec(5) se rdec(5) nocons ctitle("8") keep(post) label append

*NOVENA COLUMNA
xi: xtreg l_burglary post i.year $xvar $region , fe vce(cluster sid)
outreg2 using PS9.doc, bdec(5) se rdec(5) nocons ctitle("9") keep(post) label append

*DÉCIMA COLUMNA
xi: xtreg l_burglary post pre2_cdl i.year $xvar $region , fe vce(cluster sid)
outreg2 using PS9.doc, bdec(5) se rdec(5) nocons ctitle("10") keep(post pre2_cdl) label append

*ONCEAVA COLUMNA
xi: xtreg l_burglary post $exocrime i.year $xvar $region , fe vce(cluster sid)
outreg2 using PS9.doc, bdec(5) se rdec(5) nocons ctitle("11") keep(post) label append

*DOCEAVA COLUMNA
xi: xtreg l_burglary post  i.year $lintrend $xvar $region , fe vce(cluster sid)
outreg2 using PS9.doc, bdec(5) se rdec(5) nocons ctitle("12") keep(post) label append


//// PANEL  B ////

//// OLS - Weighted by State Population /////

*PRIMER COLUMNA
xi: xtreg l_robbery post i.year [aweight=popwt], fe vce(cluster sid)
outreg2 using PS9B.doc, word dec(5) se rdec(5) nocons ctitle("1") keep(post) label replace

*SEGUNDA COLUMNA
xi: xtreg l_robbery post i.year $region [aweight=popwt], fe vce(cluster sid)
outreg2 using PS9B.doc, bdec(5) se rdec(5) nocons ctitle("2") keep(post) label append

*TERCERA COLUMNA
xi: xtreg l_robbery post i.year $xvar $region [aweight=popwt], fe vce(cluster sid)
outreg2 using PS9B.doc, bdec(5) se rdec(5) nocons ctitle("3") keep(post) label append

*CUARTA COLUMNA
xi: xtreg l_robbery post pre2_cdl i.year $xvar $region [aweight=popwt], fe vce(cluster sid)
outreg2 using PS9B.doc, bdec(5) se rdec(5) nocons ctitle("4") keep(post pre2_cdl) label append


*QUINTA COLUMNA
xi: xtreg l_robbery post $exocrime i.year $xvar $region [aweight=popwt], fe vce(cluster sid)
outreg2 using PS9B.doc, bdec(5) se rdec(5) nocons ctitle("5") keep(post) label append

*SEXTA COLUMNA
xi: xtreg l_robbery post i.year $lintrend $xvar $region [aweight=popwt], fe vce(cluster sid)
outreg2 using PS9B.doc, bdec(5) se rdec(5) nocons ctitle("6") keep(post) append

//// OLS - Unweighted /////

*SÉPTIMA COLUMNA
xi: xtreg l_robbery post i.year, fe vce(cluster sid)
outreg2 using PS9B.doc, bdec(5) se rdec(5) nocons ctitle("7") keep(post) label append

*OCTAVA COLUMNA
xi: xtreg l_robbery post i.year $region , fe vce(cluster sid)
outreg2 using PS9B.doc, bdec(5) se rdec(5) nocons ctitle("8") keep(post) label append

*NOVENA COLUMNA
xi: xtreg l_robbery post i.year $xvar $region , fe vce(cluster sid)
outreg2 using PS9B.doc, bdec(5) se rdec(5) nocons ctitle("9") keep(post) label append

*DÉCIMA COLUMNA
xi: xtreg l_robbery post pre2_cdl i.year $xvar $region , fe vce(cluster sid)
outreg2 using PS9B.doc, bdec(5) se rdec(5) nocons ctitle("10") keep(post pre2_cdl) label append

*ONCEAVA COLUMNA
xi: xtreg l_robbery post $exocrime i.year $xvar $region , fe vce(cluster sid)
outreg2 using PS9B.doc, bdec(5) se rdec(5) nocons ctitle("11") keep(post) label append

*DOCEAVA COLUMNA
xi: xtreg l_robbery post i.year $lintrend $xvar $region , fe vce(cluster sid)
outreg2 using PS9B.doc, bdec(5) se rdec(5) nocons ctitle("12") keep(post) label append



//// PANEL  C ////

//// OLS - Weighted by State Population /////

*PRIMER COLUMNA
xi: xtreg l_assault post i.year [aweight=popwt], fe vce(cluster sid)
outreg2 using PS9C.doc, word dec(5) se rdec(5) nocons ctitle("1") keep(post) label addtext(State and Year Fixed Effects, Yes) replace

*SEGUNDA COLUMNA
xi: xtreg l_assault post i.year $region [aweight=popwt], fe vce(cluster sid)
outreg2 using PS9C.doc, bdec(5) se rdec(5) nocons ctitle("2") keep(post) label addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, Yes) append

*TERCERA COLUMNA
xi: xtreg l_assault post i.year $xvar $region [aweight=popwt], fe vce(cluster sid)
outreg2 using PS9C.doc, bdec(5) se rdec(5) nocons ctitle("3") keep(post) label addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, Yes, Time- Varying Controls, Yes) append

*CUARTA COLUMNA
xi: xtreg l_assault post pre2_cdl i.year $xvar $region [aweight=popwt], fe vce(cluster sid)
outreg2 using PS9C.doc, bdec(5) se rdec(5) nocons ctitle("4") keep(post pre2_cdl) label addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, Yes, Time- Varying Controls, Yes) append


*QUINTA COLUMNA
xi: xtreg l_assault post $exocrime  i.year $xvar $region [aweight=popwt], fe vce(cluster sid)
outreg2 using PS9C.doc, bdec(5) se rdec(5) nocons ctitle("5") keep(post) label addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, Yes, Time- Varying Controls, Yes, Contemporaneous Crime Rates, Yes) append

*SEXTA COLUMNA
xi: xtreg l_assault post  i.year $lintrend $xvar $region [aweight=popwt], fe vce(cluster sid)
outreg2 using PS9C.doc, bdec(5) se rdec(5) nocons ctitle("6") keep(post) label addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, Yes, Time- Varying Controls, Yes, State-Specific Linear Time Trends, Yes) append

//// OLS - Unweighted /////

*SÉPTIMA COLUMNA
xi: xtreg l_assault post i.year, fe vce(cluster sid)
outreg2 using PS9C.doc, bdec(5) se rdec(5) nocons ctitle("7") keep(post) label addtext(State and Year Fixed Effects, Yes) append

*OCTAVA COLUMNA
xi: xtreg l_assault post i.year $region , fe vce(cluster sid)
outreg2 using PS9C.doc, bdec(5) se rdec(5) nocons ctitle("8") keep(post) label addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, Yes)append

*NOVENA COLUMNA
xi: xtreg l_assault post i.year $xvar $region , fe vce(cluster sid)
outreg2 using PS9C.doc, bdec(5) se rdec(5) nocons ctitle("9") keep(post) label addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, Yes, Time- Varying Controls, Yes)append

*DÉCIMA COLUMNA
xi: xtreg l_assault post pre2_cdl i.year $xvar $region , fe vce(cluster sid)
outreg2 using PS9C.doc, bdec(5) se rdec(5) nocons ctitle("10") keep(post pre2_cdl) label addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, Yes, Time- Varying Controls, Yes)  append

*ONCEAVA COLUMNA
xi: xtreg l_assault post $exocrime  i.year $xvar $region , fe vce(cluster sid)
outreg2 using PS9C.doc, bdec(5) se rdec(5) nocons ctitle("11") keep(post) label addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, Yes, Time- Varying Controls, Yes, Contemporaneous Crime Rates, Yes) append

*DOCEAVA COLUMNA
xi: xtreg l_assault post  i.year $lintrend $xvar $region , fe vce(cluster sid)
outreg2 using PS9C.doc, bdec(5) se rdec(5) nocons ctitle("12") keep(post) label addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, Yes, Time- Varying Controls, Yes, State-Specific Linear Time Trends, Yes)  append


//// EJERCICIO 2 ////

ssc install csdid
ssc install drdid

replace effyear = 0 if effyear == .

csdid l_assault post, var(sid) time(year) gvar(effyear) method(reg) notyet


*Test de tendencias paralelas : H0 = las tendencias son paralelas previas a la introducción del tratamiento
estat pretrend

*Pretrend Test. H0 All Pre-treatment are equal to 0
*p-value       = 1.02904250219e-33
*Rechazamos la hipótesis nula: el p-valor no es significativamente distinto de 0 por lo que no se cumple el supuesto de tendencias paralelas

*ATT promedio:
estat simple
*ATT=0,0039
*El coeficiente no es significativo a ninguno de los niveles usuales.

*ATT para cada año:
estat calendar
*ninguno de los coeficientes es significativo

*ATT por grupo:
estat group
*ninguno de los coeficientes es significativo

*visualizamos a simple vista si las tendencias pre tratamiento son paralelas
estat event
csdid_plot
*Observamos que ningún coeficiente es significativo al 10%


*Gráfico de eventos para distintos grupos
csdid_plot, group(2005) name(m1,replace) title("2005")
csdid_plot, group(2006) name(m2,replace) title("2006")
csdid_plot, group(2007) name(m3,replace) title("2007")
csdid_plot, group(2008) name(m4,replace) title("2008")
graph combine m1 m2 m3 m4, xcommon scale(0.8)


//// EJERCICIO 3 ////

///// BACON DECOMPOSITION /////

ssc install bacondecomp

** Bacon Decomposition

xtreg l_burglary post i.year, fe robust

*Request the detailed decomposition of the DD model.
bacondecomp l_burglary post , stub(Bacon_) ddetail


//// EJERCICIO 4 ////
** Wooldridge

* Separate cohort/time treat effects as in Wooldridge (2021):

xi: xtreg l_assault post i.year [aweight=popwt], fe vce(cluster sid)
reg l_assault i.year, vce (cluster sid)

egen psum = sum(post), by(sid)
bysort year : tab psum

* d6 if treated for 6 periods, d5 if treated 5 periods, d4 if treated 4 period, d3 if treated for 3 periods, d2 if treated 2 periods, d1 if treated 1 period
gen d6 = psum == 6
gen d5 = psum == 5
gen d4 = psum == 4
gen d3 = psum == 3
gen d2 = psum == 2
gen d1 = psum == 1


reg l_assault post _Iyear_2010 _Iyear_2001 _Iyear_2002 _Iyear_2003 _Iyear_2004 _Iyear_2005 ///
	_Iyear_2006 _Iyear_2007 _Iyear_2008 _Iyear_2009 d1 d2 d3 d4 d5 d6, vce(cluster sid)

reg l_assault post _Iyear_2010 _Iyear_2001 _Iyear_2002 _Iyear_2003 _Iyear_2004 _Iyear_2005 ///
	_Iyear_2006 _Iyear_2007 _Iyear_2008 _Iyear_2009 _Iyear_2010 d1 d2 d3 d4 d5 d6, vce(cluster sid)

reg l_assault c.post#c._Iyear_2001 c.post#c._Iyear_2002 c.post#c._Iyear_2003 c.post#c._Iyear_2004 ///
	c.post#c._Iyear_2005 c.post#c._Iyear_2006 c.post#c._Iyear_2007 c.post#c._Iyear_2008 c.post#c._Iyear_2009 c.post#c._Iyear_2010 _Iyear_2001 _Iyear_2002 _Iyear_2003 _Iyear_2004 _Iyear_2005 _Iyear_2006 _Iyear_2007 _Iyear_2008 _Iyear_2009 _Iyear_2010 d1 d2 d3 d4 d5 d6, vce(cluster sid)

lincom (c.post#c._Iyear_2006 + c.post#c._Iyear_2007 + c.post#c._Iyear_2008 + c.post#c._Iyear_2009 + c.post#c._Iyear_2010)/6
		
outreg2 using PS9_4.doc, bdec(5) se rdec(5) nocons label replace
