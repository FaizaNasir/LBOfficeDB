-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[proc_Get_ConactPositions]
AS
    BEGIN
        SELECT ContactPositionInCompany
        FROM dbo.vw_IndividualsByCompany;
    END;
