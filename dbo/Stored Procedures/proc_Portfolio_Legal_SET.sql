
--[proc_Portfolio_Legal_SET] 4,0.0,2,2,325,'AC 900944'      

CREATE PROCEDURE [dbo].[proc_Portfolio_Legal_SET] @PortfolioID                  INT           = NULL, 
                                                  @vehicleID                    INT, 
                                                  @Capital                      DECIMAL       = NULL, 
                                                  @CapitalCurrencyID            INT           = NULL, 
                                                  @LegalStructureID             VARCHAR(1000) = NULL, 
                                                  @LegalRepresentativeCompanyID INT           = NULL, 
                                                  @TradeRegister                VARCHAR(50)   = NULL, 
                                                  @SectorCode                   VARCHAR(50)   = NULL, 
                                                  @CurrencyID                   INT           = NULL, 
                                                  @IsQuoted                     BIT           = NULL, 
                                                  @StockExchange                VARCHAR(50)   = NULL, 
                                                  @TickerSymbol                 VARCHAR(50)   = NULL, 
                                                  @ContingentLiabilities        VARCHAR(MAX)  = NULL, 
                                                  @LegalNotes                   VARCHAR(MAX)  = NULL, 
                                                  @NumberOfShares               INT,

                                                  --@RatesOfDetention  decimal(18,2),    

                                                  @Active                       BIT           = NULL, 
                                                  @CreatedBy                    VARCHAR(100)  = NULL, 
                                                  @CreatedDateTime              DATETIME      = NULL, 
                                                  @ModifiedBy                   VARCHAR(100)  = NULL, 
                                                  @ModifiedDateTime             DATETIME      = NULL
AS
     DECLARE @PortfolioLegalID INT= NULL;
     DECLARE @CapitalCalculation DECIMAL(18, 0)= NULL;
	 set @CapitalCalculation = @Capital
    BEGIN
        IF NOT EXISTS
        (
            SELECT 1
            FROM tbl_PortfolioLegal
            WHERE PortfolioID = @PortfolioID
        )
            BEGIN
			
                --SET @CapitalCalculation = (
                --(
                --    SELECT SUM(psho.Number)
                --    FROM tbl_PortfolioShareholdingOperations psho
                --    WHERE psho.FromID = -1
                --          AND psho.PortfolioID = @PortfolioID
                --) *
                --(
                --    SELECT TOP 1 ps.NominalValue
                --    FROM tbl_PortfolioShareholdingOperations psho
                --         LEFT OUTER JOIN tbl_PortfolioSecurity ps ON psho.SecurityID = ps.PortfolioSecurityID
                --                                                     AND ps.PortfolioID = psho.PortfolioID
                --    WHERE psho.FromID = -1
                --          AND psho.PortfolioID = @PortfolioID
                --));
                INSERT INTO [tbl_PortfolioLegal]
                ([Capital], 
                 [CapitalCurrencyID], 
                 [LegalStructureID], 
                 [LegalRepresentativeCompanyID], 
                 [TradeRegister], 
                 [SectorCode], 
                 [CurrencyID], 
                 [IsQuoted], 
                 [StockExchange], 
                 [TickerSymbol], 
                 [ContingentLiabilities], 
                 [LegalNotes], 
                 NumberOfShares,

                 --,RatesOfDetention       
                 [Active], 
                 [CreatedDateTime], 
                 [ModifiedDateTime], 
                 [PortfolioID], 
                 [CreatedBy], 
                 [ModifiedBy]
                )
                VALUES
                (@CapitalCalculation, 
                 @CapitalCurrencyID, 
                 @LegalStructureID, 
                 @LegalRepresentativeCompanyID, 
                 @TradeRegister, 
                 @SectorCode, 
                 @CurrencyID, 
                 @IsQuoted, 
                 @StockExchange, 
                 @TickerSymbol, 
                 @ContingentLiabilities, 
                 @LegalNotes, 
                 @NumberOfShares,

                 --,@RatesOfDetention       
                 @Active, 
                 @CreatedDateTime, 
                 @ModifiedDateTime, 
                 @PortfolioID, 
                 @CreatedBy, 
                 @ModifiedBy
                );
                SET @PortfolioLegalID = SCOPE_IDENTITY();
        END;
            ELSE
            BEGIN

                --SET @CapitalCalculation = (
                --(
                --    SELECT SUM(psho.Number)
                --    FROM tbl_PortfolioShareholdingOperations psho
                --    WHERE psho.FromID = -1
                --          AND psho.PortfolioID = @PortfolioID
                --) *
                --(
                --    SELECT TOP 1 ps.NominalValue
                --    FROM tbl_PortfolioShareholdingOperations psho
                --         LEFT OUTER JOIN tbl_PortfolioSecurity ps ON psho.SecurityID = ps.PortfolioSecurityID
                --                                                     AND ps.PortfolioID = psho.PortfolioID
                --    WHERE psho.FromID = -1
                --          AND psho.PortfolioID = @PortfolioID
                --));
                UPDATE [tbl_PortfolioLegal]
                  SET 
                      [Capital] = @CapitalCalculation, 
                      [CapitalCurrencyID] = @CapitalCurrencyID, 
                      [LegalStructureID] = @LegalStructureID, 
                      [LegalRepresentativeCompanyID] = @LegalRepresentativeCompanyID, 
                      [TradeRegister] = @TradeRegister, 
                      [SectorCode] = @SectorCode, 
                      [CurrencyID] = @CurrencyID, 
                      [IsQuoted] = @IsQuoted, 
                      [StockExchange] = @StockExchange, 
                      [TickerSymbol] = @TickerSymbol, 
                      [ContingentLiabilities] = @ContingentLiabilities, 
                      [LegalNotes] = @LegalNotes, 
                      [NumberOfShares] = @NumberOfShares,

                      --,[RatesOfDetention] = @RatesOfDetention       
                      [Active] = @Active, 
                      [CreatedDateTime] = @CreatedDateTime, 
                      [ModifiedDateTime] = @ModifiedDateTime, 
                      [PortfolioID] = @PortfolioID, 
                      [CreatedBy] = @CreatedBy, 
                      [ModifiedBy] = @ModifiedBy
                WHERE PortfolioID = @PortfolioID;
                SET @PortfolioLegalID =
                (
                    SELECT TOP 1 PortfolioLegalID
                    FROM [tbl_PortfolioLegal]
                    WHERE PortfolioID = @PortfolioID
                );
        END;
        SELECT 'Success' AS Result, 
               @PortfolioLegalID AS 'PortfolioLegalID';
    END;  
