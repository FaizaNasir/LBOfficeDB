CREATE PROCEDURE [dbo].[proc_Vehicle_Strategy_Region_GET] @VehicleID INT          = NULL, 
                                                          @RoleName  VARCHAR(100) = NULL
AS
    BEGIN
        SELECT VehicleStrategyRegionID, 
               RegionID, 
               'Type' = CASE IsInclude
                            WHEN '1'
                            THEN 'Include'
                            WHEN '0'
                            THEN 'Exclude'
                        END, 
               CreatedDateTime, 
               ModifiedDateTime, 
               Percentage, 
               IsInclude, 
               VehicleID, 
               CreatedBy, 
               ModifiedBy, 
               tbl_VehicleStrategyRegion.Active, 
               tbl_Contenents.ContenentName
        FROM tbl_VehicleStrategyRegion
             LEFT OUTER JOIN tbl_Contenents ON tbl_VehicleStrategyRegion.RegionID = tbl_Contenents.ContenentID
        WHERE VehicleID = ISNULL(@VehicleID, VehicleID);
    END;
