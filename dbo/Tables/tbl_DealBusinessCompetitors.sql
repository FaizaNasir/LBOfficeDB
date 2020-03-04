CREATE TABLE [dbo].[tbl_DealBusinessCompetitors] (
    [DealBusinessCompetitorsID] INT           IDENTITY (1, 1) NOT NULL,
    [CompetitorName]            NVARCHAR (50) NULL,
    [Comments]                  NVARCHAR (50) NULL,
    [DealID]                    INT           NULL
);

