CREATE TABLE [dbo].[tbl_Contenents] (
    [ContenentID]   INT            IDENTITY (1, 1) NOT NULL,
    [ContenentName] NVARCHAR (100) NULL,
    [Active]        BIT            NULL,
    CONSTRAINT [PK_tbl_Contenents] PRIMARY KEY CLUSTERED ([ContenentID] ASC)
);

