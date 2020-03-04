CREATE TABLE [dbo].[tbl_VehicleNavLimitedPartner] (
    [VehicleNavLimitedPartnerID] INT             IDENTITY (1, 1) NOT NULL,
    [LimitedPartnerID]           INT             NULL,
    [ShareID]                    INT             NULL,
    [Amount]                     DECIMAL (18, 5) NULL,
    [Active]                     BIT             NULL,
    [CreatedDateTime]            DATETIME        NULL,
    [ModifiedDateTime]           DATETIME        NULL,
    [CreatedBy]                  VARCHAR (100)   NULL,
    [ModifiedBy]                 VARCHAR (100)   NULL,
    [VehicleNavID]               INT             NULL,
    [TransferID]                 INT             NULL,
    CONSTRAINT [PK_tbl_VehicleNavLimitedPartner] PRIMARY KEY CLUSTERED ([VehicleNavLimitedPartnerID] ASC)
);

