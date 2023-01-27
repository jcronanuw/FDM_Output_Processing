#-------------------------------------------------------------------------------
# Name:        20171101_apply_symbology_to_rasters
# Purpose:     Purpose of this script is to apply symbology from one raster
#              to all rasters within an .mxd file.
#
# Author:      Jim Cronan
#
# Created:     11/02/2017
# Copyright:   (c) jcronan 2017
# Licence:     USDA Forest Service
#Source:       https://gis.stackexchange.com/questions/91551/how-to-use-
#              consistent-symbology-between-multiple-stretched-rasters-in-
#              arcmap
#-------------------------------------------------------------------------------
#Import arcpy package
import arcpy

# read in mxd file
mxd = arcpy.mapping.MapDocument(r"C:\usfs_cronan_gis\SEF\20171101_FireProgression.mxd")

# read in all rasters in the mxd which have names starting with "rb"0
rasters = arcpy.mapping.ListLayers(mxd,"rb*")

# apply the symbology lyr file to the rasters
for r in rasters:

     arcpy.ApplySymbologyFromLayer_management(r,r"C:\usfs_cronan_gis\SEF\FDM_outputs_vFP\run_102_raster\r1022127.lyr")

mxd = arcpy.mapping.MapDocument(r"C:\usfs_cronan_gis\SEF\20171103_FireProgression.mxd")
rasters = arcpy.ListRasters(mxd,"r*")
for r in rasters:

     arcpy.ApplySymbologyFromLayer_management(r, "r1022127")



# Reference current MXD and dataframe.
mxd = arcpy.mapping.MapDocument("CURRENT")
df = arcpy.mapping.ListDataFrames(mxd, "Layers")[0]

# Layer file symbology to be imported.
in_symbology_layer = arcpy.mapping.Layer(r"C:\usfs_cronan_gis\SEF\FDM_outputs_vFP\run_102_raster\r1022127.lyr")

# Layer to receive imported symbology.
all_layers = arcpy.mapping.ListLayers(mxd)

for layer in all_layers:
    arcpy.ApplySymbologyFromLayer_management(layer, in_symbology_layer)

# Refreshes Table of Contents.
arcpy.RefreshTOC()
