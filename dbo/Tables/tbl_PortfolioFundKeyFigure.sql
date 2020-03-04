CREATE TABLE [dbo].[tbl_PortfolioFundKeyFigure] (
    [PortfolioFundKeyFIgureID]             INT            IDENTITY (1, 1) NOT NULL,
    [PortfolioFundUnderlyingInvestmentsID] INT            NULL,
    [VehicleID]                            INT            NULL,
    [TargetPortfolioID]                    INT            NULL,
    [PortfolioFundKeyfigureConfigID]       INT            NULL,
    [Year]                                 DATETIME       NULL,
    [Amount]                               VARCHAR (1000) NULL,
    [Active]                               BIT            CONSTRAINT [DF_tbl_PortfolioFundKeyFIgure1_Active] DEFAULT ((1)) NULL,
    [CreatedDateTime]                      DATETIME       NULL,
    [ModifiedDateTime]                     DATETIME       NULL,
    [CreatedBy]                            VARCHAR (100)  NULL,
    [ModifiedBy]                           VARCHAR (100)  NULL,
    [SubTab]                               INT            NULL,
    [Date]                                 DATETIME       NULL,
    [Type]                                 NVARCHAR (100) NULL,
    CONSTRAINT [PK_tbl_PortfolioFundKeyFIgure1] PRIMARY KEY CLUSTERED ([PortfolioFundKeyFIgureID] ASC)
);

