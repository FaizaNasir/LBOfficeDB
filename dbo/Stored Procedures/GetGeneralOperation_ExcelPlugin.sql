CREATE PROC [dbo].[GetGeneralOperation_ExcelPlugin]
AS
    BEGIN
        SELECT sho.OperationID, 
               sho.Date, 
               cc.CompanyName, 
               ps.TypeName,
               CASE
                   WHEN sho.FromModuleID = 3
                   THEN 'Fund'
                   WHEN sho.FromModuleID = 4
                   THEN 'Contact'
                   WHEN sho.FromModuleID = 5
                   THEN 'Company'
               END FromType, 
               dbo.F_GetObjectModuleName(sho.FromID, sho.FromModuleID) [From],
               CASE
                   WHEN sho.ToModuleID = 3
                   THEN 'Fund'
                   WHEN sho.ToModuleID = 4
                   THEN 'Contact'
                   WHEN sho.ToModuleID = 5
                   THEN 'Company'
               END ToType, 
               dbo.F_GetObjectModuleName(sho.ToID, sho.ToModuleID) [To], 
               sho.Amount, 
               sho.ForeignCurrencyAmount, 
               sho.Notes
        FROM tbl_PortfolioGeneralOperation sho
             JOIN tbl_Portfolio p ON p.PortfolioID = sho.PortfolioID
             JOIN tbl_PortfolioGeneralOperationType ps ON ps.TypeID = sho.TypeID
             JOIN tbl_companycontact cc ON cc.companycontactid = p.TargetPortfolioID
        ORDER BY cc.CompanyName;
    END;
