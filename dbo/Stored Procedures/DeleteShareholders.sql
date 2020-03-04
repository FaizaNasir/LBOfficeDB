CREATE PROC [dbo].[DeleteShareholders](@shareholderID INT)
AS
    BEGIN
        DECLARE @moduleID INT;
        DECLARE @portfolioID INT;
        DECLARE @targetPortfolioID INT;
        DECLARE @id INT;
        SELECT @moduleID = ModuleID, 
               @id = ObjectID, 
               @targetPortfolioID = TargetPortfolioID
        FROM tbl_shareholders
        WHERE ShareholderID = @shareholderID;
        SET @portfolioID =
        (
            SELECT portfolioid
            FROM tbl_Portfolio
            WHERE TargetPortfolioID = @targetPortfolioID
        );
        IF EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_PortfolioShareholdingOperations
            WHERE((FromTypeID = @moduleID
                   AND FromID = @id)
                  OR ToTypeID = @moduleID
                  AND ToID = @id)
                 AND portfolioID = @portfolioID
        )
            BEGIN
                SELECT 0 Result, 
                       'Sorry, you cannot delete those shareholders as they are involved in shareholding / general operations; please delete those operations first' Msg;
                RETURN;
        END;
        IF EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_PortfolioGeneralOperation
            WHERE((FromModuleID = @moduleID
                   AND FromID = @id)
                  OR ToModuleID = @moduleID
                  AND ToID = @id)
                 AND portfolioID = @portfolioID
        )
            BEGIN
                SELECT 0 Result, 
                       'Sorry, you cannot delete those shareholders as they are involved in shareholding / general operations; please delete those operations first' Msg;
                RETURN;
        END;
        DELETE FROM tbl_shareholders
        WHERE ShareholderID = @shareholderID;
        SELECT 1 Result, 
               '' Msg;
    END;
