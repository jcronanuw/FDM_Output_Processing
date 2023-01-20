#Purpose of this script is to shorten the file names of the FDM fuelbed and stand number map files (.asc). Total
#character length cannot exceed 13 for downstream python bathc processing script (20170929_ascii_to_raster_batch.py).
#James Cronan
#US Forest Service
#Date written: 19-January-2023

library(reticulate)

#Open data
setwd("E:/FS_Desktop/D_Drive/usfs_cronan_gis/SEF/FDM_Dissertation_Runs/fdm_out_asc")



old_file <- list.files (pattern = "*.asc", full.names = F) 

new_file <- vector()
for(i in 1:length(old_file))
{
  new_file[i] <- paste(substring(old_file[i],1,1), "_", substring(old_file[i],5,7), "_", 
                       substring(old_file[i],10,12), "_", substring(old_file[i],16,17), ".asc", sep = "")
}


file.rename(from = old_file, to = new_file)

#Open data
setwd("C:/Users/jcronan/OneDrive - USDA/Documents/GitHub/FDM_Output_Processing")
py_run_file("20170929_ascii_to_raster_batch")

