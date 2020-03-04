CREATE PROCEDURE [dbo].[proc_GetDatedNavPortfolio]
(@vehicleid   INT, 
 @portfolioid INT, 
 @companyID   INT, 
 @Date        DATETIME
)
AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

        -- Insert statements for procedure here
        SELECT [dbo].[F_GetDatedNAV](@vehicleid, @portfolioid, @companyID, @Date);
    END;
