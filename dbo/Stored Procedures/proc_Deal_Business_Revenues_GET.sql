CREATE PROCEDURE [dbo].[proc_Deal_Business_Revenues_GET] @CompanyID INT = NULL
AS
    BEGIN
        SELECT CompanyRevenuesGeographyID, 
               Description, 
               Year, 
               Revenues, 
               CompanyID, 
               ContinentID, 
               tbl_Contenents.ContenentName
        FROM tbl_CompanyRevenuesByGeography
             LEFT OUTER JOIN tbl_Contenents ON tbl_CompanyRevenuesByGeography.ContinentID = tbl_Contenents.ContenentID
        WHERE CompanyID = ISNULL(@CompanyID, CompanyID);
    END;
