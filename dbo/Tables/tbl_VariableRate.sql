CREATE TABLE [dbo].[tbl_VariableRate] (
    [PortfolioVariableRateID] INT           IDENTITY (1, 1) NOT NULL,
    [PortfolioSecurityID]     INT           NULL,
    [Year]                    INT           NULL,
    [Rate]                    DECIMAL (18)  NULL,
    [Capitalized]             BIT           NULL,
    [Active]                  BIT           CONSTRAINT [DF_tbl_VariableRate_Active] DEFAULT ((1)) NULL,
    [CreatedDateTime]         DATETIME      NULL,
    [ModifiedDateTime]        DATETIME      NULL,
    [CreatedBy]               VARCHAR (100) NULL,
    [ModifiedBy]              VARCHAR (100) NULL,
    CONSTRAINT [PK_tbl_VariableRate] PRIMARY KEY CLUSTERED ([PortfolioVariableRateID] ASC)
);

