
-- proc_getOutlookEmailLinkedTo 1,1385,4,1    

CREATE PROC [dbo].[proc_DelOutlookEmail](@emailID INT)
AS
    BEGIN
        DELETE FROM tbl_OutlookEmail
        WHERE EmailID = @emailID;
        DELETE FROM tbl_OutlookEmailLinkedTo
        WHERE EmailID = @emailID;
        SELECT 1 Result;
    END;
