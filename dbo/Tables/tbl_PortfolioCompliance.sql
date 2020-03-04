CREATE TABLE [dbo].[tbl_PortfolioCompliance] (
    [PortfolioComplianceID]  INT             IDENTITY (1, 1) NOT NULL,
    [PortfolioID]            INT             NULL,
    [PartnerAgreement]       VARCHAR (5000)  NULL,
    [ExitClause]             VARCHAR (5000)  NULL,
    [EdRBoardRepresentation] VARCHAR (5000)  NULL,
    [LiquidityClause]        VARCHAR (5000)  NULL,
    [SetupCosts]             DECIMAL (18, 6) NULL,
    [Other]                  VARCHAR (5000)  NULL,
    CONSTRAINT [PK_tbl_PortfolioCompliance] PRIMARY KEY CLUSTERED ([PortfolioComplianceID] ASC)
);

