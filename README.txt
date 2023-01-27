#Order of operations for post processing
#Jim Cronan
#US Forest Service
#19-January-2023

1. Output fuelbed and stand number maps produced by FDM(1) have file names that exceed the length that can be processed by
the batch processing python script(2) that produces raster files that can be read into ArcGIS.
1_fdm_outputs_short_filenames directory contains a copy of all the 2023 FDM output files produced from October 2022 through
January 2023. A short name-change R script(3) has been run on these files to shorten their names while retaining identifying 
information (i.e., fuelbed or stand map, annual area burned with prescribed fire in 100k acres, simulation number (001-010), and 
simulation year (05, 10, 15, 20, 25, 30, 35, 40, 45, and 50))

(1) C:\Users\jcronan\OneDrive - USDA\Documents\GitHub\EglinAirForceBase\sef_FDM_v2.0
(2) C:\Users\jcronan\OneDrive - USDA\Documents\GitHub\FDM_Output_Processing\20170929_ascii_to_raster_batch
(3) C:\Users\jcronan\OneDrive - USDA\Documents\GitHub\FDM_Output_Processing\20230119_Post_Processing_Shorten_ascii_fileNames

In short, the files in this folder are replicas of the output map files from the FDM simulations, they just have different
names so they can be processed with the python script (2).