-- =============================================
-- Author:		Faisal Ashraf
-- Create date: 18-Aug-2016
-- Description:	Delete contact from main contact table and child tables.
-- =============================================
CREATE PROCEDURE [dbo].[proc_Deal_DEL] 
-- Add the parameters for the stored procedure here
@DealID INT
AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

        -- Delete statements for deal procedure here

        DELETE FROM dbo.tbl_DealTeam
        WHERE dbo.tbl_DealTeam.DealID = @DealID;
        DELETE FROM tbl_DealStageApproval
        WHERE tbl_DealStageApproval.DealID = @DealID;
        DELETE FROM dbo.tbl_Deals
        WHERE dbo.tbl_Deals.DealID = @DealID;
    END;
