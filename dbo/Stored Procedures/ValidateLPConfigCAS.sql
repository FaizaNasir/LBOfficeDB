CREATE PROC [dbo].[ValidateLPConfigCAS](@vehicleNAVid INT)
AS
     SELECT SUBSTRING(
     (
         SELECT ',' + Name
         FROM
         (
             SELECT DISTINCT 
                    dbo.F_GetObjectModuleName(lp.objectid, lp.moduleid) Name
             FROM tbl_vehiclenav c
                  JOIN tbl_vehiclenavlimitedpartner cc ON c.vehicleNAVid = cc.vehicleNAVid
                  JOIN tbl_limitedpartner lp ON lp.limitedpartnerid = cc.limitedpartnerid
             WHERE c.vehicleNAVid = @vehicleNAVid
                   AND NOT EXISTS
             (
                 SELECT TOP 1 1
                 FROM tbl_lptemplateconfig conf
                      JOIN tbl_lptemplateconfigdetail confDetail ON conf.LPTemplateConfigID = confDetail.LPTemplateConfigID
                 WHERE confDetail.objectid = lp.objectid
                       AND confDetail.moduleid = lp.moduleid
                       AND conf.documenttypeid = 3
                       AND conf.vehicleid = c.vehicleid
             )
         ) t
         ORDER BY t.Name FOR XML PATH('')
     ), 2, 200000) AS CSV;
