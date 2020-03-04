CREATE PROCEDURE [dbo].[proc_Portfolio_SimulationDetail_GEL] @PortfolioSimulationID INT = NULL
AS
     SELECT PortfolioSimulationDetailID ID, 
            Date, 
            Amount, 
            IsIncluded, 
            TypeOfOperation, 
            psd.PortfolioID, 
     (
         SELECT CompanyName
         FROM tbl_CompanyContact cc
              JOIN tbl_Portfolio p ON p.TargetPortfolioID = cc.CompanyContactID
         WHERE p.PortfolioID = psd.portfolioid
     ) CompanyName
     FROM tbl_PortfolioSimulationDetail psd
     WHERE PortfolioSimulationID = @PortfolioSimulationID;
