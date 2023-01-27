#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#PURPOSE: This script reviews all the unique fuelbeds in the fuelbed maps prodiced by the 
#FDM simulations and identifies map that contains all fuelbeds found in other maps.
#The reason this needs to be done is so I can have a master map to assign symbology
#to fuelbeds in ArcMap and then batch apply the symbology to all the other fuelbed
#maps with python script (20230124_apply_symbology_to_rasters.py).


#Author: Jim Cronan
#Organization: US Forest Service
#Address: 
#Pacific Wildland Fire Sciences Laboratory
#400 North 34th Street
#Suite 201
#Seattle, WA 98103
#Date Created: January 27, 2023

#################################################################################################
#################################################################################################
#Open first batch of fuelbed maps

#Libraries
library(raster)


run_in <- "001" #c("001", "002", "003", "004", "005", "006", "007", "008", "009", "010")
rx_fire <- "050"
intervals <- c("05", "10", "15", "20", "25", "30", "35", "40", "45", "50")

#################################################################################################
setwd("D:/FDM_2023_Simulation_Data/Step_01_FDM_Outputs/fuelbed_maps_step_1b_short_file_names")

#Import a single raster file to use header data to reference number of columns for matrix(scan())
f.head <- raster("f_050_001_05.asc")


#for(aa in 1:length(run_in))
#{
aa <- 1

#################################################################################################
setwd(paste("C:/Users/jcronan/OneDrive - USDA/Documents/GitHub/EglinAirForceBase/inputs", 
            sep = ""))

#Open year 0 fuelbed map
f.map <- matrix(scan("sef_fmap_v2_1771x3491.txt", skip = f.head@file@offset),ncol=f.head@ncols,byrow=T)

  
  #Create shortened run identifer (2 instead of 3 integers) for outgoing file names
  run_out <- substring(run_in[aa], 2, 3)
  
  #Set up filenames for incoming FDM maps
  filenames_in <- vector()
  for(i in 1:length(intervals))
  {
    filenames_in[i] <- paste("f_", rx_fire, "_", run_in[aa], "_", intervals[i], ".asc", sep = "")
  }

  setwd("D:/FDM_2023_Simulation_Data/Step_01_FDM_Outputs/fuelbed_maps_step_1b_short_file_names")
  
  #Set up a list to hold input and output maps
  maps_in <- list()
  
  #Import .asc files
  for(i in 1:length(intervals))
  {
    maps_in[[i]] <- matrix(scan(filenames_in[i],skip = f.head@file@offset),ncol=f.head@ncols,byrow=T)
  }
  
  #Add year 0 maps to catalog of output maps
  intervals2 <- c("00", "05", "10", "15", "20", "25", "30", "35", "40", "45", "50")
  maps_in2 <- list()
  for(i in 1:length(intervals2))
  {
    if(i == 1)
    {
      maps_in2[[i]] <- f.map
    } else
    {
      maps_in2[[i]] <- maps_in[[i - 1]]
    }
  }
  
  #Remove maps_in (replaced with maps_in2)
  rm(maps_in)
  
#  }

  fuelbed_vector <- list()
  for(i in 1:length(intervals2))
  {
    fuelbed_vector[[i]] <- 
  }
  
  