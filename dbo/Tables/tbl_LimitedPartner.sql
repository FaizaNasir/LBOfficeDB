CREATE TABLE [dbo].[tbl_LimitedPartner] (
    [LimitedPartnerID] INT             IDENTITY (1, 1) NOT NULL,
    [ModuleID]         INT             NULL,
    [ObjectID]         INT             NULL,
    [VehicleID]        INT             NULL,
    [Date]             DATETIME        NULL,
    [Subscription]     DECIMAL (18, 2) NULL,
    [Notes]            VARCHAR (1000)  NULL,
    [Active]           BIT             NULL,
    [CreatedDateTime]  DATETIME        NULL,
    [ModifiedDateTime] DATETIME        NULL,
    [CreatedBy]        VARCHAR (100)   NULL,
    [ModifiedBy]       VARCHAR (100)   NULL,
    [IsFake]           BIT             DEFAULT ((0)) NULL,
    CONSTRAINT [PK_tbl_LimitedPartner] PRIMARY KEY CLUSTERED ([LimitedPartnerID] ASC)
);

