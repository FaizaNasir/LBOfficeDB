
-- exec [dbo].[proc_LP_Grid] @LPID=NULL,@vehicleID=99,@objectID=NULL,@moduleID=NULL

CREATE PROC [dbo].[proc_LP_Grid]
(@LPID      INT, 
 @vehicleID INT, 
 @objectID  INT, 
 @moduleID  INT
)
AS
    BEGIN
        DECLARE @result TABLE
        (LimitedPartnerID INT, 
         ModuleID         INT, 
         ObjectID         INT, 
         ObjectName       VARCHAR(1000), 
         TotalAmount      DECIMAL(18, 3), 
         SharesName       VARCHAR(5000), 
         SharesBreakDown  VARCHAR(5000)
        );
        IF @vehicleID = 0
            SET @vehicleID = NULL;
        INSERT INTO @result
               SELECT MIN(LimitedPartnerID) LimitedPartnerID, 
                      ModuleID, 
                      ObjectID, 
                      ObjectName, 
                      dbo.[F_LPTotalCommitment](ObjectID, ModuleID, VehicleID, NULL) TotalAmount, 
                      MAX(SharesName), 
                      MAX(SharesBreakDown)
               FROM
               (
                   SELECT lp.ModuleID, 
                          lp.LimitedPartnerID, 
                          lp.ObjectID, 
                          lp.VehicleID, 
                          dbo.F_GetObjectName(lp.ModuleID, lp.ObjectID) ObjectName, 
                          STUFF(
                   (
                       SELECT '; ' + CAST(innvs.ShareName AS VARCHAR(MAX)) [text()]
                       FROM tbl_vehicleshare innvs
                       WHERE innvs.VehicleID = @VehicleID FOR XML PATH(''), TYPE
                   ).value('.', 'NVARCHAR(MAX)'), 1, 2, ' ') SharesName, 
                          STUFF(
                   (
                       SELECT '; ' + CAST(MAX(innvs.ShareName) AS VARCHAR(MAX)) + ',' + CAST(SUM(inncc.Amount) AS VARCHAR(MAX)) [text()]
                       FROM tbl_LimitedPartnerDetail inncc
                            JOIN tbl_LimitedPartner innccal ON inncc.LimitedPartnerID = innccal.LimitedPartnerID
                            JOIN tbl_vehicleshare innvs ON innvs.VehicleShareID = inncc.ShareID
                       WHERE innccal.VehicleID = @VehicleID
                             AND innccal.ObjectID = lp.ObjectID
                       GROUP BY ShareID FOR XML PATH(''), TYPE
                   ).value('.', 'NVARCHAR(MAX)'), 1, 2, ' ') SharesBreakDown
                   FROM tbl_LimitedPartner lp
                   WHERE LimitedPartnerID = ISNULL(@LPID, LimitedPartnerID)
                         AND ObjectID = ISNULL(@objectID, ObjectID)
                         AND ModuleID = ISNULL(@moduleID, ModuleID)
                         AND lp.VehicleID = ISNULL(@vehicleID, VehicleID)
               ) t
               GROUP BY ModuleID, 
                        ObjectID, 
                        VehicleID, 
                        ObjectName;
        SELECT *, 
               CAST(TotalAmount / (CASE
                                       WHEN ISNULL(
        (
            SELECT SUM(TotalAmount)
            FROM @result
        ), 0) = 0
                                       THEN 1
                                       ELSE
        (
            SELECT SUM(TotalAmount)
            FROM @result
        )
                                   END) * 100 AS DECIMAL(18, 4)) Ownd
        FROM @result
        ORDER BY ObjectName;
    END;
