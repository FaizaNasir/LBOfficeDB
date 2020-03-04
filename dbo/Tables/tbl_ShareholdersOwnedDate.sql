CREATE TABLE [dbo].[tbl_ShareholdersOwnedDate] (
    [ShareholderDateId] INT      IDENTITY (1, 1) NOT NULL,
    [TargetPortfolioId] INT      NOT NULL,
    [Date]              DATETIME NOT NULL,
    CONSTRAINT [PK_tbl_ShareholderOwnedDate] PRIMARY KEY CLUSTERED ([ShareholderDateId] ASC)
);

