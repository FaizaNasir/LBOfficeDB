CREATE TABLE [dbo].[FundExcelInputDetail] (
    [ExcelInputDetailID]     INT        IDENTITY (1, 1) NOT NULL,
    [FundID]                 INT        NULL,
    [ShareID]                INT        NULL,
    [NumOfSharesCell]        NCHAR (10) NULL,
    [CommitmentsCell]        NCHAR (10) NULL,
    [CallsCell]              NCHAR (10) NULL,
    [IncludingFees]          NCHAR (10) NULL,
    [DistributionsCell]      NCHAR (10) NULL,
    [ReturnOfCapitalCell]    NCHAR (10) NULL,
    [IsActive]               BIT        NULL,
    [ShareCashFlowstartCell] NCHAR (10) NULL,
    [Undrawn]                NCHAR (20) NULL,
    [Recallable]             NCHAR (40) NULL,
    CONSTRAINT [PK_FundExcelInputDetail] PRIMARY KEY CLUSTERED ([ExcelInputDetailID] ASC)
);

