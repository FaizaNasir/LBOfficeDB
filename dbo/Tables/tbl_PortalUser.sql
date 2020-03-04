CREATE TABLE [dbo].[tbl_PortalUser] (
    [PortalUserID]     INT            IDENTITY (1, 1) NOT NULL,
    [Email]            VARCHAR (1000) NULL,
    [Password]         VARCHAR (1000) NULL,
    [ObjectID]         INT            NULL,
    [ModuleID]         INT            NULL,
    [Active]           BIT            CONSTRAINT [DF_tbl_PortalUser_Active] DEFAULT ((1)) NULL,
    [CreatedDateTime]  DATETIME       NULL,
    [ModifiedDateTime] DATETIME       NULL,
    [CreatedBy]        VARCHAR (100)  NULL,
    [ModifiedBy]       VARCHAR (100)  NULL,
    [Name]             VARCHAR (1000) NULL,
    [IsAllowed]        BIT            NULL,
    CONSTRAINT [PK_tbl_PortalUser] PRIMARY KEY CLUSTERED ([PortalUserID] ASC)
);

