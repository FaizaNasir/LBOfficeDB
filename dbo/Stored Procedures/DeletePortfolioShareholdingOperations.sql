CREATE PROC [dbo].[DeletePortfolioShareholdingOperations](@ShareholdingOperationID INT)
AS
    BEGIN

        --if exists (select top 1 1 from tbl_PortfolioFollowOnPayment
        --where ShareholdingOperationID = @ShareholdingOperationID)
        --begin
        --select 0 Result, 'Sorry, first you have to delete the follow up payments' Msg
        --return;
        --end

        DELETE FROM tbl_PortfolioFollowOnPayment
        WHERE ShareholdingOperationID = @ShareholdingOperationID;
        DELETE FROM tbl_PortfolioShareholdingOperations
        WHERE ShareholdingOperationID = @ShareholdingOperationID;
        SELECT 1 Result, 
               '' Msg;
    END;
