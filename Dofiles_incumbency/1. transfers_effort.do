*Transfers cleaning and processing
*Paper: Incumbency advantage
*Author: Rafael Ch (rafael.ch@nyu.edu)  
*****************************************************

clear all
set more off  
set varabbrev off 

*Working Directory
cd "/Users/rafaeljafetchduran/Dropbox/Dissertation/GovernmentStrategies/incumbency_advantage/Dofiles_incumbency"
/*Source:
https://www.inegi.org.mx/programas/finanzas/#Datos_abiertos
*/
*========================================================================
*Impuesto predial: effort to increase state capacity
foreach i in 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020{
insheet using "../../Data/ConstructionDatabase/Transferencias/efipem_municipal_csv/conjunto_de_datos/efipem_municipal_anual_tr_cifra_`i'.csv", clear
rename anio year
tostring id_entidad, replace
tostring id_municipio, replace
gen digits=strlen(id_municipio)
gen inegi = id_entidad + "00" + id_municipio if digits==1
replace inegi = id_entidad + "0" + id_municipio if digits==2
replace inegi = id_entidad + id_municipio if digits==3
destring inegi, replace
keep if descripcion_categoria=="Impuesto predial" 
*keep if descripcion_categoria=="Seguridad pública"  
rename valor impuesto_predial
keep inegi year impuesto_predial 
save "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_`i'.dta", replace
}
*merge
use "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2000.dta", clear
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2001.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2002.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2003.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2004.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2005.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2006.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2007.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2008.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2009.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2010.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2011.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2012.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2013.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2014.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2015.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2016.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2017.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2018.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2019.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2020.dta"
*append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2021.dta"
order inegi year 
sort inegi year
*deflactar
preserve
insheet using "../../Data/ConstructionDatabase/Transferencias/deflator_WB/deflator_mexico_updated_2021.csv", clear
save "../../Data/ConstructionDatabase/Transferencias/Stata/deflator_mexico.dta", replace
restore
merge m:m year using "../../Data/ConstructionDatabase/Transferencias/Stata/deflator_mexico.dta"
drop _merge
gen impuesto_predial2=(impuesto_predial/deflator)*100
order inegi year 
sort inegi year
save "../../Data/ConstructionDatabase/Transferencias/Stata/predial_2000_2020.dta", replace

*========================================================================
*Public Security: Egresos
foreach i in 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020{
insheet using "../../Data/ConstructionDatabase/Transferencias/efipem_municipal_csv/conjunto_de_datos/efipem_municipal_anual_tr_cifra_`i'.csv", clear
rename anio year
tostring id_entidad, replace
tostring id_municipio, replace
gen digits=strlen(id_municipio)
gen inegi = id_entidad + "00" + id_municipio if digits==1
replace inegi = id_entidad + "0" + id_municipio if digits==2
replace inegi = id_entidad + id_municipio if digits==3
destring inegi, replace
replace descripcion_categoria="Seguridad pública" if descripcion_categoria=="Seguridad pública y tránsito"
keep if descripcion_categoria=="Seguridad pública"  & tema=="Egresos" 
collapse (sum) valor, by(inegi year)
rename valor seguridad_egr
keep inegi year seguridad_egr 
save "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_`i'.dta", replace
}
*merge
use "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2000.dta", clear
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2001.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2002.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2003.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2004.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2005.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2006.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2007.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2008.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2009.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2010.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2011.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2012.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2013.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2014.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2015.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2016.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2017.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2018.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2019.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2020.dta"
*append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2021.dta"
order inegi year 
sort inegi year
*deflactar
preserve
insheet using "../../Data/ConstructionDatabase/Transferencias/deflator_WB/deflator_mexico_updated_2021.csv", clear
save "../../Data/ConstructionDatabase/Transferencias/Stata/deflator_mexico.dta", replace
restore
merge m:m year using "../../Data/ConstructionDatabase/Transferencias/Stata/deflator_mexico.dta"
drop _merge
gen seguridad_egr2=(seguridad_egr/(100+deflator))*100
order inegi year 
sort inegi year
save "../../Data/ConstructionDatabase/Transferencias/Stata/seguridad_ingresos_2000_2020.dta", replace

*========================================================================
*Public Security: Ingresos
foreach i in 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020{
insheet using "../../Data/ConstructionDatabase/Transferencias/efipem_municipal_csv/conjunto_de_datos/efipem_municipal_anual_tr_cifra_`i'.csv", clear
rename anio year
tostring id_entidad, replace
tostring id_municipio, replace
gen digits=strlen(id_municipio)
gen inegi = id_entidad + "00" + id_municipio if digits==1
replace inegi = id_entidad + "0" + id_municipio if digits==2
replace inegi = id_entidad + id_municipio if digits==3
destring inegi, replace
replace descripcion_categoria="Seguridad pública" if descripcion_categoria=="Seguridad pública y tránsito"
keep if descripcion_categoria=="Seguridad pública"  & tema=="Ingresos" 
collapse (sum) valor, by(inegi year)
rename valor seguridad_ing
keep inegi year seguridad_ing 
save "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_`i'.dta", replace
}
*merge
use "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2000.dta", clear
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2001.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2002.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2003.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2004.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2005.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2006.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2007.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2008.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2009.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2010.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2011.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2012.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2013.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2014.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2015.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2016.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2017.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2018.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2019.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2020.dta"
*append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2021.dta"
order inegi year 
sort inegi year
*deflactar
preserve
insheet using "../../Data/ConstructionDatabase/Transferencias/deflator_WB/deflator_mexico_updated_2021.csv", clear
save "../../Data/ConstructionDatabase/Transferencias/Stata/deflator_mexico.dta", replace
restore
merge m:m year using "../../Data/ConstructionDatabase/Transferencias/Stata/deflator_mexico.dta"
drop _merge
gen seguridad_ing2=(seguridad_ing/(100+deflator))*100
order inegi year 
sort inegi year
save "../../Data/ConstructionDatabase/Transferencias/Stata/seguridad_egresos_2000_2020.dta", replace

*========================================================================
*Desarrollo Social: Egresos
foreach i in 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020{
insheet using "../../Data/ConstructionDatabase/Transferencias/efipem_municipal_csv/conjunto_de_datos/efipem_municipal_anual_tr_cifra_`i'.csv", clear
rename anio year
tostring id_entidad, replace
tostring id_municipio, replace
gen digits=strlen(id_municipio)
gen inegi = id_entidad + "00" + id_municipio if digits==1
replace inegi = id_entidad + "0" + id_municipio if digits==2
replace inegi = id_entidad + id_municipio if digits==3
destring inegi, replace
keep if descripcion_categoria=="Desarrollo social"  & tema=="Egresos" 
rename valor desarrollo_soc_egr
keep inegi year desarrollo_soc_egr 
save "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_`i'.dta", replace
}
*merge
use "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2000.dta", clear
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2001.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2002.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2003.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2004.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2005.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2006.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2007.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2008.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2009.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2010.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2011.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2012.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2013.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2014.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2015.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2016.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2017.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2018.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2019.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2020.dta"
*append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2021.dta"
order inegi year 
sort inegi year
*deflactar
preserve
insheet using "../../Data/ConstructionDatabase/Transferencias/deflator_WB/deflator_mexico_updated_2021.csv", clear
save "../../Data/ConstructionDatabase/Transferencias/Stata/deflator_mexico.dta", replace
restore
merge m:m year using "../../Data/ConstructionDatabase/Transferencias/Stata/deflator_mexico.dta"
drop _merge
gen desarrollo_soc_egr2=(desarrollo_soc_egr/(100+deflator))*100
order inegi year 
sort inegi year
save "../../Data/ConstructionDatabase/Transferencias/Stata/desarrollo_social_egresos_2000_2020.dta", replace

*========================================================================
*Obras Publicas: Egresos
foreach i in 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020{
insheet using "../../Data/ConstructionDatabase/Transferencias/efipem_municipal_csv/conjunto_de_datos/efipem_municipal_anual_tr_cifra_`i'.csv", clear
rename anio year
tostring id_entidad, replace
tostring id_municipio, replace
gen digits=strlen(id_municipio)
gen inegi = id_entidad + "00" + id_municipio if digits==1
replace inegi = id_entidad + "0" + id_municipio if digits==2
replace inegi = id_entidad + id_municipio if digits==3
destring inegi, replace
keep if descripcion_categoria=="Obras públicas"  & tema=="Egresos" 
rename valor obras_egr
keep inegi year obras_egr 
save "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_`i'.dta", replace
}
*merge
use "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2000.dta", clear
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2001.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2002.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2003.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2004.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2005.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2006.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2007.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2008.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2009.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2010.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2011.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2012.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2013.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2014.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2015.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2016.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2017.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2018.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2019.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2020.dta"
*append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2021.dta"
order inegi year 
sort inegi year
*deflactar
preserve
insheet using "../../Data/ConstructionDatabase/Transferencias/deflator_WB/deflator_mexico_updated_2021.csv", clear
save "../../Data/ConstructionDatabase/Transferencias/Stata/deflator_mexico.dta", replace
restore
merge m:m year using "../../Data/ConstructionDatabase/Transferencias/Stata/deflator_mexico.dta"
drop _merge
gen obras_egr2=(obras_egr/(100+deflator))*100
order inegi year 
sort inegi year
save "../../Data/ConstructionDatabase/Transferencias/Stata/obras_egresos_2000_2020.dta", replace

*========================================================================
*Remuneraciones: Egresos
foreach i in 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020{
insheet using "../../Data/ConstructionDatabase/Transferencias/efipem_municipal_csv/conjunto_de_datos/efipem_municipal_anual_tr_cifra_`i'.csv", clear
rename anio year
tostring id_entidad, replace
tostring id_municipio, replace
gen digits=strlen(id_municipio)
gen inegi = id_entidad + "00" + id_municipio if digits==1
replace inegi = id_entidad + "0" + id_municipio if digits==2
replace inegi = id_entidad + id_municipio if digits==3
destring inegi, replace
keep if descripcion_categoria=="Remuneraciones al personal"  & tema=="Egresos" 
rename valor remun_egr
keep inegi year remun_egr 
save "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_`i'.dta", replace
}
*merge
use "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2000.dta", clear
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2001.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2002.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2003.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2004.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2005.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2006.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2007.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2008.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2009.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2010.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2011.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2012.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2013.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2014.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2015.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2016.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2017.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2018.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2019.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2020.dta"
*append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2021.dta"
order inegi year 
sort inegi year
*deflactar
preserve
insheet using "../../Data/ConstructionDatabase/Transferencias/deflator_WB/deflator_mexico_updated_2021.csv", clear
save "../../Data/ConstructionDatabase/Transferencias/Stata/deflator_mexico.dta", replace
restore
merge m:m year using "../../Data/ConstructionDatabase/Transferencias/Stata/deflator_mexico.dta"
drop _merge
gen remun_egr2=(remun_egr/(100+deflator))*100
order inegi year 
sort inegi year
save "../../Data/ConstructionDatabase/Transferencias/Stata/remuneraciones_egresos_2000_2020.dta", replace

*========================================================================
*Ingresos
foreach i in 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020{
insheet using "../../Data/ConstructionDatabase/Transferencias/efipem_municipal_csv/conjunto_de_datos/efipem_municipal_anual_tr_cifra_`i'.csv", clear
rename anio year
tostring id_entidad, replace
tostring id_municipio, replace
gen digits=strlen(id_municipio)
gen inegi = id_entidad + "00" + id_municipio if digits==1
replace inegi = id_entidad + "0" + id_municipio if digits==2
replace inegi = id_entidad + id_municipio if digits==3
destring inegi, replace
keep if descripcion_categoria=="Total de ingresos" 
rename valor ingresos
keep inegi year ingresos 
save "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_`i'.dta", replace
}
*merge
use "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2000.dta", clear
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2001.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2002.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2003.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2004.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2005.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2006.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2007.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2008.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2009.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2010.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2011.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2012.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2013.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2014.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2015.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2016.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2017.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2018.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2019.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2020.dta"
*append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2021.dta"
order inegi year 
sort inegi year
*deflactar
preserve
insheet using "../../Data/ConstructionDatabase/Transferencias/deflator_WB/deflator_mexico_updated_2021.csv", clear
save "../../Data/ConstructionDatabase/Transferencias/Stata/deflator_mexico.dta", replace
restore
merge m:m year using "../../Data/ConstructionDatabase/Transferencias/Stata/deflator_mexico.dta"
drop _merge
gen ingresos2=(ingresos/(100+deflator))*100
order inegi year 
sort inegi year
save "../../Data/ConstructionDatabase/Transferencias/Stata/ingresos_2000_2020.dta", replace

*========================================================================
*Impuestos
foreach i in 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020{
insheet using "../../Data/ConstructionDatabase/Transferencias/efipem_municipal_csv/conjunto_de_datos/efipem_municipal_anual_tr_cifra_`i'.csv", clear
rename anio year
tostring id_entidad, replace
tostring id_municipio, replace
gen digits=strlen(id_municipio)
gen inegi = id_entidad + "00" + id_municipio if digits==1
replace inegi = id_entidad + "0" + id_municipio if digits==2
replace inegi = id_entidad + id_municipio if digits==3
destring inegi, replace
keep if descripcion_categoria=="Impuestos" 
rename valor impuestos
keep inegi year impuestos 
save "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_`i'.dta", replace
}
*merge
use "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2000.dta", clear
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2001.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2002.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2003.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2004.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2005.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2006.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2007.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2008.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2009.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2010.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2011.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2012.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2013.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2014.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2015.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2016.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2017.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2018.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2019.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2020.dta"
*append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2021.dta"
order inegi year 
sort inegi year
*deflactar
preserve
insheet using "../../Data/ConstructionDatabase/Transferencias/deflator_WB/deflator_mexico_updated_2021.csv", clear
save "../../Data/ConstructionDatabase/Transferencias/Stata/deflator_mexico.dta", replace
restore
merge m:m year using "../../Data/ConstructionDatabase/Transferencias/Stata/deflator_mexico.dta"
drop _merge
gen impuestos2=(impuestos/(100+deflator))*100
order inegi year 
sort inegi year
save "../../Data/ConstructionDatabase/Transferencias/Stata/impuestos_2000_2020.dta", replace

*========================================================================
*Impuestos sobre el Patrimonio
foreach i in 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020{
insheet using "../../Data/ConstructionDatabase/Transferencias/efipem_municipal_csv/conjunto_de_datos/efipem_municipal_anual_tr_cifra_`i'.csv", clear
rename anio year
tostring id_entidad, replace
tostring id_municipio, replace
gen digits=strlen(id_municipio)
gen inegi = id_entidad + "00" + id_municipio if digits==1
replace inegi = id_entidad + "0" + id_municipio if digits==2
replace inegi = id_entidad + id_municipio if digits==3
destring inegi, replace
keep if descripcion_categoria=="Impuestos sobre el Patrimonio" 
rename valor patrimonio
keep inegi year patrimonio 
save "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_`i'.dta", replace
}
*merge
use "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2000.dta", clear
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2001.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2002.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2003.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2004.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2005.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2006.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2007.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2008.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2009.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2010.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2011.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2012.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2013.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2014.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2015.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2016.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2017.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2018.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2019.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2020.dta"
*append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2021.dta"
order inegi year 
sort inegi year
*deflactar
preserve
insheet using "../../Data/ConstructionDatabase/Transferencias/deflator_WB/deflator_mexico_updated_2021.csv", clear
save "../../Data/ConstructionDatabase/Transferencias/Stata/deflator_mexico.dta", replace
restore
merge m:m year using "../../Data/ConstructionDatabase/Transferencias/Stata/deflator_mexico.dta"
drop _merge
gen patrimonio2=(patrimonio/(100+deflator))*100
order inegi year 
sort inegi year
save "../../Data/ConstructionDatabase/Transferencias/Stata/patrimonio_2000_2020.dta", replace

*========================================================================
*Impuesto sobre la producción, el consumo y las transacciones
foreach i in 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020{
insheet using "../../Data/ConstructionDatabase/Transferencias/efipem_municipal_csv/conjunto_de_datos/efipem_municipal_anual_tr_cifra_`i'.csv", clear
rename anio year
tostring id_entidad, replace
tostring id_municipio, replace
gen digits=strlen(id_municipio)
gen inegi = id_entidad + "00" + id_municipio if digits==1
replace inegi = id_entidad + "0" + id_municipio if digits==2
replace inegi = id_entidad + id_municipio if digits==3
destring inegi, replace
keep if descripcion_categoria=="Impuesto sobre la producción, el consumo y las transacciones" 
rename valor produccion
keep inegi year produccion 
save "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_`i'.dta", replace
}
*merge
use "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2000.dta", clear
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2001.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2002.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2003.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2004.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2005.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2006.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2007.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2008.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2009.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2010.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2011.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2012.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2013.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2014.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2015.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2016.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2017.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2018.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2019.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2020.dta"
*append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2021.dta"
order inegi year 
sort inegi year
*deflactar
preserve
insheet using "../../Data/ConstructionDatabase/Transferencias/deflator_WB/deflator_mexico_updated_2021.csv", clear
save "../../Data/ConstructionDatabase/Transferencias/Stata/deflator_mexico.dta", replace
restore
merge m:m year using "../../Data/ConstructionDatabase/Transferencias/Stata/deflator_mexico.dta"
drop _merge
gen produccion2=(produccion/(100+deflator))*100
order inegi year 
sort inegi year
save "../../Data/ConstructionDatabase/Transferencias/Stata/produccion_2000_2020.dta", replace

*========================================================================
*Impuesto sobre Tenencia o Uso de Vehículoss
foreach i in 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020{
insheet using "../../Data/ConstructionDatabase/Transferencias/efipem_municipal_csv/conjunto_de_datos/efipem_municipal_anual_tr_cifra_`i'.csv", clear
rename anio year
tostring id_entidad, replace
tostring id_municipio, replace
gen digits=strlen(id_municipio)
gen inegi = id_entidad + "00" + id_municipio if digits==1
replace inegi = id_entidad + "0" + id_municipio if digits==2
replace inegi = id_entidad + id_municipio if digits==3
destring inegi, replace
keep if descripcion_categoria=="Impuesto sobre Tenencia o Uso de Vehículos" 
rename valor tenencia
keep inegi year tenencia 
save "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_`i'.dta", replace
}
*merge
use "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2000.dta", clear
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2001.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2002.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2003.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2004.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2005.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2006.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2007.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2008.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2009.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2010.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2011.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2012.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2013.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2014.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2015.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2016.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2017.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2018.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2019.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2020.dta"
*append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2021.dta"
order inegi year 
sort inegi year
*deflactar
preserve
insheet using "../../Data/ConstructionDatabase/Transferencias/deflator_WB/deflator_mexico_updated_2021.csv", clear
save "../../Data/ConstructionDatabase/Transferencias/Stata/deflator_mexico.dta", replace
restore
merge m:m year using "../../Data/ConstructionDatabase/Transferencias/Stata/deflator_mexico.dta"
drop _merge
gen tenencia2=(tenencia/(100+deflator))*100
order inegi year 
sort inegi year
save "../../Data/ConstructionDatabase/Transferencias/Stata/tenencia_2000_2020.dta", replace

*========================================================================
*Impuesto sobre Automóviles Nuevos
foreach i in 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020{
insheet using "../../Data/ConstructionDatabase/Transferencias/efipem_municipal_csv/conjunto_de_datos/efipem_municipal_anual_tr_cifra_`i'.csv", clear
rename anio year
tostring id_entidad, replace
tostring id_municipio, replace
gen digits=strlen(id_municipio)
gen inegi = id_entidad + "00" + id_municipio if digits==1
replace inegi = id_entidad + "0" + id_municipio if digits==2
replace inegi = id_entidad + id_municipio if digits==3
destring inegi, replace
keep if descripcion_categoria=="Impuesto sobre Automóviles Nuevos" 
rename valor carros
keep inegi year carros 
save "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_`i'.dta", replace
}
*merge
use "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2000.dta", clear
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2001.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2002.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2003.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2004.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2005.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2006.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2007.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2008.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2009.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2010.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2011.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2012.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2013.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2014.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2015.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2016.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2017.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2018.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2019.dta"
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2020.dta"
*append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2021.dta"
order inegi year 
sort inegi year
*deflactar
preserve
insheet using "../../Data/ConstructionDatabase/Transferencias/deflator_WB/deflator_mexico_updated_2021.csv", clear
save "../../Data/ConstructionDatabase/Transferencias/Stata/deflator_mexico.dta", replace
restore
merge m:m year using "../../Data/ConstructionDatabase/Transferencias/Stata/deflator_mexico.dta"
drop _merge
gen carros2=(carros/(100+deflator))*100
order inegi year 
sort inegi year
save "../../Data/ConstructionDatabase/Transferencias/Stata/carros_2000_2020.dta", replace
