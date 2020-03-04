CREATE PROCEDURE [dbo].[proc_MultiCurrencyRate_SET] @MultiCurrencyRateID INT            = NULL, 
                                                    @CurrencyID          VARCHAR(100), 
                                                    @Date                DATETIME       = NULL, 
                                                    @Rate                DECIMAL(18, 6)  = NULL, 
                                                    @Active              BIT            = NULL, 
                                                    @CreatedDateTime     DATETIME       = NULL, 
                                                    @ModifiedDateTime    DATETIME       = NULL, 
                                                    @CreatedBy           VARCHAR(100)   = NULL, 
                                                    @ModifiedBy          VARCHAR(100)   = NULL
AS
    BEGIN
        DECLARE @Result AS VARCHAR(100);
        SET @MultiCurrencyRateID = 0;
        SET @Result = '';
        IF NOT EXISTS
        (
            SELECT 1
            FROM [tbl_MultiCurrencyRate]
            WHERE Date = @Date
                  AND CurrencyID = @CurrencyID
        )
            BEGIN
                INSERT INTO [tbl_MultiCurrencyRate]
                ([CurrencyID], 
                 [Date], 
                 [Rate], 
                 [Active], 
                 [CreatedDateTime], 
                 [ModifiedDateTime], 
                 [CreatedBy], 
                 [ModifiedBy]
                )
                VALUES
                (@CurrencyID, 
                 @Date, 
                 @Rate, 
                 @Active, 
                 @CreatedDateTime, 
                 @ModifiedDateTime, 
                 @CreatedBy, 
                 @ModifiedBy
                );
                SET @Result = 'Success';
        END;
            ELSE
            BEGIN
                SET @Result = 'Sorry, the same currency has already been defined at this date';
        END;
        SET @MultiCurrencyRateID = @@IDENTITY;
        SELECT @Result AS Result, 
               @MultiCurrencyRateID AS 'MultiCurrencyRateID';
    END;
