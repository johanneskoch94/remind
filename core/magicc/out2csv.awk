#!/bin/awk -f

BEGIN {
    c_expname  = "testname"
    filename = ""
    q = 0
    
    # Read out/REMIND_generic_expname.csv to get reporting periods
    getline header < "REMIND_generic_testname.csv"

    n_header_fields = split (header, header_fields, ";")

    for (i = 1; i <= n_header_fields && header_fields[i] !~ /[0-9]+/; ++i) ;
        
    for (j = 0; i <= n_header_fields && header_fields[i]  ~ /[0-9]+/; ++i)
        periods[++j] = header_fields[i]
        
    n_periods = j;    
}

filename != FILENAME {
    filename = FILENAME
    
    if (filename == "DAT_SURFACE_TEMP.OUT") {
        quantities[++q] = "Temperature|Global Mean"
        units[q]        = "°C"
    } else if (filename == "DAT_CO2_CONC.OUT") {
        quantities[++q] = "Concentration|CO2"
        units[q]        = "ppm"
    } else if (filename == "DAT_CH4_CONC.OUT") {
        quantities[++q] = "Concentration|CH4"
        units[q]        = "ppb"
    } else if (filename == "DAT_N2O_CONC.OUT") {
        quantities[++q] = "Concentration|N2O"
        units[q]        = "ppb"
    } else if (filename == "DAT_TOTAL_ANTHRO_RF.OUT") {
        quantities[++q] = "Forcing"
        units[q]        = "W/m2"
    } else if (filename == "DAT_MHALOSUM_RF.OUT") {
	quantities[++q] = "Forcing|Montreal Gases"
	units[q]        = "W/m2"
    } else if (filename == "DAT_CO2_RF.OUT") {
	quantities[++q] = "Forcing|CO2"
	units[q]        = "W/m2"
    } else if (filename == "DAT_CH4_RF.OUT") {
	quantities[++q] = "Forcing|CH4"
	units[q]        = "W/m2"
    } else if (filename == "DAT_N2O_RF.OUT") {
	quantities[++q] = "Forcing|N2O"
	units[q]        = "W/m2"
    } else if (filename == "DAT_FGASSUM_RF.OUT") {
	quantities[++q] = "Forcing|F-Gases"
	units[q]        = "W/m2"
    } else if (filename == "DAT_SOXI_RF.OUT") {
	quantities[++q] = "Forcing|Aerosol|Sulfate Direct"
	units[q]        = "W/m2"
    } else if (filename == "DAT_CLOUD_TOT_RF.OUT") {
	quantities[++q] = "Forcing|Aerosol|Cloud Indirect"
	units[q]        = "W/m2"
    } else if (filename == "DAT_TROPOZ_RF.OUT") {
	quantities[++q] = "Forcing|Tropospheric Ozone"
	units[q]        = "W/m2"
    } else if (filename == "DAT_NOXI_RF.OUT") {
	quantities[++q] = "Forcing|Aerosol|Nitrate Direct"
	units[q]        = "W/m2"
    } else if (filename == "DAT_BCI_RF.OUT") {
	quantities[++q] = "Forcing|Aerosol|BCI"
	units[q]        = "W/m2"
    } else if (filename == "DAT_OCI_RF.OUT") {
	quantities[++q] = "Forcing|Aerosol|OCI"
	units[q]        = "W/m2"
    } else if (filename == "DAT_BCSNOW_RF.OUT") {
	quantities[++q] = "Forcing|Aerosol|BC on snow"
	units[q]        = "W/m2"
    } else if (filename == "DAT_BIOMASSAER_RF.OUT") {
	quantities[++q] = "Forcing|Aerosol|Biomass burning aerosol"
	units[q]        = "W/m2"
    } else if (filename == "DAT_STRATOZ_RF.OUT") {
	quantities[++q] = "Forcing|Stratospheric Ozone"
	units[q]        = "W/m2"
    } else if (filename == "DAT_LANDUSE_RF.OUT") {
	quantities[++q] = "Forcing|Albedo Change"
	units[q]        = "W/m2"
    } else if (filename == "DAT_MINERALDUST_RF.OUT") {
	quantities[++q] = "Forcing|Mineral Dust"
	units[q]        = "W/m2"
    }
}

filename == FILENAME && NR >= 21 {
    data[quantities[q],$1] += $2    
}

END {
    print header
    
    for (; q > 0; --q) {
        printf "REMIND;"c_expname ";WORLD;" quantities[q] ";" units[q]
        
        for (i = 1; i <= n_periods; ++i) {
            printf ";" data[quantities[q],periods[i]]
        }
        
        printf "\n"
    }
}
