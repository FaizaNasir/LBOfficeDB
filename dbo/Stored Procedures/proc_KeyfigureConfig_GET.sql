CREATE PROCEDURE [dbo].[proc_KeyfigureConfig_GET]-- 1           

@DealID INT      = NULL, 
@date   DATETIME
AS
    BEGIN
        SELECT KeyFigureConfigID, 
               PortfolioID, 
               Name, 
               NameFr, 
               Seq, 
               ISNULL(IsReport, 0) AS 'IsReport', 
               ISNULL(IsChart, 0) AS 'IsChart', 
               SubTab, 
               Active, 
               CreatedDateTime, 
               ModifiedDateTime, 
               CreatedBy, 
               ModifiedBy, 
               Date
        FROM tbl_KeyfigureConfig
        WHERE PortfolioID = @DealID
              AND date = ISNULL(@date,
        (
            SELECT TOP 1 date
            FROM tbl_KeyfigureConfig
            WHERE PortfolioID = @DealID
            ORDER BY date DESC
        ))
        ORDER BY seq;
    END;
