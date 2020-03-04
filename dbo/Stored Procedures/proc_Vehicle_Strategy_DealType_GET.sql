CREATE PROCEDURE [dbo].[proc_Vehicle_Strategy_DealType_GET] @VehicleID INT          = NULL, 
                                                            @RoleName  VARCHAR(100) = NULL
AS
    BEGIN
        SELECT VehicleStrategyDealTypeID, 
               DealTypeID, 
               'Type' = CASE IsInclude
                            WHEN '1'
                            THEN 'Include'
                            WHEN '0'
                            THEN 'Exclude'
                        END, 
               tbl_VehicleStrategyDealType.CreatedDateTime, 
               tbl_VehicleStrategyDealType.ModifiedDateTime, 
               Percentage, 
               IsInclude, 
               VehicleID, 
               tbl_VehicleStrategyDealType.CreatedBy, 
               tbl_VehicleStrategyDealType.ModifiedBy, 
               tbl_VehicleStrategyDealType.Active, 
               tbl_DealType.ProjectTypeTitle
        FROM tbl_VehicleStrategyDealType
             LEFT OUTER JOIN tbl_DealType ON tbl_VehicleStrategyDealType.DealTypeID = tbl_DealType.ProjectTypeID
        WHERE VehicleID = ISNULL(@VehicleID, VehicleID);
    END;
