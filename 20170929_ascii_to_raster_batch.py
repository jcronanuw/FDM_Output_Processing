# Purpose of this code is to batch process fuelbed map outputs from FDM v.2.0
# Output file requirements:
# 1) Save as ascii files (.asc)
# 2) File name cannot be longer than 13 characters and cannot have decimals in the name
# 3) Header information must be properly entered and formatted

# Code below has been modified from:
# https://community.esri.com/thread/46801 (see code repost by tiggs03 -- Mar 6, 2012).

# Import system modules
import arcgisscripting, os, arcpy

# Create the Geoprocessor object
gp = arcgisscripting.create()

# Set local variables
InAsciiFile = None
inDir = r"D:\FDM_2023_Simulation_Data\Step_01_FDM_Outputs\fuelbed_maps_step_1b_short_file_names"
OutRaster = "D:\FDM_2023_Simulation_Data\Step_03_Shapefiles\\fuelbed_maps"
gp.outputCoordinateSystem = r"C:\Users\jcronan\OneDrive - USDA\Documents\GitHub\FDM_Output_Processing\inputs\NAD_1983_UTM_Zone_16N_coordinate_system.prj"#lost code I used to create this .prj file, but shouldn't need it now that I have one.

for InAsciiFile in os.listdir(inDir):
    if InAsciiFile.rsplit(".")[-1] == "asc":
        print InAsciiFile
        # Process: ASCIIToRaster_conversion
        gp.ASCIIToRaster_conversion(os.path.join(inDir,InAsciiFile), os.path.join(OutRaster,InAsciiFile.rsplit(".")[0]), "INTEGER")
