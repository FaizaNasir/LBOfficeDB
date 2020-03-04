-- =============================================    
-- Author:  <Author,,Name>    
-- Create date: <Create Date,,>    
-- Description: <Description,,>    
-- =============================================    
CREATE PROCEDURE [dbo].[proc_FundOperations_GET]-- 48,62,null    
@FundGeneralOperationID INT = NULL, 
@FundID                 INT, 
@FundOperationTypeID    INT = NULL
AS
    BEGIN
        SELECT FGO.FundOperationID, 
               FGO.FundOperationName, 
               FGO.FundID, 
               Ft.FundOperationTypeTitle, 
               FGO.FundOperationTypeID,
               CASE
                   WHEN fundoperationfromtype = 2
                   THEN
        (
            SELECT fundname
            FROM tbl_funds f
            WHERE f.fundid = fundoperationfromid
        )
                   ELSE
        (
            SELECT companyname
            FROM tbl_companycontact c
            WHERE c.companycontactid = fundoperationfromid
        )
               END FundOperationFrom,
               CASE
                   WHEN fundoperationTotype = 2
                   THEN
        (
            SELECT fundname
            FROM tbl_funds f
            WHERE f.fundid = fundoperationToid
        )
                   ELSE
        (
            SELECT companyname
            FROM tbl_companycontact c
            WHERE c.companycontactid = fundoperationToid
        )
               END FundOperationTo, 
               FGO.FundOperationFromType, 
               FGO.FundOperationFromID, 
               FGO.FundOperationToType, 
               FGO.FundOperationToID, 
               FGO.FundOperationAmount, 
               FGO.CurrencyID, 
               FGO.FundOperationDateTime, 
               ISNULL(FGO.FundOperationComments, '') FundOperationComments
        FROM [LBOffice].[dbo].[tbl_FundGeneralOperations] AS FGO
             LEFT JOIN [LBOffice].[dbo].[tbl_FundOperationTypes] AS FT ON [FGO].FundOperationTypeID = FT.[FundOperationTypeID]
        WHERE FundOperationID = ISNULL(@FundGeneralOperationID, FGO.FundOperationID)
              AND FGO.FundID = ISNULL(@FundID, FGO.FundID)    
        --AND FGO.FundOperationTypeID=ISNULL(@FundOperationTypeID,FGO.FundOperationTypeID)    

        ORDER BY FGO.FundOperationDateTime;
    END;
