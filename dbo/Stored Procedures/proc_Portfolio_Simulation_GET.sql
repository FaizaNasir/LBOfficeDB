
/********************************************************************
** Name			    :	[proc_Portfolio_Simulation_GET]
** Author			    :	Faisal Ashraf
** Create Date		    :	16 Sep, 2015
** 
** Description / Page   :	Portfolio - Simulation Get
**
**
********************************************************************
** Change History
**
**      Date		    Author		Description	
** --   --------	    ------		------------------------------------

********************************************************************/

CREATE PROCEDURE [dbo].[proc_Portfolio_Simulation_GET]  --51       

@PortfolioSimulationID INT = NULL
AS
    BEGIN
        SELECT ps.PortfolioSimulationID, 
               ps.TargetPortfolioID, 
               cc.CompanyName, 
               ps.VehicleID, 
               ps.Name AS 'Simulation Name', 
               ps.IRR, 
               ps.Multiple, 
               ps.UserName, 
               ps.Date AS 'logdate', 
               ps.Notes, 
               ps.Active, 
               ps.CreatedDateTime, 
               ps.ModifiedDateTime, 
               ps.CreatedBy, 
               ps.ModifiedBy

        --,psd.PortfolioSimulationDetailID  
        --,psd.Date as 'simulation date'  
        --,psd.Amount  
        --,psd.TypeOfOperation  
        --,'1' as 'ShareholdingTypeofOperationID'  
        --,'a' as 'TypeofOperationName'  
        --,psto.ShareholdingTypeofOperationID  
        --,psto.TypeofOperationName  

        FROM tbl_PortfolioSimulation ps
             LEFT OUTER JOIN tbl_PortfolioSimulationDetail psd ON psd.PortfolioSimulationID = ps.PortfolioSimulationID

             --left outer join tbl_PortfolioShareholdingTypeofOperation psto ON  
             --psto.ShareholdingTypeofOperationID = psd.TypeOfOperation  

             LEFT OUTER JOIN tbl_CompanyContact cc ON cc.CompanyContactID = ps.TargetPortfolioID
        WHERE ps.PortfolioSimulationID = ISNULL(@PortfolioSimulationID, ps.PortfolioSimulationID);
    END;
