*Construction of Main Database
*Paper: Incumbency advantage
*Author: Rafael Ch (rafael.ch@nyu.edu)  
*========================================================================
/*NOTES
Merge numbers changed because I added years from 2004 to 2009, and up to 2021
THINK ABOUT THIS
1. should I fill the missing observations for the electoral data?
2. state cross section electoral data from Magar
3. i can include more years for incumbent characteristics data prior to 2009
4. if I should have different leads and lags for electoral estimates (less years) vs. general estimates (more years)
5. if I should erase years in which we have no elections. See when I do drop if ord==.
6. should I erase "drop if incumbent_yesterday_w_tomorrow2==."
*/

*========================================================================
*Environment
clear all
set more off  
set varabbrev off 

*========================================================================
*Working Directory
cd "/Users/rafaeljafetchduran/Dropbox/Dissertation/GovernmentStrategies/incumbency_advantage/Dofiles_incumbency"

*========================================================================
*Create main file: 
**from 2004 onwards to capture all elections that affect 2010 observations. 
foreach y in 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020 2021{
use "../../Data/ConstructionDatabase/Municipality_Codes_UniqueID.dta", clear
gen year=`y'
save "../../Data/ConstructionDatabase/municipalities_id_`y'.dta", replace
}

use "../../Data/ConstructionDatabase/municipalities_id_2004.dta", clear
append using "../../Data/ConstructionDatabase/municipalities_id_2005.dta"
append using "../../Data/ConstructionDatabase/municipalities_id_2006.dta"
append using "../../Data/ConstructionDatabase/municipalities_id_2007.dta"
append using "../../Data/ConstructionDatabase/municipalities_id_2008.dta"
append using "../../Data/ConstructionDatabase/municipalities_id_2009.dta"
append using "../../Data/ConstructionDatabase/municipalities_id_2010.dta"
append using "../../Data/ConstructionDatabase/municipalities_id_2011.dta"
append using "../../Data/ConstructionDatabase/municipalities_id_2012.dta"
append using "../../Data/ConstructionDatabase/municipalities_id_2013.dta"
append using "../../Data/ConstructionDatabase/municipalities_id_2014.dta"
append using "../../Data/ConstructionDatabase/municipalities_id_2015.dta"
append using "../../Data/ConstructionDatabase/municipalities_id_2016.dta"
append using "../../Data/ConstructionDatabase/municipalities_id_2017.dta"
append using "../../Data/ConstructionDatabase/municipalities_id_2018.dta"
append using "../../Data/ConstructionDatabase/municipalities_id_2019.dta"
append using "../../Data/ConstructionDatabase/municipalities_id_2020.dta"
append using "../../Data/ConstructionDatabase/municipalities_id_2021.dta"

rename ENTIDAD estado
rename NOMBRE_ENTIDAD nombre_estado
rename MUNICIPIO municipio
rename NOMBRE_MUNICIPIO nombre_municipio
rename UNIQUE_MUNICIPALITY mun_id

*Main file to append all other files:
save "../../Data_incumbency/municipalities_id_2004_2021.dta", replace

*==========================================================================
*0) add variable labels 
rename mun_id inegi
label variable year "year"
label variable inegi "INEGI identifying code"
label variable estado "State"
label variable nombre_estado "State name"
label variable municipio "municipality (number)"
label variable nombre_municipio "Municipality name"

*==========================================================================
*1) Add elections database
merge 1:1 inegi year using  "../../Data_incumbency/municipal_elections_incumbent_mexico_1989_present_v2.dta"
/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                        41,694
        from master                    31,399  (_merge==1) =  years with no elections
        from using                     10,295  (_merge==2) = elections with no years, that is prior to 2004, and few others missing 

    Matched                            12,647  (_merge==3)
    -----------------------------------------

	*/
drop if _merge==2
rename _merge hadelection
label variable hadelection "Dummy=1 if an election that year; 0 otherwise"

*fill missing observations:
sort inegi year
/*[THINK ABOUT THIS] I didn't include these vars: inc_party_won inc_party_won_tplus1 incumbent_yesterday_w_tomorrow2
*/
foreach i in reform ife raceafter mg winning_margin winning_margin2 numparties_eff numparties numparties_eff_molinar  ///
 mv_incparty mv_incpartyfor1 inc_party_runsfor1 incumbent_yesterday incumbent_today incumbent_tomorrow ///
 incumbent_yesterday_w_today incumbent_today_w_tomorrow incumbent_yesterday_w_tomorrow ///
  firstword alignment_executive_strong win_governor alignment_governor_strong ///
 alignment_governor_weak double_alignment{
by inegi, sort: fillmissing `i', with(previous)
by inegi, sort: fillmissing `i', with(next) // to correct the first value of the series
}

*we end with around 7k missing. All of this correspond to Oaxaca's municipalities that don't have elections. 

save "../../Data_incumbency/municipalities_id_2004_2021_wtreatment.dta", replace

*==========================================================================
*2) ADD COVARIATES
**2.1) Population from CONAPO - IPA team 
preserve
use "/Users/rafaeljafetchduran/Library/CloudStorage/Box-Box/Climate Shocks/07_Questionnaires & Data/06 Additional data/CONAPO/proyecciones_poblacion2015_2030.dta", clear
collapse (sum) poblacion, by(inegi year) 
drop if year>2021
save "../../Data/ConstructionDatabase/pop_conapo_2015_2021.dta", replace
restore 

merge 1:1 inegi year using "../../Data/ConstructionDatabase/pop_conapo_2015_2021.dta"
rename poblacion pop_conapo
/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                        26,987
        from master                    26,917  (_merge==1)  = other years
        from using                         70  (_merge==2) = missing muns

    Matched                            17,129  (_merge==3)
    -----------------------------------------


*/
drop if _merge==2
drop _merge
label variable pop_conapo "Population (CONAPO)"

**2.2) Population from INEGI
preserve 
insheet using "../../Data/ConstructionDatabase/Poblacion/poblacion_muns_inegi_censo_2010.csv", clear
gen year=2010
keep pobl_total pobl_hombres pobl_mujeres inegi year 
rename pobl_total pop_inegi
rename pobl_hombres pop_men_inegi
rename pobl_mujeres pop_women_inegi
label variable pop_inegi "Population (CENSO 2010)"
label variable pop_men_inegi "Men Population (CENSO 2010)"
label variable pop_women_inegi "Women Population (CENSO 2010)"

save "../../Data/ConstructionDatabase/Poblacion/pop_inegi_2010.dta", replace
restore

merge 1:1 inegi year using "../../Data/ConstructionDatabase/Poblacion/pop_inegi_2010.dta"
/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                        41,608
        from master                    41,599  (_merge==1)
        from using                          9  (_merge==2)

    Matched                             2,447  (_merge==3)
    -----------------------------------------
*/
drop if _merge==2 
drop _merge

**2.3) Population from SALUD (FROM CONAPO, from 2011 to 2014)
preserve 
insheet using "../../Data/ConstructionDatabase/Poblacion/Salud/poblacion_municipal_salud_conapo_2010_2014_final.csv", clear
rename population_salud pop_salud
label variable pop_salud "Population (Secretaria de Salud from CONAPO proyections, 2011-2014)"
drop if year==2010
save "../../Data/ConstructionDatabase/Poblacion/pop_salud_2011_2014.dta", replace
restore

merge 1:1 inegi year using "../../Data/ConstructionDatabase/Poblacion/pop_salud_2011_2014.dta"
/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                        34,298
        from master                    34,258  (_merge==1)
        from using                         40  (_merge==2)

    Matched                             9,788  (_merge==3)
    -----------------------------------------


*/
drop if _merge==2 
drop _merge

*save "../../Data/ConstructionDatabase/municipalities_id_2010_2019_whomicideSNSPnew&old_wpop.dta", replace

**2.4) Other covariates from MAIZE to HAZE
preserve
use "../../Data/ConstructionDatabase/Poblacion/MaizeToHaze_JEEA_ReplicationData.dta", clear
keep year state muncode munname natlcornp-pcforest area_cultivated-other_crops_cultivated pop_male pop_female marijuana_value-tot4drugs_value_mex ///
tot4drugs_value_mex armed_personnel_per milexp military_exp_per riosstate-otros rainm6m7_80s rainm6m7_9093 tempm6m7_80s tempm6m7_9093 tempm4m5_80s tempm4m5_9093 rainm tempm
rename muncode inegi
save "../../Data/ConstructionDatabase/Covariates/cov_1990_2010.dta", replace
restore 

merge 1:1 inegi year using "../../Data/ConstructionDatabase/Covariates/cov_1990_2010.dta"
drop if _merge==2
drop _merge

*Fix covariates
foreach i in areakm2{
replace `i'=`i'[_n-1] if `i'==.
}

*save "../../Data/ConstructionDatabase/municipalities_id_2010_2019_whomicideSNSPnew_old_wcovariates_v1.dta", replace

**2.5 luminosity 
preserve 
insheet using "/Users/rafaeljafetchduran/Dropbox/narcodespensas/gis_data/LightData/muns_light_2000_2020_final_cleaned.csv", clear
keep inegi mean_* std_*
reshape long mean_ std_, i(inegi) j (year)
rename mean_ light_mean
rename std_ light_std
save "../../Data/ConstructionDatabase/light_2000_2020.dta", replace
restore 

merge m:m inegi year using "../../Data/ConstructionDatabase/light_2000_2020.dta"
drop if _merge==2
drop _merge

label variable light_mean "Luminosity average"
label variable light_std "Luminosity std. deviation"

/**2.6) State-level electoral dynamics from Magar [THINK ABOUT THIS]

merge m:m  nombre_estado using "../../Data/state_elections_mexico_winning_margin.dta"
drop if _merge==2
drop _merge
*/

**2.7) Mayor characteristics
merge m:m inegi year using "../../Data/ConstructionDatabase/SNIM/TransformationsUpdate2021/presidentes_municipales_historico_winegi_final.dta"
drop if _merge==2 /*Loose some observations from Coahuila and Tabasco of 2009 */
tab emm if _merge==1 /*don't have info of yucatan 2010, and the others are spurious municipalities. 172 observations lost */
*[THINK ABOUT THIS]: I CAN INCLUDE MORE YEARS BEFORE 2009
drop _merge

label variable sexo "Incumbent's gender'"
label variable partido_from_snim "Incumbent party (SNIM)"
label variable presidentemunicipal "Incumbent's name (SNIM)"
label variable title "Incumbent's professional title (SNIM)"

quietly bysort inegi year:  gen dup = cond(_N==1,0,_n)
drop if dup>1
drop dup

**2.8) egresos e ingresos
foreach i in predial seguridad_ingresos seguridad_egresos desarrollo_social_egresos obras_egresos remuneraciones_egresos ingresos impuestos patrimonio produccion tenencia carros{
merge m:m inegi year using "../../Data/ConstructionDatabase/Transferencias/Stata/`i'_2000_2021.dta"
drop if _merge==2
drop _merge
}

**2.9) ingresos not tied to municipal effort
foreach i in  participables participaciones fomento aportaciones fa_infra fa_fortalecer{
merge m:m inegi year using "../../Data/ConstructionDatabase/Transferencias/Stata/`i'_2000_2021.dta"
drop if _merge==2
drop _merge
}

**SAVE DATABASE
drop if year<2010 //erase years prior to 2010 since are not useful for estimations later on
save "../../Data_incumbency/municipalities_id_2010_2021_v1.dta", replace
 
******************
*TRANSFORMATIONS
******************
use "../../Data_incumbency/municipalities_id_2010_2021_v1.dta", clear

*A.1) COVARIATES
*generate population for all years
*ssc install carryforward
/*foreach i in pop_inegi{
*bysort countryname: egen mean`i'=mean(`i') if year<1990 & year>=1975
bysort inegi: carryforward `i', replace 
}
*/

gen pop=.

replace pop=pop_inegi if year==2010
replace pop=pop_salud if year>2010
replace pop=pop_conapo if year>=2015


*A.2) ALTERNATIVE OUTCOMES
***a) adverse selection
sort inegi year
foreach i in title{
by inegi, sort: fillmissing `i', with(previous)
}
encode title, gen(title_num)
gen incumbent_quality=1
replace incumbent_quality=0 if title_num==5
replace incumbent_quality=. if title_num==1
replace incumbent_quality=. if title_num==.

save "../../Data_incumbency/municipalities_id_2010_2021_v2.dta", replace
  
*C) EVENT-STUDY LEADS, LAGS AND CONTROLS
use "../../Data_incumbency/municipalities_id_2010_2021_v2.dta", clear

*C.1) lead and lags:
*Create adoption year variable:
preserve
collapse (mean)reform (firstnm)nombre_estado, by(estado year)
replace reform=1 if reform>0
xtset estado year
gen adopt=.
replace adopt=1 if reform>0 & l.reform==0
replace adopt=0 if adopt==.
gen adopt_year=year if adopt==1 //the non-treated states do not have leads or lags. 

save "../../Data/ConstructionDatabase/adopt_year.dta", replace
restore

merge m:m estado year using "../../Data/ConstructionDatabase/adopt_year.dta"
drop _merge
xtset inegi year
*net from https://www.sealedenvelope.com/
xfill adopt_year, i(inegi) // fill all but Hidalgo and Veracruz


*Two options: (A) for electoral estimates and (B) for general estimates:

*(A) FOR ELECTORAL ESTIMATES
preserve 
*[THINK ABOUT THIS]
restore

*(B) FOR GENERAL ESTIMATES

*Create lead/lag indicators
order year adopt_year
gen rel_year=year-adopt_year
order year adopt_year rel_year

*turn lead/lags to indicator variables
tab rel_year, gen(rel_year_) 
order year adopt_year rel_year rel_year_*

rename rel_year_1 lag_11
rename rel_year_2 lag_10
rename rel_year_3 lag_9
rename rel_year_4 lag_8
rename rel_year_5 lag_7
rename rel_year_6 lag_6
rename rel_year_7 lag_5
rename rel_year_8 lag_4
rename rel_year_9 lag_3
rename rel_year_10 lag_2 // only one municipality 
rename rel_year_11 lag_1 // only one municipality 
rename rel_year_12 date_0
rename rel_year_13 lead_1
rename rel_year_14 lead_2
rename rel_year_15 lead_3
rename rel_year_16 lead_4
rename rel_year_17 lead_5
rename rel_year_18 lead_6


*D) EVENT-STUDY LEADS, ABRAHAM AND SUN (2020) FULL SATURATED MODEL
**FOR INCUMBENCY ESTIMATES:
gen whichlead="" 
replace whichlead="lag_11" if lag_11==1
replace whichlead="lag_10" if lag_10==1
replace whichlead="lag_9" if lag_9==1
replace whichlead="lag_8" if lag_8==1
replace whichlead="lag_7" if lag_7==1
replace whichlead="lag_6" if lag_6==1
replace whichlead="lag_5" if lag_5==1
replace whichlead="lag_4" if lag_4==1
replace whichlead="lag_3" if lag_3==1
replace whichlead="lag_2" if lag_2==1
*replace whichlead="lag_1" if lag_1==1
replace whichlead="date_0" if date_0==1
replace whichlead="lead_1" if lead_1==1
replace whichlead="lead_2" if lead_2==1
replace whichlead="lead_3" if lead_3==1
replace whichlead="lead_4" if lead_4==1
replace whichlead="lead_5" if lead_5==1
replace whichlead="lead_6" if lead_6==1
encode whichlead, gen(whichlead_num)

gen whichlead2="" 
replace whichlead2="lag_11" if lag_11==1
replace whichlead2="lag_10" if lag_10==1
replace whichlead2="lag_9" if lag_9==1
replace whichlead2="lag_8" if lag_8==1
replace whichlead2="lag_7" if lag_7==1
replace whichlead2="lag_6" if lag_6==1
replace whichlead2="lag_5" if lag_5==1
replace whichlead2="lag_4" if lag_4==1
replace whichlead2="lag_3" if lag_3==1
replace whichlead2="lag_2" if lag_2==1
replace whichlead2="lag_1" if lag_1==1
*replace whichlead2="date_0" if date_0==1
replace whichlead2="lead_1" if lead_1==1
replace whichlead2="lead_2" if lead_2==1
replace whichlead2="lead_3" if lead_3==1
replace whichlead2="lead_4" if lead_4==1
replace whichlead2="lead_5" if lead_5==1
replace whichlead2="lead_6" if lead_6==1
encode whichlead2, gen(whichlead2_num)

**erase years in which we have no elections:
keep if ord!=. // [THINK ABOUT THIS]

drop if incumbent_yesterday_w_tomorrow2==. // [THINK ABOUT THIS] I could change this prior to constructing the leads and lags. 
save "../../Data/ConstructionDatabase/data_wleads&lags_incumbency.dta", replace


****************************************************
* Weights for Abraham and Sun (2020) specification, FOR INCUMBENCY ADVANTAGE ESTIMATES;
**************************************************** 
use "../../Data/ConstructionDatabase/data_wleads&lags_incumbency.dta", replace

preserve
**c) get counts; recall that four states don't have lead and lags (the non-treated)
foreach i in adopt_year{
***c.1) Get n: n is the count of observations by adoption year and lead/lag:
****group observations by adoption year and type of lead/lag
order `i' whichlead
egen group_`i'_leadlag=group(`i' whichlead)
****count the number of times each group appears
bysort group_`i'_leadlag: egen n=count(group_`i'_leadlag)
***c.2) Get percentage: n / total
****group observations by type of lead/lag
egen group_leadlag=group(whichlead)
****
bysort group_leadlag: egen total=count(n) //total is the total number of leads/lags in the effective sample 
bysort group_leadlag: gen perc= n/total
keep whichlead `i' perc
drop if whichlead==""
sort whichlead `i'
collapse (mean)perc, by(`i' whichlead)
order whichlead `i' perc
sort whichlead `i' perc

**d) make variable name to merge in for indicators; we want only the effective indicators that we need for estimation
 tostring `i', generate(`i'_s)
gen indic=whichlead+"_"+`i'_s

save "../../Data/ConstructionDatabase/weights_incumbency.dta", replace
restore

*rename _merge _mergeold
merge m:m whichlead `i' using "../../Data/ConstructionDatabase/weights_incumbency.dta" //we do not merge the lag_8 and lag_1
/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                           802
        from master                       802  (_merge==1) // not merge Hidalgo and Veracruz
        from using                          0  (_merge==2)

    Matched                             5,794  (_merge==3)
    -----------------------------------------

*/


gen indic_name = strtoname(indic)
}

levelsof indic_name, local(names)
foreach n of local names {
    gen byte `n' = (indic_name == "`n'")
}

save "../../Data/ConstructionDatabase/data_wleads&lags_incumbency_weights.dta", replace


/*REMOVING DATE_0 // [THINK ABOUT THIS] I HAVE MISTAKES
preserve
**c) get counts; recall that four states don't have lead and lags (the non-treated)
foreach i in adopt_year{
***c.1) Get n: n is the count of observations by adoption year and lead/lag:
****group observations by adoption year and type of lead/lag
order `i' whichlead2
egen group_`i'_leadlag2=group(`i' whichlead2)
****count the number of times each group appears
bysort group_`i'_leadlag2: egen n2=count(group_`i'_leadlag2)

***c.2) Get percentage: n / total
****group observations by type of lead/lag
egen group_leadlag2=group(whichlead2)
****
bysort group_leadlag2: egen total2=count(n2) //total is the total number of leads/lags in the effective sample 
bysort group_leadlag2: gen perc2= n2/total2
keep whichlead2 `i' perc2
drop if whichlead2==""
sort whichlead2 `i'
collapse (mean)perc2, by(`i' whichlead2)
order whichlead2 `i' perc2
sort whichlead2 `i' perc2

**d) make variable name to merge in for indicators; we want only the effective indicators that we need for estimation
 tostring `i', generate(`i'_s2)
gen indic2=whichlead2+"_"+`i'_s2

save "../../Data/ConstructionDatabase/weights2_incumbency.dta", replace
restore

rename _merge _mergeold2
merge m:m whichlead2 `i' using "../../Data/ConstructionDatabase/weights2_incumbency.dta" //we do not merge the lag_8 and lag_1
* A LOT OF NON MATCHES, AROUND 2K
gen indic_name2 = strtoname(indic2)
}


levelsof indic_name, local(names)
foreach n of local names {
    gen byte `n' = (indic_name == "`n'")
}


replace indic_name2="" if indic_name2!="lag_1_2015" & indic_name2!="lag_1_2016" & indic_name2!="lag_1_2017" & indic_name2!="lag_1_2018"

levelsof indic_name2, local(names2)
foreach n of local names2 {
    gen byte `n' = (indic_name2 == "`n'")
}

save "../../Data/ConstructionDatabase/data_wleads&lags_incumbency_weights.dta", replace
*/

****************************************************
* For R
****************************************************
clear all
use "../../Data_incumbency/municipalities_id_2010_2021_v2.dta", clear

*use "../../Data/ConstructionDatabase/municipalities_id_2010_2019_whomicideSNSPnew_old_wcovariates_v2.dta", clear

collapse (mean) incumbent_yesterday_w_tomorrow2 mv_incpartyfor1 ord reform (firstnm)nombre_estado, by(estado year)
*drop if year>2018
drop if ord==.
drop ord
replace incumbent_yesterday_w_tomorrow2=1 if incumbent_yesterday_w_tomorrow2>0
replace reform=1 if reform>0
rename estado estado_num
rename nombre_estado state
  
save "../../Data/ConstructionDatabase/collapseddata_incumbency_forR.dta", replace
 




