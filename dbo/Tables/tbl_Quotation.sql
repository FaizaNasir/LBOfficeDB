CREATE TABLE [dbo].[tbl_Quotation] (
    [QuotationID]      INT           IDENTITY (1, 1) NOT NULL,
    [QuotationName]    VARCHAR (100) NULL,
    [Active]           BIT           NULL,
    [CreatedDateTime]  DATETIME      NULL,
    [ModifiedDateTime] DATETIME      NULL,
    [CreatedBy]        VARCHAR (100) NULL,
    [ModifiedBy]       VARCHAR (100) NULL,
    CONSTRAINT [PK_tbl_Quotation] PRIMARY KEY CLUSTERED ([QuotationID] ASC)
);

