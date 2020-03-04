CREATE TABLE [dbo].[tbl_InnovativeCriteria] (
    [InnovativeCriteriaID]   INT            IDENTITY (1, 1) NOT NULL,
    [InnovativeCriteriaName] VARCHAR (100)  NULL,
    [Active]                 BIT            NULL,
    [CreatedDateTime]        DATETIME       NULL,
    [ModifiedDateTime]       DATETIME       NULL,
    [CreatedBy]              VARCHAR (1000) NULL,
    [ModifiedBy]             VARCHAR (1000) NULL,
    CONSTRAINT [PK_tbl_InnovativeCriteria] PRIMARY KEY CLUSTERED ([InnovativeCriteriaID] ASC)
);

