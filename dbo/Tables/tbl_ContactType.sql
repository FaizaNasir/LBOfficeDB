CREATE TABLE [dbo].[tbl_ContactType] (
    [ContactTypesID]         INT           IDENTITY (1, 1) NOT NULL,
    [ContactTypeName]        VARCHAR (100) NULL,
    [ContactTypeDescription] VARCHAR (100) NULL,
    [Active]                 BIT           CONSTRAINT [DF_tbl_ContactType_Active] DEFAULT ((1)) NULL,
    [CreatedDateTime]        DATETIME      CONSTRAINT [DF_tbl_ContactType_InsertDateTime] DEFAULT (getdate()) NULL,
    [OrderType]              INT           NULL,
    CONSTRAINT [PK_tbl_ContactTypes] PRIMARY KEY CLUSTERED ([ContactTypesID] ASC)
);

