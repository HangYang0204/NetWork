USE [BIDataWarehouse]
GO

/****** Object:  StoredProcedure [dbo].[usp_ProfitandLossSummaryFact_12Months_CorporateExpenseActualBudget_Detail]    Script Date: 24/11/2016 11:04:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








CREATE Procedure [dbo].[usp_ProfitandLossSummaryFact_12Months_CorporateExpenseActualBudget_Detail] 
	@pCurrency varchar(5),
	@pFiscalPeriod int,
	@pTemplate int,
	@pLanguage int,
	@pOrg varchar(max),
	@pSummaryDetail varchar(1)
	AS 


Declare @FuncCurrency as Varchar(5);
Declare @ConsCurrency as Varchar(5);
Declare @ENLanguage as int;
Declare @FRLanguage as int;

/**
Declare @pCurrency as varchar (5);
declare	@pFiscalPeriod as int;
declare	@pTemplate as int;
declare	@pLanguage as int;
Declare @pOrg varchar(max)
**/
SET @pCurrency = 'CONS';
SET @FuncCurrency = 'FUNC';
SET @ConsCurrency = 'CONS';
SET @ENLanguage = 1;
SET @FRLanguage = 2;

/**
SET @pFiscalPeriod = 201605;
Set @pTemplate = 105;
SET @pLanguage = 1;
SET @pCurrency = 'FUNC';
SET @pOrg = '452,662,453,387';
**/

If @pSummaryDetail = 'D' 
	BEGIN
			WITH ProfitandLossCTE (OrgSkey,OrganizationID,[Organization Name],TemplateID,GroupID ,GroupDesc,[HeaderLine],[ShowDetail],[InsertSkipLineBefore],[SkipLine]
						,[IsMarkup] ,[IsNetRevenues],[IsDirectLabor],[IsFringeBenefitsPct],[IsFringeBenefits]
						,[IsManagementSalaries],[IsMarketingSalaries],[IsTrainingSalaries],[IsEBGEPct],[IsEBGE]
						,[IsEBREPct],[IsEBRE],[IsEBITDAPct],[IsEBITDA] ,[IsCalculatedUtilizationPct],SortOrder,FiscalPeriodNumber
						,[Period 1 ActualBudget Amount],[Period 2 ActualBudget Amount],[Period 3 ActualBudget Amount],[Period 4 ActualBudget Amount]
						,[Period 5 ActualBudget Amount],[Period 6 ActualBudget Amount],[Period 7 ActualBudget Amount],[Period 8 ActualBudget Amount]
						,[Period 9 ActualBudget Amount],[Period 10 ActualBudget Amount],[Period 11 ActualBudget Amount],[Period 12 ActualBudget Amount] )
			AS
			(
				SELECT  
						DO.OrgSkey --added
						,DO.OrganizationID  
						,DO.OrganizationID + ' - ' + DO.[OrganizationDesc] as [Organization Name]  
						,TemplateID   
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
						,SortOrder,FiscalPeriodNumber																	
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
			FROM           
					FactProfitAndLossSummary AS PL 
					LEFT OUTER JOIN  MapFinancialTemplate AS FT  ON FT.AccountSkey = PL.AccountSkey 
					INNER JOIN DimCalendarPeriod AS CP ON PL.PostPeriodSkey = CP.FiscalPeriodSkey
					INNER JOIN [dbo].[DimOrganization] as DO on PL.OrgSkey = DO.OrgSkey
			WHERE        (PL.PostPeriodSkey = @pFiscalPeriod) 
						AND (FT.TemplateID = @pTemplate)
						AND PL.OrgSkey IN	( Select * from dbo.STRING_SPLIT(@pOrg, ','))
						and RemovedFlag = 'N'
	
			GROUP BY  DO.OrgSkey --added
					  ,DO.OrganizationID
					  ,DO.OrganizationID + ' - ' + DO.[OrganizationDesc]
					  ,TemplateID
						,FT.GroupID, FT.SortOrder, 
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
		
					SELECT Template.*
					--PCTE.*
						--,PCTE.OrganizationID
						,PCTE.FiscalPeriodNumber
						,ISNULL(([Period 1 ActualBudget Amount]),0.000000) AS [Period 1 ActualBudget Amount]
						,ISNULL(([Period 2 ActualBudget Amount]),0.000000) AS [Period 2 ActualBudget Amount]
						,ISNULL(([Period 3 ActualBudget Amount]),0.000000) AS [Period 3 ActualBudget Amount]
						,ISNULL(([Period 4 ActualBudget Amount]),0.000000) AS [Period 4 ActualBudget Amount]
						,ISNULL(([Period 5 ActualBudget Amount]),0.000000) AS [Period 5 ActualBudget Amount]
						,ISNULL(([Period 6 ActualBudget Amount]),0.000000) AS [Period 6 ActualBudget Amount]
						,ISNULL(([Period 7 ActualBudget Amount]),0.000000) AS [Period 7 ActualBudget Amount]
						,ISNULL(([Period 8 ActualBudget Amount]),0.000000) AS [Period 8 ActualBudget Amount]
						,ISNULL(([Period 9 ActualBudget Amount]),0.000000) AS [Period 9 ActualBudget Amount]
						,ISNULL(([Period 10 ActualBudget Amount]),0.000000) AS [Period 10 ActualBudget Amount]
						,ISNULL(([Period 11 ActualBudget Amount]),0.000000) AS [Period 11 ActualBudget Amount]
						,ISNULL(([Period 12 ActualBudget Amount]),0.000000) AS [Period 12 ActualBudget Amount]
					FROM (Select OrgSkey --added
								 ,OrganizationID
								 ,OrganizationID + ' - ' + [OrganizationDesc] as [Organization Name]
								 ,Templ.*
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
							from [dbo].[MapFinancialTemplate]
							WHERE TemplateID = @pTemplate 
							)Templ
							Cross JOIN [dbo].[DimOrganization]	
							WHERE OrgSkey IN	( Select * from dbo.STRING_SPLIT(@pOrg, ','))	
							)Template
					LEFT OUTER JOIN ProfitandLossCTE as PCTE ON Template.TemplateID = PCTE.TemplateID
														AND Template.GroupID = PCTE.GroupId
														AND Template.OrganizationID = PCTE.OrganizationID
					 Order by Template.OrganizationID,Template.SortOrder,  Template.GroupID,  Template.GroupDesc
	
END

GO

