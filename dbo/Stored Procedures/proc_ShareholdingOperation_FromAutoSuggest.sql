
/********************************************************************
** Name			    :	[proc_ShareholdingOperation_FromAutoSuggest]
** Author			    :	Faisal Ashraf
** Create Date		    :	20 Sep, 2015
** 
** Description / Page   :	Portfolio - Shareholding operation From auto suggest
**
**
********************************************************************
** Change History
**
**      Date		    Author		Description	
** --   --------	    ------		------------------------------------

********************************************************************/

CREATE PROCEDURE [dbo].[proc_ShareholdingOperation_FromAutoSuggest](@portfoliotargetcompanyid INT)
AS
    BEGIN
        SELECT '-1' ObjectID, 
               'Creation' ObjectName, 
               'New' Type, 
               '0' ModuleID
        UNION ALL
        SELECT S.ObjectID, 
               companyname ObjectName, 
               'Company' Type, 
               S.ModuleID
        FROM tbl_Shareholders S
             INNER JOIN tbl_companycontact cc ON S.ObjectID = cc.companycontactid
                                                 AND s.moduleid = 5
        WHERE S.TargetPortfolioID = @portfoliotargetcompanyid
        UNION ALL
        SELECT S.ObjectID, 
               v.Name ObjectName, 
               'Fund' Type, 
               S.ModuleID
        FROM tbl_Shareholders S
             INNER JOIN tbl_Vehicle v ON S.ObjectID = v.VehicleID
        WHERE S.TargetPortfolioID = @portfoliotargetcompanyid
        UNION ALL
        SELECT S.ObjectID, 
               ci.individuallastname + ' ' + ci.individualfirstname ObjectName, 
               'Individual' Type, 
               S.ModuleID
        FROM tbl_Shareholders S
             INNER JOIN tbl_contactindividual ci ON S.ObjectID = ci.IndividualID
        WHERE S.TargetPortfolioID = @portfoliotargetcompanyid;
    END;
