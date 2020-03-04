CREATE TABLE [dbo].[tbl_Module_Sub_TabsBU] (
    [SubTabID]          INT            NOT NULL,
    [TabID]             INT            NOT NULL,
    [ActiviteID]        INT            NULL,
    [SubTabTitle]       VARCHAR (50)   NOT NULL,
    [SubTabDesc]        VARCHAR (50)   NULL,
    [SubTabPageURL]     VARCHAR (1000) NULL,
    [SubTabPageEditURL] VARCHAR (1000) NULL,
    [SubTabOrder]       INT            NULL,
    [IsConditional]     BIT            NULL,
    [IsSelected]        BIT            NULL,
    [IsEditable]        BIT            NULL,
    [CSSTag]            VARCHAR (50)   NULL,
    [IsActive]          BIT            NULL,
    [CreatedDateTime]   DATETIME       NULL,
    [IsRead]            BIT            NULL,
    [IsEdit]            BIT            NULL,
    [IsCreate]          BIT            NULL,
    [IsDelete]          BIT            NULL,
    [IsExcel]           BIT            NULL
);

