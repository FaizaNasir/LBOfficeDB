CREATE PROC [dbo].[GetHoldingCompanyChilds]
(@companyID INT, 
 @vehicleID INT
)
AS
    BEGIN
        SELECT ROW_NUMBER() OVER(
               ORDER BY p.PortfolioID ASC) AS RowNum, 
               s.TargetPortfolioID, 
               p.PortfolioID, 
               CompanyName
        FROM tbl_ShareholdersOwned s
             JOIN tbl_Portfolio p ON s.TargetPortfolioID = p.TargetPortfolioID
                                     AND s.ModuleID = 5
             JOIN tbl_PortfolioVehicle pv ON pv.portfolioid = p.portfolioid
                                             AND pv.vehicleid = @vehicleid
             JOIN tbl_companycontact cc ON cc.companycontactid = s.TargetPortfolioID
        WHERE s.objectid = @companyID
              AND s.ShareholderOwnedDateId =
        (
            SELECT TOP 1 d.ShareholderDateId
            FROM tbl_ShareholdersOwnedDate d
            WHERE d.TargetPortfolioId = s.TargetPortfolioID
            ORDER BY date DESC
        );
    END;
