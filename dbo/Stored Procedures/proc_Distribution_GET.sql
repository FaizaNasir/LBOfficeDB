CREATE PROCEDURE [dbo].[proc_Distribution_GET] @TargetFundID INT = NULL, 
                                              @shareID      INT = NULL
AS
    BEGIN
        SELECT s.NAME, 
               s.distributionid, 
               Format(s.date, 'yyyy-MM-dd') DueDate, 
               s.fundid,
               --Isnull(s.totalamount, 0) AS TotalAmount,
               ISNULL(s.paidcarriedinterest, 0) PaidCarriedInterest, 
               ISNULL(s.pendingcarriedinterest, 0) PendingCarriedInterest, 
               ISNULL(
        (
            SELECT SUM(ISNULL(TotalDistribution, 0))
            FROM tbl_DistributionOperation inn
            WHERE inn.distributionid = S.distributionid
                  AND inn.ShareID = ISNULL(@shareID, inn.ShareID)
        ), TotalAmount) AS TotalAmount, 
               ISNULL(
        (
            SELECT SUM(ISNULL(amount, 0))
            FROM tbl_DistributionLimitedPartner inn
            WHERE inn.distributionid = S.distributionid
                  AND inn.ShareID = ISNULL(@shareID, inn.ShareID)
        ), 0) AS EffectiveAmount, 
               STUFF(
        (
            SELECT '</br> ' + CAST(bbb.companyname AS VARCHAR(MAX)) [text()]
            FROM tbl_distributionportfoliocompany aaa
                 JOIN tbl_companycontact bbb ON aaa.companycontactid = bbb.companycontactid
            WHERE distributionid = S.distributionid FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(500)'), 1, 6, ' ') LinkedInvestees, 
               s.notes, 
               S.active, 
               S.createddatetime, 
               S.modifieddatetime, 
               S.createdby, 
               S.modifiedby, 
               STUFF(
        (
            SELECT '; ' + CAST(innvs.sharename AS VARCHAR(MAX)) [text()]
            FROM tbl_vehicleshare innvs
            WHERE innvs.vehicleid = S.fundid
                  AND innvs.VehicleShareID = ISNULL(@shareID, innvs.VehicleShareID) FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)'), 1, 2, ' ') SharesName, 
               STUFF(
        (
            SELECT '; ' + CAST(innvs.sharename AS VARCHAR(MAX)) + ',' + CAST(inncc.amount AS VARCHAR(MAX)) [text()]
            FROM tbl_limitedpartnerdetail inncc
                 JOIN tbl_limitedpartner innccal ON inncc.limitedpartnerid = innccal.limitedpartnerid
                 JOIN tbl_vehicleshare innvs ON innvs.vehicleshareid = inncc.shareid
            WHERE innccal.vehicleid = S.fundid
                  AND inncc.ShareID = ISNULL(@shareID, inncc.ShareID) FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)'), 1, 2, ' ') SharesBreakDown, 
               ISNULL(
        (
            SELECT SUM(aa.returnofcapital)
            FROM tbl_distributionoperation aa
            WHERE aa.distributionid = S.distributionid
                  AND aa.ShareID = ISNULL(@shareID, aa.ShareID)
        ), 0) AS ReturnOfCapital, 
               ISNULL(
        (
            SELECT SUM(aa.profit)
            FROM tbl_distributionoperation aa
            WHERE aa.distributionid = S.distributionid
                  AND aa.ShareID = ISNULL(@shareID, aa.ShareID)
        ), 0) AS Profit, 
               ISNULL(
        (
            SELECT COUNT(*)
            FROM tbl_distributionlimitedpartner inndist
            WHERE inndist.DistributionID = S.DistributionID
                  AND inndist.ShareID = ISNULL(@shareID, inndist.ShareID)
        ), 0) AS LPBreakDownCount, 
               IsApproved1, 
               Log1, 
               IsApproved2, 
               Log2, 
               TotalValidationReq, 
               UserRole1, 
               UserRole2, 
               NameFR, 
               NotesFR, 
               RecallableDistributionAmount
        FROM tbl_distribution S
        WHERE S.fundid = ISNULL(@TargetFundID, S.fundid)
        ORDER BY duedate DESC;
    END;
