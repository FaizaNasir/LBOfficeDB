
/********************************************************************
** Name			    :	proc_GetPortfolioInfoByIsin
** Author			    :	Zain Ali
** Create Date		    :	12 Jun, 2014
** 
** Description / Page   :	Portfolio - Security Page
**
**
********************************************************************
** Change History
**
**      Date		    Author		Description	
** --   --------	    ------		------------------------------------
** 01   12 Jun, 2014	    Zain Ali		Add Created Date Column
********************************************************************/

-- proc_GetPortfolioInfoByIsin ''

CREATE PROC [dbo].[proc_GetPortfolioInfoByIsin](@isin VARCHAR(100))
AS
    BEGIN
        SELECT ps.PortfolioID, 
               pv.VehicleID, 
               ps.PortfolioSecurityID
        FROM tbl_portfoliosecurity ps
             JOIN tbl_PortfolioVehicle pv ON ps.PortfolioID = pv.PortfolioID
        WHERE isin = @isin;
    END;
