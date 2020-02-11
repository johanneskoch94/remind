*** |  (C) 2006-2019 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of REMIND and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  REMIND License Exception, version 1.0 (see LICENSE file).
*** |  Contact: remind@pik-potsdam.de
*** SOF ./standalone/macro/datainput.gms"

*------------------------------------------------------------------------------------
***                        calculations based on sets
*------------------------------------------------------------------------------------
pm_ttot_val(ttot) = ttot.val;
p_tall_val(tall) = tall.val;

pm_ts(ttot) = (pm_ttot_val(ttot+1)-(pm_ttot_val(ttot-1)))/2;
pm_ts("1900") = 2.5;
$if setGlobal END2110 pm_ts(ttot)$(ord(ttot) eq card(ttot)-1) =  pm_ts(ttot-1) ;
pm_ts(ttot)$(ord(ttot) eq card(ttot)) = 27;
pm_dt("1900") = 5;
pm_dt(ttot)$(ttot.val > 1900) = ttot.val - pm_ttot_val(ttot-1);
display pm_ts, pm_dt;


loop(ttot,
    loop(tall$((ttot.val le tall.val) AND (pm_ttot_val(ttot+1) ge tall.val)),
         pm_interpolWeight_ttot_tall(tall) = ( p_tall_val(tall) - pm_ttot_val(ttot) ) / ( pm_ttot_val(ttot+1) - pm_ttot_val(ttot) );
    );
);


pm_tall_2_ttot(tall, ttot)$((ttot.val lt tall.val) AND (pm_ttot_val(ttot+1) gt tall.val)) = Yes;
pm_ttot_2_tall(ttot,tall)$((ttot.val = tall.val) ) = Yes;

*** define pm_prtp according to cm_prtpScen:
if(cm_prtpScen eq 1, pm_prtp(regi) = 0.01);
if(cm_prtpScen eq 3, pm_prtp(regi) = 0.03);

*------------------------------------------------------------------------------------
*------------------------------------------------------------------------------------
***                                macro-economy
*------------------------------------------------------------------------------------
*------------------------------------------------------------------------------------

*** load energy system emulator data
table jk_femulator(ttot,all_regi,all_in,emu_pm)     "Supply curve parameters"  
$ondelim                
***######################## R SECTION START (FEMULATOR) ###############################
$include "./jk_emulators/jk_femulator_type1__base_lab_allT_smooth_posYIntercept_posSlope.cs4r"
***######################### R SECTION END (FEMULATOR) ################################
$offdelim
;
jk_emu_slope(ttot,all_regi,all_in) = jk_femulator(ttot,all_regi,all_in,"slope");
jk_emu_yIntercept(ttot,all_regi,all_in) = jk_femulator(ttot,all_regi,all_in,"yIntercept");        
jk_emu_x(ttot,all_regi,all_in) = jk_femulator(ttot,all_regi,all_in,"x");
jk_emu_y(ttot,all_regi,all_in) = jk_femulator(ttot,all_regi,all_in,"y");
jk_emu_x2(ttot,all_regi,all_in) = jk_femulator(ttot,all_regi,all_in,"x2");
jk_emu_y2(ttot,all_regi,all_in) = jk_femulator(ttot,all_regi,all_in,"y2");

* Emissions emulator 
table jk_emi_femulator(ttot,all_regi,all_in,emu_pm)     "Supply curve parameters" 
$ondelim                 
$include "./jk_emulators/jk_femulator_type1__base_lab_allT_smooth_testme_emissions.cs4r"
$offdelim
;

jk_emi_emu_slope(t,all_regi,all_in) = jk_emi_femulator(t,all_regi,all_in,"slope");
jk_emi_emu_yIntercept(t,all_regi,all_in) = jk_emi_femulator(t,all_regi,all_in,"yIntercept");  

display jk_emu_slope, jk_emu_yIntercept, jk_emu_x, jk_emu_y, jk_emu_x2, jk_emu_y2;

*** load population data
table f_pop(tall,all_regi,all_POPscen)        "Population data"
$ondelim
$include "./core/input/f_pop.cs3r"
$offdelim
;
pm_pop(tall,all_regi) = f_pop(tall,all_regi,"%cm_POPscen%") / 1000;  !! rescale unit from [million people] to [billion] people

*** load labour data
table f_lab(tall,all_regi,all_POPscen)        "Labour data"
$ondelim
$include "./core/input/f_lab.cs3r"
$offdelim
;
pm_lab(tall,all_regi) = f_lab(tall,all_regi,"%cm_POPscen%") / 1000; !! rescale unit from [million people] to [billion] people

display pm_pop, pm_lab;

*** load PPP-MER conversion factor data
parameter pm_shPPPMER(all_regi)        "PPP ratio for calculating GDP|PPP from GDP|MER"
/
$ondelim
$include "./core/input/pm_shPPPMER.cs4r"
$offdelim
/
;

*** load GDP data
table f_gdp(tall,all_regi,all_GDPscen)        "GDP data"
$ondelim
$include "./core/input/f_gdp.cs3r"
$offdelim
;
pm_gdp(tall,all_regi) = f_gdp(tall,all_regi,"%cm_GDPscen%") * pm_shPPPMER(all_regi) / 1000000;  !! rescale from million US$ to trillion US$

*** load level of development
table f_developmentState(tall,all_regi,all_GDPpcScen) "level of development based on GDP per capita"
$ondelim
$include "./core/input/f_developmentState.cs3r"
$offdelim
;
p_developmentState(tall,all_regi) = f_developmentState(tall,all_regi,"%c_GDPpcScen%");


*** Load information from BAU run
Execute_Loadpoint 'input'      vm_cesIO, vm_invMacro;

pm_gdp_gdx(ttot,regi)    = vm_cesIO.l(ttot,regi,"inco");
p_inv_gdx(ttot,regi)     = vm_invMacro.l(ttot,regi,"kap");

*** permit price initilization
pm_pricePerm(ttot) = 0;


*** Human capital
$ifthen.human_capital %human_capital% == "on"
table f_edu(all_regi,tall,all_POPscen)        "Labour data"
$ondelim
$include "./remind_input_LAYS.csv"
$offdelim
;
pm_education(ttot,all_regi) = f_edu(all_regi,ttot,"%cm_POPscen%");
pm_lab(ttot,all_regi) = pm_lab(ttot,all_regi) * pm_education(ttot,all_regi);
display pm_lab;
$endif.human_capital








*** ----- MAGICC RCP scenario emission data -----------------------------------
*** load default values from the scenario depending on cm_rcp_scen
*** (0): no RCP scenario, standard setting
*** (1): RCP2.6 - this only works with emiscen = 8
*** (2): RCP3.7 - this only works with emiscen = 5
*** (3): RCP4.5 - this only works with emiscen = 5
*** (4): RCP6.0 - this only works with emiscen = 5
*** (5): RCP8.5 - this only works with emiscen = 5
*** (6): RCP2.0 - this only works with emiscen = 8

$include "./core/magicc/magicc_scen_bau.inc";
$include "./core/magicc/magicc_scen_450.inc";
$include "./core/magicc/magicc_scen_550.inc";

*** ----- Parameters needed for MAGICC ----------------------------------------

table p_regi_2_MAGICC_regions(all_regi,RCP_regions_world_bunkers)    "map REMIND to MAGICC regions"
$ondelim
$include "./core/input/p_regi_2_MAGICC_regions.cs3r"
$offdelim
;
p_regi_2_MAGICC_regions(regi,"WORLD") = 1;
p_regi_2_MAGICC_regions(regi,"BUNKERS") = 0;
display p_regi_2_MAGICC_regions ;












*** -----------------------------------------------------------------------------
*** ------------ emission budgets and their time periods ------------------------
*** -----------------------------------------------------------------------------

*** definition of budgets on energy emissions in GtC and associated time period
s_t_start        = 2005;
$IFTHEN.test setglobal test_TS
sm_endBudgetCO2eq      = 2090;
$ELSE.test
sm_endBudgetCO2eq      = 2110;
$ENDIF.test
*cb single budget should cover the full modeling time, as otherwise CO2 prices show strange behaviour around 2100 (and rest of behaviour is also biased by foresight of cap-free post 2100)
if (cm_emiscen eq 6,
sm_endBudgetCO2eq      = 2150;
);

sm_budgetCO2eqGlob = 20000.0000;

*JeS values for multigasscen = 1 are only estimates which may not meet the forcing target, only those for multigasscen = 2 have already been tested.
if(cm_emiscen eq 6,
  if(cm_multigasscen eq 1,
$if  "%cm_rcp_scen%" == "rcp20"   sm_budgetCO2eqGlob = 250.0000;
$if  "%cm_rcp_scen%" == "rcp26"   sm_budgetCO2eqGlob = 273.0000;
$if  "%cm_rcp_scen%" == "rcp37"   sm_budgetCO2eqGlob = 350.0000;
$if  "%cm_rcp_scen%" == "rcp45"   sm_budgetCO2eqGlob = 420.0000;
$if  "%cm_rcp_scen%" == "rcp60"   sm_budgetCO2eqGlob = 1000.0000;
$if  "%cm_rcp_scen%" == "rcp85"   sm_budgetCO2eqGlob = 20000.0000;
$if  "%cm_rcp_scen%" == "none"    sm_budgetCO2eqGlob = 20000.0000;
  );
  if(cm_multigasscen eq 2,
$if  "%cm_rcp_scen%" == "rcp20"   sm_budgetCO2eqGlob = 500.0000;
     if(cm_ccapturescen eq 1,
$if  "%cm_rcp_scen%" == "rcp26"   sm_budgetCO2eqGlob = 530.0000;
     );
     if(cm_ccapturescen gt 1,
$if  "%cm_rcp_scen%" == "rcp26"   sm_budgetCO2eqGlob = 700.0000;
     );
$if  "%cm_rcp_scen%" == "rcp37"   sm_budgetCO2eqGlob = 1000.0000;
$if  "%cm_rcp_scen%" == "rcp45"   sm_budgetCO2eqGlob = 1273.0000;
$if  "%cm_rcp_scen%" == "rcp60"   sm_budgetCO2eqGlob = 2700.0000;
$if  "%cm_rcp_scen%" == "rcp85"   sm_budgetCO2eqGlob = 20000.0000;
$if  "%cm_rcp_scen%" == "none"    sm_budgetCO2eqGlob = 20000.0000;
  );
);

if(cm_iterative_target_adj eq 1,
***only one long budget period for scenarios with iterative adjustment of budget, so that p_referencebudgetco2 is met from 2000-2100
sm_endBudgetCO2eq      = 2150;
s_referencebudgetco2    = 1500;
sm_budgetCO2eqGlob = 700;
);
display sm_budgetCO2eqGlob;




***
*** 37_industry
***
*** substitution elasticities
Parameter 
  p37_cesdata_sigma(all_in)  "substitution elasticities"
  /
    eni     2.5
      enhi  3.0

  /
;

pm_cesdata_sigma(ttot,in)$p37_cesdata_sigma(in) = p37_cesdata_sigma(in);

pm_cesdata_sigma(ttot,in)$ (pm_ttot_val(ttot) le 2025  AND sameAs(in, "eni")) = 0.1;
pm_cesdata_sigma(ttot,in)$ (pm_ttot_val(ttot) eq 2030  AND sameAs(in, "eni")) = 0.3;
pm_cesdata_sigma(ttot,in)$ (pm_ttot_val(ttot) eq 2035  AND sameAs(in, "eni")) = 0.6;
pm_cesdata_sigma(ttot,in)$ (pm_ttot_val(ttot) eq 2040  AND sameAs(in, "eni")) = 1.3;
pm_cesdata_sigma(ttot,in)$ (pm_ttot_val(ttot) eq 2045  AND sameAs(in, "eni")) = 1.7;

pm_cesdata_sigma(ttot,in)$ (pm_ttot_val(ttot) le 2025  AND sameAs(in, "enhi")) = 0.1;
pm_cesdata_sigma(ttot,in)$ (pm_ttot_val(ttot) eq 2030  AND sameAs(in, "enhi")) = 0.3;
pm_cesdata_sigma(ttot,in)$ (pm_ttot_val(ttot) eq 2035  AND sameAs(in, "enhi")) = 0.6;
pm_cesdata_sigma(ttot,in)$ (pm_ttot_val(ttot) eq 2040  AND sameAs(in, "enhi")) = 1.3;
pm_cesdata_sigma(ttot,in)$ (pm_ttot_val(ttot) eq 2045  AND sameAs(in, "enhi")) = 2.0;

*** Don't use more than 25/50% H2/district heat in industry
pm_ppfen_shares("enhi","feh2i") = 0.25;

pm_ppfen_shares("enhi","fehei") = 0.5;

*** Don't use more H2 than gas in industry
*** FIXME release this constraint when matching to subsectors implementation
pm_ppfen_ratios("feh2i","fegai") = 1;



















*** Optimization


$ifthen %optimization% == "testOneRegi"
pm_w(regi) = 1;

*LB* initialize price parameter, import from gdx in preloop
pm_pvp(ttot,trade)$(ttot.val ge 2005) = 0;
p80_etaXp(tradePe) = 1;
p80_etaXp("good") = 1;
p80_etaXp("perm") = 1;

*load fallback prices

$include "./modules/80_optimization/testOneRegi/input/prices_NASH.inc";

*MLB 12062013* initialize learning externality (can be improved by including file)
pm_capCumForeign(ttot,regi,teLearn)$(ttot.val ge 2005) = 0;
pm_cumEff(t,regi,in) = 0;
pm_co2eqForeign(t,regi) = 0;
pm_emissionsForeign(t,regi,enty) = 0;
pm_SolNonInfes(regi) = 1; !! assume the starting point came from a feasible solution 
pm_fuExtrForeign(t,regi,enty,rlf) = 0;


$elseif %optimization% == "nash"
*** 
*** 80_optimization nash
***
pm_w(regi) = 1;

o80_trackSurplusSign(ttot,trade,iteration) = 0;
*Nash adjustment costs. Involves a trade-off: If set too low, markets jump far away from clearance. Set too high, changes in trade patten over iterations are very slow, convergence takes many many iterations. Default value around 150
p80_etaAdj(tradePe) = 80; 
p80_etaAdj("good") = 100;
p80_etaAdj("perm") = 10;

*LB* parameter for nash price algorithm within the optimization. 
p80_etaXp(tradePe) = 0.1;
p80_etaXp("good") = 0.1;
p80_etaXp("perm") = 0.2;

*LB* parameter for Nash price algorithm between different iterations
p80_etaLT(trade) = 0;
p80_etaLT("perm") = 0.03;

***These parameters are pretty sensitive. If market surpluses diverge, try higher values (up to 1). If surpluses oscillate, try lower values. 
p80_etaST(tradePe) = 0.3;
p80_etaST("good") = 0.25;
p80_etaST("perm") = 0.3;

$ifi %banking% == "banking"  p80_etaST("perm") = 0.2;      !! in banking mode, the permit market reacts more sensitively.
$ifi %emicapregi% == "budget"  p80_etaST("perm") = 0.25;      !! in budget mode, the permit market reacts more sensitively.

*AJS* bio market seems to like this:
p80_etaST("pebiolc") = 0.8;
***peur market is more sensitive, so choose lower etaST
p80_etaST("peur") = 0.2;

s80_converged = 0;

***initialize some convergence process parameters
s80_fadeoutPriceAnticipStartingPeriod = 0;
sm_fadeoutPriceAnticip = 1;
*AJS*technical stuff. We want GAMS to import values for the following variables/parameters from the gdx, it would not do that unless you set m ***a (any) value beforehand.
pm_pvp(ttot,trade)$(ttot.val ge 2005) = NA;
p80_pvpFallback(ttot,trade)$(ttot.val ge 2005) = NA;
pm_Xport0(ttot,regi,trade)$(ttot.val ge 2005) = NA;
p80_Mport0(ttot,regi,trade)$(ttot.val ge 2005) = NA;
vm_Xport.l(ttot,regi,trade)$(ttot.val ge 2005) = NA;
vm_Mport.l(ttot,regi,trade)$(ttot.val ge 2005) = NA;
vm_cons.l(ttot,regi)$(ttot.val ge 2005) = 0;
vm_emiTe.l(ttot,regi,"CO2")$(ttot.val ge 2005) = NA;  
vm_fuExtr.l(ttot,regi,tradePe,rlf)$(ttot.val ge 2005) = 0;
vm_prodPe.l(ttot,regi,tradePe)$(ttot.val ge 2005) = 0;    
vm_taxrev.l(ttot,regi)$(ttot.val gt 2005) = 0;
vm_co2eq.l(ttot,regi) = 0;
vm_emiAll.l(ttot,regi,enty) = 0;
p80_repy(all_regi,solveinfo80) = 0;
pm_capCumForeign(ttot,regi,teLearn)$(ttot.val ge 2005)=0;

***read in price paths as fallback option
***p80_pvpFallback(ttot,trade) = 0;
$include "./modules/80_optimization/nash/input/prices_NASH.inc";


***convergence mode
if(cm_nash_autoconverge gt 0,

*** set max number of iterations
cm_iteration_max = 100;

  if(cm_nash_autoconverge eq 1,
***convergences thresholds - coarse 
  p80_surplusMaxTolerance(tradePe) = 1.5 * sm_EJ_2_TWa;          !! convert EJ/yr into internal unit TWa
  p80_surplusMaxTolerance("good") = 100/1000;                  !! in internal unit, trillion Dollar
  p80_surplusMaxTolerance("perm") = 300 * 12/44 / 1000;                !! convert MtCO2eq into internal unit GtC
   );
 if(cm_nash_autoconverge eq 2,
***convergences thresholds - fine 
  p80_surplusMaxTolerance(tradePe) = 0.3 * sm_EJ_2_TWa;          !! convert EJ/yr into internal unit TWa
  p80_surplusMaxTolerance("good") = 20/1000;                  !! in internal unit, trillion Dollar
  p80_surplusMaxTolerance("perm") = 70 * 12/44 / 1000 ;                !! convert MtCO2eq into internal unit GtC
   );
);
$elseif  %optimization% == "negishi"

pm_pvp(ttot,trade)$(ttot.val ge 2005)               = 1;
p80_trade(ttot,regi,trade)$(ttot.val ge 2005)       = 0;

if (cm_emiscen eq 1,
  Execute_Loadpoint "./input.gdx", p80_currentaccount_bau = p80_curracc;
else
  Execute_Loadpoint "./input_ref.gdx", p80_currentaccount_bau = p80_curracc;
);


p80_defic_sum("1") = 1;

*MLB*LB*AJS* This parameter is only relevant for the nash algorithm. 
pm_capCumForeign(t,regi,teLearn) = 0;
pm_cumEff(t,regi,in) = 0;
pm_co2eqForeign(t,regi) = 0;
pm_emissionsForeign(t,regi,enty) = 0;
pm_fuExtrForeign(t,regi,enty,rlf) = 0;

pm_SolNonInfes(regi) = 1; !! assume the starting point came from a feasible solution 

$endif
    

*** EOF ./standalone/macro/datainput.gms"
