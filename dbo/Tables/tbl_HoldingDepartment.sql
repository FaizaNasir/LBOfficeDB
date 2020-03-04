CREATE TABLE [dbo].[tbl_HoldingDepartment] (
    [DepartmentID]   INT           NOT NULL,
    [DepartmentName] VARCHAR (100) NULL,
    [TeamID]         INT           NULL,
    [Active]         BIT           NULL,
    [CreateDateTime] DATETIME      NULL,
    CONSTRAINT [PK_tbl_HoldingDepartment] PRIMARY KEY CLUSTERED ([DepartmentID] ASC)
);

