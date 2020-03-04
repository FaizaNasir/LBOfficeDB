CREATE TABLE [dbo].[tbl_AssociatedLP] (
    [AssociatedLPID]  INT            IDENTITY (1, 1) NOT NULL,
    [ModuleID]        INT            NULL,
    [ObjectID]        INT            NULL,
    [VehicleID]       INT            NULL,
    [IsMain]          BIT            NULL,
    [CreatedBy]       VARCHAR (1000) NULL,
    [CreatedDate]     DATETIME       NULL,
    [ModifiedBy]      VARCHAR (1000) NULL,
    [ModifiedDate]    DATETIME       NULL,
    [CurrentModuleID] INT            NULL,
    [CurrentObjectID] INT            NULL,
    CONSTRAINT [PK_tbl_AssociatedLP] PRIMARY KEY CLUSTERED ([AssociatedLPID] ASC)
);

