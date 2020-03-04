CREATE TABLE [dbo].[tbl_PortfolioSecurityClass] (
    [ClassID]          INT           IDENTITY (1, 1) NOT NULL,
    [ClassNumber]      INT           NULL,
    [ClassName]        VARCHAR (100) NULL,
    [CreatedBy]        VARCHAR (100) NULL,
    [CreatedDateTime]  DATETIME      NULL,
    [ModifiedBy]       VARCHAR (100) NULL,
    [ModifiedDateTime] DATETIME      NULL,
    [Active]           BIT           NULL,
    CONSTRAINT [PK_tbl_PortfolioSecurityClass] PRIMARY KEY CLUSTERED ([ClassID] ASC)
);

