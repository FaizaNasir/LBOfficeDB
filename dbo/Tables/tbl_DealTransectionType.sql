CREATE TABLE [dbo].[tbl_DealTransectionType] (
    [DealTransectionTypeID]   INT            IDENTITY (1, 1) NOT NULL,
    [DealTransectionTypeName] VARCHAR (1000) NULL,
    [Active]                  BIT            CONSTRAINT [DF_tbl_DealTransectionType_Active] DEFAULT ((1)) NULL,
    [CreatedDateTime]         DATETIME       NULL,
    [ModifiedDateTime]        DATETIME       NULL,
    [CreatedBy]               VARCHAR (100)  NULL,
    [ModifiedBy]              VARCHAR (100)  NULL,
    CONSTRAINT [PK_tbl_DealTransectionType] PRIMARY KEY CLUSTERED ([DealTransectionTypeID] ASC)
);

