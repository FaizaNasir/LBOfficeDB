CREATE FUNCTION [dbo].[F_GetDealNegativeList]
(@DealID INT
)
RETURNS VARCHAR(MAX)
AS
     BEGIN
         DECLARE @VouvherNo VARCHAR(MAX);
         SELECT @VouvherNo = COALESCE(@VouvherNo + ' , ', '') + CC.CompanyName
         FROM tbl_DealFundNegativeInvestor DFNI
              JOIN tbl_CompanyContact cc ON DFNI.CompanyContactID = cc.companycontactid
         WHERE DFNI.DealID = @DealID;
         RETURN @VouvherNo;
     END;
