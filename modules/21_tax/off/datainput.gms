*** |  (C) 2006-2019 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of REMIND and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  REMIND License Exception, version 1.0 (see LICENSE file).
*** |  Contact: remind@pik-potsdam.de
*** SOF ./modules/21_tax/off/datainput.gms
    
*** --------------------
*** Historic CO2 prices
*** --------------------    
*IM* for tax case: future CO2-tax paths are given in different module/45_carbonprice realizations
*RP* historic (2010, 2015) CO2 prices are defined here
parameter f21_taxCO2eqHist(ttot,all_regi)        "historic CO2 prices ($/tCO2)"
/
$ondelim
$include "./modules/21_tax/on/input/pm_taxCO2eqHist.cs4r"
$offdelim
/
;
*** convert from $/tCO2 to T$/GtC
pm_taxCO2eqHist(t,regi) = f21_taxCO2eqHist(t,regi) * sm_DptCO2_2_TDpGtC;

 
*** EOF ./modules/21_tax/off/datainput.gms
