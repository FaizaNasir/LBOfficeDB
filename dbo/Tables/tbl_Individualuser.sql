CREATE TABLE [dbo].[tbl_Individualuser] (
    [IndividualuserID] INT            IDENTITY (1, 1) NOT NULL,
    [UserName]         NVARCHAR (256) NULL,
    [IndividualID]     INT            NULL,
    CONSTRAINT [PK_tbl_Individualuser] PRIMARY KEY CLUSTERED ([IndividualuserID] ASC)
);

