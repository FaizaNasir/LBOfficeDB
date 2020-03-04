CREATE PROCEDURE [dbo].[proc_CapitalCall_GET] @TargetFundID INT = NULL, 
                                              @shareID      INT = NULL
AS
    BEGIN
        SELECT s.callname, 
        (
            SELECT Number
            FROM tbl_vehicleClosing vc
            WHERE vc.Vehicleclosingid = s.closingid
        ) ClosingID, 
               s.capitalcallid, 
               format(s.duedate, 'yyyy-MM-dd') + ' 00:00:00' DueDate, 
               s.fundid, 
        (
            SELECT CAST(SUM(ISNULL(InvestmentAmount, 0.00) + ISNULL(ManagementFees, 0.00) + ISNULL(OtherFees, 0.00)) AS DECIMAL(18, 2))
            FROM tbl_CapitalCallOperation inn
            WHERE inn.capitalcallid = S.capitalcallid
                  AND inn.ShareID = ISNULL(@shareid, inn.shareid)
        ) TotalAmount, 
        (
            SELECT CAST(SUM(ISNULL(amount, 0.00)) AS DECIMAL(18, 2))
            FROM tbl_capitalcalllimitedpartner inn
            WHERE inn.capitalcallid = S.CapitalCallID
                  AND inn.ShareID = ISNULL(@shareid, inn.shareid)
                  AND inn.ShareID <> 0
        ) AS EffectiveAmount, 
               STUFF(
        (
            SELECT '</br> ' + CAST(bbb.companyname AS VARCHAR(MAX)) [text()]
            FROM tbl_capitalcallportfoliocompany aaa
                 JOIN tbl_companycontact bbb ON aaa.companycontactid = bbb.companycontactid
            WHERE capitalcallid = S.capitalcallid FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)'), 1, 6, ' ') LinkedInvestees, 
               s.isbreakdown, 
               s.notes, 
               S.active, 
               S.createddatetime, 
               S.modifieddatetime, 
               S.createdby, 
               S.modifiedby, 
               format(s.calldate, 'dd/MM/yyyy') + ' 00:00:00' CallDate, 
               STUFF(
        (
            SELECT '; ' + CAST(innvs.ShareName AS VARCHAR(MAX)) [text()]
            FROM tbl_vehicleshare innvs
            WHERE innvs.VehicleID = @TargetFundID
                  AND innvs.VehicleShareID = ISNULL(@shareID, innvs.VehicleShareID) FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)'), 1, 2, ' ') SharesName, 
               STUFF(
        (
            SELECT '; ' + CAST(innvs.ShareName AS VARCHAR(MAX)) + ',' + CAST((ISNULL(inncc.InvestmentAmount, 0) + ISNULL(inncc.ManagementFees, 0) + ISNULL(inncc.OtherFees, 0)) AS VARCHAR(MAX)) [text()]
            FROM tbl_CapitalCallOperation inncc
                 JOIN tbl_vehicleshare innvs ON innvs.VehicleShareID = inncc.ShareID
            WHERE inncc.CapitalCallID = S.CapitalCallID
                  AND inncc.ShareID = ISNULL(@shareID, inncc.ShareID) FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)'), 1, 2, ' ') AmountInEachShare, 
               STUFF(
        (
            SELECT '; ' + CAST(innvs.ShareName AS VARCHAR(MAX)) + ',' + CAST(CAST(SUM(ISNULL(inncc.Amount, 0)) AS DECIMAL(18, 2)) AS VARCHAR(MAX)) [text()]
            FROM tbl_CapitalCallLimitedPartner inncc
                 JOIN tbl_vehicleshare innvs ON innvs.VehicleShareID = inncc.ShareID
            WHERE inncc.CapitalCallID = S.CapitalCallID
                  AND inncc.ShareID = ISNULL(@shareID, inncc.ShareID)
            GROUP BY inncc.ShareID, 
                     innvs.ShareName FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)'), 1, 2, ' ') EffectiveAmountInEachShare, 
               IsApproved1, 
               Log1, 
               IsApproved2, 
               Log2, 
               TotalValidationReq, 
               UserRole1, 
               UserRole2, 
               CallNameFR, 
               NotesFR
        FROM tbl_capitalcall S
        WHERE S.fundid = ISNULL(@TargetFundID, S.fundid)
        ORDER BY S.duedate DESC;
    END;
