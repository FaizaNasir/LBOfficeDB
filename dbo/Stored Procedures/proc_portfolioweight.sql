
/********************************************************************
** Name			    :	proc_portfolioweight
** Author			    :	Faisal Ashraf
** Create Date		    :	1 Dec, 2015
** 
** Description / Page   :	Portfolio - Calculate portfolio weight
**
**
********************************************************************
** Change History
**
**      Date		    Author		Description	
** --   --------	    ------		------------------------------------

********************************************************************/

CREATE PROC [dbo].[proc_portfolioweight]
AS
     DECLARE @Sum INT;
     DECLARE @Sum1 INT;
     DECLARE @Result INT;
    BEGIN
        SET @Sum =
        (
            SELECT SUM(cc.Amount)
            FROM tbl_PortfolioVehicle cc
            WHERE cc.STATUS = 1
        );
        SET @Sum1 =
        (
            SELECT SUM(cc.Amount)
            FROM tbl_PortfolioVehicle cc
        );
        IF(@Sum1 != 0)
            SET @Result = ISNULL(@Sum, 0) / ISNULL(@Sum1, 0);
            ELSE
            SET @Result = 0;
        SELECT @Result AS 'Result';
    END;
