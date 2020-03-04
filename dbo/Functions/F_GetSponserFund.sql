CREATE FUNCTION [dbo].[F_GetSponserFund]
(@dealID INT
)
RETURNS VARCHAR(MAX)
AS
     BEGIN
         DECLARE @VouvherNo VARCHAR(MAX);
         SELECT @VouvherNo = COALESCE(@VouvherNo + ' / ', '') + cc.CompanyName
         FROM tbl_DealCompany dc
              JOIN tbl_companycontact cc ON cc.Companycontactid = dc.CompanyID
         WHERE dealid = @dealID;
         RETURN @VouvherNo;
     END;
