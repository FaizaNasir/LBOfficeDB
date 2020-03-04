
/********************************************************************
** Name			    :	[proc_Portfolio_Shareholding_TypesofOperation_GET]
** Author			    :	Zain Ali
** Create Date		    :	4 May, 2014
** 
** Description / Page   :	Portfolio - Get type of shareholding operation
**
**
********************************************************************
** Change History
**
**      Date		    Author		Description	
** --   --------	    ------		------------------------------------

********************************************************************/

CREATE PROCEDURE [dbo].[proc_Portfolio_Shareholding_TypesofOperation_GET]
AS
    BEGIN
        SELECT ShareholdingTypeofOperationID, 
               TypeofOperationName, 
               Active, 
               CreatedDateTime, 
               ModifiedDateTime, 
               CreatedBy, 
               ModifiedBy
        FROM tbl_PortfolioShareholdingTypeofOperation;
    END;
