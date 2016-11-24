USE [BIDataWarehouse]
GO

/****** Object:  StoredProcedure [dbo].[usp_ProfitandLoss_Objects12Months]    Script Date: 24/11/2016 11:02:14 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE Procedure [dbo].[usp_ProfitandLoss_Objects12Months] 
	@pCurrency varchar(5),
	@pFiscalPeriod int,
	@pLanguage int,
	@pBusinessLine varchar(max),
	@pGeoRegion varchar(max),
	@pCompany varchar(max),
	@pMarketSegment varchar(max),
	@pSubMarketSegment varchar(max),
	@pUserID as varchar(50),
	@pGroup1Level varchar(20),
	@pGroup2Level varchar(20),
	@pGroup3Level varchar(20) 
	
	AS 


Declare @FuncCurrency as Varchar(5);
Declare @ConsCurrency as Varchar(5);
Declare @ENLanguage as int;
Declare @FRLanguage as int;
Declare	@Template as int;
Declare @GroupID as varchar(max);
Declare @pInCurrency as varchar(5);
Declare @pInFiscalPeriod as int;
Declare @pInLanguage as int;
Declare @pInOrg as Varchar(max);

/**
Declare @pInCurrency as varchar(5);
declare	@pFiscalPeriod as int;
declare	@pTemplate as int;
declare	@pInLanguage as int;
Declare @pInOrg as Varchar(max);
DECLARE @pGroup1Level varchar(20);
DECLARE	@pGroup2Level varchar(20);
DECLARE	@pGroup3Level varchar(20);
**/

SET @FuncCurrency = 'FUNC';
SET @ConsCurrency = 'CONS';
SET @ENLanguage = 1;
SET @FRLanguage = 2;
SET @Template = 100
SET @GroupID = '-24, 51, -27, 49, 63'
SET @pInCurrency = @pCurrency
SET @pInFiscalPeriod = @pFiscalPeriod
SET @pInLanguage = @pLanguage
--SET @pInOrg = @pOrg



/**
SET @pFiscalPeriod = 201605;
Set @pTemplate = 105;
SET @pInLanguage = 1;
SET @pInCurrency = 'FUNC';
SET @pInOrg = '452,662,453,387';
SET @pInCurrency = 'CONS';
SET @pGroup1Level = 'A'
SET @pGroup2Level = 'I';
SET @pGroup3Level = 'C';
**/


BEGIN

		WITH ProfitandLossCTE (TemplateID,Group1Level,Group2Level,Group3Level,Group1LevelID,Group2LevelID,Group3LevelID
					,GroupID,GroupDesc, FiscalYear,PostPeriodSkey
					,FiscalPeriodNumber,SortOrder,FiscalPeriodShortName, FiscalPeriodLongName
					,[Current Month Amount],[YTD Amount]
					
					)
		AS
		(  
			SELECT  FT.TemplateID
					,Group1Level
					,Group2Level
					,Group3Level
					,Group1LevelID
					,Group2LevelID
					,Group3LevelID							 
					,FT.GroupID 
					, Case @pInLanguage When @ENLanguage THEN FT.GroupDescEN 
									  WHEN @FRLanguage THEN FT.GroupDescFR
									  Else 'Unknown'
						END as GroupDesc
					,CP.FiscalYear
					,PostPeriodSkey
					,FiscalPeriodNumber
					,SortOrder
					,Case @pInLanguage When @ENLanguage THEN CP.FiscalPeriodShortNameEN 
									  WHEN @FRLanguage THEN CP.FiscalPeriodShortNameFR
									  Else 'Unknown'
						END as FiscalPeriodShortName
					,Case @pInLanguage When @ENLanguage THEN CP.FiscalPeriodLongNameEN 
									  WHEN @FRLanguage THEN CP.FiscalPeriodLongNameFR
									  Else 'Unknown'
						END as FiscalPeriodLongName
					
					,ISNULL( Case @pInCurrency  WHEN @ConsCurrency THEN SUM(PL.ConsCMAmt * FT.IncomeStatementActualSign) 
									   WHEN @FuncCurrency THEN SUM(PL.FuncCMAmt * FT.IncomeStatementActualSign)
									   Else 0.000000
					  END,0.000000) as [Current Month Amount]
					
					, ISNULL(Case @pInCurrency  WHEN @ConsCurrency THEN SUM(PL.ConsYTDAmt * FT.IncomeStatementActualSign)
										WHEN @FuncCurrency THEN SUM(PL.FuncYTDAmt * FT.IncomeStatementActualSign)
										Else 0.000000
						END,0.000000) as [YTD Amount]
					
		
	
		FROM        FactProfitAndLossSummary   AS PL 
				LEFT OUTER JOIN MapFinancialTemplate as FT   ON FT.AccountSkey = PL.AccountSkey 
				INNER JOIN 
				( SELECT DO.Orgskey,GLStartPeriod,GLEndPeriod
								,Case @pLanguage When @ENLanguage THEN	Case @pGroup1Level	
												WHEN 'A' THEN	[TerritoryDescEN]
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
									 WHEN @FRLanguage THEN CASE  @pGroup1Level	
												WHEN 'A' THEN	[TerritoryDescFR]
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
					,Case @pLanguage When @ENLanguage THEN	Case @pGroup2Level	
												WHEN 'A' THEN	[TerritoryDescEN]
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
									 WHEN @FRLanguage THEN CASE  @pGroup2Level	
												WHEN 'A' THEN	[TerritoryDescFR]
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
					,Case @pLanguage When @ENLanguage THEN	Case @pGroup3Level	
												WHEN 'A' THEN	[TerritoryDescEN]
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
									 WHEN @FRLanguage THEN CASE  @pGroup3Level	
												WHEN 'A' THEN	[TerritoryDescFR]
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
												WHEN 'H' THEN	[BusinessUnitID]
												WHEN 'Z' THEN	'None'
												
							END as Group1LevelID
					,Case @pGroup2Level			WHEN 'I' THEN	[ProductLineID]
												WHEN 'B' THEN	[GeographicRegionID]
												WHEN 'C' THEN	[CompanyID]
												WHEN 'D' THEN	[RegionID]
												WHEN 'E' THEN	[MarketSegmentID]
												WHEN 'F' THEN	[SubMarketSegmentID]
												WHEN 'G' THEN	[LocationID]
												WHEN 'H' THEN	[BusinessUnitID]
												WHEN 'Z' THEN	'None'
												
							END as Group2LevelID
					,Case @pGroup3Level			WHEN 'I' THEN	[ProductLineID]
												WHEN 'B' THEN	[GeographicRegionID]
												WHEN 'C' THEN	[CompanyID]
												WHEN 'D' THEN	[RegionID]
												WHEN 'E' THEN	[MarketSegmentID]
												WHEN 'F' THEN	[SubMarketSegmentID]
												WHEN 'G' THEN	[LocationID]
												WHEN 'H' THEN	[BusinessUnitID]
												WHEN 'Z' THEN	'None'
												
							END as Group3LevelID
						 FROM [dbo].[DimOrganization] as DO  
							INNER JOIN DimOrgSecurity DOS ON DO.OrgSkey = DOS.OrgSkey
						 WHERE [ProductLineID] in ( Select * from dbo.STRING_SPLIT( @pBusinessLine , ','))
					AND [GeographicRegionID] IN (Select * from dbo.STRING_SPLIT(@pGeoRegion , ','))
					AND CompanyID IN (Select * from dbo.STRING_SPLIT(@pCompany , ','))
					AND [MarketSegmentID] in  (Select * from dbo.STRING_SPLIT(@pMarketSegment , ','))
					AND [SubMarketSegmentID] IN (Select * from dbo.STRING_SPLIT(@pSubMarketSegment , ','))
					AND (OrganizationID <> '99-ZZ-ZZZ-ZZZ') 
					AND (RemovedFlag = 'N')
					and ADAccount = @pUserID
							)DOS ON PL.OrgSkey = DOS.OrgSkey AND PL.PostPeriodSkey between GLStartPeriod and GLEndPeriod
				INNER JOIN DimCalendarPeriod AS CP ON PL.PostPeriodSkey = CP.FiscalPeriodSkey
		WHERE     PL.PostPeriodSkey BETWEEN  Convert(INT, Convert(varchar(6),Dateadd(mm, -12, Convert(Date, Convert(varchar(8),((@pInFiscalPeriod * 100) +1)),112)),112)) 
									AND @pInFiscalPeriod
					AND (FT.TemplateID = @Template)
					--AND PL.OrgSkey IN	( Select * from dbo.STRING_SPLIT(@pInOrg, ','))
					AND FT.GroupID in (Select * from dbo.STRING_SPLIT(@GroupID , ','))
					
		GROUP BY	 FT.TemplateID
					,Group1Level
					,Group2Level
					,Group3Level
					,Group1LevelID
					,Group2LevelID
					,Group3LevelID
					,FT.GroupID
					,Case @pInLanguage When @ENLanguage THEN FT.GroupDescEN 
									  WHEN @FRLanguage THEN FT.GroupDescFR
									  Else 'Unknown'
						END
					,CP.FiscalPeriodNumber
					,CP.FiscalYear
					,PostPeriodSkey
					,SortOrder
					,Case @pInLanguage When @ENLanguage THEN CP.FiscalPeriodShortNameEN 
									  WHEN @FRLanguage THEN CP.FiscalPeriodShortNameFR
									  Else 'Unknown'
									  END
					,Case @pInLanguage When @ENLanguage THEN CP.FiscalPeriodLongNameEN 
									  WHEN @FRLanguage THEN CP.FiscalPeriodLongNameFR
									  Else 'Unknown'
									  END
						
			
			
		)

		SELECT TemplateID,Group1Level,Group2Level,Group3Level,Group1LevelID,Group2LevelID,Group3LevelID
					,FiscalYear,FiscalPeriodNumber,FiscalPeriodLongName,
					CASE WHEN GroupID = -24 then SUM([Current Month Amount]) ELSE 0 end as [Gross Revenue CM],
					CASE WHEN GroupID = 51  then SUM([Current Month Amount]) ELSE 0 end as [Net Revenue CM],
					CASE WHEN GroupID = 49  then SUM([Current Month Amount]) ELSE 0 end as [EBGE CM],
					CASE WHEN GroupID = 63  then SUM([Current Month Amount]) ELSE 0 end as [EBITDA CM],
					CASE WHEN GroupID = -27 then SUM([Current Month Amount]) ELSE 0 end as [Direct Labour CM],
					CASE WHEN GroupID = -24 then SUM([YTD Amount]) ELSE 0 end as [Gross Revenue YTD],
					CASE WHEN GroupID = 51  then SUM([YTD Amount]) ELSE 0 end as [Net Revenue YTD],
					CASE WHEN GroupID = 49  then SUM([YTD Amount]) ELSE 0 end as [EBGE YTD],
					CASE WHEN GroupID = 63  then SUM([YTD Amount]) ELSE 0 end as [EBITDA YTD],
					CASE WHEN GroupID = -27 then SUM([YTD Amount]) ELSE 0 end as [Direct Labour YTD]
		 FROM ProfitandLossCTE
		 GROUP BY TemplateID,Group1Level,Group2Level,Group3Level,Group1LevelID,Group2LevelID,Group3LevelID
					,GroupID,FiscalYear,FiscalPeriodNumber,FiscalPeriodLongName
		 ORDER BY TemplateID,Group1Level,Group2Level,Group3Level,Group1LevelID,Group2LevelID,Group3LevelID
					,FiscalYear desc,FiscalPeriodNumber desc

/*
		Select * FROM
		(
		SELECT * FROM ProfitandLossCTE
		UNION 

		SELECT NR.TemplateID,
				Case  WA.GroupID WHEN -27 THEN  -28
						ELSE -1
						END AS GroupID

				, CASE WA.GroupDesc WHEN 'Direct Labor' THEN 'GM'
								ELSE 'Unknown'
								END AS GroupDesc
				, NR.FiscalYear, NR.PostPeriodSkey
				,NR.FiscalPeriodNumber, WA.SortOrder +10 , NR.FiscalPeriodShortName, WA.FiscalPeriodLongName
		,NR.[Current Month Amount] - WA.[Current Month Amount]
		
		,NR.[YTD Amount] - WA.[YTD Amount]
		FROM
		(SELECT * FROM ProfitandLossCTE
		WHERE GROUPID = 51)NR
		INNER JOIN (SELECT * FROM ProfitandLossCTE
		WHERE GROUPID = -27)WA ON NR.TemplateID = WA.TemplateID
								--AND NR.GroupID = WA.GroupID
								AND NR.PostPeriodSkey = WA.PostPeriodSkey
		)CD
		ORDER BY 	TemplateID
					,FiscalYear,PostPeriodSkey,SortOrder
*/		 
END

GO

