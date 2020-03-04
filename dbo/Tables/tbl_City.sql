CREATE TABLE [dbo].[tbl_City] (
    [CityID]          INT           IDENTITY (1, 1) NOT NULL,
    [CountryID]       INT           NULL,
    [CityCode]        VARCHAR (100) NULL,
    [CityName]        VARCHAR (100) NULL,
    [Active]          BIT           NULL,
    [CreatedDateTime] DATETIME      NULL,
    CONSTRAINT [PK_tbl_City_1] PRIMARY KEY CLUSTERED ([CityID] ASC),
    CONSTRAINT [FK_tbl_City_tbl_Country] FOREIGN KEY ([CountryID]) REFERENCES [dbo].[tbl_Country] ([CountryID]) NOT FOR REPLICATION
);


GO
ALTER TABLE [dbo].[tbl_City] NOCHECK CONSTRAINT [FK_tbl_City_tbl_Country];


GO
CREATE NONCLUSTERED INDEX [IX_tbl_City]
    ON [dbo].[tbl_City]([CountryID] ASC);

