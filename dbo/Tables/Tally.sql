CREATE TABLE [dbo].[Tally] (
    [ID] INT IDENTITY (1, 1) NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [PKC_Tally]
    ON [dbo].[Tally]([ID] ASC);

