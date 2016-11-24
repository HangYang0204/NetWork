USE [BIDataWarehouse]
GO

/****** Object:  StoredProcedure [dbo].[usp_Organization]    Script Date: 24/11/2016 10:54:13 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[usp_Organization] 
	@pUserID varchar(20),
	@pLanguage as int,
	@pFiscalPeriod int,
	@pActiveOrgOnly varchar(4)
	AS 

SELECT 
	Case @pLanguage WHEN 1 Then ProductLineDescEN
					 WHEN 2 Then ProductLineDescFR
	  END as ProductLineDesc
	, ProductLineSortOrder
	,Case @pLanguage WHEN 1 THEN GeographicRegionDescEN
		       WHEN 2 THEN GeographicRegionDescFR
			END as GeographicRegionDesc
	,GeographicRegionSortOrder
	 ,Case @pLanguage WHEN 1 THEN CompanyDescEN
				WHEN 2 THEN CompanyDescFR
		 END as CompanyDesc
		 ,CompanyID
	,Case @pLanguage WHEN 1 THEN [RegionDescEN]
				WHEN 2 THEN [RegionDescFR]
		 END as RegionDesc
		,	Case @pLanguage WHEN 1 THEN MarketSegmentDescEN
			WHEN 2 THEN MarketSegmentDescFR
			END as MarketSegmentDesc 
		,MarketSegmentSortOrder
		,Case @pLanguage WHEN 1 THEN  SubMarketSegmentDescEN
			WHEN 2 THEN  SubMarketSegmentDescFR
				END as SubMarketSegmentDesc
		, SubMarketSegmentSortOrder
		,Case @pLanguage WHEN 1 THEN LocationDescEN
		             WHEN 2 THEN LocationDescFR
			END as LocationDesc
		,Case @pLanguage WHEN 1 THEN	BusinessUnitDescEN
			WHEN 2 THEN BusinessUnitDescFR
			END as BusinessUnitDesc
		,Case  WHEN (@pActiveOrgOnly = 'True') 
	AND (@pFiscalPeriod Between [GLStartPeriod] and [GLEndPeriod])
		THEN DO.OrgSkey
		 ELSE DO.OrgSkey
		END as OrgSkey
         ,Case  WHEN (@pActiveOrgOnly = 'True') 
	AND (@pFiscalPeriod Between [GLStartPeriod] and [GLEndPeriod])
		THEN DO.OrganizationID
			ELSE DO.OrganizationID
		 END as OrganizationID
           ,Case  WHEN (@pActiveOrgOnly = 'True') 
	   AND (@pFiscalPeriod Between [GLStartPeriod] and [GLEndPeriod])
		THEN DO.OrganizationDesc
		 ELSE DO.OrganizationDesc
		END as OrganizationDesc
          ,Case  WHEN (@pActiveOrgOnly = 'True') 
		AND (@pFiscalPeriod Between [GLStartPeriod] and [GLEndPeriod])
		 THEN DO.OrganizationID + ' - ' + DO.OrganizationDesc
		ELSE DO.OrganizationID + ' - ' + DO.OrganizationDesc
		END as OrganizationNumber_Name
FROM DimOrganization as DO
INNER JOIN [dbo].[DimOrgSecurity] as DOS on DO.OrgSkey = DOS.OrgSkey
WHERE [ADAccount] =	@pUserID
AND [RemovedFlag] = 'N'
AND OrganizationID <> '99-ZZ-ZZZ-ZZZ'
AND [ADAccount] = @pUserID

ORDER BY 	--Order by OrganizationID
 ProductLineSortOrder
,GeographicRegionSortOrder
,CompanyID
,LocationDesc
,MarketSegmentSortOrder
,SubMarketSegmentSortOrder
,BusinessUnitDesc
,OrganizationID



GO

