*****************************************************
*Reelection Backfire
*Rafael Ch (2020)
*Transfers
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
*Participaciones federales
foreach i in 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020 2021{
insheet using "../../Data/ConstructionDatabase/Transferencias/efipem_municipal_csv/conjunto_de_datos/efipem_municipal_anual_tr_cifra_`i'.csv", clear
rename anio year
tostring id_entidad, replace
tostring id_municipio, replace
gen digits=strlen(id_municipio)
gen inegi = id_entidad + "00" + id_municipio if digits==1
replace inegi = id_entidad + "0" + id_municipio if digits==2
replace inegi = id_entidad + id_municipio if digits==3
destring inegi, replace
keep if descripcion_categoria=="Participaciones federales" & tema=="Ingresos" 
rename valor participaciones
keep inegi year participaciones 
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
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2021.dta"
order inegi year 
sort inegi year
*deflactar
preserve
insheet using "../../Data/ConstructionDatabase/Transferencias/deflator_WB/deflator_mexico_updated_2021.csv", clear
save "../../Data/ConstructionDatabase/Transferencias/Stata/deflator_mexico.dta", replace
restore
merge m:m year using "../../Data/ConstructionDatabase/Transferencias/Stata/deflator_mexico.dta"
drop _merge
gen participaciones2=(participaciones/deflator)*100
order inegi year 
sort inegi year
save "../../Data/ConstructionDatabase/Transferencias/Stata/participaciones_2000_2021.dta", replace

*========================================================================
*Fondos participables
foreach i in 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020 2021{
insheet using "../../Data/ConstructionDatabase/Transferencias/efipem_municipal_csv/conjunto_de_datos/efipem_municipal_anual_tr_cifra_`i'.csv", clear
rename anio year
tostring id_entidad, replace
tostring id_municipio, replace
gen digits=strlen(id_municipio)
gen inegi = id_entidad + "00" + id_municipio if digits==1
replace inegi = id_entidad + "0" + id_municipio if digits==2
replace inegi = id_entidad + id_municipio if digits==3
destring inegi, replace
keep if descripcion_categoria=="Fondos participables"  & tema=="Ingresos" 
collapse (sum) valor, by(inegi year)
rename valor participables
keep inegi year participables 
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
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2021.dta"
order inegi year 
sort inegi year
*deflactar
preserve
insheet using "../../Data/ConstructionDatabase/Transferencias/deflator_WB/deflator_mexico_updated_2021.csv", clear
save "../../Data/ConstructionDatabase/Transferencias/Stata/deflator_mexico.dta", replace
restore
merge m:m year using "../../Data/ConstructionDatabase/Transferencias/Stata/deflator_mexico.dta"
drop _merge
gen participables2=(participables/deflator)*100
order inegi year 
sort inegi year
save "../../Data/ConstructionDatabase/Transferencias/Stata/participables_2000_2021.dta", replace

*========================================================================
*Fondo General de Participaciones
foreach i in 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020 2021{
insheet using "../../Data/ConstructionDatabase/Transferencias/efipem_municipal_csv/conjunto_de_datos/efipem_municipal_anual_tr_cifra_`i'.csv", clear
rename anio year
tostring id_entidad, replace
tostring id_municipio, replace
gen digits=strlen(id_municipio)
gen inegi = id_entidad + "00" + id_municipio if digits==1
replace inegi = id_entidad + "0" + id_municipio if digits==2
replace inegi = id_entidad + id_municipio if digits==3
destring inegi, replace
keep if descripcion_categoria=="Fondo General de Participaciones"  & tema=="Ingresos" 
collapse (sum) valor, by(inegi year)
rename valor participaciones
keep inegi year participaciones 
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
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2021.dta"
order inegi year 
sort inegi year
*deflactar
preserve
insheet using "../../Data/ConstructionDatabase/Transferencias/deflator_WB/deflator_mexico_updated_2021.csv", clear
save "../../Data/ConstructionDatabase/Transferencias/Stata/deflator_mexico.dta", replace
restore
merge m:m year using "../../Data/ConstructionDatabase/Transferencias/Stata/deflator_mexico.dta"
drop _merge
gen participaciones2=(participaciones/deflator)*100
order inegi year 
sort inegi year
save "../../Data/ConstructionDatabase/Transferencias/Stata/participaciones_2000_2021.dta", replace

*========================================================================
*Fondo de Fomento Municipal
foreach i in 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020 2021{
insheet using "../../Data/ConstructionDatabase/Transferencias/efipem_municipal_csv/conjunto_de_datos/efipem_municipal_anual_tr_cifra_`i'.csv", clear
rename anio year
tostring id_entidad, replace
tostring id_municipio, replace
gen digits=strlen(id_municipio)
gen inegi = id_entidad + "00" + id_municipio if digits==1
replace inegi = id_entidad + "0" + id_municipio if digits==2
replace inegi = id_entidad + id_municipio if digits==3
destring inegi, replace
keep if descripcion_categoria=="Fondo de Fomento Municipal"  & tema=="Ingresos" 
rename valor fomento
keep inegi year fomento 
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
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2021.dta"
order inegi year 
sort inegi year
*deflactar
preserve
insheet using "../../Data/ConstructionDatabase/Transferencias/deflator_WB/deflator_mexico_updated_2021.csv", clear
save "../../Data/ConstructionDatabase/Transferencias/Stata/deflator_mexico.dta", replace
restore
merge m:m year using "../../Data/ConstructionDatabase/Transferencias/Stata/deflator_mexico.dta"
drop _merge
gen fomento2=(fomento/deflator)*100
order inegi year 
sort inegi year
save "../../Data/ConstructionDatabase/Transferencias/Stata/fomento_2000_2021.dta", replace

*========================================================================
*Aportaciones federales y estatales
foreach i in 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020 2021{
insheet using "../../Data/ConstructionDatabase/Transferencias/efipem_municipal_csv/conjunto_de_datos/efipem_municipal_anual_tr_cifra_`i'.csv", clear
rename anio year
tostring id_entidad, replace
tostring id_municipio, replace
gen digits=strlen(id_municipio)
gen inegi = id_entidad + "00" + id_municipio if digits==1
replace inegi = id_entidad + "0" + id_municipio if digits==2
replace inegi = id_entidad + id_municipio if digits==3
destring inegi, replace
keep if descripcion_categoria=="Aportaciones federales y estatales"  & tema=="Ingresos" 
rename valor aportaciones
keep inegi year aportaciones 
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
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2021.dta"
order inegi year 
sort inegi year
*deflactar
preserve
insheet using "../../Data/ConstructionDatabase/Transferencias/deflator_WB/deflator_mexico_updated_2021.csv", clear
save "../../Data/ConstructionDatabase/Transferencias/Stata/deflator_mexico.dta", replace
restore
merge m:m year using "../../Data/ConstructionDatabase/Transferencias/Stata/deflator_mexico.dta"
drop _merge
gen aportaciones2=(aportaciones/deflator)*100
order inegi year 
sort inegi year
save "../../Data/ConstructionDatabase/Transferencias/Stata/aportaciones_2000_2021.dta", replace

*========================================================================
*FA para la Infraestructura Social Municipal
foreach i in 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020 2021{
insheet using "../../Data/ConstructionDatabase/Transferencias/efipem_municipal_csv/conjunto_de_datos/efipem_municipal_anual_tr_cifra_`i'.csv", clear
rename anio year
tostring id_entidad, replace
tostring id_municipio, replace
gen digits=strlen(id_municipio)
gen inegi = id_entidad + "00" + id_municipio if digits==1
replace inegi = id_entidad + "0" + id_municipio if digits==2
replace inegi = id_entidad + id_municipio if digits==3
destring inegi, replace
keep if descripcion_categoria=="FA para la Infraestructura Social Municipal"  & tema=="Ingresos" 
rename valor fa_infra
keep inegi year fa_infra 
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
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2021.dta"
order inegi year 
sort inegi year
*deflactar
preserve
insheet using "../../Data/ConstructionDatabase/Transferencias/deflator_WB/deflator_mexico_updated_2021.csv", clear
save "../../Data/ConstructionDatabase/Transferencias/Stata/deflator_mexico.dta", replace
restore
merge m:m year using "../../Data/ConstructionDatabase/Transferencias/Stata/deflator_mexico.dta"
drop _merge
gen fa_infra2=(fa_infra/deflator)*100
order inegi year 
sort inegi year
save "../../Data/ConstructionDatabase/Transferencias/Stata/fa_infra_2000_2021.dta", replace

*========================================================================
*FA para el Fortalecimiento de los Municipios
foreach i in 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020 2021{
insheet using "../../Data/ConstructionDatabase/Transferencias/efipem_municipal_csv/conjunto_de_datos/efipem_municipal_anual_tr_cifra_`i'.csv", clear
rename anio year
tostring id_entidad, replace
tostring id_municipio, replace
gen digits=strlen(id_municipio)
gen inegi = id_entidad + "00" + id_municipio if digits==1
replace inegi = id_entidad + "0" + id_municipio if digits==2
replace inegi = id_entidad + id_municipio if digits==3
destring inegi, replace
keep if descripcion_categoria=="FA para el Fortalecimiento de los Municipios"  & tema=="Ingresos" 
rename valor fa_fortalecer
keep inegi year fa_fortalecer
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
append using "../../Data/ConstructionDatabase/Transferencias/Stata/impuesto_predial_2021.dta"
order inegi year 
sort inegi year
*deflactar
preserve
insheet using "../../Data/ConstructionDatabase/Transferencias/deflator_WB/deflator_mexico_updated_2021.csv", clear
save "../../Data/ConstructionDatabase/Transferencias/Stata/deflator_mexico.dta", replace
restore
merge m:m year using "../../Data/ConstructionDatabase/Transferencias/Stata/deflator_mexico.dta"
drop _merge
gen fa_fortalecer2=(fa_fortalecer/deflator)*100
order inegi year 
sort inegi year
save "../../Data/ConstructionDatabase/Transferencias/Stata/fa_fortalecer_2000_2021.dta", replace
