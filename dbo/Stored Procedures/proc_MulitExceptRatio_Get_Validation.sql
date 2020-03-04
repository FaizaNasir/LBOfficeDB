-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[proc_MulitExceptRatio_Get_Validation] @SourceObjectID VARCHAR(MAX), 
                                                              @SourceType     VARCHAR(MAX)
AS
    BEGIN
        IF(@SourceType = 'FundInvestmentTypes')
            BEGIN
                SELECT ISNULL(SUM(ISNULL(FundInvestmentAllocationRatio, 0)), 0) AS RemainAllotion
                FROM tbl_FundInvestmentTypes
                WHERE FundID = @SourceObjectID
                      AND Active = 1;
        END;
            ELSE
            IF(@SourceType = 'FundDealsAllocations')
                BEGIN
                    SELECT ISNULL(SUM(ISNULL(FundInvestmentAllocationRatio, 0)), 0) AS RemainAllotion
                    FROM tbl_FundDealsAllocations
                    WHERE FundID = @SourceObjectID
                          AND Active = 1;
            END----adding tbl_FundSecurityTypes;
                ELSE
                IF(@SourceType = 'FundSecurityTypes')
                    BEGIN
                        SELECT ISNULL(SUM(ISNULL(FundAllocationRatio, 0)), 0) AS RemainAllotion
                        FROM tbl_FundSecurityTypes
                        WHERE FundID = @SourceObjectID
                              AND Active = 1;
                END;
                    ELSE
                    IF(@SourceType = 'FundBusinessAreaAllocation')
                        BEGIN
                            SELECT ISNULL(SUM(ISNULL(AllocationRatio, 0)), 0) AS RemainAllotion
                            FROM tbl_FundBusinessAreaAllocation
                            WHERE FundID = @SourceObjectID
                                  AND Active = 1;
                    END;
                        ELSE
                        IF(@SourceType = 'FundGeographicalRegionAllocation')
                            BEGIN
                                SELECT ISNULL(SUM(ISNULL(AllocationRatio, 0)), 0) AS RemainAllotion
                                FROM tbl_FundGeographicalRegionAllocation
                                WHERE FundID = @SourceObjectID
                                      AND Active = 1;
                        END;
                            ELSE
                            IF(@SourceType = 'FundGeographicalCountryAllocation')
                                BEGIN
                                    SELECT ISNULL(SUM(ISNULL(AllocationRatio, 0)), 0) AS RemainAllotion
                                    FROM tbl_FundGeographicalCountryAllocation
                                    WHERE FundID = @SourceObjectID;
                            END;
    END;
