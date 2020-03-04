CREATE PROCEDURE [dbo].[proc_Deal_Status_Details_By_Deal_ID_GET] @DealID INT = NULL
AS
    BEGIN
        SELECT *
        FROM tbl_DealStatusDetails ds
        WHERE ds.DealID = ISNULL(@DealID, ds.DealID);
    END;
