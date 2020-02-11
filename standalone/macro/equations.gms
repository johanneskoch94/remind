*** |  (C) 2006-2019 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of REMIND and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  REMIND License Exception, version 1.0 (see LICENSE file).
*** |  Contact: remind@pik-potsdam.de
*** SOF ./standalone/macro/equations.gms"
q_costEnergySys(ttot,regi)$( ttot.val ge cm_startyear ) ..
    vm_costEnergySys(ttot,regi)
  =e=
$ifthen.emulator %emulator_energySys% == "on_1" 
    sum(ppfEn, jk_emu_yIntercept(ttot,regi,ppfEn) * vm_cesIO(ttot,regi,ppfEn) 
             + jk_emu_slope(ttot,regi,ppfEn) * vm_cesIO(ttot,regi,ppfEn)**2 / 2.0)
$elseif.emulator %emulator_energySys% == "on_1b" 
    sum(ppfEn, (jk_emu_yIntercept(ttot,regi,ppfEn) + jk_emu_slope(ttot,regi,ppfEn) * vm_cesIO(ttot,regi,ppfEn))
                * vm_cesIO(ttot,regi,ppfEn))
* $ifthen.emulator %emulator_energySys% == "on_1" 
*     sum(ppfEn, (jk_emu_slope(ttot,regi,ppfEn)*vm_cesIO(ttot,regi,ppfEn) + jk_emu_yIntercept(ttot,regi,ppfEn)) * vm_cesIO(ttot,regi,ppfEn))
$elseif.emulator %emulator_energySys% == "on_2" 
    sum(ppfEn, 
    (( jk_emu_slope(ttot,regi,ppfEn) * vm_cesIO(ttot,regi,ppfEn) + jk_emu_yIntercept(ttot,regi,ppfEn)) 
    * vm_cesIO(ttot,regi,ppfEn))$(jk_pm_cesIO(ttot,regi,ppfEn) gt jk_emu_x(ttot,regi,ppfEn))
    + 
    (( -1 * jk_emu_yIntercept(ttot,regi,ppfEn)/jk_emu_x(ttot,regi,ppfEn)**2 * vm_cesIO(ttot,regi,ppfEn)**2 
      + (jk_emu_slope(ttot,regi,ppfEn) + 2 * jk_emu_yIntercept(ttot,regi,ppfEn) / jk_emu_x(ttot,regi,ppfEn)) * vm_cesIO(ttot,regi,ppfEn)) 
    * vm_cesIO(ttot,regi,ppfEn))$(jk_pm_cesIO(ttot,regi,ppfEn) le jk_emu_x(ttot,regi,ppfEn))
    ) 
$elseif.emulator %emulator_energySys% == "on_3"
    sum(ppfEn,(jk_emu_yIntercept(ttot,regi,ppfEn) * vm_cesIO(ttot,regi,ppfEn)
             + jk_emu_slope(ttot,regi,ppfEn) * vm_cesIO(ttot,regi,ppfEn)**2 / 2.0)
             $(jk_pm_priceEnergy(ttot,regi,ppfEn) gt jk_emu_y(ttot,regi,ppfEn))
             +(jk_emu_y(ttot,regi,ppfEn) * vm_cesIO(ttot,regi,ppfEn))
             $(jk_pm_priceEnergy(ttot,regi,ppfEn) le jk_emu_y(ttot,regi,ppfEn)))
$elseif.emulator %emulator_energySys% == "on_3b"
    sum(ppfEn,(jk_emu_yIntercept(ttot,regi,ppfEn) + jk_emu_slope(ttot,regi,ppfEn) * vm_cesIO(ttot,regi,ppfEn))
                * vm_cesIO(ttot,regi,ppfEn)
             $(jk_pm_priceEnergy(ttot,regi,ppfEn) gt jk_emu_y(ttot,regi,ppfEn))
             +(jk_emu_y(ttot,regi,ppfEn) * vm_cesIO(ttot,regi,ppfEn))
             $(jk_pm_priceEnergy(ttot,regi,ppfEn) le jk_emu_y(ttot,regi,ppfEn)))  
$elseif.emulator %emulator_energySys% == "on_4"
    sum(ppfEn, 
     (( jk_emu_slope(ttot,regi,ppfEn) * vm_cesIO(ttot,regi,ppfEn) + jk_emu_yIntercept(ttot,regi,ppfEn)) * vm_cesIO(ttot,regi,ppfEn))
      $(jk_pm_priceEnergy(ttot,regi,ppfEn) gt jk_emu_y(ttot,regi,ppfEn) AND jk_pm_priceEnergy(ttot,regi,ppfEn) lt jk_emu_y2(ttot,regi,ppfEn))
     + 
     (jk_emu_y(ttot,regi,ppfEn) * vm_cesIO(ttot,regi,ppfEn))
      $(jk_pm_priceEnergy(ttot,regi,ppfEn) le jk_emu_y(ttot,regi,ppfEn))
     + 
     (jk_emu_y2(ttot,regi,ppfEn) * vm_cesIO(ttot,regi,ppfEn))
      $(jk_pm_priceEnergy(ttot,regi,ppfEn) ge jk_emu_y2(ttot,regi,ppfEn))
    ) 
$endif.emulator
;

***--------------------------------------------------
*' Total energy-emissions:
***--------------------------------------------------
*mh calculate total energy system emissions for each region and timestep:
q_emiTe(t,regi,emiTe(enty)) .. 
  vm_emiTe(t,regi,enty)
  =e=
    sum(ppfEn, jk_emi_emu_slope(t,regi,ppfEn) * vm_cesIO(t,regi,ppfEn) + jk_emi_emu_yIntercept(t,regi,ppfEn))
;



$ifthen %optimization% == "nash"
q80_budg_intertemp(regi)..
0 =e= pm_nfa_start(regi) * pm_pvp("2005","good")
  + SUM(ttot$(ttot.val ge 2005),
     pm_ts(ttot)
      * (
        SUM(trade,
              (vm_Xport(ttot,regi,trade) - vm_Mport(ttot,regi,trade)) * pm_pvp(ttot,trade)
           * ( 1 +  sm_fadeoutPriceAnticip*p80_etaXp(trade)
                   * ( (pm_Xport0(ttot,regi,trade) - p80_Mport0(ttot,regi,trade)) - (vm_Xport(ttot,regi,trade) - vm_Mport(ttot,regi,trade))
                   - p80_taxrev0(ttot,regi)$(ttot.val gt 2005)$(sameas(trade,"good")) + vm_taxrev(ttot,regi)$(ttot.val gt 2005)$(sameas(trade,"good"))
		     )
                   / (p80_normalize0(ttot,regi,trade) + sm_eps)
              )
        )
	  + pm_pvp(ttot,"good") * pm_NXagr(ttot,regi)
      )
    );


*' quadratic adjustment costs, penalizing deviations from the trade pattern of the last iteration.
q80_costAdjNash(ttot,regi)$(ttot.val ge cm_startyear)..
vm_costAdjNash(ttot,regi) =e= sum(trade,
                      pm_pvp(ttot,trade) * p80_etaAdj(trade)
                      * ( (pm_Xport0(ttot,regi,trade) - p80_Mport0(ttot,regi,trade)) - (vm_Xport(ttot,regi,trade) - vm_Mport(ttot,regi,trade))
		      )
                      * ( (pm_Xport0(ttot,regi,trade) - p80_Mport0(ttot,regi,trade)) - (vm_Xport(ttot,regi,trade) - vm_Mport(ttot,regi,trade))
		      )
                      / (p80_normalize0(ttot,regi,trade) + sm_eps)


);

$elseif %optimization% == "testOneRegi"
q80_budg_intertemp(regi).. 
0 =e=  
 SUM(ttot$(ttot.val ge 2005), 
    pm_ts(ttot) 
       * SUM(trade, 
              (vm_Xport(ttot,regi,trade)-vm_Mport(ttot,regi,trade)) * pm_pvp(ttot,trade)
              * ( 1 +  p80_etaXp(trade)
                   * ( (pm_Xport0(ttot,regi,trade) - p80_Mport0(ttot,regi,trade)) - (vm_Xport(ttot,regi,trade) - vm_Mport(ttot,regi,trade)) )
                   / (p80_normalize0(ttot,regi,trade) + 1E-6)
                )
            ) 
    );  

q80_costAdjNash(ttot,regi)$(ttot.val ge cm_startyear)..
vm_costAdjNash(ttot,regi) =e= 0;

$elseif %optimization% == "negishi"
*** trade balances for resources, goods, permits
q80_balTrade(t,trade(enty))..
  SUM(regi,  vm_Xport(t,regi,trade) - vm_Mport(t,regi,trade)) =e= 0;

*AJS initialize helper eqn. any way to get around this?
q80_budget_helper(t,regi)..
    1
  =g=
    1
;

$endif
*** EOF ./standalone/macro/equations.gms"
