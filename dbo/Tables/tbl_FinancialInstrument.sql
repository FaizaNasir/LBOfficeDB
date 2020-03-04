CREATE TABLE [dbo].[tbl_FinancialInstrument] (
    [FinancialInstrumentID]    INT          NOT NULL,
    [FinancialInstrumentTitle] VARCHAR (50) NULL,
    [FinancialInstrumentDesc]  VARCHAR (50) NULL,
    [Active]                   BIT          NULL,
    [CreatedDateTime]          DATETIME     NULL
);

