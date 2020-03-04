CREATE TABLE [dbo].[tbl_Eligibility] (
    [EligibilityID]           INT             IDENTITY (1, 1) NOT NULL,
    [ObjectModuleID]          INT             NULL,
    [ModuleID]                INT             NULL,
    [EmpNumber]               INT             NULL,
    [HeadquarterID]           INT             NULL,
    [IsTargetPayTax]          BIT             NULL,
    [IsCapital]               BIT             NULL,
    [IsCompanylessthan5Years] BIT             NULL,
    [IsCompanylessthan8Years] BIT             NULL,
    [VehicleID]               INT             NULL,
    [QuotationID]             INT             NULL,
    [AmountCapitalIncrease]   DECIMAL (18, 2) NULL,
    [AmountConvertableBonds]  DECIMAL (18, 2) NULL,
    [AmountTransferSecurity]  DECIMAL (18, 2) NULL,
    [AmountCurrentAccount]    DECIMAL (18, 2) NULL,
    [Active]                  BIT             NULL,
    [CreatedDateTime]         DATETIME        NULL,
    [ModifiedDateTime]        DATETIME        NULL,
    [CreatedBy]               VARCHAR (100)   NULL,
    [ModifiedBy]              VARCHAR (100)   NULL,
    CONSTRAINT [PK_tbl_Eligibility] PRIMARY KEY CLUSTERED ([EligibilityID] ASC)
);

