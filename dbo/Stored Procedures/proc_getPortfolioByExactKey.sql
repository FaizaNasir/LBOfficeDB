CREATE PROC [dbo].[proc_getPortfolioByExactKey] @key VARCHAR(200)
AS
    BEGIN
        SELECT p.portfolioID, 
        (
            SELECT TOP 1 CASE
                             WHEN DealPriority = 1
                             THEN 'Co-invest w/ fees and/or carry'
                             WHEN DealPriority = 2
                             THEN 'Minority transaction, no control shareholder'
                             WHEN DealPriority = 3
                             THEN 'Lead / Co Lead'
                             WHEN DealPriority = 4
                             THEN 'Public investment'
                             WHEN DealPriority = 5
                             THEN 'Co-invest no fees, no carry'
                             WHEN DealPriority = 6
                             THEN 'No alignment of interest / structured product'
                         END
            FROM tbl_deals d
                 JOIN tbl_DealOptionalDetails do ON do.dealid = d.DealID
            WHERE d.DealCurrentTargetID = p.TargetPortfolioID
        ) Category, 
               CompanyName
        FROM tbl_portfolio p
             JOIN tbl_companycontact c ON p.TargetPortfolioID = c.CompanyContactID
        WHERE CompanyName = @key;
    END;
