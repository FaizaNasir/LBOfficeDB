CREATE TABLE [dbo].[tbl_GeographicalRegion] (
    [GeographicalRegionID]    INT           NOT NULL,
    [GeographicalRegionTitle] VARCHAR (100) NULL,
    [GeographicalRegionDesc]  VARCHAR (100) NULL,
    [Active]                  BIT           NULL,
    [CreatedDateTime]         DATETIME      NULL,
    CONSTRAINT [PK_tbl_GeographicalRegion] PRIMARY KEY CLUSTERED ([GeographicalRegionID] ASC)
);

