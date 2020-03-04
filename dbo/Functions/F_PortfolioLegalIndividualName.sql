
--  select dbo.[F_PortfolioLegalIndividualName](2)  

CREATE FUNCTION [dbo].[F_PortfolioLegalIndividualName]
(@legalid INT
)
RETURNS VARCHAR(MAX)
AS
     BEGIN
         DECLARE @XYList AS VARCHAR(MAX);
         SELECT @XYList = COALESCE(@XYList + ', ', '') + CONVERT(VARCHAR, ci.IndividualFullName)
         FROM tbl_PortfolioLegal pl
              INNER JOIN tbl_PortfolioLegalContactIndividual plci ON pl.PortfolioLegalID = plci.PortfolioLegalID
              INNER JOIN tbl_ContactIndividual ci ON plci.ContactIndividualID = ci.IndividualID
         WHERE pl.PortfolioLegalID = @legalid;
         RETURN @XYList;
     END;
