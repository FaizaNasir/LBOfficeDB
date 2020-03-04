CREATE TABLE [dbo].[tbl_VehicleReport] (
    [VehicleReportID]    INT            IDENTITY (1, 1) NOT NULL,
    [VehicleID]          INT            NULL,
    [Date]               DATETIME       NULL,
    [Report]             VARCHAR (100)  NULL,
    [Notes]              VARCHAR (MAX)  NULL,
    [Active]             BIT            NULL,
    [CreatedBy]          VARCHAR (50)   NULL,
    [CreatedDateTime]    DATETIME       NULL,
    [ModifiedBy]         VARCHAR (50)   NULL,
    [ModifiedDateTime]   DATETIME       NULL,
    [IsApproved1]        BIT            NULL,
    [Log1]               VARCHAR (1000) NULL,
    [IsApproved2]        BIT            NULL,
    [Log2]               VARCHAR (1000) NULL,
    [PortfolioCsv]       VARCHAR (1000) NULL,
    [TotalValidationReq] INT            NULL,
    [UserRole1]          VARCHAR (1000) NULL,
    [UserRole2]          VARCHAR (1000) NULL,
    [Lang]               VARCHAR (100)  NULL,
    [DocStatus]          INT            NULL,
    CONSTRAINT [PK_tbl_FundReport] PRIMARY KEY CLUSTERED ([VehicleReportID] ASC)
);

