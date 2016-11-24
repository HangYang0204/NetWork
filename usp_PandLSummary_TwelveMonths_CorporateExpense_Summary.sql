USE [BIDataWarehouse]
GO

/****** Object:  StoredProcedure [dbo].[usp_PandLSummary_TwelveMonths_CorporateExpense_Summary]    Script Date: 24/11/2016 10:54:42 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--/**
CREATE Procedure [dbo].[usp_PandLSummary_TwelveMonths_CorporateExpense_Summary]
	@pCurrency varchar(5),
	@pFiscalPeriod int,
	@pTemplate int,
	@pLanguage int,
	@pOrg varchar(max),
	@pGroup1Level varchar(20),
	@pGroup2Level varchar(20),
	@pGroup3Level varchar(20),
	@pSummaryDetail varchar(1)
	AS 
--	**/

Declare @FuncCurrency as Varchar(5);
Declare @ConsCurrency as Varchar(5);
Declare @ENLanguage as int;
Declare @FRLanguage as int;

/**
Declare @pCurrency as varchar(5);
declare	@pFiscalPeriod as int;
declare	@pTemplate as int;
declare	@pLanguage as int;
Declare @pOrg as Varchar(max);
DECLARE @pGroup1Level varchar(20);
DECLARE	@pGroup2Level varchar(20);
DECLARE	@pGroup3Level varchar(20);
DECLARE @pSummaryDetail varchar(1);

**/
SET @FuncCurrency = 'FUNC';
SET @ConsCurrency = 'CONS';
SET @ENLanguage = 1;
SET @FRLanguage = 2;

/**
SET @pFiscalPeriod = 201605;
Set @pTemplate = 110;
SET @pLanguage = 1;
SET @pCurrency = 'FUNC';
SET @pOrg = '452,662,453,387';
SET @pCurrency = 'CONS';
SET @pGroup1Level = 'Z'		--'A'
SET @pGroup2Level =	'Z';		--'I';
SET @pGroup3Level =	'Z';		--'C';
SET @pSummaryDetail = 'S';
**/


if @pSummaryDetail = 'S' 
BEGIN

WITH ProfitandLossCTE (TemplateID,BusinessUnitID,OrgSkey, GroupID ,GroupDesc
			,Group1Level,Group2Level,Group3Level,Group1LevelID,Group2LevelID,Group3LevelID, [HeaderLine],[ShowDetail],[InsertSkipLineBefore],[SkipLine]
			,[IsMarkup],[IsNetRevenues],[IsDirectLabor],[IsFringeBenefitsPct],[IsFringeBenefits]
			,[IsManagementSalaries],[IsMarketingSalaries],[IsTrainingSalaries],[IsEBGEPct],[IsEBGE]
			,[IsEBREPct],[IsEBRE],[IsEBITDAPct],[IsEBITDA] ,[IsCalculatedUtilizationPct],SortOrder,FiscalPeriodNumber
			,[Current Month Amount],[LY Current Month Amount]
			,[Current Month Budget Amount],[YTD Amount],[LY YTD Amount]
			,[Current Month Forecast 1 Amount],[Current Month Forecast 2 Amount],[Current Month Forecast 3 Amount]
			,[YTD Budget Amount],[LY YTD Budget Amount]
			,[Current Year Budget Amount]
			,[YTD Forecast 1 Amount],[YTD Forecast 2 Amount],[YTD Forecast 3 Amount]
			,[QTD Amount],[LY QTD Amount],[QTD Budget Amount]
			,[QTD Forecast 1 Amount],[QTD Forecast 2 Amount],[QTD Forecast 3 Amount]
			,[Period 1 Actual Amount],[Period 2 Actual Amount],[Period 3 Actual Amount],[Period 4 Actual Amount]
			,[Period 5 Actual Amount],[Period 6 Actual Amount],[Period 7 Actual Amount],[Period 8 Actual Amount]
			,[Period 9 Actual Amount],[Period 10 Actual Amount],[Period 11 Actual Amount],[Period 12 Actual Amount]
			,[Period 1 Budget Amount],[Period 2 Budget Amount],[Period 3 Budget Amount],[Period 4 Budget Amount]
			,[Period 5 Budget Amount],[Period 6 Budget Amount],[Period 7 Budget Amount],[Period 8 Budget Amount]
			,[Period 9 Budget Amount],[Period 10 Budget Amount],[Period 11 Budget Amount],[Period 12 Budget Amount]
			,[Period 1 Forecast 1 Amount],[Period 2 Forecast 1 Amount],[Period 3 Forecast 1 Amount],[Period 4 Forecast 1 Amount]
			,[Period 5 Forecast 1 Amount],[Period 6 Forecast 1 Amount],[Period 7 Forecast 1 Amount],[Period 8 Forecast 1 Amount]
			,[Period 9 Forecast 1 Amount],[Period 10 Forecast 1 Amount],[Period 11 Forecast 1 Amount],[Period 12 Forecast 1 Amount]
			,[Period 1 Forecast 2 Amount],[Period 2 Forecast 2 Amount],[Period 3 Forecast 2 Amount],[Period 4 Forecast 2 Amount]
			,[Period 5 Forecast 2 Amount],[Period 6 Forecast 2 Amount],[Period 7 Forecast 2 Amount],[Period 8 Forecast 2 Amount]
			,[Period 9 Forecast 2 Amount],[Period 10 Forecast 2 Amount],[Period 11 Forecast 2 Amount],[Period 12 Forecast 2 Amount]
			,[Period 1 Forecast 3 Amount],[Period 2 Forecast 3 Amount],[Period 3 Forecast 3 Amount],[Period 4 Forecast 3 Amount]
			,[Period 5 Forecast 3 Amount],[Period 6 Forecast 3 Amount],[Period 7 Forecast 3 Amount],[Period 8 Forecast 3 Amount]
			,[Period 9 Forecast 3 Amount],[Period 10 Forecast 3 Amount],[Period 11 Forecast 3 Amount],[Period 12 Forecast 3 Amount]			
			
			)
		AS
		(

			SELECT		CYPL.TemplateID
					,CYPL.BusinessUnitID
					,CYPL.OrgSkey
					,CYPL.GroupId
					,CYPL.GroupDesc	
					,Case @pLanguage When @ENLanguage THEN	Case @pGroup1Level	WHEN 'A' THEN	[TerritoryDescEN]
												WHEN 'I' THEN	[ProductLineDescEN]
												WHEN 'B' THEN	[GeographicRegionDescEN]
												WHEN 'C' THEN	[CompanyDescEN]
												WHEN 'D' THEN	[RegionDescEN]
												WHEN 'E' THEN	[MarketSegmentDescEN]
												WHEN 'F' THEN	[SubMarketSegmentDescEN]
												WHEN 'G' THEN	[LocationDescEN]
												WHEN 'H' THEN	[BusinessUnitDescEN]
												WHEN 'Z' THEN	'None'
												END
									 WHEN @FRLanguage THEN CASE  @pGroup1Level	WHEN 'A' THEN	[TerritoryDescFR]
												WHEN 'I' THEN	[ProductLineDescFR]
												WHEN 'B' THEN	[GeographicRegionDescFR]
												WHEN 'C' THEN	[CompanyDescFR]
												WHEN 'D' THEN	[RegionDescFR]
												WHEN 'E' THEN	[MarketSegmentDescFR]
												WHEN 'F' THEN	[SubMarketSegmentDescFR]
												WHEN 'G' THEN	[LocationDescFR]
												WHEN 'H' THEN	[BusinessUnitDescFR]
												WHEN 'Z' THEN	'None'
												END
							END as Group1Level
					,Case @pLanguage When @ENLanguage THEN	Case @pGroup2Level	WHEN 'A' THEN	[TerritoryDescEN]
												WHEN 'I' THEN	[ProductLineDescEN]
												WHEN 'B' THEN	[GeographicRegionDescEN]
												WHEN 'C' THEN	[CompanyDescEN]
												WHEN 'D' THEN	[RegionDescEN]
												WHEN 'E' THEN	[MarketSegmentDescEN]
												WHEN 'F' THEN	[SubMarketSegmentDescEN]
												WHEN 'G' THEN	[LocationDescEN]
												WHEN 'H' THEN	[BusinessUnitDescEN]
												WHEN 'Z' THEN	'None'
												END
									 WHEN @FRLanguage THEN CASE  @pGroup2Level	WHEN 'A' THEN	[TerritoryDescFR]
												WHEN 'I' THEN	[ProductLineDescFR]
												WHEN 'B' THEN	[GeographicRegionDescFR]
												WHEN 'C' THEN	[CompanyDescFR]
												WHEN 'D' THEN	[RegionDescFR]
												WHEN 'E' THEN	[MarketSegmentDescFR]
												WHEN 'F' THEN	[SubMarketSegmentDescFR]
												WHEN 'G' THEN	[LocationDescFR]
												WHEN 'H' THEN	[BusinessUnitDescFR]
												WHEN 'Z' THEN	'None'
												END
							END as Group2Level
					,Case @pLanguage When @ENLanguage THEN	Case @pGroup3Level	WHEN 'A' THEN	[TerritoryDescEN]
												WHEN 'I' THEN	[ProductLineDescEN]
												WHEN 'B' THEN	[GeographicRegionDescEN]
												WHEN 'C' THEN	[CompanyDescEN]
												WHEN 'D' THEN	[RegionDescEN]
												WHEN 'E' THEN	[MarketSegmentDescEN]
												WHEN 'F' THEN	[SubMarketSegmentDescEN]
												WHEN 'G' THEN	[LocationDescEN]
												WHEN 'H' THEN	[BusinessUnitDescEN]
												WHEN 'Z' THEN	'None'
												END
									 WHEN @FRLanguage THEN CASE  @pGroup3Level	WHEN 'A' THEN	[TerritoryDescFR]
												WHEN 'I' THEN	[ProductLineDescFR]
												WHEN 'B' THEN	[GeographicRegionDescFR]
												WHEN 'C' THEN	[CompanyDescFR]
												WHEN 'D' THEN	[RegionDescFR]
												WHEN 'E' THEN	[MarketSegmentDescFR]
												WHEN 'F' THEN	[SubMarketSegmentDescFR]
												WHEN 'G' THEN	[LocationDescFR]
												WHEN 'H' THEN	[BusinessUnitDescFR]
												WHEN 'Z' THEN	'None'
												END
							END as Group3Level
					,Case @pGroup1Level			WHEN 'I' THEN	[ProductLineID]
												WHEN 'B' THEN	[GeographicRegionID]
												WHEN 'C' THEN	[CompanyID]
												WHEN 'D' THEN	[RegionID]
												WHEN 'E' THEN	[MarketSegmentID]
												WHEN 'F' THEN	[SubMarketSegmentID]
												WHEN 'G' THEN	[LocationID]
												WHEN 'H' THEN	CYPL.[BusinessUnitID]
												WHEN 'Z' THEN	'None'
												
							END as Group1LevelID
					,Case @pGroup2Level			WHEN 'I' THEN	[ProductLineID]
												WHEN 'B' THEN	[GeographicRegionID]
												WHEN 'C' THEN	[CompanyID]
												WHEN 'D' THEN	[RegionID]
												WHEN 'E' THEN	[MarketSegmentID]
												WHEN 'F' THEN	[SubMarketSegmentID]
												WHEN 'G' THEN	[LocationID]
												WHEN 'H' THEN	CYPL.[BusinessUnitID]
												WHEN 'Z' THEN	'None'
												
							END as Group2LevelID
					,Case @pGroup3Level			WHEN 'I' THEN	[ProductLineID]
												WHEN 'B' THEN	[GeographicRegionID]
												WHEN 'C' THEN	[CompanyID]
												WHEN 'D' THEN	[RegionID]
												WHEN 'E' THEN	[MarketSegmentID]
												WHEN 'F' THEN	[SubMarketSegmentID]
												WHEN 'G' THEN	[LocationID]
												WHEN 'H' THEN	CYPL.[BusinessUnitID]
												WHEN 'Z' THEN	'None'
												
							END as Group3LevelID
					,[HeaderLine]
					,[ShowDetail]
					,[InsertSkipLineBefore]
					,[SkipLine]
					,[IsMarkup]
					,[IsNetRevenues]
					,[IsDirectLabor]
					,[IsFringeBenefitsPct]
					,[IsFringeBenefits]
					,[IsManagementSalaries]
					,[IsMarketingSalaries]
					,[IsTrainingSalaries]
					,[IsEBGEPct]
					,[IsEBGE]
					,[IsEBREPct]
					,[IsEBRE]
					,[IsEBITDAPct]
					,[IsEBITDA]
					,[IsCalculatedUtilizationPct]
					,SortOrder
					,CYPL.FiscalPeriodNumber
					,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Current Month Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Current Month Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Current Month Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Current Month Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Current Month Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Current Month Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Current Month Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Current Month Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Current Month Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Current Month Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Current Month Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Current Month Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Current Month Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Current Month Amount] Else 0.000000 End
							  Else [Current Month Amount]
							End),0.000000) AS [Current Month Amount]
					,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [LY Current Month Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [LY Current Month Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [LY Current Month Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [LY Current Month Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [LY Current Month Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [LY Current Month Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [LY Current Month Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [LY Current Month Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [LY Current Month Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [LY Current Month Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [LY Current Month Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [LY Current Month Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [LY Current Month Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [LY Current Month Amount] Else 0.000000 End
							  Else [LY Current Month Amount]
							End),0.000000) AS [LY Current Month Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Current Month Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Current Month Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Current Month Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Current Month Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Current Month Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Current Month Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Current Month Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Current Month Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Current Month Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Current Month Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Current Month Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Current Month Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Current Month Budget Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Current Month Budget Amount] Else 0.000000 End
							  Else [Current Month Budget Amount]
							End),0.000000) AS [Current Month Budget Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [YTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [YTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [YTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [YTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [YTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [YTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [YTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [YTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [YTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [YTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [YTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [YTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [YTD Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [YTD Amount] Else 0.000000 End
							  Else [YTD Amount]
							End),0.000000) AS [YTD Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [LY YTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [LY YTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [LY YTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [LY YTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [LY YTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [LY YTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [LY YTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [LY YTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [LY YTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [LY YTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [LY YTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [LY YTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [LY YTD Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [LY YTD Amount] Else 0.000000 End
							  Else [LY YTD Amount]
							End ),0.000000) AS [LY YTD Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Current Month Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Current Month Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Current Month Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Current Month Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Current Month Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Current Month Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Current Month Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Current Month Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Current Month Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Current Month Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Current Month Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Current Month Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Current Month Forecast 1 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Current Month Forecast 1 Amount] Else 0.000000 End
							  Else [Current Month Forecast 1 Amount]
							End),0.000000) AS [Current Month Forecast 1 Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Current Month Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Current Month Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Current Month Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Current Month Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Current Month Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Current Month Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Current Month Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Current Month Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Current Month Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Current Month Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Current Month Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Current Month Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Current Month Forecast 2 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Current Month Forecast 2 Amount] Else 0.000000 End
							  Else [Current Month Forecast 2 Amount]
							End),0.000000) AS [Current Month Forecast 2 Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Current Month Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Current Month Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Current Month Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Current Month Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Current Month Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Current Month Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Current Month Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Current Month Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Current Month Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Current Month Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Current Month Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Current Month Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Current Month Forecast 3 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Current Month Forecast 3 Amount] Else 0.000000 End
							  Else [Current Month Forecast 3 Amount]
							End),0.000000) AS [Current Month Forecast 3 Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [YTD Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [YTD Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [YTD Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [YTD Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [YTD Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [YTD Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [YTD Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [YTD Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [YTD Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [YTD Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [YTD Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [YTD Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [YTD Budget Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [YTD Budget Amount] Else 0.000000 End
							  Else [YTD Budget Amount]
							End),0.000000) AS [YTD Budget Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [LY YTD Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [LY YTD Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [LY YTD Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [LY YTD Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [LY YTD Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [LY YTD Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [LY YTD Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [LY YTD Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [LY YTD Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [LY YTD Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [LY YTD Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [LY YTD Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [LY YTD Budget Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [LY YTD Budget Amount] Else 0.000000 End
							  Else [LY YTD Budget Amount]
							End ),0.000000) As [LY YTD Budget Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Current Year Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Current Year Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Current Year Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Current Year Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Current Year Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Current Year Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Current Year Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Current Year Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Current Year Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Current Year Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Current Year Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Current Year Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Current Year Budget Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Current Year Budget Amount] Else 0.000000 End
							  Else [Current Year Budget Amount]
							End),0.000000) AS [Current Year Budget Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [YTD Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [YTD Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [YTD Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [YTD Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [YTD Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [YTD Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [YTD Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [YTD Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [YTD Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [YTD Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [YTD Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [YTD Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [YTD Forecast 1 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [YTD Forecast 1 Amount] Else 0.000000 End
							  Else [YTD Forecast 1 Amount]
							End),0.000000) AS [YTD Forecast 1 Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [YTD Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [YTD Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [YTD Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [YTD Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [YTD Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [YTD Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [YTD Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [YTD Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [YTD Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [YTD Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [YTD Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [YTD Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [YTD Forecast 2 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [YTD Forecast 2 Amount] Else 0.000000 End
							  Else [YTD Forecast 2 Amount]
							End),0.000000) AS [YTD Forecast 2 Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [YTD Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [YTD Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [YTD Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [YTD Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [YTD Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [YTD Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [YTD Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [YTD Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [YTD Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [YTD Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [YTD Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [YTD Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [YTD Forecast 3 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [YTD Forecast 3 Amount] Else 0.000000 End
							  Else [YTD Forecast 3 Amount]
							End),0.000000) AS [YTD Forecast 3 Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [QTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [QTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [QTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [QTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [QTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [QTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [QTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [QTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [QTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [QTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [QTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [QTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [QTD Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [QTD Amount] Else 0.000000 End
							  Else [QTD Amount]
							End),0.000000) AS [QTD Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [LY QTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [LY QTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [LY QTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [LY QTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [LY QTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [LY QTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [LY QTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [LY QTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [LY QTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [LY QTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [LY QTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [LY QTD Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [LY QTD Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [LY QTD Amount] Else 0.000000 End
							  Else [LY QTD Amount]
							End),0.000000) AS [LY QTD Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [QTD Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [QTD Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [QTD Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [QTD Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [QTD Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [QTD Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [QTD Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [QTD Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [QTD Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [QTD Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [QTD Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [QTD Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [QTD Budget Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [QTD Budget Amount] Else 0.000000 End
							  Else [QTD Budget Amount]
							End),0.000000) AS [QTD Budget Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [QTD Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [QTD Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [QTD Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [QTD Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [QTD Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [QTD Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [QTD Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [QTD Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [QTD Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [QTD Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [QTD Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [QTD Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [QTD Forecast 1 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [QTD Forecast 1 Amount] Else 0.000000 End
							  Else [QTD Forecast 1 Amount]
							End),0.000000) AS [QTD Forecast 1 Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [QTD Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [QTD Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [QTD Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [QTD Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [QTD Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [QTD Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [QTD Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [QTD Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [QTD Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [QTD Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [QTD Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [QTD Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [QTD Forecast 2 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [QTD Forecast 2 Amount] Else 0.000000 End
							  Else [QTD Forecast 2 Amount]
							End),0.000000) AS [QTD Forecast 2 Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [QTD Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [QTD Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [QTD Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [QTD Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [QTD Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [QTD Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [QTD Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [QTD Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [QTD Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [QTD Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [QTD Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [QTD Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [QTD Forecast 3 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [QTD Forecast 3 Amount] Else 0.000000 End
							  Else [QTD Forecast 3 Amount]
							End),0.000000) AS [QTD Forecast 3 Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 1 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 1 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 1 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 1 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 1 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 1 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 1 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 1 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 1 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 1 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 1 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 1 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 1 Actual Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 1 Actual Amount] Else 0.000000 End
							  Else [Period 1 Actual Amount]
							End),0.000000) AS [Period 1 Actual Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 2 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 2 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 2 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 2 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 2 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 2 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 2 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 2 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 2 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 2 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 2 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 2 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 2 Actual Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 2 Actual Amount] Else 0.000000 End
							  Else [Period 2 Actual Amount]
							End),0.000000) AS [Period 2 Actual Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 3 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 3 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 3 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 3 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 3 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 3 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 3 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 3 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 3 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 3 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 3 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 3 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 3 Actual Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 3 Actual Amount] Else 0.000000 End
							  Else [Period 3 Actual Amount]
							End),0.000000) AS [Period 3 Actual Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 4 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 4 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 4 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 4 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 4 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 4 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 4 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 4 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 4 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 4 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 4 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 4 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 4 Actual Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 4 Actual Amount] Else 0.000000 End
							  Else [Period 4 Actual Amount]
							End),0.000000) AS [Period 4 Actual Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 5 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 5 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 5 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 5 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 5 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 5 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 5 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 5 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 5 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 5 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 5 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 5 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 5 Actual Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 5 Actual Amount] Else 0.000000 End
							  Else [Period 5 Actual Amount]
							End),0.000000) AS [Period 5 Actual Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 6 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 6 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 6 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 6 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 6 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 6 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 6 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 6 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 6 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 6 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 6 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 6 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 6 Actual Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 6 Actual Amount] Else 0.000000 End
							  Else [Period 6 Actual Amount]
							End),0.000000) AS [Period 6 Actual Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 7 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 7 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 7 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 7 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 7 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 7 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 7 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 7 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 7 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 7 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 7 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 7 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 7 Actual Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 7 Actual Amount] Else 0.000000 End
							  Else [Period 7 Actual Amount]
							End),0.000000) AS [Period 7 Actual Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 8 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 8 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 8 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 8 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 8 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 8 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 8 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 8 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 8 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 8 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 8 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 8 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 8 Actual Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 8 Actual Amount] Else 0.000000 End
							  Else [Period 8 Actual Amount]
							End),0.000000) as [Period 8 Actual Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 9 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 9 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 9 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 9 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 9 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 9 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 9 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 9 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 9 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 9 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 9 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 9 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 9 Actual Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 9 Actual Amount] Else 0.000000 End
							  Else [Period 9 Actual Amount]
							End),0.000000) as [Period 9 Actual Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 10 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 10 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 10 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 10 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 10 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 10 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 10 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 10 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 10 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 10 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 10 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 10 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 10 Actual Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 10 Actual Amount] Else 0.000000 End
							  Else [Period 10 Actual Amount]
							End),0.000000) AS [Period 10 Actual Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 11 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 11 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 11 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 11 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 11 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 11 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 11 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 11 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 11 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 11 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 11 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 11 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 11 Actual Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 11 Actual Amount] Else 0.000000 End
							  Else [Period 11 Actual Amount]
							End),0.000000) AS [Period 11 Actual Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 12 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 12 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 12 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 12 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 12 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 12 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 12 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 12 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 12 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 12 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 12 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 12 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 12 Actual Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 12 Actual Amount] Else 0.000000 End
							  Else [Period 12 Actual Amount]
							End),0.000000) AS [Period 12 Actual Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 1 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 1 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 1 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 1 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 1 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 1 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 1 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 1 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 1 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 1 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 1 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 1 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 1 Budget Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 1 Budget Amount] Else 0.000000 End
							  Else [Period 1 Budget Amount]
							End),0.000000) AS [Period 1 Budget Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 2 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 2 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 2 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 2 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 2 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 2 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 2 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 2 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 2 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 2 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 2 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 2 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 2 Budget Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 2 Budget Amount] Else 0.000000 End
							  Else [Period 2 Budget Amount]
							End),0.000000) AS [Period 2 Budget Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 3 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 3 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 3 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 3 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 3 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 3 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 3 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 3 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 3 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 3 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 3 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 3 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 3 Budget Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 3 Budget Amount] Else 0.000000 End
							  Else [Period 3 Budget Amount]
							End),0.000000) AS [Period 3 Budget Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 4 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 4 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 4 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 4 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 4 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 4 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 4 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 4 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 4 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 4 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 4 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 4 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 4 Budget Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 4 Budget Amount] Else 0.000000 End
							  Else [Period 4 Budget Amount]
							End),0.000000) as [Period 4 Budget Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 5 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 5 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 5 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 5 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 5 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 5 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 5 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 5 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 5 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 5 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 5 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 5 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 5 Budget Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 5 Budget Amount] Else 0.000000 End
							  Else [Period 5 Budget Amount]
							End),0.000000) AS [Period 5 Budget Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 6 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 6 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 6 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 6 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 6 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 6 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 6 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 6 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 6 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 6 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 6 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 6 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 6 Budget Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 6 Budget Amount] Else 0.000000 End
							  Else [Period 6 Budget Amount]
							End),0.000000) AS [Period 6 Budget Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 7 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 7 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 7 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 7 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 7 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 7 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 7 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 7 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 7 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 7 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 7 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 7 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 7 Budget Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 7 Budget Amount] Else 0.000000 End
							  Else [Period 7 Budget Amount]
							End),0.000000) AS [Period 7 Budget Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 8 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 8 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 8 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 8 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 8 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 8 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 8 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 8 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 8 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 8 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 8 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 8 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 8 Budget Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 8 Budget Amount] Else 0.000000 End
							  Else [Period 8 Budget Amount]
							End),0.000000) AS [Period 8 Budget Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 9 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 9 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 9 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 9 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 9 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 9 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 9 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 9 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 9 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 9 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 9 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 9 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 9 Budget Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 9 Budget Amount] Else 0.000000 End
							  Else [Period 9 Budget Amount]
							End),0.000000) AS [Period 9 Budget Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 10 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 10 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 10 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 10 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 10 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 10 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 10 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 10 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 10 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 10 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 10 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 10 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 10 Budget Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 10 Budget Amount] Else 0.000000 End
							  Else [Period 10 Budget Amount]
							End),0.000000) AS [Period 10 Budget Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 11 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 11 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 11 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 11 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 11 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 11 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 11 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 11 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 11 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 11 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 11 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 11 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 11 Budget Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 11 Budget Amount] Else 0.000000 End
							  Else [Period 11 Budget Amount]
							End),0.000000) AS [Period 11 Budget Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 12 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 12 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 12 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 12 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 12 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 12 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 12 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 12 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 12 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 12 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 12 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 12 Budget Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 12 Budget Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 12 Budget Amount] Else 0.000000 End
							  Else [Period 12 Budget Amount]
							End),0.000000) AS [Period 12 Budget Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 1 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 1 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 1 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 1 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 1 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 1 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 1 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 1 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 1 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 1 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 1 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 1 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 1 Forecast 1 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 1 Forecast 1 Amount] Else 0.000000 End
							  Else [Period 1 Forecast 1 Amount]
							End),0.000000) AS [Period 1 Forecast 1 Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 2 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 2 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 2 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 2 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 2 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 2 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 2 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 2 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 2 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 2 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 2 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 2 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 2 Forecast 1 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 2 Forecast 1 Amount] Else 0.000000 End
							  Else [Period 2 Forecast 1 Amount]
							End),0.000000) AS [Period 2 Forecast 1 Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 3 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 3 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 3 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 3 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 3 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 3 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 3 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 3 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 3 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 3 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 3 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 3 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 3 Forecast 1 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 3 Forecast 1 Amount] Else 0.000000 End
							  Else [Period 3 Forecast 1 Amount]
							End),0.000000) AS [Period 3 Forecast 1 Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 4 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 4 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 4 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 4 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 4 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 4 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 4 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 4 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 4 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 4 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 4 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 4 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 4 Forecast 1 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 4 Forecast 1 Amount] Else 0.000000 End
							  Else [Period 4 Forecast 1 Amount]
							End),0.000000) AS [Period 4 Forecast 1 Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 5 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 5 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 5 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 5 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 5 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 5 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 5 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 5 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 5 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 5 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 5 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 5 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 5 Forecast 1 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 5 Forecast 1 Amount] Else 0.000000 End
							  Else [Period 5 Forecast 1 Amount]
							End),0.000000) AS [Period 5 Forecast 1 Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 6 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 6 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 6 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 6 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 6 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 6 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 6 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 6 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 6 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 6 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 6 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 6 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 6 Forecast 1 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 6 Forecast 1 Amount] Else 0.000000 End
							  Else [Period 6 Forecast 1 Amount]
							End),0.000000) AS [Period 6 Forecast 1 Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 7 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 7 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 7 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 7 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 7 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 7 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 7 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 7 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 7 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 7 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 7 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 7 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 7 Forecast 1 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 7 Forecast 1 Amount] Else 0.000000 End
							  Else [Period 7 Forecast 1 Amount]
							End),0.000000) AS [Period 7 Forecast 1 Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 8 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 8 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 8 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 8 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 8 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 8 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 8 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 8 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 8 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 8 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 8 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 8 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 8 Forecast 1 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 8 Forecast 1 Amount] Else 0.000000 End
							  Else [Period 8 Forecast 1 Amount]
							End),0.000000) AS [Period 8 Forecast 1 Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 9 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 9 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 9 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 9 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 9 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 9 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 9 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 9 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 9 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 9 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 9 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 9 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 9 Forecast 1 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 9 Forecast 1 Amount] Else 0.000000 End
							  Else [Period 9 Forecast 1 Amount]
							End),0.000000) AS [Period 9 Forecast 1 Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 10 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 10 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 10 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 10 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 10 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 10 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 10 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 10 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 10 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 10 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 10 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 10 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 10 Forecast 1 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 10 Forecast 1 Amount] Else 0.000000 End
							  Else [Period 10 Forecast 1 Amount]
							End),0.000000) AS [Period 10 Forecast 1 Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 11 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 11 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 11 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 11 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 11 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 11 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 11 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 11 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 11 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 11 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 11 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 11 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 11 Forecast 1 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 11 Forecast 1 Amount] Else 0.000000 End
							  Else [Period 11 Forecast 1 Amount]
							End),0.000000) AS [Period 11 Forecast 1 Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 12 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 12 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 12 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 12 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 12 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 12 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 12 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 12 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 12 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 12 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 12 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 12 Forecast 1 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 12 Forecast 1 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 12 Forecast 1 Amount] Else 0.000000 End
							  Else [Period 12 Forecast 1 Amount]
							End),0.000000) AS [Period 12 Forecast 1 Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 1 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 1 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 1 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 1 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 1 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 1 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 1 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 1 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 1 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 1 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 1 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 1 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 1 Forecast 2 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 1 Forecast 2 Amount] Else 0.000000 End
							  Else [Period 1 Forecast 2 Amount]
							End),0.000000) AS [Period 1 Forecast 2 Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 2 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 2 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 2 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 2 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 2 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 2 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 2 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 2 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 2 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 2 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 2 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 2 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 2 Forecast 2 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 2 Forecast 2 Amount] Else 0.000000 End
							  Else [Period 2 Forecast 2 Amount]
							  END),0.000000) AS [Period 2 Forecast 2 Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 3 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 3 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 3 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 3 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 3 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 3 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 3 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 3 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 3 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 3 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 3 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 3 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 3 Forecast 2 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 3 Forecast 2 Amount] Else 0.000000 End
							  Else [Period 3 Forecast 2 Amount]
							End),0.000000) AS [Period 3 Forecast 2 Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 4 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 4 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 4 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 4 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 4 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 4 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 4 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 4 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 4 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 4 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 4 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 4 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 4 Forecast 2 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 4 Forecast 2 Amount] Else 0.000000 End
							  Else [Period 4 Forecast 2 Amount]
							End),0.000000) AS [Period 4 Forecast 2 Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 5 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 5 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 5 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 5 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 5 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 5 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 5 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 5 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 5 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 5 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 5 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 5 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 5 Forecast 2 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 5 Forecast 2 Amount] Else 0.000000 End
							  Else [Period 5 Forecast 2 Amount]
							End),0.000000) AS [Period 5 Forecast 2 Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 6 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 6 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 6 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 6 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 6 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 6 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 6 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 6 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 6 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 6 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 6 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 6 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 6 Forecast 2 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 6 Forecast 2 Amount] Else 0.000000 End
							  Else [Period 6 Forecast 2 Amount]
							End),0.000000) AS [Period 6 Forecast 2 Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 7 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 7 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 7 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 7 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 7 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 7 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 7 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 7 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 7 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 7 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 7 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 7 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 7 Forecast 2 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 7 Forecast 2 Amount] Else 0.000000 End
							  Else [Period 7 Forecast 2 Amount]
							End),0.000000) AS [Period 7 Forecast 2 Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 8 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 8 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 8 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 8 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 8 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 8 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 8 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 8 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 8 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 8 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 8 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 8 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 8 Forecast 2 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 8 Forecast 2 Amount] Else 0.000000 End
							  Else [Period 8 Forecast 2 Amount]
							End),0.000000) AS [Period 8 Forecast 2 Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 9 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 9 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 9 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 9 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 9 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 9 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 9 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 9 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 9 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 9 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 9 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 9 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 9 Forecast 2 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 9 Forecast 2 Amount] Else 0.000000 End
							  Else [Period 9 Forecast 2 Amount]
							End),0.000000) AS [Period 9 Forecast 2 Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 10 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 10 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 10 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 10 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 10 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 10 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 10 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 10 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 10 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 10 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 10 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 10 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 10 Forecast 2 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 10 Forecast 2 Amount] Else 0.000000 End
							  Else [Period 10 Forecast 2 Amount]
							End),0.000000) as [Period 10 Forecast 2 Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 11 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 11 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 11 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 11 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 11 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 11 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 11 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 11 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 11 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 11 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 11 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 11 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 11 Forecast 2 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 11 Forecast 2 Amount] Else 0.000000 End
							  Else [Period 11 Forecast 2 Amount]
							End),0.000000) AS [Period 11 Forecast 2 Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 12 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 12 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 12 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 12 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 12 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 12 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 12 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 12 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 12 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 12 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 12 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 12 Forecast 2 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 12 Forecast 2 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 12 Forecast 2 Amount] Else 0.000000 End
							  Else [Period 12 Forecast 2 Amount]
							End),0.000000) AS [Period 12 Forecast 2 Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 1 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 1 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 1 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 1 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 1 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 1 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 1 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 1 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 1 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 1 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 1 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 1 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 1 Forecast 3 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 1 Forecast 3 Amount] Else 0.000000 End
							  Else [Period 1 Forecast 3 Amount]
							End),0.000000) AS [Period 1 Forecast 3 Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 2 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 2 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 2 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 2 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 2 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 2 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 2 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 2 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 2 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 2 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 2 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 2 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 2 Forecast 3 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 2 Forecast 3 Amount] Else 0.000000 End
							  Else [Period 2 Forecast 3 Amount]
							End),0.000000) AS [Period 2 Forecast 3 Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 3 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 3 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 3 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 3 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 3 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 3 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 3 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 3 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 3 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 3 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 3 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 3 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 3 Forecast 3 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 3 Forecast 3 Amount] Else 0.000000 End
							  Else [Period 3 Forecast 3 Amount]
							End),0.000000) AS [Period 3 Forecast 3 Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 4 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 4 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 4 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 4 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 4 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 4 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 4 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 4 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 4 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 4 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 4 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 4 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 4 Forecast 3 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 4 Forecast 3 Amount] Else 0.000000 End
							  Else [Period 4 Forecast 3 Amount]
							End),0.000000) AS [Period 4 Forecast 3 Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 5 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 5 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 5 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 5 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 5 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 5 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 5 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 5 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 5 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 5 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 5 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 5 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 5 Forecast 3 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 5 Forecast 3 Amount] Else 0.000000 End
							  Else [Period 5 Forecast 3 Amount]
							End),0.000000) AS [Period 5 Forecast 3 Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 6 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 6 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 6 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 6 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 6 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 6 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 6 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 6 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 6 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 6 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 6 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 6 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 6 Forecast 3 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 6 Forecast 3 Amount] Else 0.000000 End
							  Else [Period 6 Forecast 3 Amount]
							End),0.000000) AS [Period 6 Forecast 3 Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 7 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 7 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 7 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 7 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 7 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 7 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 7 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 7 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 7 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 7 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 7 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 7 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 7 Forecast 3 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 7 Forecast 3 Amount] Else 0.000000 End
							  Else [Period 7 Forecast 3 Amount]
							End),0.000000) AS [Period 7 Forecast 3 Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 8 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 8 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 8 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 8 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 8 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 8 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 8 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 8 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 8 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 8 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 8 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 8 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 8 Forecast 3 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 8 Forecast 3 Amount] Else 0.000000 End
							  Else [Period 8 Forecast 3 Amount]
							End),0.000000) AS [Period 8 Forecast 3 Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 9 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 9 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 9 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 9 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 9 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 9 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 9 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 9 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 9 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 9 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 9 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 9 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 9 Forecast 3 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 9 Forecast 3 Amount] Else 0.000000 End
							  Else [Period 9 Forecast 3 Amount]
							End),0.000000) AS [Period 9 Forecast 3 Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 10 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 10 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 10 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 10 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 10 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 10 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 10 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 10 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 10 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 10 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 10 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 10 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 10 Forecast 3 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 10 Forecast 3 Amount] Else 0.000000 End
							  Else [Period 10 Forecast 3 Amount]
							End),0.000000) AS [Period 10 Forecast 3 Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 11 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 11 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 11 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 11 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 11 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 11 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 11 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 11 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 11 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 11 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 11 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 11 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 11 Forecast 3 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 11 Forecast 3 Amount] Else 0.000000 End
							  Else [Period 11 Forecast 3 Amount]
							End),0.000000) AS [Period 11 Forecast 3 Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [Period 12 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [Period 12 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [Period 12 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [Period 12 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [Period 12 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [Period 12 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [Period 12 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [Period 12 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [Period 12 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [Period 12 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [Period 12 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [Period 12 Forecast 3 Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [Period 12 Forecast 3 Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [Period 12 Forecast 3 Amount] Else 0.000000 End
							  Else [Period 12 Forecast 3 Amount]
							End),0.000000) AS [Period 12 Forecast 3 Amount]
						
							
	FROM ( 
			SELECT				 
					  FT.GroupID 
					 ,FT.TemplateID
					 ,PL.[OrgSkey]
					 ,DO.BusinessUnitID
					 ,FiscalPeriodNumber
					 ,SortOrder, 
						Case @pLanguage When @ENLanguage THEN FT.GroupDescEN 
									  WHEN @FRLanguage THEN FT.GroupDescFR
									  Else 'Unknown'
						END as GroupDesc
					,[HeaderLine]
					,[ShowDetail]
					,[InsertSkipLineBefore]
					,[SkipLine]
					,[IsMarkup]
					,[IsNetRevenues]
					,[IsDirectLabor]
					,[IsFringeBenefitsPct]
					,[IsFringeBenefits]
					,[IsManagementSalaries]
					,[IsMarketingSalaries]
					,[IsTrainingSalaries]
					,[IsEBGEPct]
					,[IsEBGE]
					,[IsEBREPct]
					,[IsEBRE]
					,[IsEBITDAPct]
					,[IsEBITDA]
					,[IsCalculatedUtilizationPct]
					 ,Case @pCurrency  WHEN @ConsCurrency THEN SUM(PL.ConsCMAmt * FT.IncomeStatementActualSign) 
									   WHEN @FuncCurrency THEN SUM(PL.FuncCMAmt * FT.IncomeStatementActualSign)
									   Else 0.000000
					  END as [Current Month Amount]
					  
					,Case @pCurrency WHEN @ConsCurrency THEN SUM(PL.ConsLYCMAmt * FT.IncomeStatementActualSign)
									WHEN @FuncCurrency THEN SUM(PL.FuncLYCMAmt * FT.IncomeStatementActualSign)
							END AS [LY Current Month Amount]
					, Case @pCurrency  WHEN @ConsCurrency THEN SUM(PL.ConsCMBudgetAmt * FT.IncomeStatementBudgetSign)
									   WHEN @FuncCurrency THEN SUM(PL.FuncCMBudgetAmt * FT.IncomeStatementBudgetSign)
									   Else 0.000000
					  END as [Current Month Budget Amount]
					
					, Case @pCurrency  WHEN @ConsCurrency THEN SUM(PL.ConsYTDAmt * FT.IncomeStatementActualSign)
										WHEN @FuncCurrency THEN SUM(PL.FuncYTDAmt * FT.IncomeStatementActualSign)
										Else 0.000000
						END as [YTD Amount]
						,Case @pCurrency  WHEN @ConsCurrency THEN SUM(PL.ConsLYYTDAmt * FT.IncomeStatementActualSign)
										WHEN @FuncCurrency THEN SUM(PL.FuncLYYTDAmt * FT.IncomeStatementActualSign)
										Else 0.000000
						END as [LY YTD Amount]
					,SUM((Case @pCurrency  WHEN @ConsCurrency THEN PL.ConsCMFC1Amt 
									   WHEN @FuncCurrency THEN PL.FuncCMFC1Amt 
									   Else 0.000000
									   END) * 
							Case When CP.[FiscalPeriodNumber] <= 2 Then [IncomeStatementActualSign]  
										Else [IncomeStatementBudgetSign]
										END 
										) as [Current Month Forecast 1 Amount]
					,SUM((Case @pCurrency  WHEN @ConsCurrency THEN PL.ConsCMFC2Amt 
									   WHEN @FuncCurrency THEN PL.FuncCMFC2Amt 
									   Else 0.000000
									   END) * 
							Case When CP.[FiscalPeriodNumber] <= 5 Then [IncomeStatementActualSign]  
										Else [IncomeStatementBudgetSign]
										END 
										) as [Current Month Forecast 2 Amount]
					,SUM((Case @pCurrency  WHEN @ConsCurrency THEN PL.ConsCMFC3Amt 
									   WHEN @FuncCurrency THEN PL.FuncCMFC3Amt 
									   Else 0.000000
									   END) * 
							Case When CP.[FiscalPeriodNumber] <= 8 Then [IncomeStatementActualSign]  
										Else [IncomeStatementBudgetSign]
										END 
										) as [Current Month Forecast 3 Amount]
					, Case @pCurrency  WHEN @ConsCurrency THEN SUM(PL.ConsYTDBudgetAmt * FT.IncomeStatementBudgetSign)
									   WHEN @FuncCurrency THEN SUM(PL.FuncYTDBudgetAmt * FT.IncomeStatementBudgetSign)
									   END as [YTD Budget Amount]
					,Case @pCurrency  WHEN @ConsCurrency THEN SUM(PL.ConsLYYTDBudgetAmt * FT.IncomeStatementBudgetSign)
									   WHEN @FuncCurrency THEN SUM(PL.FuncLYYTDBudgetAmt * FT.IncomeStatementBudgetSign)
									   END as [LY YTD Budget Amount]

					, Case @pCurrency  WHEN @ConsCurrency THEN SUM(PL.ConsCYBudgetAmt * FT.IncomeStatementBudgetSign) 
									   WHEN @FuncCurrency THEN SUM(PL.FuncCYBudgetAmt * FT.IncomeStatementBudgetSign)
									   END as [Current Year Budget Amount]

					, Case @pCurrency 
						WHEN @ConsCurrency THEN 
						  (CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM((PL.ConsP1FC1Amt) * FT.IncomeStatementActualSign)				  
										   WHEN  2  THEN SUM((PL.ConsP1FC1Amt + PL.ConsP2FC1Amt) * FT.IncomeStatementActualSign)				   
										   WHEN  3  THEN SUM(((PL.ConsP1FC1Amt + PL.ConsP2FC1Amt) * FT.IncomeStatementActualSign)  + (PL.ConsP3FC1Amt * FT.IncomeStatementBudgetSign)) 				   
										   WHEN  4  THEN SUM(((PL.ConsP1FC1Amt + PL.ConsP2FC1Amt)  * FT.IncomeStatementActualSign) + ((PL.ConsP3FC1Amt + PL.ConsP4FC1Amt) * FT.IncomeStatementBudgetSign)) 				   
										   WHEN  5  THEN SUM(((PL.ConsP1FC1Amt + PL.ConsP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC1Amt + PL.ConsP4FC1Amt + PL.ConsP5FC1Amt) * FT.IncomeStatementBudgetSign))				   
										   WHEN  6  THEN SUM(((PL.ConsP1FC1Amt + PL.ConsP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC1Amt + PL.ConsP4FC1Amt + PL.ConsP5FC1Amt + PL.ConsP6FC1Amt) * FT.IncomeStatementBudgetSign))				  
										   WHEN  7   THEN SUM(((PL.ConsP1FC1Amt + PL.ConsP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC1Amt + PL.ConsP4FC1Amt + PL.ConsP5FC1Amt + PL.ConsP6FC1Amt + PL.ConsP7FC1Amt) * FT.IncomeStatementBudgetSign))				   
										   WHEN  8  THEN SUM(((PL.ConsP1FC1Amt + PL.ConsP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC1Amt + PL.ConsP4FC1Amt + PL.ConsP5FC1Amt + PL.ConsP6FC1Amt + PL.ConsP7FC1Amt + PL.ConsP8FC1Amt) * FT.IncomeStatementBudgetSign))				   
										   WHEN  9  THEN SUM(((PL.ConsP1FC1Amt + PL.ConsP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC1Amt + PL.ConsP4FC1Amt + PL.ConsP5FC1Amt + PL.ConsP6FC1Amt + PL.ConsP7FC1Amt + PL.ConsP8FC1Amt + PL.ConsP9FC1Amt) * FT.IncomeStatementBudgetSign))				   
										   WHEN  10   THEN SUM(((PL.ConsP1FC1Amt + PL.ConsP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC1Amt + PL.ConsP4FC1Amt + PL.ConsP5FC1Amt + PL.ConsP6FC1Amt + PL.ConsP7FC1Amt + PL.ConsP8FC1Amt + PL.ConsP9FC1Amt + PL.ConsP10FC1Amt) * FT.IncomeStatementBudgetSign))				   
										   WHEN  11  THEN SUM(((PL.ConsP1FC1Amt + PL.ConsP2FC1Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.ConsP3FC1Amt + PL.ConsP4FC1Amt + PL.ConsP5FC1Amt + PL.ConsP6FC1Amt + PL.ConsP7FC1Amt + PL.ConsP8FC1Amt + PL.ConsP9FC1Amt + PL.ConsP10FC1Amt + PL.ConsP11FC1Amt) * FT.IncomeStatementBudgetSign)) 				  
										   WHEN 12  THEN SUM(((PL.ConsP1FC1Amt + PL.ConsP2FC1Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.ConsP3FC1Amt + PL.ConsP4FC1Amt + PL.ConsP5FC1Amt + PL.ConsP6FC1Amt + PL.ConsP7FC1Amt + PL.ConsP8FC1Amt + PL.ConsP9FC1Amt + PL.ConsP10FC1Amt + PL.ConsP11FC1Amt + PL.ConsP12FC1Amt) * FT.IncomeStatementBudgetSign))
						  END)
					 WHEN @FuncCurrency THEN
							(Case CP.[FiscalPeriodNumber] WHEN 1  THEN SUM(((PL.FuncP1FC1Amt) * FT.IncomeStatementActualSign)) 
							  WHEN 2  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign))  
							  WHEN 3 THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + (PL.FuncP3FC1Amt * FT.IncomeStatementBudgetSign)) 
							  WHEN 4 THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt)  * FT.IncomeStatementActualSign) + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt) * FT.IncomeStatementBudgetSign)) 
							  WHEN 5  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt) * FT.IncomeStatementBudgetSign))  
							  WHEN 6 THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt) * FT.IncomeStatementBudgetSign))
							  WHEN 7  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt) * FT.IncomeStatementBudgetSign))  
							  WHEN 8 THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt) * FT.IncomeStatementBudgetSign))  
							  WHEN 9 THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt) * FT.IncomeStatementBudgetSign))  
							  WHEN 10  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt + PL.FuncP10FC1Amt) * FT.IncomeStatementBudgetSign)) 
							  WHEN 11 THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign) 
										 + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt + PL.FuncP10FC1Amt + PL.FuncP11FC1Amt) * FT.IncomeStatementBudgetSign))
							 WHEN  12  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign) 
										 + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt + PL.FuncP10FC1Amt + PL.FuncP11FC1Amt + PL.FuncP12FC1Amt) * FT.IncomeStatementBudgetSign))
							 END)
						Else 0.000000
						END AS [YTD Forecast 1 Amount]
            
					 ,Case @pCurrency WHEN @ConsCurrency THEN 
								(CASE CP.FiscalPeriodNumber WHEN 1   THEN SUM((PL.ConsP1FC2Amt) * FT.IncomeStatementActualSign)									  
											  WHEN 2  THEN SUM((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign) 									  
											  WHEN 3  THEN SUM((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt + PL.ConsP3FC2Amt) * FT.IncomeStatementActualSign)									  
											  WHEN 4  THEN SUM((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt + PL.ConsP3FC2Amt + PL.ConsP4FC2Amt) * FT.IncomeStatementActualSign) 									  
											  WHEN 5  THEN SUM((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt + PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt) * FT.IncomeStatementActualSign) 									  
											  WHEN 6  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt + PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt ) * FT.IncomeStatementActualSign) + (( PL.ConsP6FC2Amt) * FT.IncomeStatementBudgetSign))									  
											  WHEN 7  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt + PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt) * FT.IncomeStatementActualSign) + (( PL.ConsP6FC2Amt + PL.ConsP7FC2Amt) * FT.IncomeStatementBudgetSign)) 									  
											  WHEN 8  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt + PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt ) * FT.IncomeStatementActualSign) 
													 + (( PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt ) * FT.IncomeStatementBudgetSign))									  
											  WHEN 9  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt + PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt) * FT.IncomeStatementActualSign) 
													 + (( PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt) * FT.IncomeStatementBudgetSign)) 								  
											  WHEN 10  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt + PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt) * FT.IncomeStatementActualSign) 
													 + (( PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt + PL.ConsP10FC2Amt) * FT.IncomeStatementBudgetSign))									  
											  WHEN 11   THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt + PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt) * FT.IncomeStatementActualSign) 
													 + (( PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt + PL.ConsP10FC2Amt + PL.ConsP11FC2Amt) * FT.IncomeStatementBudgetSign))								  
											  WHEN 12  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt + PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt) * FT.IncomeStatementActualSign) 
													 + (( PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt + PL.ConsP10FC2Amt + PL.ConsP11FC2Amt + PL.ConsP12FC2Amt) * FT.IncomeStatementBudgetSign))
											END)
								 WHEN @FuncCurrency THEN	 
										(CASE CP.FiscalPeriodNumber WHEN 1 THEN SUM((PL.FuncP1FC2Amt) * FT.IncomeStatementActualSign) 
												WHEN 2 THEN SUM((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign) 
												WHEN 3 THEN SUM((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt + PL.FuncP3FC2Amt) * FT.IncomeStatementActualSign)
												WHEN 4 THEN SUM((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt + PL.FuncP3FC2Amt + PL.FuncP4FC2Amt) * FT.IncomeStatementActualSign) 
												WHEN 5 THEN SUM((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt + PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt) * FT.IncomeStatementActualSign) 
												WHEN 6 THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt + PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt ) * FT.IncomeStatementActualSign) + (( PL.FuncP6FC2Amt) * FT.IncomeStatementBudgetSign))  
												WHEN 7 THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt + PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt) * FT.IncomeStatementActualSign) + (( PL.FuncP6FC2Amt + PL.FuncP7FC2Amt) * FT.IncomeStatementBudgetSign)) 
												WHEN 8 THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt + PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt ) * FT.IncomeStatementActualSign) 
															+ (( PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt ) * FT.IncomeStatementBudgetSign))  
												WHEN 9 THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt + PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt) * FT.IncomeStatementActualSign) 
															+ (( PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt) * FT.IncomeStatementBudgetSign)) 
												WHEN 10 THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt + PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt) * FT.IncomeStatementActualSign) 
															+ (( PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt + PL.FuncP10FC2Amt) * FT.IncomeStatementBudgetSign))  
												WHEN 11 THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt + PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt) * FT.IncomeStatementActualSign) 
															+ (( PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt + PL.FuncP10FC2Amt + PL.FuncP11FC2Amt) * FT.IncomeStatementBudgetSign))
												WHEN 12 THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt + PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt) * FT.IncomeStatementActualSign) 
															+ (( PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt + PL.FuncP10FC2Amt + PL.FuncP11FC2Amt + PL.FuncP12FC2Amt) * FT.IncomeStatementBudgetSign))
										 END)
							Else 0.000000
						END AS [YTD Forecast 2 Amount]
			  
				   ,Case @pCurrency WHEN @ConsCurrency THEN
						 ( CASE CP.FiscalPeriodNumber WHEN 1  THEN SUM(((PL.ConsP1FC3Amt) * FT.IncomeStatementActualSign))				  
								  WHEN  2  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign))				  
								  WHEN  3  THEN SUM((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt + PL.ConsP3FC3Amt) * FT.IncomeStatementActualSign)				  
								  WHEN  4  THEN SUM((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt + PL.ConsP3FC3Amt + PL.ConsP4FC3Amt) * FT.IncomeStatementActualSign)				  
								  WHEN  5  THEN SUM((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt + PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt) * FT.IncomeStatementActualSign)				  
								  WHEN  6  THEN SUM((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt + PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt) * FT.IncomeStatementActualSign) 				  
								  WHEN  7  THEN SUM((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt + PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt) * FT.IncomeStatementActualSign) 				  
								  WHEN  8  THEN SUM((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt + PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt) * FT.IncomeStatementActualSign) 				                     
								  WHEN  9  THEN SUM((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt 
										 + PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt ) * FT.IncomeStatementActualSign)				  
								  WHEN  10  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt 
										 + PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt) * FT.IncomeStatementActualSign) + (PL.ConsP10FC3Amt) * FT.IncomeStatementBudgetSign)				  
								  WHEN  11  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt 
										 + PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt ) * FT.IncomeStatementActualSign) + (PL.ConsP10FC3Amt + PL.ConsP11FC3Amt) * FT.IncomeStatementBudgetSign) 				  
								  WHEN  12  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt 
										 + PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt ) * FT.IncomeStatementActualSign) + (PL.ConsP10FC3Amt + PL.ConsP11FC3Amt + PL.ConsP12FC3Amt) * FT.IncomeStatementBudgetSign) 
								 END )
					  WHEN @FuncCurrency THEN
							( CASE CP.FiscalPeriodNumber WHEN 1  THEN SUM((PL.FuncP1FC3Amt) * FT.IncomeStatementActualSign)
									WHEN 2 THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign))  
									WHEN 3 THEN SUM((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt + PL.FuncP3FC3Amt) * FT.IncomeStatementActualSign)
									WHEN 4 THEN SUM((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt + PL.FuncP3FC3Amt + PL.FuncP4FC3Amt) * FT.IncomeStatementActualSign)
									WHEN 5 THEN SUM((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt + PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt) * FT.IncomeStatementActualSign)
									WHEN 6 THEN SUM((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt + PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt) * FT.IncomeStatementActualSign) 
									WHEN 7 THEN SUM((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt + PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt) * FT.IncomeStatementActualSign) 
									WHEN 8 THEN SUM((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt + PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt) * FT.IncomeStatementActualSign)
									WHEN 9 THEN SUM((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt 
												 + PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt ) * FT.IncomeStatementActualSign)  
									WHEN 10 THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt 
												 + PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt) * FT.IncomeStatementActualSign) + (PL.FuncP10FC3Amt) * FT.IncomeStatementBudgetSign)  
									WHEN 11 THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt 
												 + PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt ) * FT.IncomeStatementActualSign) + (PL.FuncP10FC3Amt + PL.FuncP11FC3Amt) * FT.IncomeStatementBudgetSign) 
									WHEN 12 THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt 
												 + PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt ) * FT.IncomeStatementActualSign) + (PL.FuncP10FC3Amt + PL.FuncP11FC3Amt + PL.FuncP12FC3Amt) * FT.IncomeStatementBudgetSign) 
							  END)
							END AS [YTD Forecast 3 Amount]

					,CASE @pCurrency WHEN @ConsCurrency THEN  SUM(PL.[ConsQTDAmt] * FT.[IncomeStatementActualSign])
											WHEN @FuncCurrency THEN SUM( PL.[FuncQTDAmt] * FT.[IncomeStatementActualSign])
										Else 0.000000
									END AS [QTD Amount]
					,CASE @pCurrency WHEN @ConsCurrency THEN  SUM(PL.[ConsLYQTDAmt] * FT.[IncomeStatementActualSign])
											WHEN @FuncCurrency THEN SUM( PL.[FuncLYQTDAmt] * FT.[IncomeStatementActualSign])
										Else 0.000000
									END AS [LY QTD Amount]
					,CASE @pCurrency WHEN @ConsCurrency THEN  SUM((PL.[ConsQTDBudgetAmt]) * FT.[IncomeStatementBudgetSign])
											WHEN @FuncCurrency THEN SUM( (PL.[FuncQTDBudgetAmt]) * FT.[IncomeStatementBudgetSign])
										Else 0.000000
									END AS [QTD Budget Amount]
					,Case @pCurrency WHEN @ConsCurrency THEN
						 ( CASE CP.[FiscalPeriodNumber]
							  WHEN 1 THEN SUM( PL.[ConsP1FC1Amt]  * FT.[IncomeStatementActualSign])
							  WHEN 2 THEN SUM(( PL.[ConsP1FC1Amt] + PL.[ConsP2FC1Amt] ) * FT.[IncomeStatementActualSign])
							  WHEN 3 THEN SUM(( PL.[ConsP1FC1Amt] + PL.[ConsP2FC1Amt] ) * FT.[IncomeStatementActualSign] + PL.[ConsP3FC1Amt] * FT.[IncomeStatementBudgetSign])
							  WHEN 4 THEN SUM( PL.[ConsP4FC1Amt]  * FT.[IncomeStatementBudgetSign])
							  WHEN 5 THEN SUM(( PL.[ConsP4FC1Amt] + PL.[ConsP5FC1Amt] ) * FT.[IncomeStatementBudgetSign])
							  WHEN 6 THEN SUM(( PL.[ConsP4FC1Amt] + PL.[ConsP5FC1Amt] + PL.[ConsP6FC1Amt] ) * FT.[IncomeStatementBudgetSign])
							  WHEN 7 THEN SUM( PL.[ConsP7FC1Amt]  * FT.[IncomeStatementBudgetSign])
							  WHEN 8 THEN SUM(( PL.[ConsP7FC1Amt] + PL.[ConsP8FC1Amt]) * FT.[IncomeStatementBudgetSign])
							  WHEN 9 THEN SUM(( PL.[ConsP7FC1Amt] + PL.[ConsP8FC1Amt] + PL.[ConsP9FC1Amt] ) * FT.[IncomeStatementBudgetSign])
							  WHEN 10 THEN SUM( PL.[ConsP10FC1Amt] * FT.[IncomeStatementBudgetSign])
							  WHEN 11 THEN SUM(( PL.[ConsP10FC1Amt] + PL.[ConsP11FC1Amt] ) * FT.[IncomeStatementBudgetSign])
							  WHEN 12 THEN SUM(( PL.[ConsP10FC1Amt] + PL.[ConsP11FC1Amt] + PL.[ConsP12FC1Amt] ) * FT.[IncomeStatementBudgetSign])
						   END ) 
					WHEN @FuncCurrency THEN
							( CASE CP.[FiscalPeriodNumber]
							  WHEN 1 THEN SUM(( PL.[FuncP1FC1Amt])  * FT.[IncomeStatementActualSign])
							  WHEN 2 THEN SUM(( PL.[FuncP1FC1Amt] + PL.[FuncP2FC1Amt] ) * FT.[IncomeStatementActualSign])
							  WHEN 3 THEN SUM(( PL.[FuncP1FC1Amt] + PL.[FuncP2FC1Amt] ) * FT.[IncomeStatementActualSign]  + PL.[FuncP3FC1Amt]* FT.[IncomeStatementBudgetSign] ) 
							  WHEN 4 THEN SUM(( PL.[FuncP4FC1Amt] ) * FT.[IncomeStatementBudgetSign])
							  WHEN 5 THEN SUM(( PL.[FuncP4FC1Amt] + PL.[FuncP5FC1Amt] ) * FT.[IncomeStatementBudgetSign])
							  WHEN 6 THEN SUM(( PL.[FuncP4FC1Amt] + PL.[FuncP5FC1Amt] + PL.[FuncP6FC1Amt] ) * FT.[IncomeStatementBudgetSign])
							  WHEN 7 THEN SUM(( PL.[FuncP7FC1Amt] ) * FT.[IncomeStatementBudgetSign])
							  WHEN 8 THEN SUM(( PL.[FuncP7FC1Amt] + PL.[FuncP8FC1Amt]) * FT.[IncomeStatementBudgetSign])
							  WHEN 9 THEN SUM(( PL.[FuncP7FC1Amt] + PL.[FuncP8FC1Amt] + PL.[FuncP9FC1Amt] ) * FT.[IncomeStatementBudgetSign])
							  WHEN 10 THEN SUM(( PL.[FuncP10FC1Amt] ) * FT.[IncomeStatementBudgetSign])
							  WHEN 11 THEN SUM(( PL.[FuncP10FC1Amt] + PL.[FuncP11FC1Amt] ) * FT.[IncomeStatementBudgetSign])
							  WHEN 12 THEN SUM(( PL.[FuncP10FC1Amt] + PL.[FuncP11FC1Amt] + PL.[FuncP12FC1Amt] ) * FT.[IncomeStatementBudgetSign])
						   END ) 
				Else 0.000000
				END AS [QTD Forecast 1 Amount]
				,Case @pCurrency WHEN @ConsCurrency THEN
					( CASE CP.FiscalPeriodNumber
							  WHEN 1 THEN SUM( PL.[ConsP1FC2Amt]  * FT.[IncomeStatementActualSign])
							  WHEN 2 THEN SUM(( PL.[ConsP1FC2Amt] + PL.[ConsP2FC2Amt] ) * FT.[IncomeStatementActualSign])
							  WHEN 3 THEN SUM(( PL.[ConsP1FC2Amt] + PL.[ConsP2FC2Amt] + PL.[ConsP3FC2Amt] ) * FT.[IncomeStatementActualSign] )
							  WHEN 4 THEN SUM( PL.[ConsP4FC2Amt]  * FT.[IncomeStatementActualSign])
							  WHEN 5 THEN SUM(( PL.[ConsP4FC2Amt] + PL.[ConsP5FC2Amt] ) * FT.[IncomeStatementActualSign])
							  WHEN 6 THEN SUM(( PL.[ConsP4FC2Amt] + PL.[ConsP5FC2Amt])*FT.[IncomeStatementActualSign] + PL.[ConsP6FC2Amt] * FT.[IncomeStatementBudgetSign])
							  WHEN 7 THEN SUM( PL.[ConsP7FC2Amt]  * FT.[IncomeStatementBudgetSign])
							  WHEN 8 THEN SUM(( PL.[ConsP7FC2Amt] + PL.[ConsP8FC2Amt]) * FT.[IncomeStatementBudgetSign])
							  WHEN 9 THEN SUM(( PL.[ConsP7FC2Amt] + PL.[ConsP8FC2Amt] + PL.[ConsP9FC2Amt] ) * FT.[IncomeStatementBudgetSign])
							  WHEN 10 THEN SUM( PL.[ConsP10FC2Amt] * FT.[IncomeStatementBudgetSign])
							  WHEN 11 THEN SUM(( PL.[ConsP10FC2Amt] + PL.[ConsP11FC2Amt] ) * FT.[IncomeStatementBudgetSign])
							  WHEN 12 THEN SUM(( PL.[ConsP10FC2Amt] + PL.[ConsP11FC2Amt] + PL.[ConsP12FC2Amt] ) * FT.[IncomeStatementBudgetSign])
						   END ) 
				WHEN @FuncCurrency THEN
							( CASE CP.[FiscalPeriodNumber]
							  WHEN 1 THEN SUM(( PL.[FuncP1FC2Amt])  * FT.[IncomeStatementActualSign])
							  WHEN 2 THEN SUM(( PL.[FuncP1FC2Amt] + PL.[FuncP2FC2Amt] ) * FT.[IncomeStatementActualSign])
							  WHEN 3 THEN SUM(( PL.[FuncP1FC2Amt] + PL.[FuncP2FC2Amt] + PL.[FuncP3FC2Amt] ) * FT.[IncomeStatementActualSign] ) 
							  WHEN 4 THEN SUM(( PL.[FuncP4FC2Amt] ) * FT.[IncomeStatementBudgetSign])
							  WHEN 5 THEN SUM(( PL.[FuncP4FC2Amt] + PL.[FuncP5FC2Amt] ) * FT.[IncomeStatementActualSign])
							  WHEN 6 THEN SUM(( PL.[FuncP4FC2Amt] + PL.[FuncP5FC2Amt])* FT.[IncomeStatementActualSign] + PL.[FuncP6FC2Amt] * FT.[IncomeStatementBudgetSign])
							  WHEN 7 THEN SUM(( PL.[FuncP7FC2Amt] ) * FT.[IncomeStatementBudgetSign])
							  WHEN 8 THEN SUM(( PL.[FuncP7FC2Amt] + PL.[FuncP8FC2Amt]) * FT.[IncomeStatementBudgetSign])
							  WHEN 9 THEN SUM(( PL.[FuncP7FC2Amt] + PL.[FuncP8FC2Amt] + PL.[FuncP9FC2Amt] ) * FT.[IncomeStatementBudgetSign])
							  WHEN 10 THEN SUM(( PL.[FuncP10FC2Amt] ) * FT.[IncomeStatementBudgetSign])
							  WHEN 11 THEN SUM(( PL.[FuncP10FC2Amt] + PL.[FuncP11FC2Amt] ) * FT.[IncomeStatementBudgetSign])
							  WHEN 12 THEN SUM(( PL.[FuncP10FC2Amt] + PL.[FuncP11FC2Amt] + PL.[FuncP12FC2Amt] ) * FT.[IncomeStatementBudgetSign])
						   END ) 
				Else 0.000000
				END AS [QTD Forecast 2 Amount]
				,Case @pCurrency WHEN @ConsCurrency THEN
				( CASE CP.FiscalPeriodNumber
						  WHEN 1 THEN SUM( PL.[ConsP1FC3Amt]  * FT.[IncomeStatementActualSign])
						  WHEN 2 THEN SUM(( PL.[ConsP1FC3Amt] + PL.[ConsP2FC3Amt] ) * FT.[IncomeStatementActualSign])
						  WHEN 3 THEN SUM(( PL.[ConsP1FC3Amt] + PL.[ConsP2FC3Amt] + PL.[ConsP3FC3Amt]) * FT.[IncomeStatementActualSign] )
						  WHEN 4 THEN SUM( PL.[ConsP4FC3Amt]  * FT.[IncomeStatementActualSign])
						  WHEN 5 THEN SUM(( PL.[ConsP4FC3Amt] + PL.[ConsP5FC3Amt] ) * FT.[IncomeStatementActualSign])
						  WHEN 6 THEN SUM(( PL.[ConsP4FC3Amt] + PL.[ConsP5FC3Amt] + PL.[ConsP6FC3Amt] ) *FT.[IncomeStatementActualSign])
						  WHEN 7 THEN SUM( PL.[ConsP7FC3Amt]  * FT.[IncomeStatementActualSign])
						  WHEN 8 THEN SUM(( PL.[ConsP7FC3Amt] + PL.[ConsP8FC3Amt]) * FT.[IncomeStatementActualSign])
						  WHEN 9 THEN SUM(( PL.[ConsP7FC3Amt] + PL.[ConsP8FC3Amt])*FT.[IncomeStatementActualSign] + PL.[ConsP9FC3Amt] * FT.[IncomeStatementBudgetSign])
						  WHEN 10 THEN SUM( PL.[ConsP10FC3Amt] * FT.[IncomeStatementBudgetSign])
						  WHEN 11 THEN SUM(( PL.[ConsP10FC3Amt] + PL.[ConsP11FC3Amt] ) * FT.[IncomeStatementBudgetSign])
						  WHEN 12 THEN SUM(( PL.[ConsP10FC3Amt] + PL.[ConsP11FC3Amt] + PL.[ConsP12FC3Amt] ) * FT.[IncomeStatementBudgetSign])
					   END ) 
			WHEN @FuncCurrency THEN
						( CASE CP.[FiscalPeriodNumber]
						  WHEN 1 THEN SUM(( PL.[FuncP1FC3Amt])  * FT.[IncomeStatementActualSign])
						  WHEN 2 THEN SUM(( PL.[FuncP1FC3Amt] + PL.[FuncP2FC3Amt] ) * FT.[IncomeStatementActualSign])
						  WHEN 3 THEN SUM(( PL.[FuncP1FC3Amt] + PL.[FuncP2FC3Amt] + PL.[FuncP3FC3Amt] ) * FT.[IncomeStatementActualSign] )
						  WHEN 4 THEN SUM(( PL.[FuncP4FC3Amt] )* FT.[IncomeStatementActualSign])
						  WHEN 5 THEN SUM(( PL.[FuncP4FC3Amt] + PL.[FuncP5FC3Amt] ) * FT.[IncomeStatementActualSign])
						  WHEN 6 THEN SUM(( PL.[FuncP4FC3Amt] + PL.[FuncP5FC3Amt] + PL.[FuncP6FC3Amt] ) * FT.[IncomeStatementActualSign])
						  WHEN 7 THEN SUM(( PL.[FuncP7FC3Amt] ) * FT.[IncomeStatementActualSign])
						  WHEN 8 THEN SUM(( PL.[FuncP7FC3Amt] + PL.[FuncP8FC3Amt]) * FT.[IncomeStatementActualSign])
						  WHEN 9 THEN SUM(( PL.[FuncP7FC3Amt] + PL.[FuncP8FC3Amt]) * FT.[IncomeStatementActualSign] + PL.[FuncP9FC3Amt] * FT.[IncomeStatementBudgetSign])
						  WHEN 10 THEN SUM(( PL.[FuncP10FC3Amt] ) * FT.[IncomeStatementBudgetSign])
						  WHEN 11 THEN SUM(( PL.[FuncP10FC3Amt] + PL.[FuncP11FC3Amt] ) * FT.[IncomeStatementBudgetSign])
						  WHEN 12 THEN SUM(( PL.[FuncP10FC3Amt] + PL.[FuncP11FC3Amt] + PL.[FuncP12FC3Amt] ) * FT.[IncomeStatementBudgetSign])
					   END ) 
			Else 0.000000
			END as [QTD Forecast 3 Amount]
			

		 ,Case @pCurrency	WHEN @ConsCurrency THEN
						 ( SUM(PL.ConsP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 1  
								  THEN FT.IncomeStatementActualSign 
												Else 0.000000 --FT.[IncomeStatementBudgetSign] 
										END ))
							WHEN @FuncCurrency THEN
							( SUM(PL.FuncP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 1  
								  THEN FT.IncomeStatementActualSign 
												Else 0.000000 --FT.[IncomeStatementBudgetSign] 
												END ))
		  END AS [Period 1 Actual Amount]
		,Case @pCurrency WHEN @ConsCurrency THEN
						 ( SUM(PL.ConsP2ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 2  
								  THEN FT.IncomeStatementActualSign 
											Else 0.000000  --FT.[IncomeStatementBudgetSign] 
												END ))
						 WHEN @FuncCurrency THEN
							( SUM(PL.FuncP2ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 2  
								  THEN FT.IncomeStatementActualSign 
											Else 0.000000  --FT.[IncomeStatementBudgetSign] 
												END ))
				END AS [Period 2 Actual Amount]
		,Case @pCurrency WHEN @ConsCurrency THEN
						 ( SUM(PL.ConsP3ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 3  
								  THEN FT.IncomeStatementActualSign 
											Else 0.000000  --FT.[IncomeStatementBudgetSign] 
											END ))
						 WHEN @FuncCurrency THEN
							( SUM(PL.FuncP3ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 3  
								  THEN FT.IncomeStatementActualSign 
											Else 0.000000 --FT.[IncomeStatementBudgetSign] 
											END ))
				END AS [Period 3 Actual Amount]
		,Case @pCurrency WHEN @ConsCurrency THEN
						 ( SUM(PL.ConsP4ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 4  
								  THEN FT.IncomeStatementActualSign 
											Else 0.000000 -- FT.[IncomeStatementBudgetSign] 
											END ))
						WHEN @FuncCurrency THEN
							( SUM(PL.FuncP4ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 4  
								  THEN FT.IncomeStatementActualSign 
											Else 0.000000  --FT.[IncomeStatementBudgetSign] 
											END ))
			END AS [Period 4 Actual Amount]
		,Case @pCurrency WHEN @ConsCurrency THEN
						 ( SUM(PL.ConsP5ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 5  
								  THEN FT.IncomeStatementActualSign 
											Else 0.000000  -- FT.[IncomeStatementBudgetSign] 
											END ))
					  WHEN @FuncCurrency THEN
							( SUM(PL.FuncP5ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 5  
								  THEN FT.IncomeStatementActualSign 
											Else 0.000000 -- FT.[IncomeStatementBudgetSign]
											 END ))
			END AS [Period 5 Actual Amount]
		,Case @pCurrency WHEN @ConsCurrency THEN
						 ( SUM(PL.ConsP6ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 6  
								  THEN FT.IncomeStatementActualSign 
											Else 0.000000 --FT.[IncomeStatementBudgetSign] 
											END ))
					  WHEN @FuncCurrency THEN
							( SUM(PL.FuncP6ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 6  
								  THEN FT.IncomeStatementActualSign 
											Else 0.000000 -- FT.[IncomeStatementBudgetSign] 
										END ))
			END AS [Period 6 Actual Amount]
		,Case @pCurrency WHEN @ConsCurrency THEN
						 ( SUM(PL.ConsP7ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 7 
								  THEN FT.IncomeStatementActualSign 
											ELSE  0  --FT.[IncomeStatementBudgetSign] 
											END ))
					  WHEN @FuncCurrency THEN
							( SUM(PL.FuncP7ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 7  
								  THEN FT.IncomeStatementActualSign 
											Else 0.000000  --FT.[IncomeStatementBudgetSign] 
											END ))
			END AS [Period 7 Actual Amount]
		,Case @pCurrency WHEN @ConsCurrency THEN
						 ( SUM(PL.ConsP8ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 8  
								  THEN FT.IncomeStatementActualSign 
											Else 0.000000  --FT.[IncomeStatementBudgetSign] 
											END ))
					  WHEN @FuncCurrency THEN
							( SUM(PL.FuncP8ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 8  
								  THEN FT.IncomeStatementActualSign 
											Else 0.000000 --FT.[IncomeStatementBudgetSign] 
											END ))
			END AS [Period 8 Actual Amount]
		,Case @pCurrency WHEN @ConsCurrency THEN
						 ( SUM(PL.ConsP9ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9  
								  THEN FT.IncomeStatementActualSign 
											Else 0.000000 --FT.[IncomeStatementBudgetSign] 
											END ))
					  WHEN @FuncCurrency THEN
							( SUM(PL.FuncP9ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9  
								  THEN FT.IncomeStatementActualSign 
											Else 0.000000  --FT.[IncomeStatementBudgetSign] 
											END ))
			END AS [Period 9 Actual Amount]	
		,Case @pCurrency WHEN @ConsCurrency THEN
						 ( SUM(PL.ConsP10ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 10  
								  THEN FT.IncomeStatementActualSign 
											Else 0.000000 --FT.[IncomeStatementBudgetSign] 
											END ))
					  WHEN @FuncCurrency THEN
							( SUM(PL.FuncP10ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 10 
								  THEN FT.IncomeStatementActualSign 
											Else 0.000000 --FT.[IncomeStatementBudgetSign] 
											END ))
			END AS [Period 10 Actual Amount]
		,Case @pCurrency WHEN @ConsCurrency THEN
						 ( SUM(PL.ConsP11ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 11 
								  THEN FT.IncomeStatementActualSign 
											Else 0.000000 -- FT.[IncomeStatementBudgetSign] 
											END ))
					  WHEN @FuncCurrency THEN
							( SUM(PL.FuncP11ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 11  
								  THEN FT.IncomeStatementActualSign 
											Else 0.000000 --FT.[IncomeStatementBudgetSign] 
											END ))
				END AS [Period 11 Actual Amount]
		,Case @pCurrency WHEN @ConsCurrency THEN
						 ( SUM(PL.ConsP12ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 12  
								  THEN FT.IncomeStatementActualSign 
											Else 0.000000 --FT.[IncomeStatementBudgetSign] 
											END ))
					  WHEN @FuncCurrency THEN
							( SUM(PL.FuncP12ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 12  
								  THEN FT.IncomeStatementActualSign 
											Else 0.000000 --FT.[IncomeStatementBudgetSign] 
											 END ))
				END AS [Period 12 Actual Amount]
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP1BudgetAmt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP1BudgetAmt * FT.IncomeStatementBudgetSign) )
				END AS [Period 1 Budget Amount]
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP2BudgetAmt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP2BudgetAmt * FT.IncomeStatementBudgetSign) )
				END AS [Period 2 Budget Amount]
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP3BudgetAmt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP3BudgetAmt * FT.IncomeStatementBudgetSign) )
				END AS [Period 3 Budget Amount]
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP4BudgetAmt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP4BudgetAmt * FT.IncomeStatementBudgetSign) )
				END AS [Period 4 Budget Amount]
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP5BudgetAmt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP5BudgetAmt * FT.IncomeStatementBudgetSign) )
				END AS [Period 5 Budget Amount]
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP6BudgetAmt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP6BudgetAmt * FT.IncomeStatementBudgetSign) )
				END AS [Period 6 Budget Amount]
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP7BudgetAmt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP7BudgetAmt * FT.IncomeStatementBudgetSign) )
				END AS [Period 7 Budget Amount]
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP8BudgetAmt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP8BudgetAmt * FT.IncomeStatementBudgetSign) )
				END AS [Period 8 Budget Amount]
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP9BudgetAmt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP9BudgetAmt * FT.IncomeStatementBudgetSign) )
				END AS [Period 9 Budget Amount]
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP10BudgetAmt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP10BudgetAmt * FT.IncomeStatementBudgetSign) )
				END AS [Period 10 Budget Amount]
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP11BudgetAmt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP11BudgetAmt * FT.IncomeStatementBudgetSign) )
				END AS [Period 11 Budget Amount]
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP12BudgetAmt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP12BudgetAmt * FT.IncomeStatementBudgetSign) )
				END AS [Period 12 Budget Amount]
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP1FC1Amt * FT.IncomeStatementActualSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP1FC1Amt * FT.IncomeStatementActualSign) )
				END AS [Period 1 Forecast 1 Amount] 
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP2FC1Amt * FT.IncomeStatementActualSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP2FC1Amt * FT.IncomeStatementActualSign) )
				END AS [Period 2 Forecast 1 Amount] 
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP3FC1Amt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP3FC1Amt * FT.IncomeStatementBudgetSign) )
				END AS [Period 3 Forecast 1 Amount] 
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP4FC1Amt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP4FC1Amt * FT.IncomeStatementBudgetSign) )
				END AS [Period 4 Forecast 1 Amount] 
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP5FC1Amt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP5FC1Amt * FT.IncomeStatementBudgetSign) )
				END AS [Period 5 Forecast 1 Amount] 
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP6FC1Amt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP6FC1Amt * FT.IncomeStatementBudgetSign) )
				END AS [Period 6 Forecast 1 Amount] 
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP7FC1Amt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP7FC1Amt * FT.IncomeStatementBudgetSign) )
				END AS [Period 7 Forecast 1 Amount] 
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP8FC1Amt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP8FC1Amt * FT.IncomeStatementBudgetSign) )
							END AS [Period 8 Forecast 1 Amount] 
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP9FC1Amt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP9FC1Amt * FT.IncomeStatementBudgetSign) )
				END AS [Period 9 Forecast 1 Amount] 
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP10FC1Amt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP10FC1Amt * FT.IncomeStatementBudgetSign) )
				END AS [Period 10 Forecast 1 Amount] 
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP11FC1Amt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP11FC1Amt * FT.IncomeStatementBudgetSign) )
				END AS [Period 11 Forecast 1 Amount] 
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP12FC1Amt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP12FC1Amt * FT.IncomeStatementBudgetSign) )
				END AS [Period 12 Forecast 1 Amount] 
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP1FC2Amt * FT.IncomeStatementActualSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP1FC2Amt * FT.IncomeStatementActualSign) )
				END AS [Period 1 Forecast 2 Amount] 
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP2FC2Amt * FT.IncomeStatementActualSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP2FC2Amt * FT.IncomeStatementActualSign) )
				END AS [Period 2 Forecast 2 Amount] 
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP3FC2Amt * FT.IncomeStatementActualSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP3FC2Amt * FT.IncomeStatementActualSign) )
				END AS [Period 3 Forecast 2 Amount] 
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP4FC2Amt * FT.IncomeStatementActualSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP4FC2Amt * FT.IncomeStatementActualSign) )
				END AS [Period 4 Forecast 2 Amount] 
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP5FC2Amt * FT.IncomeStatementActualSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP5FC2Amt * FT.IncomeStatementActualSign) )
				END AS [Period 5 Forecast 2 Amount] 
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP6FC2Amt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP6FC2Amt * FT.IncomeStatementBudgetSign) )
				END AS [Period 6 Forecast 2 Amount] 
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP7FC2Amt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP7FC2Amt * FT.IncomeStatementBudgetSign) )
				END AS [Period 7 Forecast 2 Amount] 
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP8FC2Amt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP8FC2Amt * FT.IncomeStatementBudgetSign) )
				END AS [Period 8 Forecast 2 Amount] 
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP9FC2Amt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP9FC2Amt * FT.IncomeStatementBudgetSign) )
				END AS [Period 9 Forecast 2 Amount] 
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP10FC2Amt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP10FC2Amt * FT.IncomeStatementBudgetSign) )
				END AS [Period 10 Forecast 2 Amount] 
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP11FC2Amt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP11FC2Amt * FT.IncomeStatementBudgetSign) )
				END AS [Period 11 Forecast 2 Amount] 
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP12FC2Amt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP12FC2Amt * FT.IncomeStatementBudgetSign) )
				END AS [Period 12 Forecast 2 Amount]
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP1FC3Amt * FT.IncomeStatementActualSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP1FC3Amt * FT.IncomeStatementActualSign) )
				END AS [Period 1 Forecast 3 Amount] 
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP2FC3Amt * FT.IncomeStatementActualSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP2FC3Amt * FT.IncomeStatementActualSign) )
				END AS [Period 2 Forecast 3 Amount] 
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP3FC3Amt * FT.IncomeStatementActualSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP3FC3Amt * FT.IncomeStatementActualSign) )
				END AS [Period 3 Forecast 3 Amount] 
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP4FC3Amt * FT.IncomeStatementActualSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP4FC3Amt * FT.IncomeStatementActualSign) )
				END AS [Period 4 Forecast 3 Amount] 
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP5FC3Amt * FT.IncomeStatementActualSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP5FC3Amt * FT.IncomeStatementActualSign) )
				END AS [Period 5 Forecast 3 Amount] 
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP6FC3Amt * FT.IncomeStatementActualSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP6FC3Amt * FT.IncomeStatementActualSign) )
				END AS [Period 6 Forecast 3 Amount] 
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP7FC3Amt * FT.IncomeStatementActualSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP7FC3Amt * FT.IncomeStatementActualSign) )
				END AS [Period 7 Forecast 3 Amount] 
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP8FC3Amt * FT.IncomeStatementActualSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP8FC3Amt * FT.IncomeStatementActualSign) )
				END AS [Period 8 Forecast 3 Amount] 
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP9FC3Amt * FT.IncomeStatementActualSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP9FC3Amt * FT.IncomeStatementActualSign) )
				END AS [Period 9 Forecast 3 Amount] 
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP10FC3Amt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP10FC3Amt * FT.IncomeStatementBudgetSign) )
				END AS [Period 10 Forecast 3 Amount] 
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP11FC3Amt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP11FC3Amt * FT.IncomeStatementBudgetSign) )
							END AS [Period 11 Forecast 3 Amount] 
		,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP12FC3Amt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP12FC3Amt * FT.IncomeStatementBudgetSign) )
							END AS [Period 12 Forecast 3 Amount]

FROM        FactProfitAndLossSummary   AS PL 
				LEFT OUTER JOIN MapFinancialTemplate as FT   ON FT.AccountSkey = PL.AccountSkey 
				INNER JOIN [dbo].[DimOrganization] as DO ON PL.OrgSkey = DO.OrgSkey
				INNER JOIN DimCalendarPeriod AS CP ON PL.PostPeriodSkey = CP.FiscalPeriodSkey
		WHERE        (PL.PostPeriodSkey = @pFiscalPeriod) 
					AND (FT.TemplateID = @pTemplate)
					AND PL.OrgSkey IN	( Select * from STRING_SPLIT(@pOrg, ',')
					)
		GROUP BY    FT.GroupID 
					 ,FT.TemplateID
					 ,PL.[OrgSkey]
					 ,DO.BusinessUnitID
					 ,CP.FiscalPeriodNumber
					 ,SortOrder, 
						Case @pLanguage When @ENLanguage THEN FT.GroupDescEN 
									  WHEN @FRLanguage THEN FT.GroupDescFR
									  Else 'Unknown'
						END
					,[HeaderLine]
					,[ShowDetail]
					,[InsertSkipLineBefore]
					,[SkipLine]
					,[IsMarkup]
					,[IsNetRevenues]
					,[IsDirectLabor]
					,[IsFringeBenefitsPct]
					,[IsFringeBenefits]
					,[IsManagementSalaries]
					,[IsMarketingSalaries]
					,[IsTrainingSalaries]
					,[IsEBGEPct]
					,[IsEBGE]
					,[IsEBREPct]
					,[IsEBRE]
					,[IsEBITDAPct]
					,[IsEBITDA]
					,[IsCalculatedUtilizationPct]
					)CYPL
					INNER JOIN [dbo].[DimOrganization] as DO ON CYPL.OrgSkey = DO.OrgSkey
	
		)	

--Select * INTO @PandL_TwelveMonths_CorporateExpense FROM  ProfitandLossCTE;
--INSERT INTO @PandL_TwelveMonths_CorporateExpense 
--SELECT * FROM ProfitandLossCTE
 

,PandLCorporateExpenseCTE(TemplateID, GroupID ,GroupDesc
				,Group1Level,Group2Level,Group3Level, Group1LevelID,Group2LevelID,Group3LevelID, [HeaderLine],[ShowDetail],[InsertSkipLineBefore],[SkipLine]
			,[IsMarkup],[IsNetRevenues],[IsDirectLabor],[IsFringeBenefitsPct],[IsFringeBenefits]
			,[IsManagementSalaries],[IsMarketingSalaries],[IsTrainingSalaries],[IsEBGEPct],[IsEBGE]
			,[IsEBREPct],[IsEBRE],[IsEBITDAPct],[IsEBITDA] ,[IsCalculatedUtilizationPct],SortOrder,FiscalPeriodNumber
			,[Current Month Amount],[LY Current Month Amount],[Current Month Budget Amount],[YTD Amount],[LY YTD Amount]
			,[Current Month Forecast 1 Amount],[Current Month Forecast 2 Amount],[Current Month Forecast 3 Amount]
			,[YTD Budget Amount],[LY YTD Budget Amount]
			,[Current Year Budget Amount]
			,[YTD Forecast 1 Amount],[YTD Forecast 2 Amount],[YTD Forecast 3 Amount]
			,[QTD Amount],[LY QTD Amount],[QTD Budget Amount]
			,[QTD Forecast 1 Amount],[QTD Forecast 2 Amount],[QTD Forecast 3 Amount]
			,[Period 1 Actual Amount],[Period 2 Actual Amount],[Period 3 Actual Amount],[Period 4 Actual Amount]
			,[Period 5 Actual Amount],[Period 6 Actual Amount],[Period 7 Actual Amount],[Period 8 Actual Amount]
			,[Period 9 Actual Amount],[Period 10 Actual Amount],[Period 11 Actual Amount],[Period 12 Actual Amount]
			,[Period 1 Budget Amount],[Period 2 Budget Amount],[Period 3 Budget Amount],[Period 4 Budget Amount]
			,[Period 5 Budget Amount],[Period 6 Budget Amount],[Period 7 Budget Amount],[Period 8 Budget Amount]
			,[Period 9 Budget Amount],[Period 10 Budget Amount],[Period 11 Budget Amount],[Period 12 Budget Amount]
			,[Period 1 Forecast 1 Amount],[Period 2 Forecast 1 Amount],[Period 3 Forecast 1 Amount],[Period 4 Forecast 1 Amount]
			,[Period 5 Forecast 1 Amount],[Period 6 Forecast 1 Amount],[Period 7 Forecast 1 Amount],[Period 8 Forecast 1 Amount]
			,[Period 9 Forecast 1 Amount],[Period 10 Forecast 1 Amount],[Period 11 Forecast 1 Amount],[Period 12 Forecast 1 Amount]
			,[Period 1 Forecast 2 Amount],[Period 2 Forecast 2 Amount],[Period 3 Forecast 2 Amount],[Period 4 Forecast 2 Amount]
			,[Period 5 Forecast 2 Amount],[Period 6 Forecast 2 Amount],[Period 7 Forecast 2 Amount],[Period 8 Forecast 2 Amount]
			,[Period 9 Forecast 2 Amount],[Period 10 Forecast 2 Amount],[Period 11 Forecast 2 Amount],[Period 12 Forecast 2 Amount]
			,[Period 1 Forecast 3 Amount],[Period 2 Forecast 3 Amount],[Period 3 Forecast 3 Amount],[Period 4 Forecast 3 Amount]
			,[Period 5 Forecast 3 Amount],[Period 6 Forecast 3 Amount],[Period 7 Forecast 3 Amount],[Period 8 Forecast 3 Amount]
			,[Period 9 Forecast 3 Amount],[Period 10 Forecast 3 Amount],[Period 11 Forecast 3 Amount],[Period 12 Forecast 3 Amount]			
			
		)
		AS
		(
SELECT 
				TemplateID,  
				GroupId
				, GroupDesc
				,Group1Level,Group2Level,Group3Level
				,Group1LevelID,Group2LevelID,Group3LevelID								
				,[HeaderLine]
				,[ShowDetail]
					,[InsertSkipLineBefore]
					,[SkipLine]
					,[IsMarkup]
					,[IsNetRevenues]
					,[IsDirectLabor]
					,[IsFringeBenefitsPct]
					,[IsFringeBenefits]
					,[IsManagementSalaries]
					,[IsMarketingSalaries]
					,[IsTrainingSalaries]
					,[IsEBGEPct]
					,[IsEBGE]
					,[IsEBREPct]
					,[IsEBRE]
					,[IsEBITDAPct]
					,[IsEBITDA]
					,[IsCalculatedUtilizationPct]
					,SortOrder
					 ,FiscalPeriodNumber
						,SUM([Current Month Amount]) AS [Current Month Amount]
						,SUM([LY Current Month Amount]) as [LY Current Month Amount]
							,SUM([Current Month Budget Amount]) AS [Current Month Budget Amount]
							,SUM([YTD Amount]) as [YTD Amount]
							,SUM([LY YTD Amount]) as [LY YTD Amount]
							,SUM([Current Month Forecast 1 Amount]) as [Current Month Forecast 1 Amount]
							,SUM([Current Month Forecast 2 Amount]) as [Current Month Forecast 2 Amount]
							,SUM([Current Month Forecast 3 Amount]) AS [Current Month Forecast 3 Amount]
							,SUM([YTD Budget Amount]) AS [YTD Budget Amount]
							,SUM([LY YTD Budget Amount]) as [LY YTD Budget Amount]
							,SUM([Current Year Budget Amount]) as [Current Year Budget Amount]
							,SUM([YTD Forecast 1 Amount]) as [YTD Forecast 1 Amount]
							,SUM([YTD Forecast 2 Amount]) as [YTD Forecast 2 Amount]
							,SUM([YTD Forecast 3 Amount]) as [YTD Forecast 3 Amount]							
							,SUM([QTD Amount]) AS [QTD Amount]
							,SUM([LY QTD Amount]) AS [LY QTD Amount]
							,SUM([QTD Budget Amount]) AS [QTD Budget Amount]							
							,SUM([QTD Forecast 1 Amount]) AS [QTD Forecast 1 Amount]
							,SUM([QTD Forecast 2 Amount]) AS [QTD Forecast 2 Amount]
							,SUM([QTD Forecast 3 Amount]) AS [QTD Forecast 3 Amount]
							,SUM([Period 1 Actual Amount]) AS [Period 1 Actual Amount]
							,SUM([Period 2 Actual Amount]) AS [Period 2 Actual Amount]
							,SUM([Period 3 Actual Amount]) AS [Period 3 Actual Amount]
							,SUM([Period 4 Actual Amount]) AS [Period 4 Actual Amount]
							,SUM([Period 5 Actual Amount]) AS [Period 5 Actual Amount]
							,SUM([Period 6 Actual Amount]) AS [Period 6 Actual Amount]
							,SUM([Period 7 Actual Amount]) AS [Period 7 Actual Amount]
							,SUM([Period 8 Actual Amount]) AS [Period 8 Actual Amount]
							,SUM([Period 9 Actual Amount]) AS [Period 9 Actual Amount]
							,SUM([Period 10 Actual Amount]) AS [Period 10 Actual Amount]
							,SUM([Period 11 Actual Amount]) AS [Period 11 Actual Amount]
							,SUM([Period 12 Actual Amount]) AS [Period 12 Actual Amount]
							,SUM([Period 1 Budget Amount]) AS [Period 1 Budget Amount]
							,SUM([Period 2 Budget Amount]) AS [Period 2 Budget Amount]
							,SUM([Period 3 Budget Amount]) AS [Period 3 Budget Amount]
							,SUM([Period 4 Budget Amount]) AS [Period 4 Budget Amount]
							,SUM([Period 5 Budget Amount]) AS [Period 5 Budget Amount]
							,SUM([Period 6 Budget Amount]) AS [Period 6 Budget Amount]
							,SUM([Period 7 Budget Amount]) AS [Period 7 Budget Amount]
							,SUM([Period 8 Budget Amount]) AS [Period 8 Budget Amount]
							,SUM([Period 9 Budget Amount]) AS [Period 9 Budget Amount]
							,SUM([Period 10 Budget Amount]) AS [Period 10 Budget Amount]
							,SUM([Period 11 Budget Amount]) AS [Period 11 Budget Amount]
							,SUM([Period 12 Budget Amount]) AS [Period 12 Budget Amount]
							,SUM([Period 1 Forecast 1 Amount]) AS [Period 1 Forecast 1 Amount]
							,SUM([Period 2 Forecast 1 Amount]) AS [Period 2 Forecast 1 Amount]
							,SUM([Period 3 Forecast 1 Amount]) AS [Period 3 Forecast 1 Amount]
							,SUM([Period 4 Forecast 1 Amount]) AS [Period 4 Forecast 1 Amount]
							,SUM([Period 5 Forecast 1 Amount]) AS [Period 5 Forecast 1 Amount]
							,SUM([Period 6 Forecast 1 Amount]) AS [Period 6 Forecast 1 Amount]
							,SUM([Period 7 Forecast 1 Amount]) AS [Period 7 Forecast 1 Amount]
							,SUM([Period 8 Forecast 1 Amount]) AS [Period 8 Forecast 1 Amount]
							,SUM([Period 9 Forecast 1 Amount]) AS [Period 9 Forecast 1 Amount]
							,SUM([Period 10 Forecast 1 Amount]) AS [Period 10 Forecast 1 Amount]
							,SUM([Period 11 Forecast 1 Amount]) AS [Period 11 Forecast 1 Amount]
							,SUM([Period 12 Forecast 1 Amount]) AS [Period 12 Forecast 1 Amount]
							,SUM([Period 1 Forecast 2 Amount]) AS [Period 1 Forecast 2 Amount]
							,SUM([Period 2 Forecast 2 Amount]) AS [Period 2 Forecast 2 Amount]
							,SUM([Period 3 Forecast 2 Amount]) AS [Period 3 Forecast 2 Amount]
							,SUM([Period 4 Forecast 2 Amount]) AS [Period 4 Forecast 2 Amount]
							,SUM([Period 5 Forecast 2 Amount]) AS [Period 5 Forecast 2 Amount]
							,SUM([Period 6 Forecast 2 Amount]) AS [Period 6 Forecast 2 Amount]
							,SUM([Period 7 Forecast 2 Amount]) AS [Period 7 Forecast 2 Amount]
							,SUM([Period 8 Forecast 2 Amount]) AS [Period 8 Forecast 2 Amount]
							,SUM([Period 9 Forecast 2 Amount]) AS [Period 9 Forecast 2 Amount]
							,SUM([Period 10 Forecast 2 Amount]) AS [Period 10 Forecast 2 Amount]
							,SUM([Period 11 Forecast 2 Amount]) AS [Period 11 Forecast 2 Amount]
							,SUM([Period 12 Forecast 2 Amount]) AS [Period 12 Forecast 2 Amount]
							,SUM([Period 1 Forecast 3 Amount]) AS [Period 1 Forecast 3 Amount]
							,SUM([Period 2 Forecast 3 Amount]) AS [Period 2 Forecast 3 Amount]
							,SUM([Period 3 Forecast 3 Amount]) AS [Period 3 Forecast 3 Amount]
							,SUM([Period 4 Forecast 3 Amount]) AS [Period 4 Forecast 3 Amount]
							,SUM([Period 5 Forecast 3 Amount]) AS [Period 5 Forecast 3 Amount]
							,SUM([Period 6 Forecast 3 Amount]) AS [Period 6 Forecast 3 Amount]
							,SUM([Period 7 Forecast 3 Amount]) AS [Period 7 Forecast 3 Amount]
							,SUM([Period 8 Forecast 3 Amount]) AS [Period 8 Forecast 3 Amount]
							,SUM([Period 9 Forecast 3 Amount]) AS [Period 9 Forecast 3 Amount]
							,SUM([Period 10 Forecast 3 Amount]) AS [Period 10 Forecast 3 Amount]
							,SUM([Period 11 Forecast 3 Amount]) AS [Period 11 Forecast 3 Amount]
							,SUM([Period 12 Forecast 3 Amount])	AS 	[Period 12 Forecast 3 Amount]
							
	
		--from @PandL_TwelveMonths_CorporateExpense
		--dbo.#PandL_TwelveMonths_CorporateExpense --dbo.PandL_TwelveMonths_CorporateExpense
		--[dbo].[Fact_PandLSummary_TwelveMonths_CorporateExpense]
		FROM ProfitandLossCTE
	
--/**		
		GROUP BY	TemplateID
					,GroupId
					, GroupDesc 
					,Group1Level,Group2Level,Group3Level
					,Group1LevelID,Group2LevelID,Group3LevelID															
					,[HeaderLine]
					,[ShowDetail]
					,[InsertSkipLineBefore]
					,[SkipLine]
					,[IsMarkup]
					,[IsNetRevenues]
					,[IsDirectLabor]
					,[IsFringeBenefitsPct]
					,[IsFringeBenefits]
					,[IsManagementSalaries]
					,[IsMarketingSalaries]
					,[IsTrainingSalaries]
					,[IsEBGEPct]
					,[IsEBGE]
					,[IsEBREPct]
					,[IsEBRE]
					,[IsEBITDAPct]
					,[IsEBITDA]
					,[IsCalculatedUtilizationPct]
					,SortOrder
					 ,FiscalPeriodNumber
		)
		SELECT 
						Template.Group1Level,Template.Group2Level,Template.Group3Level,
						Template.Group1LevelID,Template.Group2LevelID,Template.Group3LevelID
						,Template.TemplateID
						,Template.GroupID, Template.GroupDesc, Template.GroupType, Template.SortOrder,FiscalPeriodNumber
						,Template.[HeaderLine], Template.[ShowDetail], Template.[InsertSkipLineBefore], Template.[SkipLine]
						,Template.[IsMarkup],Template.[IsFringeBenefitsPct],Template.[IsEBGEPct],Template.[IsEBREPct]						
						,Template.[IsEBITDAPct],Template.[IsCalculatedUtilizationPct]
						,ISNULL([Current Month Amount], 0.000000) AS [Current Month Amount],ISNULL([LY Current Month Amount], 0.000000) AS [LY Current Month Amount],ISNULL([Current Month Budget Amount], 0.000000) AS [Current Month Budget Amount]
						,ISNULL([YTD Amount], 0.000000) AS [YTD Amount],ISNULL([LY YTD Amount], 0.000000) AS [LY YTD Amount]
						,ISNULL([Current Month Forecast 1 Amount], 0.000000) AS [Current Month Forecast 1 Amount],ISNULL([Current Month Forecast 2 Amount], 0.000000) AS [Current Month Forecast 2 Amount],ISNULL([Current Month Forecast 3 Amount], 0.000000) AS [Current Month Forecast 3 Amount]
						,ISNULL([YTD Budget Amount], 0.000000) AS [YTD Budget Amount],ISNULL([LY YTD Budget Amount], 0.000000) AS [LY YTD Budget Amount]
						,ISNULL([Current Year Budget Amount], 0.000000) AS [Current Year Budget Amount]
						,ISNULL([YTD Forecast 1 Amount], 0.000000) AS [YTD Forecast 1 Amount],ISNULL([YTD Forecast 2 Amount], 0.000000) AS [YTD Forecast 2 Amount],ISNULL([YTD Forecast 3 Amount], 0.000000) AS [YTD Forecast 3 Amount]
						,ISNULL([QTD Amount], 0.000000) AS [QTD Amount],ISNULL([LY QTD Amount], 0.000000) AS [LY QTD Amount],ISNULL([QTD Budget Amount], 0.000000) AS [QTD Budget Amount]
						,ISNULL([QTD Forecast 1 Amount], 0.000000) AS [QTD Forecast 1 Amount],ISNULL([QTD Forecast 2 Amount], 0.000000) AS [QTD Forecast 2 Amount],ISNULL([QTD Forecast 3 Amount], 0.000000) AS [QTD Forecast 3 Amount]
						,ISNULL([Period 1 Actual Amount], 0.000000) AS [Period 1 Actual Amount],ISNULL([Period 2 Actual Amount], 0.000000) AS [Period 2 Actual Amount],ISNULL([Period 3 Actual Amount], 0.000000) AS [Period 3 Actual Amount],ISNULL([Period 4 Actual Amount], 0.000000) AS [Period 4 Actual Amount]
						,ISNULL([Period 5 Actual Amount], 0.000000) AS [Period 5 Actual Amount],ISNULL([Period 6 Actual Amount], 0.000000) AS [Period 6 Actual Amount],ISNULL([Period 7 Actual Amount], 0.000000) AS [Period 7 Actual Amount],ISNULL([Period 8 Actual Amount], 0.000000) AS [Period 8 Actual Amount]
						,ISNULL([Period 9 Actual Amount], 0.000000) AS [Period 9 Actual Amount],ISNULL([Period 10 Actual Amount], 0.000000) AS [Period 10 Actual Amount],ISNULL([Period 11 Actual Amount], 0.000000) AS [Period 11 Actual Amount],ISNULL([Period 12 Actual Amount], 0.000000) AS [Period 12 Actual Amount]
						,ISNULL([Period 1 Budget Amount], 0.000000) AS [Period 1 Budget Amount],ISNULL([Period 2 Budget Amount], 0.000000) AS [Period 2 Budget Amount],ISNULL([Period 3 Budget Amount], 0.000000) AS [Period 3 Budget Amount],ISNULL([Period 4 Budget Amount], 0.000000) AS [Period 4 Budget Amount]
						,ISNULL([Period 5 Budget Amount], 0.000000) AS [Period 5 Budget Amount],ISNULL([Period 6 Budget Amount], 0.000000) AS [Period 6 Budget Amount],ISNULL([Period 7 Budget Amount], 0.000000) AS [Period 7 Budget Amount],ISNULL([Period 8 Budget Amount], 0.000000) AS [Period 8 Budget Amount]
						,ISNULL([Period 9 Budget Amount], 0.000000) AS [Period 9 Budget Amount],ISNULL([Period 10 Budget Amount], 0.000000) AS [Period 10 Budget Amount],ISNULL([Period 11 Budget Amount], 0.000000) AS [Period 11 Budget Amount],ISNULL([Period 12 Budget Amount], 0.000000) [Period 12 Budget Amount]						
						,ISNULL([Period 1 Forecast 1 Amount], 0.000000) AS [Period 1 Forecast 1 Amount],ISNULL([Period 2 Forecast 1 Amount], 0.000000) AS [Period 2 Forecast 1 Amount],ISNULL([Period 3 Forecast 1 Amount], 0.000000) AS [Period 3 Forecast 1 Amount],ISNULL([Period 4 Forecast 1 Amount], 0.000000) AS [Period 4 Forecast 1 Amount]
						,ISNULL([Period 5 Forecast 1 Amount], 0.000000) AS [Period 5 Forecast 1 Amount],ISNULL([Period 6 Forecast 1 Amount], 0.000000) AS [Period 6 Forecast 1 Amount],ISNULL([Period 7 Forecast 1 Amount], 0.000000) AS [Period 7 Forecast 1 Amount],ISNULL([Period 8 Forecast 1 Amount], 0.000000) AS [Period 8 Forecast 1 Amount]
						,ISNULL([Period 9 Forecast 1 Amount], 0.000000) AS [Period 9 Forecast 1 Amount],ISNULL([Period 10 Forecast 1 Amount], 0.000000) AS [Period 10 Forecast 1 Amount],ISNULL([Period 11 Forecast 1 Amount], 0.000000) AS [Period 11 Forecast 1 Amount],ISNULL([Period 12 Forecast 1 Amount], 0.000000) AS [Period 12 Forecast 1 Amount]
						,ISNULL([Period 1 Forecast 2 Amount], 0.000000) AS [Period 1 Forecast 2 Amount],ISNULL([Period 2 Forecast 2 Amount], 0.000000) AS [Period 2 Forecast 2 Amount],ISNULL([Period 3 Forecast 2 Amount], 0.000000) AS [Period 3 Forecast 2 Amount],ISNULL([Period 4 Forecast 2 Amount], 0.000000) AS [Period 4 Forecast 2 Amount]
						,ISNULL([Period 5 Forecast 2 Amount], 0.000000) AS [Period 5 Forecast 2 Amount],ISNULL([Period 6 Forecast 2 Amount], 0.000000) AS [Period 6 Forecast 2 Amount],ISNULL([Period 7 Forecast 2 Amount], 0.000000) [Period 7 Forecast 2 Amount] ,ISNULL([Period 8 Forecast 2 Amount], 0.000000) AS [Period 8 Forecast 2 Amount]
						,ISNULL([Period 9 Forecast 2 Amount], 0.000000) AS [Period 9 Forecast 2 Amount],ISNULL([Period 10 Forecast 2 Amount], 0.000000) AS [Period 10 Forecast 2 Amount],ISNULL([Period 11 Forecast 2 Amount], 0.000000) AS [Period 11 Forecast 2 Amount],ISNULL([Period 12 Forecast 2 Amount], 0.000000) AS [Period 12 Forecast 2 Amount]
						,ISNULL([Period 1 Forecast 3 Amount], 0.000000) AS [Period 1 Forecast 3 Amount],ISNULL([Period 2 Forecast 3 Amount], 0.000000) AS [Period 2 Forecast 3 Amount],ISNULL([Period 3 Forecast 3 Amount], 0.000000) AS [Period 3 Forecast 3 Amount],ISNULL([Period 4 Forecast 3 Amount], 0.000000) AS [Period 4 Forecast 3 Amount]
						,ISNULL([Period 5 Forecast 3 Amount], 0.000000) AS [Period 5 Forecast 3 Amount],ISNULL([Period 6 Forecast 3 Amount], 0.000000) AS [Period 6 Forecast 3 Amount],ISNULL([Period 7 Forecast 3 Amount], 0.000000) AS [Period 7 Forecast 3 Amount],ISNULL([Period 8 Forecast 3 Amount], 0.000000) AS [Period 8 Forecast 3 Amount]
						,ISNULL([Period 9 Forecast 3 Amount], 0.000000) AS [Period 9 Forecast 3 Amount],ISNULL([Period 10 Forecast 3 Amount], 0.000000) AS [Period 10 Forecast 3 Amount],ISNULL([Period 11 Forecast 3 Amount], 0.000000) AS [Period 11 Forecast 3 Amount],ISNULL([Period 12 Forecast 3 Amount], 0.000000) AS [Period 12 Forecast 3 Amount]
						,ISNULL([LY Period 1 Actual Amount], 0.000000) AS [LY Period 1 Actual Amount],ISNULL([LY Period 2 Actual Amount], 0.000000) AS [LY Period 2 Actual Amount],ISNULL([LY Period 3 Actual Amount], 0.000000) AS [LY Period 3 Actual Amount],ISNULL([LY Period 4 Actual Amount], 0.000000) AS [LY Period 4 Actual Amount]
						,ISNULL([LY Period 5 Actual Amount], 0.000000) AS [LY Period 5 Actual Amount],ISNULL([LY Period 6 Actual Amount], 0.000000) AS [LY Period 6 Actual Amount],ISNULL([LY Period 7 Actual Amount], 0.000000) AS [LY Period 7 Actual Amount],ISNULL([LY Period 8 Actual Amount], 0.000000) AS [LY Period 8 Actual Amount]
						,ISNULL([LY Period 9 Actual Amount], 0.000000) AS [LY Period 9 Actual Amount],ISNULL([LY Period 10 Actual Amount], 0.000000) AS [LY Period 10 Actual Amount],ISNULL([LY Period 11 Actual Amount], 0.000000) AS [LY Period 11 Actual Amount],ISNULL([LY Period 12 Actual Amount], 0.000000) AS [LY Period 12 Actual Amount]
						,ISNULL(NRCTE.[Current_Net_Revenues], 0.000000) AS [Current_Net_Revenues], ISNULL(NRCTE.Budget_Current_Net_Revenues,0.000000) AS Budget_Current_Net_Revenues, ISNULL(NRCTE.Forecast_Current_Net_Revenues_Q1,0.000000) AS Forecast_Current_Net_Revenues_Q1, ISNULL(NRCTE.Forecast_Current_Net_Revenues_Q2,0.000000) AS Forecast_Current_Net_Revenues_Q2
						,ISNULL(NRCTE.Forecast_Current_Net_Revenues_Q3,0.0000000) AS Forecast_Current_Net_Revenues_Q3
						,ISNULL(NRCTE.YTD_Net_Revenues,0.000000) AS YTD_Net_Revenues,ISNULL(NRCTE.Budget_YTD_Net_Revenues,0.000000) AS Budget_YTD_Net_Revenues, ISNULL(NRCTE.Forecast_YTD_Net_Revenues_Q1,0.000000) AS Forecast_YTD_Net_Revenues_Q1
						,ISNULL(NRCTE.Forecast_YTD_Net_Revenues_Q2,0.000000) AS Forecast_YTD_Net_Revenues_Q2, ISNULL(NRCTE.Forecast_YTD_Net_Revenues_Q3,0.000000) AS Forecast_YTD_Net_Revenues_Q3, ISNULL(NRCTE.[Budget_Amount_Net_Revenues], 0.000000) AS [Budget_Amount_Net_Revenues]
						,ISNULL(NRCTE.QTD_Net_Revenues,0.000000) AS QTD_Net_Revenues, ISNULL(NRCTE.Budget_QTD_Net_Revenues,0.000000) AS Budget_QTD_Net_Revenues, ISNULL(NRCTE.Forecast_QTD_Net_Revenues_Q1,0.000000) AS Forecast_QTD_Net_Revenues_Q1
						,ISNULL(NRCTE.Forecast_QTD_Net_Revenues_Q2,0.000000) AS Forecast_QTD_Net_Revenues_Q2, ISNULL(NRCTE.Forecast_QTD_Net_Revenues_Q3,0.000000) AS Forecast_QTD_Net_Revenues_Q3 
						,ISNULL(NRCTE.LY_Current_Net_Revenues,0.000000) AS LY_Current_Net_Revenues, ISNULL(NRCTE.LY_YTD_Net_Revenues,0.000000) AS LY_YTD_Net_Revenues, ISNULL(NRCTE.LY_Budget_YTD_Net_Revenues,0.000000) AS LY_Budget_YTD_Net_Revenues, ISNULL(NRCTE.LY_QTD_Net_Revenues,0.000000) LY_QTD_Net_Revenues
		--FROM PandLCorporateExpenseCTE
		FROM 
			  (		SELECT Group1Level,Group2Level,Group3Level,Group1LevelID,Group2LevelID,Group3LevelID,Templ.*
			
						FROM	(select Distinct TemplateID
									,GroupID 
								  ,Case @pLanguage When @ENLanguage THEN GroupDescEN 
									  WHEN @FRLanguage THEN GroupDescFR
									  Else 'Unknown'
									END as GroupDesc
									,GroupType
									,Sortorder 
									,[HeaderLine]
									,[ShowDetail]
									,[InsertSkipLineBefore]
									,[SkipLine]
									,[IsMarkup]
									,[IsFringeBenefitsPct]
									,[IsEBGEPct]						
									,[IsEBREPct]						
									,[IsEBITDAPct]							
									,[IsCalculatedUtilizationPct]
						from [dbo].[MapFinancialTemplate] MT
						WHERE [TemplateID] = @pTemplate 
						)Templ
						 CROSS JOIN ( Select Distinct Group1Level,Group2Level,Group3Level,Group1LevelID,Group2LevelID,Group3LevelID
										FROM PandLCorporateExpenseCTE
										)DistGroup
						)Template
				LEFT OUTER JOIN PandLCorporateExpenseCTE as PCTE ON Template.TemplateID = PCTE.TemplateID
													AND Template.GroupID = PCTE.GroupId
													AND Template.Group1level = PCTE.Group1level
													AND Template.Group2level = PCTE.Group2level
													AND Template.Group3level = PCTE.Group3level
				

			 LEFT OUTER JOIN(
					Select  GroupID,Group1Level,Group2Level,Group3Level
						,[Current Month Amount] as [Current_Net_Revenues]
						,[LY Current Month Amount] as [LY_Current_Net_Revenues]
						,[Current Month Budget Amount] as   [Budget_Current_Net_Revenues]
						,[Current Month Forecast 1 Amount] as [Forecast_Current_Net_Revenues_Q1]
						,[Current Month Forecast 2 Amount] as [Forecast_Current_Net_Revenues_Q2]
						,[Current Month Forecast 3 Amount] as [Forecast_Current_Net_Revenues_Q3]
						,[YTD Amount] as [YTD_Net_Revenues]
						,[LY YTD Amount] as [LY_YTD_Net_Revenues]
						,[YTD Budget Amount] as [Budget_YTD_Net_Revenues]
						,[LY YTD Budget Amount] as [LY_Budget_YTD_Net_Revenues]
						,[YTD Forecast 1 Amount] as  [Forecast_YTD_Net_Revenues_Q1]
						,[YTD Forecast 2 Amount] as  [Forecast_YTD_Net_Revenues_Q2]
						,[YTD Forecast 3 Amount] as  [Forecast_YTD_Net_Revenues_Q3]
						,[QTD Amount] as [QTD_Net_Revenues]
						,[LY QTD Amount] as [LY_QTD_Net_Revenues]
						,[QTD Budget Amount] as [Budget_QTD_Net_Revenues]
						,[QTD Forecast 1 Amount] as [Forecast_QTD_Net_Revenues_Q1]
						,[QTD Forecast 2 Amount] as [Forecast_QTD_Net_Revenues_Q2]
						,[QTD Forecast 3 Amount] as [Forecast_QTD_Net_Revenues_Q3]
						,[Current Year Budget Amount]  as [Budget_Amount_Net_Revenues]
				FROM PandLCorporateExpenseCTE 
				WHERE [IsNetRevenues] = 'Y')NRCTE  on   --(Template.GroupId is not NULL)
												Template.Group1level = NRCTE.Group1level
											AND Template.Group2level = NRCTE.Group2level
												AND Template.Group3level = NRCTE.Group3level

				LEFT OUTER JOIN ( SELECT GROUPID
					 ,Group1Level
					 ,Group1LevelID
					 ,Group2Level
					 ,Group2LevelID
					 ,Group3Level
					 ,Group3LevelID
					,TemplateID
					,GroupDesc
					,SUM([LY Period 1 Actual Amount]) AS [LY Period 1 Actual Amount]
					,SUM([LY Period 2 Actual Amount]) AS [LY Period 2 Actual Amount]
					,SUM([LY Period 3 Actual Amount]) AS [LY Period 3 Actual Amount]
					,SUM([LY Period 4 Actual Amount]) AS [LY Period 4 Actual Amount]
					,SUM([LY Period 5 Actual Amount]) AS [LY Period 5 Actual Amount]
					,SUM([LY Period 6 Actual Amount]) AS [LY Period 6 Actual Amount]
					,SUM([LY Period 7 Actual Amount]) AS [LY Period 7 Actual Amount]
					,SUM([LY Period 8 Actual Amount]) AS [LY Period 8 Actual Amount]
					,SUM([LY Period 9 Actual Amount]) AS [LY Period 9 Actual Amount]
					,SUM([LY Period 10 Actual Amount]) AS [LY Period 10 Actual Amount]
					,SUM([LY Period 11 Actual Amount]) AS [LY Period 11 Actual Amount]
					,SUM([LY Period 12 Actual Amount]) AS [LY Period 12 Actual Amount]

		FROM (
		SELECT  	CYPL.TemplateID
					,CYPL.BusinessUnitID
					,CYPL.OrgSkey
					,CYPL.GroupId
					,CYPL.GroupDesc	
					,Case @pLanguage When @ENLanguage THEN	Case @pGroup1Level	WHEN 'A' THEN	[TerritoryDescEN]
												WHEN 'I' THEN	[ProductLineDescEN]
												WHEN 'B' THEN	[GeographicRegionDescEN]
												WHEN 'C' THEN	[CompanyDescEN]
												WHEN 'D' THEN	[RegionDescEN]
												WHEN 'E' THEN	[MarketSegmentDescEN]
												WHEN 'F' THEN	[SubMarketSegmentDescEN]
												WHEN 'G' THEN	[LocationDescEN]
												WHEN 'H' THEN	[BusinessUnitDescEN]
												WHEN 'Z' THEN	'None'
												END
									 WHEN @FRLanguage THEN CASE  @pGroup1Level	WHEN 'A' THEN	[TerritoryDescFR]
												WHEN 'I' THEN	[ProductLineDescFR]
												WHEN 'B' THEN	[GeographicRegionDescFR]
												WHEN 'C' THEN	[CompanyDescFR]
												WHEN 'D' THEN	[RegionDescFR]
												WHEN 'E' THEN	[MarketSegmentDescFR]
												WHEN 'F' THEN	[SubMarketSegmentDescFR]
												WHEN 'G' THEN	[LocationDescFR]
												WHEN 'H' THEN	[BusinessUnitDescFR]
												WHEN 'Z' THEN	'None'
												END
							END as Group1Level
					,Case @pLanguage When @ENLanguage THEN	Case @pGroup2Level	WHEN 'A' THEN	[TerritoryDescEN]
												WHEN 'I' THEN	[ProductLineDescEN]
												WHEN 'B' THEN	[GeographicRegionDescEN]
												WHEN 'C' THEN	[CompanyDescEN]
												WHEN 'D' THEN	[RegionDescEN]
												WHEN 'E' THEN	[MarketSegmentDescEN]
												WHEN 'F' THEN	[SubMarketSegmentDescEN]
												WHEN 'G' THEN	[LocationDescEN]
												WHEN 'H' THEN	[BusinessUnitDescEN]
												WHEN 'Z' THEN	'None'
												END
									 WHEN @FRLanguage THEN CASE  @pGroup2Level	WHEN 'A' THEN	[TerritoryDescFR]
												WHEN 'I' THEN	[ProductLineDescFR]
												WHEN 'B' THEN	[GeographicRegionDescFR]
												WHEN 'C' THEN	[CompanyDescFR]
												WHEN 'D' THEN	[RegionDescFR]
												WHEN 'E' THEN	[MarketSegmentDescFR]
												WHEN 'F' THEN	[SubMarketSegmentDescFR]
												WHEN 'G' THEN	[LocationDescFR]
												WHEN 'H' THEN	[BusinessUnitDescFR]
												WHEN 'Z' THEN	'None'
												END
							END as Group2Level
					,Case @pLanguage When @ENLanguage THEN	Case @pGroup3Level	WHEN 'A' THEN	[TerritoryDescEN]
												WHEN 'I' THEN	[ProductLineDescEN]
												WHEN 'B' THEN	[GeographicRegionDescEN]
												WHEN 'C' THEN	[CompanyDescEN]
												WHEN 'D' THEN	[RegionDescEN]
												WHEN 'E' THEN	[MarketSegmentDescEN]
												WHEN 'F' THEN	[SubMarketSegmentDescEN]
												WHEN 'G' THEN	[LocationDescEN]
												WHEN 'H' THEN	[BusinessUnitDescEN]
												WHEN 'Z' THEN	'None'
												END
									 WHEN @FRLanguage THEN CASE  @pGroup3Level	WHEN 'A' THEN	[TerritoryDescFR]
												WHEN 'I' THEN	[ProductLineDescFR]
												WHEN 'B' THEN	[GeographicRegionDescFR]
												WHEN 'C' THEN	[CompanyDescFR]
												WHEN 'D' THEN	[RegionDescFR]
												WHEN 'E' THEN	[MarketSegmentDescFR]
												WHEN 'F' THEN	[SubMarketSegmentDescFR]
												WHEN 'G' THEN	[LocationDescFR]
												WHEN 'H' THEN	[BusinessUnitDescFR]
												WHEN 'Z' THEN	'None'
												END
							END as Group3Level
					,Case @pGroup1Level			WHEN 'I' THEN	[ProductLineID]
												WHEN 'B' THEN	[GeographicRegionID]
												WHEN 'C' THEN	[CompanyID]
												WHEN 'D' THEN	[RegionID]
												WHEN 'E' THEN	[MarketSegmentID]
												WHEN 'F' THEN	[SubMarketSegmentID]
												WHEN 'G' THEN	[LocationID]
												WHEN 'H' THEN	CYPL.[BusinessUnitID]
												WHEN 'Z' THEN	'None'
												
							END as Group1LevelID
					,Case @pGroup2Level			WHEN 'I' THEN	[ProductLineID]
												WHEN 'B' THEN	[GeographicRegionID]
												WHEN 'C' THEN	[CompanyID]
												WHEN 'D' THEN	[RegionID]
												WHEN 'E' THEN	[MarketSegmentID]
												WHEN 'F' THEN	[SubMarketSegmentID]
												WHEN 'G' THEN	[LocationID]
												WHEN 'H' THEN	CYPL.[BusinessUnitID]
												WHEN 'Z' THEN	'None'
												
							END as Group2LevelID
					,Case @pGroup3Level			WHEN 'I' THEN	[ProductLineID]
												WHEN 'B' THEN	[GeographicRegionID]
												WHEN 'C' THEN	[CompanyID]
												WHEN 'D' THEN	[RegionID]
												WHEN 'E' THEN	[MarketSegmentID]
												WHEN 'F' THEN	[SubMarketSegmentID]
												WHEN 'G' THEN	[LocationID]
												WHEN 'H' THEN	CYPL.[BusinessUnitID]
												WHEN 'Z' THEN	'None'
												
							END as Group3LevelID

				  ,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [LY Period 1 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [LY Period 1 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [LY Period 1 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [LY Period 1 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [LY Period 1 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [LY Period 1 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [LY Period 1 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [LY Period 1 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [LY Period 1 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [LY Period 1 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [LY Period 1 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [LY Period 1 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [LY Period 1 Actual Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [LY Period 1 Actual Amount] Else 0.000000 End
							  Else [LY Period 1 Actual Amount]
							End),0.000000) AS [LY Period 1 Actual Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [LY Period 2 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [LY Period 2 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [LY Period 2 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [LY Period 2 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [LY Period 2 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [LY Period 2 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [LY Period 2 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [LY Period 2 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [LY Period 2 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [LY Period 2 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [LY Period 2 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [LY Period 2 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [LY Period 2 Actual Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [LY Period 2 Actual Amount] Else 0.000000 End
							  Else [LY Period 2 Actual Amount]
							End),0.000000) AS [LY Period 2 Actual Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [LY Period 3 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [LY Period 3 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [LY Period 3 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [LY Period 3 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [LY Period 3 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [LY Period 3 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [LY Period 3 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [LY Period 3 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [LY Period 3 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [LY Period 3 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [LY Period 3 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [LY Period 3 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [LY Period 3 Actual Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [LY Period 3 Actual Amount] Else 0.000000 End
							  Else [LY Period 3 Actual Amount]
							End),0.000000) AS [LY Period 3 Actual Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [LY Period 4 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [LY Period 4 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [LY Period 4 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [LY Period 4 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [LY Period 4 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [LY Period 4 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [LY Period 4 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [LY Period 4 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [LY Period 4 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [LY Period 4 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [LY Period 4 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [LY Period 4 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [LY Period 4 Actual Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [LY Period 4 Actual Amount] Else 0.000000 End
							  Else [LY Period 4 Actual Amount]
							End),0.000000) AS [LY Period 4 Actual Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [LY Period 5 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [LY Period 5 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [LY Period 5 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [LY Period 5 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [LY Period 5 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [LY Period 5 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [LY Period 5 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [LY Period 5 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [LY Period 5 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [LY Period 5 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [LY Period 5 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [LY Period 5 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [LY Period 5 Actual Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [LY Period 5 Actual Amount] Else 0.000000 End
							  Else [LY Period 5 Actual Amount]
							End),0.000000) AS [LY Period 5 Actual Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [LY Period 6 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [LY Period 6 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [LY Period 6 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [LY Period 6 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [LY Period 6 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [LY Period 6 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [LY Period 6 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [LY Period 6 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [LY Period 6 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [LY Period 6 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [LY Period 6 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [LY Period 6 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [LY Period 6 Actual Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [LY Period 6 Actual Amount] Else 0.000000 End
							  Else [LY Period 6 Actual Amount]
							End),0.000000) AS [LY Period 6 Actual Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [LY Period 7 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [LY Period 7 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [LY Period 7 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [LY Period 7 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [LY Period 7 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [LY Period 7 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [LY Period 7 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [LY Period 7 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [LY Period 7 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [LY Period 7 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [LY Period 7 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [LY Period 7 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [LY Period 7 Actual Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [LY Period 7 Actual Amount] Else 0.000000 End
							  Else [LY Period 7 Actual Amount]
							End),0.000000) AS [LY Period 7 Actual Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [LY Period 8 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [LY Period 8 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [LY Period 8 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [LY Period 8 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [LY Period 8 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [LY Period 8 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [LY Period 8 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [LY Period 8 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [LY Period 8 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [LY Period 8 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [LY Period 8 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [LY Period 8 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [LY Period 8 Actual Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [LY Period 8 Actual Amount] Else 0.000000 End
							  Else [LY Period 8 Actual Amount]
							End),0.000000) AS [LY Period 8 Actual Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [LY Period 9 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [LY Period 9 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [LY Period 9 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [LY Period 9 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [LY Period 9 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [LY Period 9 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [LY Period 9 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [LY Period 9 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [LY Period 9 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [LY Period 9 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [LY Period 9 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [LY Period 9 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [LY Period 9 Actual Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [LY Period 9 Actual Amount] Else 0.000000 End
							  Else [LY Period 9 Actual Amount]
							End),0.000000) AS [LY Period 9 Actual Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [LY Period 10 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [LY Period 10 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [LY Period 10 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [LY Period 10 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [LY Period 10 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [LY Period 10 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [LY Period 10 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [LY Period 10 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [LY Period 10 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [LY Period 10 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [LY Period 10 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [LY Period 10 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [LY Period 10 Actual Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [LY Period 10 Actual Amount] Else 0.000000 End
							  Else [LY Period 10 Actual Amount]
							End),0.000000) AS [LY Period 10 Actual Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [LY Period 11 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [LY Period 11 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [LY Period 11 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [LY Period 11 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [LY Period 11 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [LY Period 11 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [LY Period 11 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [LY Period 11 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [LY Period 11 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [LY Period 11 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [LY Period 11 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [LY Period 11 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [LY Period 11 Actual Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [LY Period 11 Actual Amount] Else 0.000000 End
							  Else [LY Period 11 Actual Amount]
							End),0.000000) AS [LY Period 11 Actual Amount]
						,ISNULL( ( Case 
							  When CYPL.GroupID = -159 Then Case When CYPL.BusinessUnitID = '602' Then [LY Period 12 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -160 Then Case When CYPL.BusinessUnitID = '602' Then [LY Period 12 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -161 Then Case When CYPL.BusinessUnitID in ('603', '000') Then [LY Period 12 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -162 Then Case When CYPL.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then [LY Period 12 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -164 Then Case When CYPL.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then [LY Period 12 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -165 Then Case When CYPL.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then [LY Period 12 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -168 Then Case When CYPL.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then [LY Period 12 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -170 Then Case When CYPL.BusinessUnitID = '608' Then [LY Period 12 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -166 Then Case When CYPL.BusinessUnitID = '609' Then [LY Period 12 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -167 Then Case When CYPL.BusinessUnitID = '610' Then [LY Period 12 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -163 Then Case When CYPL.BusinessUnitID = '611' Then [LY Period 12 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -169 Then Case When CYPL.BusinessUnitID = '615' Then [LY Period 12 Actual Amount] Else 0.000000 End 
							  When CYPL.GroupID = -294 Then Case When CYPL.BusinessUnitID In ('616', '617', '099') Then [LY Period 12 Actual Amount] Else 0.000000 End  
							  When CYPL.GroupID = -171 Then Case When (CYPL.BusinessUnitID <= '601' OR CYPL.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  
															CYPL.BusinessUnitID >= '701') AND CYPL.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then [LY Period 12 Actual Amount] Else 0.000000 End
							  Else [LY Period 12 Actual Amount]
							End),0.000000) AS [LY Period 12 Actual Amount]
		FROM (
				
					SELECT
					FT.GroupID 
					 ,FT.TemplateID
					 ,LYPL.[OrgSkey]
					 ,DO.BusinessUnitID
					 ,FiscalPeriodNumber
					 ,SortOrder 
					 ,	Case @pLanguage When @ENLanguage THEN FT.GroupDescEN 
									  WHEN @FRLanguage THEN FT.GroupDescFR
									  Else 'Unknown'
						END as GroupDesc
					
				,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN 
				 	  
						 (CASE WHEN CP.FiscalPeriodNumber =1  THEN  SUM([ConsCMAmt] *FT.IncomeStatementActualSign) 
														  ELSE  0.000000
														  END)
					WHEN @FuncCurrency THEN
					 
						 (CASE WHEN CP.FiscalPeriodNumber =1  THEN  SUM([FuncCMAmt]*FT.IncomeStatementActualSign) 
														  ELSE  0.000000
														  END)	    
						END,0.000000) AS [LY Period 1 Actual Amount]
				,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN 
				 	  
						 (CASE WHEN CP.FiscalPeriodNumber =2  THEN  SUM([ConsCMAmt] *FT.IncomeStatementActualSign) 
														  ELSE  0.000000
														  END)
					WHEN @FuncCurrency THEN
					 
						 (CASE WHEN CP.FiscalPeriodNumber =2  THEN  SUM([FuncCMAmt]*FT.IncomeStatementActualSign) 
														  ELSE  0.000000
														  END)	    
						END,0.000000) AS [LY Period 2 Actual Amount]
				,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN 
				 	  
						 (CASE WHEN CP.FiscalPeriodNumber =3  THEN  SUM([ConsCMAmt] *FT.IncomeStatementActualSign) 
														  ELSE  0.000000
														  END)
					WHEN @FuncCurrency THEN
					 
						 (CASE WHEN CP.FiscalPeriodNumber =3  THEN  SUM([FuncCMAmt]*FT.IncomeStatementActualSign) 
														  ELSE  0.000000
														  END)	    
						END,0.000000) AS [LY Period 3 Actual Amount]
				,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN 
				 	  
						 (CASE WHEN CP.FiscalPeriodNumber =4  THEN  SUM([ConsCMAmt] *FT.IncomeStatementActualSign) 
														  ELSE  0.000000
														  END)
					WHEN @FuncCurrency THEN
					 
						 (CASE WHEN CP.FiscalPeriodNumber =4  THEN  SUM([FuncCMAmt]*FT.IncomeStatementActualSign) 
														  ELSE  0.000000
														  END)	    
						END,0.000000) AS [LY Period 4 Actual Amount]
				,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN 
				 	  
						 (CASE WHEN CP.FiscalPeriodNumber =5  THEN  SUM([ConsCMAmt] *FT.IncomeStatementActualSign) 
														  ELSE  0.000000
														  END)
					WHEN @FuncCurrency THEN
					 
						 (CASE WHEN CP.FiscalPeriodNumber =5  THEN  SUM([FuncCMAmt]*FT.IncomeStatementActualSign) 
														  ELSE  0.000000
														  END)	    
						END,0.000000) AS [LY Period 5 Actual Amount]
				,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN 
				 	  
						 (CASE WHEN CP.FiscalPeriodNumber =6  THEN  SUM([ConsCMAmt] *FT.IncomeStatementActualSign) 
														  ELSE  0.000000
														  END)
					WHEN @FuncCurrency THEN
					 
						 (CASE WHEN CP.FiscalPeriodNumber =6  THEN  SUM([FuncCMAmt]*FT.IncomeStatementActualSign) 
														  ELSE  0.000000
														  END)	    
						END,0.000000) AS [LY Period 6 Actual Amount]
				,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN 
				 	  
						 (CASE WHEN CP.FiscalPeriodNumber =7  THEN  SUM([ConsCMAmt] *FT.IncomeStatementActualSign) 
														  ELSE  0.000000
														  END)
					WHEN @FuncCurrency THEN
					 
						 (CASE WHEN CP.FiscalPeriodNumber =7  THEN  SUM([FuncCMAmt]*FT.IncomeStatementActualSign) 
														  ELSE  0.000000
														  END)	    
						END,0.000000) AS [LY Period 7 Actual Amount]
				,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN 
				 	  
						 (CASE WHEN CP.FiscalPeriodNumber =8  THEN  SUM([ConsCMAmt] *FT.IncomeStatementActualSign) 
														  ELSE  0.000000
														  END)
					WHEN @FuncCurrency THEN
					 
						 (CASE WHEN CP.FiscalPeriodNumber =8  THEN  SUM([FuncCMAmt]*FT.IncomeStatementActualSign) 
														  ELSE  0.000000
														  END)	    
						END,0.000000) AS [LY Period 8 Actual Amount]
				,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN 
				 	  
						 (CASE WHEN CP.FiscalPeriodNumber =9  THEN  SUM([ConsCMAmt] *FT.IncomeStatementActualSign) 
														  ELSE  0.000000
														  END)
					WHEN @FuncCurrency THEN
					 
						 (CASE WHEN CP.FiscalPeriodNumber =9  THEN  SUM([FuncCMAmt]*FT.IncomeStatementActualSign) 
														  ELSE  0.000000
														  END)	    
						END,0.000000) AS [LY Period 9 Actual Amount]
				,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN 
				 	  
						 (CASE WHEN CP.FiscalPeriodNumber =10  THEN  SUM([ConsCMAmt] *FT.IncomeStatementActualSign) 
														  ELSE  0.000000
														  END)
					WHEN @FuncCurrency THEN
					 
						 (CASE WHEN CP.FiscalPeriodNumber =10  THEN  SUM([FuncCMAmt]*FT.IncomeStatementActualSign) 
														  ELSE  0.000000
														  END)	    
						END,0.000000) AS [LY Period 10 Actual Amount]
				,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN 
				 	  
						 (CASE WHEN CP.FiscalPeriodNumber =11  THEN  SUM([ConsCMAmt] *FT.IncomeStatementActualSign) 
														  ELSE  0.000000
														  END)
					WHEN @FuncCurrency THEN
					 
						 (CASE WHEN CP.FiscalPeriodNumber =11  THEN  SUM([FuncCMAmt]*FT.IncomeStatementActualSign) 
														  ELSE  0.000000
														  END)	    
						END,0.000000) AS [LY Period 11 Actual Amount]
				,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN 
				 	  
						 (CASE WHEN CP.FiscalPeriodNumber =12  THEN  SUM([ConsCMAmt] *FT.IncomeStatementActualSign) 
														  ELSE  0.000000
														  END)
					WHEN @FuncCurrency THEN
					 
						 (CASE WHEN CP.FiscalPeriodNumber =12  THEN  SUM([FuncCMAmt]*FT.IncomeStatementActualSign) 
														  ELSE  0.000000
														  END)	    
						END,0.000000) AS [LY Period 12 Actual Amount]

			FROM        FactProfitAndLossSummary  AS LYPL 
			LEFT OUTER JOIN MapFinancialTemplate as FT   ON FT.AccountSkey = LYPL.AccountSkey 
			INNER JOIN [dbo].[DimOrganization] as DO ON LYPL.OrgSkey = DO.OrgSkey
			INNER JOIN DimCalendarPeriod AS CP ON LYPL.PostPeriodSkey = CP.FiscalPeriodSkey
			WHERE  (CP.FiscalYear = cast (substring (cast (@pFiscalPeriod-100 as varchar(10)), 1, 4) as integer) )
					AND (FT.TemplateID = @pTemplate)
					AND LYPL.OrgSkey IN	( Select * from STRING_SPLIT(@pOrg, ','))
			GROUP BY    FT.GroupID 
					 ,FT.TemplateID
					 ,LYPL.[OrgSkey]
					 ,DO.BusinessUnitID
					 ,CP.FiscalPeriodNumber
					 ,SortOrder
					 ,Case @pLanguage When @ENLanguage THEN FT.GroupDescEN 
									  WHEN @FRLanguage THEN FT.GroupDescFR
									  Else 'Unknown'
							END
				)CYPL
				 INNER JOIN [dbo].[DimOrganization] as DO ON CYPL.OrgSkey = DO.OrgSkey
		)GLYPL

		GROUP BY GROUPID
					 ,Group1Level
					 ,Group1LevelID
					 ,Group2Level
					 ,Group2LevelID
					 ,Group3Level
					 ,Group3LevelID
					,TemplateID
					,GroupDesc
			) PALYPL ON Template.TemplateID = PALYPL.TemplateID
													AND Template.GroupID = PALYPL.GroupId
													AND Template.Group1level = PALYPL.Group1level
													AND Template.Group2level = PALYPL.Group2level
													AND Template.Group3level = PALYPL.Group3level				
			ORDER BY  Template.Group1Level,Template.Group2Level,Template.Group3Level,Template.SortOrder,  Template.GroupID,  Template.GroupDesc


END



		

GO

