CREATE PROCEDURE [dbo].[proc_CompanyContactFundStrategyGET] @companyId INT
AS
     SELECT cfs.CompanyFundStrategyID AS FundStrategyID, 
            cfs.Label
     FROM tbl_CompanyContact_FundStrategy cc_fs
          LEFT JOIN tbl_CompanyFundStrategy cfs ON cc_fs.FundStrategyId = cfs.CompanyFundStrategyID
     WHERE CompanyID = @companyId;
