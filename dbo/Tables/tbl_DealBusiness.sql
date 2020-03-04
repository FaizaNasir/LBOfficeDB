CREATE TABLE [dbo].[tbl_DealBusiness] (
    [DealBusinessID] INT            IDENTITY (1, 1) NOT NULL,
    [Date]           DATE           NULL,
    [Comments]       NVARCHAR (MAX) NULL,
    [Rate]           INT            NULL,
    [DealID]         INT            NULL
);

