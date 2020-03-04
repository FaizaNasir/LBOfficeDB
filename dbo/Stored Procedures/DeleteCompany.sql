CREATE PROC [dbo].[DeleteCompany](@companyID INT)
AS
    BEGIN
        IF EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_Portfolio
            WHERE TargetPortfolioID = @companyID
        )
            BEGIN
                SELECT 0 Result, 
                       'Sorry, this company is in portfolio, please first delete it from Portfolio' Msg;
                RETURN;
        END;
        IF EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_deals
            WHERE DealCurrentTargetID = @companyID
        )
            BEGIN
                SELECT 0 Result, 
                       'Sorry, this company is target company of an existing deal, please first delete the deal

' Msg;
                RETURN;
        END;
        DELETE FROM tbl_PortfolioShareholdingOperations
        WHERE((FromID = @companyID
               AND FromTypeID = 5)
              OR (ToID = @companyID
                  AND ToTypeID = 5));
        DELETE FROM tbl_PortfolioGeneralOperation
        WHERE((FromID = @companyID
               AND FromModuleID = 5)
              OR (ToID = @companyID
                  AND ToModuleID = 5));
        DELETE FROM tbl_Shareholders
        WHERE ModuleID = 5
              AND ObjectID = @companyID;
        DELETE FROM tbl_CompanyOffice
        WHERE CompanyContactID = @companyID;
        DELETE FROM tbl_CompanyOptional
        WHERE CompanyID = @companyID;
        DELETE FROM tbl_CompanyRevenuesByGeography
        WHERE CompanyID = @companyID;
        DELETE FROM tbl_CompanyRevenuesByProduct
        WHERE CompanyID = @companyID;
        DELETE FROM tbl_CompanyRevenuesByService
        WHERE CompanyID = @companyID;
        DELETE FROM tbl_DealCompany
        WHERE CompanyID = @companyID;
        DELETE FROM tbl_CompanyBusinessUpdates
        WHERE CompanyID = @companyID;
        DELETE FROM tbl_CompanyClients
        WHERE CompanyID = @companyID;
        DELETE FROM tbl_CompanyCompetitors
        WHERE CompanyID = @companyID;
        DELETE FROM tbl_CompanyContactExternalAdvisors
        WHERE CompanyID = @companyID;
        DELETE FROM tbl_CompanyContactType
        WHERE CompanyContactID = @companyID;
        DELETE FROM tbl_MeetingLinkedTo
        WHERE ObjectID = @companyID
              AND moduleID = 5;
        DELETE FROM tbl_TaskLinked
        WHERE ObjectID = @companyID
              AND moduleID = 5;
        DELETE FROM tbl_CompanyIndividuals
        WHERE CompanyContactID = @companyID;
        DELETE FROM tbl_CompanyContact
        WHERE CompanyContactID = @companyID;
        SELECT 1 Result, 
               '' Msg;
    END;
