CREATE TABLE [dbo].[tbl_Committee] (
    [CommitteeID]          INT           NOT NULL,
    [CommitteeName]        VARCHAR (100) NULL,
    [CommitteeTypeID]      INT           NULL,
    [CommitteeDate]        DATETIME      NULL,
    [CommitteeDescription] VARCHAR (100) NULL,
    CONSTRAINT [PK_tbl_Committee] PRIMARY KEY CLUSTERED ([CommitteeID] ASC)
);

