CREATE PROCEDURE [dbo].[proc_Deal_Revenues_Product_GET] @CompanyID INT = NULL
AS
    BEGIN
        SELECT CompanyRevenuesProductID, 
               Description, 
               Year, 
               Revenues, 
               Type, 
               CompanyID, 
               TypeName
        FROM tbl_CompanyRevenuesByProduct
        WHERE CompanyID = ISNULL(@CompanyID, CompanyID);
    END;
