# !/usr/bin/awk -f
# manipulate magicc SCEN input files to add emission pulse of size_pulse (in GtC) in year specified by year_pulse
# example: "awk -f addEmissionPulse.awk -v year_pulse=2015 -v size_pulse=0 REMIND_myrun.SCEN > REMIND_myrun_new.SCEN"
# AJS 2016

BEGIN {
    
#    year_pulse = ARGV[0]
#    size_pulse = ARGV[1]
}

NR == 1 {
    $1 = $1 +2
    print " " $0
}

NR<6 && NR>1 {

    print($0)

}
#edit numbers
NR>=6 {  

    if (NF == 1) {
        region = $1
    }

    if($1 == year_pulse){
	    $1 = $1 - 1
	    for(i=1; i<= NF; i++) { printf  "%11s", $i }; printf "\n";
	    $1 = $1 + 1
	# insert pulse
    if ((region == "WORLD"  || region == "R5REF") && $1 == year_pulse) {
	    $2 = $2 + size_pulse
    }
	    for(i=1; i<= NF; i++) { printf  "%11s", $i  }; printf "\n";
	    $1 = $1 + 1
	# insert pulse
	    if ((region == "WORLD"  || region == "R5REF") && $1 == (year_pulse +1)) {
	    $2 = $2 - size_pulse
    }	    
	    for(i=1; i<= NF; i++) { printf  "%11s", $i  }; printf "\n";
    }
    else{
	print($0)
    }

}
