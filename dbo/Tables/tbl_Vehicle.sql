CREATE TABLE [dbo].[tbl_Vehicle] (
    [VehicleID]                      INT             IDENTITY (1, 1) NOT NULL,
    [ManagementCompanyID]            INT             NULL,
    [TypeID]                         INT             NULL,
    [Name]                           VARCHAR (200)   NULL,
    [MainActivity]                   INT             NULL,
    [Size]                           DECIMAL (18)    NULL,
    [CurrencyID]                     INT             NULL,
    [FormationOn]                    DATE            NULL,
    [FundAddress]                    NVARCHAR (MAX)  NULL,
    [ZipCode]                        VARCHAR (50)    NULL,
    [City]                           INT             NULL,
    [StateID]                        INT             NULL,
    [CountryID]                      INT             NULL,
    [Notes]                          NVARCHAR (MAX)  NULL,
    [SubFundRatiobasedonCommitments] BIT             NULL,
    [CreatedDateTime]                DATETIME        NULL,
    [CreatedBy]                      VARCHAR (100)   NULL,
    [ModifiedDateTime]               DATETIME        NULL,
    [ModifiedBy]                     VARCHAR (100)   NULL,
    [VintageYear]                    INT             NULL,
    [Active]                         BIT             NULL,
    [IRRGross]                       DECIMAL (18, 6) NULL,
    [IRRNet]                         DECIMAL (18, 6) NULL,
    [MultipleGross]                  DECIMAL (18, 6) NULL,
    [MultipleNet]                    DECIMAL (18, 6) NULL,
    [IRRGrossFX]                     DECIMAL (18, 6) NULL,
    [MultipleGrossFX]                DECIMAL (18, 6) NULL,
    [IRRNetFX]                       DECIMAL (18, 6) NULL,
    [MultipleNetFX]                  DECIMAL (18, 6) NULL,
    [IsExit]                         BIT             NULL,
    [Role]                           VARCHAR (MAX)   NULL,
    [TargetGeography]                NVARCHAR (MAX)  NULL,
    [ManagementFee]                  VARCHAR (MAX)   NULL,
    [AdvisoryCost]                   VARCHAR (MAX)   NULL,
    [AssociatedVehicleID]            INT             NULL,
    CONSTRAINT [PK_tbl_Vehicle] PRIMARY KEY CLUSTERED ([VehicleID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_Vehicle]
    ON [dbo].[tbl_Vehicle]([CurrencyID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_Vehicle_1]
    ON [dbo].[tbl_Vehicle]([ManagementCompanyID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_Vehicle_2]
    ON [dbo].[tbl_Vehicle]([StateID] ASC);

