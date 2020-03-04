CREATE TABLE [dbo].[tbl_Module_TabsBU] (
    [TabID]          INT            NOT NULL,
    [ModuleID]       INT            NULL,
    [ActiviteID]     INT            NULL,
    [TabTitle]       NVARCHAR (100) NULL,
    [TabDescription] NVARCHAR (100) NULL,
    [TabPageURL]     VARCHAR (1000) NULL,
    [TabPageEditURL] VARCHAR (1000) NULL,
    [TabOrder]       INT            NULL,
    [IsConditional]  BIT            NULL,
    [IsSelected]     BIT            NULL,
    [IsEditable]     BIT            NULL,
    [TabType]        INT            NULL,
    [CSSTag]         VARCHAR (50)   NULL,
    [IsActive]       BIT            NULL,
    [IsRead]         BIT            NULL,
    [IsEdit]         BIT            NULL,
    [IsCreate]       BIT            NULL,
    [IsDelete]       BIT            NULL,
    [IsExcel]        BIT            NULL
);

