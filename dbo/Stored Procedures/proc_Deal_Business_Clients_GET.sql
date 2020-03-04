CREATE PROCEDURE [dbo].[proc_Deal_Business_Clients_GET] @CompanyID INT = NULL
AS
    BEGIN
        SELECT CompanyClientsID, 
               ClientName, 
               Comments, 
               CompanyID
        FROM tbl_CompanyClients
        WHERE CompanyID = ISNULL(@CompanyID, CompanyID);
    END;
