-- [proc_PortfolioValuationSecurityDetails_GET] 20,1          

CREATE PROCEDURE [dbo].[proc_PortfolioValuationSecurityDetails_SET]
(@SecurityID  INT, 
 @Value       DECIMAL(18, 4), 
 @ValuationID INT, 
 @Stock       DECIMAL(18, 4)
)
AS
    BEGIN
        DECLARE @id INT;
        SET @id =
        (
            SELECT TOP 1 ValuationDetailID
            FROM tbl_PortfolioValuationDetails
            WHERE SecurityID = @SecurityID
                  AND ValuationID = @ValuationID
        );
        IF @id IS NULL
            BEGIN
                INSERT INTO tbl_PortfolioValuationDetails
                (SecurityID, 
                 Value, 
                 ValuationID, 
                 Stock
                )
                       SELECT @SecurityID, 
                              @Value, 
                              @ValuationID, 
                              @Stock;
                SELECT 1 AS Result;
        END;
            ELSE
            BEGIN
                UPDATE tbl_PortfolioValuationDetails
                  SET 
                      Value = @Value, 
                      Stock = @Stock
                WHERE ValuationDetailID = @id;
        END;
    END;
