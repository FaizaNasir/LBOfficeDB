CREATE PROCEDURE [dbo].[proc_Deal_Business_Competitors_GET] @CompanyID INT = NULL
AS
    BEGIN
        SELECT CompanyCompetitorsID, 
               CompetitorName, 
               Comments, 
               CompanyID
        FROM tbl_CompanyCompetitors
        WHERE CompanyID = ISNULL(@CompanyID, CompanyID);
    END;
