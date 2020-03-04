-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[proc_GET_ContactIndividual] @ContactIndividualID INT = NULL, 
                                                    @CountryID           INT = NULL, 
                                                    @CityID              INT = NULL, 
                                                    @ContactTypeID       INT = NULL, 
                                                    @RoleID              INT, 
                                                    @CompanyID           INT = NULL
AS
    BEGIN
        SELECT *
        FROM tbl_ContactIndividual AS C
             LEFT OUTER JOIN dbo.tbl_ModuleObjectPermissions AS P ON C.IndividualID = P.ModuleObjectID
                                                                     AND P.ModuleName = 'ContactIndividual'
                                                                     AND P.RoleID = 1 --AND P.CanView=1
        WHERE		--P.CanView=1 AND 
        C.IndividualID = ISNULL(@ContactIndividualID, C.IndividualID);
    END;
