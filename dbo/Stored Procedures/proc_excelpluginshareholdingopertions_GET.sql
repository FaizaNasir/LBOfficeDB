
/********************************************************************
** Name			    :	[proc_excelpluginshareholdingopertions_GET]
** Author			    :	Naveed Bashani
** Create Date		    :	2 Jan, 2014
** 
** Description / Page   :	Portfolio - excel download proc for shareholding operation
**
**
********************************************************************
** Change History
**
**      Date		    Author		Description	
** --   --------	    ------		------------------------------------
** 01   15 Mar, 2013    Zain Ali		Add created date column
********************************************************************/

CREATE PROCEDURE [dbo].[proc_excelpluginshareholdingopertions_GET]
AS
    BEGIN
        SELECT DISTINCT 
               p.PortfolioID, 
               p.TargetPortfolioID, 
               cc.CompanyName, 
               psho.Name, 
               psho.Date, 
               psho.Amount, 
               psho.Number,
               CASE
                   WHEN psho.FromTypeID = 3
                   THEN
        (
            SELECT v.Name
            FROM tbl_Vehicle v
            WHERE v.VehicleID = psho.FromID
        )
                   WHEN psho.FromTypeID = 4
                   THEN
        (
            SELECT ci.IndividualFullName
            FROM tbl_ContactIndividual ci
            WHERE ci.IndividualID = psho.FromID
        )
                   WHEN psho.FromTypeID = 5
                   THEN
        (
            SELECT ccc.CompanyName
            FROM tbl_CompanyContact ccc
            WHERE ccc.CompanyContactID = psho.FromID
        )
                   WHEN psho.FromID = -1
                   THEN
        (
            SELECT 'Creation' objectname
        )
               END AS 'from',
               CASE
                   WHEN psho.ToTypeID = 3
                   THEN
        (
            SELECT v.Name
            FROM tbl_Vehicle v
            WHERE v.VehicleID = psho.ToID
        )
                   WHEN psho.ToTypeID = 4
                   THEN
        (
            SELECT ci.IndividualFullName
            FROM tbl_ContactIndividual ci
            WHERE ci.IndividualID = psho.ToID
        )
                   WHEN psho.ToTypeID = 5
                   THEN
        (
            SELECT ccc.CompanyName
            FROM tbl_CompanyContact ccc
            WHERE ccc.CompanyContactID = psho.ToID
        )
                   WHEN psho.ToID = -2
                   THEN
        (
            SELECT 'Deletion' objectname
        )
               END AS 'to'
        FROM tbl_PortfolioShareholdingOperations psho
             INNER JOIN tbl_Portfolio p ON p.PortfolioID = psho.PortfolioID
             INNER JOIN tbl_CompanyContact cc ON p.TargetPortfolioID = cc.CompanyContactID
             INNER JOIN tbl_PortfolioVehicle pv ON p.PortfolioID = pv.PortfolioVehicleID
        WHERE pv.VehicleID = 28;
    END;
