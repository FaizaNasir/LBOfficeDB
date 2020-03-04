CREATE TABLE [dbo].[tbl_UserLog] (
    [UserLogID] INT           IDENTITY (1, 1) NOT NULL,
    [UserName]  VARCHAR (100) NULL,
    [Login]     DATETIME      NULL,
    [Logout]    DATETIME      NULL,
    CONSTRAINT [PK_tbl_UserLog] PRIMARY KEY CLUSTERED ([UserLogID] ASC)
);

