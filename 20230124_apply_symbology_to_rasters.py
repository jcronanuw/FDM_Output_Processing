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
env.workspace = "C:\usfs_cronan_gis\sef"
mxd = arcpy.mapping.MapDocument(r"C:\usfs_cronan_gis\sef\20230124_FineFuels_Abs.mxd")
df = arcpy.mapping.ListDataFrames(mxd, "Layers")[0]
rasters = arcpy.mapping.ListLayers(mxd, "t050*", df)

symbologyLayer = r"C:\usfs_cronan_gis\sef\x050_01_50.lyr"

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