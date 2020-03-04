--[proc_PortfolioID_ByVehicleIDAndTargetCompanyID_GET] null,369

CREATE PROCEDURE [dbo].[proc_PortfolioID_ByVehicleIDAndTargetCompanyID_GET] @VehicleID       INT = NULL, 
                                                                            @TargetCompanyID INT = NULL
AS
    BEGIN
        SELECT DISTINCT 
               p.PortfolioID
        FROM tbl_Portfolio p
             INNER JOIN tbl_PortfolioVehicle pv ON p.PortfolioID = pv.PortfolioID
        WHERE p.TargetPortfolioID = ISNULL(@TargetCompanyID, p.TargetPortfolioID)
              AND pv.VehicleID = ISNULL(@VehicleID, pv.VehicleID);
    END;
