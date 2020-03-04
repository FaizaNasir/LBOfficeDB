CREATE TABLE [dbo].[tbl_OutlookEmailLinkedTo] (
    [OutLookEmailLinkedToID] INT IDENTITY (1, 1) NOT NULL,
    [EmailID]                INT NULL,
    [ObjectID]               INT NULL,
    [ModuleID]               INT NULL,
    [IsEmailTo]              BIT NULL,
    CONSTRAINT [PK_tbl_OutlookEmailLinkedTo] PRIMARY KEY CLUSTERED ([OutLookEmailLinkedToID] ASC)
);

