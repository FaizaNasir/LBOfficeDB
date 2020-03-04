CREATE TABLE [dbo].[tbl_PortfolioFundUnderlyingInvestments] (
    [PortfolioFundUnderlyingInvestmentsID] INT             IDENTITY (1, 1) NOT NULL,
    [VehicleID]                            INT             NOT NULL,
    [CountryID]                            INT             NULL,
    [CurrencyID]                           INT             NULL,
    [CompanyName]                          NVARCHAR (MAX)  NULL,
    [BusinessAreaID]                       INT             NULL,
    [InvestmentDate]                       DATETIME        NULL,
    [ExitDate]                             DATETIME        NULL,
    [BusinessDescription]                  NVARCHAR (MAX)  NULL,
    [AcquisitionEBITDAMultiple]            DECIMAL (18, 3) NULL,
    [ExitEBITDAMultiple]                   DECIMAL (18, 3) NULL,
    [DealType]                             VARCHAR (100)   NULL,
    [HighLevelDealType]                    VARCHAR (100)   NULL,
    [Segment]                              VARCHAR (100)   NULL,
    [AcquisitionRevenue]                   DECIMAL (18, 3) NULL,
    [AcquisitionEBITDA]                    DECIMAL (18, 3) NULL,
    [AcquisitionEBIT]                      DECIMAL (18, 3) NULL,
    [AcquisitionNetDebt]                   DECIMAL (18, 3) NULL,
    [AcquisitionDebtEBITDAMultiple]        DECIMAL (18, 3) NULL,
    [AcquisitionEnterpriseValue]           DECIMAL (18, 3) NULL,
    PRIMARY KEY CLUSTERED ([PortfolioFundUnderlyingInvestmentsID] ASC)
);

