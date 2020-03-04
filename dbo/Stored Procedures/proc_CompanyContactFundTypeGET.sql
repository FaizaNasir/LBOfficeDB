CREATE PROCEDURE [dbo].[proc_CompanyContactFundTypeGET] @companyId INT
AS
     SELECT cft.CompanyFundTypeID AS FundTypeID, 
            cft.Label
     FROM tbl_CompanyContact_FundType cc_ft
          LEFT JOIN tbl_CompanyFundType cft ON cc_ft.FundTypeId = cft.CompanyFundTypeID
     WHERE CompanyID = @companyId;
