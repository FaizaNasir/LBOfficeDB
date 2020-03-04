CREATE TABLE [dbo].[tbl_MultiCurrencyRate] (
    [MultiCurrencyRateID] INT             IDENTITY (1, 1) NOT NULL,
    [CurrencyID]          VARCHAR (100)   NULL,
    [Date]                DATETIME        NULL,
    [Rate]                DECIMAL (18, 6) NULL,
    [Active]              BIT             NULL,
    [CreatedDateTime]     DATETIME        NULL,
    [ModifiedDateTime]    DATETIME        NULL,
    [CreatedBy]           VARCHAR (100)   NULL,
    [ModifiedBy]          VARCHAR (100)   NULL,
    CONSTRAINT [PK_tbl_MultiCurrencyRate] PRIMARY KEY CLUSTERED ([MultiCurrencyRateID] ASC)
);

