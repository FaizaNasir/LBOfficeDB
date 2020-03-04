CREATE TABLE [dbo].[tbl_CommitteeType] (
    [CommitteeTypeID]    INT           NOT NULL,
    [CommitteeTypeTitle] VARCHAR (100) NULL,
    [CommitteeTypeDesc]  VARCHAR (100) NULL,
    [Active]             BIT           NULL,
    [CreatedDateTime]    DATETIME      NULL,
    CONSTRAINT [PK_tbl_CommitteeType] PRIMARY KEY CLUSTERED ([CommitteeTypeID] ASC)
);

