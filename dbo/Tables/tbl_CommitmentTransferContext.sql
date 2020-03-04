CREATE TABLE [dbo].[tbl_CommitmentTransferContext] (
    [CommitmentTransferContextID] INT             IDENTITY (1, 1) NOT NULL,
    [CommitmentTransferShareID]   INT             NULL,
    [VehicleID]                   INT             NULL,
    [ContextID]                   INT             NULL,
    [DocumentTypeID]              INT             NULL,
    [Amount]                      DECIMAL (18, 3) NULL,
    [FromLPID]                    INT             NULL,
    [FromModuleID]                INT             NULL,
    [FromObjectID]                INT             NULL,
    [ToLPID]                      INT             NULL,
    [ToModuleID]                  INT             NULL,
    [ToObjectID]                  INT             NULL,
    [Active]                      BIT             CONSTRAINT [DF_tbl_CommitmentTransferContext_Active] DEFAULT ((1)) NULL,
    [CreatedDateTime]             DATETIME        NULL,
    [ModifiedDateTime]            DATETIME        NULL,
    [CreatedBy]                   VARCHAR (100)   NULL,
    [ModifiedBy]                  VARCHAR (100)   NULL,
    CONSTRAINT [PK_tbl_CommitmentTransferContext] PRIMARY KEY CLUSTERED ([CommitmentTransferContextID] ASC)
);

