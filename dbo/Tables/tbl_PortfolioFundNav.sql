CREATE TABLE [dbo].[tbl_PortfolioFundNav] (
    [PortfolioFundNavID]        INT             IDENTITY (1, 1) NOT NULL,
    [VehicleID]                 INT             NOT NULL,
    [VehicleUnderManagmentID]   INT             NULL,
    [Date]                      DATETIME        NULL,
    [NAV]                       DECIMAL (18, 2) NULL,
    [TotalNAV]                  DECIMAL (18, 2) NULL,
    [Unfunded]                  DECIMAL (18, 2) NULL,
    [TotalInvested]             DECIMAL (18, 2) NULL,
    [RemainingCommitments]      DECIMAL (18, 2) NULL,
    [RealizedProceeds]          DECIMAL (18, 2) NULL,
    [Notes]                     VARCHAR (MAX)   NULL,
    [PortfolioInvestments]      DECIMAL (18, 2) NULL,
    [PortfolioReevaluation]     DECIMAL (18, 2) NULL,
    [IncludingCash]             DECIMAL (18, 2) NULL,
    [IncludingConstitutionFees] DECIMAL (18, 2) NULL,
    [IncludingWorkingCapital]   DECIMAL (18, 2) NULL,
    [IncludingFXHedging]        DECIMAL (18, 2) NULL,
    [IncludingBankDebt]         DECIMAL (18, 2) NULL,
    [GrossIRR]                  DECIMAL (18, 6) NULL,
    CONSTRAINT [PK__tmp_ms_x__D496EE91C65323D8] PRIMARY KEY CLUSTERED ([PortfolioFundNavID] ASC),
    CONSTRAINT [FK_tbl_PortolioFundNav_tbl_Vehicle] FOREIGN KEY ([VehicleID]) REFERENCES [dbo].[tbl_Vehicle] ([VehicleID])
);


GO
ALTER TABLE [dbo].[tbl_PortfolioFundNav] NOCHECK CONSTRAINT [FK_tbl_PortolioFundNav_tbl_Vehicle];

