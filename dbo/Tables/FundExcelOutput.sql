CREATE TABLE [dbo].[FundExcelOutput] (
    [ExcelOutputID]                  INT        IDENTITY (1, 1) NOT NULL,
    [FundID]                         INT        NULL,
    [ShareID]                        INT        NULL,
    [TotalNAVCell]                   NCHAR (10) NULL,
    [NAVPerShareCell]                NCHAR (10) NULL,
    [ReturnOfCapitalAmountCell]      NCHAR (10) NULL,
    [ProfitsAmountCell]              NCHAR (10) NULL,
    [IsActive]                       BIT        NULL,
    [CarriedInterestCell]            NCHAR (10) NULL,
    [InitialShareValueReimbursement] NCHAR (20) NULL,
    [PreferredReturn]                NCHAR (20) NULL,
    [ACShares]                       NCHAR (20) NULL,
    [NetSurplusPaidInCash]           NCHAR (20) NULL,
    CONSTRAINT [PK_FundExcelOutPut] PRIMARY KEY CLUSTERED ([ExcelOutputID] ASC)
);

