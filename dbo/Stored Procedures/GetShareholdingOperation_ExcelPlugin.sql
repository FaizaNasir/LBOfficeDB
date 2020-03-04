CREATE PROC [dbo].[GetShareholdingOperation_ExcelPlugin]
AS
    BEGIN
        SELECT NULL FollowOnPaymentID, 
               sho.ShareholdingOperationID, 
               cc.CompanyName, 
               sho.Date,
               CASE
                   WHEN sho.FromTypeID = 3
                   THEN 'Fund'
                   WHEN sho.FromTypeID = 4
                   THEN 'Contact'
                   WHEN sho.FromTypeID = 5
                   THEN 'Company'
               END FromType, 
               dbo.F_GetObjectModuleName(sho.FromID, sho.FromTypeID) [From],
               CASE
                   WHEN sho.ToTypeID = 3
                   THEN 'Fund'
                   WHEN sho.ToTypeID = 4
                   THEN 'Contact'
                   WHEN sho.ToTypeID = 5
                   THEN 'Company'
               END ToType, 
               Replace(dbo.F_GetObjectModuleName(sho.ToID, sho.ToTypeID), 'Creation', 'Deletion') [To], 
               sho.Amount, 
               sho.ForeignCurrencyAmount,
               CASE
                   WHEN sho.FromTypeID = 3
                   THEN sho.ReturnCapitalFx
                   ELSE NULL
               END ReturnCapitalFx,
               CASE
                   WHEN sho.FromTypeID = 3
                   THEN sho.ReturnCapitalEUR
                   ELSE NULL
               END ReturnCapitalEUR,
               CASE
                   WHEN sho.FromTypeID <> 3
                   THEN sho.ReturnCapitalEur
                   ELSE NULL
               END AdditionalRemainingCommitmentsEUR,
               CASE
                   WHEN sho.FromTypeID <> 3
                   THEN sho.ReturnCapitalFx
                   ELSE NULL
               END AdditionalRemainingCommitmentsFX, 
               ps.Name SecurityName, 
               pst.PortfolioSecurityTypeName, 
               sho.Number, 
               sho.Notes, 
               dbo.[F_GetPortfolioVehicle](p.portfolioID) VehicleName
        FROM tbl_PortfolioShareholdingOperations sho
             JOIN tbl_Portfolio p ON p.PortfolioID = sho.PortfolioID
             JOIN tbl_PortfolioSecurity ps ON ps.PortfolioSecurityID = sho.SecurityID
             JOIN tbl_PortfolioSecurityType pst ON pst.PortfolioSecurityTypeID = ps.PortfolioSecurityTypeID
             JOIN tbl_companycontact cc ON cc.companycontactid = p.TargetPortfolioID
        UNION ALL
        SELECT FollowOnPaymentID, 
               sho.ShareholdingOperationID, 
               cc.CompanyName, 
               pf.Date,
               CASE
                   WHEN sho.FromTypeID = 3
                   THEN 'Fund'
                   WHEN sho.FromTypeID = 4
                   THEN 'Contact'
                   WHEN sho.FromTypeID = 5
                   THEN 'Company'
               END FromType, 
               dbo.F_GetObjectModuleName(sho.FromID, sho.FromTypeID) [From],
               CASE
                   WHEN sho.ToTypeID = 3
                   THEN 'Fund'
                   WHEN sho.ToTypeID = 4
                   THEN 'Contact'
                   WHEN sho.ToTypeID = 5
                   THEN 'Company'
               END ToType, 
               Replace(dbo.F_GetObjectModuleName(sho.ToID, sho.ToTypeID), 'Creation', 'Deletion') [To], 
               pf.AmountDue, 
               pf.AmountDueFx, 
               NULL ReturnCapitalFx, 
               NULL ReturnCapitalEUR, 
               NULL AdditionalRemainingCommitmentsEUR, 
               NULL AdditionalRemainingCommitmentsFX, 
               NULL SecurityName, 
               NULL PortfolioSecurityTypeName, 
               NULL Number, 
               sho.Notes, 
               dbo.[F_GetPortfolioVehicle](p.portfolioID) VehicleName
        FROM tbl_PortfolioShareholdingOperations sho
             JOIN tbl_PortfolioFollowOnPayment pf ON pf.ShareholdingOperationID = sho.ShareholdingOperationID
             JOIN tbl_Portfolio p ON p.PortfolioID = sho.PortfolioID
             JOIN tbl_PortfolioSecurity ps ON ps.PortfolioSecurityID = sho.SecurityID
             JOIN tbl_PortfolioSecurityType pst ON pst.PortfolioSecurityTypeID = ps.PortfolioSecurityTypeID
             JOIN tbl_companycontact cc ON cc.companycontactid = p.TargetPortfolioID
        ORDER BY cc.CompanyName, 
                 ShareholdingOperationID, 
                 FollowOnPaymentID;
    END;
