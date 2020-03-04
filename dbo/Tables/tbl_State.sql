CREATE TABLE [dbo].[tbl_State] (
    [StateID]        INT           IDENTITY (1, 1) NOT NULL,
    [StateTitle]     VARCHAR (100) NULL,
    [StateDesc]      VARCHAR (100) NULL,
    [Active]         BIT           NULL,
    [CreateDateTime] NCHAR (10)    NULL,
    [CountryID]      INT           NULL,
    CONSTRAINT [PK_tbl_State] PRIMARY KEY CLUSTERED ([StateID] ASC)
);

