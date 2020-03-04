
/********************************************************************
** Name			    :	[proc_Portfolio_DebtSecurities_GET]
** Author			    :	Faisal Ashraf
** Create Date		    :	22 Nov, 2015
** 
** Description / Page   :	Portfolio - DebtSecurities Get Proc
**
**
********************************************************************
** Change History
**
**      Date		    Author		Description	
** --   --------	    ------		------------------------------------

********************************************************************/

--[proc_Portfolio_DebtSecurities_GET] 34

CREATE PROCEDURE [dbo].[proc_Portfolio_DebtSecurities_GET] --34       

@PortfolioSecurityID INT = NULL
AS
    BEGIN
        SELECT [DebtID], 
               [PortfolioSecurityID], 
               [Rate], 
               [SubscriptionDate], 
               [MaturityDate], 
               [CapitalizationDate], 
               [AnnualBasis], 
               [NonConversionPremium], 
               [Active], 
               [CreatedDateTime], 
               [ModifiedDateTime], 
               [CreatedBy], 
               [ModifiedBy]
        FROM [LBOffice].[dbo].[tbl_PortfolioDebtSecurities]
        WHERE PortfolioSecurityID = ISNULL(@PortfolioSecurityID, PortfolioSecurityID);
    END;
