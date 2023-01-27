#Purpose of this script is to shorten the file names of the FDM fuelbed and stand number map files (.asc). Total
#character length cannot exceed 13 for downstream python bathc processing script (20170929_ascii_to_raster_batch.py).
#James Cronan
#US Forest Service
#Date written: 19-January-2023

library(reticulate)

#Open data

#Set working directory
setwd("D:/2023_FDM_Simulation_Data/Step_01_FDM_Outputs/fuelbed_maps")

#Identify all files
old_file <- list.files (pattern = "*.asc", full.names = F) 

#Generate new file names
new_file <- vector()
for(i in 1:length(old_file))
{
  new_file[i] <- paste(substring(old_file[i],1,1), "_", substring(old_file[i],5,7), "_", 
                       substring(old_file[i],10,12), "_", substring(old_file[i],16,17), ".asc", sep = "")
}

#Replace old file names with new ones.
file.rename(from = old_file, to = new_file)

#END