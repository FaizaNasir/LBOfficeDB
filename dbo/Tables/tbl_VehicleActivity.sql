CREATE TABLE [dbo].[tbl_VehicleActivity] (
    [Id]               INT           IDENTITY (1, 1) NOT NULL,
    [VehicleID]        INT           NULL,
    [ActivityId]       INT           NULL,
    [Active]           BIT           NULL,
    [CreatedDateTime]  DATETIME      NULL,
    [ModifiedDateTime] DATETIME      NULL,
    [CreatedBy]        VARCHAR (100) NULL,
    [ModifiedBy]       VARCHAR (100) NULL,
    CONSTRAINT [PK_tbl_FuindActivity] PRIMARY KEY CLUSTERED ([Id] ASC)
);

