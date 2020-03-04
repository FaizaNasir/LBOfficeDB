CREATE TABLE [dbo].[tbl_CommitmentTransfer] (
    [CommitmentTransferID] INT             IDENTITY (1, 1) NOT NULL,
    [Date]                 DATETIME        NULL,
    [SubscriptionPremium]  DECIMAL (18, 2) NULL,
    [FromLPID]             INT             NULL,
    [FromModuleID]         INT             NULL,
    [FromObjectID]         INT             NULL,
    [ToLPID]               INT             NULL,
    [ToModuleID]           INT             NULL,
    [ToObjectID]           INT             NULL,
    [FundID]               INT             NULL,
    [Notes]                VARCHAR (MAX)   NULL,
    [Active]               BIT             NULL,
    [CreatedBy]            VARCHAR (50)    NULL,
    [CreatedDateTime]      DATETIME        NULL,
    [ModifiedBy]           VARCHAR (50)    NULL,
    [ModifiedDateTime]     DATETIME        NULL,
    [ParentID]             INT             NULL,
    CONSTRAINT [PK_tbl_CommitmentTransfer] PRIMARY KEY CLUSTERED ([CommitmentTransferID] ASC)
);

