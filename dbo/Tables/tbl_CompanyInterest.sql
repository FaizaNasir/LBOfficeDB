CREATE TABLE [dbo].[tbl_CompanyInterest] (
    [CompanyInterestID] INT             IDENTITY (1, 1) NOT NULL,
    [CompanyID]         INT             NULL,
    [Year]              DATETIME        NULL,
    [Notes]             VARCHAR (MAX)   NULL,
    [Rate]              DECIMAL (18, 6) NULL,
    [Type]              VARCHAR (100)   NULL,
    [Active]            BIT             CONSTRAINT [DF_tbl_CompanyInterest_Active] DEFAULT ((1)) NULL,
    [CreatedDateTime]   DATETIME        NULL,
    [ModifiedDateTime]  DATETIME        NULL,
    [CreatedBy]         VARCHAR (100)   NULL,
    [ModifiedBy]        VARCHAR (100)   NULL,
    CONSTRAINT [PK_tbl_CompanyInterest] PRIMARY KEY CLUSTERED ([CompanyInterestID] ASC)
);

