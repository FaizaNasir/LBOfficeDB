-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[proc_GET_CompanyIndividuals] @CompanyContactID    INT = NULL, 
                                                     @ContactIndividualID INT = NULL
AS
    BEGIN
        SELECT *
        FROM [tbl_CompanyIndividuals];
    END;
