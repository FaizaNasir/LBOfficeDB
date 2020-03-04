
/********************************************************************



** Name			    :	[proc_Portfolio_DebtCovenant_GET]



** Author			    :	Faisal Ashraf



** Create Date		    :	6 Aug, 2015



** 



** Description / Page   :	Portfolio - Security Get



**



**



********************************************************************



** Change History



**



**      Date		    Author		Description	



** --   --------	    ------		------------------------------------



** 01   6 Aug, 2015	    Faisal Ashraf	



********************************************************************/

CREATE PROCEDURE [dbo].[proc_Portfolio_DebtCovenant_GET] --34       

@PortfolioSecurityID INT = NULL
AS
    BEGIN
        SELECT [PortfolioDebtCovenantID], 
               [PortfolioSecurityID], 
               [CovenantTypeID] AS 'ConvenantRatio', 
               [Ratio] AS 'Percentage', 
               [Active], 
               [CreatedDateTime], 
               [ModifiedDateTime], 
               [CreatedBy], 
               [ModifiedBy], 
               Type
        FROM tbl_PortfolioDebtCovenant
        WHERE PortfolioSecurityID = ISNULL(@PortfolioSecurityID, PortfolioSecurityID);
    END;
