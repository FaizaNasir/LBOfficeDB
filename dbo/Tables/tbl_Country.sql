CREATE TABLE [dbo].[tbl_Country] (
    [CountryID]        INT           IDENTITY (1, 1) NOT NULL,
    [CountryCode]      VARCHAR (100) NULL,
    [CountryPhoneCode] VARCHAR (100) NULL,
    [RegionID]         INT           NULL,
    [CountryName]      VARCHAR (100) NULL,
    [CurrencyID]       INT           NULL,
    [Active]           BIT           CONSTRAINT [DF_tbl_Country_Active] DEFAULT ((1)) NULL,
    [ContenentID]      INT           NULL,
    [CreatedDateTime]  DATETIME      CONSTRAINT [DF_tbl_Country_CreatedDateTime] DEFAULT (getdate()) NULL,
    [ISO]              VARCHAR (500) NULL,
    [CountryNameFr]    VARCHAR (500) NULL,
    [ISO2]             VARCHAR (500) NULL,
    CONSTRAINT [PK_tbl_Country] PRIMARY KEY CLUSTERED ([CountryID] ASC)
);

