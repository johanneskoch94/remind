*** |  (C) 2006-2019 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of REMIND and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  REMIND License Exception, version 1.0 (see LICENSE file).
*** |  Contact: remind@pik-potsdam.de

*##################### R SECTION START (VERSION INFO) ##########################
* 
* Regionscode: 690d3718e151be1b450b394c1064b1c5
* 
* Input data revision: 5.846
* 
* Last modification (input data): Tue Jul 02 13:58:54 2019
* 
*###################### R SECTION END (VERSION INFO) ###########################

$title model_title

*--------------------------------------------------------------------------
*** preliminaries:
*--------------------------------------------------------------------------
*** allow empty data sets:
$onempty
*** create dummy identifier to fill empty sets:
$phantom null
*** include unique element list:
$onuellist
*** include $-statements in listing
$ondollar
*** include end-of-line comments
$ONeolcom
*** remove the warnings for very small exponents (x**-60) when post-processing
$offdigit


***---------------------    Run name    -----------------------------------------
$setGlobal c_expname  test
***---------------------    Energy System Emulator    ---------------------------
$setGlobal emulator_energySys  on_1
***
$setGlobal human_capital on

***------------------------------------------------------------------------------
***                           MODULES
***------------------------------------------------------------------------------
***---------------------    01_macro    -----------------------------------------
$setGlobal macro  singleSectorGr  !! def = singleSectorGr
***---------------------    02_welfare    ---------------------------------------
$setGlobal welfare  utilitarian  !! def = utilitarian
***---------------------    04_PE_FE_parameters    ------------------------------
$setGlobal PE_FE_parameters  iea2014  !! def = iea2014
***---------------------    05_initialCap    ------------------------------------
$setGlobal initialCap  on             !! def = on
***---------------------    11_aerosols    --------------------------------------
$setGlobal aerosols  exoGAINS         !! def = exoGAINS
***---------------------    15_climate    ---------------------------------------
$setGlobal climate  off               !! def = off
***---------------------    16_downscaleTemperature    --------------------------
$setGlobal downscaleTemperature  off  !! def = off
***---------------------    20_growth    ----------------------------------------
$setGlobal growth  exogenous          !! def = exogenous
***---------------------    21_tax    -------------------------------------------
$setGlobal tax  off                    !! def = on
***---------------------    22_subsidizeLearning    -----------------------------
$setGlobal subsidizeLearning  off     !! def = off
***---------------------    23_capitalMarket    ---------------------------------
$setGlobal capitalMarket  perfect     !! def = perfect
***---------------------    24_trade    -----------------------------------------
$setGlobal trade  standard     !! def = standard
***---------------------    26_agCosts ------------------------------------------
$setGlobal agCosts  costs               !! def = costs
***---------------------    29_CES_parameters    --------------------------------
$setglobal CES_parameters  load       !! def = load
***---------------------    30_biomass    ---------------------------------------
$setGlobal biomass  magpie_40 !! def = magpie_40
***---------------------    31_fossil    ----------------------------------------
$setGlobal fossil  timeDepGrades        !! def = grades2poly
***---------------------    32_power    -----------------------------------------
$setGlobal power  IntC               !! def = IntC
***---------------------    33_cdr       ----------------------------------------
$setGlobal CDR  DAC                   !! def = DAC
***---------------------    35_transport    -------------------------------------
$setGlobal transport  complex         !! def = complex
***---------------------    36_buildings    -------------------------------------
$setglobal buildings  simple          !! def = simple
***---------------------    37_industry    --------------------------------------
$setglobal industry  fixed_shares     !! def = simple
***---------------------    38_stationary    ------------------------------------
$setglobal stationary  off            !! def = simple
***---------------------    39_CCU    -------------------------------------------
$setglobal CCU  off !! def = off
***---------------------    40_techpol  -----------------------------------------
$setglobal techpol  none              !! def = none
***---------------------    41_emicapregi  --------------------------------------
$setglobal emicapregi  none           !! def = none
***---------------------    42_banking  -----------------------------------------
$setglobal banking  off               !! def = off
***---------------------    45_carbonprice  -------------------------------------
$setglobal carbonprice  none          !! def = none
***---------------------    47_regipol  -----------------------------------------
$setglobal regipol  none              !! def = none
***---------------------    50_damages    ---------------------------------------
$setGlobal damages  off               !! def = off
***---------------------    51_internalizeDamages    ----------------------------
$setGlobal internalizeDamages  off               !! def = off
***---------------------    70_water  -------------------------------------------
$setglobal water  off                 !! def = off
***---------------------    80_optimization    ----------------------------------
$setGlobal optimization  nash         !! def = nash
***---------------------    81_codePerformance    -------------------------------
$setGlobal codePerformance  off       !! def = off



***-----------------------------------------------------------------------------
***                     SWITCHES and FLAGS
***-----------------------------------------------------------------------------
***--------------- switches ----------------------------------------------------
parameters
cm_iteration_max            "number of Negishi iterations (up to 49)"
c_solver_try_max            "maximum number of inner iterations within one Negishi iteration (<10)"
c_keep_iteration_gdxes      "save intermediate iteration gdxes"
cm_nash_autoconverge        "choice of nash convergence mode"
cm_TaxConvCheck             "switch for enabling tax convergence check in nash mode"
cm_emiscen                  "policy scenario choice"
cm_GDPcovid                 "GDP correction for covid"
cm_multigasscen 
cm_ccapturescen 
c_macscen                   "use of mac"
cm_bioenergy_tax            "level of bioenergy tax in fraction of bioenergy price"
cm_tradecost_bio  
cm_startyear                "first optimized modelling time step"
cm_prtpScen                 "pure rate of time preference standard values"
cm_damage                   "cm_damage factor for forcing overshoot"
cm_iterative_target_adj     "whether or not a tax or a budget target should be iteratively adjusted depending on actual emission or forcing level"
cm_trdcst                   "parameter to scale trade export cost for gas"
cm_trdadj                   "parameter scale the adjustment cost parameter for increasing gas trade export"
;
cm_iteration_max            = 1;            !! def = 1
c_solver_try_max            = 2;            !! def = 2
c_keep_iteration_gdxes      = 0;            !! def = 0
cm_nash_autoconverge        = 1;            !! def = 1
cm_TaxConvCheck             = 1;            !! def = 1
cm_emiscen                  = 1;            !! def = 1
cm_GDPcovid                 = 0;            !! def = 0
cm_multigasscen             = 2;            !! def = 2
cm_ccapturescen             = 1;            !! def = 1
c_macscen                   = 1;            !! def = 1
cm_bioenergy_tax            = 1.5;          !! def = 1.5
cm_tradecost_bio            = 2;            !! def = 2
cm_startyear                = 2005;         !! def = 2005 for a BAU, 2015 for policy runs
cm_prtpScen                 = 3;            !! def = 3
cm_damage                   = 0.005;        !! def = 0.005
cm_iterative_target_adj     = 0;            !! def = 0
cm_trdadj                   = 2;            !! def = 2.0
cm_trdcst                   = 1.5;          !! def = 1.5
*-------------------- flags ----------------------------------------------------
$setglobal cm_MAgPIE_coupling         off             !! def = "off"
$setglobal cm_rcp_scen                none            !! def = "none"
$setglobal cm_LU_emi_scen             SSP2            !! def = SSP2
$setglobal cm_POPscen                 pop_SSP2        !! def = pop_SSP2
$setglobal cm_GDPscen                 gdp_SSP2        !! def = gdp_SSP2
$setglobal c_GDPpcScen                SSP2            !! def = gdp_SSP2   (automatically adjusted in core/datainput.gms based on GDPscen) 
$setGlobal c_regi_nucscen             all             !! def = all
$setGlobal c_regi_capturescen         all             !! def = all
$setGlobal cm_SlowConvergence         off             !! def = off
$setGlobal cm_nash_mode               parallel        !! def = parallel
$setglobal cm_INCONV_PENALTY          on              !! def = on
$setGlobal c_skip_output              off             !! def = off
$setGlobal cm_conoptv                 conopt3         !! def = conopt3
$setGlobal cm_ccsfosall               off             !! def = off
*** CES related
$setglobal cm_CES_configuration       stat_off-indu_fixed_shares-buil_simple-tran_complex-POP_pop_SSP2-GDP_gdp_SSP2-Kap_perfect-Reg_690d3718e1 
$setglobal c_CES_calibration_new_structure      0     !! def =  0
$setglobal c_CES_calibration_iterations         10    !! def = 10
$setglobal c_CES_calibration_iteration          1     !! def =  1
$setglobal c_CES_calibration_write_prices       0     !! def =  0
$setglobal cm_CES_calibration_default_prices    0     !! def = 0
$setGlobal cm_EsubGrowth              low             !! def = low
***
$setglobal c_testOneRegi_region       NEU             !! def = EUR
***
$setGlobal cm_less_TS  on  !! def = on
$setGlobal cm_Full_Integration  off     !! def = off
***-----------------------------------------------------------------------------
***                    
***-----------------------------------------------------------------------------


*** set conopt version
option nlp = %cm_conoptv%;
option cns = %cm_conoptv%;


*--------------------------------------------------------------------------
***           SETS
*--------------------------------------------------------------------------
$include    "./core/sets.gms";
$batinclude "./standalone/macro/include_sets.gms"    sets
$include    "./standalone/macro/set_calculations.gms";

*--------------------------------------------------------------------------
***        DECLARATION     of equations, variables, parameters and scalars
*--------------------------------------------------------------------------
$include    "./standalone/macro/declarations.gms";
$batinclude "./standalone/macro/include_declarations.gms"    declarations

*--------------------------------------------------------------------------
***          DATAINPUT
*--------------------------------------------------------------------------
$include    "./standalone/macro/datainput.gms";
$batinclude "./standalone/macro/include_datainput.gms"    datainput

*** Transport
Parameter 
  p35_cesdata_sigma(all_in)  "substitution elasticities"
  /
        entrp   1.5
          fetf  0.8
  /

  p35_valconv                "temporary parameter used to set convergence between regions"
;
pm_cesdata_sigma(ttot,in)$p35_cesdata_sigma(in) = p35_cesdata_sigma(in);

$if "%CES_parameters%" == "calibrate" pm_cesdata_sigma(ttot,in)$p29_cesdata_sigma(in) = p29_cesdata_sigma(in);


pm_cesdata_sigma(ttot,in)$ (pm_ttot_val(ttot) le 2025  AND sameAs(in, "inco")) = 0.1;
pm_cesdata_sigma(ttot,in)$ (pm_ttot_val(ttot) eq 2030  AND sameAs(in, "inco")) = 0.15;
pm_cesdata_sigma(ttot,in)$ (pm_ttot_val(ttot) eq 2035  AND sameAs(in, "inco")) = 0.20;
pm_cesdata_sigma(ttot,in)$ (pm_ttot_val(ttot) eq 2040  AND sameAs(in, "inco")) = 0.30;
pm_cesdata_sigma(ttot,in)$ (pm_ttot_val(ttot) eq 2045  AND sameAs(in, "inco")) = 0.40;

pm_cesdata_sigma(ttot,in)$ (pm_ttot_val(ttot) le 2025  AND sameAs(in, "en")) = 0.1;
pm_cesdata_sigma(ttot,in)$ (pm_ttot_val(ttot) eq 2030  AND sameAs(in, "en")) = 0.12;
pm_cesdata_sigma(ttot,in)$ (pm_ttot_val(ttot) eq 2035  AND sameAs(in, "en")) = 0.15;
pm_cesdata_sigma(ttot,in)$ (pm_ttot_val(ttot) eq 2040  AND sameAs(in, "en")) = 0.20;
pm_cesdata_sigma(ttot,in)$ (pm_ttot_val(ttot) eq 2045  AND sameAs(in, "en")) = 0.25;

*** Specify the ces structure on which the calibration will run.
$ifthen "%CES_parameters%" == "calibrate"
ppf_29(all_in)
  = ppfen_dyn35(all_in)
  + cal_ppf_buildings_dyn36(all_in)
  + cal_ppf_industry_dyn37(all_in)
;

ppf_29("kap") = YES;
ppf_29("lab") = YES;
$endif




Execute_Loadpoint 'input' pm_macCost = pm_macCost;
pm_shPerm(t,regi) = 1;
pm_emicapglob(t) = 1000;

*** Load in Trade variabes, and fix trade in PE
Execute_Loadpoint 'input_ref' vm_Mport.l = vm_Mport.l;
Execute_Loadpoint 'input_ref' vm_Xport.l = vm_Xport.l;
vm_Xport.fx(tall,regi,tradePe) = vm_Xport.l(tall,regi,tradePe);
vm_Mport.fx(tall,regi,tradePe) = vm_Mport.l(tall,regi,tradePe);

*--------------------------------------------------------------------------
***          EQUATIONS
*--------------------------------------------------------------------------
$include    "./standalone/macro/equations.gms";
$batinclude "./standalone/macro/include_equations.gms"    equations


*--------------------------------------------------------------------------
***           PRELOOP   Calculations before the Negishi-loop starts
***                     (e.g. initial calibration of macroeconomic module)
*--------------------------------------------------------------------------
Execute_Loadpoint 'input' qm_budget.m = qm_budget.m;
Execute_Loadpoint 'input' pm_pvpRegi = pm_pvpRegi;
$batinclude "./standalone/macro/include_sets.gms"    preloop

*--------------------- MODEL DEFINITION & SOLVER OPTIONS ------------------
model hybrid / all /;

option limcol    = 0;
option limrow    = 0;
hybrid.optfile   = 1;
hybrid.holdfixed = 1;
hybrid.scaleopt  = 1;
option savepoint = 0;
option reslim    = 1.e+6;
*AJS* limit maximum time for one nash region to two hours.
$IFI %optimization% == 'nash' option reslim = 7200;
option iterlim   = 1.e+6;
option solprint  = off ;

***-------------------------------------------------------------------
***                     read GDX
***-------------------------------------------------------------------
*** load start gdx
execute_loadpoint 'input';

***--------------------------------------------------------------------------
***    start iteration loop 
***--------------------------------------------------------------------------
LOOP(iteration $(ord(iteration)<(cm_iteration_max+1)),

  IF(ord(iteration)>(cm_iteration_max-1),
    OPTION solprint=on
  );
*--------------------------------------------------------------------------
***         BOUNDS
*--------------------------------------------------------------------------
$batinclude "./standalone/macro/include_bounds.gms" bounds

*** set Mport and Xport positive
vm_Mport.lo(ttot,regi,tradePe)$(ttot.val ge 2005) = 0;
vm_Xport.lo(ttot,regi,tradePe)$(ttot.val ge 2005) = 0;

vm_costpollution.fx(t,regi)=0;

***--------------------------------------------------------------------------
***         PRESOLVE
***--------------------------------------------------------------------------
$batinclude "./standalone/macro/include_datainput.gms" presolve

*cb 20140305 Fixing information (.L, .FX and .M) from run to be fixed to is read in from input_ref.gdx (t < cm_startyear)
*cb 20140305 happens via submit.R script (files levs.gms, fixings.gms, margs.gms)
*cb 20140305 submit.R looks for the unique string in the following line and replaces it with the offlisting include into the full.gms at this position
***cb20140305readinpositionforfinxingfiles

*AJS* In case of fixing, fix to prices from input_ref.gdx (t < cm_startyear). 
*** Parameters are not automatically treated by the fixing mechanism above.

if( (cm_startyear gt 2005),
  Execute_Loadpoint 'input_ref' p_pvpRef = pm_pvp;
  pm_pvp(ttot,trade)$( (ttot.val ge 2005) and (ttot.val lt cm_startyear)) = p_pvpRef(ttot,trade);
);     

***--------------------------------------------------------------------------
***         SOLVE 
***--------------------------------------------------------------------------
***this disables solprint in cm_nash_mode=debug case by default. It is switched on in case of infes in nash/solve.gms
*RP* for faster debugging, turn solprint immediately on
$IF %cm_nash_mode% == "debug" option solprint = on ;

o_modelstat = 100;
loop(sol_itr$(sol_itr.val <= c_solver_try_max),
  if(o_modelstat ne 2,
$batinclude "./standalone/macro/include_sets.gms" solve
  )
* end of sol_itr loop, when o_modelstat is not equal to 2
);  


***---------------------------------------------------------
***     Track of changes between iterations
***---------------------------------------------------------
o_negitr_disc_cons_dr5_reg(iteration,regi) =
  sum(ttot$( (ttot.val lt 2100) AND (ttot.val gt 2005)), vm_cons.l(ttot,regi) * (0.95 ** (pm_ttot_val(ttot) - s_t_start)) * pm_ts(ttot) )
  + sum(ttot$(ttot.val eq 2005), vm_cons.l(ttot,regi) * (0.95 ** (pm_ttot_val(ttot) - s_t_start)) * pm_ts(ttot) * 0.5 ) 
  + sum(ttot$(ttot.val eq 2100), vm_cons.l(ttot,regi) * (0.95 ** (pm_ttot_val(ttot) - s_t_start)) * ( pm_ttot_val(ttot)- pm_ttot_val(ttot-1) ) *0.5 )
;
o_negitr_disc_cons_drInt_reg(iteration,regi) =
  sum(ttot$( (ttot.val lt 2100) AND (ttot.val gt 2005)), vm_cons.l(ttot,regi) * qm_budget.m(ttot,regi)/ (qm_budget.m('2005',regi) + 1.e-8) *pm_ts(ttot) )
  + sum(ttot$(ttot.val eq 2005), vm_cons.l(ttot,regi) * qm_budget.m(ttot,regi)/ (qm_budget.m('2005',regi) + 1.e-8) * pm_ts(ttot) * 0.5 ) 
  + sum(ttot$(ttot.val eq 2100), vm_cons.l(ttot,regi) * qm_budget.m(ttot,regi)/ (qm_budget.m('2005',regi) + 1.e-8) * ( pm_ttot_val(ttot)-pm_ttot_val(ttot-1) ) * 0.5 )
;

***--------------------------------------------------------------------------
***         POSTSOLVE
***--------------------------------------------------------------------------
* Write some info into the log.txt file. 
Execute "printf '\nIteration '; grep LOOPS full.log | tail -n -1 | cut -d' ' -f5; printf  'Time: '; date '+%H:%M:%S'";
$batinclude "./standalone/macro/include_declarations.gms" postsolve

*--------------------------------------------------------------------------
***                  save gdx
*--------------------------------------------------------------------------
*** write the fulldata.gdx file after each optimal iteration
*AJS* in Nash status 7 is considered optimal in that respect (see definition of
***   o_modelstat in solve.gms)
if (o_modelstat le 2,
  execute_unload 'fulldata'; !! retain gdxes of intermediate iterations by copying them using shell commands
  if (c_keep_iteration_gdxes eq 1,
    put_utility "shell" / "printf '%03i\n'" iteration.val:0:0
                          "| sed 's/\(.*\)/fulldata.gdx fulldata_\1.gdx/'"
                          "| xargs -n 2 cp"
  );
else
  execute_unload 'non_optimal';
  if (c_keep_iteration_gdxes eq 1,
    put_utility "shell" / "printf '%03i\n'" iteration.val:0:0
                          "| sed 's/\(.*\)/non_optimal.gdx non_optimal_\1.gdx/'"
                          "| xargs -n 2 cp"
  );
);

);  !! close iteration loop

$batinclude "./standalone/macro/include_equations.gms"    output
*** EOF ./main.gms
