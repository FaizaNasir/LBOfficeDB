CREATE TABLE [dbo].[tbl_CapitalCallShareDetail] (
    [CapitalCallShareDetailID] INT             IDENTITY (1, 1) NOT NULL,
    [CapitalCallID]            INT             NULL,
    [ShareID]                  INT             NULL,
    [Amount]                   DECIMAL (18, 5) NULL,
    CONSTRAINT [PK_tbl_CapitalCallShareDetail] PRIMARY KEY CLUSTERED ([CapitalCallShareDetailID] ASC)
);

