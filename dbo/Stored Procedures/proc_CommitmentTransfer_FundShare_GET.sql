CREATE PROCEDURE [dbo].[proc_CommitmentTransfer_FundShare_GET] @CommitmentTransferID INT = NULL
AS
    BEGIN
        SELECT CommitmentTransferShareID, 
               [CommitmentTransferID], 
               fs.VehicleShareID, 
               [ShareAmount] Amount, 
               AmountPer, 
               fs.ShareName, 
               fs.ShareNameFr, 
               ToShareID
        FROM [tbl_CommitmentTransferFundShare] cfs
             INNER JOIN tbl_vehicleshare fs ON fs.VehicleShareID = cfs.fundshareid
        WHERE cfs.CommitmentTransferID = ISNULL(@CommitmentTransferID, cfs.CommitmentTransferID);
    END;
