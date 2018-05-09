# Purpose of this code is to batch process fuelbed map outputs from FDM v.2.0
# Output file requirements:
# 1) Save as ascii files (.asc)
# 2) File name cannot be longer than 13 characters and cannot have decimals in the name
# 3) Header information must be properly entered and formatted

# Code below has been modified from:
# https://community.esri.com/thread/46801 (see code repost by tiggs03 Mar 6, 2012.

# Import system modules
import arcgisscripting, os

# Create the Geoprocessor object
gp = arcgisscripting.create()

# Set local variables
InAsciiFile = None
inDir = r"C:\usfs_cronan_gis\SEF\FDM_outputs_vFP\run_102"
OutRaster = "C:\usfs_cronan_gis\SEF\FDM_outputs_vFP\\run_102_raster"
#5/8/2018 -- not sure why, but if the \\run is a single slash it will generate an error in os.path.join() below. For some reason with one slash it is removed.
#This was not a problem with the previous version
gp.outputCoordinateSystem = r"C:\usfs_cronan_gis\SEF\FDM_outputs\run_d45c.prj"

for InAsciiFile in os.listdir(inDir):
    if InAsciiFile.rsplit(".")[-1] == "asc":
        print InAsciiFile
        # Process: ASCIIToRaster_conversion
        gp.ASCIIToRaster_conversion(os.path.join(inDir,InAsciiFile), os.path.join(OutRaster,InAsciiFile.rsplit(".")[0]), "INTEGER")

# see error you fixed above. Merge this with other versions of this script.