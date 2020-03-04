CREATE PROCEDURE [dbo].[proc_Portfolio_All_Report_GET](@VehicleID VARCHAR(MAX) = NULL)
AS
    BEGIN
        SET NOCOUNT ON;

        --drop table #tmpportfoliocompany

        CREATE TABLE #tmpportfoliocompany
        (portfolioid      INT, 
         companycontactid INT, 
         companyname      VARCHAR(MAX) NULL
        );
        INSERT INTO #tmpportfoliocompany
        EXEC proc_portfolio_list_report_get 
             @VehicleID;
        CREATE TABLE #general
        ([PortfolioID]                        INT, 
         [Portfolio company name]             VARCHAR(MAX) NULL, 
         [Portfolio company currency]         VARCHAR(MAX) NULL, 
         [Portfolio company legal]            DECIMAL(18, 2) NULL, 
         [Portfolio company logo]             VARCHAR(MAX) NULL, 
         [Portfolio company sector]           VARCHAR(MAX) NULL, 
         [Portfolio company industry]         VARCHAR(MAX) NULL, 
         [Portfolio company business profile] VARCHAR(MAX) NULL, 
         [Portfolio company address]          VARCHAR(MAX) NULL, 
         [Portfolio company city]             VARCHAR(MAX) NULL, 
         [Portfolio company zip code]         VARCHAR(MAX) NULL, 
         [Portfolio company country]          VARCHAR(MAX) NULL, 
         [Portfolio company phone number]     VARCHAR(MAX) NULL, 
         [Portfolio company fax number]       VARCHAR(MAX) NULL, 
         [Portfolio company website]          VARCHAR(MAX) NULL, 
         [Portfolio company notes]            VARCHAR(MAX) NULL
        );
        INSERT INTO #general
        EXEC proc_portfolio_general_Report_BI_GET 
             @VehicleID;
        CREATE TABLE #optional
        ([PortfolioID]          INT, 
         [Deal type]            VARCHAR(MAX) NULL, 
         [Transaction reason]   VARCHAR(MAX) NULL, 
         [Investment thesis]    VARCHAR(MAX) NULL, 
         [Detailed profile]     VARCHAR(MAX) NULL, 
         [Deal overview]        VARCHAR(MAX) NULL, 
         [Exit strategy]        VARCHAR(MAX) NULL, 
         [KYC done]             VARCHAR(MAX) NULL, 
         [ESG criteria]         VARCHAR(MAX) NULL, 
         [Intermediate vehicle] VARCHAR(MAX) NULL, 
         [Amount invested]      VARCHAR(MAX) NULL, 
         [Main investors]       VARCHAR(MAX) NULL
        );
        INSERT INTO #optional
        EXEC dbo.proc_portfolio_optional_Report_BI_GET 
             @VehicleID;
        CREATE TABLE #legal
        ([PortfolioID]                     INT, 
         [Capital]                         DECIMAL(18, 2) NULL, 
         [Legal structure]                 VARCHAR(MAX) NULL, 
         [Legal representative company]    VARCHAR(MAX) NULL, 
         [Legal representative individual] VARCHAR(MAX) NULL, 
         [Trade register]                  VARCHAR(MAX) NULL, 
         [Sector code]                     VARCHAR(MAX) NULL, 
         [Quoted]                          VARCHAR(MAX) NULL, 
         [Legal notes]                     VARCHAR(MAX) NULL
        );
        INSERT INTO #legal
        EXEC dbo.proc_portfolio_legal_Report_BI_GET 
             @VehicleID;
        CREATE TABLE #keyfigure
        ([PortfolioID]             INT, 
         [EBIT 2013]               DECIMAL(18, 2) NULL, 
         [EBIT 2014]               DECIMAL(18, 2) NULL, 
         [EBIT 2015]               DECIMAL(18, 2) NULL, 
         [EBIT 2016]               DECIMAL(18, 2) NULL, 
         [EBITDA 2013]             DECIMAL(18, 2) NULL, 
         [EBITDA 2014]             DECIMAL(18, 2) NULL, 
         [EBITDA 2015]             DECIMAL(18, 2) NULL, 
         [EBITDA 2016]             DECIMAL(18, 2) NULL, 
         [Enterprise value 2013]   DECIMAL(18, 2) NULL, 
         [Enterprise value 2014]   DECIMAL(18, 2) NULL, 
         [Enterprise value 2015]   DECIMAL(18, 2) NULL, 
         [Enterprise value 2016]   DECIMAL(18, 2) NULL, 
         [Net financial debt 2013] DECIMAL(18, 2) NULL, 
         [Net financial debt 2014] DECIMAL(18, 2) NULL, 
         [Net financial debt 2015] DECIMAL(18, 2) NULL, 
         [Net financial debt 2016] DECIMAL(18, 2) NULL, 
         [Net profit 2013]         DECIMAL(18, 2) NULL, 
         [Net profit 2014]         DECIMAL(18, 2) NULL, 
         [Net profit 2015]         DECIMAL(18, 2) NULL, 
         [Net profit 2016]         DECIMAL(18, 2) NULL, 
         [Revenues 2013]           DECIMAL(18, 2) NULL, 
         [Revenues 2014]           DECIMAL(18, 2) NULL, 
         [Revenues 2015]           DECIMAL(18, 2) NULL, 
         [Revenues 2016]           DECIMAL(18, 2) NULL
        );
        INSERT INTO #keyfigure
        EXEC dbo.proc_Kefigure_Report_BI_GET 
             @VehicleID;
        CREATE TABLE #capital
        ([VehicleID]   INT, 
         [PortfolioID] INT, 
         [shName]      VARCHAR(MAX) NULL, 
         [non diluted] VARCHAR(MAX) NULL, 
         [diluted]     VARCHAR(MAX) NULL, 
         [voting]      VARCHAR(MAX) NULL
        );
        INSERT INTO #capital
        EXEC dbo.proc_capital_Report_BI_GET 
             @VehicleID;
        CREATE TABLE #investshare
        ([PortfolioID]                        INT, 
         [Amount invested in equity]          DECIMAL(18, 2) NULL, 
         [Amount invested in debt]            DECIMAL(18, 2) NULL, 
         [Amount invested in current account] DECIMAL(18, 2) NULL, 
         [Amount invested]                    DECIMAL(18, 2) NULL
        );
        INSERT INTO #investshare
        EXEC dbo.proc_investshare_Report_BI_GET 
             @VehicleID;
        CREATE TABLE #divestshare
        ([PortfolioID]                        INT, 
         [Amount divested in equity]          DECIMAL(18, 2) NULL, 
         [Amount divested in debt]            DECIMAL(18, 2) NULL, 
         [Amount divested in current account] DECIMAL(18, 2) NULL, 
         [Amount divested]                    DECIMAL(18, 2) NULL
        );
        INSERT INTO #divestshare
        EXEC dbo.proc_divestshare_Report_BI_GET 
             @VehicleID;
        CREATE TABLE #generaloperation
        ([PortfolioID]                      INT, 
         [Dividends]                        DECIMAL(18, 2) NULL, 
         [Acquisition fees]                 DECIMAL(18, 2) NULL, 
         [Carried interest paid to sponsor] DECIMAL(18, 2) NULL, 
         [FX Hedging Gain]                  DECIMAL(18, 2) NULL, 
         [FX Hedging Loss]                  DECIMAL(18, 2) NULL, 
         [Interest accrued]                 DECIMAL(18, 2) NULL, 
         [Interest received]                DECIMAL(18, 2) NULL, 
         [Management fees]                  DECIMAL(18, 2) NULL, 
         [Monitoring fees]                  DECIMAL(18, 2) NULL, 
         [SPV fees]                         DECIMAL(18, 2) NULL
        );
        INSERT INTO #generaloperation
        EXEC dbo.proc_generaloper_Report_BI_GET 
             @VehicleID;
        CREATE TABLE #valuation
        ([PortfolioID]             INT, 
         [Last valuation EUR]      DECIMAL(18, 2) NULL, 
         [Last valuation FX]       DECIMAL(18, 2) NULL, 
         [Last valuation date]     DATETIME NULL, 
         [Last valuation type]     VARCHAR(MAX) NULL, 
         [Last valuation method]   VARCHAR(MAX) NULL, 
         [Before valuation EUR]    DECIMAL(18, 2) NULL, 
         [Before valuation FX]     DECIMAL(18, 2) NULL, 
         [Before valuation date]   DATETIME NULL, 
         [Before valuation type]   VARCHAR(MAX) NULL, 
         [Before valuation method] VARCHAR(MAX) NULL
        );
        INSERT INTO #valuation
        EXEC dbo.proc_valuation_report_BI_GET 
             @VehicleID;
        CREATE TABLE #performance
        ([VehicleID]   INT, 
         [PortfolioID] INT, 
         [IRREUR]      VARCHAR(MAX) NULL, 
         [MulEUR]      VARCHAR(MAX) NULL, 
         [IRRFX]       VARCHAR(MAX) NULL, 
         [MulFX]       VARCHAR(MAX) NULL
        );
        INSERT INTO #performance
        EXEC dbo.proc_perform_report_BI_GET 
             @VehicleID;
        CREATE TABLE #business
        (PortfolioID                                   INT, 
         [Portfolio company market description]        VARCHAR(MAX) NULL, 
         [Portfolio company Last business update]      VARCHAR(MAX) NULL, 
         [Portfolio company last business update date] DATE
        );
        INSERT INTO #business
        EXEC dbo.proc_business_report_BI_GET 
             @VehicleID;
        CREATE TABLE #BOD
        (PortfolioID                                                 INT, 
         [Portfolio company number of our firm’s board of directors] VARCHAR(MAX) NULL
        );
        INSERT INTO #BOD
        EXEC dbo.proc_BOD_report_BI_GET 
             @VehicleID;
        SELECT DISTINCT 
               ge.*, 
               bus.*, 
               op.*, 
               le.*, 
               ke.*, --,ca.* 
               inv.*, 
               div.*, 
               gen.*, 
               val.*, 
               per.*, 
               bod.*
        FROM #tmpportfoliocompany PV
             JOIN [tbl_companycontact] CC ON cc.companycontactid = pv.companycontactid
             LEFT JOIN #general ge ON ge.PortfolioID = PV.portfolioid
             LEFT JOIN #optional op ON ge.PortfolioID = op.PortfolioID
             LEFT JOIN #legal le ON le.PortfolioID = op.PortfolioID
             LEFT JOIN #keyfigure ke ON ke.PortfolioID = le.PortfolioID
             LEFT JOIN --#capital ca ON ke.PortfolioID = ca.PortfolioID LEFT JOIN 
             #investshare inv ON ke.PortfolioID = inv.PortfolioID
             LEFT JOIN #divestshare div ON inv.PortfolioID = div.PortfolioID
             LEFT JOIN #generaloperation gen ON div.PortfolioID = gen.PortfolioID
             LEFT JOIN #valuation val ON gen.PortfolioID = val.PortfolioID
             LEFT JOIN #performance per ON val.PortfolioID = per.PortfolioID
             LEFT JOIN #business bus ON per.PortfolioID = bus.PortfolioID
             LEFT JOIN #BOD bod ON bus.PortfolioID = bod.PortfolioID;
        IF OBJECT_ID('#tempdb..#general') IS NULL
            DROP TABLE #general;
        IF OBJECT_ID('#tempdb..#optional') IS NULL
            DROP TABLE #optional;
        IF OBJECT_ID('#tempdb..#legal') IS NULL
            DROP TABLE #legal;
        IF OBJECT_ID('#tempdb..#keyfigure') IS NULL
            DROP TABLE #keyfigure;
        IF OBJECT_ID('#tempdb..#capital') IS NULL
            DROP TABLE #capital;
        IF OBJECT_ID('#tempdb..#investshare') IS NULL
            DROP TABLE #investshare;
        IF OBJECT_ID('#tempdb..#divestshare') IS NULL
            DROP TABLE #divestshare;
        IF OBJECT_ID('#tempdb..#generaloperation') IS NULL
            DROP TABLE #generaloperation;
        IF OBJECT_ID('#tempdb..#valuation') IS NULL
            DROP TABLE #valuation;
        IF OBJECT_ID('#tempdb..#performance') IS NULL
            DROP TABLE #performance;
        IF OBJECT_ID('#tempdb..#business') IS NULL
            DROP TABLE #business;
        IF OBJECT_ID('#tempdb..#BOD') IS NULL
            DROP TABLE #BOD;
        IF OBJECT_ID('#tempdb..#tmpportfoliocompany') IS NULL
            DROP TABLE #tmpportfoliocompany;
        SET NOCOUNT OFF;
    END;
