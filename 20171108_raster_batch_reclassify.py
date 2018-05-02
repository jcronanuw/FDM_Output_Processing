#-------------------------------------------------------------------------------
# Name:        module1
# Purpose:
#
# Author:      jcronan
#
# Created:     08/11/2017
# Copyright:   (c) jcronan 2017
# Licence:     <your licence>
#-------------------------------------------------------------------------------

#fix the path to point to the directory containing your data
arcpy.env.workspace = r"C:\usfs_cronan_gis\SEF\FDM_outputs_vFP\run_102_raster"
for x in range(1101,1184):
    rastername = "r102"+str(x)
    newraster = "rd102"+str(x) #or whatever you?d like to call it
    #Con function arguments: input raster, value if true, output raster, value if false (input raster in this case), conditional statement
    arcpy.gp.Con_sa(rastername, "1", newraster, rastername, '"VALUE" > 0')
