CREATE PROC [dbo].[DeleteDistributionChildDetailsByDistributionID](@DistributionID INT = NULL)
AS
    BEGIN
        DELETE FROM tbl_DistributionOperation
        WHERE DistributionID = @DistributionID;
        DELETE FROM tbl_DistributionLimitedPartner
        WHERE DistributionID = @DistributionID;
        DELETE FROM tbl_DistributionPortfolioCompany
        WHERE DistributionID = @DistributionID;
        SELECT 1;
    END;
