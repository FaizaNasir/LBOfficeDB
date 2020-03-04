﻿CREATE TABLE [dbo].[tbl_DistributionOperation] (
    [DistributionOperationID] INT             IDENTITY (1, 1) NOT NULL,
    [FundID]                  INT             NULL,
    [ModuleID]                INT             NULL,
    [Date]                    DATETIME        NULL,
    [Type]                    VARCHAR (50)    NULL,
    [ShareID]                 INT             NULL,
    [DistributionID]          INT             NULL,
    [Active]                  BIT             NULL,
    [CreatedBy]               VARCHAR (50)    NULL,
    [CreatedDateTime]         DATETIME        NULL,
    [ModifiedBy]              VARCHAR (50)    NULL,
    [ModifiedDateTime]        DATETIME        NULL,
    [InvestmentAmount]        DECIMAL (18, 5) NULL,
    [ManagementFees]          DECIMAL (18, 5) NULL,
    [OtherFees]               DECIMAL (18, 5) NULL,
    [ReturnOfCapital]         DECIMAL (18, 5) NULL,
    [Profit]                  DECIMAL (18, 5) NULL,
    [TotalDistribution]       DECIMAL (18, 5) NULL,
    [DistributionByShare]     DECIMAL (18, 5) NULL,
    [Undrawn]                 DECIMAL (18, 6) NULL,
    [Recallable]              DECIMAL (18, 6) NULL,
    CONSTRAINT [PK_tbl_DistributionOperation] PRIMARY KEY CLUSTERED ([DistributionOperationID] ASC)
);
