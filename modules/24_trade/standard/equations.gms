*** |  (C) 2006-2019 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of REMIND and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  REMIND License Exception, version 1.0 (see LICENSE file).
*** |  Contact: remind@pik-potsdam.de
*** SOF ./modules/24_trade/standard/equations.gms

positive variable
Artificial(ttot,all_regi) "Artificial variable to find infeasability"
;
Set 
art(all_regi) "Artificail set" /"NEU"/
;
Artificial.l(ttot,"NEU") = 0;
Artificial.fx(ttot,regi)$(NOT art(regi)) = 0;

q24_costTradePe(ttot,regi)$( ttot.val ge cm_startyear ) ..
    vm_costTradePe(ttot,regi) + 1000*Artificial(ttot,regi)
  =e=
    sum(tradePe(enty), pm_costsTradePeFinancial(regi,"Mport",enty) * vm_Mport(ttot,regi,enty))
  + sum(tradePe(enty),
      (pm_costsTradePeFinancial(regi,"Xport",enty) * vm_Xport(ttot,regi,enty))
    * ( 1 
      + ( pm_costsTradePeFinancial(regi,"XportElasticity",enty)
        / sqr(pm_ttot_val(ttot)-pm_ttot_val(ttot-1))
        * ( vm_Xport(ttot,regi,enty) 
          / ( vm_Xport(ttot-1,regi,enty) + pm_costsTradePeFinancial(regi, "tradeFloor",enty) ) 
          - 1
          )
        )$( ttot.val ge max(2010, cm_startyear) )
      )
    )
;
*** EOF ./modules/24_trade/standard/equations.gms
