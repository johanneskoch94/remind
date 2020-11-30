*** |  (C) 2006-2019 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of REMIND and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  REMIND License Exception, version 1.0 (see LICENSE file).
*** |  Contact: remind@pik-potsdam.de
*** SOF ./standalone/macro/set_calculations.gms"
Scalar
  sm_tmp           "temporary scalar that can be used locally"
  sm_tmp2          "temporary scalar that can be used locally" 
;

regi(all_regi) = YES;
display regi;


entyFe(enty) = entyFeStat(enty) + entyFeTrans(enty);

*** calculate primary production factors (ppf)
ppf(all_in) = ppfEn(all_in) + ppfKap(all_in);
*** add labour to the primary production factors (ppf)
ppf("lab")  = YES;

*** calculate intermediate production factors
ipf(all_in) = in(all_in) - ppf(all_in);
ipf_putty(all_in) = in_putty(all_in) - ppf_putty(all_in);
loop ( out,
ppfIO_putty(in)$(cesOut2cesIn(out,in)
                  AND ipf_putty(in)
                  AND NOT in_putty(out))          = YES;
);
*** Initialise cesLevel2cesIO and cesRev2cesIO
loop (counter$( ord(counter) eq 1 ),
  cesLevel2cesIO(counter,"inco") = YES;   !! the root is at the lowest level
  sm_tmp = counter.val;              !! used here to track total depth in the tree
); 

loop ((counter,cesOut2cesIn(out,in)),    !! loop over all out/in combinations
  if (cesLevel2cesIO(counter-1,out),    !! if out was an input on the last level
    cesLevel2cesIO(counter,in) = YES;   !! in is an input on this level

    if (counter.val gt sm_tmp,   !! store deepest level reached
      sm_tmp = counter.val;
    )
  )
);

loop (counter$( counter.val eq sm_tmp ),
  cesRev2cesIO(counter,"inco") = YES;
);

for (sm_tmp = sm_tmp downto 0,
  loop ((counter,cesOut2cesIn(out,in))$( counter.val eq sm_tmp ),
    if (cesRev2cesIO(counter + 1,out),
      cesRev2cesIO(counter,in) = YES;
    )
  )
);

*** Compute all the elements of the CES below out, iteratively
loop( cesOut2cesIn(out,ppf(in)),
cesOut2cesIn_below(out,in) = YES;
);

loop ((cesRev2cesIO(counter,in),cesOut2cesIn(in,in2)),

 loop(in3,
 cesOut2cesIn_below(in,in3)$ (cesOut2cesIn_below(in2,in3)) = YES;
);
cesOut2cesIn_below(in,in2) = YES;
);

in_below_putty(in) = NO;
loop (ppf_putty,
in_below_putty(in)$cesOut2cesIn_below(ppf_putty,in) = YES;
);

*** Aliasing of mappings is not available in all GAMS versions
cesOut2cesIn2(out,in) = cesOut2cesIn(out,in);

*** Computing the reference complentary factors
$offOrder
sm_tmp = 0;
loop (cesOut2cesIn(out,in) $ in_complements(in),
  if ( NOT ord(out) eq sm_tmp,
  sm_tmp = ord(out);
  loop (cesOut2cesIn2(out,in2),
        complements_ref(in,in2) = YES;
        );
     );
     );
$onOrder

display "production function sets", cesOut2cesIn, cesOut2cesIn2, cesLevel2cesIO, cesRev2cesIO, ppf, ppfEn, ipf;


emiMacMagpie(enty)   = emiMacMagpieCH4(enty) + emiMacMagpieN2O(enty) + emiMacMagpieCO2(enty);
emiMacExo(enty)      = emiMacExoCH4(enty) + emiMacExoN2O(enty);



*** MAGICC related sets
t_magiccttot(tall) = ttot(tall) + t_extra(tall);
t_magicc(t_magiccttot)$(t_magiccttot.val ge 2005) = Yes;

*** EOF ./standalone/macro/set_calculations.gms"
