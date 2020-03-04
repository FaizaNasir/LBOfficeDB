-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- proc_GetCapitalCallReportByCapitalCallID 19

CREATE PROCEDURE [dbo].[proc_GetCapitalCallReportByCapitalCallIDBU]

-- Add the parameters for the stored procedure here

@CapitalCallID INT
AS
    BEGIN

        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.

        SET NOCOUNT ON;

        -- Insert statements for procedure here

        SELECT P.*, 
               (P.LPCommitment - P.LPCallAmount) AS 'UncalledCommitments'
        FROM
        (
            SELECT ISNULL(MAX(cc.CallDate), '') AS CallDate, 
                   MAX(cc.DueDate) AS DueDate, 
                   MAX(cc.Notes) AS Notes, 
                   ISNULL(
            (
                SELECT(CASE
                           WHEN lp.ModuleID = 4
                           THEN
                (
                    SELECT TOP 1 CI.IndividualTitle + ' ' + CI.IndividualFullName
                    FROM [tbl_ContactIndividual] CI
                    WHERE CI.IndividualID = lp.ObjectID
                )
                           WHEN lp.ModuleID = 5
                           THEN
                (
                    SELECT TOP 1 ISNULL(CI.IndividualTitle, '') + ' ' + CI.IndividualFullName
                    FROM [tbl_ContactIndividual] CI
                         JOIN tbl_CompanyIndividuals TCI ON CI.IndividualID = TCI.ContactIndividualID
                    WHERE TCI.CompanyContactID =
                    (
                        SELECT TOP 1 cc2.CompanyContactID
                        FROM [tbl_CompanyContact] CC2
                        WHERE CC2.CompanyContactID = lp.ObjectID
                    )
                          AND TCI.isMainIndividual = 1
                )
                       END)
                FROM tbl_LimitedPartner lp
                WHERE lp.LimitedPartnerID = cclp.LimitedPartnerID
            ), 'N/A') AS LimitedPartnerName, 
            (
                SELECT ISNULL(veh.Name, '')
                FROM tbl_Vehicle veh
                WHERE veh.VehicleID = cc.FundID
            ) AS FundName, 
                   MAX(cc.TotalAmount) AS CallAmount, 
                   cclp.LimitedPartnerID, 
            (
                SELECT SUM(ISNULL(cclpinn.Amount, 0))
                FROM tbl_CapitalCallLimitedPartner cclpinn
                WHERE cclpinn.CapitalCallID = cc.CapitalCallID
                      AND cclpinn.LimitedPartnerID = cclp.LimitedPartnerID
            ) AS LPCallAmount, 
            (
                SELECT SUM(lpd.Amount)
                FROM tbl_LimitedPartnerDetail lpd
                WHERE lpd.LimitedPartnerID = cclp.LimitedPartnerID
            ) AS 'LPCommitment', 
                   SUM(cclp.Amount) AS 'NetContributedCapital', 
                   ISNULL(
            (
                SELECT SUM(inndistlp.Amount)
                FROM tbl_DistributionLimitedPartner inndistlp
                     JOIN tbl_Distribution inndist ON inndist.DistributionID = inndistlp.DistributionID
                WHERE inndist.FundID = cc.FundID
                      AND inndistlp.LimitedPartnerID = cclp.LimitedPartnerID
            ), 0) AS 'CumulatedDistributions', 
                   ISNULL(
            (
                SELECT SUM(amount)
                FROM tbl_VehicleNavLimitedPartner innvehNavlp
                     JOIN tbl_VehicleNav innvehNav ON innvehNavlp.VehicleNavID = innvehNav.VehicleNavID
                WHERE innvehNav.VehicleID = cc.FundID
                      AND innvehNavlp.LimitedPartnerID = cclp.LimitedPartnerID
            ), 0) AS 'LastNAV', 
                   MAX(vbd.[AccountName]) AS 'AccountName', 
                   MAX(vbd.[AccountNumber]) AS 'AccountNumber', 
                   MAX(vbd.[AccountIBAN]) AS 'AccountIBAN', 
                   MAX(vbd.[BankSWIFT]) AS 'BankSWIFT', 
                   MAX(vbd.[AccountCurrencyID]) AS 'AccountCurrencyID', 
                   MAX(vbd.[CustodianID]) AS 'CustodianID', 
            (
                SELECT SUM((innncclp.Amount * (CASE
                                                   WHEN PP.Total > 0
                                                   THEN PP.InvestmentAmount / PP.Total
                                                   ELSE 0
                                               END))) AS LPInvestment
                FROM tbl_CapitalCallLimitedPartner innncclp
                     JOIN
                (
                    SELECT ccop.CapitalCallID, 
                           ccop.ShareID, 
                           ccop.InvestmentAmount, 
                           ccop.ManagementFees, 
                           ccop.OtherFees, 
                           (ccop.InvestmentAmount + ccop.ManagementFees + ccop.OtherFees) AS Total
                    FROM tbl_CapitalCallOperation ccop
                ) PP ON innncclp.CapitalCallID = PP.CapitalCallID
                        AND innncclp.ShareID = PP.ShareID
                WHERE innncclp.CapitalCallID = cc.CapitalCallID
                      AND innncclp.LimitedPartnerID = cclp.LimitedPartnerID
            ) AS 'LPInvestment', 
            (
                SELECT SUM((innncclp.Amount * (CASE
                                                   WHEN PP.Total > 0
                                                   THEN PP.ManagementFees / PP.Total
                                                   ELSE 0
                                               END))) AS LPManagementFees
                FROM tbl_CapitalCallLimitedPartner innncclp
                     JOIN
                (
                    SELECT ccop.CapitalCallID, 
                           ccop.ShareID, 
                           ccop.InvestmentAmount, 
                           ccop.ManagementFees, 
                           ccop.OtherFees, 
                           (ccop.InvestmentAmount + ccop.ManagementFees + ccop.OtherFees) AS Total
                    FROM tbl_CapitalCallOperation ccop
                ) PP ON innncclp.CapitalCallID = PP.CapitalCallID
                        AND innncclp.ShareID = PP.ShareID
                WHERE innncclp.CapitalCallID = cc.CapitalCallID
                      AND innncclp.LimitedPartnerID = cclp.LimitedPartnerID
            ) AS 'LPManagementFees', 
            (
                SELECT SUM((innncclp.Amount * (CASE
                                                   WHEN PP.Total > 0
                                                   THEN PP.OtherFees / PP.Total
                                                   ELSE 0
                                               END))) AS LPOtherFees
                FROM tbl_CapitalCallLimitedPartner innncclp
                     JOIN
                (
                    SELECT ccop.CapitalCallID, 
                           ccop.ShareID, 
                           ccop.InvestmentAmount, 
                           ccop.ManagementFees, 
                           ccop.OtherFees, 
                           (ccop.InvestmentAmount + ccop.ManagementFees + ccop.OtherFees) AS Total
                    FROM tbl_CapitalCallOperation ccop
                ) PP ON innncclp.CapitalCallID = PP.CapitalCallID
                        AND innncclp.ShareID = PP.ShareID
                WHERE innncclp.CapitalCallID = cc.CapitalCallID
                      AND innncclp.LimitedPartnerID = cclp.LimitedPartnerID
            ) AS 'LPOtherFees', 
                   ISNULL((CASE
                               WHEN lp.ModuleID = 4
                               THEN ' '
                               ELSE
            (
                SELECT TOP 1 CC.CompanyName
                FROM [tbl_CompanyContact] CC
                WHERE CC.CompanyContactID = lp.ObjectID
            )
                           END), 'N/A') AS 'LPCompany', 
                   ISNULL((CASE
                               WHEN lp.ModuleID = 4
                               THEN
            (
                SELECT TOP 1 CI.IndividualAddress
                FROM [tbl_ContactIndividual] CI
                WHERE CI.IndividualID = lp.ObjectID
            )
                               ELSE
            (
                SELECT TOP 1 CC.CompanyAddress
                FROM [tbl_CompanyContact] CC
                WHERE CC.CompanyContactID = lp.ObjectID
            )
                           END), 'N/A') AS 'LPAddress', 
                   ISNULL((CASE
                               WHEN lp.ModuleID = 4
                               THEN
            (
                SELECT CountryName
                FROM tbl_Country
                WHERE CountryID =
                (
                    SELECT TOP 1 CI.IndividualCountryID
                    FROM [tbl_ContactIndividual] CI
                    WHERE CI.IndividualID = lp.ObjectID
                )
            )
                               ELSE
            (
                SELECT CountryName
                FROM tbl_Country
                WHERE CountryID =
                (
                    SELECT TOP 1 CC.CompanyCountryID
                    FROM [tbl_CompanyContact] CC
                    WHERE CC.CompanyContactID = lp.ObjectID
                )
            )
                           END), 'N/A') AS 'LPCountry', 
                   ISNULL((CASE
                               WHEN lp.ModuleID = 4
                               THEN
            (
                SELECT CityName
                FROM tbl_City
                WHERE CityID =
                (
                    SELECT TOP 1 CI.IndividualCityID
                    FROM [tbl_ContactIndividual] CI
                    WHERE CI.IndividualID = lp.ObjectID
                )
            )
                               ELSE
            (
                SELECT CityName
                FROM tbl_City
                WHERE CityID =
                (
                    SELECT TOP 1 CC.CompanyCityID
                    FROM [tbl_CompanyContact] CC
                    WHERE CC.CompanyContactID = lp.ObjectID
                )
            )
                           END), 'N/A') AS 'LPCity', 
                   ISNULL((CASE
                               WHEN lp.ModuleID = 4
                               THEN
            (
                SELECT TOP 1 CI.IndividualZipCode
                FROM [tbl_ContactIndividual] CI
                WHERE CI.IndividualID = lp.ObjectID
            )
                               ELSE
            (
                SELECT TOP 1 CC.CompanyZip
                FROM [tbl_CompanyContact] CC
                WHERE CC.CompanyContactID = lp.ObjectID
            )
                           END), 'N/A') AS 'LPZipCode', 
                   cc.CallName, 
            (
                SELECT curr.CurrencyCode
                FROM tbl_Currency curr
                WHERE curr.CurrencyID = MAX(vbd.[AccountCurrencyID])
            ) AS 'CurrencyCode', 
                   ISNULL(MAX(BranchCode), 'N/A') AS BranchCode, 
                   ISNULL(MAX(SortCode), 'N/A') AS SortCode, 
                   ISNULL(MAX(RIBCode), 'N/A') AS RIBCode, 
                   ISNULL(
            (
                SELECT cc.CompanyName
                FROM tbl_companycontact cc
                WHERE cc.CompanyContactID = MAX(vbd.[CustodianID])
            ), '') AS CustodianName, 
            (
                SELECT ISNULL(SUM(ISNULL(lpdinnn.Amount, 0)), 0)
                FROM tbl_LimitedPartnerDetail lpdinnn
                WHERE lpdinnn.LimitedPartnerID IN
                (
                    SELECT lpinnn.LimitedPartnerID
                    FROM tbl_LimitedPartner lpinnn
                    WHERE lpinnn.VehicleID = cc.FundID
                          AND lpinnn.Date <= MAX(cc.DueDate)
                )
            ) AS 'TotalCommitments'
            FROM tbl_CapitalCall cc
                 JOIN tbl_CapitalCallLimitedPartner cclp ON cc.CapitalCallID = cclp.CapitalCallID
                 JOIN tbl_LimitedPartner lp ON lp.LimitedPartnerID = cclp.LimitedPartnerID
                 LEFT JOIN tbl_VehicleBankDetails vbd ON cc.FundID = vbd.VehicleID
            WHERE cc.CapitalCallID = @CapitalCallID
            GROUP BY cc.FundID, 
                     cc.CapitalCallID, 
                     cclp.LimitedPartnerID, 
                     lp.ObjectID, 
                     lp.ModuleID, 
                     cc.CallName
        ) P;

        --select * from [tbl_ContactIndividual]

    END;
