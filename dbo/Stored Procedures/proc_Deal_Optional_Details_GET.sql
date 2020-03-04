CREATE PROCEDURE [dbo].[proc_Deal_Optional_Details_GET] @DealID INT = NULL
AS
    BEGIN
        SELECT DealOptionalDetailsID, 
               dod.DealID, 
               DealPriority, 
               SignedOn, 
               InvestmentBackgroundID, 
               OwnershipID, 
               ShareholdingTypeID, 
               SourceTypeID, 
               InvestmentReason, 
               IntroducedWithID, 
               ExpectedExit, 
               IsCommunicated, 
               DealIntroductionWithName, 
               DealInvestmentBackgroundName, 
               DealOwnershipName, 
               DealShareholdingTypeName, 
               DealSourceTypeName, 
               TenorOfEngagement, 
               CloseDate, 
               NDATypeID, 
               DernierCA, 
               EBIT, 
               EBITDA, 
               ResultatNet, 
               Commentaires, 
               TypeDeDealID, 
        (
            SELECT TOP 1 dsd.DealStatusDateTime
            FROM tbl_DealStatusDetails dsd
            WHERE dsd.dealid = dod.dealid
                  AND DealStatusID = 1
            ORDER BY 1 DESC
        ) AcceptedDate
        FROM tbl_DealOptionalDetails dod --left join tbl_dealvehicle df      
             --on df.DealID = dod.DealID      
             LEFT JOIN tbl_DealIntroductionWith iw ON iw.DealIntroductionWithID = dod.IntroducedWithID
             LEFT JOIN tbl_DealInvestmentBackground ib ON ib.DealInvestmentBackgroundID = dod.InvestmentBackgroundID
             LEFT JOIN tbl_DealOwnership do ON do.DealOwnershipID = dod.OwnershipID
             LEFT JOIN tbl_DealShareholdingType sh ON sh.DealShareholdingTypeID = dod.ShareholdingTypeID
             LEFT JOIN tbl_DealSourceType ds ON ds.DealSourceTypeID = dod.SourceTypeID
        WHERE dod.DealID = ISNULL(@DealID, dod.DealID);
    END;
