CREATE TABLE [dbo].[tbl_PortfolioVehicle] (
    [PortfolioVehicleID] INT             IDENTITY (1, 1) NOT NULL,
    [PortfolioID]        INT             NULL,
    [VehicleID]          INT             NULL,
    [Active]             BIT             NULL,
    [CreatedBy]          VARCHAR (100)   NULL,
    [CreatedDateTime]    DATETIME        NULL,
    [ModifiedBy]         VARCHAR (100)   NULL,
    [ModifiedDateTime]   DATETIME        NULL,
    [Status]             INT             NULL,
    [Amount]             DECIMAL (18, 2) NULL,
    [IRRGross]           DECIMAL (18, 6) NULL,
    [IRRNet]             DECIMAL (18, 6) NULL,
    [MultipleGross]      DECIMAL (18, 6) NULL,
    [MultipleNet]        DECIMAL (18, 6) NULL,
    [IRRGrossFX]         DECIMAL (18, 6) NULL,
    [MultipleGrossFX]    DECIMAL (18, 6) NULL,
    [IRRNetFX]           DECIMAL (18, 6) NULL,
    [MultipleNetFX]      DECIMAL (18, 6) NULL,
    CONSTRAINT [PK_tbl_PortfolioVehicle] PRIMARY KEY CLUSTERED ([PortfolioVehicleID] ASC),
    CONSTRAINT [PortfolioVehiclePortfolioID] FOREIGN KEY ([PortfolioID]) REFERENCES [dbo].[tbl_Portfolio] ([PortfolioID])
);


GO
ALTER TABLE [dbo].[tbl_PortfolioVehicle] NOCHECK CONSTRAINT [PortfolioVehiclePortfolioID];


GO
CREATE NONCLUSTERED INDEX [IX_tbl_PortfolioVehicle]
    ON [dbo].[tbl_PortfolioVehicle]([PortfolioID] ASC);

