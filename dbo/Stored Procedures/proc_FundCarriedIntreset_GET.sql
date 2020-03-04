CREATE PROCEDURE [dbo].[proc_FundCarriedIntreset_GET] @CarriedIntresetID INT = NULL, 
                                                      @FundID            INT = NULL
AS
    BEGIN
        SELECT CarriedIntresetID, 
               fci.FundID, 
               IsIRR, 
               BetweenStartPercent, 
               BetweenEndPercent, 
               CarriedIntresetPercent, 
               IsAndOr, 
               IsFundBasedCarriedIntreset, 
               CarriedInterestFeesComments, 
               fci.CreatedDate, 
               fci.CreatedBy, 
               fci.ModifiedDate, 
               fci.ModifiedBy
        FROM tbl_FundCarriedIntreset fci
             JOIN tbl_FundGeneralFees fgf ON fgf.fundid = fci.fundid
        WHERE fci.FundID = @FundID
              AND CarriedIntresetID = ISNULL(@CarriedIntresetID, CarriedIntresetID);
    END;
