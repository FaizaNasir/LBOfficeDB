CREATE TABLE [dbo].[tbl_LimitedPartnerDetail] (
    [LimitedPartnerDetailID] INT             IDENTITY (1, 1) NOT NULL,
    [LimitedPartnerID]       INT             NULL,
    [ShareID]                INT             NULL,
    [Amount]                 DECIMAL (18, 6) NULL,
    [Active]                 BIT             NULL,
    [CreatedDateTime]        DATETIME        NULL,
    [ModifiedDateTime]       DATETIME        NULL,
    [CreatedBy]              VARCHAR (100)   NULL,
    [ModifiedBy]             VARCHAR (100)   NULL,
    CONSTRAINT [PK_tbl_LimitedPartnerDetail] PRIMARY KEY CLUSTERED ([LimitedPartnerDetailID] ASC)
);

