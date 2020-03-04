CREATE TABLE [dbo].[tbl_PortfolioDebtCovenant] (
    [PortfolioDebtCovenantID] INT             IDENTITY (1, 1) NOT NULL,
    [PortfolioSecurityID]     INT             NULL,
    [CovenantTypeID]          VARCHAR (100)   NULL,
    [Ratio]                   DECIMAL (18, 2) NULL,
    [Active]                  BIT             CONSTRAINT [DF_tbl_PortfolioDebtCovenant_Active] DEFAULT ((1)) NULL,
    [CreatedDateTime]         DATETIME        NULL,
    [ModifiedDateTime]        DATETIME        NULL,
    [CreatedBy]               VARCHAR (100)   NULL,
    [ModifiedBy]              VARCHAR (100)   NULL,
    [Type]                    VARCHAR (100)   NULL,
    CONSTRAINT [PK_tbl_PortfolioDebtCovenant] PRIMARY KEY CLUSTERED ([PortfolioDebtCovenantID] ASC)
);

