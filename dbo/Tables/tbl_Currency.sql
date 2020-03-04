CREATE TABLE [dbo].[tbl_Currency] (
    [CurrencyID]      INT           IDENTITY (1, 1) NOT NULL,
    [CurrencyCode]    VARCHAR (50)  NULL,
    [CurrencyCountry] VARCHAR (100) NULL,
    [CurrencySign]    VARCHAR (50)  NULL,
    [Active]          BIT           NULL,
    [CreatedDateTime] DATETIME      NULL,
    CONSTRAINT [PK_tbl_Currency] PRIMARY KEY CLUSTERED ([CurrencyID] ASC)
);

