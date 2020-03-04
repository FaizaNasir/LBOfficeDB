--select [dbo].[F_PortfolioDealTeam] (6)          
CREATE FUNCTION [dbo].[F_Portfolio_Shareholder_ByPortfolio]
(@FundID            INT, 
 @TargetPortfolioID INT
)
RETURNS VARCHAR(MAX)
AS
     BEGIN
         DECLARE @VouvherNo VARCHAR(MAX);
         SELECT @VouvherNo = COALESCE(@VouvherNo + ' , ', '') +
         (
             SELECT CASE
                        WHEN s.ModuleID = 5
                        THEN
             (
                 SELECT TOP 1 CC.CompanyName
                 FROM [tbl_CompanyContact] CC
                 WHERE CC.CompanyContactID = S.TargetPortfolioID
             )
                    END + ' (' + STR(CAST(ROUND((dbo.[F_CapitalTable_NonDiluted](GETDATE(), p.PortfolioID, s.TargetPortfolioID, s.ObjectID, 5) * 100), 2) AS VARCHAR(1000)), 8, 2) + '%)' AS 'Company Name'
             FROM tbl_Shareholders S
                  INNER JOIN tbl_Portfolio p ON p.TargetPortfolioID = s.TargetPortfolioID
                  INNER JOIN tbl_PortfolioVehicle pv ON pv.PortfolioID = p.PortfolioID
             WHERE S.ObjectID = ISNULL(@TargetPortfolioID, S.TargetPortfolioID)
                   AND s.ModuleID = 5
                   AND pv.VehicleID = @FundID
         );
         RETURN @VouvherNo;
     END; 
