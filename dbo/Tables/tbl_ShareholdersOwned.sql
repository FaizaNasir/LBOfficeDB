CREATE TABLE [dbo].[tbl_ShareholdersOwned] (
    [ShareholderID]          INT             IDENTITY (1, 1) NOT NULL,
    [ModuleID]               INT             NULL,
    [ObjectID]               INT             NULL,
    [TargetPortfolioID]      INT             NULL,
    [ReportName]             VARCHAR (1000)  NULL,
    [Active]                 BIT             NULL,
    [CreatedDateTime]        DATETIME        NULL,
    [ModifiedDateTime]       DATETIME        NULL,
    [CreatedBy]              VARCHAR (100)   NULL,
    [ModifiedBy]             VARCHAR (100)   NULL,
    [Owned]                  DECIMAL (18, 2) NULL,
    [ShareholderOwnedDateId] INT             NULL,
    [NumberofShares]         DECIMAL (18, 6) NULL,
    [ConvertibleBonds]       DECIMAL (18, 6) NULL,
    [NumberofOthers]         DECIMAL (18, 6) NULL,
    [TypeName]               VARCHAR (100)   NULL,
    CONSTRAINT [PK__tmp_ms_x__62752D90E89639C9] PRIMARY KEY CLUSTERED ([ShareholderID] ASC)
);

