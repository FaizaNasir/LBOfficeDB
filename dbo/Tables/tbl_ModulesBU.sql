CREATE TABLE [dbo].[tbl_ModulesBU] (
    [ModuleID]        INT            NOT NULL,
    [ActiviteID]      INT            NOT NULL,
    [ModuleName]      VARCHAR (50)   NOT NULL,
    [ModuleDesc]      VARCHAR (50)   NULL,
    [ModuleURL]       VARCHAR (1000) NULL,
    [IsSelected]      BIT            NULL,
    [CssTag]          VARCHAR (50)   NULL,
    [OrderBy]         INT            NULL,
    [IsActive]        BIT            NULL,
    [CreatedDateTime] DATETIME       NULL,
    [IsRead]          BIT            NULL,
    [IsEdit]          BIT            NULL,
    [IsCreate]        BIT            NULL,
    [IsDelete]        BIT            NULL,
    [IsExcel]         BIT            NULL
);

