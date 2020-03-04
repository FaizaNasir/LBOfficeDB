CREATE PROC [dbo].[GetPortfolioShareholdingFunds](@portfolioID INT)
AS
    BEGIN
        SELECT DISTINCT 
               v.VehicleID, 
               v.Name AS VehicleName
        FROM tbl_PortfolioShareholdingOperations sho
             JOIN tbl_vehicle v ON 1 = CASE
                                           WHEN sho.FromTypeID = 3
                                                AND sho.FromID = v.VehicleID
                                           THEN 1
                                           WHEN sho.ToTypeID = 3
                                                AND sho.ToID = v.VehicleID
                                           THEN 1
                                           ELSE 0
                                       END
        WHERE sho.PortfolioID = @portfolioID
        ORDER BY v.Name;
    END;
