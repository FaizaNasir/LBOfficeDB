CREATE PROC [dbo].[CleanMe]  
AS  
    BEGIN  
        DELETE FROM tbl_ContactIndividual  
		  
        WHERE IndividualID NOT IN  
        (  
            SELECT IndividualID  
            FROM tbl_Individualuser  
        );  
		TRUNCATE TABLE tbl_companyoffice
        TRUNCATE TABLE tbl_companycontacttype;  
        TRUNCATE TABLE tbl_Commitment;  
        TRUNCATE TABLE tbl_CommitmentFundShare;  
        TRUNCATE TABLE tbl_CommitmentTransfer;  
        TRUNCATE TABLE tbl_CommitmentTransferFundShare;  
        TRUNCATE TABLE tbl_Committee;  
        TRUNCATE TABLE tbl_CommitteeAttendies;  
        TRUNCATE TABLE tbl_CompanyBusinessUpdates;  
        TRUNCATE TABLE tbl_CompanyClients;  
        TRUNCATE TABLE tbl_CompanyCompetitors;  
        TRUNCATE TABLE tbl_CompanyContact;  
        TRUNCATE TABLE tbl_CompanyContactExternalAdvisors;  
        TRUNCATE TABLE tbl_CompanyIndividuals;  
        TRUNCATE TABLE tbl_CompanyOffice;  
        TRUNCATE TABLE tbl_CompanyRevenuesByGeography;  
        TRUNCATE TABLE tbl_CompanyRevenuesByProduct;  
        TRUNCATE TABLE tbl_CompanyRevenuesByService;  
        TRUNCATE TABLE tbl_ContactIndividualRM;  
        TRUNCATE TABLE tbl_DealFee;  
        TRUNCATE TABLE tbl_DealFundInvestors;  
        TRUNCATE TABLE tbl_DealFundNegativeInvestor;  
        TRUNCATE TABLE tbl_DealOptionalDetails;  
        TRUNCATE TABLE tbl_DealSecurity;  
        TRUNCATE TABLE tbl_DealSource;  
        TRUNCATE TABLE tbl_DealStageApproval;  
        TRUNCATE TABLE tbl_DealStatusDetails;  
        TRUNCATE TABLE tbl_DealTarget;  
        TRUNCATE TABLE tbl_DealTeam;  
        --TRUNCATE TABLE tbl_DealVehicle;  
        --TRUNCATE TABLE tbl_DealVehicleEligibility;  
        TRUNCATE TABLE tbl_DealWorkingTeam;  
        TRUNCATE TABLE tbl_Eligibility;  
        TRUNCATE TABLE tbl_EventAttendies;  
        TRUNCATE TABLE tbl_FundBusinessAreaAllocation;  
        TRUNCATE TABLE tbl_FundDistributionSequence;  
        TRUNCATE TABLE tbl_FundNav;  
        TRUNCATE TABLE tbl_FundNavDetails;  
        TRUNCATE TABLE tbl_FundReportingFrequency;  
        TRUNCATE TABLE tbl_FundShare;  
        TRUNCATE TABLE tbl_FundShareSequence;  
        TRUNCATE TABLE tbl_GeographicalRegion;  
        TRUNCATE TABLE tbl_HoldingDepartment;  
        TRUNCATE TABLE tbl_HoldingDepartments;  
        TRUNCATE TABLE tbl_IndividualComments;  
        --  
        TRUNCATE TABLE tbl_InterestAppetiteAssetTypePerferenceDetails;  
        TRUNCATE TABLE tbl_InterestAppetiteAssetTypePerferenceTransactionTypeDetail;  
        TRUNCATE TABLE tbl_InterestAppetiteAssetTypePreference;  
        TRUNCATE TABLE tbl_InterestAppetiteGeographyCountry;  
        TRUNCATE TABLE tbl_InterestAppetiteGeographyRegion;  
        TRUNCATE TABLE tbl_InterestAppetiteSectorPreference;  
        TRUNCATE TABLE tbl_InterestAppetiteSizePreference;  
        TRUNCATE TABLE tbl_InterestGeoghraphyCountryDetail;  
        TRUNCATE TABLE tbl_InterestGeoghraphyRegionDetail;  
        TRUNCATE TABLE tbl_InterestGeographyCountryTransactionTypeDetail;  
        TRUNCATE TABLE tbl_InterestGeographyRegionTransactionTypeDetail;  
        TRUNCATE TABLE tbl_InterestPortfolioDirectDeal;  
        TRUNCATE TABLE tbl_InterestPortfolioFund;  
        TRUNCATE TABLE tbl_InvestorBankSource;  
        TRUNCATE TABLE tbl_InvestorBusinessAreaPreferences;  
        TRUNCATE TABLE tbl_InvestorTypeDetail;  
        TRUNCATE TABLE tbl_LimitedPartner;  
        TRUNCATE TABLE tbl_MeetingLinkedTo;  
        TRUNCATE TABLE tbl_Meetings;  
        TRUNCATE TABLE tbl_PortfolioDealTeam;  
        TRUNCATE TABLE tbl_PortfolioDebtCovenant;  
        TRUNCATE TABLE tbl_PortfolioDebtSecurities;  
        TRUNCATE TABLE tbl_PortfolioFollowOnPayment;  
        TRUNCATE TABLE tbl_PortfolioGeneralOperation;  
        TRUNCATE TABLE tbl_PortfolioKeyFigure;  
        TRUNCATE TABLE tbl_PortfolioLegal;  
        TRUNCATE TABLE tbl_KeyfigureConfig;  
        TRUNCATE TABLE tbl_PortfolioLegalContactIndividual;  
        TRUNCATE TABLE tbl_PortfolioLegalEvent;  
        TRUNCATE TABLE tbl_PortfolioOptional;  
        TRUNCATE TABLE tbl_PortfolioSecurity;  
        TRUNCATE TABLE tbl_PortfolioShareholdingOperationsUnderConditions;  
        TRUNCATE TABLE tbl_PortfolioSimulationDetail;  
        TRUNCATE TABLE tbl_PortfolioValuationDetails;  
        TRUNCATE TABLE tbl_PortfolioVariableRate;  
        TRUNCATE TABLE tbl_PortfolioVehicle;  
        TRUNCATE TABLE tbl_SectorPerferenceDetails;  
        TRUNCATE TABLE tbl_SectorPerferenceTypeDetail;  
        TRUNCATE TABLE tbl_Shareholders;  
        --TRUNCATE TABLE tbl_SubVehicles;  
        TRUNCATE TABLE tbl_TaskLinked;  
        TRUNCATE TABLE tbl_Tasks;  
        TRUNCATE TABLE tbl_TeamType;  
        TRUNCATE TABLE tbl_VariableRate;  
        --TRUNCATE TABLE tbl_Vehicle_Strategy_Investment_Criteria;  
        --TRUNCATE TABLE tbl_VehicleActivity;  
        --TRUNCATE TABLE tbl_VehicleBankDetails;  
        --TRUNCATE TABLE tbl_VehicleCarriedIntreset;  
        --TRUNCATE TABLE tbl_VehicleCatchUp;  
        --TRUNCATE TABLE tbl_VehicleEligibility;  
        --TRUNCATE TABLE tbl_VehicleEligibilityRegion;  
        --TRUNCATE TABLE tbl_VehicleHurdleRate;  
        --TRUNCATE TABLE tbl_VehicleLegal;  
        --TRUNCATE TABLE tbl_VehicleManagement;  
        --TRUNCATE TABLE tbl_VehicleQuarterlyUpdates;  
        --TRUNCATE TABLE tbl_VehicleRatio;  
        --TRUNCATE TABLE tbl_VehicleShare;  
        --TRUNCATE TABLE tbl_VehicleShareDetail;  
        --TRUNCATE TABLE tbl_VehicleStrategyAssetType;  
        --TRUNCATE TABLE tbl_VehicleStrategyCountry;  
        --TRUNCATE TABLE tbl_VehicleStrategyDealType;  
        --TRUNCATE TABLE tbl_VehicleStrategyFinancialInstrument;  
        --TRUNCATE TABLE tbl_VehicleStrategyPortfolioSize;  
        --TRUNCATE TABLE tbl_VehicleStrategyRegion;  
        --TRUNCATE TABLE tbl_VehicleStrategySector;  
        --TRUNCATE TABLE tbl_VehicleTeam;  
        DELETE FROM tbl_PortfolioSimulation;  
        DELETE FROM tbl_PortfolioShareholdingOperations;  
        DELETE FROM tbl_Portfolio;  
        DELETE FROM tbl_Deals;  
        DELETE FROM tbl_PortfolioValuation;  
        --DELETE FROM tbl_Vehicle;  
        DELETE FROM aspnet_Membership  
        WHERE UserId IN  
        (  
            SELECT UserId  
            FROM aspnet_Users  
            WHERE UserName NOT IN('admin', 'administrator')  
        );  
        DELETE FROM aspnet_UsersInRoles  
        WHERE UserId IN  
        (  
            SELECT UserId  
            FROM aspnet_Users  
            WHERE UserName NOT IN('admin', 'administrator')  
        );  
        DELETE FROM aspnet_Users  
        WHERE UserName NOT IN('admin', 'administrator');  
        DELETE FROM aspnet_Roles  
        WHERE RoleName NOT IN('LbofficeAdmin');  
        TRUNCATE TABLE tbl_PortfolioEnterprise;  
        TRUNCATE TABLE tbl_city;  
        TRUNCATE TABLE tbl_OutlookMeeting;  
        TRUNCATE TABLE tbl_OutlookEmailLinkedTo;  
        TRUNCATE TABLE tbl_OutlookEmail;  
        --TRUNCATE TABLE tbl_VehicleClosing;  
        --TRUNCATE TABLE tbl_VehicleDocumentType;  
        TRUNCATE TABLE tbl_MultiCurrencyRate;  
        TRUNCATE TABLE tbl_LPTemplateConfigDetail;  
        TRUNCATE TABLE tbl_LPTemplateConfig;  
        --TRUNCATE TABLE tbl_VehicleNav;  
        TRUNCATE TABLE tbl_DistributionOperation;  
        TRUNCATE TABLE tbl_DistributionPortfolioCompany;  
        TRUNCATE TABLE tbl_LPEmailConfigDetail;  
        TRUNCATE TABLE tbl_CommitmentTransferFundShare;  
        TRUNCATE TABLE tbl_LPTemlateConfigStaticDocs;  
        TRUNCATE TABLE tbl_LPReport;  
        TRUNCATE TABLE tbl_LimitedPartnerDetail;  
        TRUNCATE TABLE tbl_LimitedPartner;  
        TRUNCATE TABLE tbl_FundShareSequence;  
        TRUNCATE TABLE tbl_FundShare;  
        TRUNCATE TABLE tbl_FundNavDetails;  
        TRUNCATE TABLE tbl_Distribution;  
        TRUNCATE TABLE tbl_CommitmentFundShare;  
        TRUNCATE TABLE tbl_FundNav;  
        TRUNCATE TABLE tbl_DistributionLimitedPartner;  
        TRUNCATE TABLE tbl_CommitmentTransfer;  
        TRUNCATE TABLE tbl_Commitment;  
        TRUNCATE TABLE tbl_CapitalCallShareDetail;  
        TRUNCATE TABLE tbl_LPEmailConfig;  
        --TRUNCATE TABLE tbl_VehicleNavDetails;  
        TRUNCATE TABLE tbl_LPEmailConfigDetail;  
        --TRUNCATE TABLE tbl_vehicleshare;  
        --TRUNCATE TABLE tbl_VehicleNavLimitedPartner;  
        --TRUNCATE TABLE tbl_VehicleShareDetail;  
        TRUNCATE TABLE FundExcelInputDetail;  
        TRUNCATE TABLE FundExcelOutput;  
        TRUNCATE TABLE FundExcelInputMaster;  
        TRUNCATE TABLE tbl_CapitalCall;  
        TRUNCATE TABLE tbl_CapitalCallLimitedPartner;  
        TRUNCATE TABLE tbl_CapitalCallOperation;  
        TRUNCATE TABLE tbl_CapitalCallPortfolioCompany;  
        TRUNCATE TABLE tbl_DealOfficePermission;  
        TRUNCATE TABLE tbl_DealStagePermission;  
        DELETE FROM tbl_BlockedPermission  
        WHERE UserRole NOT IN('LbofficeAdmin');  
        DELETE FROM tbl_BlockedGroupPermission  
        WHERE UserRole NOT IN('LbofficeAdmin');  
        DELETE FROM tbl_TabsPermission  
        WHERE UserRole NOT IN('LbofficeAdmin');  
    END;
