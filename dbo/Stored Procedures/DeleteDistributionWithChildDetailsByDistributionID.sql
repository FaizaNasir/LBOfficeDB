CREATE PROC [dbo].[DeleteDistributionWithChildDetailsByDistributionID](@DistributionID INT = NULL)
AS
    BEGIN
        DELETE FROM tbl_DistributionOperation
        WHERE DistributionID = @DistributionID;
        DELETE FROM tbl_DistributionLimitedPartner
        WHERE DistributionID = @DistributionID;
        DELETE FROM tbl_DistributionPortfolioCompany
        WHERE DistributionID = @DistributionID;
        DELETE FROM tbl_LPReport
        WHERE ContextID = @DistributionID
              AND documenttypeid = 2
              AND vehicleid =
        (
            SELECT TOP 1 fundid
            FROM tbl_Distribution c
            WHERE c.DistributionID = @DistributionID
        );
        DELETE FROM tbl_Distribution
        WHERE DistributionID = @DistributionID;
        SELECT 1;
    END;
