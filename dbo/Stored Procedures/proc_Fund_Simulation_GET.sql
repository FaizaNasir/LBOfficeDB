
-- exec [dbo].[proc_Fund_Simulation_GET] @PortfolioSimulationID = 28

CREATE PROCEDURE [dbo].[proc_Fund_Simulation_GET]  --51           
@VehicleID INT = NULL
AS
    BEGIN
        SELECT ps.PortfolioSimulationID, 
               ps.TargetPortfolioID, 
               ps.VehicleID, 
               ps.Name, 
               ps.IRR, 
               ps.Multiple, 
               ps.UserName, 
               ps.Date, 
               ps.Notes, 
               ps.Active, 
               ps.CreatedDateTime, 
               ps.ModifiedDateTime, 
               ps.CreatedBy, 
               ps.ModifiedBy    
        --,(select CompanyName from tbl_CompanyContact cc     
        --join tbl_Portfolio p on p.TargetPortfolioID = cc.CompanyContactID    
        --where p.PortfolioID = psd.portfolioid)CompanyName      
        --,psd.PortfolioSimulationDetailID      
        --,psd.Date as 'simulation date'      
        --,psd.Amount      
        --,psd.TypeOfOperation      
        --,'1' as 'ShareholdingTypeofOperationID'      
        --,'a' as 'TypeofOperationName'      
        --,psto.ShareholdingTypeofOperationID      
        --,psto.TypeofOperationName      

        FROM tbl_PortfolioSimulation ps
        WHERE ps.VehicleID = ISNULL(@VehicleID, ps.VehicleID)
              AND isfund = 1;
    END;
