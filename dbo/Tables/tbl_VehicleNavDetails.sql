CREATE TABLE [dbo].[tbl_VehicleNavDetails] (
    [VehicleNavDetailID]             INT             IDENTITY (1, 1) NOT NULL,
    [VehicleNavID]                   INT             NULL,
    [ShareID]                        INT             NULL,
    [TotalNav]                       DECIMAL (18, 6) NULL,
    [NavPerShare]                    DECIMAL (18, 6) NULL,
    [Active]                         BIT             CONSTRAINT [DF_tbl_VehicleNavDetails_Active] DEFAULT ((1)) NULL,
    [CreatedDateTime]                DATETIME        NULL,
    [ModifiedDateTime]               DATETIME        NULL,
    [CreatedBy]                      VARCHAR (100)   NULL,
    [ModifiedBy]                     VARCHAR (100)   NULL,
    [Undrawn]                        DECIMAL (18, 3) NULL,
    [CarriedInterest]                DECIMAL (18, 6) NULL,
    [InitialShareValueReimbursement] DECIMAL (18, 6) NULL,
    [PreferredReturn]                DECIMAL (18, 6) NULL,
    [ACShares]                       DECIMAL (18, 6) NULL,
    [NetSurplusPaidInCash]           DECIMAL (18, 6) NULL,
    CONSTRAINT [PK_tbl_VehicleNavDetails] PRIMARY KEY CLUSTERED ([VehicleNavDetailID] ASC)
);

