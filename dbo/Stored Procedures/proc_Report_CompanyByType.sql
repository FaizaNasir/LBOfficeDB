-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[proc_Report_CompanyByType]
-- Add the parameters for the stored procedure here
@CompanyTypeID INT = NULL
AS
    BEGIN
        SELECT CompanyName, 
               ContactTypeID, 
               CTN.ContactTypeName
        FROM tbl_CompanyContact AS CC
             INNER JOIN tbl_CompanyContactType AS CT ON CC.CompanyContactID = CT.CompanyContactID
                                                        AND CT.Active = 1
             INNER JOIN tbl_ContactType AS CTN ON CT.ContactTypeID = CTN.ContactTypesID;
        --where CT.ContactTypeID = ISNULL(@CompanyTypeID, CT.ContactTypeID)
    END;
