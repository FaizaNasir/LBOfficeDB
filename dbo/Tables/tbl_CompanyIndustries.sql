CREATE TABLE [dbo].[tbl_CompanyIndustries] (
    [CompanyIndustryID]      INT           NOT NULL,
    [CompanyIndustryTitle]   VARCHAR (100) NULL,
    [CompanyIndustryDesc]    VARCHAR (100) NULL,
    [Active]                 BIT           NULL,
    [CreateDateTime]         DATETIME      NULL,
    [CompanyIndustryTitleFr] VARCHAR (500) NULL,
    CONSTRAINT [PK_tbl_CompanyIndustries] PRIMARY KEY CLUSTERED ([CompanyIndustryID] ASC)
);

