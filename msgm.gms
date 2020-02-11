* Uncomment the following line if executing this file independently from the rest of REMIND.
* $declareAndLoad "output/SSP2-NPi2025_def_2026-02-04_11.55.39/fulldata.gdx"

Sets
msgm                  "Final energy resolution of multi-sector growth model (MSGM)"   /"fetot", "feel", "fenoel"/
esm2msgm(entyFe,msgm) "Interface between ESM and MSGM" /  
  fegas.fetot
  fehos.fetot
  fesos.fetot
  feels.fetot
  fehes.fetot
  feh2s.fetot
  fepet.fetot
  fedie.fetot
  feh2t.fetot
  feelt.fetot
  fegat.fetot
  fegas.fenoel
  fehos.fenoel
  fesos.fenoel
  fehes.fenoel
  feh2s.fenoel
  fepet.fenoel
  fedie.fenoel
  feh2t.fenoel
  fegat.fenoel
  feels.feel
  feelt.feel
/
;

Parameters
o_FEPrice(ttot,all_regi,entyFe)    "Same as p_FEPrice_by_FE but computed more elegantly [tr$2005/TWa]"
o_demFE(ttot,all_regi,entyFe)      "Total FE demand [TWa]"
o_FEPrice_MSGM(ttot,all_regi,msgm) "MSGM prices (weighted averages of o_FEPrice) [tr$2005/TWa]"
o_demFE_MSGM(ttot,all_regi,msgm)   "MSGM FE amounts [TWa]"
o_emiCO2_MSGM(ttot,all_regi,msgm)  "MSGM co2 emission from the energy sector"
o_emiCO2_nES_MSGM(ttot,all_regi)   "MSGM co2 emission from outside of the energy sector"
o_inv_energy_supply(ttot,all_regi) "Energy supply investments"
o_inv_energy_supply_fossil(ttot,all_regi) "Energy supply investments into fossil fuel techs"
;

** First compute helper FE demand and prices parameters
o_demFE(t,regi,entyFe) = sum((entySE,sector,emiMkt), vm_demFEsector.l(t,regi,entySE,entyFE,sector,emiMkt));

** Same as p_FEPrice_by_FE but more elegant (marginal prices of aggregates equal to minimal non-zero marginal price of full equation marginal)
*** Have to condition the lhs as well, otherwise smin will return INF in case the set condition excludes all prices
o_FEPrice(t,regi,entyFe)$(
    smax((entySe,sector,emiMkt), p_FEPrice_by_SE_Sector_EmiMkt(t,regi,entySe,entyFe,sector,emiMkt)) > 0
  ) 
  = 
    smin((entySe,sector,emiMkt)$(p_FEPrice_by_SE_Sector_EmiMkt(t,regi,entySe,entyFe,sector,emiMkt) > 0),
         p_FEPrice_by_SE_Sector_EmiMkt(t,regi,entySe,entyFe,sector,emiMkt)
);

** Then compute the same with the correct aggregation
o_demFE_MSGM(t,regi,msgm) = sum((esm2msgm(entyFe,msgm)), o_demFE(t,regi,entyFe));
** Take the weighted average of the FE prices for the MSGM prices
o_FEPrice_MSGM(t,regi,msgm) = sum((esm2msgm(entyFe,msgm)), o_FEPrice(t,regi,entyFe) *  o_demFE(t,regi,entyFe)) 
                              / o_demFE_MSGM(t,regi,msgm);

** For the emissions, take emiTe as proxy for Emi|CO2|+|Energy (not quite), and take the diff to vm_emiAll
** to get the non-energy system CO2 emissions.
o_emiCO2_MSGM(t,regi,"fetot") = vm_emiTe.l(t,regi,"co2");
o_emiCO2_MSGM(t,regi,"feel") = sum(pe2se(entyPe,"seel",te), 
                                   pm_emifac(t,regi,entyPe,"seel",te,"co2") * vm_demPE.l(t,regi,entyPe,"seel",te));
o_emiCO2_MSGM(t,regi,"fenoel") = o_emiCO2_MSGM(t,regi,"fetot") - o_emiCO2_MSGM(t,regi,"feel");
o_emiCO2_nES_MSGM(t,regi) = vm_emiAll.l(t,regi,"co2") - o_emiCO2_MSGM(t,regi,"fetot");

** Compute energy supply investments
o_inv_energy_supply(t,regi) = 
  sum(en2en(enty,enty2,te)$(not tePrc(te)), vm_costInvTeDir.l(t,regi,te) + vm_costInvTeAdj.l(t,regi,te))
  + sum(teNoTransform, vm_costInvTeDir.l(t,regi,teNoTransform) + vm_costInvTeAdj.l(t,regi,teNoTransform));

o_inv_energy_supply_fossil(t,regi) = 
  sum(en2en(enty,enty2,te)$(not tePrc(te) AND peFos(enty)), vm_costInvTeDir.l(t,regi,te) + vm_costInvTeAdj.l(t,regi,te))
  + sum(teNoTransform, vm_costInvTeDir.l(t,regi,teNoTransform) + vm_costInvTeAdj.l(t,regi,teNoTransform));

execute_unload "fulldata";
