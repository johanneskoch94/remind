#!/bin/awk -f

BEGIN {
    n_regions    = 0
    n_quantities = 0
    n_units      = 0
    
    first_year = 2005
    last_year  = 2100
    year_steps =    5
}

# Begin at line six, because this is where the data starts
NR >= 6 {
	# If there is only one item on the line, it is the region for the following lines
    if (NF == 1) {
        region = $1
        regions[++n_regions] = $1
    }

	# The line with the quantity names starts with "YEARS"   
    if ($1 == "YEARS" && n_quantities == 0)
        for (i = 2; i <= NF; ++i)
            quantities[++n_quantities] = $i

	# The line with the units starts with "Yrs"
    if ($1 == "Yrs" && n_units == 0)
        for (i = 2; i <= NF; ++i)
            units[++n_units] = $i

	# All lines starting with a number (year) contain data
    if (NF > 1 && $1 ~ /[0-9]+/) {
        years[$1] = $1

        # Convert entries to numbers by adding 0
        for (i = 2; i <= NF; ++i)
            data[region,$1,quantities[i-1]] = 0 + $i
    }
}

END {
	# Sort the years to print them in correct order
    y_ = 0
    for (y in years)
        years_[++y_] = y
        
    n_years = asort (years_)

	# Print header lines
    print "Table " table_name "(RCP_regions_world,tall,emiRCP)"
    
    printf "            "
    for (q = 1; q <= n_quantities; ++q)
        printf ("%14s", quantities[q])
    printf "\n"
    
    printf "***         "
    for (u = 1; u <= n_units; ++u)
        printf ("%14s", units[u])
    printf "\n"
    
    
    for (r = 1; r <= n_regions; ++r) {
    
        if (regions[r] == "BUNKERS" && bunkers != "yes")
            continue
            
        for (y = first_year; y <= last_year; y += year_steps) {
            printf ("%7s.%d ", regions[r], y)
            if (y in years) {
                for (q = 1; q <= n_quantities; ++q)
                    printf ("%13.6f ", data[regions[r],y,quantities[q]])
                printf "\n"
                    
            } else {
                for (y_after = 1; y_after <= n_years; ++y_after)
                    if (years_[y_after] > y)
                        break
                    
                y_before = y_after - 1
                delta_y = years_[y_after] - years_[y_before]
                
                for (q = 1; q <= n_quantities; ++q) {
                    delta_v = data[regions[r],years_[y_after],quantities[q]] - data[regions[r],years_[y_before],quantities[q]]
                    
                    value = delta_v / delta_y * (y - years_[y_before]) + data[regions[r],years_[y_before],quantities[q]]
                    
                    printf ("%13.6f ", value)
                }
                printf "\n"
            }
        }
    }
    
    print ";"
}
