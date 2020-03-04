CREATE PROC [dbo].[ValidateLPConfigDistribution](@distributionid INT)
AS
     SELECT SUBSTRING(
     (
         SELECT ',' + Name
         FROM
         (
             SELECT DISTINCT 
                    dbo.F_GetObjectModuleName(lp.objectid, lp.moduleid) Name
             FROM tbl_distribution c
                  JOIN tbl_distributionlimitedpartner cc ON c.distributionid = cc.distributionid
                  JOIN tbl_limitedpartner lp ON lp.limitedpartnerid = cc.limitedpartnerid
             WHERE c.distributionid = @distributionid
                   AND NOT EXISTS
             (
                 SELECT TOP 1 1
                 FROM tbl_lptemplateconfig conf
                      JOIN tbl_lptemplateconfigdetail confDetail ON conf.LPTemplateConfigID = confDetail.LPTemplateConfigID
                 WHERE confDetail.objectid = lp.objectid
                       AND confDetail.moduleid = lp.moduleid
                       AND conf.documenttypeid = 2
                       AND conf.vehicleid = c.fundid
             )
         ) t
         ORDER BY t.Name FOR XML PATH('')
     ), 2, 200000) AS CSV;
