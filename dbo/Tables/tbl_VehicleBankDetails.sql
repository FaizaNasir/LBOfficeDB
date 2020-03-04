CREATE TABLE [dbo].[tbl_VehicleBankDetails] (
    [VehicleBankDetailsID] INT           IDENTITY (1, 1) NOT NULL,
    [VehicleID]            INT           NULL,
    [AccountName]          VARCHAR (100) NULL,
    [AccountNumber]        VARCHAR (100) NULL,
    [AccountIBAN]          VARCHAR (100) NULL,
    [BankSWIFT]            VARCHAR (100) NULL,
    [AccountCurrencyID]    INT           NULL,
    [CustodianID]          INT           NULL,
    [CreatedDateTime]      DATETIME      NULL,
    [CreatedBy]            VARCHAR (100) NULL,
    [ModifiedDateTime]     DATETIME      NULL,
    [ModifiedBy]           VARCHAR (100) NULL,
    [Active]               BIT           NULL,
    [BranchCode]           VARCHAR (50)  NULL,
    [SortCode]             VARCHAR (50)  NULL,
    [RIBCode]              VARCHAR (50)  NULL,
    CONSTRAINT [PK_tbl_FundBankDetails_1] PRIMARY KEY CLUSTERED ([VehicleBankDetailsID] ASC),
    CONSTRAINT [VehicleBankDetailsVehicleID] FOREIGN KEY ([VehicleID]) REFERENCES [dbo].[tbl_Vehicle] ([VehicleID])
);


GO
ALTER TABLE [dbo].[tbl_VehicleBankDetails] NOCHECK CONSTRAINT [VehicleBankDetailsVehicleID];


GO
CREATE NONCLUSTERED INDEX [IX_tbl_VehicleBankDetails]
    ON [dbo].[tbl_VehicleBankDetails]([VehicleID] ASC);

