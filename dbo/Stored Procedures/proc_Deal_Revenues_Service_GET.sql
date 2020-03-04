CREATE PROCEDURE [dbo].[proc_Deal_Revenues_Service_GET] @CompanyID INT = NULL
AS
    BEGIN
        SELECT CompanyRevenuesServiceID, 
               Description, 
               Year, 
               Revenues, 
               Type, 
               CompanyID, 
               TypeName
        FROM tbl_CompanyRevenuesByService
        WHERE CompanyID = ISNULL(@CompanyID, CompanyID);
    END;
