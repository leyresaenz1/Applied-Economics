
/////////////////////////////////////////////
/////////////// PROBLEM SET 7 ///////////////
/////////////////////////////////////////////

clear all
global main "/Users/apple/Desktop/UDESA/Cuarto Año/Segundo Cuatrimestre/Economia Aplicada/TUTORIALES/Tutorial 7"
global output "$main/output"
global input "$main/input"

use "$input/lalondo_exper"

tab moa, gen (moa_) 

egen mean_educ=mean(educ)
egen mean_age=mean(age)
egen mean_black=mean(black)
egen mean_hisp=mean(hisp)
egen mean_marr=mean(marr)
egen mean_nodegree=mean(nodegree)
egen mean_re74=mean(re74)
egen mean_u74=mean(u74)
egen mean_re75=mean(re75)
egen mean_u75=mean(u75)

// INTERACT //

gen educ1=educ-mean_educ
gen educ_t=educ1*t

gen age1=age-mean_age
gen age_t=age1*t

gen black1=black-mean_black
gen black_t=black1*t

gen hisp1=hisp-mean_hisp
gen hisp_t=hisp1*t

gen marr1=marr-mean_marr
gen marr_t=marr1*t

gen nodegree1=nodegree-mean_nodegree
gen nodegree_t=nodegree1*t

gen re74_1=re74-mean_re74
gen re74_t=re74_1*t

gen u74_1=u74-mean_u74
gen u74_t=u74_1*t

gen re75_1=re75-mean_re75
gen re75_t=re75_1*t

gen u75_1=u75-mean_u75
gen u75_t=u75_1*t


reg re78 t educ educ_t age age_t black black_t hisp hisp_t marr marr_t nodegree nodegree_t re74 re74_t u74 u74_t re75 re75_t u75 u75_t moa_1 moa_2 moa_3 moa_4 moa_5 moa_6 moa_7 moa_8 moa_9 moa_10

global covariates "educ age black hisp marr nodegree re74 u74 re75 u75" 
global interac "educ_t age_t black_t hisp_t marr_t nodegree_t re74_t u74_t re75_t u75_t"

/////// PUNTO 1 ////////
*1.	Run the regression using plain standard errors. Keep the coefficients using this command: matrix coeff_1 = e(b)

reg re78 t educ educ_t age age_t black black_t hisp hisp_t marr marr_t nodegree nodegree_t re74 re74_t u74 u74_t re75 re75_t u75 u75_t moa_1 moa_2 moa_3 moa_4 moa_5 moa_6 moa_7 moa_8 moa_9 moa_10

matrix coeff_1 = e(b)

outreg2 using PS7.doc, bdec(5) se rdec(5) ctitle("Plain SE") label replace

/////// PUNTO 2 ////////
*2.	Run the same regression with robust standard errors.

reg re78 t educ educ_t age age_t black black_t hisp hisp_t marr marr_t nodegree nodegree_t re74 re74_t u74 u74_t re75 re75_t u75 u75_t moa_1 moa_2 moa_3 moa_4 moa_5 moa_6 moa_7 moa_8 moa_9 moa_10, robust

matrix coeff_2 = e(b)

outreg2 using PS7.doc, bdec(5) se rdec(5) ctitle("Robust SE") append


/////// PUNTO 3 ////////
*3.	Repeat the procedure clustering the standard errors at moa level. Export the three regresscions. Compare the standard errors and comment. 
reg re78 t educ educ_t age age_t black black_t hisp hisp_t marr marr_t nodegree nodegree_t re74 re74_t u74 u74_t re75 re75_t u75 u75_t i.moa_1 i.moa_2 i.moa_3 i.moa_4 i.moa_5 i.moa_6 i.moa_7 i.moa_8 i.moa_9 i.moa_10 , cluster(moa) robust

outreg2 using PS7.doc, bdec(5) se rdec(5) ctitle("Clustered SE") append


/////// PUNTO 4 ////////

*A

gen v_1 = 1 
save "C:\Users\Magda\Desktop\2021\Eco Aplicada\Tut 7\Tutorial 7\lalonde_exper2", replace

putmata y = re78, replace view
putmata X = (t v_1 educ educ_t age age_t black black_t hisp hisp_t marr marr_t nodegree nodegree_t re74 re74_t u74 u74_t re75 re75_t u75 u75_t), replace view

*B 

/// open mata //

mata 


beta = invsym(X'X)*X'*y
yhat = X*beta

*C GRADOS DE LIBERTAD (FILAS - COLUMNAS)

cols(X)
rows(X)

df = rows(X)-cols(X)
*df=423

*D

ehat = y-yhat

*E STANDARD ERRORS. 

vh = (1/df)*(ehat'ehat)*invsym(X'X)


*F

sebeta = sqrt(diagonal(vh))

*G

tstat = beta:/sebeta

*H

pval = 2*ttail(rows(X)-2, abs(tstat))

*I

// i y ii
M1 = beta, sebeta, tstat, pval

st_matrix("OLS_default", M1)

// iii

column_header = J(4,1,"")

// iv

column_header2 = ("Coefficient" \ "SE" \ "t-stat" \ "p-value")

// v

column_header = column_header, column_header2 

// vi

st_matrixcolstripe("OLS_default", column_header)

// vii

row_labels = J(cols(X), 1, "")

row_labels2 = ("t", tokens(st_global("covariates")), tokens(st_global("interac")), "_cons")
rowlabels = row_labels, row_labels2'
st_matrixrowstripe("OLS_default", rowlabels)

/// END MATA

end

cd "C:\Users\Magda\Desktop\2021\Eco Aplicada\Tut 7\Tutorial 7"
frmttable using table1.doc, statmat(OLS_default)


//////////  PUNTO 5 ////////////

/*X is a nxk matrix and e is a nxs vector of residuals*/

putmata y = re78, replace view
putmata X = (t v_1 educ educ_t age age_t black black_t hisp hisp_t marr marr_t nodegree nodegree_t re74 re74_t u74 u74_t re75 re75_t u75 u75_t), replace view
putmata v_1 = v_1

mata
beta = invsym(X'X)*X'*y
yhat = X*beta
ehat = y-yhat
N=rows(ehat)
k=cols(X)

var_hc1 = (N/(N - k)) * invsym(X'X) * X'*diag(ehat*ehat') * X * invsym(X'X)

sebeta=sqrt(diagonal(var_hc1))
tstat = beta:/sebeta
pval = 2*ttail(rows(X)-2, abs(tstat))


M2 = beta, sebeta, tstat, pval


st_matrix("OLS_default", M2)


column_header = J(4,1,"")
column_header2 = ("Coefficient" \ "SE" \ "t-stat" \ "p-value")
column_header = column_header, column_header2 
st_matrixcolstripe("OLS_default", column_header)


row_labels = J(cols(X), 1, "")
row_labels2 = ("t", tokens(st_global("covariates")), tokens(st_global("interac")), "_cons")
rowlabels = row_labels, row_labels2'
st_matrixrowstripe("OLS_default", rowlabels)

st_matrixcolstripe("OLS_default", column_header)
end

frmttable using tabledos.doc, statmat(OLS_default)

