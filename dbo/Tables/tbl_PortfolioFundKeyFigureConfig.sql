CREATE TABLE [dbo].[tbl_PortfolioFundKeyFigureConfig] (
    [PortfolioFundKeyfigureConfigID]       INT            IDENTITY (1, 1) NOT NULL,
    [PortfolioFundUnderlyingInvestmentsID] INT            NULL,
    [VehicleID]                            INT            NULL,
    [Name]                                 VARCHAR (1000) NULL,
    [Seq]                                  INT            NULL,
    [IsReport]                             BIT            NULL,
    [IsChart]                              BIT            NULL,
    [SubTab]                               INT            NULL,
    [Active]                               BIT            CONSTRAINT [DF_tbl_PortfolioFundKeyfigure_Active] DEFAULT ((1)) NULL,
    [CreatedDateTime]                      DATETIME       NULL,
    [ModifiedDateTime]                     DATETIME       NULL,
    [CreatedBy]                            VARCHAR (100)  NULL,
    [ModifiedBy]                           VARCHAR (100)  NULL,
    [Date]                                 DATETIME       NULL,
    CONSTRAINT [PK_tbl_PortfolioFundKeyfigure] PRIMARY KEY CLUSTERED ([PortfolioFundKeyfigureConfigID] ASC)
);

