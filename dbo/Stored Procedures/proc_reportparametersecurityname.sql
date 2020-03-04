--proc_reportparametersecurityname
-- [test] '32,46','1'  

CREATE PROCEDURE [dbo].[proc_reportparametersecurityname]
(@PortfolioCompany VARCHAR(MAX), 
 @SecurityTypeID   VARCHAR(MAX)
)
AS
    BEGIN
        SELECT ps.PortfolioSecurityID, 
               ps.Name
        FROM tbl_PortfolioSecurity ps
             INNER JOIN tbl_PortfolioSecurityType pst ON ps.PortfolioSecurityTypeID = pst.PortfolioSecurityTypeID
        WHERE ps.PortfolioID IN
        (
            SELECT *
            FROM dbo.[SplitCSV](@PortfolioCompany, ',')
        )
             AND pst.PortfolioSecurityTypeID IN
        (
            SELECT *
            FROM dbo.[SplitCSV](@SecurityTypeID, ',')
        );
    END;

--tbl_Vehicle

