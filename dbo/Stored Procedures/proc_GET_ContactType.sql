-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[proc_GET_ContactType] @ContactTypeID INT = NULL
AS
    BEGIN
        SELECT *
        FROM [tbl_ContactType]
        WHERE ContactTypesID = ISNULL(@ContactTypeID, ContactTypesID);
    END;
