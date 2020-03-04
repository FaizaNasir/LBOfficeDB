CREATE PROCEDURE [dbo].[proc_GetDistributionReportByDistributionID] @DistributionID INT
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT Q.*, 
               ISNULL(((Q.lasteffectivenav * Q.lpsharesowned) + ISNULL(Q.cumulatedcallsforadjnav, 0) - ISNULL(Q.cumulateddistributionforadjnav, 0)), 0) AS 'AdjustedNAV'
        FROM
        (
            SELECT P.*, 
                   ISNULL((ISNULL(P.lpcommitment, 0) - P.netcontributedcapital), 0) AS 'UncalledCommitments', 
                   ISNULL((P.totalreturnofcapital / CASE
                                                        WHEN P.distributionamount > 0
                                                        THEN ISNULL(P.distributionamount, 1)
                                                        ELSE 1
                                                    END) * 100, 0) AS 'PercentReturnOfCapital', 
                   ISNULL((P.totalprofit / CASE
                                               WHEN P.distributionamount > 0
                                               THEN ISNULL(P.distributionamount, 1)
                                               ELSE 1
                                           END) * 100, 0) AS 'PercentProfit', 
                   ISNULL(((P.lpsharecommitment / CASE
                                                      WHEN P.totalsharecommitments > 0
                                                      THEN ISNULL(P.totalsharecommitments, 1)
                                                      ELSE 1
                                                  END)) * 100, 0) AS 'LPShareCommitmentPercentage', 
                   ((P.lpsharecommitment / ISNULL(P.TotalShareCommitmentsAsOfDate, 1))) * 100 AS 'varLPShareCommitmentPercentAsOfDate', 
                   ISNULL(((P.lpsharecallamount / CASE
                                                      WHEN P.totalsharecommitments > 0
                                                      THEN ISNULL(P.totalsharecommitments, 1)
                                                      ELSE 1
                                                  END)) * 100, 0) AS 'LPShareCapitalPercentage', 
                   (ISNULL(P.lpsharecommitment, 0) - ISNULL(P.lpsharenetcontributed, 0)) AS 'LPShareUncalledCommitments', 
                   ISNULL(((P.lpsharecommitment) /
            (
                SELECT CASE
                           WHEN a.nominalvalue > 0
                           THEN ISNULL(a.nominalvalue, 1)
                           ELSE 1
                       END
                FROM tbl_vehicleshare a
                WHERE a.vehicleid = P.fundid
                      AND a.vehicleshareid = P.shareid
            )), 0) AS 'LPSharesOwned'
            FROM
            (
                SELECT cc.fundid, 
                       ISNULL(MAX(cc.date), '') AS DistributionDate, 
                       cc.Notes, 
                       cc.NotesFr, 
                       ISNULL((CASE
                                   WHEN lp.moduleid = 4
                                   THEN
                (
                    SELECT TOP 1 ISNULL(CI.individualtitle, '') + ' ' + ISNULL(CI.individualfirstname, '') + ' ' + ISNULL(CI.IndividualLastName, '')
                    FROM [tbl_contactindividual] CI
                    WHERE CI.individualid = lp.objectid
                )
                                   WHEN lp.moduleid = 5
                                   THEN
                (
                    SELECT TOP 1 ISNULL(ci.individualtitle, '') + ' ' + ISNULL(ci.individualfirstname, '') + ' ' + ISNULL(ci.individuallastname, '')
                    FROM [tbl_contactindividual] CI
                         JOIN tbl_companyindividuals TCI ON CI.individualid = TCI.contactindividualid
                    WHERE TCI.companycontactid =
                    (
                        SELECT TOP 1 cc2.companycontactid
                        FROM [tbl_companycontact] CC2
                        WHERE CC2.companycontactid = lp.objectid
                    )
                          AND TCI.ismainindividual = 1
                )
                               END), 'N/A') AS LimitedPartnerName, 
                       ISNULL((CASE
                                   WHEN lp.moduleid = 4
                                   THEN
                (
                    SELECT TOP 1 ISNULL(CI.IndividualTitle, '') + ' ' + ISNULL(CI.individualfirstname, '') + ' ' + ISNULL(CI.individuallastname, '')
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
                               END), 'N/A') AS LPFullName, 
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
                (
                    SELECT ISNULL(veh.NAME, '')
                    FROM tbl_vehicle veh
                    WHERE veh.vehicleid = cc.fundid
                ) AS FundName, 
                       ISNULL(MAX(cc.totalamount), 0) AS DistributionAmount, 
                       cclp.limitedpartnerid, 
                       cclp.shareid, 
                       ISNULL(
                (
                    SELECT SUM(ISNULL(cclpinn.amount, 0))
                    FROM tbl_distributionlimitedpartner cclpinn
                    WHERE cclpinn.distributionid = cc.distributionid
                          AND cclpinn.limitedpartnerid = cclp.limitedpartnerid
                          AND cclpinn.ShareID = cclp.shareid
                ), 0) AS LPDistributionAmount, 
                       ISNULL(
                (
                    SELECT SUM(ISNULL(cclpinn.amount, 0))
                    FROM tbl_distributionlimitedpartner cclpinn
                    WHERE cclpinn.distributionid = cc.distributionid
                          AND cclpinn.shareid = cclp.shareid
                ), 0) AS ShareDistributionAmount, 
                       ISNULL(
                (
                    SELECT ISNULL(SUM(lpd.amount), 0)
                    FROM tbl_limitedpartnerdetail lpd
                         JOIN tbl_limitedpartner lppp ON lpd.limitedpartnerid = lppp.limitedpartnerid
                    WHERE lppp.ObjectID = lp.ObjectID
                ), 0) AS 'LPCommitment', 
                       ISNULL(
                (
                    SELECT SUM(inncclp.amount)
                    FROM tbl_capitalcalllimitedpartner inncclp
                    WHERE inncclp.limitedpartnerid = cclp.limitedpartnerid
                          AND inncclp.capitalcallid IN
                    (
                        SELECT inntblcap.capitalcallid
                        FROM tbl_capitalcall inntblcap
                        WHERE inntblcap.fundid = cc.fundid
                              AND inntblcap.duedate <= MAX(cc.date)
                    )
                ), 0) AS 'NetContributedCapital', 
                       ISNULL(
                (
                    SELECT SUM(inndistlp.amount)
                    FROM tbl_distributionlimitedpartner inndistlp
                         JOIN tbl_distribution inndist ON inndist.distributionid = inndistlp.distributionid
                    WHERE inndist.fundid = cc.fundid
                          AND inndistlp.limitedpartnerid = cclp.limitedpartnerid
                          AND Date <= MAX(cc.date)
                ), 0) AS 'CumulatedDistributions', 
                       ISNULL(
                (
                    SELECT SUM(amount)
                    FROM tbl_vehiclenavlimitedpartner innvehNavlp
                         JOIN tbl_vehiclenav innvehNav ON innvehNavlp.vehiclenavid = innvehNav.vehiclenavid
                    WHERE innvehNav.vehicleid = cc.fundid
                          AND innvehNavlp.limitedpartnerid = cclp.limitedpartnerid
                ), 0) AS 'LastNAV', 
                       ISNULL(MAX(vbd.[accountname]), '') AS 'AccountName', 
                       ISNULL(MAX(vbd.[accountnumber]), '') AS 'AccountNumber', 
                       ISNULL(MAX(vbd.[accountiban]), '') AS 'AccountIBAN', 
                       ISNULL(MAX(vbd.[bankswift]), '') AS 'BankSWIFT', 
                       ISNULL(MAX(vbd.[accountcurrencyid]), '') AS 'AccountCurrencyID', 
                       ISNULL(MAX(vbd.[custodianid]), '') AS 'CustodianID', 
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
                       (CASE
                            WHEN lp.moduleid = 4
                            THEN
                (
                    SELECT TOP 1 CI.LPTypeID
                    FROM [tbl_contactindividual] CI
                    WHERE CI.individualid = lp.objectid
                )
                            ELSE
                (
                    SELECT TOP 1 CC.LPTypeID
                    FROM tbl_companycontact CC
                    WHERE CC.companycontactid = lp.objectid
                )
                        END) AS 'LPTypeID', 
                       (CASE
                            WHEN lp.moduleid = 4
                            THEN
                (
                    SELECT TOP 1 CI.AccountName
                    FROM [tbl_contactindividual] CI
                    WHERE CI.individualid = lp.objectid
                )
                            ELSE
                (
                    SELECT TOP 1 CC.AccountName
                    FROM tbl_companycontact CC
                    WHERE CC.companycontactid = lp.objectid
                )
                        END) AS 'LPAccountName', 
                       ISNULL((CASE
                                   WHEN lp.moduleid = 4
                                   THEN
                (
                    SELECT TOP 1 CI.individualaddress
                    FROM [tbl_contactindividual] CI
                    WHERE CI.individualid = lp.objectid
                )
                                   ELSE
                (
                    SELECT TOP 1 CC.officeaddress
                    FROM tbl_companyoffice CC
                    WHERE CC.companycontactid = lp.objectid
                          AND cc.IsMain = 1
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
                                   ELSE
                (
                    SELECT countryname
                    FROM tbl_country
                    WHERE countryid =
                    (
                        SELECT TOP 1 CC.countryid
                        FROM tbl_companyoffice CC
                        WHERE CC.companycontactid = lp.objectid
                              AND cc.IsMain = 1
                    )
                )
                               END), 'N/A') AS 'LPCountry', 
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
                                   ELSE
                (
                    SELECT cityname
                    FROM tbl_city
                    WHERE cityid =
                    (
                        SELECT TOP 1 CC.cityid
                        FROM tbl_companyoffice CC
                        WHERE CC.companycontactid = lp.objectid
                              AND cc.IsMain = 1
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
                                   ELSE
                (
                    SELECT TOP 1 CC.officezip
                    FROM tbl_companyoffice CC
                    WHERE CC.companycontactid = lp.objectid
                          AND cc.IsMain = 1
                )
                               END), 'N/A') AS 'LPZipCode', 
                       cc.NAME, 
                       cc.NAMEFr, 
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
                       ISNULL(
                (
                    SELECT SUM(distop.returnofcapital)
                    FROM tbl_distributionoperation distop
                    WHERE distop.distributionid = cc.distributionid
                ), 0) AS TotalReturnOfCapital, 
                       ISNULL(
                (
                    SELECT SUM(distop.profit)
                    FROM tbl_distributionoperation distop
                    WHERE distop.distributionid = cc.distributionid
                ), 0) AS TotalProfit, 
                       ISNULL(
                (
                    SELECT SUM(PPIN.lpreturnofcapital) AS 'LPReturnOfCapital'
                    FROM
                    (
                        SELECT(distlp.amount * (returnofcapital / (CASE
                                                                       WHEN totaldistribution > 0
                                                                       THEN totaldistribution
                                                                       ELSE 1
                                                                   END))) AS 'LPReturnOfCapital'
                        FROM tbl_distributionlimitedpartner distlp
                             JOIN tbl_distributionoperation distop ON distlp.distributionid = distop.distributionid
                                                                      AND distlp.shareid = distop.shareid
                        WHERE distlp.distributionid = cc.distributionid
                              AND distlp.limitedpartnerid = cclp.limitedpartnerid
                    ) PPIN
                ), 0) AS LPReturnOfCapital, 
                       ISNULL(
                (
                    SELECT SUM(PPIN.lpprofit) AS 'LPProfit'
                    FROM
                    (
                        SELECT(distlp.amount * (profit / CASE
                                                             WHEN totaldistribution > 0
                                                             THEN totaldistribution
                                                             ELSE 1
                                                         END)) AS 'LPProfit'
                        FROM tbl_distributionlimitedpartner distlp
                             JOIN tbl_distributionoperation distop ON distlp.distributionid = distop.distributionid
                                                                      AND distlp.shareid = distop.shareid
                        WHERE distlp.distributionid = cc.distributionid
                              AND distlp.limitedpartnerid = cclp.limitedpartnerid
                    ) PPIN
                ), 0) AS LPProfit, 
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
                (
                    SELECT innvs.sharename
                    FROM tbl_vehicleshare innvs
                    WHERE innvs.vehicleshareid = cclp.shareid
                          AND innvs.vehicleid = cc.fundid
                ) AS 'ShareName', 
                (
                    SELECT innvs.sharenameFR
                    FROM tbl_vehicleshare innvs
                    WHERE innvs.vehicleshareid = cclp.shareid
                          AND innvs.vehicleid = cc.fundid
                ) AS 'ShareNameFR', 
                       ISNULL(
                (
                    SELECT ISNULL(SUM(lpd.amount), 0)
                    FROM tbl_limitedpartnerdetail lpd
                         JOIN tbl_limitedpartner lppp ON lpd.limitedpartnerid = lppp.limitedpartnerid
                    WHERE lppp.ObjectID = lp.ObjectID
                          AND lppp.VehicleID = cc.fundid
                          AND lpd.shareid = cclp.shareid
                ), 0) AS 'LPShareCommitment', 
                       ISNULL(
                (
                    SELECT ISNULL(SUM(ISNULL(lpdinnn.amount, 0)), 0)
                    FROM tbl_limitedpartnerdetail lpdinnn
                         JOIN tbl_limitedpartner lppp ON lpdinnn.limitedpartnerid = lppp.limitedpartnerid
                    WHERE lppp.ObjectID = lp.ObjectID
                          AND lppp.VehicleID = cc.fundid
                          AND lpdinnn.shareid = cclp.shareid
                          AND lppp.date <= ISNULL(MAX(cc.Date), GETDATE())
                ), 0) AS 'TotalShareCommitments', 
                (
                    SELECT ISNULL(SUM(ISNULL(lpdinnn.amount, 0)), 0)
                    FROM tbl_limitedpartnerdetail lpdinnn
                    WHERE lpdinnn.limitedpartnerid IN
                    (
                        SELECT lpinnn.limitedpartnerid
                        FROM tbl_limitedpartner lpinnn
                        WHERE lpinnn.vehicleid = cc.fundid
                              AND lpinnn.date <= MAX(ISNULL(cc.Date, GETDATE()))
                    )
                          AND lpdinnn.shareid = cclp.shareid
                ) AS 'TotalShareCommitmentsAsOfDate', 
                       ISNULL(
                (
                    SELECT SUM(ISNULL(cclpinn.amount, 0))
                    FROM tbl_capitalcalllimitedpartner cclpinn
                    WHERE cclpinn.capitalcallid IN
                    (
                        SELECT ISNULL(inntblcap.capitalcallid, 0)
                        FROM tbl_capitalcall inntblcap
                        WHERE inntblcap.fundid = cc.fundid
                              AND inntblcap.calldate <= ISNULL(MAX(cc.date), GETDATE())
                    )
                          AND cclpinn.limitedpartnerid = cclp.limitedpartnerid
                          AND cclpinn.shareid = cclp.shareid
                ), 0) AS LPShareCallAmount, 
                       ISNULL(
                (
                    SELECT TOP 1(ISNULL(tccop.investmentamount, 0) + ISNULL(tccop.managementfees, 0) + ISNULL(tccop.otherfees, 0))
                    FROM tbl_capitalcalloperation tccop
                    WHERE tccop.capitalcallid IN
                    (
                        SELECT ISNULL(inntblcap.capitalcallid, 0)
                        FROM tbl_capitalcall inntblcap
                        WHERE inntblcap.fundid = cc.fundid
                              AND ISNULL(inntblcap.calldate, GETDATE()) <= MAX(cc.date)
                    )
                          AND tccop.fundid = cc.fundid
                          AND tccop.shareid = cclp.shareid
                ), 0) AS EffectiveShareCallAmount, 
                       ISNULL(
                (
                    SELECT ISNULL(SUM(cclpinn.amount), 0)
                    FROM tbl_capitalcalllimitedpartner cclpinn
                    WHERE cclpinn.limitedpartnerid = cclp.limitedpartnerid
                          AND cclpinn.capitalcallid IN
                    (
                        SELECT capitalcallid
                        FROM tbl_capitalcall
                        WHERE fundid = cc.fundid
                    )
                          AND shareid = cclp.shareid
                ), 0) AS 'LPShareNetContributed', 
                       ISNULL(
                (
                    SELECT SUM(ISNULL(inndistlp.amount, 0))
                    FROM tbl_distributionlimitedpartner inndistlp
                         JOIN tbl_distribution inndist ON inndist.distributionid = inndistlp.distributionid
                    WHERE inndist.fundid = cc.fundid
                          AND inndistlp.limitedpartnerid = cclp.limitedpartnerid
                          AND inndistlp.shareid = cclp.shareid
                          AND Date <= MAX(cc.date)
                ), 0) AS 'LPShareCumulatedDistributions', 
                       ISNULL(
                (
                    SELECT TOP 1 abcd.navpershare
                    FROM tbl_vehiclenavlimitedpartner innvehNavlp
                         JOIN tbl_vehiclenav innvehNav ON innvehNavlp.vehiclenavid = innvehNav.vehiclenavid
                         JOIN tbl_vehiclenavdetails abcd ON abcd.vehiclenavid = innvehNav.vehiclenavid
                    WHERE innvehNav.vehicleid = cc.fundid
                          AND innvehNavlp.shareid = cclp.shareid
                          AND innvehNavlp.limitedpartnerid = cclp.limitedpartnerid
                          AND innvehNav.navdate <= MAX(cc.date)
                    ORDER BY innvehNav.navdate DESC
                ), 0) AS 'LastEffectiveNAV', 
                       ISNULL(
                (
                    SELECT SUM(ISNULL(ii.amount, 0))
                    FROM tbl_capitalcalllimitedpartner ii
                         JOIN tbl_capitalcall bb ON ii.capitalcallid = bb.capitalcallid
                    WHERE bb.calldate <= MAX(cc.date)
                          AND bb.calldate > ISNULL(
                    (
                        SELECT MAX(navdate)
                        FROM tbl_vehiclenav
                        WHERE vehicleid = cc.fundid
                    ), bb.calldate)
                          AND bb.fundid = cc.fundid
                          AND ii.limitedpartnerid = cclp.limitedpartnerid
                          AND ii.shareid = cclp.shareid
                ), 0) AS 'CumulatedCallsForAdjNAV', 
                       ISNULL(
                (
                    SELECT SUM(ISNULL(ii.amount, 0))
                    FROM tbl_distributionlimitedpartner ii
                         JOIN tbl_distribution bb ON ii.distributionid = bb.distributionid
                    WHERE bb.date <= MAX(cc.date)
                          AND bb.date >= ISNULL(
                    (
                        SELECT MAX(navdate)
                        FROM tbl_vehiclenav
                        WHERE vehicleid = cc.fundid
                    ), bb.date)
                          AND bb.fundid = cc.fundid
                          AND ii.limitedpartnerid = cclp.limitedpartnerid
                          AND ii.shareid = cclp.shareid
                ), 0) AS 'CumulatedDistributionForAdjNAV', 
                       ISNULL(
                (
                    SELECT tbdo.returnofcapital
                    FROM tbl_distributionoperation tbdo
                    WHERE tbdo.distributionid = cc.distributionid
                          AND tbdo.shareid = cclp.shareid
                ), 0) AS ShareReturnOfCapital, 
                       ISNULL(
                (
                    SELECT tbdo.profit
                    FROM tbl_distributionoperation tbdo
                    WHERE tbdo.distributionid = cc.distributionid
                          AND tbdo.shareid = cclp.shareid
                ), 0) AS ShareProfit, 
                       lp.ModuleID, 
                       lp.ObjectID
                FROM tbl_distribution cc
                     JOIN tbl_distributionlimitedpartner cclp ON cc.distributionid = cclp.distributionid
                     JOIN tbl_limitedpartner lp ON lp.limitedpartnerid = cclp.limitedpartnerid
                     LEFT JOIN tbl_vehiclebankdetails vbd ON cc.fundid = vbd.vehicleid
                WHERE cc.distributionid = @DistributionID
                GROUP BY cc.fundid, 
                         cc.distributionid, 
                         cclp.limitedpartnerid, 
                         cclp.shareid, 
                         lp.objectid, 
                         lp.moduleid, 
                         cc.NAME, 
                         cc.NAMEFr, 
                         cc.Notes, 
                         cc.NotesFr
            ) P
            WHERE P.lpsharecommitment IS NOT NULL
                  AND P.lpsharecommitment > 0
        ) Q
        ORDER BY Q.lpfullname, 
                 Q.sharename;
    END;
