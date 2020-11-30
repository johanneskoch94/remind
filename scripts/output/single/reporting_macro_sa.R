# |  (C) 2006-2019 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of REMIND and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  REMIND License Exception, version 1.0 (see LICENSE file).
# |  Contact: remind@pik-potsdam.de


# Check for an object called "source_include". If found, that means, this script
# is being called from another (output.R most likely), and the input variable 
# "outputdir" is already in the environment. If not found, "outputdir" is given
# default values, and made over-writable with the command line.
if(!exists("source_include")) {
  # Set default value
  outputdir <- c(" ")   
  # Make over-writtable from command line
  lucode2::readArgs("outputdir")
  
}



gdx_name     <- "fulldata.gdx"        # name of the gdx  
gdx_ref_name <- "input_ref.gdx"       # name of the reference gdx (for policy cost calculation)
gdx      <- fs::path(outputdir,gdx_name)
gdx_ref  <- fs::path(outputdir,gdx_ref_name)
if(!file.exists(gdx_ref)) { gdx_ref <- NULL }
scenario <- lucode2::getScenNames(outputdir)



# generate REMIND reporting
remind_reporting_file <- fs::path(outputdir,paste0("REMIND_generic_",scenario,".mif"))

t <- c(seq(2005,2060,5),seq(2070,2110,10),2130,2150)
regionSubsetList <- remind:::toolRegionSubsets(gdx)    
output <- remind::reportMacroEconomy(gdx,regionSubsetList)[,t,]
magclass::getSets(output)[3] <- "variable"
output <- magclass::add_dimension(output,dim=3.1,add = "model",nm = "REMIND")
output <- magclass::add_dimension(output,dim=3.1,add = "scenario",nm = scenario)
magclass::write.report(output,file=remind_reporting_file,ndigit=7)




# generate MAGICC reporting
magicc_reporting_file <- fs::path(outputdir,paste0("REMIND_climate_", scenario, ".mif"))
if (0 == nchar(Sys.getenv('MAGICC_BINARY'))) {
  warning('Can\'t find magicc executable under environment variable MAGICC_BINARY')
} else {
  system(paste("cd ",outputdir ,"/magicc; ",
             "pwd;",
             "sed -f modify_MAGCFG_USER_CFG.sed -i MAGCFG_USER.CFG; ",
             Sys.getenv('MAGICC_BINARY'), '; ',
             "awk -f MAGICC_reporting.awk -v c_expname=\"", scenario, "\"",
             " < climate_reporting_template.txt ",
             " > ","../../../", magicc_reporting_file,"; ",
             "sed -i 's/glob/World/g' ","../../../", magicc_reporting_file, "; ",
             sep = ""))
}


# generate macro_sa reporting
# of <- c(paste0("/p/tmp/jokoch/remind/",outputdir,"/"))
# 
# rmarkdown::render("scripts/output/single/notebook_templates/compare_macro.Rmd",
#                   params = list(output_folders = of),
#                   output_file = paste0("../../../../",outputdir,"/macro_report.html"))
