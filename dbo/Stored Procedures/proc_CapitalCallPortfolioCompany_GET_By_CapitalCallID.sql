
-- [proc_CapitalCallPortfolioCompany_GET_By_CapitalCallID] 1
CREATE PROCEDURE [dbo].[proc_CapitalCallPortfolioCompany_GET_By_CapitalCallID] @CapitalCallID INT = NULL
AS
    BEGIN
        SELECT s.CapitalCallPortfolioCompanyID, 
               s.CompanyContactID, 
               S.Active, 
               S.CreatedDateTime, 
               S.ModifiedDateTime, 
               S.CreatedBy, 
               S.ModifiedBy
        FROM tbl_CapitalCallPortfolioCompany S
        WHERE S.CapitalCallID = @CapitalCallID;
    END;
