CREATE PROCEDURE [dbo].[ILPAPortfolioReport_Product] @companyID INT, 
                                                     @year      INT
AS
    BEGIN
        --DECLARE @companyID INT;
        --DECLARE @year INT;
        --SET @companyID = 4372;
        --SET @year = 2017;
        SELECT Description, 
               Type, 
               TypeName
        FROM tbl_CompanyRevenuesByProduct
        WHERE year = @year - 1
              AND CompanyID = @companyID
        ORDER BY Revenues DESC;
    END;
