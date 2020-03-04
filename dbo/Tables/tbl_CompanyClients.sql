CREATE TABLE [dbo].[tbl_CompanyClients] (
    [CompanyClientsID] INT            IDENTITY (1, 1) NOT NULL,
    [ClientName]       NVARCHAR (50)  NULL,
    [Comments]         NVARCHAR (MAX) NULL,
    [CompanyID]        INT            NULL,
    CONSTRAINT [PK_DealTargetClients] PRIMARY KEY CLUSTERED ([CompanyClientsID] ASC)
);

