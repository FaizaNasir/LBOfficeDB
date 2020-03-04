-- =============================================  
-- Author:      
-- Create date:   
-- Description:    
-- =============================================  
-- Proc_getcapitalcallreportbycapitalcallid 35--24--32  

CREATE PROCEDURE [dbo].[Proc_getcapitalcallreportbycapitalcallidBU31May2017]

-- Add the parameters for the stored procedure here  

@CapitalCallID INT
AS
    BEGIN

        -- SET NOCOUNT ON added to prevent extra result sets from  
        -- interfering with SELECT statements.  

        SET NOCOUNT ON;

        -- Insert statements for procedure here  

        SELECT Q.*, 
               ISNULL(((Q.lasteffectivenav * Q.lpsharesowned) + ISNULL(Q.cumulatedcallsforadjnav, 0) - ISNULL(Q.cumulateddistributionforadjnav, 0)), 0) AS 'AdjustedNAV'
        FROM
        (
            SELECT P.*, 
                   (P.lpcommitment - P.lpcallamount) AS 'UncalledCommitments', 
                   (ISNULL(P.lpsharecommitment, 0) - ISNULL(P.lpsharecallamount, 0)) AS 'LPShareUncalledCommitments', 
                   ((P.lpsharecommitment / ISNULL(P.totalsharecommitments, 1))) * 100 AS 'LPShareCommitmentPercentage', 
                   ((P.lpsharecallamount / ISNULL(P.totalsharecommitments, 1))) * 100 AS 'LPShareCapitalPercentage', 
                   ((P.lpsharecommitment) /
            (
                SELECT ISNULL(a.nominalvalue, 1)
                FROM tbl_vehicleshare a
                WHERE a.vehicleid = P.fundid
                      AND a.vehicleshareid = P.shareid
            )) AS 'LPSharesOwned'
            FROM
            (
                SELECT cc.fundid, 
                       ISNULL(MAX(cc.calldate), '') AS CallDate, 
                       MAX(cc.duedate) AS DueDate, 
                       MAX(cc.notes) AS Notes, 
                       ISNULL(
                (
                    SELECT(CASE
                               WHEN lp.moduleid = 4
                               THEN
                    (
                        SELECT TOP 1 ISNULL(CI.individualtitle, '') + ' ' + ISNULL(CI.individualfirstname, '') + ' ' + ISNULL(CI.individuallastname, '')

                        -- + CI.individualfullname  

                        FROM [tbl_contactindividual] CI
                        WHERE CI.individualid = lp.objectid
                    )
                               WHEN lp.moduleid = 5
                               THEN
                    (
                        SELECT TOP 1 ISNULL(CI.individualtitle, '') + ' ' + -- +  isnull(CI.IndividualFirstName,'') + ' ' + isnull(CI.IndividualLastName ,'') 

                                     CI.individualfullname
                        FROM [tbl_contactindividual] CI
                             JOIN tbl_companyindividuals TCI ON CI.individualid = TCI.contactindividualid
                                                                AND TCI.ismainindividual = 1
                        WHERE TCI.companycontactid = lp.objectid
                    )
                           END)
                    FROM tbl_limitedpartner lp
                    WHERE lp.limitedpartnerid = cclp.limitedpartnerid
                ), 'N/A') AS LimitedPartnerName, 
                       ISNULL(
                (
                    SELECT(CASE
                               WHEN lp.moduleid = 4
                               THEN
                    (
                        SELECT TOP 1 ISNULL(CI.individualfirstname, '') + ' ' + ISNULL(CI.individuallastname, '')
                        FROM [tbl_contactindividual] CI
                        WHERE CI.individualid = lp.objectid
                    )
                               WHEN lp.moduleid = 5
                               THEN
                    (
                        SELECT TOP 1 CI.individualfullname
                        FROM [tbl_contactindividual] CI
                             JOIN tbl_companyindividuals TCI ON CI.individualid = TCI.contactindividualid
                                                                AND TCI.ismainindividual = 1
                        WHERE TCI.companycontactid = lp.objectid
                    )
                           END)
                    FROM tbl_limitedpartner lp
                    WHERE lp.limitedpartnerid = cclp.limitedpartnerid
                ), 'N/A') AS LPFullName, 
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
                       cclp.limitedpartnerid, 
                       cclp.shareid, 
                (
                    SELECT innvs.sharename
                    FROM tbl_vehicleshare innvs
                    WHERE innvs.vehicleshareid = cclp.shareid
                          AND innvs.vehicleid = cc.fundid
                ) AS 'ShareName', 
                (
                    SELECT SUM(ISNULL(cclpinn.amount, 0))
                    FROM tbl_capitalcalllimitedpartner cclpinn
                    WHERE cclpinn.capitalcallid = cc.capitalcallid
                          AND cclpinn.limitedpartnerid = cclp.limitedpartnerid
                ) AS LPCallAmount, 
                (
                    SELECT SUM(ISNULL(cclpinn.amount, 0))
                    FROM tbl_capitalcalllimitedpartner cclpinn
                    WHERE cclpinn.capitalcallid = cc.capitalcallid
                          AND cclpinn.limitedpartnerid = cclp.limitedpartnerid
                          AND cclpinn.shareid = cclp.shareid
                ) AS LPShareCallAmount, 
                (
                    SELECT SUM(lpd.amount)
                    FROM tbl_limitedpartnerdetail lpd
                         JOIN tbl_limitedpartner lppp ON lpd.limitedpartnerid = lppp.limitedpartnerid
                    WHERE lpd.limitedpartnerid = cclp.limitedpartnerid
                          AND lppp.date <= ISNULL(MAX(cc.calldate), GETDATE())
                ) AS 'LPCommitment', 
                (
                    SELECT ISNULL(SUM(ISNULL(lpd.amount, 0)), 0)
                    FROM tbl_limitedpartnerdetail lpd
                         JOIN tbl_limitedpartner lppp ON lpd.limitedpartnerid = lppp.limitedpartnerid
                    WHERE lppp.ObjectID = lp.ObjectID
                          AND lppp.VehicleID = cc.fundid
                          AND lpd.shareid = cclp.shareid
                          AND lppp.date <= ISNULL(MAX(cc.calldate), GETDATE())
                ) AS 'LPShareCommitment', 
                       SUM(cclp.amount) AS 'NetContributedCapital', 
                       ISNULL(
                (
                    SELECT SUM(inndistlp.amount)
                    FROM tbl_distributionlimitedpartner inndistlp
                         JOIN tbl_distribution inndist ON inndist.distributionid = inndistlp.distributionid
                    WHERE inndist.fundid = cc.fundid
                          AND inndistlp.limitedpartnerid = cclp.limitedpartnerid
                ), 0) AS 'CumulatedDistributions', 
                       ISNULL(
                (
                    SELECT SUM(inndistlp.amount)
                    FROM tbl_distributionlimitedpartner inndistlp
                         JOIN tbl_distribution inndist ON inndist.distributionid = inndistlp.distributionid
                    WHERE inndist.fundid = cc.fundid
                          AND inndistlp.limitedpartnerid = cclp.limitedpartnerid
                          AND inndistlp.shareid = cclp.shareid
                ), 0) AS 'LPShareCumulatedDistributions', 
                       ISNULL(
                (
                    SELECT SUM(amount)
                    FROM tbl_vehiclenavlimitedpartner innvehNavlp
                         JOIN tbl_vehiclenav innvehNav ON innvehNavlp.vehiclenavid = innvehNav.vehiclenavid
                    WHERE innvehNav.vehicleid = cc.fundid
                          AND innvehNavlp.limitedpartnerid = cclp.limitedpartnerid
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
                            AND innncclp.shareid = PP.shareid
                    WHERE innncclp.capitalcallid = cc.capitalcallid
                          AND innncclp.limitedpartnerid = cclp.limitedpartnerid
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
                    WHERE innncclp.capitalcallid = cc.capitalcallid
                          AND innncclp.limitedpartnerid = cclp.limitedpartnerid
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
                    WHERE innncclp.capitalcallid = cc.capitalcallid
                          AND innncclp.limitedpartnerid = cclp.limitedpartnerid
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
                                   ELSE
                (
                    SELECT TOP 1 CC.companyaddress
                    FROM [tbl_companycontact] CC
                    WHERE CC.companycontactid = lp.objectid
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
                        SELECT TOP 1 CC.companycountryid
                        FROM [tbl_companycontact] CC
                        WHERE CC.companycontactid = lp.objectid
                    )
                )
                               END), 'N/A') AS 'LPCountry', 
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
                        SELECT TOP 1 CC.companycityid
                        FROM [tbl_companycontact] CC
                        WHERE CC.companycontactid = lp.objectid
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
                    SELECT TOP 1 CC.companyzip
                    FROM [tbl_companycontact] CC
                    WHERE CC.companycontactid = lp.objectid
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
                              AND lpinnn.date <= MAX(cc.duedate)
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
                              AND lpinnn.date <= MAX(cc.calldate)
                    )
                          AND lpdinnn.shareid = cclp.shareid
                ) AS 'TotalShareCommitments', 
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
                ) AS 'LPShareNetContributed', 
                       ISNULL(
                (
                    SELECT TOP 1 abcd.navpershare
                    FROM tbl_vehiclenavlimitedpartner innvehNavlp
                         JOIN tbl_vehiclenav innvehNav ON innvehNavlp.vehiclenavid = innvehNav.vehiclenavid
                         JOIN tbl_vehiclenavdetails abcd ON abcd.vehiclenavid = innvehNav.vehiclenavid
                    WHERE innvehNav.vehicleid = cc.fundid
                          AND innvehNavlp.shareid = cclp.shareid
                          AND innvehNavlp.limitedpartnerid = cclp.limitedpartnerid
                          AND innvehNav.navdate <= MAX(cc.calldate)
                    ORDER BY innvehNav.navdate DESC
                ), 0) AS 'LastEffectiveNAV', 
                (
                    SELECT SUM(ISNULL(ii.amount, 0))
                    FROM tbl_capitalcalllimitedpartner ii
                         JOIN tbl_capitalcall bb ON ii.capitalcallid = bb.capitalcallid
                    WHERE bb.calldate <= MAX(cc.calldate)
                          AND bb.calldate > ISNULL(
                    (
                        SELECT MAX(navdate)
                        FROM tbl_vehiclenav
                        WHERE vehicleid = cc.fundid
                    ), bb.calldate)
                          AND bb.fundid = cc.fundid
                          AND ii.limitedpartnerid = cclp.limitedpartnerid
                          AND ii.shareid = cclp.shareid
                ) AS 'CumulatedCallsForAdjNAV', 
                (
                    SELECT SUM(ISNULL(ii.amount, 0))
                    FROM tbl_distributionlimitedpartner ii
                         JOIN tbl_distribution bb ON ii.distributionid = bb.distributionid
                    WHERE bb.date <= MAX(cc.calldate)
                          AND bb.date >= ISNULL(
                    (
                        SELECT MAX(navdate)
                        FROM tbl_vehiclenav
                        WHERE vehicleid = cc.fundid
                    ), bb.date)
                          AND bb.fundid = cc.fundid
                          AND ii.limitedpartnerid = cclp.limitedpartnerid
                          AND ii.shareid = cclp.shareid
                ) AS 'CumulatedDistributionForAdjNAV'
                FROM tbl_capitalcall cc
                     JOIN tbl_capitalcalllimitedpartner cclp ON cc.capitalcallid = cclp.capitalcallid
                     JOIN tbl_limitedpartner lp ON lp.limitedpartnerid = cclp.limitedpartnerid
                     LEFT JOIN tbl_vehiclebankdetails vbd ON cc.fundid = vbd.vehicleid
                WHERE cc.capitalcallid = @CapitalCallID
                GROUP BY cc.fundid, 
                         cc.capitalcallid, 
                         cclp.limitedpartnerid, 
                         cclp.shareid, 
                         lp.objectid, 
                         lp.moduleid, 
                         cc.callname
            ) P

                -- WHERE 
                -- P.lpsharecommitment IS NOT NULL 
                -- AND P.lpsharecommitment > 0

        ) Q
        ORDER BY Q.lpfullname, 
                 Q.sharename;

        --order by Q.limitedpartnerid,Q.ShareID 
        --select * from [tbl_ContactIndividual]  

    END;
