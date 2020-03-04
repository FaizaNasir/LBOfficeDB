CREATE TABLE [dbo].[tbl_OutlookContactSync] (
    [OutlookID]  INT            IDENTITY (1, 1) NOT NULL,
    [Email]      VARCHAR (1000) NULL,
    [UpdateDate] DATETIME       NULL,
    CONSTRAINT [PK_tbl_OutlookContactSync] PRIMARY KEY CLUSTERED ([OutlookID] ASC)
);

