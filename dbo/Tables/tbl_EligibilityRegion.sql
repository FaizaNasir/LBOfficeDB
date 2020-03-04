CREATE TABLE [dbo].[tbl_EligibilityRegion] (
    [EligibilityRegionID] INT           IDENTITY (1, 1) NOT NULL,
    [EligibilityID]       INT           NULL,
    [RegionID]            INT           NULL,
    [Active]              BIT           NULL,
    [CreatedDateTime]     DATETIME      NULL,
    [ModifiedDateTime]    DATETIME      NULL,
    [CreatedBy]           VARCHAR (100) NULL,
    [ModifiedBy]          VARCHAR (100) NULL,
    CONSTRAINT [PK_tbl_EligibilityRegion] PRIMARY KEY CLUSTERED ([EligibilityRegionID] ASC)
);

