#-------------------------------------------------------------------------------
#Name:		20230124_apply_symbology_to_rasters
#Derived from:	20171101_apply_symbology_to_rasters
#Purpose:	Purpose of this script is to apply symbology from one raster
#		to all rasters within an .mxd file.
#
# Author:	Jim Cronan
#
# Created:	01/24/2023
# Copyright:	(c) jcronan 2023
# Licence:	USDA Forest Service
#Sources:	https://gis.stackexchange.com/questions/91551/how-to-use-
#		consistent-symbology-between-multiple-stretched-rasters-in-
#		arcmap
#
#		AND
#
#		https://gis.stackexchange.com/questions/122470/apply-symbology-
#		to-rasters-using-arcpy-script
#-------------------------------------------------------------------------------
#Import arcpy package
import arcpy
from arcpy import env

#Set the current workspace
env.workspace = "D:\FDM_2023_Simulation_Data"
mxd = arcpy.mapping.MapDocument(r"D:\FDM_2023_Simulation_Data\Step_04_Symbology_Menu_Map\20230129_Symbology_Map_050_001.mxd")
df = arcpy.mapping.ListDataFrames(mxd, "Layers")[0]
rasters = arcpy.mapping.ListLayers(mxd, "f_*", df)

symbologyLayer = r"D:\FDM_2023_Simulation_Data\Step_04_Symbology_Menu_Map\Step_B_shapefile\symbology_map.lyr"

for ThisLayer in rasters:
	print "Working on " + ThisLayer.name
	if not ThisLayer.isBroken: # only try to work with layers that aren't broken
		print "-not broken"
		if not ThisLayer.name.upper() == symbologyLayer.upper():
			print "-not the source layer"
			# not the source layer
			if ThisLayer.isRasterLayer:
				print "-is a raster layer"
				# only applies to raster layers
				arcpy.CalculateStatistics_management(ThisLayer.dataSource)
				print "--Statistics calculated"
				arcpy.ApplySymbologyFromLayer_management(ThisLayer,symbologyLayer)
				print "--Symbology Applied"

mxd.save()
del mxd