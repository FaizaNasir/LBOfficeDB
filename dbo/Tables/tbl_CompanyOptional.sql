CREATE TABLE [dbo].[tbl_CompanyOptional] (
    [CompanyOptionalID]        INT           IDENTITY (1, 1) NOT NULL,
    [CompanyID]                INT           NULL,
    [AMLFinalized]             BIT           NULL,
    [ClientType]               BIT           NULL,
    [AMLCategory]              INT           NULL,
    [ClientPoliticallyExposed] BIT           NULL,
    [ResidenceCountry]         INT           NULL,
    [ClientMet]                BIT           NULL,
    [LastReviewDate]           DATETIME      NULL,
    [Active]                   BIT           NULL,
    [CreatedDate]              DATETIME      NULL,
    [ModifiedDate]             DATETIME      NULL,
    [CreatedBy]                VARCHAR (100) NULL,
    [ModifiedBy]               VARCHAR (100) NULL,
    CONSTRAINT [PK_tbl_CompanyOptional] PRIMARY KEY CLUSTERED ([CompanyOptionalID] ASC)
);

