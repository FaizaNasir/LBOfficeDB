CREATE TABLE [dbo].[tbl_PortfolioVariableRate] (
    [PortfolioVariableRateID] INT             IDENTITY (1, 1) NOT NULL,
    [PortfolioSecurityID]     INT             NULL,
    [Year]                    INT             NULL,
    [Rate]                    DECIMAL (18, 2) NULL,
    [Capitalized]             BIT             NULL,
    [Active]                  BIT             NULL,
    [CreatedDateTime]         DATETIME        NULL,
    [ModifiedDateTime]        DATETIME        NULL,
    [CreatedBy]               VARCHAR (100)   NULL,
    [ModifiedBy]              VARCHAR (100)   NULL,
    CONSTRAINT [PK_tbl_PortfolioVariableRate] PRIMARY KEY CLUSTERED ([PortfolioVariableRateID] ASC)
);

