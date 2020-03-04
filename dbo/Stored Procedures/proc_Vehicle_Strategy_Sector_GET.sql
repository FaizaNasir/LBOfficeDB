CREATE PROCEDURE [dbo].[proc_Vehicle_Strategy_Sector_GET] @VehicleID INT          = NULL, 
                                                          @RoleName  VARCHAR(100) = NULL
AS
    BEGIN
        SELECT VehicleStrategySectorID, 
               SectorID, 
               tbl_VehicleStrategySector.CreatedDateTime, 
               tbl_VehicleStrategySector.ModifiedDateTime, 
               'Type' = CASE IsInclude
                            WHEN '1'
                            THEN 'Include'
                            WHEN '0'
                            THEN 'Exclude'
                        END, 
               Percentage, 
               IsInclude, 
               VehicleID, 
               CreatedBy, 
               ModifiedBy, 
               tbl_VehicleStrategySector.Active, 
               tbl_BusinessArea.BusinessAreaTitle
        FROM tbl_VehicleStrategySector
             LEFT OUTER JOIN tbl_BusinessArea ON tbl_VehicleStrategySector.SectorID = tbl_BusinessArea.BusinessAreaID
        WHERE VehicleID = ISNULL(@VehicleID, VehicleID);
    END;
