CREATE TABLE [dbo].[tbl_Activities] (
    [ActiviteID]            INT           IDENTITY (1, 1) NOT NULL,
    [ActiviteName]          VARCHAR (500) NOT NULL,
    [Active]                BIT           NULL,
    [PortfolioTargetTypeID] INT           NULL,
    CONSTRAINT [PK_tbl_Activities] PRIMARY KEY CLUSTERED ([ActiviteID] ASC)
);

