-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[proc_GET_CompanyContactType] @CompanyContactID INT, 
                                                     @ContactTypeID    INT = NULL
AS
    BEGIN
        SELECT *
        FROM tbl_CompanyContactTypes T
             INNER JOIN tbl_CompanyContact C ON T.CompanyContactID = C.CompanyContactID
             INNER JOIN tbl_ContactType CT ON CT.ContactTypeID = T.ContactTypeID
        WHERE T.CompanyContactTypeID = ISNULL(@CompanyContactID, T.CompanyContactTypeID)
              AND T.ContactTypeID = ISNULL(@ContactTypeID, T.ContactTypeID);
    END;
