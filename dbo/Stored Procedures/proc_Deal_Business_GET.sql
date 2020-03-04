CREATE PROCEDURE [dbo].[proc_Deal_Business_GET] @CompanyID INT = NULL
AS
    BEGIN
        SELECT [CompanyBusinessID], 
               [Date], 
               [Comments], 
               Language, 
               [Rate], 
               [CompanyID]
        FROM tbl_CompanyBusinessUpdates
        WHERE CompanyID = ISNULL(@CompanyID, CompanyID);
    END;
