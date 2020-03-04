CREATE TABLE [dbo].[tbl_VehicleManagementFee] (
    [VehicleManagementFeeID] INT             IDENTITY (1, 1) NOT NULL,
    [VehicleID]              INT             NULL,
    [Commitment]             DECIMAL (18, 6) NULL,
    [BasisPeriod]            DECIMAL (18, 6) NULL,
    [FeesReceivedByGP]       DECIMAL (18, 6) NULL,
    [Date]                   DATETIME        NULL,
    [Active]                 BIT             DEFAULT ((1)) NULL,
    [CreatedDate]            DATETIME        DEFAULT (getdate()) NULL,
    [ModifiedDate]           DATETIME        NULL,
    [CreatedBy]              VARCHAR (1000)  NULL,
    [ModifiedBy]             VARCHAR (1000)  NULL,
    [AcquisitionCost]        DECIMAL (18, 6) NULL,
    [InvestmentAmount]       DECIMAL (18, 6) NULL,
    [TotalAmount]            DECIMAL (18, 6) NULL,
    CONSTRAINT [PK_VehicleManagementFeeID] PRIMARY KEY CLUSTERED ([VehicleManagementFeeID] ASC)
);

