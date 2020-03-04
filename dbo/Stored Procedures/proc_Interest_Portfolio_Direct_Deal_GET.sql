
/********************************************************************
** Name			    :	[proc_Interest_Portfolio_Direct_Deal_GET]
** Author			    :	Zain Ali
** Create Date		    :	2 Aug, 2015
** 
** Description / Page   :	Portfolio - Interest page deal Get
**
**
********************************************************************
** Change History
**
**      Date		    Author		Description	
** --   --------	    ------		------------------------------------

********************************************************************/

CREATE PROCEDURE [dbo].[proc_Interest_Portfolio_Direct_Deal_GET] @ObjectID  INT = NULL, 
                                                                 @IsCompany BIT = NULL
AS
    BEGIN
        SELECT [InterestPortfolioDirectDealID], 
               [CompanyName], 
               [SectorID], 
               [Size], 
               tbl_InterestPortfolioDirectDeal.[CurrencyID], 
               [Side], 
               [Comments], 
               [IsCompany], 
               [ObjectID], 
               [DealDate], 
               tbl_Currency.CurrencyCode, 
               tbl_SectorPerference.[SectorPerferenceDesc]
        FROM tbl_InterestPortfolioDirectDeal
             LEFT OUTER JOIN tbl_Currency ON tbl_Currency.CurrencyID = tbl_InterestPortfolioDirectDeal.CurrencyID
             LEFT OUTER JOIN tbl_SectorPerference ON tbl_SectorPerference.SectorPerferenceID = tbl_InterestPortfolioDirectDeal.SectorID
        WHERE ObjectID = ISNULL(@ObjectID, ObjectID)
              AND IsCompany = ISNULL(@IsCompany, IsCompany);
    END;
