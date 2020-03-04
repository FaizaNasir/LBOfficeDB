CREATE TABLE [dbo].[tbl_Region] (
    [RegionID]         INT            IDENTITY (1, 1) NOT NULL,
    [RegionName]       VARCHAR (100)  NULL,
    [CountryID]        INT            NULL,
    [Active]           BIT            NULL,
    [CreatedDateTime]  DATETIME       NULL,
    [ModifiedDateTime] DATETIME       NULL,
    [CreatedBy]        VARCHAR (1000) NULL,
    [ModifiedBy]       VARCHAR (1000) NULL,
    CONSTRAINT [PK_tbl_Region] PRIMARY KEY CLUSTERED ([RegionID] ASC)
);

