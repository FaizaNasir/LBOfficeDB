CREATE TABLE [dbo].[tbl_PortfolioSecurity] (
    [PortfolioSecurityID]     INT             IDENTITY (1, 1) NOT NULL,
    [PortfolioID]             INT             NULL,
    [Name]                    VARCHAR (100)   NULL,
    [PortfolioSecurityTypeID] INT             NULL,
    [NominalValue]            DECIMAL (18, 2) NULL,
    [ConversionRatio]         DECIMAL (18, 2) NULL,
    [VotingRatio]             DECIMAL (18, 2) NULL,
    [LimitDate]               DATETIME        NULL,
    [BasedOn]                 INT             NULL,
    [Notes]                   VARCHAR (MAX)   NULL,
    [Active]                  BIT             CONSTRAINT [DF_tbl_PortfolioSecurity_Active] DEFAULT ((1)) NULL,
    [CreatedDateTime]         DATETIME        NULL,
    [ModifiedDateTime]        DATETIME        NULL,
    [CreatedBy]               VARCHAR (100)   NULL,
    [ModifiedBy]              VARCHAR (100)   NULL,
    [ISIN]                    VARCHAR (100)   NULL,
    [ClassID]                 INT             NULL,
    CONSTRAINT [PK_tbl_PortfolioSecurity] PRIMARY KEY CLUSTERED ([PortfolioSecurityID] ASC),
    CONSTRAINT [PortfolioSecurityPortfolioID] FOREIGN KEY ([PortfolioID]) REFERENCES [dbo].[tbl_Portfolio] ([PortfolioID]),
    CONSTRAINT [SecurityType] FOREIGN KEY ([PortfolioSecurityTypeID]) REFERENCES [dbo].[tbl_PortfolioSecurityType] ([PortfolioSecurityTypeID])
);


GO
ALTER TABLE [dbo].[tbl_PortfolioSecurity] NOCHECK CONSTRAINT [PortfolioSecurityPortfolioID];


GO
ALTER TABLE [dbo].[tbl_PortfolioSecurity] NOCHECK CONSTRAINT [SecurityType];


GO
CREATE NONCLUSTERED INDEX [IX_tbl_PortfolioSecurity]
    ON [dbo].[tbl_PortfolioSecurity]([PortfolioID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_PortfolioSecurity_1]
    ON [dbo].[tbl_PortfolioSecurity]([PortfolioSecurityTypeID] ASC);

