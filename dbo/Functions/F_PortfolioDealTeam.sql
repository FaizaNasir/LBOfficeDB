--select [dbo].[F_PortfolioDealTeam] (6)          
CREATE FUNCTION [dbo].[F_PortfolioDealTeam]
(@Portfolio INT
)
RETURNS VARCHAR(MAX)
AS
     BEGIN
         DECLARE @VouvherNo VARCHAR(MAX);
         SELECT @VouvherNo = COALESCE(@VouvherNo + ' , ', '') + (cc.IndividualFirstName + ' ' + cc.IndividualLastName)
         FROM tbl_PortfolioDealTeam DFNI
              JOIN tbl_ContactIndividual cc ON DFNI.ContactIndividualID = cc.IndividualID
         WHERE DFNI.PortfolioID = @Portfolio;          
         --and DFNI.RoleID = 'Co-lead'        

         RETURN @VouvherNo;
     END; 
