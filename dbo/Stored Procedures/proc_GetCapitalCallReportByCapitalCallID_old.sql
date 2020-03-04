CREATE PROCEDURE [dbo].[proc_GetCapitalCallReportByCapitalCallID_old] @CapitalCallID INT
AS
    BEGIN
        SET NOCOUNT ON;
        DECLARE @totalFundCommitment DECIMAL(18, 2);
        SET @totalFundCommitment =
        (
            SELECT SUM(amount)
            FROM tbl_LimitedPartnerDetail lpd
                 JOIN tbl_LimitedPartner lp ON lp.LimitedPartnerID = lpd.LimitedPartnerID
            WHERE lp.VehicleID =
            (
                SELECT fundid
                FROM tbl_CapitalCall
                WHERE CapitalCallID = @CapitalCallID
            )
        );
        SELECT Q.*, 
        (
            SELECT Role
            FROM tbl_vehicle v
            WHERE v.vehicleid = q.FundID
        ) Role, 
               ISNULL(((Q.lasteffectivenav * Q.lpsharesowned) + ISNULL(Q.cumulatedcallsforadjnav, 0) - ISNULL(Q.cumulateddistributionforadjnav, 0)), 0) AS 'AdjustedNAV'
        FROM
        (
            SELECT P.*, 
                   (P.lpcommitment - P.lpcallamount) AS 'UncalledCommitments',

                   --dbo.F_GetCapitalCallUnCalledCommitmentsLP(@capitalcallID, p.fundID, p.objectID, p.moduleID, p.shareID, p.calldate) AS 'LPShareUncalledCommitments',

                   0.0 'LPShareUncalledCommitments', 
                   ((P.lpsharecommitment / ISNULL(P.totalsharecommitments, 1))) * 100 AS 'LPShareCommitmentPercentage', 
                   ((P.lpsharecommitment / ISNULL(P.TotalShareCommitmentsAsOfDate, 1))) * 100 AS 'varLPShareCommitmentPercentAsOfDate', 
                   ((P.effectivesharecallamount / ISNULL(P.totalsharecommitments, 1))) * 100 AS 'LPShareCapitalPercentage', 
                   ((P.EffectiveCallAmount / ISNULL(@totalFundCommitment, 1))) * 100 AS 'LPFundCallPercent', 
                   ((P.lpsharecommitment) /
            (
                SELECT TOP 1 ISNULL(a.nominalvalue, 1)
                FROM tbl_vehicleshareDetail a
                WHERE a.shareid = P.shareid
                      AND a.ShareDate <= CallDate
                ORDER BY a.ShareDate DESC
            )) AS 'LPSharesOwned'
            FROM
            (
                SELECT cc.fundid, 
                       cc.CallNameFR, 
                       cc.NotesFR, 
                       lp.ObjectID, 
                       lp.ModuleID, 
                       ISNULL((CASE
                                   WHEN lp.moduleid = 5
                                   THEN
                (
                    SELECT TOP 1 ISNULL(c.individualtitle, '') + ' ' + ISNULL(c.individualfirstname, '') + ' ' + ISNULL(c.individuallastname, '')
                    FROM tbl_CompanyIndividuals CI
                         JOIN tbl_ContactIndividual c ON c.individualid = ci.ContactIndividualID
                    WHERE CI.companycontactid = lp.objectid
                          AND CI.isMainIndividual = 1
                )
                               END), 'N/A') AS LPMainContact, 
                       ISNULL((CASE
                                   WHEN lp.moduleid = 4
                                   THEN
                (
                    SELECT countrynameFR
                    FROM tbl_country
                    WHERE countryid =
                    (
                        SELECT TOP 1 CI.individualcountryid
                        FROM [tbl_contactindividual] CI
                        WHERE CI.individualid = lp.objectid
                    )
                )
                                   ELSE
                (
                    SELECT countrynameFR
                    FROM tbl_country
                    WHERE countryid =
                    (
                        SELECT TOP 1 CC.countryid
                        FROM tbl_companyoffice CC
                        WHERE CC.companycontactid = lp.objectid
                              AND cc.IsMain = 1
                    )
                )
                               END), 'N/A') AS 'LPCountryFR', 
                (
                    SELECT SUM((ISNULL(tccop.investmentamount, 0) + ISNULL(tccop.managementfees, 0) + ISNULL(tccop.otherfees, 0)))
                    FROM tbl_capitalcalloperation tccop
                    WHERE tccop.capitalcallid = cc.capitalcallid
                          AND tccop.fundid = cc.fundid
                ) AS EffectiveCallAmount, 
                       ISNULL(MAX(cc.calldate), '') AS CallDate, 
                       MAX(cc.duedate) AS DueDate, 
                       MAX(cc.notes) AS Notes, 
                       ISNULL((CASE
                                   WHEN lp.moduleid = 4
                                   THEN
                (
                    SELECT TOP 1 ISNULL(CI.individualtitle, '') + ' ' + ISNULL(CI.individualfirstname, '') + ' ' + ISNULL(CI.individuallastname, '') + ISNULL(CI.individualmiddlename, '')
                    FROM [tbl_contactindividual] CI
                    WHERE CI.individualid = lp.objectid
                )
                                   WHEN lp.moduleid = 5
                                   THEN
                (
                    SELECT TOP 1 ISNULL(CI.individualtitle, '') + ' ' + ISNULL(CI.individualfirstname, '') + ' ' + ISNULL(CI.individuallastname, '') + ISNULL(CI.individualmiddlename, '')
                    FROM [tbl_contactindividual] CI
                         JOIN tbl_companyindividuals TCI ON CI.individualid = TCI.contactindividualid
                                                            AND TCI.ismainindividual = 1
                    WHERE TCI.companycontactid = lp.objectid
                )
                                   WHEN lp.moduleid = 3
                                   THEN
                (
                    SELECT TOP 1 Name
                    FROM tbl_vehicle v
                    WHERE v.VehicleID = lp.objectid
                )
                               END), 'N/A') AS LimitedPartnerName, 
                       ISNULL((CASE
                                   WHEN lp.moduleid = 4
                                   THEN
                (
                    SELECT TOP 1 ISNULL(CI.individualtitle, '') + ' ' + ISNULL(CI.individualfirstname, '') + ' ' + ISNULL(CI.individuallastname, '') + ISNULL(CI.individualmiddlename, '')
                    FROM [tbl_contactindividual] CI
                    WHERE CI.individualid = lp.objectid
                )
                                   WHEN lp.moduleid = 5
                                   THEN
                (
                    SELECT TOP 1 CC.companyname
                    FROM [tbl_companycontact] CC
                    WHERE CC.companycontactid = lp.objectid
                )
                                   WHEN lp.moduleid = 3
                                   THEN
                (
                    SELECT TOP 1 Name
                    FROM tbl_vehicle v
                    WHERE v.VehicleID = lp.objectid
                )
                               END), 'N/A') AS LPFullName, 
                (
                    SELECT ISNULL(veh.NAME, '')
                    FROM tbl_vehicle veh
                    WHERE veh.vehicleid = cc.fundid
                ) AS FundName, 
                       MAX(cc.totalamount) AS CallAmount, 
                (
                    SELECT(ISNULL(tccop.investmentamount, 0) + ISNULL(tccop.managementfees, 0) + ISNULL(tccop.otherfees, 0))
                    FROM tbl_capitalcalloperation tccop
                    WHERE tccop.capitalcallid = cc.capitalcallid
                          AND tccop.fundid = cc.fundid
                          AND tccop.shareid = cclp.shareid
                ) AS EffectiveShareCallAmount, 
                       MIN(cclp.limitedpartnerid) limitedpartnerid, 
                       cclp.shareid, 
                (
                    SELECT innvs.sharename
                    FROM tbl_vehicleshare innvs
                    WHERE innvs.vehicleshareid = cclp.shareid
                          AND innvs.vehicleid = cc.fundid
                ) AS 'ShareName', 
                (
                    SELECT innvs.sharenameFr
                    FROM tbl_vehicleshare innvs
                    WHERE innvs.vehicleshareid = cclp.shareid
                          AND innvs.vehicleid = cc.fundid
                ) AS 'ShareNameFR', 
                (
                    SELECT SUM(ISNULL(cclpinn.amount, 0))
                    FROM tbl_capitalcalllimitedpartner cclpinn
                         JOIN tbl_LimitedPartner lp1 ON lp1.LimitedPartnerID = cclpinn.limitedpartnerid
                    WHERE cclpinn.capitalcallid = cc.capitalcallid
                          AND lp1.ObjectID = lp.ObjectID
                          AND lp1.ModuleID = lp.ModuleID
                ) AS LPCallAmount, 
                (
                    SELECT SUM(ISNULL(cclpinn.amount, 0))
                    FROM tbl_capitalcalllimitedpartner cclpinn
                         JOIN tbl_LimitedPartner lp1 ON lp1.LimitedPartnerID = cclpinn.limitedpartnerid
                    WHERE cclpinn.capitalcallid = cc.capitalcallid
                          AND lp1.ObjectID = lp.ObjectID
                          AND lp1.ModuleID = lp.ModuleID
                          AND cclpinn.shareid = cclp.shareid
                ) AS LPShareCallAmount, 
                       ISNULL(
                (
                    SELECT SUM(lpd.amount)
                    FROM tbl_limitedpartnerdetail lpd
                         JOIN tbl_limitedpartner lppp ON lpd.limitedpartnerid = lppp.limitedpartnerid
                    WHERE lppp.objectid = lp.objectid
                          AND lppp.vehicleid = cc.fundid
                          AND lppp.date <= ISNULL(MAX(cc.calldate), GETDATE())
                ), 0) + ISNULL(
                (
                    SELECT-1 * SUM(ShareAmount)
                    FROM tbl_CommitmentTransfer lp1
                         JOIN tbl_CommitmentTransferFundShare lpd ON lp1.CommitmentTransferID = lpd.CommitmentTransferID
                         JOIN tbl_vehicleShare vs ON vs.VehicleShareID = lpd.FundShareID
                         JOIN tbl_LimitedPartner t ON lp1.FromLPID = t.LimitedPartnerID
                                                      AND lp1.FromModuleID = t.ModuleID
                                                      AND t.VehicleID = lp1.FundID
                    WHERE lp1.FundID = cc.fundid
                          AND lp1.Date <= ISNULL(MAX(cc.calldate), GETDATE())
                          AND lp1.FromObjectID = lp.objectid
                          AND lp1.FromModuleID = lp.ModuleID
                ), 0) + ISNULL(
                (
                    SELECT SUM(ShareAmount)
                    FROM tbl_CommitmentTransfer lp1
                         JOIN tbl_CommitmentTransferFundShare lpd ON lp1.CommitmentTransferID = lpd.CommitmentTransferID
                         JOIN tbl_vehicleShare vs ON vs.VehicleShareID = lpd.ToShareID
                         LEFT JOIN tbl_LimitedPartner t ON lp1.ToLPID = t.LimitedPartnerID
                                                           AND lp1.ToModuleID = t.ModuleID
                                                           AND t.VehicleID = lp1.FundID
                    WHERE lp1.FundID = cc.fundid
                          AND lp1.Date <= ISNULL(MAX(cc.calldate), GETDATE())
                          AND lp1.ToObjectID = lp.objectid
                          AND lp1.ToModuleID = lp.ModuleID
                ), 0) AS 'LPCommitment', 
                       ISNULL(
                (
                    SELECT ISNULL(SUM(ISNULL(lpd.amount, 0)), 0)
                    FROM tbl_limitedpartnerdetail lpd
                         JOIN tbl_limitedpartner lppp ON lpd.limitedpartnerid = lppp.limitedpartnerid
                    WHERE lppp.objectid = lp.objectid
                          AND lppp.vehicleid = cc.fundid
                          AND lpd.shareid = cclp.shareid
                          AND lppp.date <= ISNULL(MAX(cc.calldate), GETDATE())
                ), 0) + ISNULL(
                (
                    SELECT-1 * SUM(ShareAmount)
                    FROM tbl_CommitmentTransfer lp1
                         JOIN tbl_CommitmentTransferFundShare lpd ON lp1.CommitmentTransferID = lpd.CommitmentTransferID
                         JOIN tbl_vehicleShare vs ON vs.VehicleShareID = lpd.FundShareID
                         JOIN tbl_LimitedPartner t ON lp1.FromLPID = t.LimitedPartnerID
                                                      AND lp1.FromModuleID = t.ModuleID
                                                      AND t.VehicleID = lp1.FundID
                    WHERE lp1.FundID = cc.fundid
                          AND vs.VehicleShareID = cclp.ShareID
                          AND lp1.Date <= ISNULL(MAX(cc.calldate), GETDATE())
                          AND lp1.FromObjectID = lp.objectid
                          AND lp1.FromModuleID = lp.ModuleID
                ), 0) + ISNULL(
                (
                    SELECT SUM(ShareAmount)
                    FROM tbl_CommitmentTransfer lp1
                         JOIN tbl_CommitmentTransferFundShare lpd ON lp1.CommitmentTransferID = lpd.CommitmentTransferID
                         JOIN tbl_vehicleShare vs ON vs.VehicleShareID = lpd.ToShareID
                         LEFT JOIN tbl_LimitedPartner t ON lp1.ToLPID = t.LimitedPartnerID
                                                           AND lp1.ToModuleID = t.ModuleID
                                                           AND t.VehicleID = lp1.FundID
                    WHERE lp1.FundID = cc.fundid
                          AND vs.VehicleShareID = ISNULL(cclp.ShareID, vs.VehicleShareID)
                          AND lp1.Date <= ISNULL(MAX(cc.calldate), GETDATE())
                          AND lp1.ToObjectID = lp.objectid
                          AND lp1.ToModuleID = lp.ModuleID
                ), 0) AS 'LPShareCommitment', 
                       CAST(SUM(cclp.amount) AS DECIMAL(18, 3)) AS 'NetContributedCapital', 
                       ISNULL(
                (
                    SELECT SUM(inndistlp.amount)
                    FROM tbl_distributionlimitedpartner inndistlp
                         JOIN tbl_distribution inndist ON inndist.distributionid = inndistlp.distributionid
                         JOIN tbl_LimitedPartner lp1 ON inndistlp.limitedpartnerid = lp1.limitedpartnerid
                    WHERE inndist.fundid = cc.fundid
                          AND lp1.ObjectID = lp.ObjectID
                          AND lp1.ModuleID = lp.ModuleID
                          AND inndist.date <= ISNULL(MAX(cc.calldate), GETDATE())
                ), 0) AS 'CumulatedDistributions', 
                       ISNULL(
                (
                    SELECT SUM(inndistlp.amount)
                    FROM tbl_distributionlimitedpartner inndistlp
                         JOIN tbl_distribution inndist ON inndist.distributionid = inndistlp.distributionid
                         JOIN tbl_LimitedPartner lp1 ON inndistlp.limitedpartnerid = lp1.limitedpartnerid
                    WHERE inndist.fundid = cc.fundid
                          AND lp1.ObjectID = lp.ObjectID
                          AND lp1.ModuleID = lp.ModuleID
                          AND inndistlp.shareid = cclp.shareid
                          AND inndist.date <= ISNULL(MAX(cc.calldate), GETDATE())
                ), 0) AS 'LPShareCumulatedDistributions', 
                       ISNULL(
                (
                    SELECT SUM(amount)
                    FROM tbl_vehiclenavlimitedpartner innvehNavlp
                         JOIN tbl_vehiclenav innvehNav ON innvehNavlp.vehiclenavid = innvehNav.vehiclenavid
                         JOIN tbl_LimitedPartner lp1 ON innvehNavlp.limitedpartnerid = lp1.limitedpartnerid
                    WHERE innvehNav.vehicleid = cc.fundid
                          AND lp1.ObjectID = lp.ObjectID
                          AND lp1.ModuleID = lp.ModuleID
                ), 0) AS 'LastNAV', 
                       MAX(vbd.[accountname]) AS 'AccountName', 
                       MAX(vbd.[accountnumber]) AS 'AccountNumber', 
                       MAX(vbd.[accountiban]) AS 'AccountIBAN', 
                       MAX(vbd.[bankswift]) AS 'BankSWIFT', 
                       MAX(vbd.[accountcurrencyid]) AS 'AccountCurrencyID', 
                       MAX(vbd.[custodianid]) AS 'CustodianID', 
                (
                    SELECT SUM((innncclp.amount * (CASE
                                                       WHEN PP.total > 0
                                                       THEN PP.investmentamount / PP.total
                                                       ELSE 0
                                                   END))) AS LPInvestment
                    FROM tbl_capitalcalllimitedpartner innncclp
                         JOIN
                    (
                        SELECT ccop.capitalcallid, 
                               ccop.shareid, 
                               ccop.investmentamount, 
                               ccop.managementfees, 
                               ccop.otherfees, 
                               (ccop.investmentamount + ccop.managementfees + ccop.otherfees) AS Total
                        FROM tbl_capitalcalloperation ccop
                    ) PP ON innncclp.capitalcallid = PP.capitalcallid
                         JOIN tbl_LimitedPartner lp1 ON innncclp.limitedpartnerid = lp1.limitedpartnerid
                                                        AND innncclp.shareid = PP.shareid
                    WHERE innncclp.capitalcallid = cc.capitalcallid
                          AND lp1.ObjectID = lp.ObjectID
                          AND lp1.ModuleID = lp.ModuleID
                ) AS 'LPInvestment', 
                (
                    SELECT SUM((innncclp.amount * (CASE
                                                       WHEN PP.total > 0
                                                       THEN PP.managementfees / PP.total
                                                       ELSE 0
                                                   END))) AS LPManagementFees
                    FROM tbl_capitalcalllimitedpartner innncclp
                         JOIN
                    (
                        SELECT ccop.capitalcallid, 
                               ccop.shareid, 
                               ccop.investmentamount, 
                               ccop.managementfees, 
                               ccop.otherfees, 
                               (ccop.investmentamount + ccop.managementfees + ccop.otherfees) AS Total
                        FROM tbl_capitalcalloperation ccop
                    ) PP ON innncclp.capitalcallid = PP.capitalcallid
                            AND innncclp.shareid = PP.shareid
                         JOIN tbl_LimitedPartner lp1 ON innncclp.limitedpartnerid = lp1.limitedpartnerid
                    WHERE innncclp.capitalcallid = cc.capitalcallid
                          AND lp1.ObjectID = lp.ObjectID
                          AND lp1.ModuleID = lp.ModuleID
                ) AS 'LPManagementFees', 
                (
                    SELECT SUM((innncclp.amount * (CASE
                                                       WHEN PP.total > 0
                                                       THEN PP.otherfees / PP.total
                                                       ELSE 0
                                                   END))) AS LPOtherFees
                    FROM tbl_capitalcalllimitedpartner innncclp
                         JOIN
                    (
                        SELECT ccop.capitalcallid, 
                               ccop.shareid, 
                               ccop.investmentamount, 
                               ccop.managementfees, 
                               ccop.otherfees, 
                               (ccop.investmentamount + ccop.managementfees + ccop.otherfees) AS Total
                        FROM tbl_capitalcalloperation ccop
                    ) PP ON innncclp.capitalcallid = PP.capitalcallid
                            AND innncclp.shareid = PP.shareid
                         JOIN tbl_LimitedPartner lp1 ON innncclp.limitedpartnerid = lp1.limitedpartnerid
                    WHERE innncclp.capitalcallid = cc.capitalcallid
                          AND lp1.ObjectID = lp.ObjectID
                          AND lp1.ModuleID = lp.ModuleID
                ) AS 'LPOtherFees', 
                       ISNULL((CASE
                                   WHEN lp.moduleid = 4
                                   THEN ' '
                                   ELSE
                (
                    SELECT TOP 1 CC.companyname
                    FROM [tbl_companycontact] CC
                    WHERE CC.companycontactid = lp.objectid
                )
                               END), 'N/A') AS 'LPCompany', 
                       ISNULL((CASE
                                   WHEN lp.moduleid = 4
                                   THEN
                (
                    SELECT TOP 1 CI.individualaddress
                    FROM [tbl_contactindividual] CI
                    WHERE CI.individualid = lp.objectid
                )
                                   WHEN lp.moduleid = 5
                                   THEN
                (
                    SELECT TOP 1 CC.officeaddress
                    FROM tbl_companyoffice CC
                    WHERE CC.companycontactid = lp.objectid
                )
                                   WHEN lp.moduleid = 3
                                   THEN
                (
                    SELECT TOP 1 v.FundAddress
                    FROM tbl_vehicle v
                    WHERE v.VehicleID = lp.objectid
                )
                               END), 'N/A') AS 'LPAddress', 
                       ISNULL((CASE
                                   WHEN lp.moduleid = 4
                                   THEN
                (
                    SELECT countryname
                    FROM tbl_country
                    WHERE countryid =
                    (
                        SELECT TOP 1 CI.individualcountryid
                        FROM [tbl_contactindividual] CI
                        WHERE CI.individualid = lp.objectid
                    )
                )
                                   WHEN lp.moduleid = 5
                                   THEN
                (
                    SELECT countryname
                    FROM tbl_country
                    WHERE countryid =
                    (
                        SELECT TOP 1 CC.countryid
                        FROM tbl_companyoffice CC
                        WHERE CC.companycontactid = lp.objectid
                    )
                )
                                   WHEN lp.moduleid = 3
                                   THEN
                (
                    SELECT countryname
                    FROM tbl_country
                    WHERE countryid =
                    (
                        SELECT TOP 1 v.CountryID
                        FROM tbl_vehicle v
                        WHERE v.VehicleID = lp.objectid
                    )
                )
                               END), 'N/A') AS 'LPCountry', 
                       ISNULL((CASE
                                   WHEN lp.moduleid = 4
                                   THEN
                (
                    SELECT StateTitle
                    FROM tbl_State
                    WHERE StateID =
                    (
                        SELECT TOP 1 ci.StateID
                        FROM [tbl_contactindividual] CI
                        WHERE CI.individualid = lp.objectid
                              AND CI.IndividualCountryID = 471
                    )
                )
                                   WHEN lp.moduleid = 5
                                   THEN
                (
                    SELECT StateTitle
                    FROM tbl_State
                    WHERE StateID =
                    (
                        SELECT TOP 1 cc.StateID
                        FROM tbl_companyoffice CC
                        WHERE CC.companycontactid = lp.objectid
                              AND cc.CountryID = 471
                    )
                )
                                   WHEN lp.moduleid = 3
                                   THEN
                (
                    SELECT StateTitle
                    FROM tbl_State
                    WHERE StateID =
                    (
                        SELECT TOP 1 v.StateID
                        FROM tbl_vehicle v
                        WHERE v.VehicleID = lp.objectid
                              AND v.CountryID = 471
                    )
                )
                               END), 'N/A') AS 'LPState', 
                       ISNULL((CASE
                                   WHEN lp.moduleid = 4
                                   THEN
                (
                    SELECT cityname
                    FROM tbl_city
                    WHERE cityid =
                    (
                        SELECT TOP 1 CI.individualcityid
                        FROM [tbl_contactindividual] CI
                        WHERE CI.individualid = lp.objectid
                    )
                )
                                   WHEN lp.moduleid = 5
                                   THEN
                (
                    SELECT cityname
                    FROM tbl_city
                    WHERE cityid =
                    (
                        SELECT TOP 1 CC.cityid
                        FROM tbl_companyoffice CC
                        WHERE CC.companycontactid = lp.objectid
                    )
                )
                                   WHEN lp.moduleid = 3
                                   THEN
                (
                    SELECT CityName
                    FROM tbl_city
                    WHERE cityID =
                    (
                        SELECT TOP 1 v.City
                        FROM tbl_vehicle v
                        WHERE v.VehicleID = lp.objectid
                    )
                )
                               END), 'N/A') AS 'LPCity', 
                       ISNULL((CASE
                                   WHEN lp.moduleid = 4
                                   THEN
                (
                    SELECT TOP 1 CI.individualzipcode
                    FROM [tbl_contactindividual] CI
                    WHERE CI.individualid = lp.objectid
                )
                                   WHEN lp.moduleid = 5
                                   THEN
                (
                    SELECT TOP 1 CC.officezip
                    FROM tbl_companyoffice CC
                    WHERE CC.companycontactid = lp.objectid
                )
                                   WHEN lp.moduleid = 3
                                   THEN
                (
                    SELECT TOP 1 v.ZipCode
                    FROM tbl_vehicle v
                    WHERE v.VehicleID = lp.objectid
                )
                               END), 'N/A') AS 'LPZipCode', 
                       cc.callname, 
                (
                    SELECT curr.currencycode
                    FROM tbl_currency curr
                    WHERE curr.currencyid = MAX(vbd.[accountcurrencyid])
                ) AS 'CurrencyCode', 
                       ISNULL(MAX(branchcode), 'N/A') AS BranchCode, 
                       ISNULL(MAX(sortcode), 'N/A') AS SortCode, 
                       ISNULL(MAX(ribcode), 'N/A') AS RIBCode, 
                       ISNULL(
                (
                    SELECT cc.companyname
                    FROM tbl_companycontact cc
                    WHERE cc.companycontactid = MAX(vbd.[custodianid])
                ), '') AS CustodianName, 
                (
                    SELECT ISNULL(SUM(ISNULL(lpdinnn.amount, 0)), 0)
                    FROM tbl_limitedpartnerdetail lpdinnn
                    WHERE lpdinnn.limitedpartnerid IN
                    (
                        SELECT lpinnn.limitedpartnerid
                        FROM tbl_limitedpartner lpinnn
                        WHERE lpinnn.vehicleid = cc.fundid
                              AND lpinnn.date <= MAX(ISNULL(cc.CallDate, GETDATE()))
                    )
                ) AS 'TotalCommitments', 
                (
                    SELECT ISNULL(SUM(ISNULL(lpdinnn.amount, 0)), 0)
                    FROM tbl_limitedpartnerdetail lpdinnn
                    WHERE lpdinnn.limitedpartnerid IN
                    (
                        SELECT lpinnn.limitedpartnerid
                        FROM tbl_limitedpartner lpinnn
                        WHERE lpinnn.vehicleid = cc.fundid
                    )
                          AND lpdinnn.shareid = cclp.shareid
                ) AS 'TotalShareCommitments', 
                (
                    SELECT ISNULL(SUM(ISNULL(lpdinnn.amount, 0)), 0)
                    FROM tbl_limitedpartnerdetail lpdinnn
                    WHERE lpdinnn.limitedpartnerid IN
                    (
                        SELECT lpinnn.limitedpartnerid
                        FROM tbl_limitedpartner lpinnn
                        WHERE lpinnn.vehicleid = cc.fundid
                              AND lpinnn.date <= MAX(ISNULL(cc.calldate, GETDATE()))
                    )
                          AND lpdinnn.shareid = cclp.shareid
                ) AS 'TotalShareCommitmentsAsOfDate', 
                       CAST(
                (
                    SELECT ISNULL(SUM(cclpinn.amount), 0)
                    FROM tbl_capitalcalllimitedpartner cclpinn
                         JOIN tbl_LimitedPartner lp1 ON cclpinn.limitedpartnerid = lp1.limitedpartnerid
                    WHERE lp1.ObjectID = lp.ObjectID
                          AND lp1.ModuleID = lp.ModuleID
                          AND cclpinn.capitalcallid IN
                    (
                        SELECT capitalcallid
                        FROM tbl_capitalcall
                        WHERE fundid = cc.fundid
                              AND calldate <= MAX(cc.calldate)
                    )
                          AND shareid = cclp.shareid
                ) AS DECIMAL(18, 8)) AS 'LPShareNetContributed', 
                       ISNULL(
                (
                    SELECT TOP 1 abcd.navpershare
                    FROM tbl_vehiclenavlimitedpartner innvehNavlp
                         JOIN tbl_vehiclenav innvehNav ON innvehNavlp.vehiclenavid = innvehNav.vehiclenavid
                         JOIN tbl_vehiclenavdetails abcd ON abcd.vehiclenavid = innvehNav.vehiclenavid
                         JOIN tbl_LimitedPartner lp1 ON innvehNavlp.limitedpartnerid = lp1.limitedpartnerid
                    WHERE innvehNav.vehicleid = cc.fundid
                          AND innvehNavlp.shareid = cclp.shareid
                          AND lp1.ObjectID = lp.ObjectID
                          AND lp1.ModuleID = lp.ModuleID
                          AND innvehNav.navdate <= MAX(cc.calldate)
                    ORDER BY innvehNav.navdate DESC
                ), 0) AS 'LastEffectiveNAV', 
                       CAST(ISNULL(
                (
                    SELECT SUM(ISNULL(ii.amount, 0))
                    FROM tbl_capitalcalllimitedpartner ii
                         JOIN tbl_capitalcall bb ON ii.capitalcallid = bb.capitalcallid
                         JOIN tbl_LimitedPartner lp1 ON ii.limitedpartnerid = lp1.limitedpartnerid
                    WHERE bb.calldate <= MAX(cc.calldate)
                          AND bb.calldate >= ISNULL(
                    (
                        SELECT MAX(navdate)
                        FROM tbl_vehiclenav nv
                        WHERE vehicleid = cc.fundid
                              AND nv.NavDate <= bb.calldate
                    ), bb.calldate)
                          AND bb.fundid = cc.fundid
                          AND lp1.ObjectID = lp.ObjectID
                          AND lp1.ModuleID = lp.ModuleID
                          AND ii.shareid = cclp.shareid
                ), 0) AS DECIMAL(18, 5)) AS 'CumulatedCallsForAdjNAV', 
                       ISNULL(
                (
                    SELECT SUM(ISNULL(ii.amount, 0))
                    FROM tbl_distributionlimitedpartner ii
                         JOIN tbl_distribution bb ON ii.distributionid = bb.distributionid
                         JOIN tbl_LimitedPartner lp1 ON ii.limitedpartnerid = lp1.limitedpartnerid
                    WHERE bb.date <= MAX(cc.calldate)
                          AND bb.date >= ISNULL(
                    (
                        SELECT MAX(navdate)
                        FROM tbl_vehiclenav nv
                        WHERE vehicleid = cc.fundid
                              AND nv.navdate < cc.calldate
                    ), bb.date)
                          AND bb.fundid = cc.fundid
                          AND lp1.ObjectID = lp.ObjectID
                          AND lp1.ModuleID = lp.ModuleID
                          AND ii.shareid = cclp.shareid
                ), 0) AS 'CumulatedDistributionForAdjNAV', 
                (
                    SELECT mancom.companyname
                    FROM tbl_companycontact mancom
                    WHERE companycontactid =
                    (
                        SELECT veh.managementcompanyid
                        FROM tbl_vehicle veh
                        WHERE veh.vehicleid = cc.fundid
                    )
                ) AS 'ManagementCompanyName', 
                       co.InvestmentAmount, 
                       co.ManagementFees, 
                       co.OtherFees,

                --dbo.F_GetAdjustedNav(cc.CapitalCallID, lp.ObjectID, lp.ModuleID, cc.FundID, cclp.ShareID, cc.Calldate) LPAdjustedNav,

                       0.0 LPAdjustedNav,
                       CASE
                           WHEN lp.moduleid = 5
                           THEN
                (
                    SELECT TOP 1 greetings1
                    FROM tbl_companyOptionalBis b
                    WHERE b.CompanyId = lp.ObjectID
                )
                           WHEN lp.moduleid = 4
                           THEN
                (
                    SELECT TOP 1 greetings1
                    FROM tbl_ContactIndividualOptional b
                    WHERE b.IndividualID = lp.ObjectID
                )
                       END Greetings1,
                       CASE
                           WHEN lp.moduleid = 5
                           THEN
                (
                    SELECT TOP 1 greetings2
                    FROM tbl_companyOptionalBis b
                    WHERE b.CompanyId = lp.ObjectID
                )
                           WHEN lp.moduleid = 4
                           THEN
                (
                    SELECT TOP 1 greetings2
                    FROM tbl_ContactIndividualOptional b
                    WHERE b.IndividualID = lp.ObjectID
                )
                       END Greetings2
                FROM tbl_capitalcall cc
                     JOIN tbl_capitalcalllimitedpartner cclp ON cc.capitalcallid = cclp.capitalcallid
                     JOIN tbl_limitedpartner lp ON lp.limitedpartnerid = cclp.limitedpartnerid
                     LEFT JOIN tbl_vehiclebankdetails vbd ON cc.fundid = vbd.vehicleid
                     LEFT JOIN tbl_CapitalCallOperation co ON co.CapitalCallID = cc.CapitalCallID
                                                              AND co.ShareID = cclp.ShareID
                WHERE cc.capitalcallid = @CapitalCallID
                GROUP BY cc.fundid, 
                         cc.capitalcallid, 
                         cclp.shareid, 
                         lp.objectid, 
                         lp.moduleid, 
                         cc.callname, 
                         cc.CallNameFR, 
                         cc.NotesFR, 
                         cc.Calldate, 
                         co.InvestmentAmount, 
                         co.ManagementFees, 
                         co.OtherFees
            ) P
            WHERE P.lpsharecommitment IS NOT NULL
                  AND P.lpsharecommitment <> 0
                  AND P.effectivesharecallamount IS NOT NULL
                  AND P.effectivesharecallamount <> 0
        ) Q
        ORDER BY Q.lpfullname, 
                 Q.sharename;
    END;
