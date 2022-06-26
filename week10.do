******************************
*    Applied Econometrics    *
*          PS #10           *
*      Control Sintético     *
******************************

cd "/Users/apple/Desktop/UDESA/Cuarto Año/Segundo Cuatrimestre/Economia Aplicada/TUTORIALES/Tutorial 10"

import delimited "/Users/apple/Desktop/UDESA/Cuarto Año/Segundo Cuatrimestre/Economia Aplicada/TUTORIALES/Tutorial 10/df.csv", encoding(ISO-8859-1) 

save BasePS10, replace

use BasePS10, clear


/// GRÁFICO 1 ///

tsset code year

bys year : egen meanhomiciderates = mean (homiciderates)

twoway (line homiciderates year if code==35) (line meanhomiciderates year, lpattern(dash)), xline(1999, lpattern(shortdash)) ytitle("Homicide Rates") xtitle("Year") legend(label(1 "São Paulo") label(2 "Brazil (average)" )) title("Figure 1") 

/// GRÁFICO 2 ///

synth homiciderates yearsschoolingimp stategdpcapita populationextremepovertyimp giniimp populationprojectionln stategdpgrowthpercent, trunit(35) trperiod(1999) nested fig


/// GRÁFICO 3 ///
sort state year

matrix gaps=e(Y_treated) -e(Y_synthetic)
matrix Y_treated=e(Y_treated)
matrix Y_synthetic=e(Y_synthetic)
svmat gaps
svmat Y_treated
svmat Y_synthetic

twoway (line gaps1 year), xline(1999, lpattern(shortdash)) yline(0, lpattern(dash)) ytitle("Gap in homicide Rates")  xlabel(1990 1995 2000 2005) ylabel(-30 -20 -10 0 10 20 30) title("Figure 3") note("Figure 3: Homicide rates gap between São Paulo and synthetic São Paulo.")


/// GRÁFICO 4 ///
use BasePS10, clear

tempname resmat
tsset code year
        forvalues t = 1994/1999 {
         qui synth homiciderates yearsschoolingimp stategdpcapita populationextremepovertyimp giniimp populationprojectionln stategdpgrowthpercent , trunit(35) trperiod(`t') resultsperiod(1990(1)1998) nested keep(resout`t', replace)		
        }
		
forvalues t = 1994/1999 {
use "C:\Users\Magda\Desktop\2021\Eco Aplicada\Tut 10\Tutorial 10\resout`t'.dta", clear
ren _Y_synthetic _Y_synthetic_`t'
ren _Y_treated _Y_treated_`t'
gen _Y_gap_`t'=_Y_treated_`t'-_Y_synthetic_`t'
save "C:\Users\Magda\Desktop\2021\Eco Aplicada\Tut 10\Tutorial 10\resout`t'.dta", replace
}

use "C:\Users\Magda\Desktop\2021\Eco Aplicada\Tut 10\Tutorial 10\resout1994.dta", clear
forvalues t = 1994/1999 {
merge 1:1 _Co_Number _time using "C:\Users\Magda\Desktop\2021\Eco Aplicada\Tut 10\Tutorial 10\resout`t'.dta", nogen
}

twoway (line _Y_synthetic_1994 _time , lpattern(dash) lcolor(black)) (line _Y_treated_1994 _time , lcolor(black)), xline(1995, lpattern(shortdash)) ytitle("Homicide Rates")  ylabel(0 10 20 30 40 50) title("Figure 4") note("Figure 4: Placebo policy implementation in 1994: São Paulo versus synthetic São Paulo.")
        

//GRÁFICO 5 //
* Leave one out	
use BasePS10, clear
tsset code year 

tempname resmat
        local i 35
        qui synth homiciderates yearsschoolingimp stategdpcapita populationextremepovertyimp giniimp populationprojectionln stategdpgrowthpercent, trunit(`i') trperiod(1999) nested keep(loo-resout`i', replace)	
		
		forvalues j=11/53 {
		if `j'==35 { 
		continue
		}
		use BasePS10, clear
		tsset code year 
		drop if code==`j'
        qui synth homiciderates yearsschoolingimp stategdpcapita populationextremepovertyimp giniimp populationprojectionln stategdpgrowthpercent, trunit(35) trperiod(1999) nested keep(loo-resout`j', replace)	
        }
		
forvalues i = 11/53 {
use "C:\Users\Magda\Desktop\2021\Eco Aplicada\Tut 10\Tutorial 10\loo-resout`i'.dta", clear
ren _Y_synthetic _Y_synthetic_`i'
ren _Y_treated _Y_treated_`i'
gen _Y_gap_`i'=_Y_treated_`i'-_Y_synthetic_`i'
save "C:\Users\Magda\Desktop\2021\Eco Aplicada\Tut 10\Tutorial 10\loo-resout`i'.dta", replace
}

use "C:\Users\Magda\Desktop\2021\Eco Aplicada\Tut 10\Tutorial 10\loo-resout11.dta", clear
forvalues i = 12/53 {
merge 1:1 _Co_Number _time using "C:\Users\Magda\Desktop\2021\Eco Aplicada\Tut 10\Tutorial 10\loo-resout`i'.dta", nogen
}

twoway (line _Y_treated_35 _time, lcolor(black) lwidth(thick)) (line _Y_synthetic_35 _time, lcolor(black) lpattern(dash) lwidth(thick)) (line _Y_synthetic_11 _time, lcolor(gray)) (line _Y_synthetic_12 _time, lcolor(gray)) (line _Y_synthetic_13 _time, lcolor(gray)) (line _Y_synthetic_14 _time, lcolor(gray)) (line _Y_synthetic_15 _time, lcolor(gray)) (line _Y_synthetic_16 _time, lcolor(gray)) (line _Y_synthetic_17 _time, lcolor(gray)) (line _Y_synthetic_18 _time, lcolor(gray)) (line _Y_synthetic_19 _time, lcolor(gray)) (line _Y_synthetic_20 _time, lcolor(gray)) (line _Y_synthetic_21 _time, lcolor(gray)) (line _Y_synthetic_22 _time, lcolor(gray)) (line _Y_synthetic_23 _time, lcolor(gray)) (line _Y_synthetic_24 _time, lcolor(gray)) (line _Y_synthetic_25 _time, lcolor(gray)) (line _Y_synthetic_26 _time, lcolor(gray)) (line _Y_synthetic_27 _time, lcolor(gray)) (line _Y_synthetic_28 _time, lcolor(gray)) (line _Y_synthetic_29 _time, lcolor(gray)) (line _Y_synthetic_30 _time, lcolor(gray)) (line _Y_synthetic_31 _time, lcolor(gray)) (line _Y_synthetic_32 _time, lcolor(gray)) (line _Y_synthetic_33 _time, lcolor(gray)) (line _Y_synthetic_34 _time, lcolor(gray)) (line _Y_synthetic_36 _time, lcolor(gray)) (line _Y_synthetic_37 _time, lcolor(gray)) (line _Y_synthetic_38 _time, lcolor(gray)) (line _Y_synthetic_39 _time, lcolor(gray)) (line _Y_synthetic_40 _time, lcolor(gray)) (line _Y_synthetic_41 _time, lcolor(gray)) (line _Y_synthetic_42 _time, lcolor(gray)) (line _Y_synthetic_43 _time, lcolor(gray)) (line _Y_synthetic_44 _time, lcolor(gray)) (line _Y_synthetic_45 _time, lcolor(gray)) (line _Y_synthetic_46 _time, lcolor(gray)) (line _Y_synthetic_47 _time, lcolor(gray)) (line _Y_synthetic_48 _time, lcolor(gray)) (line _Y_synthetic_49 _time, lcolor(gray)) (line _Y_synthetic_50 _time, lcolor(gray)) (line _Y_synthetic_51 _time, lcolor(gray)) (line _Y_synthetic_52 _time, lcolor(gray)) (line _Y_synthetic_53 _time, lcolor(gray)), xline(1999, lpattern(shortdash)) legend(off) ytitle("Homicide Rates") xtitle("Year") legend(label(1 "São Paulo") label(2 "Synthetic São Paulo" ) label(3 "Synthetic São Paulo (leave-one-out)")) title("Figure 5") xlabel(1990 1995 2000 2005) ylabel(10 20 30 40 50) note("Figure 5: Leave-one-out distribution of the synthetic control for São Paulo.")


//GRÁFICO 6//

use BasePS10, clear
tsset code year 

*35
synth homiciderates yearsschoolingimp stategdpcapita populationextremepovertyimp giniimp populationprojectionln stategdpgrowthpercent, trunit(35) trperiod(1999) nested fig
matrix gaps35=e(Y_treated) -e(Y_synthetic)
svmat gaps35

matrix RMSPE35=e(RMSPE)
svmat RMSPE35



*11
synth homiciderates yearsschoolingimp stategdpcapita populationextremepovertyimp giniimp populationprojectionln stategdpgrowthpercent, trunit(11) trperiod(1999) nested 
matrix gaps11=e(Y_treated) -e(Y_synthetic)
svmat gaps11

matrix RMSPE11=e(RMSPE)
svmat RMSPE11


*12
synth homiciderates yearsschoolingimp stategdpcapita populationextremepovertyimp giniimp populationprojectionln stategdpgrowthpercent, trunit(12) trperiod(1999) nested 
matrix gaps12=e(Y_treated) -e(Y_synthetic)
svmat gaps12

matrix RMSPE12=e(RMSPE)
svmat RMSPE12


*13
synth homiciderates yearsschoolingimp stategdpcapita populationextremepovertyimp giniimp populationprojectionln stategdpgrowthpercent, trunit(13) trperiod(1999) nested 
matrix gaps13=e(Y_treated) -e(Y_synthetic)
svmat gaps13

matrix RMSPE13=e(RMSPE)
svmat RMSPE13


*14
synth homiciderates yearsschoolingimp stategdpcapita populationextremepovertyimp giniimp populationprojectionln stategdpgrowthpercent, trunit(14) trperiod(1999) nested 
matrix gaps14=e(Y_treated) -e(Y_synthetic)
svmat gaps14

matrix RMSPE14=e(RMSPE)
svmat RMSPE14

*15
synth homiciderates yearsschoolingimp stategdpcapita populationextremepovertyimp giniimp populationprojectionln stategdpgrowthpercent, trunit(15) trperiod(1999) nested 
matrix gaps15=e(Y_treated) -e(Y_synthetic)
svmat gaps15

matrix RMSPE15=e(RMSPE)
svmat RMSPE15

*16
synth homiciderates yearsschoolingimp stategdpcapita populationextremepovertyimp giniimp populationprojectionln stategdpgrowthpercent, trunit(16) trperiod(1999) nested 
matrix gaps16=e(Y_treated) -e(Y_synthetic)
svmat gaps16

matrix RMSPE16=e(RMSPE)
svmat RMSPE16

*17
synth homiciderates yearsschoolingimp stategdpcapita populationextremepovertyimp giniimp populationprojectionln stategdpgrowthpercent, trunit(17) trperiod(1999) nested 
matrix gaps17=e(Y_treated) -e(Y_synthetic)
svmat gaps17

matrix RMSPE17=e(RMSPE)
svmat RMSPE17


*21
synth homiciderates yearsschoolingimp stategdpcapita populationextremepovertyimp giniimp populationprojectionln stategdpgrowthpercent, trunit(21) trperiod(1999) nested 
matrix gaps21=e(Y_treated) -e(Y_synthetic)
svmat gaps21

matrix RMSPE21=e(RMSPE)
svmat RMSPE21

*22
synth homiciderates yearsschoolingimp stategdpcapita populationextremepovertyimp giniimp populationprojectionln stategdpgrowthpercent, trunit(22) trperiod(1999) nested 
matrix gaps22=e(Y_treated) -e(Y_synthetic)
svmat gaps22

matrix RMSPE22=e(RMSPE)
svmat RMSPE22

*23
synth homiciderates yearsschoolingimp stategdpcapita populationextremepovertyimp giniimp populationprojectionln stategdpgrowthpercent, trunit(23) trperiod(1999) nested 
matrix gaps23=e(Y_treated) -e(Y_synthetic)
svmat gaps23

matrix RMSPE23=e(RMSPE)
svmat RMSPE23

*24
synth homiciderates yearsschoolingimp stategdpcapita populationextremepovertyimp giniimp populationprojectionln stategdpgrowthpercent, trunit(24) trperiod(1999) nested 
matrix gaps24=e(Y_treated) -e(Y_synthetic)
svmat gaps24

matrix RMSPE24=e(RMSPE)
svmat RMSPE24

*25
synth homiciderates yearsschoolingimp stategdpcapita populationextremepovertyimp giniimp populationprojectionln stategdpgrowthpercent, trunit(25) trperiod(1999) nested 
matrix gaps25=e(Y_treated) -e(Y_synthetic)
svmat gaps25

matrix RMSPE25=e(RMSPE)
svmat RMSPE25

*26
synth homiciderates yearsschoolingimp stategdpcapita populationextremepovertyimp giniimp populationprojectionln stategdpgrowthpercent, trunit(26) trperiod(1999) nested 
matrix gaps26=e(Y_treated) -e(Y_synthetic)
svmat gaps26

matrix RMSPE26=e(RMSPE)
svmat RMSPE26

*27
synth homiciderates yearsschoolingimp stategdpcapita populationextremepovertyimp giniimp populationprojectionln stategdpgrowthpercent, trunit(27) trperiod(1999) nested 
matrix gaps27=e(Y_treated) -e(Y_synthetic)
svmat gaps27

matrix RMSPE27=e(RMSPE)
svmat RMSPE27

*28
synth homiciderates yearsschoolingimp stategdpcapita populationextremepovertyimp giniimp populationprojectionln stategdpgrowthpercent, trunit(28) trperiod(1999) nested 
matrix gaps28=e(Y_treated) -e(Y_synthetic)
svmat gaps28

matrix RMSPE28=e(RMSPE)
svmat RMSPE28

*29
synth homiciderates yearsschoolingimp stategdpcapita populationextremepovertyimp giniimp populationprojectionln stategdpgrowthpercent, trunit(29) trperiod(1999) nested 
matrix gaps29=e(Y_treated) -e(Y_synthetic)
svmat gaps29

matrix RMSPE29=e(RMSPE)
svmat RMSPE29

*30
synth homiciderates yearsschoolingimp stategdpcapita populationextremepovertyimp giniimp populationprojectionln stategdpgrowthpercent, trunit(31) trperiod(1999) nested 
matrix gaps31=e(Y_treated) -e(Y_synthetic)
svmat gaps31

matrix RMSPE31=e(RMSPE)
svmat RMSPE31

*32
synth homiciderates yearsschoolingimp stategdpcapita populationextremepovertyimp giniimp populationprojectionln stategdpgrowthpercent, trunit(32) trperiod(1999) nested 
matrix gaps32=e(Y_treated) -e(Y_synthetic)
svmat gaps32

matrix RMSPE32=e(RMSPE)
svmat RMSPE32

*33
synth homiciderates yearsschoolingimp stategdpcapita populationextremepovertyimp giniimp populationprojectionln stategdpgrowthpercent, trunit(33) trperiod(1999) nested 
matrix gaps33=e(Y_treated) -e(Y_synthetic)
svmat gaps33

matrix RMSPE33=e(RMSPE)
svmat RMSPE33

*41
synth homiciderates yearsschoolingimp stategdpcapita populationextremepovertyimp giniimp populationprojectionln stategdpgrowthpercent, trunit(41) trperiod(1999) nested 
matrix gaps41=e(Y_treated) -e(Y_synthetic)
svmat gaps41

matrix RMSPE41=e(RMSPE)
svmat RMSPE41

*42
synth homiciderates yearsschoolingimp stategdpcapita populationextremepovertyimp giniimp populationprojectionln stategdpgrowthpercent, trunit(42) trperiod(1999) nested 
matrix gaps42=e(Y_treated) -e(Y_synthetic)
svmat gaps42

matrix RMSPE42=e(RMSPE)
svmat RMSPE42

*43
synth homiciderates yearsschoolingimp stategdpcapita populationextremepovertyimp giniimp populationprojectionln stategdpgrowthpercent, trunit(43) trperiod(1999) nested 
matrix gaps43=e(Y_treated) -e(Y_synthetic)
svmat gaps43

matrix RMSPE43=e(RMSPE)
svmat RMSPE43

*50
synth homiciderates yearsschoolingimp stategdpcapita populationextremepovertyimp giniimp populationprojectionln stategdpgrowthpercent, trunit(50) trperiod(1999) nested 
matrix gaps50=e(Y_treated) -e(Y_synthetic)
svmat gaps50

matrix RMSPE50=e(RMSPE)
svmat RMSPE50

*51
synth homiciderates yearsschoolingimp stategdpcapita populationextremepovertyimp giniimp populationprojectionln stategdpgrowthpercent, trunit(51) trperiod(1999) nested 
matrix gaps51=e(Y_treated) -e(Y_synthetic)
svmat gaps51

matrix RMSPE51=e(RMSPE)
svmat RMSPE51

*53
synth homiciderates yearsschoolingimp stategdpcapita populationextremepovertyimp giniimp populationprojectionln stategdpgrowthpercent, trunit(53) trperiod(1999) nested 
matrix gaps53=e(Y_treated) -e(Y_synthetic)
svmat gaps53

matrix RMSPE53=e(RMSPE)
svmat RMSPE53

*GRÁFICO


twoway (line gaps351 year, lcolor(black) lwidth(thick)) (line gaps111 year, lcolor(gs13)) (line gaps121 year, lcolor(gs13)) (line gaps131 year, lcolor(gs13)) (line gaps141 year, lcolor(gs13)) (line gaps151 year, lcolor(gs13)) (line gaps161 year, lcolor(gs13)) (line gaps171 year, lcolor(gs13)) (line gaps211 year, lcolor(gs13)) (line gaps221 year, lcolor(gray)) (line gaps231 year, lcolor(gray)) (line gaps241 year, lcolor(gs13)) (line gaps251 year, lcolor(gs13)) (line gaps261 year, lcolor(gs13)) (line gaps271 year, lcolor(gs13)) (line gaps281 year, lcolor(gs13)) (line gaps291 year, lcolor(gs13)) (line gaps311 year, lcolor(gs13)) (line gaps321 year, lcolor(gs13)) (line gaps331 year, lcolor(gs13)) (line gaps411 year, lcolor(gs13)) (line gaps151 year, lcolor(gs13)) (line gaps161 year, lcolor(gs13)) (line gaps421 year, lcolor(gs13)) (line gaps431 year, lcolor(gs13)) (line gaps501 year, lcolor(gs13)) (line gaps511 year, lcolor(gs13)), xline(1999, lpattern(shortdash)) xlabel(1990 1995 2000 2005) ylabel(-30 -20 -10 0 10 20 30)  ytitle("Gap in Homicide Rates") xtitle("Year") title("Figure 6") note("Figure 6: Permutation test: Homicide rate gaps in São Paulo and twenty-six control states.") legend(off)


///GRÁFICO 7 //
*RMSPE de São Paulo =  2.853773 
*RMSPE utilizados no tiene que ser mayores a 2.853773 *2 

*=5,707546

sum RMSPE* 

drop RMSPE161
drop RMSPE261
drop RMSPE271
drop RMSPE281
drop RMSPE311
drop RMSPE321
drop RMSPE331
drop RMSPE421
drop RMSPE111
drop RMSPE121
drop RMSPE141

twoway (line gaps351 year, lcolor(black) lwidth(thick)) (line gaps131 year, lcolor(gs13)) (line gaps151 year, lcolor(gs13)) (line gaps171 year, lcolor(gs13)) (line gaps211 year, lcolor(gs13)) (line gaps221 year, lcolor(gray)) (line gaps231 year, lcolor(gray)) (line gaps241 year, lcolor(gs13)) (line gaps251 year, lcolor(gs13)) (line gaps291 year, lcolor(gs13)) (line gaps411 year, lcolor(gs13)) (line gaps151 year, lcolor(gs13)) (line gaps161 year, lcolor(gs13)) (line gaps431 year, lcolor(gs13)) (line gaps501 year, lcolor(gs13)) (line gaps511 year, lcolor(gs13)), xline(1999, lpattern(shortdash)) xlabel(1990 1995 2000 2005) ylabel(-30 -20 -10 0 10 20 30 40 50)  ytitle("Gap in Homicide Rates") xtitle("Year") title("Figure 7") note("Figure 7: Permutation test: Homicide rate gaps in São Paulo and twenty-six control states.") legend(off) xlabel(1990 1995 2000 2005) ylabel(-30 -20 -10 0 10 20 30)

graph save "Graph" "C:\Users\Magda\Desktop\2021\Eco Aplicada\Tut 10\Figure 7.gph"




