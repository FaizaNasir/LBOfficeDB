CREATE PROC [dbo].[ValidateLpTemplateConfig]
(@vehicleid      INT, 
 @documentTypeID INT, 
 @lps            VARCHAR(2000), 
 @id             INT, 
 @lang           VARCHAR(100)
)
AS
    BEGIN
        SELECT DISTINCT 
               dbo.F_GetObjectName(ModuleID, ObjectID) LPName
        FROM tbl_LPTemplateConfig t
             JOIN tbl_LPTemplateConfigDetail td ON t.LPTemplateConfigID = td.LPTemplateConfigID
                                                   AND td.LPTemplateConfigID <> ISNULL(@id, 0)
        WHERE t.VehicleID = @vehicleid
              AND t.DocumentTypeID = @documentTypeID
              AND t.Active = 1
              AND t.Lang = @lang
              AND CAST(td.ModuleID AS VARCHAR(10)) + '|' + CAST(td.ObjectID AS VARCHAR(10)) IN
        (
            SELECT *
            FROM dbo.SplitCSV(@lps, ',')
        );
    END;
