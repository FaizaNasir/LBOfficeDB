
-- exec [dbo].[proc_LimitedPartnerGrid_GET] @fundID=28,@date='2016-05-03'

CREATE PROCEDURE [dbo].[proc_LimitedPartnerGrid_GET] @fundID INT, 
                                                    @date   DATETIME
AS
    BEGIN
        DECLARE @sumofshares DECIMAL(18, 2);

        --declare @date datetime
        --declare @fundID int 
        --set @fundID = 28;
        --set @date = GETDATE();

        DECLARE @tbl TABLE
        (Number1          DECIMAL(18, 2), 
         ObjectID         INT, 
         ModuleID         INT, 
         LimitedPartnerID INT
        );
        DECLARE @transfer TABLE
        (ShareAmount  DECIMAL(18, 2), 
         ShareID      INT, 
         FromObjectID INT, 
         FromModuleID INT, 
         ToObjectID   INT, 
         ToModuleID   INT, 
         isparent     INT
        );
        DECLARE @minusAmountByLP TABLE
        (FromObjectID INT, 
         FromModuleID INT, 
         Amount       DECIMAL(18, 2), 
         ShareID      INT
        );
        DECLARE @FinalTransferCommitment TABLE
        (Date        DATETIME, 
         ModuleID    INT, 
         ObjectID    INT, 
         ShareName   VARCHAR(100), 
         Amount      DECIMAL(18, 2), 
         FundShareID INT
        );
        INSERT INTO @tbl
               SELECT dbo.[F_LPOwenPercentage](lp.ObjectID, lp.ModuleID, @date, @fundID, 1) AS Number1, 
                      lp.ObjectID, 
                      lp.ModuleID, 
                      lp.LimitedPartnerID
               FROM tbl_LimitedPartner lp
               WHERE lp.VehicleID = @fundID;
        INSERT INTO @transfer
               SELECT ctfs.ShareAmount, 
                      ctfs.FundShareID, 
                      ct.FromObjectID, 
                      ct.FromModuleID, 
                      ct.ToObjectID, 
                      ct.ToModuleID, 
                      ct.ParentID
               FROM tbl_CommitmentTransfer ct
                    INNER JOIN tbl_CommitmentTransferFundShare ctfs ON ct.CommitmentTransferID = ctfs.CommitmentTransferID
               WHERE ct.FundID = @fundID
                     AND ct.Date <= @date;
        IF(
        (
            SELECT TOP 1 CommitmentTransferID
            FROM tbl_CommitmentTransfer
            WHERE FundID = @fundID
        ) = NULL)
            BEGIN
                SELECT

                --t.LimitedPartnerID,

                t.ModuleID, 
                t.ObjectID,
                CASE
                    WHEN t.ModuleID = 4
                    THEN
                (
                    SELECT TOP 1 CI.IndividualFullName
                    FROM [tbl_ContactIndividual] CI
                    WHERE CI.IndividualID = t.ObjectID
                )
                    WHEN t.ModuleID = 5
                    THEN
                (
                    SELECT TOP 1 CC.CompanyName
                    FROM [tbl_CompanyContact] CC
                    WHERE CC.CompanyContactID = t.ObjectID
                )
                END AS 'LPName', 
                (t.Number1 * 100) AS 'Owned'
                FROM @tbl t;
        END;
            ELSE
            BEGIN
                INSERT INTO @minusAmountByLP
                       SELECT DISTINCT 
                              tc.FromObjectID, 
                              tc.FromModuleID, 
                              SUM(tc.ShareAmount), 
                              tc.ShareID
                       FROM @transfer tc
                       WHERE tc.isparent IS NULL
                       GROUP BY tc.FromObjectID, 
                                tc.FromModuleID, 
                                tc.ShareID;

                --this have to be insert in final temp table

                INSERT INTO @FinalTransferCommitment
                       SELECT c.Date, 
                              c.ModuleID, 
                              c.ObjectID, 
                              fs.ShareName, 
                              (cfs.ShareAmount) - mlp.Amount AS 'Amount', 
                              cfs.FundShareID
                       FROM tbl_Commitment c
                            INNER JOIN tbl_CommitmentFundShare cfs ON cfs.CommitmentID = c.CommitmentID
                            INNER JOIN tbl_FundShare fs ON cfs.FundShareID = fs.FundShareID
                                                           AND c.FundID = fs.FundID
                            INNER JOIN @minusAmountByLP mlp ON mlp.FromModuleID = c.ModuleID
                                                               AND mlp.FromObjectID = c.ObjectID
                                                               AND cfs.FundShareID = mlp.ShareID
                       WHERE c.FundID = @fundID
                             AND c.Date <= @date;
                DECLARE @count INT;
                SET @count = 1;
                DECLARE @lpcount INT;
                SET @lpcount =
                (
                    SELECT COUNT(CommitmentTransferID)
                    FROM tbl_CommitmentTransfer
                    WHERE parentid IS NULL
                );
                DECLARE @tmp TABLE
                (id         INT, 
                 transferid INT
                );
                INSERT INTO @tmp
                       SELECT ROW_NUMBER() OVER(
                              ORDER BY FundID DESC), 
                              CommitmentTransferID
                       FROM tbl_CommitmentTransfer
                       WHERE parentid IS NULL;
                DECLARE @tmp1 TABLE
                (transferid INT, 
                 objectid   INT, 
                 moduleid   INT
                );
                WHILE(@count) <= @lpcount
                    BEGIN

                        --insert those who have parentid equals to primary key id

                        INSERT INTO @tmp1
                               SELECT CommitmentTransferID, 
                                      ct.ToObjectID, 
                                      ct.ToModuleID
                               FROM tbl_CommitmentTransfer ct
                                    INNER JOIN @tmp tmp ON ct.CommitmentTransferID = tmp.transferid
                               WHERE tmp.id = @count
                                     AND ct.Date <= @date;

                        --insert those who have primary key id equals to parentid   

                        INSERT INTO @tmp1
                               SELECT CommitmentTransferID, 
                                      ct.ToObjectID, 
                                      ct.ToModuleID
                               FROM tbl_CommitmentTransfer ct
                                    INNER JOIN @tmp tmp ON ct.parentID = tmp.transferid
                               WHERE tmp.id = @count
                                     AND ct.Date <= @date;
                        SET @count = @count + 1;
        END;

                --select * from @tmp1

                DECLARE @Sharetmp TABLE(shareid INT);
                INSERT INTO @Sharetmp
                       SELECT FundShareID
                       FROM tbl_FundShare;
                DECLARE @ShareCaltmp TABLE
                (ObjectID    INT, 
                 ModuleID    INT, 
                 ShareID     INT, 
                 ShareAmount DECIMAL(18, 2)
                );
                INSERT INTO @ShareCaltmp
                       SELECT c.ObjectID, 
                              c.ModuleID, 
                              cts.FundShareID, 
                              cts.ShareAmount
                       FROM tbl_Commitment c
                            INNER JOIN @tmp1 tmp1 ON tmp1.objectid = c.ObjectID
                                                     AND tmp1.moduleid = c.ModuleID
                            INNER JOIN tbl_CommitmentFundShare cts ON cts.CommitmentID = c.CommitmentID
                            INNER JOIN @Sharetmp st ON st.shareid = cts.FundShareID;
                DECLARE @SumSharetmp TABLE
                (shareid INT, 
                 Amount  DECIMAL(18, 2)
                );
                INSERT INTO @SumSharetmp
                       SELECT sct.ShareID, 
                              SUM(sct.shareamount)
                       FROM @ShareCaltmp sct
                            INNER JOIN @Sharetmp st ON st.shareid = sct.ShareID
                       GROUP BY sct.ShareID;
                DECLARE @tmp2 TABLE
                (ModuleID  INT, 
                 ObjectID  INT, 
                 ShareID   INT, 
                 CalAmount DECIMAL(18, 2)
                );
                INSERT INTO @tmp2
                       SELECT sct.ModuleID, 
                              sct.ObjectID, 
                              sct.ShareID, 
                              (sct.ShareAmount) / sst.Amount
                       FROM @ShareCaltmp sct
                            INNER JOIN @SumSharetmp sst ON sst.shareid = sct.ShareID;

                --select * from @tmp3

                DECLARE @tmp3 TABLE
                (ModuleID       INT, 
                 ObjectID       INT, 
                 ShareID        INT, 
                 TransferAmount DECIMAL(18, 2)
                );
                INSERT INTO @tmp3
                       SELECT DISTINCT 
                              ct.ToModuleID, 
                              ct.ToObjectID, 
                              ctfs.FundShareID, 
                              (ctfs.ShareAmount * tmp2.CalAmount) 'TransferAmount'
                       FROM tbl_CommitmentTransfer ct
                            INNER JOIN tbl_CommitmentTransferFundShare ctfs ON ct.CommitmentTransferID = ctfs.CommitmentTransferID
                            INNER JOIN @ShareCaltmp sct ON sct.ModuleID = ct.ToModuleID
                                                           AND sct.ObjectID = ct.ToObjectID
                            INNER JOIN @tmp2 tmp2 ON tmp2.ModuleID = ct.ToModuleID
                                                     AND tmp2.ObjectID = ct.ToObjectID
                                                     AND tmp2.ShareID = ctfs.FundShareID
                       WHERE ct.FundID = @fundID;

                --select * from @tmp3

                INSERT INTO @FinalTransferCommitment
                       SELECT c.Date, 
                              c.ModuleID, 
                              c.ObjectID, 
                              fs.ShareName, 
                              (cfs.ShareAmount) + tmp3.TransferAmount AS 'Amount', 
                              cfs.FundShareID
                       FROM tbl_Commitment c
                            INNER JOIN tbl_CommitmentFundShare cfs ON cfs.CommitmentID = c.CommitmentID
                            INNER JOIN tbl_FundShare fs ON cfs.FundShareID = fs.FundShareID
                                                           AND c.FundID = fs.FundID
                            INNER JOIN @tmp3 tmp3 ON tmp3.ModuleID = c.ModuleID
                                                     AND tmp3.ObjectID = c.ObjectID
                                                     AND tmp3.ShareID = cfs.FundShareID
                       WHERE c.FundID = @fundID;
                INSERT INTO @FinalTransferCommitment
                       SELECT c.Date, 
                              c.ModuleID, 
                              c.ObjectID, 
                              fs.ShareName, 
                              cfs.ShareAmount, 
                              cfs.FundShareID
                       FROM tbl_Commitment c
                            INNER JOIN tbl_CommitmentFundShare cfs ON cfs.CommitmentID = c.CommitmentID
                            INNER JOIN tbl_FundShare fs ON cfs.FundShareID = fs.FundShareID
                                                           AND c.FundID = fs.FundID
                            LEFT OUTER JOIN @FinalTransferCommitment ftc ON ftc.ModuleID = c.ModuleID
                                                                            AND ftc.ObjectID = c.ObjectID
                                                                            AND ftc.FundShareID = cfs.FundShareID
                       WHERE c.FundID = @fundID
                             AND ftc.FundShareID IS NULL;
                DECLARE @tmp4 TABLE
                (amount  DECIMAL(18, 2), 
                 shareid INT
                );
                INSERT INTO @tmp4
                       SELECT SUM(Amount), 
                              FundShareID
                       FROM @FinalTransferCommitment
                       GROUP BY FundShareID;
                DECLARE @sum DECIMAL(18, 2);
                SET @sum =
                (
                    SELECT SUM(amount)
                    FROM @tmp4
                );
                DECLARE @temp5 TABLE
                (ModuleID INT, 
                 ObjectID INT, 
                 Amount   DECIMAL(18, 2)
                );
                INSERT INTO @temp5
                       SELECT ftc.ModuleID, 
                              ftc.ObjectID, 
                              ((ftc.Amount) /
                       (
                           SELECT @sum
                       )) * 100
                       FROM @FinalTransferCommitment ftc
                            INNER JOIN @tmp4 tmp4 ON tmp4.shareid = ftc.FundShareID;
                SELECT ModuleID, 
                       ObjectID,
                       CASE
                           WHEN ModuleID = 4
                           THEN
                (
                    SELECT TOP 1 CI.IndividualFullName
                    FROM [tbl_ContactIndividual] CI
                    WHERE CI.IndividualID = ObjectID
                )
                           WHEN ModuleID = 5
                           THEN
                (
                    SELECT TOP 1 CC.CompanyName
                    FROM [tbl_CompanyContact] CC
                    WHERE CC.CompanyContactID = ObjectID
                )
                       END AS 'LPName', 
                       SUM(amount) AS 'Owned'
                FROM @temp5
                GROUP BY ModuleID, 
                         ObjectID;
        END;
    END;
