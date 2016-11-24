USE [BIDataWarehouse]
GO

/****** Object:  StoredProcedure [dbo].[usp_ProfitandLossSummaryFact_12Months_CorporateExpenseActualBudget]    Script Date: 24/11/2016 11:04:34 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO









CREATE Procedure [dbo].[usp_ProfitandLossSummaryFact_12Months_CorporateExpenseActualBudget] 
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
SET @pFiscalPeriod = 201604;
Set @pTemplate = 110;
SET @pLanguage = 1;
SET @pCurrency = 'FUNC';
SET @pOrg = '452,662,453,387';
SET @pCurrency = 'CONS';
SET @pGroup1Level = 'A'
SET @pGroup2Level = 'I';
SET @pGroup3Level = 'C';
SET @pSummaryDetail = 'S'
**/

if @pSummaryDetail = 'S'
BEGIN

		WITH ProfitandLossCTE (TemplateID, Group1Level,Group2Level,Group3Level,Group1LevelID,Group2LevelID,Group3LevelID,GroupID,GroupDesc
			,[HeaderLine],[ShowDetail],[InsertSkipLineBefore],[SkipLine]
			,[IsMarkup],[IsNetRevenues],[IsDirectLabor],[IsFringeBenefitsPct],[IsFringeBenefits]
			,[IsManagementSalaries],[IsMarketingSalaries],[IsTrainingSalaries],[IsEBGEPct],[IsEBGE]
			,[IsEBREPct],[IsEBRE],[IsEBITDAPct],[IsEBITDA] ,[IsCalculatedUtilizationPct],SortOrder,FiscalPeriodNumber--, BusinessUnitID
			,[Period 1 ActualBudget Amount],[Period 2 ActualBudget Amount],[Period 3 ActualBudget Amount],[Period 4 ActualBudget Amount]
			,[Period 5 ActualBudget Amount],[Period 6 ActualBudget Amount],[Period 7 ActualBudget Amount],[Period 8 ActualBudget Amount]
			,[Period 9 ActualBudget Amount],[Period 10 ActualBudget Amount],[Period 11 ActualBudget Amount],[Period 12 ActualBudget Amount]
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
					, Case @pLanguage When @ENLanguage THEN FT.GroupDescEN 
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
					,SortOrder,FiscalPeriodNumber--, DO.BusinessUnitID										
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN 
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.ConsP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 1 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.ConsP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 1 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then ( SUM(PL.ConsP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 1 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then ( SUM(PL.ConsP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 1 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then ( SUM(PL.ConsP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 1 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then ( SUM(PL.ConsP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 1 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then ( SUM(PL.ConsP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 1 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then ( SUM(PL.ConsP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 1 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then ( SUM(PL.ConsP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 1 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then ( SUM(PL.ConsP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 1 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then ( SUM(PL.ConsP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 1 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then ( SUM(PL.ConsP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 1 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then ( SUM(PL.ConsP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 1 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End  
												When FT.GroupID = -171 Then Case When (DO.BusinessUnitID <= '601' OR DO.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  DO.BusinessUnitID >= '701') AND DO.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then ( SUM(PL.ConsP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 1 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End
												  Else ( SUM(PL.ConsP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 1 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END ))
											End		 
							WHEN @FuncCurrency THEN
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.FuncP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 1 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.FuncP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 1 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then ( SUM(PL.FuncP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 1 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then ( SUM(PL.FuncP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 1 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then ( SUM(PL.FuncP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 1 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then ( SUM(PL.FuncP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 1 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then ( SUM(PL.FuncP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 1 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then ( SUM(PL.FuncP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 1 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then ( SUM(PL.FuncP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 1 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then ( SUM(PL.FuncP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 1 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then ( SUM(PL.FuncP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 1 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then ( SUM(PL.FuncP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 1 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then ( SUM(PL.FuncP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 1 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End  
												When FT.GroupID = -171 Then Case When (DO.BusinessUnitID <= '601' OR DO.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  DO.BusinessUnitID >= '701') AND DO.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then ( SUM(PL.FuncP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 1 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End
												  Else ( SUM(PL.FuncP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 1 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END ))
											End
							END,0.000000) AS [Period 1 ActualBudget Amount]
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN 
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.ConsP2ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 2 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.ConsP2ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 2 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then ( SUM(PL.ConsP2ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 2 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then ( SUM(PL.ConsP2ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 2 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then ( SUM(PL.ConsP2ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 2 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then ( SUM(PL.ConsP2ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 2 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then ( SUM(PL.ConsP2ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 2 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then ( SUM(PL.ConsP2ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 2 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then ( SUM(PL.ConsP2ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 2 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then ( SUM(PL.ConsP2ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 2 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then ( SUM(PL.ConsP2ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 2 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then ( SUM(PL.ConsP2ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 2 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then ( SUM(PL.ConsP2ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 2 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End  
												When FT.GroupID = -171 Then Case When (DO.BusinessUnitID <= '601' OR DO.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  DO.BusinessUnitID >= '701') AND DO.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then ( SUM(PL.ConsP2ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 2 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End
												  Else ( SUM(PL.ConsP2ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 2 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END ))
											End		 
							WHEN @FuncCurrency THEN
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.FuncP2ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 2 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.FuncP2ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 2 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then ( SUM(PL.FuncP2ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 2 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then ( SUM(PL.FuncP2ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 2 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then ( SUM(PL.FuncP2ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 2 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then ( SUM(PL.FuncP2ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 2 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then ( SUM(PL.FuncP2ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 2 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then ( SUM(PL.FuncP2ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 2 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then ( SUM(PL.FuncP2ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 2 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then ( SUM(PL.FuncP2ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 2 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then ( SUM(PL.FuncP2ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 2 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then ( SUM(PL.FuncP2ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 2 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then ( SUM(PL.FuncP2ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 2 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End  
												When FT.GroupID = -171 Then Case When (DO.BusinessUnitID <= '601' OR DO.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  DO.BusinessUnitID >= '701') AND DO.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then ( SUM(PL.FuncP2ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 2 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End
												  Else ( SUM(PL.FuncP2ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 2 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END ))
											End
							END,0.000000) AS [Period 2 ActualBudget Amount]
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN 
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.ConsP3ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 3 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.ConsP3ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 3 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then ( SUM(PL.ConsP3ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 3 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then ( SUM(PL.ConsP3ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 3 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then ( SUM(PL.ConsP3ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 3 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then ( SUM(PL.ConsP3ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 3 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then ( SUM(PL.ConsP3ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 3 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then ( SUM(PL.ConsP3ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 3 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then ( SUM(PL.ConsP3ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 3 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then ( SUM(PL.ConsP3ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 3 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then ( SUM(PL.ConsP3ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 3 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then ( SUM(PL.ConsP3ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 3 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then ( SUM(PL.ConsP3ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 3 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End  
												When FT.GroupID = -171 Then Case When (DO.BusinessUnitID <= '601' OR DO.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  DO.BusinessUnitID >= '701') AND DO.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then ( SUM(PL.ConsP3ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 3 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End
												  Else ( SUM(PL.ConsP3ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 3 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END ))
											End		 
							WHEN @FuncCurrency THEN
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.FuncP3ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 3 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.FuncP3ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 3 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then ( SUM(PL.FuncP3ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 3 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then ( SUM(PL.FuncP3ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 3 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then ( SUM(PL.FuncP3ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 3 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then ( SUM(PL.FuncP3ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 3 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then ( SUM(PL.FuncP3ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 3 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then ( SUM(PL.FuncP3ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 3 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then ( SUM(PL.FuncP3ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 3 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then ( SUM(PL.FuncP3ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 3 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then ( SUM(PL.FuncP3ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 3 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then ( SUM(PL.FuncP3ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 3 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then ( SUM(PL.FuncP3ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 3 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End  
												When FT.GroupID = -171 Then Case When (DO.BusinessUnitID <= '601' OR DO.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  DO.BusinessUnitID >= '701') AND DO.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then ( SUM(PL.FuncP3ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 3 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End
												  Else ( SUM(PL.FuncP3ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 3 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END ))
											End
							END,0.000000) AS [Period 3 ActualBudget Amount]
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN 
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.ConsP4ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 4 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.ConsP4ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 4 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then ( SUM(PL.ConsP4ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 4 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then ( SUM(PL.ConsP4ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 4 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then ( SUM(PL.ConsP4ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 4 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then ( SUM(PL.ConsP4ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 4 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then ( SUM(PL.ConsP4ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 4 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then ( SUM(PL.ConsP4ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 4 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then ( SUM(PL.ConsP4ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 4 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then ( SUM(PL.ConsP4ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 4 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then ( SUM(PL.ConsP4ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 4 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then ( SUM(PL.ConsP4ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 4 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then ( SUM(PL.ConsP4ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 4 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End  
												When FT.GroupID = -171 Then Case When (DO.BusinessUnitID <= '601' OR DO.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  DO.BusinessUnitID >= '701') AND DO.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then ( SUM(PL.ConsP4ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 4 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End
												  Else ( SUM(PL.ConsP4ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 4 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END ))
											End		 
							WHEN @FuncCurrency THEN
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.FuncP4ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 4 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.FuncP4ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 4 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then ( SUM(PL.FuncP4ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 4 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then ( SUM(PL.FuncP4ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 4 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then ( SUM(PL.FuncP4ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 4 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then ( SUM(PL.FuncP4ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 4 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then ( SUM(PL.FuncP4ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 4 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then ( SUM(PL.FuncP4ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 4 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then ( SUM(PL.FuncP4ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 4 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then ( SUM(PL.FuncP4ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 4 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then ( SUM(PL.FuncP4ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 4 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then ( SUM(PL.FuncP4ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 4 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then ( SUM(PL.FuncP4ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 4 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End  
												When FT.GroupID = -171 Then Case When (DO.BusinessUnitID <= '601' OR DO.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  DO.BusinessUnitID >= '701') AND DO.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then ( SUM(PL.FuncP4ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 4 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End
												  Else ( SUM(PL.FuncP4ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 4 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END ))
											End
							END,0.000000) AS [Period 4 ActualBudget Amount]
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN 
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.ConsP5ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 5 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.ConsP5ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 5 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then ( SUM(PL.ConsP5ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 5 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then ( SUM(PL.ConsP5ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 5 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then ( SUM(PL.ConsP5ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 5 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then ( SUM(PL.ConsP5ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 5 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then ( SUM(PL.ConsP5ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 5 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then ( SUM(PL.ConsP5ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 5 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then ( SUM(PL.ConsP5ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 5 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then ( SUM(PL.ConsP5ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 5 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then ( SUM(PL.ConsP5ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 5 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then ( SUM(PL.ConsP5ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 5 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then ( SUM(PL.ConsP5ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 5 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End  
												When FT.GroupID = -171 Then Case When (DO.BusinessUnitID <= '601' OR DO.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  DO.BusinessUnitID >= '701') AND DO.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then ( SUM(PL.ConsP5ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 5 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End
												  Else ( SUM(PL.ConsP5ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 5 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END ))
											End		 
						 WHEN @FuncCurrency THEN
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.FuncP5ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 5 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.FuncP5ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 5 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then ( SUM(PL.FuncP5ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 5 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then ( SUM(PL.FuncP5ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 5 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then ( SUM(PL.FuncP5ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 5 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then ( SUM(PL.FuncP5ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 5 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then ( SUM(PL.FuncP5ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 5 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then ( SUM(PL.FuncP5ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 5 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then ( SUM(PL.FuncP5ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 5 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then ( SUM(PL.FuncP5ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 5 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then ( SUM(PL.FuncP5ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 5 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then ( SUM(PL.FuncP5ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 5 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then ( SUM(PL.FuncP5ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 5 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End  
												When FT.GroupID = -171 Then Case When (DO.BusinessUnitID <= '601' OR DO.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  DO.BusinessUnitID >= '701') AND DO.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then ( SUM(PL.FuncP5ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 5 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End
												  Else ( SUM(PL.FuncP5ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 5 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END ))
											End
							END,0.000000) AS [Period 5 ActualBudget Amount]
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN 
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.ConsP6ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 6 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.ConsP6ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 6 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then ( SUM(PL.ConsP6ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 6 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then ( SUM(PL.ConsP6ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 6 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then ( SUM(PL.ConsP6ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 6 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then ( SUM(PL.ConsP6ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 6 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then ( SUM(PL.ConsP6ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 6 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then ( SUM(PL.ConsP6ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 6 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then ( SUM(PL.ConsP6ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 6 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then ( SUM(PL.ConsP6ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 6 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then ( SUM(PL.ConsP6ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 6 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then ( SUM(PL.ConsP6ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 6 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then ( SUM(PL.ConsP6ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 6 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End  
												When FT.GroupID = -171 Then Case When (DO.BusinessUnitID <= '601' OR DO.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  DO.BusinessUnitID >= '701') AND DO.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then ( SUM(PL.ConsP6ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 6 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End
												  Else ( SUM(PL.ConsP6ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 6 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END ))
											End		 
						 WHEN @FuncCurrency THEN
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.FuncP6ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 6 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.FuncP6ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 6 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then ( SUM(PL.FuncP6ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 6 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then ( SUM(PL.FuncP6ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 6 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then ( SUM(PL.FuncP6ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 6 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then ( SUM(PL.FuncP6ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 6 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then ( SUM(PL.FuncP6ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 6 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then ( SUM(PL.FuncP6ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 6 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then ( SUM(PL.FuncP6ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 6 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then ( SUM(PL.FuncP6ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 6 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then ( SUM(PL.FuncP6ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 6 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then ( SUM(PL.FuncP6ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 6 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then ( SUM(PL.FuncP6ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 6 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End  
												When FT.GroupID = -171 Then Case When (DO.BusinessUnitID <= '601' OR DO.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  DO.BusinessUnitID >= '701') AND DO.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then ( SUM(PL.FuncP6ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 6 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End
												  Else ( SUM(PL.FuncP6ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 6 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END ))
											End
							END,0.000000) AS [Period 6 ActualBudget Amount]
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN 
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.ConsP7ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 7 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.ConsP7ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 7 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then ( SUM(PL.ConsP7ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 7 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then ( SUM(PL.ConsP7ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 7 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then ( SUM(PL.ConsP7ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 7 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then ( SUM(PL.ConsP7ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 7 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then ( SUM(PL.ConsP7ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 7 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then ( SUM(PL.ConsP7ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 7 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then ( SUM(PL.ConsP7ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 7 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then ( SUM(PL.ConsP7ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 7 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then ( SUM(PL.ConsP7ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 7 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then ( SUM(PL.ConsP7ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 7 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then ( SUM(PL.ConsP7ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 7 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End  
												When FT.GroupID = -171 Then Case When (DO.BusinessUnitID <= '601' OR DO.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  DO.BusinessUnitID >= '701') AND DO.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then ( SUM(PL.ConsP7ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 7 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End
												  Else ( SUM(PL.ConsP7ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 7 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END ))
											End		 
						WHEN @FuncCurrency THEN
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.FuncP7ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 7 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.FuncP7ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 7 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then ( SUM(PL.FuncP7ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 7 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then ( SUM(PL.FuncP7ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 7 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then ( SUM(PL.FuncP7ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 7 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then ( SUM(PL.FuncP7ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 7 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then ( SUM(PL.FuncP7ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 7 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then ( SUM(PL.FuncP7ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 7 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then ( SUM(PL.FuncP7ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 7 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then ( SUM(PL.FuncP7ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 7 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then ( SUM(PL.FuncP7ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 7 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then ( SUM(PL.FuncP7ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 7 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then ( SUM(PL.FuncP7ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 7 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End  
												When FT.GroupID = -171 Then Case When (DO.BusinessUnitID <= '601' OR DO.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  DO.BusinessUnitID >= '701') AND DO.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then ( SUM(PL.FuncP7ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 7 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End
												  Else ( SUM(PL.FuncP7ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 7 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END ))
											End
							END,0.000000) AS [Period 7 ActualBudget Amount]
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN 
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.ConsP8ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 8 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.ConsP8ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 8 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then ( SUM(PL.ConsP8ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 8 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then ( SUM(PL.ConsP8ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 8 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then ( SUM(PL.ConsP8ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 8 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then ( SUM(PL.ConsP8ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 8 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then ( SUM(PL.ConsP8ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 8 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then ( SUM(PL.ConsP8ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 8 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then ( SUM(PL.ConsP8ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 8 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then ( SUM(PL.ConsP8ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 8 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then ( SUM(PL.ConsP8ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 8 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then ( SUM(PL.ConsP8ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 8 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then ( SUM(PL.ConsP8ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 8 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End  
												When FT.GroupID = -171 Then Case When (DO.BusinessUnitID <= '601' OR DO.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  DO.BusinessUnitID >= '701') AND DO.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then ( SUM(PL.ConsP8ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 8 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End
												  Else ( SUM(PL.ConsP8ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 8 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END ))
											End		 
					  WHEN @FuncCurrency THEN
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.FuncP8ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 8 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.FuncP8ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 8 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then ( SUM(PL.FuncP8ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 8 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then ( SUM(PL.FuncP8ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 8 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then ( SUM(PL.FuncP8ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 8 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then ( SUM(PL.FuncP8ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 8 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then ( SUM(PL.FuncP8ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 8 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then ( SUM(PL.FuncP8ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 8 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then ( SUM(PL.FuncP8ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 8 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then ( SUM(PL.FuncP8ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 8 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then ( SUM(PL.FuncP8ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 8 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then ( SUM(PL.FuncP8ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 8 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then ( SUM(PL.FuncP8ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 8 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End  
												When FT.GroupID = -171 Then Case When (DO.BusinessUnitID <= '601' OR DO.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  DO.BusinessUnitID >= '701') AND DO.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then ( SUM(PL.FuncP8ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 8 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End
												  Else ( SUM(PL.FuncP8ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 8 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END ))
											End
							END,0.000000) AS [Period 8 ActualBudget Amount]
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN 
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.ConsP9ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.ConsP9ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then ( SUM(PL.ConsP9ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then ( SUM(PL.ConsP9ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then ( SUM(PL.ConsP9ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then ( SUM(PL.ConsP9ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then ( SUM(PL.ConsP9ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then ( SUM(PL.ConsP9ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then ( SUM(PL.ConsP9ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then ( SUM(PL.ConsP9ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then ( SUM(PL.ConsP9ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then ( SUM(PL.ConsP9ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then ( SUM(PL.ConsP9ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End  
												When FT.GroupID = -171 Then Case When (DO.BusinessUnitID <= '601' OR DO.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  DO.BusinessUnitID >= '701') AND DO.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then ( SUM(PL.ConsP9ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End
												  Else ( SUM(PL.ConsP9ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END ))
											End		 
					  WHEN @FuncCurrency THEN
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.FuncP9ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.FuncP9ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then ( SUM(PL.FuncP9ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then ( SUM(PL.FuncP9ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then ( SUM(PL.FuncP9ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then ( SUM(PL.FuncP9ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then ( SUM(PL.FuncP9ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then ( SUM(PL.FuncP9ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then ( SUM(PL.FuncP9ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then ( SUM(PL.FuncP9ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then ( SUM(PL.FuncP9ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then ( SUM(PL.FuncP9ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then ( SUM(PL.FuncP9ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End  
												When FT.GroupID = -171 Then Case When (DO.BusinessUnitID <= '601' OR DO.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  DO.BusinessUnitID >= '701') AND DO.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then ( SUM(PL.FuncP9ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End
												  Else ( SUM(PL.FuncP9ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END ))
											End
							END,0.000000) AS [Period 9 ActualBudget Amount]	
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN 
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.ConsP10ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 10 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.ConsP10ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 10 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then ( SUM(PL.ConsP10ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 10 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then ( SUM(PL.ConsP10ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 10 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then ( SUM(PL.ConsP10ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 10 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then ( SUM(PL.ConsP10ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 10 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then ( SUM(PL.ConsP10ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 10 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then ( SUM(PL.ConsP10ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 10 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then ( SUM(PL.ConsP10ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 10 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then ( SUM(PL.ConsP10ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 10 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then ( SUM(PL.ConsP10ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 10 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then ( SUM(PL.ConsP10ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 10 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then ( SUM(PL.ConsP10ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 10 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End  
												When FT.GroupID = -171 Then Case When (DO.BusinessUnitID <= '601' OR DO.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  DO.BusinessUnitID >= '701') AND DO.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then ( SUM(PL.ConsP10ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 10 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End
												  Else ( SUM(PL.ConsP10ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 10 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END ))
											End		 
					  WHEN @FuncCurrency THEN
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.FuncP10ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 10 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.FuncP10ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 10 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then ( SUM(PL.FuncP10ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 10 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then ( SUM(PL.FuncP10ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 10 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then ( SUM(PL.FuncP10ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 10 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then ( SUM(PL.FuncP10ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 10 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then ( SUM(PL.FuncP10ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 10 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then ( SUM(PL.FuncP10ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 10 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then ( SUM(PL.FuncP10ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 10 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then ( SUM(PL.FuncP10ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 10 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then ( SUM(PL.FuncP10ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 10 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then ( SUM(PL.FuncP10ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 10 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then ( SUM(PL.FuncP10ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 10 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End  
												When FT.GroupID = -171 Then Case When (DO.BusinessUnitID <= '601' OR DO.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  DO.BusinessUnitID >= '701') AND DO.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then ( SUM(PL.FuncP10ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 10 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End
												  Else ( SUM(PL.FuncP10ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 10 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END ))
											End
							END,0.000000) AS [Period 10 ActualBudget Amount]
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN 
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.ConsP11ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 11 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.ConsP11ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 11 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then ( SUM(PL.ConsP11ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 11 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then ( SUM(PL.ConsP11ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 11 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then ( SUM(PL.ConsP11ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 11 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then ( SUM(PL.ConsP11ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 11 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then ( SUM(PL.ConsP11ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 11 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then ( SUM(PL.ConsP11ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 11 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then ( SUM(PL.ConsP11ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 11 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then ( SUM(PL.ConsP11ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 11 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then ( SUM(PL.ConsP11ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 11 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then ( SUM(PL.ConsP11ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 11 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then ( SUM(PL.ConsP11ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 11 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End  
												When FT.GroupID = -171 Then Case When (DO.BusinessUnitID <= '601' OR DO.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  DO.BusinessUnitID >= '701') AND DO.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then ( SUM(PL.ConsP11ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 11 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End
												  Else ( SUM(PL.ConsP11ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 11 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END ))
											End		 
					  WHEN @FuncCurrency THEN
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.FuncP11ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 11 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.FuncP11ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 11 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then ( SUM(PL.FuncP11ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 11 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then ( SUM(PL.FuncP11ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 11 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then ( SUM(PL.FuncP11ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 11 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then ( SUM(PL.FuncP11ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 11 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then ( SUM(PL.FuncP11ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 11 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then ( SUM(PL.FuncP11ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 11 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then ( SUM(PL.FuncP11ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 11 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then ( SUM(PL.FuncP11ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 11 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then ( SUM(PL.FuncP11ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 11 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then ( SUM(PL.FuncP11ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 11 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then ( SUM(PL.FuncP11ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 11 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End  
												When FT.GroupID = -171 Then Case When (DO.BusinessUnitID <= '601' OR DO.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  DO.BusinessUnitID >= '701') AND DO.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then ( SUM(PL.FuncP11ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 11 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End
												  Else ( SUM(PL.FuncP11ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 11 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END ))
											End
							END,0.000000) AS [Period 11 ActualBudget Amount]
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN 
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.ConsP12ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 12 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.ConsP12ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 12 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then ( SUM(PL.ConsP12ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 12 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then ( SUM(PL.ConsP12ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 12 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then ( SUM(PL.ConsP12ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 12 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then ( SUM(PL.ConsP12ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 12 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then ( SUM(PL.ConsP12ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 12 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then ( SUM(PL.ConsP12ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 12 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then ( SUM(PL.ConsP12ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 12 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then ( SUM(PL.ConsP12ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 12 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then ( SUM(PL.ConsP12ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 12 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then ( SUM(PL.ConsP12ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 12 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then ( SUM(PL.ConsP12ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 12 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End  
												When FT.GroupID = -171 Then Case When (DO.BusinessUnitID <= '601' OR DO.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  DO.BusinessUnitID >= '701') AND DO.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then ( SUM(PL.ConsP12ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 12 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End
												  Else ( SUM(PL.ConsP12ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 12 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END ))
											End		 
					  WHEN @FuncCurrency THEN
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.FuncP12ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 12 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then ( SUM(PL.FuncP12ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 12 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then ( SUM(PL.FuncP12ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 12 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then ( SUM(PL.FuncP12ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 12 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then ( SUM(PL.FuncP12ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 12 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then ( SUM(PL.FuncP12ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 12 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then ( SUM(PL.FuncP12ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 12 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then ( SUM(PL.FuncP12ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 12 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then ( SUM(PL.FuncP12ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 12 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then ( SUM(PL.FuncP12ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 12 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then ( SUM(PL.FuncP12ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 12 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then ( SUM(PL.FuncP12ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 12 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End 
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then ( SUM(PL.FuncP12ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 12 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End  
												When FT.GroupID = -171 Then Case When (DO.BusinessUnitID <= '601' OR DO.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  DO.BusinessUnitID >= '701') AND DO.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then ( SUM(PL.FuncP12ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 12 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END )) Else 0.000000 End
												  Else ( SUM(PL.FuncP12ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 12 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END ))
											End
							END,0.000000) AS [Period 12 ActualBudget Amount]			 
		FROM        FactProfitAndLossSummary   AS PL 
				LEFT OUTER JOIN MapFinancialTemplate as FT   ON FT.AccountSkey = PL.AccountSkey 
				INNER JOIN ( SELECT OrgSkey,BusinessUnitID
				
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
						FROM [dbo].[DimOrganization] as DO
					
					)DO ON PL.OrgSkey = DO.OrgSkey
				INNER JOIN DimCalendarPeriod AS CP ON PL.PostPeriodSkey = CP.FiscalPeriodSkey
		WHERE        (PL.PostPeriodSkey = @pFiscalPeriod) 
					AND (FT.TemplateID = @pTemplate)
					AND PL.OrgSkey IN	( Select * from dbo.STRING_SPLIT(@pOrg, ','))
					--)
					--AND HeaderLine = 'Y'
	
		GROUP BY	 FT.TemplateID
					 ,Group1Level
					,Group2Level
					,Group3Level	
					,Group1LevelID
					,Group2LevelID
					,Group3LevelID
					,FT.GroupID
					,FT.SortOrder, 
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
					,CP.FiscalPeriodNumber
					,SortOrder
					,DO.BusinessUnitID
			
		)



		
				SELECT Template.Group1Level,Template.Group2Level,Template.Group3Level,Template.Group1LevelID,Template.Group2LevelID,Template.Group3LevelID
						,Template.TemplateID,Template.GroupID, Template.GroupDesc, Template.GroupType, Template.SortOrder
						,Template.[HeaderLine], Template.[ShowDetail], Template.[InsertSkipLineBefore], Template.[SkipLine]
						,Template.[IsMarkup],Template.[IsFringeBenefitsPct],Template.[IsEBGEPct],Template.[IsEBREPct]						
						,Template.[IsEBITDAPct],Template.[IsCalculatedUtilizationPct]
				-- Template.*
				-- ,PCTE.*
				--, Group1Level,Group2Level,Group3Level,
					,PCTE.FiscalPeriodNumber
					,ISNULL(Sum([Period 1 ActualBudget Amount]),0.000000) AS [Period 1 ActualBudget Amount]
					,ISNULL(Sum([Period 2 ActualBudget Amount]),0.000000) AS [Period 2 ActualBudget Amount]
					,ISNULL(Sum([Period 3 ActualBudget Amount]),0.000000) AS [Period 3 ActualBudget Amount]
					,ISNULL(Sum([Period 4 ActualBudget Amount]),0.000000) AS [Period 4 ActualBudget Amount]
					,ISNULL(Sum([Period 5 ActualBudget Amount]),0.000000) AS [Period 5 ActualBudget Amount]
					,ISNULL(Sum([Period 6 ActualBudget Amount]),0.000000) AS [Period 6 ActualBudget Amount]
					,ISNULL(Sum([Period 7 ActualBudget Amount]),0.000000) AS [Period 7 ActualBudget Amount]
					,ISNULL(Sum([Period 8 ActualBudget Amount]),0.000000) AS [Period 8 ActualBudget Amount]
					,ISNULL(Sum([Period 9 ActualBudget Amount]),0.000000) AS [Period 9 ActualBudget Amount]
					,ISNULL(Sum([Period 10 ActualBudget Amount]),0.000000) AS [Period 10 ActualBudget Amount]
					,ISNULL(Sum([Period 11 ActualBudget Amount]),0.000000) AS [Period 11 ActualBudget Amount]
					,ISNULL(Sum([Period 12 ActualBudget Amount]),0.000000) AS [Period 12 ActualBudget Amount]
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
										FROM ProfitandLossCTE
										)DistGroup
						)Template	

				LEFT OUTER JOIN ProfitandLossCTE as PCTE ON Template.TemplateID = PCTE.TemplateID
													AND Template.GroupID = PCTE.GroupId
													AND Template.Group1level = PCTE.Group1level
													AND Template.Group2level = PCTE.Group2level
													AND Template.Group3level = PCTE.Group3level
				
				GROUP BY Template.Group1Level,Template.Group2Level,Template.Group3Level,Template.Group1LevelID,Template.Group2LevelID,Template.Group3LevelID
						,Template.TemplateID, Template.GroupID, Template.GroupDesc,Template.GroupDesc, Template.GroupType, Template.SortOrder
						,Template.[HeaderLine], Template.[ShowDetail], Template.[InsertSkipLineBefore], Template.[SkipLine]
						,Template.[IsMarkup],Template.[IsFringeBenefitsPct],Template.[IsEBGEPct],Template.[IsEBREPct]						
						,Template.[IsEBITDAPct],Template.[IsCalculatedUtilizationPct],PCTE.FiscalPeriodNumber	              
				ORDER BY  Template.Group1Level,Template.Group2Level,Template.Group3Level,Template.SortOrder,Template.GroupID,Template.GroupDesc
			
	

END	


GO

