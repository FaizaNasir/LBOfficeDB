-- =============================================
-- Author:		Faisal Ashraf
-- Create date: 18-Aug-2016
-- Description:	Delete contact from main contact table and child tables.
-- =============================================
CREATE PROCEDURE [dbo].[proc_ContactCompany_DEL] 
-- Add the parameters for the stored procedure here
@IndividualID INT
AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

        -- Delete statements for contact procedure here

        DELETE FROM dbo.tbl_CompanyIndividuals
        WHERE dbo.tbl_CompanyIndividuals.ContactIndividualID = @IndividualID;
        UPDATE tbl_Deals
          SET 
              tbl_Deals.DealSourceIndividualID = NULL
        WHERE tbl_Deals.DealSourceIndividualID = @IndividualID;
        DELETE FROM dbo.tbl_Shareholders
        WHERE dbo.tbl_Shareholders.ModuleID = 4
              AND dbo.tbl_Shareholders.ObjectID = @IndividualID;
        DELETE FROM dbo.tbl_PortfolioShareholdingOperations
        WHERE tbl_PortfolioShareholdingOperations.FromID = 4
              AND tbl_PortfolioShareholdingOperations.FromTypeID = @IndividualID;
        DELETE FROM dbo.tbl_PortfolioShareholdingOperations
        WHERE tbl_PortfolioShareholdingOperations.ToID = 4
              AND tbl_PortfolioShareholdingOperations.ToTypeID = @IndividualID;
        DELETE FROM dbo.tbl_ContactIndividual
        WHERE dbo.tbl_ContactIndividual.IndividualID = @IndividualID;
        SELECT '1' AS Result;
    END;
