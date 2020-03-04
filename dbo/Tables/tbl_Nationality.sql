CREATE TABLE [dbo].[tbl_Nationality] (
    [NationalityID] INT IDENTITY (1, 1) NOT NULL,
    [IndividualID]  INT NULL,
    [CountryID]     INT NULL,
    CONSTRAINT [PK_tbl_Nationality] PRIMARY KEY CLUSTERED ([NationalityID] ASC)
);

