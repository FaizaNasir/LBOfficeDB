
-- _GetPortfolioInfo 1

CREATE PROC [dbo].[_GetPortfolioInfo](@id INT)
AS
    BEGIN
        SELECT CompanyName, 
               CompanyContactID
        FROM tbl_CompanyContact c
             JOIN tbl_portfolio p ON c.CompanyContactID = p.TargetPortfolioID
        WHERE CompanyContactID = @id;
    END;
