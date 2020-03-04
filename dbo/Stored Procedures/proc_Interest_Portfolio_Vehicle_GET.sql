
/********************************************************************
** Name			    :	[proc_Interest_Portfolio_Vehicle_GET]
** Author			    :	Faisal Ashraf
** Create Date		    :	16 Sep, 2015
** 
** Description / Page   :	Portfolio - Interest tab get portfolio vehicle 
**
**
********************************************************************
** Change History
**
**      Date		    Author		Description	
** --   --------	    ------		------------------------------------

********************************************************************/

CREATE PROCEDURE [dbo].[proc_Interest_Portfolio_Vehicle_GET] @ObjectID  INT = NULL, 
                                                             @IsCompany BIT = NULL
AS
    BEGIN
        SELECT [InterestPortfolioFundID], 
               [FundName], 
               i.[TypeID], 
               [Size], 
               i.[CurrencyID], 
               [TransactionName], 
               [Comments], 
               [IsCompany], 
               [ObjectID], 
               [DealDate], 
               c.CurrencyCode, 
               vt.TypeName
        FROM tbl_InterestPortfolioFund i
             LEFT OUTER JOIN tbl_Currency c ON c.CurrencyID = i.CurrencyID
             LEFT OUTER JOIN tbl_VehicleType vt ON vt.TypeID = i.TypeID
        WHERE ObjectID = ISNULL(@ObjectID, ObjectID)
              AND IsCompany = ISNULL(@IsCompany, @IsCompany);
    END;
