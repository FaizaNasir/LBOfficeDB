CREATE TABLE [dbo].[tbl_Office] (
    [OfficeID]         INT            IDENTITY (1, 1) NOT NULL,
    [OfficeName]       VARCHAR (1000) NULL,
    [CreatedDateTime]  DATETIME       NULL,
    [ModifiedDateTime] DATETIME       NULL,
    CONSTRAINT [PK_tbl_Office] PRIMARY KEY CLUSTERED ([OfficeID] ASC)
);

