CREATE TABLE [dbo].[tbl_PortfolioOptional] (
    [PortfolioOptionalID]         INT            IDENTITY (1, 1) NOT NULL,
    [PortfolioID]                 INT            NULL,
    [DealTypeID]                  INT            NULL,
    [InvestmentBackgroundID]      INT            NULL,
    [InvestmentBackgroundNotes]   VARCHAR (MAX)  NULL,
    [DealThesis]                  VARCHAR (MAX)  NULL,
    [ExitExpectations]            VARCHAR (MAX)  NULL,
    [IsCommunicated]              BIT            NULL,
    [EnviornmentalRisks]          VARCHAR (MAX)  NULL,
    [SoicalRisks]                 VARCHAR (MAX)  NULL,
    [GovernanceRisks]             VARCHAR (MAX)  NULL,
    [MeasureTaken]                VARCHAR (MAX)  NULL,
    [InvestmentRiskAssessment]    VARCHAR (MAX)  NULL,
    [Active]                      BIT            CONSTRAINT [DF_tbl_PortfolioOptional_Active] DEFAULT ((1)) NULL,
    [CreatedDateTime]             DATETIME       NULL,
    [ModifiedDateTime]            DATETIME       NULL,
    [CreatedBy]                   VARCHAR (100)  NULL,
    [ModifiedBy]                  VARCHAR (100)  NULL,
    [InstrumentType]              VARCHAR (MAX)  NULL,
    [Region]                      VARCHAR (1000) NULL,
    [RegionFr]                    VARCHAR (1000) NULL,
    [InvestmentRiskAssessmentFr]  VARCHAR (MAX)  NULL,
    [DealThesisFr]                VARCHAR (MAX)  NULL,
    [InstrumentTypeFr]            VARCHAR (MAX)  NULL,
    [InvestmentBackgroundNotesFr] VARCHAR (MAX)  NULL,
    [ExitExpectationsFr]          VARCHAR (MAX)  NULL,
    [EnviornmentalRisksFr]        VARCHAR (MAX)  NULL,
    [GovernanceRisksFr]           VARCHAR (MAX)  NULL,
    [Image2]                      NVARCHAR (MAX) NULL,
    [Image3]                      NVARCHAR (MAX) NULL,
    [FileName]                    VARCHAR (1000) NULL,
    [FileNumber]                  INT            NULL,
    [ClosingDate]                 DATETIME       NULL,
    [Holding]                     NVARCHAR (MAX) NULL,
    [Susidiary]                   NVARCHAR (MAX) NULL,
    [ManagementIncentiveScheme]   NVARCHAR (MAX) NULL,
    [TypeDistributionID]          INT            NULL,
    [ValueGrowthID]               INT            NULL,
    [TypeControlID]               INT            NULL,
    [TypeTechnologyID]            INT            NULL,
    [AnalysisOnID]                INT            NULL,
    [Communicated]                BIT            NULL,
    [ControllingStake]            BIT            NULL,
    [StatusID]                    VARCHAR (100)  NULL,
    [Holding1]                    INT            NULL,
    [Holding2]                    INT            NULL,
    [Holding3]                    INT            NULL,
    CONSTRAINT [PK_tbl_PortfolioOptional] PRIMARY KEY CLUSTERED ([PortfolioOptionalID] ASC),
    CONSTRAINT [OptionalPortfolioID] FOREIGN KEY ([PortfolioID]) REFERENCES [dbo].[tbl_Portfolio] ([PortfolioID])
);


GO
ALTER TABLE [dbo].[tbl_PortfolioOptional] NOCHECK CONSTRAINT [OptionalPortfolioID];


GO
CREATE NONCLUSTERED INDEX [IX_tbl_PortfolioOptional]
    ON [dbo].[tbl_PortfolioOptional]([PortfolioID] ASC);

