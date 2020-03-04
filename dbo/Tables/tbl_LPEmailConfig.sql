CREATE TABLE [dbo].[tbl_LPEmailConfig] (
    [LPEmailConfigID] INT           IDENTITY (1, 1) NOT NULL,
    [ModuleID]        INT           NULL,
    [ObjectID]        INT           NULL,
    [VehicleID]       INT           NULL,
    [DocumentTypeID]  INT           NULL,
    [ToEmailAddress]  VARCHAR (MAX) NULL,
    [CCEmailAddress]  VARCHAR (MAX) NULL,
    [Active]          BIT           NULL,
    [CreatedDate]     DATETIME      NULL,
    [ModifiedDate]    DATETIME      NULL,
    [CreatedBy]       VARCHAR (100) NULL,
    [ModifiedBy]      VARCHAR (100) NULL,
    CONSTRAINT [PK_tbl_LPEmailConfig] PRIMARY KEY CLUSTERED ([LPEmailConfigID] ASC)
);

