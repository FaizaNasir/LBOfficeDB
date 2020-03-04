CREATE PROCEDURE [dbo].[proc_Deal_By_DealTeam_GET] @DealID INT = NULL
AS
    BEGIN
        SELECT D.ReceiverId, 
               D.DealSourceCompanyID, 
               D.DealSourceIndividualID, 
               CI.IndividualFullName AS 'ReceivedBy', 
               CII.IndividualFullName AS 'SenderIndividual', 
               CC.CompanyName AS 'SenderCompany'
        FROM tbl_Deals AS D
             LEFT OUTER JOIN tbl_ContactIndividual AS CI ON D.ReceiverId = CI.IndividualID
             LEFT OUTER JOIN tbl_ContactIndividual AS CII ON D.DealSourceIndividualID = CII.IndividualID
             LEFT OUTER JOIN tbl_CompanyContact AS CC ON D.DealSourceCompanyID = CC.CompanyContactID
        WHERE DealID = ISNULL(@DealID, DealID);
    END;
