*** |  (C) 2006-2019 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of REMIND and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  REMIND License Exception, version 1.0 (see LICENSE file).
*** |  Contact: remind@pik-potsdam.de
*** SOF ./standalone/macro/presolve.gms"
***--------------------------------------
*** MAC costs
***--------------------------------------
*** Integral under MAC cost curve
*** costs = baseline emissions * price step * sum [over i to n] (q_n - q_i)
*** q_i = abatement [fraction] at step i
pm_macCost(ttot,regi,emiMacSector(enty)) 
  = 1e-3 
  * pm_macCostSwitch(enty)
  * p_emi_quan_conv_ar4(enty)
  * vm_macBase.l(ttot,regi,enty) 
  * sm_dmac 
  * ( ( sum(emiMac2mac(enty,enty2),
          pm_macStep(ttot,regi,enty2)
        )
      * sum(steps$( ord(steps) eq sum(emiMac2mac(enty,enty2),
                                    pm_macStep(ttot,regi,enty2)) ),
          sum(emiMac2mac(enty,enty2), pm_macAbat(ttot,regi,enty2,steps))
        )
      )
    - sum(steps$( ord(steps) le sum(emiMac2mac(enty,enty2),
                                  pm_macStep(ttot,regi,enty2)) ),
        sum(emiMac2mac(enty,enty2), pm_macAbat(ttot,regi,enty2,steps))
      )
    );
*** EOF ./standalone/macro/presolve.gms"
