
/********************************************************************

** Name			    :	[proc_Portfolio_Vehicle_GET]

** Author			    :	Faizan Rehman

** Create Date		    :	20 Jan, 2017

** 

** Description / Page   :	Get all PortFolio Companies By Vehicle ID

**

**

********************************************************************

** Change History

**

**      Date		    Author		Description	

** --   --------	    ------		------------------------------------



********************************************************************/

CREATE PROCEDURE [dbo].[proc_Vehicle_Portfolio_Company_GET] @VehicleID INT = NULL
AS
    BEGIN
        SELECT a.PortfolioID, 
               a.PortfolioVehicleID, 
               c.CompanyContactID, 
               c.CompanyName
        FROM tbl_PortfolioVehicle a
             JOIN tbl_Portfolio b ON a.PortfolioID = b.PortfolioID
             JOIN tbl_CompanyContact c ON b.TargetPortfolioID = c.CompanyContactID
        WHERE a.VehicleID = @VehicleID;
    END;
