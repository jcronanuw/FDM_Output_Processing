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

#File name components needed to open fuelbed maps
rx_fire <- c("050", "075", "100", "125")
run_in <- c("001", "002", "003", "004", "005", "006", "007", "008", "009", "010")
intervals <- c("05", "10", "15", "20", "25", "30", "35", "40", "45", "50")

#################################################################################################
#Pull in any fuelbed map to get header data -- needed to stip header data from incoming maps.
setwd("D:/FDM_2023_Simulation_Data/Step_01_FDM_Outputs/fuelbed_maps_step_1b_short_file_names")

#Import a single raster file to use header data to reference number of columns for matrix(scan())
f.head <- raster("f_050_001_05.asc")

#################################################################################################
#Open year 0 fuelbed map.
setwd(paste("C:/Users/jcronan/OneDrive - USDA/Documents/GitHub/EglinAirForceBase/inputs", 
            sep = ""))
f.map <- matrix(scan("sef_fmap_v2_1771x3491.txt", skip = f.head@file@offset),ncol=f.head@ncols,byrow=T)

#Set up list to hold unique fuelbeds in each map
fuelbed_list <- list()

fuelbed_list[[1]] <- sort(unique(as.vector(f.map)))

#Run loop to read all fuelbed maps produced in 2022/2023 FDM simulations and strip out unique fuelbeds.
for(x in 1:length(rx_fire))#prescribed burn scenarios (n = 4)
  {
  for(y in 1:length(run_in))#simulations (n = 10)
    {
    
    #Set up filenames for incoming FDM maps
    filenames_in <- vector()
    for(i in 1:length(intervals))
      {
      filenames_in[i] <- paste("f_", rx_fire[x], "_", run_in[y], "_", intervals[i], ".asc", sep = "")
      }
    
    #Set working directory to location of simulation output maps
    setwd("D:/FDM_2023_Simulation_Data/Step_01_FDM_Outputs/fuelbed_maps_step_1b_short_file_names")
  
    #Set up a list to hold input and output maps
    maps_in <- list()

    #Import .asc files
    for(i in 1:length(intervals))
      {
      maps_in[[i]] <- matrix(scan(filenames_in[i],skip = f.head@file@offset),ncol=f.head@ncols,byrow=T)
    }
    
    #identify and store unique fuelbeds in each fuelbed map
    for(i in 1:length(intervals))
      {
      fuelbed_list[[length(fuelbed_list)+1]] <- sort(unique(as.vector(maps_in[[i]])))
    }
    rm(maps_in)
    print(paste("Rx Fire:", rx_fire[x], "Run:", run_in[y], sep = " "))
  }
}
    
#Count number of fuelbeds in each map
f_count <- vector()
for(i in 1:length(fuelbed_list))
  {
  f_count[i] <- length(fuelbed_list[[i]])
  }
  
#Plot fuelbed quantity
plot(f_count[1:11], type = "l", ylim = c(125,310), xlim = c(1,11), ylab = "No of fuelbeds", xlab = "Simulation Years", xaxt = "n")
axis(1, at = 1:11, labels = seq(0,50,5))
divs <- (401-11)/10 
start <- seq(12,392,10)
for(i in 1:divs)
{
  lines(c(f_count[1], f_count[start[i]:(start[i] + 9)]))
}

#Which map has the most fuelbeds
#Identify location on list of fuelbed map with largest number of fuelbeds
fl <- which.max(f_count)

#Create a key to identify which fuelbed map this is
map_key <- data.frame(rx_fire = c(100, rep(50,100), rep(75,100), rep(100,100), rep(125,100)),
                      run = c(0, rep(c(rep(1,10), rep(2,10), rep(3,10), rep(4,10), rep(5,10), rep(6,10), rep(7,10), rep(8,10), rep(9,10), rep(10,10)), 4)),
                      year = c(0, rep(c(5,10,15,20,25,30,35,40,45,50),40)))

#Fin the fuelbed map  
map_key[fl,]


#Do any fuelbed maps have fuelbeds not represnted in this map
test_maps <- vector()
for(i in 1:length(f_count))
{
  test_maps[i] <- length(sort(unique(is.na(match(fuelbed_list[[i]], fuelbed_list[[fl]])))))
}
length(test_maps[test_maps == 1])
#Almost all the maps have fuelbeds not represented in the map with the most fuelbeds.

#How many fuelbeds are there among all the maps?
fuelbeds <- unlist(fuelbed_list)
unique_fuelbed <- sort(unique(fuelbeds))
length(unique_fuelbed)

#Create a master fuelbed map with all fuelbeds for symbology by adding unrepresented fuelbeds to map that already has the most fuelbeds

#Re-import fuelbed map with most fuelbeds (Rx Fire Scenario: 75k acres, Run 004, Year: 50).
max_fccs <- matrix(scan(paste("f_0", map_key[fl,1], "_00", map_key[fl,2], "_", map_key[fl,3], ".asc", sep = ""), skip = f.head@file@offset),ncol=f.head@ncols,byrow=T)

#Find a fuelbed with wide coverage so pixels can be replaced with additional fuelbeds without completely erasing replaced fuelbeds.
mfv <- as.vector(max_fccs)
fbs <- sort(unique(mfv))

count_fccs <- vector()

for(i in 1:length(fbs))
{
  count_fccs[i] <- length(mfv[mfv == fbs[i]])
}

#The 41st fuelbed occupies tons of pixels, use this one.
count_fccs
#List fuelbed
fbs[41]
#1051406: Baygall

#Figure out which fuelbeds need to be manually added to this map
list_fccs <- list()

#Cycle through each list of fuelbeds and find fuelbeds not represneted in the map with the most fuelbeds
for(i in 1:length(fuelbed_list))
{
  id_fccs <- match(fuelbed_list[[i]], fuelbed_list[[fl]])
  list_fccs[[i]] <- fuelbed_list[[i]][is.na(id_fccs)]
  rm(id_fccs)
  }

#Unlist the list
all_fccs <- unlist(list_fccs)

#Pare down to list of unique fuelbeds
unique_fccs <- sort(unique(all_fccs))

#Total number of fuelbeds between map with most fuelbeds and fuelbeds in other maps
length(unique_fccs) + length(fuelbed_list[[141]])  
  
#Above number should be equal to this, the total number of unique fuelbeds in all simulation maps.
length(unique_fuelbed)
  
#Replace pixels containing fuelbed 1051406 with unrepresneted fuelbeds

#List locations
coords <- which(max_fccs == fbs[41])

#Randomly select one coordinate for each unrepresneted fuelbed
re_coord <- sample(coords,length(unique_fccs))

#Insert missing fuelbeds in one randomly selected pixel containing fuelbed 1051406
for(i in 1:length(unique_fccs))
  {
  max_fccs[re_coord[i]] <- unique_fccs[i]
  }
  
#################################################################################################
#Get metadata to save map
setwd("C:/Users/jcronan/OneDrive - USDA/Documents/GitHub/FDM-Eglin-Analysis/inputs")

##Open metadata for spatial datasets
metadata <- read.table(paste("eglin_raster_metadata.txt", sep = ""), 
                       header=TRUE, sep=",", na.strings="NA", dec=".", strip.white=TRUE)
  
#################################################################################################
#################################################################################################
#Create vectors from metadata list
md.desc <- as.vector(unlist(metadata[,1]))
md.valu <- as.vector(unlist(metadata[,2]))

#Seprate header metadata into seperate lines.
line1 <- paste(paste(md.desc[1]), paste("         ", md.valu[1]))
line2 <- paste(paste(md.desc[2]), paste("         ", md.valu[2]))
line3 <- paste(paste(md.desc[3]), paste("     ", md.valu[3]))
line4 <- paste(paste(md.desc[4]), paste("     ", md.valu[4]))
line5 <- paste(paste(md.desc[5]), paste("      ", md.valu[5]))
line6 <- paste(paste(md.desc[6]), paste("  ", md.valu[6]))
  
#Save stand map.
#Combine metadata and pixel attribute into a single vector.
a <- c(line1, line2, line3, line4, line5, line6, t(max_fccs))

#Name file
file <- "symbology_map.asc"
setwd("D:/FDM_2023_Simulation_Data/Step_04_Symbology_Menu_Map")
write.table(a, file=file, row.names=FALSE, col.names=FALSE, sep=", ",
            append=TRUE, quote=FALSE)
  
  
  
  
  
  
  
  
  