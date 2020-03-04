CREATE TABLE [dbo].[tbl_TabsPermission] (
    [TabsPermissionID] INT           IDENTITY (1, 1) NOT NULL,
    [ModuleID]         INT           NULL,
    [TabID]            INT           NULL,
    [SubTabID]         INT           NULL,
    [UserRole]         VARCHAR (100) NULL,
    [IsRead]           BIT           NULL,
    [IsEdit]           BIT           NULL,
    [IsCreate]         BIT           NULL,
    [IsDelete]         BIT           NULL,
    [IsExcel]          BIT           NULL,
    [Active]           BIT           NULL,
    [CreateDateTime]   DATETIME      NULL,
    [ModifiedDateTime] DATETIME      NULL,
    [CreatedBy]        VARCHAR (100) NULL,
    [ModifiedBy]       VARCHAR (100) NULL,
    CONSTRAINT [PK_tbl_TabsPermission] PRIMARY KEY CLUSTERED ([TabsPermissionID] ASC)
);

