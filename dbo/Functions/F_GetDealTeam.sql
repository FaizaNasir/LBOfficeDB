
--  select  dbo.[F_BeforeLast_Valuation](66,60,'12-31-2016')      
--  select dbo.F_GetDealTeam (3557)

CREATE FUNCTION [dbo].[F_GetDealTeam]
(@dealid INT
)
RETURNS VARCHAR(5000)
AS
     BEGIN
         DECLARE @result VARCHAR(5000);
         SELECT @result = COALESCE(@result + ',', '') + CONVERT(VARCHAR(2000), ci.IndividualFullName)
         FROM tbl_dealteam dt
              JOIN tbl_contactindividual ci ON ci.individualid = dt.IndividualID
         WHERE DealID = @dealid
         ORDER BY IndividualFullName;
         RETURN @result;
     END;
