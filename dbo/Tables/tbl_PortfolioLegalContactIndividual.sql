CREATE TABLE [dbo].[tbl_PortfolioLegalContactIndividual] (
    [PortfolioLegalContactIndividualID] INT           IDENTITY (1, 1) NOT NULL,
    [ContactIndividualID]               INT           NULL,
    [PortfolioLegalID]                  INT           NULL,
    [Active]                            BIT           NULL,
    [CreatedDateTime]                   DATETIME      NULL,
    [ModifiedDateTime]                  DATETIME      NULL,
    [CreatedBy]                         VARCHAR (100) NULL,
    [ModifiedBy]                        VARCHAR (100) NULL,
    CONSTRAINT [PK_tbl_PortfolioLegalContactIndividual] PRIMARY KEY CLUSTERED ([PortfolioLegalContactIndividualID] ASC)
);

