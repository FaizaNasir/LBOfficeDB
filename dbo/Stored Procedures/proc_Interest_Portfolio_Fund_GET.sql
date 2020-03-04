
/********************************************************************
** Name			    :	[proc_Interest_Portfolio_Fund_GET]
** Author			    :	Faisal Ashraf
** Create Date		    :	22 Nov, 2015
** 
** Description / Page   :	Portfolio - Interest Portfolio Fund get proc
**
**
********************************************************************
** Change History
**
**      Date		    Author		Description	
** --   --------	    ------		------------------------------------

********************************************************************/

CREATE PROCEDURE [dbo].[proc_Interest_Portfolio_Fund_GET] @ObjectID  INT = NULL, 
                                                          @IsCompany BIT = NULL
AS
    BEGIN
        SELECT [InterestPortfolioFundID], 
               [FundName], 
               [TypeID], 
               [Size], 
               tbl_InterestPortfolioFund.[CurrencyID], 
               [TransactionName], 
               [Comments], 
               [IsCompany], 
               [ObjectID], 
               [DealDate], 
               tbl_Currency.CurrencyCode, 
               tbl_Activities.ActiviteName FundTypeName
        FROM tbl_InterestPortfolioFund
             LEFT OUTER JOIN tbl_Currency ON tbl_Currency.CurrencyID = tbl_InterestPortfolioFund.CurrencyID
             LEFT OUTER JOIN tbl_Activities ON tbl_Activities.ActiviteID = tbl_InterestPortfolioFund.TypeID
        WHERE ObjectID = ISNULL(@ObjectID, ObjectID)
              AND IsCompany = ISNULL(@IsCompany, @IsCompany);
    END;
