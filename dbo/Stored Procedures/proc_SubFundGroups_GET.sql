CREATE PROCEDURE [dbo].[proc_SubFundGroups_GET] @FundGroupID INT
AS
    BEGIN
        SELECT *
        FROM tbl_SubFundGroup
        WHERE FundGroupID = ISNULL(@FundGroupID, FundGroupID);
    END;
