clear all
set memory 600m
set more off
cd "/Users/kevincao/Desktop/MATH76/Trading Project"

cap log close
cap erase regressions.log
log using regressions.log, replace

use trading.dta, clear

gen ln_eigen = ln(eigencentrality)
gen ln_e_usd = ln(e_usd)
gen ln_interestrate = ln(interestrate)
gen ln_gdpgrowth = ln(gdpgrowth)


xtset countryid year


// regression 1: % change in exchange rate from % change in eigen, interest rate, and gdp growth

// year fixed effects (option but there is some justification --> all countries are affected by global economic fluctuations)

// in spite of null results for ln_eigen, this is good because it debunks modern political argument that american "trade weakness" is weakening our currency
xtreg ln_e_usd ln_eigen ln_interestrate gdpgrowth i.year, fe cluster(countryid) 

// no interest rate 
xtreg ln_e_usd ln_eigen gdpgrowth i.year, fe cluster(countryid)

// wait gdpgrowth is not a part of the UIP model
xtreg ln_e_usd ln_eigen ln_interestrate i.year, fe cluster(countryid)

// 1:1
xtreg ln_e_usd ln_eigen i.year, fe cluster(countryid)



// regression 2: % change in growth <- % change in eigen 

// no controls
xtreg gdpgrowth ln_eigen i.year, fe cluster(countryid)

// exchange rate control
xtreg gdpgrowth ln_eigen ln_e_usd i.year, fe cluster(countryid)

// interest rate control
xtreg gdpgrowth ln_eigen ln_interestrate i.year, fe cluster(countryid)

// all controls
xtreg gdpgrowth ln_eigen ln_e_usd ln_interestrate i.year, fe cluster(countryid)



log close
