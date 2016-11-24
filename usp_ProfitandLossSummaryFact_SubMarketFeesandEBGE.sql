USE [BIDataWarehouse]
GO

/****** Object:  StoredProcedure [dbo].[usp_ProfitandLossSummaryFact_SubMarketFeesandEBGE]    Script Date: 24/11/2016 11:10:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[usp_ProfitandLossSummaryFact_SubMarketFeesandEBGE] 
	@pCurrency varchar(5),
	@pFiscalPeriod int,
	--@pTemplate int,
	@pLanguage int,
	@pFiscalPeriodOptions varchar(4),
	@pTerritory varchar(max),
	@pGeoRegion varchar(max),
	@pCompany varchar(max),
	@pRegion varchar(max)
	--@pOrg varchar(max),
 
	AS 

Declare @FuncCurrency as Varchar(5);
Declare @ConsCurrency as Varchar(5);
Declare @ENLanguage as int;
Declare @FRLanguage as int;
Declare @pTemplate as int;
SET @FuncCurrency = 'FUNC';
SET @ConsCurrency = 'CONS';
SET @ENLanguage = 1;
SET @FRLanguage = 2;
SET @pTemplate = 101;

;With ProfitandLossDetail
--(
--[Sub Market Segment Code],[Sub Market Segment],[Sub Market Segment Sort Order],
--[Actual Label],[Budget Label],[Budget Variance Label],[Last Year Actual Label], [YOY Variance],

--[Actual_Net_ Revenues],
--[Actual_EBRE],
--[Budget_Net_Revenues],
--[Budget_EBRE],
--[PY_Actual_Net_Revenues],
--[PY_Actual_EBRE]
--,[Budget_Variance_Net_Revenues],
--[Budget_Variance_EBRE],
--[Last_Year_Variance_Net_Revenues],
--[Last_Year_Variance_EBRE]

--)
AS
(
Select
FT.[IsRegionalExpenses],
FT.[IsNetRevenues],
FT.[IsEBRE],
DO.[MarketSegmentID],
DO.[SubMarketSegmentID],
--DO.[SubMarketSegmentID],
--//////////////////////////////////////////////////////////////////
DO.[SubMarketSegmentID] as [Sub Market Segment Code],

Case @pLanguage when @ENLanguage then  DO.[SubMarketSegmentDescEN]
				when @FRLanguage then  DO.[SubMarketSegmentDescFR] end
as [Sub Market Segment],

DO.[SubMarketSegmentSortOrder] as [Sub Market Segment Sort Order],

Case @pLanguage  When @FRLanguage Then 'En cours ' 
				 Else 'Actual ' End + cast(CP.[FiscalYear] AS char(4))
as [Actual Label],

'Budget ' +  cast(CP.[FiscalYear] AS char(4)) 
as [Budget Label],

Case @pLanguage When @FRLanguage Then 'Écart Budget ' 
                when @ENLanguage then 'Budget Variance ' End
as [Budget Variance Label],

Case @pLanguage When @FRLanguage Then 'En cours '
                When @ENLanguage Then  'Actual ' End + cast(CP.[FiscalYear]-1 AS char(4))
as [Last Year Actual Label],

Case @pLanguage When @FRLanguage Then 'Écart ' 
                When @ENLanguage Then 'Variance ' End + cast(CP.[FiscalYear] AS char(4)) + ' vs ' + cast(CP.[FiscalYear]-1 AS char(4))
as [YOY Variance],
--/////////////////////////////////////////////////////////////////////////////

Case 
When FT.[IsNetRevenues]  = 'Y' 
Then 
   Case 
   When @pFiscalPeriodOptions = 'CM' 
   Then 
         Case @pCurrency
         When @FuncCurrency Then PL.[FuncCMAmt]--[Current Month Functional Amount]
         When @ConsCurrency Then PL.[ConsCMAmt]--[Current Month Consolidated Amount]
         Else 0
         End
   When  @pFiscalPeriodOptions = 'YTD' 
   Then 
         Case @pCurrency
         When @FuncCurrency Then PL.[FuncYTDAmt]--[YTD Functional Amount]
         When @ConsCurrency Then  PL.[ConsYTDAmt]--[YTD Consolidated Amount]
         Else 0
         End
   Else 0
   End
Else 0
End
as [Actual_Net_ Revenues], 

CASE WHEN FT.[IsRegionalExpenses] = 'Y' THEN -1 
	 WHEN FT.[IsEBRE] = 'Y' OR FT.[IsNetRevenues] = 'Y' THEN 1 END
* Case 
   When @pFiscalPeriodOptions = 'CM' 
   Then 
         Case @pCurrency
         When @FuncCurrency  Then PL.[FuncCMAmt]--[Current Month Functional Amount]
         When @ConsCurrency  Then PL.[ConsCMAmt]--[Current Month Consolidated Amount]
         Else 0
         End
   When @pFiscalPeriodOptions = 'YTD' 
   Then 
         Case @pCurrency
         When @FuncCurrency  Then PL.[FuncYTDAmt]--[YTD Functional Amount]
         When @ConsCurrency  Then PL.[ConsYTDAmt]--[YTD Consolidated Amount]
         Else 0
         End
   Else 0
End 
as [Actual_EBRE],

Case 
When FT.[IsNetRevenues]  = 'Y' 
Then 
   Case 
   When @pFiscalPeriodOptions = 'CM'
   Then 
         Case @pCurrency
         When @FuncCurrency  Then PL.[FuncCMBudgetAmt]--[Current Month Budget Functional Amount]
         When @ConsCurrency  Then PL.[ConsCMBudgetAmt]--[Current Month Budget Consolidated Amount]
         Else 0
         End
   When @pFiscalPeriodOptions =  'YTD' 
   Then 
         Case @pCurrency
         When @FuncCurrency  Then PL.[FuncYTDBudgetAmt]--[YTD Budget Functional Amount]
         When @ConsCurrency  Then PL.[ConsYTDBudgetAmt]--[YTD Budget Consolidated Amount]
         Else 0
         End
   Else 0
   End
Else 0
End as  [Budget_Net_Revenues], 

CASE WHEN FT.[IsRegionalExpenses] = 'Y' THEN -1 
	 WHEN FT.[IsEBRE] = 'Y' OR FT.[IsNetRevenues] = 'Y' THEN 1 END
* Case 
   When @pFiscalPeriodOptions = 'CM' 
   Then 
         Case @pCurrency
         When @FuncCurrency Then PL.[FuncCMBudgetAmt]--[Current Month Budget Functional Amount]
         When @ConsCurrency Then PL.[ConsCMBudgetAmt]--[Current Month Budget Consolidated Amount]
         Else 0
         End
   When @pFiscalPeriodOptions = 'YTD'
   Then 
         Case @pCurrency
         When @FuncCurrency Then PL.[FuncYTDBudgetAmt]--[YTD Budget Functional Amount]
         When @ConsCurrency Then PL.[ConsYTDBudgetAmt]--[YTD Budget Consolidated Amount]
         Else 0
         End
   Else 0
End
as [Budget_EBRE],

Case 
When FT.[IsNetRevenues]  = 'Y' 
Then 
   Case 
   When @pFiscalPeriodOptions = 'CM' 
   Then 
         Case @pCurrency
         When @FuncCurrency Then PL.[FuncLYCMAmt]--[Prior Year Current Month Functional Amount]
         When @ConsCurrency Then PL.[ConsLYCMAmt]--[Prior Year Current Month Consolidated Amount]
         Else 0
         End
   When @pFiscalPeriodOptions = 'YTD'
   Then 
         Case @pCurrency
         When @FuncCurrency Then PL.[FuncLYYTDAmt]--[Prior Year YTD Functional Amount]
         When @ConsCurrency Then PL.[ConsLYYTDAmt]--[Prior Year YTD Consolidated Amount]
         Else 0
         End
   Else 0
   End
Else 0
End	
as [PY_Actual_Net_Revenues], 

-1 * Case 
   When @pFiscalPeriodOptions = 'CM'  
   Then 
         Case @pCurrency
         When @FuncCurrency Then PL.[FuncLYCMAmt]--[Prior Year Current Month Functional Amount]
         When @ConsCurrency Then PL.[ConsLYCMAmt]--[Prior Year Current Month Consolidated Amount]
         Else 0
         End
   When @pFiscalPeriodOptions = 'YTD' 
   Then 
         Case @pCurrency	
         When @FuncCurrency Then PL.[FuncLYYTDAmt]--[Prior Year YTD Functional Amount]
         When @ConsCurrency Then PL.[ConsLYYTDAmt]--[Prior Year YTD Consolidated Amount]
         Else 0
         End
   Else 0
End 
as [PY_Actual_EBRE]

from FactProfitAndLossSummary AS PL 
					LEFT OUTER JOIN  MapFinancialTemplate AS FT  ON FT.AccountSkey = PL.AccountSkey 
					INNER JOIN DimCalendarPeriod AS CP ON PL.PostPeriodSkey = CP.FiscalPeriodSkey
					INNER JOIN [dbo].[DimOrganization] as DO on PL.OrgSkey = DO.OrgSkey
where (PL.PostPeriodSkey = @pFiscalPeriod) 
 AND (FT.TemplateID = @pTemplate)
 AND [TerritoryID] IN (SELECT * FROM dbo.STRING_SPLIT(@pTerritory,','))
 AND [GeographicRegionID] IN (SELECT * FROM dbo.STRING_SPLIT(@pGeoRegion,','))
 AND [CompanyID] IN (SELECT * FROM dbo.STRING_SPLIT(@pCompany,','))
 AND [RegionID] IN (SELECT * FROM dbo.STRING_SPLIT(@pRegion,','))
 AND [RemovedFlag] = 'N'
)

--//Reginal Expense for org//
SELECT 
[Sub Market Segment Code],[Sub Market Segment],[Sub Market Segment Sort Order],
[Actual Label],[Budget Label],[Budget Variance Label],[Last Year Actual Label], [YOY Variance],
SUM([Actual_Net_ Revenues]) AS [Actual_Net_ Revenues],
SUM([Actual_EBRE]) AS [Actual_EBRE],
SUM([Budget_Net_Revenues]) AS [Budget_Net_Revenues],
SUM([Budget_EBRE]) AS [Budget_EBRE],
SUM([PY_Actual_Net_Revenues]) AS [PY_Actual_Net_Revenues],
SUM([PY_Actual_EBRE]) AS [PY_Actual_EBRE],
SUM([Actual_Net_ Revenues]) - SUM([Budget_Net_Revenues]) AS [Budget_Variance_Net_Revenues],
SUM([Actual_EBRE]) - SUM([Budget_EBRE]) AS [Budget_Variance_EBRE],
SUM([Actual_Net_ Revenues]) - SUM([PY_Actual_Net_Revenues]) AS [Last_Year_Variance_Net_Revenues],
SUM([Actual_EBRE]) - SUM([PY_Actual_EBRE]) AS [Last_Year_Variance_EBRE]
FROM ProfitandLossDetail
WHERE [IsRegionalExpenses] = 'Y' 
AND [IsNetRevenues] = 'N'
AND [IsEBRE]<>'N'
AND [MarketSegmentID] NOT IN ('0','6')
AND [Sub Market Segment Code] = 'REG'
GROUP BY 
[Sub Market Segment Code],[Sub Market Segment],[Sub Market Segment Sort Order],
[Actual Label],[Budget Label],[Budget Variance Label],[Last Year Actual Label], [YOY Variance] 

UNION  
--//Reginal org//
SELECT 
[Sub Market Segment Code],[Sub Market Segment],[Sub Market Segment Sort Order],
[Actual Label],[Budget Label],[Budget Variance Label],[Last Year Actual Label], [YOY Variance],
SUM([Actual_Net_ Revenues]) AS [Actual_Net_ Revenues],
SUM([Actual_EBRE]) AS [Actual_EBRE],
SUM([Budget_Net_Revenues]) AS [Budget_Net_Revenues],
SUM([Budget_EBRE]) AS [Budget_EBRE],
SUM([PY_Actual_Net_Revenues]) AS [PY_Actual_Net_Revenues],
SUM([PY_Actual_EBRE]) AS [PY_Actual_EBRE],
SUM([Actual_Net_ Revenues]) - SUM([Budget_Net_Revenues]) AS [Budget_Variance_Net_Revenues],
SUM([Actual_EBRE]) - SUM([Budget_EBRE]) AS [Budget_Variance_EBRE],
SUM([Actual_Net_ Revenues]) - SUM([PY_Actual_Net_Revenues]) AS [Last_Year_Variance_Net_Revenues],
SUM([Actual_EBRE]) - SUM([PY_Actual_EBRE]) AS [Last_Year_Variance_EBRE]
FROM ProfitandLossDetail
WHERE [IsRegionalExpenses] = 'Y' 
AND [IsNetRevenues] ='N'
AND [IsEBRE]<>'N'
AND [MarketSegmentID] = '6'
AND [Sub Market Segment Code] = 'REG'
GROUP BY 
[Sub Market Segment Code],[Sub Market Segment],[Sub Market Segment Sort Order],
[Actual Label],[Budget Label],[Budget Variance Label],[Last Year Actual Label], [YOY Variance] 
 
UNION  
--//Sub Market//
SELECT 
[Sub Market Segment Code],[Sub Market Segment],[Sub Market Segment Sort Order],
[Actual Label],[Budget Label],[Budget Variance Label],[Last Year Actual Label], [YOY Variance],
SUM([Actual_Net_ Revenues]) AS [Actual_Net_ Revenues],
SUM([Actual_EBRE]) AS [Actual_EBRE],
SUM([Budget_Net_Revenues]) AS [Budget_Net_Revenues],
SUM([Budget_EBRE]) AS [Budget_EBRE],
SUM([PY_Actual_Net_Revenues]) AS [PY_Actual_Net_Revenues],
SUM([PY_Actual_EBRE]) AS [PY_Actual_EBRE],
SUM([Actual_Net_ Revenues]) - SUM([Budget_Net_Revenues]) AS [Budget_Variance_Net_Revenues],
SUM([Actual_EBRE]) - SUM([Budget_EBRE]) AS [Budget_Variance_EBRE],
SUM([Actual_Net_ Revenues]) - SUM([PY_Actual_Net_Revenues]) AS [Last_Year_Variance_Net_Revenues],
SUM([Actual_EBRE]) - SUM([PY_Actual_EBRE]) AS [Last_Year_Variance_EBRE]
FROM ProfitandLossDetail
WHERE
    [IsRegionalExpenses] = 'N' 
AND ([IsNetRevenues] = 'Y' OR [IsEBRE] = 'Y')
AND [MarketSegmentID]  not in ('0', '6')
GROUP BY
[Sub Market Segment Code],[Sub Market Segment],[Sub Market Segment Sort Order],
[Actual Label],[Budget Label],[Budget Variance Label],[Last Year Actual Label], [YOY Variance] 

 
GO

