CREATE TABLE [dbo].[tbl_DealBusinessClients] (
    [DealBusinessClientsID] INT            IDENTITY (1, 1) NOT NULL,
    [ClientName]            NVARCHAR (50)  NULL,
    [Comments]              NVARCHAR (MAX) NULL,
    [DealID]                INT            NULL
);

