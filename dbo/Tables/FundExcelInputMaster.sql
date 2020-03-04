CREATE TABLE [dbo].[FundExcelInputMaster] (
    [ExcelInputID]           INT        IDENTITY (1, 1) NOT NULL,
    [FundID]                 INT        NULL,
    [DateCell]               NCHAR (10) NULL,
    [NavDistributionAmount]  NCHAR (10) NULL,
    [CashFlowstartCell]      NCHAR (10) NULL,
    [PaidCarriedInterest]    NCHAR (10) NULL,
    [PendingCarriedInterest] NCHAR (10) NULL,
    [IsActive]               BIT        NULL,
    CONSTRAINT [PK_FundExcelInputMaster] PRIMARY KEY CLUSTERED ([ExcelInputID] ASC)
);

