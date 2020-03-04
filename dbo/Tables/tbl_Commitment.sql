CREATE TABLE [dbo].[tbl_Commitment] (
    [CommitmentID]        INT             NOT NULL,
    [Date]                DATETIME        NULL,
    [SubscriptionPremium] DECIMAL (18, 2) NULL,
    [ModuleID]            INT             NULL,
    [ObjectID]            INT             NULL,
    [FundID]              INT             NULL,
    [Notes]               VARCHAR (MAX)   NULL,
    [Active]              BIT             NULL,
    [CreatedBy]           VARCHAR (50)    NULL,
    [CreatedDateTime]     DATETIME        NULL,
    [ModifiedBy]          VARCHAR (50)    NULL,
    [ModifiedDateTime]    DATETIME        NULL
);

