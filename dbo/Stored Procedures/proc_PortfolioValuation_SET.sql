  
CREATE PROCEDURE [dbo].[proc_PortfolioValuation_SET] @ValuationID            INT            = NULL,   
                                                     @PortfolioID            INT            = NULL,   
                                                     @VehicleID              INT            = NULL,   
                                                     @Date                   DATETIME       = NULL,   
                                                     @TypeID                 INT            = NULL,   
                                                     @MethodID               INT            = NULL,   
                                                     @ValuationLevel         BIT,   
                                                     @InvestmentValue        DECIMAL(18, 2),   
                                                     @Discount               DECIMAL(18, 2),   
                                                     @FinalValuation         DECIMAL(18, 2),   
                                                     @Notes                  VARCHAR(MAX),   
                                                     @CreatedBy              VARCHAR(100),   
                                                     @ModifiedBy             VARCHAR(100),   
                                                     @Appliedfigures         NVARCHAR(MAX),   
                                                     @CurrentEnterpriseValue DECIMAL(18, 2)  
AS  
    BEGIN  
        SET @ValuationID = (CASE  
                                WHEN @ValuationID IS NULL  
                                THEN  
        (  
            SELECT TOP 1 ValuationID  
            FROM tbl_PortfolioValuation  
            WHERE PortfolioID = @PortfolioID  
                  AND VehicleID = @VehicleID  
                  AND Date = @Date  
        )  
                                ELSE @ValuationID  
                            END);  
        IF @ValuationID IS NULL  
            BEGIN  
                INSERT INTO tbl_PortfolioValuation  
                (PortfolioID,   
                 VehicleID,   
                 Date,   
                 TypeID,   
                 MethodID,   
                 ValuationLevel,   
                 InvestmentValue,   
                 Discount,   
                 FinalValuation,   
                 Notes,   
                 CreatedBy,   
                 CreatedDateTime,   
                 Appliedfigures,   
                 CurrentEnterpriseValue  
                )  
                VALUES  
                (@PortfolioID,   
                 @VehicleID,   
                 @Date,   
                 @TypeID,   
                 @MethodID,   
                 @ValuationLevel,   
                 @InvestmentValue,   
                 @Discount,   
                 @FinalValuation,   
                 @Notes,   
                 @CreatedBy,   
                 GETDATE(),   
                 @Appliedfigures,   
                 @CurrentEnterpriseValue  
                );  
                SET @ValuationID = @@IDENTITY;  
        END;  
            ELSE  
            BEGIN  
                UPDATE tbl_PortfolioValuation  
                  SET   
                      PortfolioID = @PortfolioID,   
                      VehicleID = @VehicleID,   
                      Date = @Date,   
                      TypeID = @TypeID,   
                      MethodID = @MethodID,   
                      ValuationLevel = @ValuationLevel,   
                      InvestmentValue = @InvestmentValue,   
                      Notes = @Notes,   
                      Discount = @Discount,   
                      FinalValuation = @FinalValuation,   
                      ModifiedDateTime = GETDATE(),   
                      Modifiedby = @Modifiedby  ,
					  Appliedfigures = @Appliedfigures,
					  CurrentEnterpriseValue = @CurrentEnterpriseValue
                WHERE ValuationID = @ValuationID;  
        END;  
        SELECT 'Success' AS Result,   
               @ValuationID AS 'ValuationID';  
    END;