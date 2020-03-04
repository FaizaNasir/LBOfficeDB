CREATE TABLE [dbo].[KYCChecklistConfig] (
    [KYCChecklistConfigID] INT            IDENTITY (1, 1) NOT NULL,
    [ModuleID]             INT            NULL,
    [TypeID]               INT            NULL,
    [Notes]                VARCHAR (1000) NULL,
    [Active]               BIT            DEFAULT ((1)) NULL,
    [CreatedDate]          DATETIME       DEFAULT (getdate()) NULL,
    [ModifiedDate]         DATETIME       NULL,
    [CreatedBy]            VARCHAR (1000) NULL,
    [ModifiedBy]           VARCHAR (1000) NULL,
    CONSTRAINT [PK_KYCChecklistConfigID] PRIMARY KEY CLUSTERED ([KYCChecklistConfigID] ASC)
);

