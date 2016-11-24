USE [BIDataWarehouse]
GO

/****** Object:  StoredProcedure [dbo].[usp_ProfitandLossSummaryFact_BudgetCorporateExpenseDraft_Summary]    Script Date: 24/11/2016 11:08:12 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






/*Add next year Budget*/
CREATE Procedure [dbo].[usp_ProfitandLossSummaryFact_BudgetCorporateExpenseDraft_Summary] 
	@pCurrency varchar(5),
	@pFiscalPeriod int,
	@pTemplate int,
	@pLanguage int,
	@pOrg varchar(max),
	@pGroup1Level varchar(20),
	@pGroup2Level varchar(20),
	@pGroup3Level varchar(20)--,
	--@pSummaryDetail varchar(1)
	AS 

--Declare @pCurrency as Varchar (5);
Declare @FuncCurrency as Varchar(5);
Declare @ConsCurrency as Varchar(5);
Declare @ENLanguage as int;
Declare @FRLanguage as int;
/**
Declare @pCurrency as varchar(5);
declare	@pFiscalPeriod as int;
declare	@pTemplate as int;
declare	@pLanguage as int;
**/
--SET @pCurrency = 'CONS';
SET @FuncCurrency = 'FUNC';
SET @ConsCurrency = 'CONS';
SET @ENLanguage = 1;
SET @FRLanguage = 2;
/**
SET @pFiscalPeriod = 201605;
Set @pTemplate = 105;
SET @pLanguage = 1;
SET @pCurrency = 'FUNC';

**/
--If @pSummaryDetail = 'S' 
WITH ProfitandLossCTE (
TemplateID, Group1Level,Group2Level,Group3Level,Group1LevelID, Group2LevelID, Group3LevelID,
GroupID ,GroupDesc, AccountID, AccountDesc,
[HeaderLine],[ShowDetail],[InsertSkipLineBefore],[SkipLine]
,[IsMarkup] ,[IsNetRevenues],[IsDirectLabor],[IsFringeBenefitsPct],[IsFringeBenefits],
[IsManagementSalaries],[IsMarketingSalaries],[IsTrainingSalaries],[IsEBGEPct],[IsEBGE]
,[IsEBREPct],[IsEBRE],[IsEBITDAPct],[IsEBITDA] ,[IsCalculatedUtilizationPct]
,SortOrder 
,FiscalPeriodNumber

,[Current Month Amount]--Not use
,[Current Month Budget Amount]--Not use
,[YTD Amount]--YTD
,[Current Month Forecast 1 Amount]--Forecast Current Q1
,[Current Month Forecast 2 Amount]--Forecast Current Q2
,[Current Month Forecast 3 Amount]--Forecast Current Q3
,[YTD Budget Amount]--BudgetYTD
,[Current Year Budget Amount]--BudgetAmount
--,[QTD Forecast 1 Amount]
,[YTD Forecast 1 Amount]--Forecast YTD Q1
,[YTD Forecast 2 Amount]--Forecast YTD Q2
,[YTD Forecast 3 Amount]--Forecast YTD Q3
/*Added for this Report*/--Leo Yang July 21
,[NYBudget]
,[NY Forecast 1 Amonut]
,[NY Forecast 2 Amonut]
,[NY Forecast 3 Amonut]
,[Period 1 Forecast 1 Amount],[Period 2 Forecast 1 Amount],[Period 3 Forecast 1 Amount],[Period 4 Forecast 1 Amount]
,[Period 5 Forecast 1 Amount],[Period 6 Forecast 1 Amount],[Period 7 Forecast 1 Amount],[Period 8 Forecast 1 Amount]
,[Period 9 Forecast 1 Amount],[Period 10 Forecast 1 Amount],[Period 11 Forecast 1 Amount],[Period 12 Forecast 1 Amount]
,[Period 1 Forecast 2 Amount],[Period 2 Forecast 2 Amount],[Period 3 Forecast 2 Amount],[Period 4 Forecast 2 Amount]
,[Period 5 Forecast 2 Amount],[Period 6 Forecast 2 Amount],[Period 7 Forecast 2 Amount],[Period 8 Forecast 2 Amount]
,[Period 9 Forecast 2 Amount],[Period 10 Forecast 2 Amount],[Period 11 Forecast 2 Amount],[Period 12 Forecast 2 Amount]
,[Period 1 Forecast 3 Amount],[Period 2 Forecast 3 Amount],[Period 3 Forecast 3 Amount],[Period 4 Forecast 3 Amount]
,[Period 5 Forecast 3 Amount],[Period 6 Forecast 3 Amount],[Period 7 Forecast 3 Amount],[Period 8 Forecast 3 Amount]
,[Period 9 Forecast 3 Amount],[Period 10 Forecast 3 Amount],[Period 11 Forecast 3 Amount],[Period 12 Forecast 3 Amount]
,[PYActual]
)
AS
(





SELECT  CYPL.TemplateID
					,Case @pLanguage When @ENLanguage THEN	Case @pGroup1Level	WHEN 'A' THEN	DO.[TerritoryDescEN]
												WHEN 'I' THEN	DO.[ProductLineDescEN]
												WHEN 'B' THEN	DO.[GeographicRegionDescEN]
												WHEN 'C' THEN	DO.[CompanyDescEN]
												WHEN 'D' THEN	DO.[RegionDescEN]
												WHEN 'E' THEN	DO.[MarketSegmentDescEN]
												WHEN 'F' THEN	DO.[SubMarketSegmentDescEN]
												WHEN 'G' THEN	DO.[LocationDescEN]
												WHEN 'H' THEN	DO.[BusinessUnitDescEN]
												WHEN 'Z' THEN	'None'
												END
									 WHEN @FRLanguage THEN CASE  @pGroup1Level	WHEN 'A' THEN	DO.[TerritoryDescFR]
												WHEN 'I' THEN	DO.[ProductLineDescFR]
												WHEN 'B' THEN	DO.[GeographicRegionDescFR]
												WHEN 'C' THEN	DO.[CompanyDescFR]
												WHEN 'D' THEN	DO.[RegionDescFR]
												WHEN 'E' THEN	DO.[MarketSegmentDescFR]
												WHEN 'F' THEN	DO.[SubMarketSegmentDescFR]
												WHEN 'G' THEN	DO.[LocationDescFR]
												WHEN 'H' THEN	DO.[BusinessUnitDescFR]
												WHEN 'Z' THEN	'None'
												END
							END as Group1Level
					,Case @pLanguage When @ENLanguage THEN	Case @pGroup2Level	WHEN 'A' THEN	DO.[TerritoryDescEN]
												WHEN 'I' THEN	DO.[ProductLineDescEN]
												WHEN 'B' THEN	DO.[GeographicRegionDescEN]
												WHEN 'C' THEN	DO.[CompanyDescEN]
												WHEN 'D' THEN	DO.[RegionDescEN]
												WHEN 'E' THEN	DO.[MarketSegmentDescEN]
												WHEN 'F' THEN	DO.[SubMarketSegmentDescEN]
												WHEN 'G' THEN	DO.[LocationDescEN]
												WHEN 'H' THEN	DO.[BusinessUnitDescEN]
												WHEN 'Z' THEN	'None'
												END
									 WHEN @FRLanguage THEN CASE  @pGroup2Level	WHEN 'A' THEN	DO.[TerritoryDescFR]
												WHEN 'I' THEN	DO.[ProductLineDescFR]
												WHEN 'B' THEN	DO.[GeographicRegionDescFR]
												WHEN 'C' THEN	DO.[CompanyDescFR]
												WHEN 'D' THEN	DO.[RegionDescFR]
												WHEN 'E' THEN	DO.[MarketSegmentDescFR]
												WHEN 'F' THEN	DO.[SubMarketSegmentDescFR]
												WHEN 'G' THEN	DO.[LocationDescFR]
												WHEN 'H' THEN	DO.[BusinessUnitDescFR]
												WHEN 'Z' THEN	'None'
												END
							END as Group2Level
					,Case @pLanguage When @ENLanguage THEN	Case @pGroup3Level	WHEN 'A' THEN	DO.[TerritoryDescEN]
												WHEN 'I' THEN	DO.[ProductLineDescEN]
												WHEN 'B' THEN	DO.[GeographicRegionDescEN]
												WHEN 'C' THEN	DO.[CompanyDescEN]
												WHEN 'D' THEN	DO.[RegionDescEN]
												WHEN 'E' THEN	DO.[MarketSegmentDescEN]
												WHEN 'F' THEN	DO.[SubMarketSegmentDescEN]
												WHEN 'G' THEN	DO.[LocationDescEN]
												WHEN 'H' THEN	DO.[BusinessUnitDescEN]
												WHEN 'Z' THEN	'None'
												END
									 WHEN @FRLanguage THEN CASE  @pGroup3Level	WHEN 'A' THEN	DO.[TerritoryDescFR]
												WHEN 'I' THEN	DO.[ProductLineDescFR]
												WHEN 'B' THEN	DO.[GeographicRegionDescFR]
												WHEN 'C' THEN	DO.[CompanyDescFR]
												WHEN 'D' THEN	DO.[RegionDescFR]
												WHEN 'E' THEN	DO.[MarketSegmentDescFR]
												WHEN 'F' THEN	DO.[SubMarketSegmentDescFR]
												WHEN 'G' THEN	DO.[LocationDescFR]
												WHEN 'H' THEN	DO.[BusinessUnitDescFR]
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
							,CYPL.GroupId
						, CYPL.GroupDesc		
						, CYPL.AccountID  --added
						, CYPL.AccountDesc	  --added									
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
					,SUM([Current Month Amount]) AS [Current Month Amount]
					,SUM([Current Month Budget Amount]) AS [Current Month Budget Amount]
					,SUM([YTD Amount]) as [YTD Amount]
					,SUM([Current Month Forecast 1 Amount]) as [Current Month Forecast 1 Amount]
					,SUM([Current Month Forecast 2 Amount]) as [Current Month Forecast 2 Amount]
					,SUM([Current Month Forecast 3 Amount]) AS [Current Month Forecast 3 Amount]
					,SUM([YTD Budget Amount]) AS [YTD Budget Amount]
					,SUM([Current Year Budget Amount]) as [Current Year Budget Amount]
					,SUM([YTD Forecast 1 Amount]) as [YTD Forecast 1 Amount]
					,SUM([YTD Forecast 2 Amount]) as [YTD Forecast 2 Amount]
					,SUM([YTD Forecast 3 Amount]) as [YTD Forecast 3 Amount]
					,SUM([NYBudget]) AS [NYBudget]
					,SUM([NY Forecast 1 Amonut]) as [NY Forecast 1 Amonut]
					,SUM([NY Forecast 2 Amonut]) AS [NY Forecast 2 Amonut]
					,SUM([NY Forecast 3 Amonut]) AS [NY Forecast 3 Amonut]
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
					,SUM([PY Actual]) as [PY Actual]
   FROM( SELECT  FT.TemplateID
			,PL.[OrgSkey]
     		,FT.GroupID 
			, Case @pLanguage When @ENLanguage THEN FT.[GroupDescEN]
							  WHEN @FRLanguage THEN FT.[GroupDescFR]
							  Else 'Unknown'
				END as GroupDesc
			,DA.AccountID-- added
			, Case @pLanguage when @ENLanguage THEN DA.[AccountNameEN]
							  WHEN @FRLanguage THEN DA.[AccountNameFR]
							  ELSE 'Unknown'
				END AS AccountDesc  -- added
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
			,SortOrder,FiscalPeriodNumber
			,ISNULL(Case @pCurrency  WHEN @ConsCurrency THEN SUM(PL.ConsCMAmt * FT.IncomeStatementActualSign) 
							   WHEN @FuncCurrency THEN SUM(PL.FuncCMAmt * FT.IncomeStatementActualSign)
							   Else 0.000000
			  END,0.000000) as [Current Month Amount]
			,ISNULL(Case @pCurrency  WHEN @ConsCurrency THEN SUM(PL.ConsCMBudgetAmt * FT.IncomeStatementBudgetSign)
							   WHEN @FuncCurrency THEN SUM(PL.FuncCMBudgetAmt * FT.IncomeStatementBudgetSign)
							   Else 0.000000
			  END,0.000000) as [Current Month Budget Amount]
			,ISNULL(Case @pCurrency  WHEN @ConsCurrency THEN SUM(PL.ConsYTDAmt * FT.IncomeStatementActualSign)
								WHEN @FuncCurrency THEN SUM(PL.FuncYTDAmt * FT.IncomeStatementActualSign)
								Else 0.000000
			  END,0.000000) as [YTD Amount]
			,ISNULL(SUM((Case @pCurrency  WHEN @ConsCurrency THEN PL.ConsCMFC1Amt 
							   WHEN @FuncCurrency THEN PL.FuncCMFC1Amt 
							   Else 0.000000
							   END) * 
					Case When CP.[FiscalPeriodNumber] <= 2 Then [IncomeStatementActualSign]  
								Else [IncomeStatementBudgetSign]
								END 
								),0.000000) as [Current Month Forecast 1 Amount]
			,ISNULL(SUM((Case @pCurrency  WHEN @ConsCurrency THEN PL.ConsCMFC2Amt 
							   WHEN @FuncCurrency THEN PL.FuncCMFC2Amt 
							   Else 0.000000
							   END) * 
					Case When CP.[FiscalPeriodNumber] <= 5 Then [IncomeStatementActualSign]  
								Else [IncomeStatementBudgetSign]
								END 
								),0.000000) as [Current Month Forecast 2 Amount]
			,ISNULL(SUM((Case @pCurrency  WHEN @ConsCurrency THEN PL.ConsCMFC1Amt 
							   WHEN @FuncCurrency THEN PL.FuncCMFC1Amt 
							   Else 0.000000
							   END) * 
					Case When CP.[FiscalPeriodNumber] <= 8 Then [IncomeStatementActualSign]  
								Else [IncomeStatementBudgetSign]
								END 
								),0.000000) as [Current Month Forecast 3 Amount]
			,ISNULL(Case @pCurrency  WHEN @ConsCurrency THEN SUM(PL.ConsYTDBudgetAmt * FT.IncomeStatementBudgetSign)
							   WHEN @FuncCurrency THEN SUM(PL.FuncYTDBudgetAmt * FT.IncomeStatementBudgetSign)
							   END,0.000000) as [YTD Budget Amount]
			,ISNULL(Case @pCurrency  WHEN @ConsCurrency THEN SUM(PL.ConsCYBudgetAmt * FT.IncomeStatementBudgetSign) 
							   WHEN @FuncCurrency THEN SUM(PL.FuncCYBudgetAmt * FT.IncomeStatementBudgetSign)
							   END,0.000000) as [Current Year Budget Amount]
		
			,ISNULL(Case @pCurrency 
				WHEN @ConsCurrency THEN 
				  (CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.ConsP1FC1Amt) * FT.IncomeStatementActualSign)) 				  
								   WHEN  2  THEN SUM(((PL.ConsP1FC1Amt + PL.ConsP2FC1Amt) * FT.IncomeStatementActualSign))				   
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
				END,0.000000) AS [YTD Forecast 1 Amount]
            
			 ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN 
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
				END,0.000000) AS [YTD Forecast 2 Amount]
			  
           ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN
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
					( CASE CP.FiscalPeriodNumber WHEN 1  THEN SUM(((PL.FuncP1FC3Amt) * FT.IncomeStatementActualSign)) 
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
					Else 0.000000
					END,0.000000) AS [YTD Forecast 3 Amount]

					,ISNULL(Case @pCurrency  WHEN @ConsCurrency THEN SUM(FB.ConsBudgetAmt * FT.IncomeStatementActualSign)
										WHEN @FuncCurrency THEN SUM(FB.FuncBudgetAmt * FT.IncomeStatementActualSign)
										Else 0.000000
					END,0.000000) AS [NYBudget]
					,0 AS [NY Forecast 1 Amonut]
					,0 AS [NY Forecast 2 Amonut]
					,0 AS [NY Forecast 3 Amonut]
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP1FC1Amt * FT.IncomeStatementActualSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP1FC1Amt * FT.IncomeStatementActualSign) )
							END,0.000000) AS [Period 1 Forecast 1 Amount] 
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP2FC1Amt * FT.IncomeStatementActualSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP2FC1Amt * FT.IncomeStatementActualSign) )
							END,0.000000) AS [Period 2 Forecast 1 Amount] 
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP3FC1Amt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP3FC1Amt * FT.IncomeStatementBudgetSign) )
							END,0.000000) AS [Period 3 Forecast 1 Amount] 
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP4FC1Amt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP4FC1Amt * FT.IncomeStatementBudgetSign) )
							END,0.000000) AS [Period 4 Forecast 1 Amount] 
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP5FC1Amt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP5FC1Amt * FT.IncomeStatementBudgetSign) )
							END,0.000000) AS [Period 5 Forecast 1 Amount] 
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP6FC1Amt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP6FC1Amt * FT.IncomeStatementBudgetSign) )
							END,0.000000) AS [Period 6 Forecast 1 Amount] 
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP7FC1Amt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP7FC1Amt * FT.IncomeStatementBudgetSign) )
							END,0.000000) AS [Period 7 Forecast 1 Amount] 
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP8FC1Amt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP8FC1Amt * FT.IncomeStatementBudgetSign) )
							END,0.000000) AS [Period 8 Forecast 1 Amount] 
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP9FC1Amt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP9FC1Amt * FT.IncomeStatementBudgetSign) )
							END,0.000000) AS [Period 9 Forecast 1 Amount] 
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP10FC1Amt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP10FC1Amt * FT.IncomeStatementBudgetSign) )
							END,0.000000) AS [Period 10 Forecast 1 Amount] 
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP11FC1Amt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP11FC1Amt * FT.IncomeStatementBudgetSign) )
							END,0.000000) AS [Period 11 Forecast 1 Amount] 
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP12FC1Amt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP12FC1Amt * FT.IncomeStatementBudgetSign) )
							END,0.000000) AS [Period 12 Forecast 1 Amount] 
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP1FC2Amt * FT.IncomeStatementActualSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP1FC2Amt * FT.IncomeStatementActualSign) )
							END,0.000000) AS [Period 1 Forecast 2 Amount] 
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP2FC2Amt * FT.IncomeStatementActualSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP2FC2Amt * FT.IncomeStatementActualSign) )
							END,0.000000) AS [Period 2 Forecast 2 Amount] 
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP3FC2Amt * FT.IncomeStatementActualSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP3FC2Amt * FT.IncomeStatementActualSign) )
							END,0.000000) AS [Period 3 Forecast 2 Amount] 
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP4FC2Amt * FT.IncomeStatementActualSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP4FC2Amt * FT.IncomeStatementActualSign) )
							END,0.000000) AS [Period 4 Forecast 2 Amount] 
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP5FC2Amt * FT.IncomeStatementActualSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP5FC2Amt * FT.IncomeStatementActualSign) )
							END,0.000000) AS [Period 5 Forecast 2 Amount] 
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP6FC2Amt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP6FC2Amt * FT.IncomeStatementBudgetSign) )
							END,0.000000) AS [Period 6 Forecast 2 Amount] 
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP7FC2Amt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP7FC2Amt * FT.IncomeStatementBudgetSign) )
							END,0.000000) AS [Period 7 Forecast 2 Amount] 
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP8FC2Amt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP8FC2Amt * FT.IncomeStatementBudgetSign) )
							END,0.000000) AS [Period 8 Forecast 2 Amount] 
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP9FC2Amt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP9FC2Amt * FT.IncomeStatementBudgetSign) )
							END,0.000000) AS [Period 9 Forecast 2 Amount] 
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP10FC2Amt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP10FC2Amt * FT.IncomeStatementBudgetSign) )
							END,0.000000) AS [Period 10 Forecast 2 Amount] 
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP11FC2Amt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP11FC2Amt * FT.IncomeStatementBudgetSign) )
							END,0.000000) AS [Period 11 Forecast 2 Amount] 
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP12FC2Amt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP12FC2Amt * FT.IncomeStatementBudgetSign) )
							END,0.000000) AS [Period 12 Forecast 2 Amount]
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP1FC3Amt * FT.IncomeStatementActualSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP1FC3Amt * FT.IncomeStatementActualSign) )
							END,0.000000) AS [Period 1 Forecast 3 Amount] 
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP2FC3Amt * FT.IncomeStatementActualSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP2FC3Amt * FT.IncomeStatementActualSign) )
							END,0.000000) AS [Period 2 Forecast 3 Amount] 
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP3FC3Amt * FT.IncomeStatementActualSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP3FC3Amt * FT.IncomeStatementActualSign) )
							END,0.000000) AS [Period 3 Forecast 3 Amount] 
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP4FC3Amt * FT.IncomeStatementActualSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP4FC3Amt * FT.IncomeStatementActualSign) )
							END,0.000000) AS [Period 4 Forecast 3 Amount] 
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP5FC3Amt * FT.IncomeStatementActualSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP5FC3Amt * FT.IncomeStatementActualSign) )
							END,0.000000) AS [Period 5 Forecast 3 Amount] 
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP6FC3Amt * FT.IncomeStatementActualSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP6FC3Amt * FT.IncomeStatementActualSign) )
							END,0.000000) AS [Period 6 Forecast 3 Amount] 
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP7FC3Amt * FT.IncomeStatementActualSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP7FC3Amt * FT.IncomeStatementActualSign) )
							END,0.000000) AS [Period 7 Forecast 3 Amount] 
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP8FC3Amt * FT.IncomeStatementActualSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP8FC3Amt * FT.IncomeStatementActualSign) )
							END,0.000000) AS [Period 8 Forecast 3 Amount] 
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP9FC3Amt * FT.IncomeStatementActualSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP9FC3Amt * FT.IncomeStatementActualSign) )
							END,0.000000) AS [Period 9 Forecast 3 Amount] 
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP10FC3Amt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP10FC3Amt * FT.IncomeStatementBudgetSign) )
							END,0.000000) AS [Period 10 Forecast 3 Amount] 
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP11FC3Amt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP11FC3Amt * FT.IncomeStatementBudgetSign) )
							END,0.000000) AS [Period 11 Forecast 3 Amount] 
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP12FC3Amt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP12FC3Amt * FT.IncomeStatementBudgetSign) )
							END,0.000000) AS [Period 12 Forecast 3 Amount] 

FROM        FactProfitAndLossSummary   AS PL 
		LEFT OUTER JOIN MapFinancialTemplate as FT ON FT.AccountSkey = PL.AccountSkey 
		INNER JOIN DimAccount DA ON PL.AccountSkey  = DA.AccountSkey --added
		INNER JOIN [dbo].[DimOrganization] as DO ON PL.OrgSkey = DO.OrgSkey
		INNER JOIN DimCalendarPeriod AS CP ON PL.PostPeriodSkey = CP.FiscalPeriodSkey
		LEFT OUTER JOIN [dbo].[FactGLBudgetingProcessDetail] FB ON PL.[PostPeriodSkey] = FB.[PostPeriodSkey] --Add Budget Amt
WHERE        (PL.PostPeriodSkey = @pFiscalPeriod) 
			AND (FT.TemplateID = @pTemplate)
			AND PL.OrgSkey IN	( Select * from dbo.STRING_SPLIT(@pOrg, ','))
			--AND HeaderLine = 'Y'
			AND FT.GroupID not in (60)  -- added
	

GROUP BY	 FT.TemplateID
			,PL.[OrgSkey]
			,FT.GroupID, FT.SortOrder, 
				Case @pLanguage When @ENLanguage THEN FT.[GroupDescEN]
							  WHEN @FRLanguage THEN FT.[GroupDescFR]
							  Else 'Unknown'
				END
			,DA.AccountID
			,Case @pLanguage when @ENLanguage THEN DA.[AccountNameEN]
							  WHEN @FRLanguage THEN DA.[AccountNameFR]
							  ELSE 'Unknown'
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
			,CP.FiscalPeriodNumber
			,SortOrder
			
 
) CYPL
LEFT OUTER JOIN (
	Select FT.GroupID 
					  ,DA.AccountID   -- added
					  ,FT.TemplateID
					 ,LYPL.[OrgSkey]
					 ,CP.FiscalPeriodNumber
				,Case @pCurrency WHEN @ConsCurrency THEN 
				 	 SUM([ConsP1ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=1  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))
					 + SUM([ConsP2ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=2  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))	
					+ SUM([ConsP3ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=3  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))
					+ SUM([ConsP4ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=4  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))
					+ SUM([ConsP5ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=5  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))	
					+ SUM([ConsP6ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=6  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))
					+ SUM([ConsP7ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=7  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))
					+ SUM([ConsP8ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=8  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))
					+ SUM([ConsP9ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=9  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))
					+ SUM([ConsP10ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=10  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))	
					+ SUM([ConsP11ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=11  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))	
					+ SUM([ConsP12ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >= 12  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))	
		
				WHEN @FuncCurrency THEN
					SUM([FuncP1ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=1  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))
					+ SUM([FuncP2ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=2  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))	
					+ SUM([FuncP3ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=3  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))
					+ SUM([FuncP4ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=4  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))
					+ SUM([FuncP5ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=5  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))	
					+ SUM([FuncP6ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=6  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))
					+ SUM([FuncP7ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=7  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))
					+ SUM([FuncP8ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=8  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))
					+ SUM([FuncP9ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=9  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))
					+ SUM([FuncP10ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=10  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))	
					+ SUM([FuncP11ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=11  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))	
					+ SUM([FuncP12ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >= 12  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))			    
				END AS [PY Actual]
FROM        FactProfitAndLossSummary  AS LYPL 
			LEFT OUTER JOIN MapFinancialTemplate as FT   ON FT.AccountSkey = LYPL.AccountSkey 
			INNER JOIN DimAccount DA ON LYPL.AccountSkey  = DA.AccountSkey
			INNER JOIN DimCalendarPeriod AS CP ON LYPL.PostPeriodSkey = CP.FiscalPeriodSkey
			WHERE  (LYPL.PostPeriodSkey = cast (substring (cast ((((@pFiscalPeriod-100)/100)*100 + 12)   as varchar(10)), 1, 6) as integer) ) 
					AND (FT.TemplateID = @pTemplate)
					AND LYPL.OrgSkey IN	( Select * from dbo.STRING_SPLIT(@pOrg, ','))
					AND FT.GroupID not in (60)	-- added

			GROUP BY  FT.GroupID 
				 ,DA.AccountID	-- added
				 ,FT.TemplateID
				 ,LYPL.[OrgSkey]
				 ,CP.FiscalPeriodNumber
		
		)LYPL
ON CYPL.GroupID = LYPL.GroupID
			 AND CYPL.AccountID = LYPL.AccountID	-- added
			 AND CYPL.TemplateID = LYPL.TemplateID
			 AND CYPL.OrgSkey = LYPL.OrgSkey
		INNER JOIN [dbo].[DimOrganization] as DO ON CYPL.OrgSkey = DO.OrgSkey

GROUP BY  CYPL.TemplateID
				 ,Case @pLanguage When @ENLanguage THEN	Case @pGroup1Level	WHEN 'A' THEN	DO.[TerritoryDescEN]
												WHEN 'I' THEN	DO.[ProductLineDescEN]
												WHEN 'B' THEN	DO.[GeographicRegionDescEN]
												WHEN 'C' THEN	DO.[CompanyDescEN]
												WHEN 'D' THEN	DO.[RegionDescEN]
												WHEN 'E' THEN	DO.[MarketSegmentDescEN]
												WHEN 'F' THEN	DO.[SubMarketSegmentDescEN]
												WHEN 'G' THEN	DO.[LocationDescEN]
												WHEN 'H' THEN	DO.[BusinessUnitDescEN]
												WHEN 'Z' THEN	'None'
												END
									 WHEN @FRLanguage THEN CASE  @pGroup1Level	WHEN 'A' THEN	DO.[TerritoryDescFR]
												WHEN 'I' THEN	DO.[ProductLineDescFR]
												WHEN 'B' THEN	DO.[GeographicRegionDescFR]
												WHEN 'C' THEN	DO.[CompanyDescFR]
												WHEN 'D' THEN	DO.[RegionDescFR]
												WHEN 'E' THEN	DO.[MarketSegmentDescFR]
												WHEN 'F' THEN	DO.[SubMarketSegmentDescFR]
												WHEN 'G' THEN	DO.[LocationDescFR]
												WHEN 'H' THEN	DO.[BusinessUnitDescFR]
												WHEN 'Z' THEN	'None'
												END
							END 
					,Case @pLanguage When @ENLanguage THEN	Case @pGroup2Level	WHEN 'A' THEN	DO.[TerritoryDescEN]
												WHEN 'I' THEN	DO.[ProductLineDescEN]
												WHEN 'B' THEN	DO.[GeographicRegionDescEN]
												WHEN 'C' THEN	DO.[CompanyDescEN]
												WHEN 'D' THEN	DO.[RegionDescEN]
												WHEN 'E' THEN	DO.[MarketSegmentDescEN]
												WHEN 'F' THEN	DO.[SubMarketSegmentDescEN]
												WHEN 'G' THEN	DO.[LocationDescEN]
												WHEN 'H' THEN	DO.[BusinessUnitDescEN]
												WHEN 'Z' THEN	'None'
												END
									 WHEN @FRLanguage THEN CASE  @pGroup2Level	WHEN 'A' THEN	DO.[TerritoryDescFR]
												WHEN 'I' THEN	DO.[ProductLineDescFR]
												WHEN 'B' THEN	DO.[GeographicRegionDescFR]
												WHEN 'C' THEN	DO.[CompanyDescFR]
												WHEN 'D' THEN	DO.[RegionDescFR]
												WHEN 'E' THEN	DO.[MarketSegmentDescFR]
												WHEN 'F' THEN	DO.[SubMarketSegmentDescFR]
												WHEN 'G' THEN	DO.[LocationDescFR]
												WHEN 'H' THEN	DO.[BusinessUnitDescFR]
												WHEN 'Z' THEN	'None'
												END
							END
					,Case @pLanguage When @ENLanguage THEN	Case @pGroup3Level	WHEN 'A' THEN	DO.[TerritoryDescEN]
												WHEN 'I' THEN	DO.[ProductLineDescEN]
												WHEN 'B' THEN	DO.[GeographicRegionDescEN]
												WHEN 'C' THEN	DO.[CompanyDescEN]
												WHEN 'D' THEN	DO.[RegionDescEN]
												WHEN 'E' THEN	DO.[MarketSegmentDescEN]
												WHEN 'F' THEN	DO.[SubMarketSegmentDescEN]
												WHEN 'G' THEN	DO.[LocationDescEN]
												WHEN 'H' THEN	DO.[BusinessUnitDescEN]
												WHEN 'Z' THEN	'None'
												END
									 WHEN @FRLanguage THEN CASE  @pGroup3Level	WHEN 'A' THEN	DO.[TerritoryDescFR]
												WHEN 'I' THEN	DO.[ProductLineDescFR]
												WHEN 'B' THEN	DO.[GeographicRegionDescFR]
												WHEN 'C' THEN	DO.[CompanyDescFR]
												WHEN 'D' THEN	DO.[RegionDescFR]
												WHEN 'E' THEN	DO.[MarketSegmentDescFR]
												WHEN 'F' THEN	DO.[SubMarketSegmentDescFR]
												WHEN 'G' THEN	DO.[LocationDescFR]
												WHEN 'H' THEN	DO.[BusinessUnitDescFR]
												WHEN 'Z' THEN	'None'
												END
							END
					,Case @pGroup1Level			WHEN 'I' THEN	DO.[ProductLineID]
												WHEN 'B' THEN	DO.[GeographicRegionID]
												WHEN 'C' THEN	DO.[CompanyID]
												WHEN 'D' THEN	DO.[RegionID]
												WHEN 'E' THEN	DO.[MarketSegmentID]
												WHEN 'F' THEN	DO.[SubMarketSegmentID]
												WHEN 'G' THEN	DO.[LocationID]
												WHEN 'H' THEN	DO.[BusinessUnitID]
												WHEN 'Z' THEN	'None'
												
							END
					,Case @pGroup2Level			WHEN 'I' THEN	DO.[ProductLineID]
												WHEN 'B' THEN	DO.[GeographicRegionID]
												WHEN 'C' THEN	DO.[CompanyID]
												WHEN 'D' THEN	DO.[RegionID]
												WHEN 'E' THEN	DO.[MarketSegmentID]
												WHEN 'F' THEN	DO.[SubMarketSegmentID]
												WHEN 'G' THEN	DO.[LocationID]
												WHEN 'H' THEN	DO.[BusinessUnitID]
												WHEN 'Z' THEN	'None'
												
							END
					,Case @pGroup3Level			WHEN 'I' THEN	DO.[ProductLineID]
												WHEN 'B' THEN	DO.[GeographicRegionID]
												WHEN 'C' THEN	DO.[CompanyID]
												WHEN 'D' THEN	DO.[RegionID]
												WHEN 'E' THEN	DO.[MarketSegmentID]
												WHEN 'F' THEN	DO.[SubMarketSegmentID]
												WHEN 'G' THEN	DO.[LocationID]
												WHEN 'H' THEN	DO.[BusinessUnitID]
												WHEN 'Z' THEN	'None'
												
							END 
					,CYPL.GroupID
					,CYPL.AccountID	-- added
					,CYPL.SortOrder
					,CYPL.GroupDesc
					,CYPL.AccountDesc	-- added	
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
					,CYPL.FiscalPeriodNumber
					
			
		)
--END OF CTE
SELECT  Template.*
,ISNULL([Current Month Amount],0.000000) AS [Current Month Amount]--Not use
,ISNULL([Current Month Budget Amount],0.000000) AS [Current Month Budget Amount]--Not use
,ISNULL([YTD Amount],0.000000) AS [YTD Amount]--YTD
,ISNULL([Current Month Forecast 1 Amount],0.000000) AS [Current Month Forecast 1 Amount]--Forecast Current Q1
,ISNULL([Current Month Forecast 2 Amount],0.000000) AS [Current Month Forecast 2 Amount]--Forecast Current Q2
,ISNULL([Current Month Forecast 3 Amount],0.000000) AS [Current Month Forecast 3 Amount]--Forecast Current Q3
,ISNULL([YTD Budget Amount],0.000000) AS [YTD Budget Amount]--BudgetYTD
,ISNULL([Current Year Budget Amount],0.000000) AS [Current Year Budget Amount]--BudgetAmount
,ISNULL([YTD Forecast 1 Amount],0.000000) AS [YTD Forecast 1 Amount]--Forecast YTD Q1
,ISNULL([YTD Forecast 2 Amount],0.000000) AS [YTD Forecast 2 Amount]--Forecast YTD Q2
,ISNULL([YTD Forecast 3 Amount],0.000000) AS [YTD Forecast 3 Amount]--Forecast YTD Q3
,ISNULL([NYBudget],0.000000) AS [NYBudget]
,ISNULL([NY Forecast 1 Amonut],0.000000) AS [NY Forecast 1 Amonut]
,ISNULL([NY Forecast 2 Amonut],0.000000) AS [NY Forecast 2 Amonut]
,ISNULL([NY Forecast 3 Amonut],0.000000) AS [NY Forecast 3 Amonut]
,ISNULL([Period 1 Forecast 1 Amount],0.000000) AS [Period 1 Forecast 1 Amount]
,ISNULL([Period 2 Forecast 1 Amount],0.000000) AS [Period 2 Forecast 1 Amount]
,ISNULL([Period 3 Forecast 1 Amount],0.000000) AS [Period 3 Forecast 1 Amount]
,ISNULL([Period 4 Forecast 1 Amount],0.000000) AS [Period 4 Forecast 1 Amount]
,ISNULL([Period 5 Forecast 1 Amount],0.000000) AS [Period 5 Forecast 1 Amount]
,ISNULL([Period 6 Forecast 1 Amount],0.000000) AS [Period 6 Forecast 1 Amount]
,ISNULL([Period 7 Forecast 1 Amount],0.000000) AS [Period 7 Forecast 1 Amount]
,ISNULL([Period 8 Forecast 1 Amount],0.000000) AS [Period 8 Forecast 1 Amount]
,ISNULL([Period 9 Forecast 1 Amount],0.000000) AS [Period 9 Forecast 1 Amount]
,ISNULL([Period 10 Forecast 1 Amount],0.000000) AS [Period 10 Forecast 1 Amount]
,ISNULL([Period 11 Forecast 1 Amount],0.000000) AS [Period 11 Forecast 1 Amount]
,ISNULL([Period 12 Forecast 1 Amount],0.000000) AS [Period 12 Forecast 1 Amount]
,ISNULL([Period 1 Forecast 2 Amount],0.000000) AS [Period 1 Forecast 2 Amount]
,ISNULL([Period 2 Forecast 2 Amount],0.000000) AS [Period 2 Forecast 2 Amount]
,ISNULL([Period 3 Forecast 2 Amount],0.000000) AS [Period 3 Forecast 2 Amount]
,ISNULL([Period 4 Forecast 2 Amount],0.000000) AS [Period 4 Forecast 2 Amount]
,ISNULL([Period 5 Forecast 2 Amount],0.000000) AS [Period 5 Forecast 2 Amount]
,ISNULL([Period 6 Forecast 2 Amount],0.000000) AS [Period 6 Forecast 2 Amount]
,ISNULL([Period 7 Forecast 2 Amount],0.000000) AS [Period 7 Forecast 2 Amount]
,ISNULL([Period 8 Forecast 2 Amount],0.000000) AS [Period 8 Forecast 2 Amount]
,ISNULL([Period 9 Forecast 2 Amount],0.000000) AS [Period 9 Forecast 2 Amount]
,ISNULL([Period 10 Forecast 2 Amount],0.000000) AS [Period 10 Forecast 2 Amount]
,ISNULL([Period 11 Forecast 2 Amount],0.000000) AS [Period 11 Forecast 2 Amount]
,ISNULL([Period 12 Forecast 2 Amount],0.000000) AS [Period 12 Forecast 2 Amount]
,ISNULL([Period 1 Forecast 3 Amount],0.000000) AS [Period 1 Forecast 3 Amount]
,ISNULL([Period 2 Forecast 3 Amount],0.000000) AS [Period 2 Forecast 3 Amount]
,ISNULL([Period 3 Forecast 3 Amount],0.000000) AS [Period 3 Forecast 3 Amount]
,ISNULL([Period 4 Forecast 3 Amount],0.000000) AS [Period 4 Forecast 3 Amount]
,ISNULL([Period 5 Forecast 3 Amount],0.000000) AS [Period 5 Forecast 3 Amount]
,ISNULL([Period 6 Forecast 3 Amount],0.000000) AS [Period 6 Forecast 3 Amount]
,ISNULL([Period 7 Forecast 3 Amount],0.000000) AS [Period 7 Forecast 3 Amount]
,ISNULL([Period 8 Forecast 3 Amount],0.000000) AS [Period 8 Forecast 3 Amount]
,ISNULL([Period 9 Forecast 3 Amount],0.000000) AS [Period 9 Forecast 3 Amount]
,ISNULL([Period 10 Forecast 3 Amount],0.000000) AS [Period 10 Forecast 3 Amount]
,ISNULL([Period 11 Forecast 3 Amount],0.000000) AS [Period 11 Forecast 3 Amount]
,ISNULL([Period 12 Forecast 3 Amount],0.000000) AS [Period 12 Forecast 3 Amount]
,ISNULL([PYActual],0.000000) AS [PYActual]
--NR		
,ISNULL(NRCTE.[Current_Net_Revenues],0.000000) AS [Current_Net_Revenues]
,ISNULL(NRCTE.[Budget_Current_Net_Revenues],0.000000) AS [Budget_Current_Net_Revenues]
,ISNULL(NRCTE.[Forecast_Current_Net_Revenues_Q1],0.000000) AS [Forecast_Current_Net_Revenues_Q1]
,ISNULL(NRCTE.[Forecast_Current_Net_Revenues_Q2],0.000000) AS [Forecast_Current_Net_Revenues_Q2]
,ISNULL(NRCTE.[Forecast_Current_Net_Revenues_Q3],0.000000) AS [Forecast_Current_Net_Revenues_Q3]
,ISNULL(NRCTE.[YTD_Net_Revenues],0.000000) AS [YTD_Net_Revenues]
,ISNULL(NRCTE.[Budget_YTD_Net_Revenues],0.000000) AS [Budget_YTD_Net_Revenues]
,ISNULL(NRCTE.[Forecast_YTD_Net_Revenues_Q1],0.000000) AS [Forecast_YTD_Net_Revenues_Q1]
,ISNULL(NRCTE.[Forecast_YTD_Net_Revenues_Q2],0.000000) AS [Forecast_YTD_Net_Revenues_Q2]
,ISNULL(NRCTE.[Forecast_YTD_Net_Revenues_Q3],0.000000) AS [Forecast_YTD_Net_Revenues_Q3]
,ISNULL(NRCTE.[Budget_Amount_Net_Revenues],0.000000) AS [Budget_Amount_Net_Revenues]
,ISNULL(NRCTE.[NYBudget_Net_Revenue],0.000000) AS [NYBudget_Net_Revenue]
,ISNULL(NRCTE.[Forecast_NY_Net_Revenues_Q1],0.000000) AS [Forecast_NY_Net_Revenues_Q1]
,ISNULL(NRCTE.[Forecast_NY_Net_Revenues_Q2],0.000000) AS [Forecast_NY_Net_Revenues_Q2]
,ISNULL(NRCTE.[Forecast_NY_Net_Revenues_Q3],0.000000) AS [Forecast_NY_Net_Revenues_Q3]
,ISNULL(NRCTE.[PYActual_Net_Revenues],0.000000) AS [PYActual_Net_Revenues]
--DL				    
,ISNULL(DLCTE.[Current_Direct_Labor],0.000000) AS [Current_Direct_Labor]
,ISNULL(DLCTE.Budget_Current_Direct_Labor,0.000000) AS Budget_Current_Direct_Labor
,ISNULL(DLCTE.Forecast_Current_Direct_Labor_Q1,0.000000) AS Forecast_Current_Direct_Labor_Q1
,ISNULL(DLCTE.Forecast_Current_Direct_Labor_Q2,0.000000) AS Forecast_Current_Direct_Labor_Q2
,ISNULL(DLCTE.Forecast_Current_Direct_Labor_Q3,0.000000) AS Forecast_Current_Direct_Labor_Q3
,ISNULL(DLCTE.YTD_Direct_Labor,0.000000) AS YTD_Direct_Labor
,ISNULL(DLCTE.Budget_YTD_Direct_Labor,0.000000) AS Budget_YTD_Direct_Labor
,ISNULL(DLCTE.Forecast_YTD_Direct_Labor_Q1,0.000000) AS Forecast_YTD_Direct_Labor_Q1
,ISNULL(DLCTE.Forecast_YTD_Direct_Labor_Q2,0.000000) AS Forecast_YTD_Direct_Labor_Q2
,ISNULL(DLCTE.Forecast_YTD_Direct_Labor_Q3,0.000000) AS Forecast_YTD_Direct_Labor_Q3
,ISNULL(DLCTE.Budget_Amount_Direct_Labor,0.000000) AS Budget_Amount_Direct_Labor
,ISNULL(DLCTE.NYBudget_Direct_Labor,0.000000) AS NYBudget_Direct_Labor
,ISNULL(DLCTE.Forecast_NY_Direct_Labor_Q1,0.000000) AS Forecast_NY_Direct_Labor_Q1
,ISNULL(DLCTE.Forecast_NY_Direct_Labor_Q2,0.000000) AS Forecast_NY_Direct_Labor_Q2
,ISNULL(DLCTE.Forecast_NY_Direct_Labor_Q3,0.000000) AS Forecast_NY_Direct_Labor_Q3
,ISNULL(DLCTE.[PYActual_Direct_Labor],0.000000) AS [PYActual_Direct_Labor]
--FB					
,ISNULL(FBCTE.Current_FringeBenefits,0.000000) AS Current_FringeBenefits
,ISNULL(FBCTE.Budget_Current_FringeBenefits,0.000000) AS Budget_Current_FringeBenefits
,ISNULL(FBCTE.Forecast_Current_FringeBenefits_Q1,0.000000) AS Forecast_Current_FringeBenefits_Q1
,ISNULL(FBCTE.Forecast_Current_FringeBenefits_Q2,0.000000) AS Forecast_Current_FringeBenefits_Q2
,ISNULL(FBCTE.Forecast_Current_FringeBenefits_Q3,0.000000) AS Forecast_Current_FringeBenefits_Q3
,ISNULL(FBCTE.YTD_FringeBenefits,0.000000) AS YTD_FringeBenefits
,ISNULL(FBCTE.Budget_YTD_FringeBenefits,0.000000) AS Budget_YTD_FringeBenefits
,ISNULL(FBCTE.Forecast_YTD_FringeBenefits_Q1,0.000000) AS Forecast_YTD_FringeBenefits_Q1
,ISNULL(FBCTE.Forecast_YTD_FringeBenefits_Q2,0.000000) AS Forecast_YTD_FringeBenefits_Q2
,ISNULL(FBCTE.Forecast_YTD_FringeBenefits_Q3,0.000000) AS Forecast_YTD_FringeBenefits_Q3
,ISNULL(FBCTE.Budget_Amount_FringeBenefits,0.000000) AS Budget_Amount_FringeBenefits
,ISNULL(FBCTE.[NYBudget_DFringeBenefits],0.000000) AS [NYBudget_DFringeBenefits]
,ISNULL(FBCTE.[Forecast_NY_FringeBenefits_Q1],0.000000) AS [Forecast_NY_FringeBenefits_Q1]
,ISNULL(FBCTE.[Forecast_NY_FringeBenefits_Q2],0.000000) AS [Forecast_NY_FringeBenefits_Q2]
,ISNULL(FBCTE.[Forecast_NY_FringeBenefits_Q3],0.000000) AS [Forecast_NY_FringeBenefits_Q3]
,ISNULL(FBCTE.[PYActual_FringeBenefits],0.000000) AS [PYActual_FringeBenefits]
--SA
,ISNULL(SACTE.Current_Salaries,0.000000) AS Current_Salaries
,ISNULL(SACTE.Budget_Current_Salaries,0.000000) AS Budget_Current_Salaries
,ISNULL(SACTE.Forecast_Current_Salaries_Q1,0.000000) AS Forecast_Current_Salaries_Q1
,ISNULL(SACTE.Forecast_Current_Salaries_Q2,0.000000) AS Forecast_Current_Salaries_Q2
,ISNULL(SACTE.Forecast_Current_Salaries_Q3,0.000000) AS Forecast_Current_Salaries_Q3
,ISNULL(SACTE.YTD_Salaries,0.000000) AS YTD_Salaries
,ISNULL(SACTE.Budget_YTD_Salaries,0.000000) AS Budget_YTD_Salaries
,ISNULL(SACTE.Forecast_YTD_Salaries_Q1,0.000000) AS Forecast_YTD_Salaries_Q1
,ISNULL(SACTE.Forecast_YTD_Salaries_Q2,0.000000) AS Forecast_YTD_Salaries_Q2
,ISNULL(SACTE.Forecast_YTD_Salaries_Q3,0.000000) AS Forecast_YTD_Salaries_Q3
,ISNULL(SACTE.Budget_Amount_Salaries,0.000000) AS Budget_Amount_Salaries
,ISNULL(SACTE.[NYBudget_Salaries],0.000000) AS [NYBudget_Salaries]
,ISNULL(SACTE.[Forecast_NY_Salaries_Q1],0.000000) AS [Forecast_NY_Salaries_Q1]
,ISNULL(SACTE.[Forecast_NY_Salaries_Q2],0.000000) AS [Forecast_NY_Salaries_Q2]
,ISNULL(SACTE.[Forecast_NY_Salaries_Q3],0.000000) AS [Forecast_NY_Salaries_Q3]
,ISNULL(SACTE.[PYActual_Salaries],0.000000) AS [PYActual_Salaries]
--EBGE
,ISNULL(EBGECTE.Current_EBGE,0.000000) AS Current_EBGE
,ISNULL(EBGECTE.Budget_Current_EBGE,0.000000) AS Budget_Current_EBGE
,ISNULL(EBGECTE.Forecast_Current_EBGE_Q1,0.000000) AS Forecast_Current_EBGE_Q1
,ISNULL(EBGECTE.Forecast_Current_EBGE_Q2,0.000000) AS Forecast_Current_EBGE_Q2
,ISNULL(EBGECTE.Forecast_Current_EBGE_Q3,0.000000) AS Forecast_Current_EBGE_Q3
,ISNULL(EBGECTE.YTD_EBGE,0.000000) AS YTD_EBGE
,ISNULL(EBGECTE.Budget_YTD_EBGE,0.000000) AS Budget_YTD_EBGE
,ISNULL(EBGECTE.Forecast_YTD_EBGE_Q1,0.000000) AS Forecast_YTD_EBGE_Q1
,ISNULL(EBGECTE.Forecast_YTD_EBGE_Q2,0.000000) AS Forecast_YTD_EBGE_Q2
,ISNULL(EBGECTE.Forecast_YTD_EBGE_Q3,0.000000) AS Forecast_YTD_EBGE_Q3
,ISNULL(EBGECTE.Budget_Amount_EBGE,0.000000) AS Budget_Amount_EBGE
,ISNULL(EBGECTE.[NYBudget_EBGE],0.000000) AS [NYBudget_EBGE]
,ISNULL(EBGECTE.[Forecast_NY_EBGE_Q1],0.000000) AS [Forecast_NY_EBGE_Q1]
,ISNULL(EBGECTE.[Forecast_NY_EBGE_Q2],0.000000) AS [Forecast_NY_EBGE_Q2]
,ISNULL(EBGECTE.[Forecast_NY_EBGE_Q3],0.000000) AS [Forecast_NY_EBGE_Q3]
,ISNULL(EBGECTE.[PYActual_EBGE],0.000000) AS [PYActual_EBGE]
--EBRE
,ISNULL(EBRECTE.Current_EBRE,0.000000) AS Current_EBRE
,ISNULL(EBRECTE.Budget_Current_EBRE,0.000000) AS Budget_Current_EBRE
,ISNULL(EBRECTE.Forecast_Current_EBRE_Q1,0.000000) AS Forecast_Current_EBRE_Q1
,ISNULL(EBRECTE.Forecast_Current_EBRE_Q2,0.000000) AS Forecast_Current_EBRE_Q2
,ISNULL(EBRECTE.Forecast_Current_EBRE_Q3,0.000000) AS Forecast_Current_EBRE_Q3
,ISNULL(EBRECTE.YTD_EBRE,0.000000) AS YTD_EBRE
,ISNULL(EBRECTE.Budget_YTD_EBRE,0.000000) AS Budget_YTD_EBRE
,ISNULL(EBRECTE.Forecast_YTD_EBRE_Q1,0.000000) AS Forecast_YTD_EBRE_Q1
,ISNULL(EBRECTE.Forecast_YTD_EBRE_Q2,0.000000) AS Forecast_YTD_EBRE_Q2
,ISNULL(EBRECTE.Forecast_YTD_EBRE_Q3,0.000000) AS Forecast_YTD_EBRE_Q3
,ISNULL(EBRECTE.Budget_Amount_EBRE,0.000000) AS Budget_Amount_EBRE
,ISNULL(EBRECTE.[NYBudget_EBRE],0.000000) AS [NYBudget_EBRE]
,ISNULL(EBRECTE.[Forecast_NY_EBRE_Q1],0.000000) AS [Forecast_NY_EBRE_Q1]
,ISNULL(EBRECTE.[Forecast_NY_EBRE_Q2],0.000000) AS [Forecast_NY_EBRE_Q2]
,ISNULL(EBRECTE.[Forecast_NY_EBRE_Q3],0.000000) AS [Forecast_NY_EBRE_Q3]
,ISNULL(EBRECTE.[PYActual_EBRE],0.000000) AS [PYActual_EBRE]
--EBITDA
,ISNULL(EBITDACTE.Current_EBITDA,0.000000) AS Current_EBITDA
,ISNULL(EBITDACTE.Budget_Current_EBITDA,0.000000) AS Budget_Current_EBITDA
,ISNULL(EBITDACTE.Forecast_Current_EBITDA_Q1,0.000000) AS Forecast_Current_EBITDA_Q1
,ISNULL(EBITDACTE.Forecast_Current_EBITDA_Q2,0.000000) AS Forecast_Current_EBITDA_Q2
,ISNULL(EBITDACTE.Forecast_Current_EBITDA_Q3,0.000000) AS Forecast_Current_EBITDA_Q3
,ISNULL(EBITDACTE.YTD_EBITDA,0.000000) AS YTD_EBITDA
,ISNULL(EBITDACTE.Budget_YTD_EBITDA,0.000000) AS Budget_YTD_EBITDA
,ISNULL(EBITDACTE.Forecast_YTD_EBITDA_Q1,0.000000) AS Forecast_YTD_EBITDA_Q1
,ISNULL(EBITDACTE.Forecast_YTD_EBITDA_Q2,0.000000) AS Forecast_YTD_EBITDA_Q2
,ISNULL(EBITDACTE.Forecast_YTD_EBITDA_Q3,0.000000) AS Forecast_YTD_EBITDA_Q3
,ISNULL(EBITDACTE.Budget_Amount_EBITDA,0.000000) AS Budget_Amount_EBITDA
,ISNULL(EBITDACTE.[NYBudget_EBITDA],0.000000) AS [NYBudget_EBITDA]
,ISNULL(EBITDACTE.[Forecast_NY_EBITDA_Q1],0.000000) AS [Forecast_NY_EBITDA_Q1]
,ISNULL(EBITDACTE.[Forecast_NY_EBITDA_Q2],0.000000) AS [Forecast_NY_EBITDA_Q2]
,ISNULL(EBITDACTE.[Forecast_NY_EBITDA_Q3],0.000000) AS [Forecast_NY_EBITDA_Q3]
,ISNULL(EBITDACTE.[PYActual_EBITDA],0.000000) AS [PYActual_EBITDA]		 

FROM(
SELECT Group1Level,Group2Level,Group3Level,Group1LevelID,Group2LevelID,Group3LevelID,Templ.*
			
						FROM	(select Distinct TemplateID
									,GroupID 
								  ,Case @pLanguage When @ENLanguage THEN GroupDescEN 
									  WHEN @FRLanguage THEN GroupDescFR
									  Else 'Unknown'
									END as GroupDesc
									,AccountID	-- added
								  ,Case @pLanguage When @ENLanguage THEN AccountNameEN 
									  WHEN @FRLanguage THEN AccountNameFR 
									  Else 'Unknown'
									END as AccountDesc	-- added
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
						INNER JOIN dbo.DimAccount on		-- added
							MT.accountskey = dimaccount.accountskey
						WHERE [TemplateID] = @pTemplate 
						AND MT.GroupID not in (60) -- added
						)Templ
						 CROSS JOIN ( Select Distinct Group1Level,Group2Level,Group3Level,Group1LevelID,Group2LevelID,Group3LevelID
										FROM ProfitandLossCTE
										)DistGroup
						)Template
LEFT OUTER JOIN ProfitandLossCTE as PCTE ON Template.TemplateID = PCTE.TemplateID
													AND Template.GroupID = PCTE.GroupId
													AND Template.AccountId = PCTE.AccountId	-- added
													AND Template.Group1level = PCTE.Group1level
													AND Template.Group2level = PCTE.Group2level
													AND Template.Group3level = PCTE.Group3level
LEFT OUTER JOIN(
					Select  GroupID,Group1Level,Group2Level,Group3Level			
				   ,[Current Month Amount] as [Current_Net_Revenues] --1
			       ,[Current Month Budget Amount] as   [Budget_Current_Net_Revenues]--2
				   ,[Current Month Forecast 1 Amount] as [Forecast_Current_Net_Revenues_Q1]--3
				   ,[Current Month Forecast 2 Amount] as [Forecast_Current_Net_Revenues_Q2]--4
				   ,[Current Month Forecast 3 Amount] as [Forecast_Current_Net_Revenues_Q3]--5
				   ,[YTD Amount] as [YTD_Net_Revenues]--6
				   ,[YTD Budget Amount] as [Budget_YTD_Net_Revenues]--7
				   ,[YTD Forecast 1 Amount] as  [Forecast_YTD_Net_Revenues_Q1]--8
				   ,[YTD Forecast 2 Amount] as  [Forecast_YTD_Net_Revenues_Q2]--9
				   ,[YTD Forecast 3 Amount] as  [Forecast_YTD_Net_Revenues_Q3]--10
				   ,[Current Year Budget Amount]  as [Budget_Amount_Net_Revenues]--11
				   ,[NYBudget] as [NYBudget_Net_Revenue]--12
				   ,[NY Forecast 1 Amonut] as [Forecast_NY_Net_Revenues_Q1]--13
				   ,[NY Forecast 2 Amonut] AS [Forecast_NY_Net_Revenues_Q2]--14
				   ,[NY Forecast 3 Amonut] AS [Forecast_NY_Net_Revenues_Q3]--15
				   ,[PYActual] as [PYActual_Net_Revenues]--16
					FROM ProfitandLossCTE 
					WHERE [IsNetRevenues] = 'Y')NRCTE  on   --(Template.GroupId is not NULL)
														Template.Group1level = NRCTE.Group1level
													AND Template.Group2level = NRCTE.Group2level
													AND Template.Group3level = NRCTE.Group3level
LEFT OUTER JOIN (
					Select GroupID,Group1Level,Group2Level,Group3Level
				   ,[Current Month Amount] as [Current_Direct_Labor]
			       ,[Current Month Budget Amount] as   [Budget_Current_Direct_Labor]
				   ,[Current Month Forecast 1 Amount] as [Forecast_Current_Direct_Labor_Q1]
				   ,[Current Month Forecast 2 Amount] as [Forecast_Current_Direct_Labor_Q2]
				   ,[Current Month Forecast 3 Amount] as [Forecast_Current_Direct_Labor_Q3]
				   ,[YTD Amount] as [YTD_Direct_Labor]
				   ,[YTD Budget Amount] as [Budget_YTD_Direct_Labor]
				   ,[YTD Forecast 1 Amount] as  [Forecast_YTD_Direct_Labor_Q1]
				   ,[YTD Forecast 2 Amount] as  [Forecast_YTD_Direct_Labor_Q2]
				   ,[YTD Forecast 3 Amount] as  [Forecast_YTD_Direct_Labor_Q3]
				   ,[Current Year Budget Amount]  as [Budget_Amount_Direct_Labor]
				   ,[NYBudget] as [NYBudget_Direct_Labor]
				   ,[NY Forecast 1 Amonut] as [Forecast_NY_Direct_Labor_Q1]
				   ,[NY Forecast 2 Amonut] AS [Forecast_NY_Direct_Labor_Q2]
				   ,[NY Forecast 3 Amonut] AS [Forecast_NY_Direct_Labor_Q3]
				   ,[PYActual] as [PYActual_Direct_Labor]
					FROM ProfitandLossCTE 
					WHERE [IsDirectLabor] = 'Y'
							   )DLCTE on Template.GroupId in (94,95,96,100,106,108)
													AND Template.Group1level = DLCTE.Group1level
													AND Template.Group2level = DLCTE.Group2level
													AND Template.Group3level = DLCTE.Group3level
LEFT OUTER JOIN (
				     Select GroupID,Group1Level,Group2Level,Group3Level
				   ,[Current Month Amount] as [Current_FringeBenefits]
			       ,[Current Month Budget Amount] as   [Budget_Current_FringeBenefits]
				   ,[Current Month Forecast 1 Amount] as [Forecast_Current_FringeBenefits_Q1]
				   ,[Current Month Forecast 2 Amount] as [Forecast_Current_FringeBenefits_Q2]
				   ,[Current Month Forecast 3 Amount] as [Forecast_Current_FringeBenefits_Q3]
				   ,[YTD Amount] as [YTD_FringeBenefits]
				   ,[YTD Budget Amount] as [Budget_YTD_FringeBenefits]
				   ,[YTD Forecast 1 Amount] as  [Forecast_YTD_FringeBenefits_Q1]
				   ,[YTD Forecast 2 Amount] as  [Forecast_YTD_FringeBenefits_Q2]
				   ,[YTD Forecast 3 Amount] as  [Forecast_YTD_FringeBenefits_Q3]
				   ,[Current Year Budget Amount]  as [Budget_Amount_FringeBenefits]
				   ,[NYBudget] as [NYBudget_DFringeBenefits]
				   ,[NY Forecast 1 Amonut] as [Forecast_NY_FringeBenefits_Q1]
				   ,[NY Forecast 2 Amonut] AS [Forecast_NY_FringeBenefits_Q2]
				   ,[NY Forecast 3 Amonut] AS [Forecast_NY_FringeBenefits_Q3]
				   ,[PYActual] as [PYActual_FringeBenefits]
					FROM ProfitandLossCTE 
					WHERE [IsFringeBenefits] = 'Y'
							   )FBCTE on Template.GroupId  in (94,95,96,100,106,108)
													AND Template.Group1level = FBCTE.Group1level
													AND Template.Group2level = FBCTE.Group2level
													AND Template.Group3level = FBCTE.Group3level
LEFT OUTER JOIN (
					Select Group1Level,Group2Level,Group3Level
	               ,SUM([Current Month Amount]) as [Current_Salaries]
			       ,SUM([Current Month Budget Amount]) as   [Budget_Current_Salaries]
				   ,SUM([Current Month Forecast 1 Amount]) as [Forecast_Current_Salaries_Q1]
				   ,SUM([Current Month Forecast 2 Amount]) as [Forecast_Current_Salaries_Q2]
				   ,SUM([Current Month Forecast 3 Amount]) as [Forecast_Current_Salaries_Q3]
				   ,SUM([YTD Amount]) as [YTD_Salaries]
				   ,SUM([YTD Budget Amount]) as [Budget_YTD_Salaries]
				   ,SUM([YTD Forecast 1 Amount]) as  [Forecast_YTD_Salaries_Q1]
				   ,SUM([YTD Forecast 2 Amount]) as  [Forecast_YTD_Salaries_Q2]
				   ,SUM([YTD Forecast 3 Amount]) as  [Forecast_YTD_Salaries_Q3]
				   ,SUM([Current Year Budget Amount])  as [Budget_Amount_Salaries]
				   ,SUM([NYBudget]) AS [NYBudget_Salaries]
				   ,SUM([NY Forecast 1 Amonut]) AS [Forecast_NY_Salaries_Q1]
				   ,SUM([NY Forecast 2 Amonut]) AS [Forecast_NY_Salaries_Q2]
				   ,SUM([NY Forecast 3 Amonut]) AS [Forecast_NY_Salaries_Q3]
				   ,SUM([PYActual]) AS [PYActual_Salaries]
					FROM ProfitandLossCTE 
					WHERE [IsDirectLabor] = 'Y' OR [IsManagementSalaries] = 'Y'
						 OR [IsMarketingSalaries] = 'Y' OR [IsTrainingSalaries] = 'Y'
						 GROUP BY  Group1Level,Group2Level,Group3Level
							   )SACTE on Template.GroupId in (94,95,96,100,106,108)
													AND Template.Group1level = SACTE.Group1level
													AND Template.Group2level = SACTE.Group2level
													AND Template.Group3level = SACTE.Group3level
LEFT OUTER JOIN (
					Select GroupID,Group1Level,Group2Level,Group3Level 
				   ,[Current Month Amount] as [Current_EBGE]
			       ,[Current Month Budget Amount] as   [Budget_Current_EBGE]
				   ,[Current Month Forecast 1 Amount] as [Forecast_Current_EBGE_Q1]
				   ,[Current Month Forecast 2 Amount] as [Forecast_Current_EBGE_Q2]
				   ,[Current Month Forecast 3 Amount] as [Forecast_Current_EBGE_Q3]
				   ,[YTD Amount] as [YTD_EBGE]
				   ,[YTD Budget Amount] as [Budget_YTD_EBGE]
				   ,[YTD Forecast 1 Amount] as  [Forecast_YTD_EBGE_Q1]
				   ,[YTD Forecast 2 Amount] as  [Forecast_YTD_EBGE_Q2]
				   ,[YTD Forecast 3 Amount] as  [Forecast_YTD_EBGE_Q3]
				   ,[Current Year Budget Amount]  as [Budget_Amount_EBGE]
				   ,[NYBudget] as [NYBudget_EBGE]
				   ,[NY Forecast 1 Amonut] as [Forecast_NY_EBGE_Q1]
				   ,[NY Forecast 2 Amonut] AS [Forecast_NY_EBGE_Q2]
				   ,[NY Forecast 3 Amonut] AS [Forecast_NY_EBGE_Q3]
				   ,[PYActual] as [PYActual_EBGE]
					FROM ProfitandLossCTE 
					WHERE [IsEBGE] = 'Y'
							   )EBGECTE on Template.GroupId in (94,95,96,100,106,108)
													AND Template.Group1level = EBGECTE.Group1level
													AND Template.Group2level = EBGECTE.Group2level
													AND Template.Group3level = EBGECTE.Group3level
LEFT OUTER JOIN (
					Select GroupID,Group1Level,Group2Level,Group3Level 
				   ,[Current Month Amount] as [Current_EBRE]
			       ,[Current Month Budget Amount] as   [Budget_Current_EBRE]
				   ,[Current Month Forecast 1 Amount] as [Forecast_Current_EBRE_Q1]
				   ,[Current Month Forecast 2 Amount] as [Forecast_Current_EBRE_Q2]
				   ,[Current Month Forecast 3 Amount] as [Forecast_Current_EBRE_Q3]
				   ,[YTD Amount] as [YTD_EBRE]
				   ,[YTD Budget Amount] as [Budget_YTD_EBRE]
				   ,[YTD Forecast 1 Amount] as  [Forecast_YTD_EBRE_Q1]
				   ,[YTD Forecast 2 Amount] as  [Forecast_YTD_EBRE_Q2]
				   ,[YTD Forecast 3 Amount] as  [Forecast_YTD_EBRE_Q3]
				   ,[Current Year Budget Amount]  as [Budget_Amount_EBRE]
				   ,[NYBudget] as [NYBudget_EBRE]
				   ,[NY Forecast 1 Amonut] as [Forecast_NY_EBRE_Q1]
				   ,[NY Forecast 2 Amonut] AS [Forecast_NY_EBRE_Q2]
				   ,[NY Forecast 3 Amonut] AS [Forecast_NY_EBRE_Q3]
				   ,[PYActual] as [PYActual_EBRE]
					FROM ProfitandLossCTE 
					WHERE [IsEBRE] = 'Y'
							   )EBRECTE on Template.GroupId	in (94,95,96,100,106,108)
													AND Template.Group1level = EBRECTE.Group1level
													AND Template.Group2level = EBRECTE.Group2level
													AND Template.Group3level = EBRECTE.Group3level
LEFT OUTER JOIN (
					Select GroupID,Group1Level,Group2Level,Group3Level
				   ,[Current Month Amount] as [Current_EBITDA]
			       ,[Current Month Budget Amount] as   [Budget_Current_EBITDA]
				   ,[Current Month Forecast 1 Amount] as [Forecast_Current_EBITDA_Q1]
				   ,[Current Month Forecast 2 Amount] as [Forecast_Current_EBITDA_Q2]
				   ,[Current Month Forecast 3 Amount] as [Forecast_Current_EBITDA_Q3]
				   ,[YTD Amount] as [YTD_EBITDA]
				   ,[YTD Budget Amount] as [Budget_YTD_EBITDA]
				   ,[YTD Forecast 1 Amount] as  [Forecast_YTD_EBITDA_Q1]
				   ,[YTD Forecast 2 Amount] as  [Forecast_YTD_EBITDA_Q2]
				   ,[YTD Forecast 3 Amount] as  [Forecast_YTD_EBITDA_Q3]
				   ,[Current Year Budget Amount]  as [Budget_Amount_EBITDA]
				   ,[NYBudget] as [NYBudget_EBITDA]
				   ,[NY Forecast 1 Amonut] as [Forecast_NY_EBITDA_Q1]
				   ,[NY Forecast 2 Amonut] AS [Forecast_NY_EBITDA_Q2]
				   ,[NY Forecast 3 Amonut] AS [Forecast_NY_EBITDA_Q3]
				   ,[PYActual] as [PYActual_EBITDA]
					FROM ProfitandLossCTE 
					WHERE [IsEBITDA] = 'Y'
							   )EBITDACTE on Template.GroupId  in (94,95,96,100,106,108) --EBITDACTE.GroupId
													AND Template.Group1level = EBITDACTE.Group1level
													AND Template.Group2level = EBITDACTE.Group2level
													AND Template.Group3level = EBITDACTE.Group3level
						              
ORDER BY  Template.Group1Level,Template.Group2Level,Template.Group3Level,Template.SortOrder,  Template.GroupID,  Template.GroupDesc
			
				

GO

