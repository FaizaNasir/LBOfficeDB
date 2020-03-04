
-- [proc_DistributionPortfolioCompany_GET_By_DistributionID] 1

CREATE PROCEDURE [dbo].[proc_DistributionPortfolioCompany_GET_By_DistributionID] @DistributionID INT = NULL
AS
    BEGIN
        SELECT s.DistributionPortfolioCompanyID, 
               s.CompanyContactID, 
               S.Active, 
               S.CreatedDateTime, 
               S.ModifiedDateTime, 
               S.CreatedBy, 
               S.ModifiedBy
        FROM tbl_DistributionPortfolioCompany S
        WHERE S.DistributionID = @DistributionID;
    END;
