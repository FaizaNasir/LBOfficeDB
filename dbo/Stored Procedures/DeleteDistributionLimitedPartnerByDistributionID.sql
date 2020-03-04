CREATE PROC [dbo].[DeleteDistributionLimitedPartnerByDistributionID](@DistributionID INT = NULL)
AS
    BEGIN
        DELETE FROM tbl_DistributionLimitedPartner
        WHERE DistributionID = @DistributionID;
        SELECT 1;
    END;
