
/********************************************************************
** Name			    :	[proc_ShareholdingOperation_MaxNumber]
** Author			    :	Faisal Ashraf
** Create Date		    :	20 Sep, 2015
** 
** Description / Page   :	Portfolio - ShareholdingOperation max number calculation SP 
**
**
********************************************************************
** Change History
**
**      Date		    Author		Description	
** --   --------	    ------		------------------------------------

********************************************************************/

-- [proc_ShareholdingOperation_MaxNumber]11,11,3

CREATE PROCEDURE [dbo].[proc_ShareholdingOperation_MaxNumber]
(@id         INT = NULL, 
 @securityid INT = NULL, 
 @moduleid   INT = NULL
)
AS
    BEGIN
        DECLARE @add INT;
        DECLARE @sub INT;
        DECLARE @sum INT;
        SELECT @add = SUM(Number)
        FROM tbl_PortfolioShareholdingOperations PSO
        WHERE ToID = @id
              AND ToTypeID = @moduleID
              AND SecurityID = @securityid;
        SELECT @sub = SUM(Number)
        FROM tbl_PortfolioShareholdingOperations PSO
        WHERE FromID = @id
              AND FromTypeID = @moduleID
              AND SecurityID = @securityid;
        SELECT @sum = ISNULL(@add, 0) - ISNULL(@sub, 0);
        SELECT 'Sum' AS Result, 
               @sum AS 'Sum';
    END;
