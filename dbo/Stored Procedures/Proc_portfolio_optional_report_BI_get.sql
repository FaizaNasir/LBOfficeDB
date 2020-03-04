CREATE PROCEDURE [dbo].[Proc_portfolio_optional_report_BI_get](@VehicleID AS VARCHAR(MAX) = NULL)
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT po.portfolioid, 
        (
            SELECT TOP 1 projecttypetitle
            FROM tbl_dealtype
            WHERE projecttypeid = dealtypeid
        ) [Deal type], 
        (
            SELECT TOP 1 dealinvestmentbackgroundname
            FROM tbl_dealinvestmentbackground
            WHERE dealinvestmentbackgroundid = investmentbackgroundid
        ) AS [Transaction reason], 
               investmentbackgroundnotes AS [Investment thesis], 
               investmentriskassessment AS [Detailed profile], 
               dealthesis AS [Deal overview], 
               exitexpectations AS [Exit strategy], 
               (CASE
                    WHEN iscommunicated = 1
                    THEN 'Yes'
                    ELSE 'NO'
                END) AS [KYC done], 
               enviornmentalrisks AS [ESG criteria], 
               soicalrisks AS [Intermediate vehicle], 
               governancerisks AS [Amount invested], 
               measuretaken AS [Main investors]
        FROM tbl_portfoliovehicle pv
             JOIN tbl_portfolio p ON pv.portfolioid = p.portfolioid
             JOIN [tbl_companycontact] CC ON CC.companycontactid = P.TargetPortfolioID
             LEFT JOIN tbl_portfoliooptional po ON po.portfolioid = P.portfolioid;

        --Where VehicleID in(@VehicleID) 
        SET NOCOUNT OFF;
    END;
