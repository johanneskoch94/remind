*** |  (C) 2006-2019 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of REMIND and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  REMIND License Exception, version 1.0 (see LICENSE file).
*** |  Contact: remind@pik-potsdam.de
*** SOF ./standalone/macro/include.gms

$setglobal phase %1

*######################## R SECTION START (MODULES) ############################
$include "./modules/01_macro/module.gms"
$include "./modules/02_welfare/module.gms"
$include "./modules/15_climate/module.gms"
$include "./modules/20_growth/module.gms"
$include "./modules/23_capitalMarket/module.gms"
$include "./modules/24_trade/module.gms"
$include "./modules/26_agCosts/module.gms"
$include "./modules/29_CES_parameters/module.gms"
$include "./modules/36_buildings/module.gms"
$include "./modules/50_damages/module.gms"
*######################## R SECTION END (MODULES) ##############################
*** EOF ./standalone/macro/include.gms
