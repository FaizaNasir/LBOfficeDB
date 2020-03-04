CREATE TABLE [dbo].[tbl_CompanyCompetitors] (
    [CompanyCompetitorsID] INT            IDENTITY (1, 1) NOT NULL,
    [CompetitorName]       NVARCHAR (50)  NULL,
    [Comments]             NVARCHAR (MAX) NULL,
    [CompanyID]            INT            NULL,
    CONSTRAINT [PK_tbl_DealBusinessCompetitors] PRIMARY KEY CLUSTERED ([CompanyCompetitorsID] ASC)
);

