
/********************************************************************
** Name			    :	proc_getKeyFigureSimulations
** Author			    :	Faisal Ashraf
** Create Date		    :	12 Dec, 2015
** 
** Description / Page   :	Portfolio - Capital table Get
**
**
********************************************************************
** Change History
**
**      Date		    Author		Description	
** --   --------	    ------		------------------------------------

********************************************************************/

--[proc_capitaltable_Values_GET] 1,574,28,3

CREATE PROCEDURE [dbo].[proc_capitaltable_Values_GET]
(@portfolioid       INT, 
 @targetportfolioid INT, 
 @objectid          INT, 
 @moduleid          INT
)
AS
    BEGIN
        DECLARE @nondiluted DECIMAL(18, 2);
        DECLARE @testTbl TABLE
        (ObjectID   INT, 
         ModuleID   INT, 
         Name       VARCHAR(MAX), 
         Number1    INT, 
         nondiluted DECIMAL(18, 2), 
         Number2    INT, 
         diluted    DECIMAL(18, 2), 
         Number3    INT, 
         voting     DECIMAL(18, 2), 
         IsTeam     BIT
        );
        INSERT INTO @testTbl
        (ObjectID, 
         ModuleID, 
         Name, 
         Number1, 
         nondiluted, 
         Number2, 
         diluted, 
         Number3, 
         voting, 
         IsTeam
        )
        EXEC [proc_capitaltable_GET] 
             '31 Dec, 2015', 
             @targetportfolioid, 
             @portfolioid;

        --set @nondiluted = (Select nondiluted from @testTbl
        --where ObjectID = @objectid
        --and  ModuleID = @moduleid)

        SELECT nondiluted
        FROM @testTbl
        WHERE ObjectID = @objectid
              AND ModuleID = @moduleid;
    END;
