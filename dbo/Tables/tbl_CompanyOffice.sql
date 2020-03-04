CREATE TABLE [dbo].[tbl_CompanyOffice] (
    [OfficeID]         INT            IDENTITY (1, 1) NOT NULL,
    [CompanyContactID] INT            NULL,
    [OfficeName]       NVARCHAR (150) NULL,
    [OfficeAddress]    NVARCHAR (100) NULL,
    [OfficeZip]        NVARCHAR (100) NULL,
    [OfficePOBox]      NVARCHAR (100) NULL,
    [OfficeCity]       NVARCHAR (100) NULL,
    [CountryID]        INT            NULL,
    [CityID]           INT            NULL,
    [OfficePhone]      NVARCHAR (100) NULL,
    [OfficeFax]        NVARCHAR (100) NULL,
    [isHeadOffice]     BIT            NULL,
    [OfficeWebsite]    NVARCHAR (100) NULL,
    [OfficeNewGUID]    NVARCHAR (255) NULL,
    [StateID]          INT            NULL,
    [IsMain]           BIT            NULL,
    CONSTRAINT [PK_tbl_CompanyOffice] PRIMARY KEY CLUSTERED ([OfficeID] ASC)
);

