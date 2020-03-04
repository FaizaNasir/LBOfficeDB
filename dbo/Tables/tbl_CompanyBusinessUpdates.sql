CREATE TABLE [dbo].[tbl_CompanyBusinessUpdates] (
    [CompanyBusinessID] INT            IDENTITY (1, 1) NOT NULL,
    [Date]              DATE           NULL,
    [Comments]          NVARCHAR (MAX) NULL,
    [Rate]              INT            NULL,
    [CompanyID]         INT            NULL,
    [Language]          VARCHAR (100)  NULL,
    CONSTRAINT [PK_tbl_DealTargetBusiness] PRIMARY KEY CLUSTERED ([CompanyBusinessID] ASC)
);

