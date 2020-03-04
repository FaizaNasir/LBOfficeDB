CREATE TABLE [dbo].[tbl_Language] (
    [LanguageID]   INT            IDENTITY (1, 1) NOT NULL,
    [LanguageName] VARCHAR (1000) NULL,
    CONSTRAINT [PK_tbl_Language] PRIMARY KEY CLUSTERED ([LanguageID] ASC)
);

