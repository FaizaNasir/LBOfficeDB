CREATE TABLE [dbo].[tbl_CapitalCallOperation] (
    [CapitalCallOperationID] INT             IDENTITY (1, 1) NOT NULL,
    [FundID]                 INT             NULL,
    [ModuleID]               INT             NULL,
    [Date]                   DATETIME        NULL,
    [Type]                   VARCHAR (50)    NULL,
    [ShareID]                INT             NULL,
    [CapitalCallID]          INT             NULL,
    [Active]                 BIT             NULL,
    [CreatedBy]              VARCHAR (50)    NULL,
    [CreatedDateTime]        DATETIME        NULL,
    [ModifiedBy]             VARCHAR (50)    NULL,
    [ModifiedDateTime]       DATETIME        NULL,
    [InvestmentAmount]       DECIMAL (18, 5) NULL,
    [ManagementFees]         DECIMAL (18, 5) NULL,
    [OtherFees]              DECIMAL (18, 5) NULL,
    CONSTRAINT [PK_tbl_CapitalCallOperation] PRIMARY KEY CLUSTERED ([CapitalCallOperationID] ASC)
);

