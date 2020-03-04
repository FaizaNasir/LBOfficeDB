CREATE TABLE [dbo].[tbl_DealIntroductionWith] (
    [DealIntroductionWithID]   INT            IDENTITY (1, 1) NOT NULL,
    [DealIntroductionWithName] VARCHAR (1000) NULL,
    [CreatedDateTime]          DATETIME       NULL,
    [ModifiedDateTime]         DATETIME       NULL,
    CONSTRAINT [PK_tbl_DealIntroductionWith] PRIMARY KEY CLUSTERED ([DealIntroductionWithID] ASC)
);

