CREATE TABLE [dbo].[tbl_InvestorBusinessAreaPreferences] (
    [InvestorBankBusinessAreaPrefrenceID] INT           IDENTITY (1, 1) NOT NULL,
    [InvestorID]                          INT           NULL,
    [InvestorType]                        VARCHAR (100) NULL,
    [BusinessAreaPrefrenceID]             INT           NULL,
    [AllocationRatio]                     INT           NULL,
    [Active]                              BIT           NULL,
    [CreateDateTime]                      DATETIME      NULL,
    CONSTRAINT [PK_tbl_BusinessAreaPrefrences] PRIMARY KEY CLUSTERED ([InvestorBankBusinessAreaPrefrenceID] ASC)
);

