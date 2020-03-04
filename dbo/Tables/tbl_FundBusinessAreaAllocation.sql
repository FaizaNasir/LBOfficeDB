CREATE TABLE [dbo].[tbl_FundBusinessAreaAllocation] (
    [FundBusinessAreaID] INT      IDENTITY (1, 1) NOT NULL,
    [FundID]             INT      NULL,
    [BusinessAreaID]     INT      NULL,
    [AllocationRatio]    INT      NULL,
    [Active]             BIT      NULL,
    [CreatedDateTime]    DATETIME NULL,
    CONSTRAINT [PK_tbl_FundBusinessArea_1] PRIMARY KEY CLUSTERED ([FundBusinessAreaID] ASC)
);

