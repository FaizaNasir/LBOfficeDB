CREATE TABLE [dbo].[tbl_Currency_new] (
    [CurrencyID]      INT          IDENTITY (1, 1) NOT NULL,
    [CurrencyCode]    VARCHAR (50) NULL,
    [CurrencySign]    VARCHAR (20) NULL,
    [Active]          BIT          NULL,
    [CreatedDateTime] DATETIME     NULL,
    [CreatedBy]       VARCHAR (50) NULL,
    CONSTRAINT [PK_tbl_Currency_1] PRIMARY KEY CLUSTERED ([CurrencyID] ASC)
);

