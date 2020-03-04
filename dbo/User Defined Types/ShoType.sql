CREATE TYPE [dbo].[ShoType] AS TABLE (
    [ShareholdingOperationID] INT             NULL,
    [PortfolioID]             INT             NULL,
    [Date]                    DATETIME        NULL,
    [Amount]                  DECIMAL (18, 2) NULL,
    [SecurityID]              INT             NULL,
    [Number]                  DECIMAL (18, 2) NULL,
    [FromID]                  INT             NULL,
    [ToID]                    INT             NULL,
    [FromTypeID]              INT             NULL,
    [ToTypeID]                INT             NULL,
    [NatureID]                INT             NULL);

