-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[proc_Get_ContactDepartments]
AS
    BEGIN
        SELECT ContactDepartmentInCompany
        FROM dbo.vw_IndividualsByCompany;
    END;
