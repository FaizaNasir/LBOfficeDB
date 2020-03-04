CREATE TABLE [dbo].[tbl_HoldingDepartments] (
    [HoldingDepartmentID] INT      NOT NULL,
    [HoldingID]           INT      NULL,
    [DepartmentID]        INT      NULL,
    [Active]              BIT      NULL,
    [CreateDateTime]      DATETIME NULL,
    CONSTRAINT [PK_tbl_HoldingDepartments\] PRIMARY KEY CLUSTERED ([HoldingDepartmentID] ASC)
);

