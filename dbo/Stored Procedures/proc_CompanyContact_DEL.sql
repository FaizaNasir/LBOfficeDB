-- =============================================
-- Author:		Faisal Ashraf
-- Create date: 18-Aug-2016
-- Description:	Delete contact from main contact table and child tables.
-- =============================================
CREATE PROCEDURE [dbo].[proc_CompanyContact_DEL] 
-- Add the parameters for the stored procedure here
@CompanyID INT
AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

        -- Delete statements for contact procedure here

        IF EXISTS
        (
            SELECT 1
            FROM dbo.tbl_DealTarget tdt
            WHERE tdt.ModuleObjectID = @CompanyID
        )
            BEGIN
                SELECT 'Sorry this company is also a target linked to deal' +
                (
                    SELECT TOP 1 td.DealName
                    FROM dbo.tbl_DealTarget tdt
                         INNER JOIN dbo.tbl_Deals td ON td.DealID = tdt.DealID
                    WHERE tdt.ModuleObjectID = @CompanyID
                ) + ' , you have to deleted from target first' AS Result;
                RETURN;
        END;
            ELSE
            IF EXISTS
            (
                SELECT 1
                FROM dbo.tbl_Portfolio tp
                WHERE tp.TargetPortfolioID = @CompanyID
            )
                BEGIN
                    SELECT 'Sorry, this company is also a portfolio company, you have to delete it from portfolio first' AS Result;
                    RETURN;
            END;
                ELSE
                BEGIN
                    DELETE FROM dbo.tbl_CompanyIndividuals
                    WHERE dbo.tbl_CompanyIndividuals.CompanyContactID = @CompanyID;
                    DELETE FROM dbo.tbl_Shareholders
                    WHERE dbo.tbl_Shareholders.ModuleID = 5
                          AND dbo.tbl_Shareholders.ObjectID = @CompanyID;
                    DELETE FROM dbo.tbl_PortfolioShareholdingOperations
                    WHERE tbl_PortfolioShareholdingOperations.FromID = 5
                          AND tbl_PortfolioShareholdingOperations.FromTypeID = @CompanyID;
                    DELETE FROM dbo.tbl_PortfolioShareholdingOperations
                    WHERE tbl_PortfolioShareholdingOperations.ToID = 5
                          AND tbl_PortfolioShareholdingOperations.ToTypeID = @CompanyID;
                    UPDATE tbl_Deals
                      SET 
                          tbl_Deals.DealSourceIndividualID = NULL
                    WHERE tbl_Deals.DealSourceCompanyID = @CompanyID;
                    DELETE FROM dbo.tbl_CompanyContact
                    WHERE dbo.tbl_CompanyContact.CompanyContactID = @CompanyID;
            END;
    END;
