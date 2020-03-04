CREATE PROC [dbo].[ValidateLPConfigCapitalCall](@callid INT)
AS
     SELECT SUBSTRING(
     (
         SELECT ',' + Name
         FROM
         (
             SELECT DISTINCT 
                    dbo.F_GetObjectModuleName(lp.objectid, lp.moduleid) Name
             FROM tbl_capitalcall c
                  JOIN tbl_capitalcalllimitedpartner cc ON c.capitalcallid = cc.capitalcallid
                  JOIN tbl_limitedpartner lp ON lp.limitedpartnerid = cc.limitedpartnerid
             WHERE c.capitalcallid = @callid
                   AND NOT EXISTS
             (
                 SELECT TOP 1 1
                 FROM tbl_lptemplateconfig conf
                      JOIN tbl_lptemplateconfigdetail confDetail ON conf.LPTemplateConfigID = confDetail.LPTemplateConfigID
                 WHERE confDetail.objectid = lp.objectid
                       AND confDetail.moduleid = lp.moduleid
                       AND conf.documenttypeid = 1
                       AND conf.vehicleid = c.fundid
             )
         ) t
         ORDER BY t.Name FOR XML PATH('')
     ), 2, 200000) AS CSV;
