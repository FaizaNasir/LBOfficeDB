
/********************************************************************
** Name			    :	[proc_Portfolio_VariableRate_GET]
** Author			    :	Faisal Ashraf
** Create Date		    :	22 Nov, 2015
** 
** Description / Page   :	Portfolio - Variable rate Get proc
**
**
********************************************************************
** Change History
**
**      Date		    Author		Description	
** --   --------	    ------		------------------------------------

********************************************************************/

--[proc_Portfolio_DebtSecurities_GET] 34

CREATE PROCEDURE [dbo].[proc_Portfolio_VariableRate_GET] --34       

@PortfolioSecurityID INT = NULL
AS
    BEGIN
        SELECT [PortfolioVariableRateID], 
               [PortfolioSecurityID], 
               [Year], 
               [Rate], 
               [Capitalized], 
               [Active], 
               [CreatedDateTime], 
               [ModifiedDateTime], 
               [CreatedBy], 
               [ModifiedBy]
        FROM [tbl_PortfolioVariableRate]
        WHERE PortfolioSecurityID = ISNULL(@PortfolioSecurityID, PortfolioSecurityID);
    END;
