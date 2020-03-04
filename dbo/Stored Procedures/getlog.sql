
-- proc_GetPortfolioInfoByIsin ''        

CREATE PROC [dbo].[getlog](@id INT = NULL)
AS
    BEGIN
        IF @id IS NULL
            SET @id = 50;
        SELECT TOP (@id) *
        FROM tbl_errorlog
        ORDER BY CreatedDateTime DESC;
    END;
