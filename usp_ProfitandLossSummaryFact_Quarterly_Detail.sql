USE [BIDataWarehouse]
GO

/****** Object:  StoredProcedure [dbo].[usp_ProfitandLossSummaryFact_Quarterly_Detail]    Script Date: 24/11/2016 11:10:29 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE Procedure [dbo].[usp_ProfitandLossSummaryFact_Quarterly_Detail] 
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
Declare @pCurrency as Varchar (5);
declare	@pFiscalPeriod as int;
declare	@pTemplate as int;
declare	@pLanguage as int;
Declare @pOrg varchar(max)
DECLARE @pSummaryDetail varchar(1);
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
SET @pSummaryDetail = 'D';
**/

If @pSummaryDetail = 'D' 
	BEGIN
			WITH ProfitandLossCTE (OrgSkey,OrganizationID,[Organization Name],TemplateID,GroupID ,GroupDesc,[HeaderLine],[ShowDetail],[InsertSkipLineBefore],[SkipLine]
						,[IsMarkup] ,[IsNetRevenues],[IsDirectLabor],[IsFringeBenefitsPct],[IsFringeBenefits]
						,[IsManagementSalaries],[IsMarketingSalaries],[IsTrainingSalaries],[IsEBGEPct],[IsEBGE]
						,[IsEBREPct],[IsEBRE],[IsEBITDAPct],[IsEBITDA] ,[IsCalculatedUtilizationPct],SortOrder,FiscalPeriodNumber
						,[Period 1 ActualBudget Amount],[Period 2 ActualBudget Amount],[Period 3 ActualBudget Amount],[Period 4 ActualBudget Amount]
						,[Period 5 ActualBudget Amount],[Period 6 ActualBudget Amount],[Period 7 ActualBudget Amount],[Period 8 ActualBudget Amount]
						,[Period 9 ActualBudget Amount],[Period 10 ActualBudget Amount],[Period 11 ActualBudget Amount],[Period 12 ActualBudget Amount]	 
						,[Q1 ActualBudget Amount],[Q2 ActualBudget Amount],[Q3 ActualBudget Amount],[Q4 ActualBudget Amount]
						,[LY Period 1 Actual Amount],[LY Period 2 Actual Amount],[LY Period 3 Actual Amount],[LY Period 4 Actual Amount]
						,[LY Period 5 Actual Amount],[LY Period 6 Actual Amount],[LY Period 7 Actual Amount],[LY Period 8 Actual Amount]
						,[LY Period 9 Actual Amount],[LY Period 10 Actual Amount],[LY Period 11 Actual Amount],[LY Period 12 Actual Amount]	
						)
			AS
			( 
				SELECT  
						CYPL.OrgSkey
						,CYPL.OrganizationID  
						,CYPL.OrganizationID + ' - ' + CYPL.[OrganizationDesc] as [Organization Name]
						,CYPL.TemplateID
						,CYPL.GroupID 
						, GroupDesc
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
						,SUM([Period 1 ActualBudget Amount]) AS [Period 1 ActualBudget Amount]
						,SUM([Period 2 ActualBudget Amount]) AS [Period 2 ActualBudget Amount]
						,SUM([Period 3 ActualBudget Amount]) AS [Period 3 ActualBudget Amount]
						,SUM([Period 4 ActualBudget Amount]) AS [Period 4 ActualBudget Amount]
						,SUM([Period 5 ActualBudget Amount]) AS [Period 5 ActualBudget Amount]
						,SUM([Period 6 ActualBudget Amount]) AS [Period 6 ActualBudget Amount]
						,SUM([Period 7 ActualBudget Amount]) AS [Period 7 ActualBudget Amount]
						,SUM([Period 8 ActualBudget Amount]) AS [Period 8 ActualBudget Amount]
						,SUM([Period 9 ActualBudget Amount]) AS [Period 9 ActualBudget Amount]
						,SUM([Period 10 ActualBudget Amount]) AS [Period 10 ActualBudget Amount]
						,SUM([Period 11 ActualBudget Amount]) AS [Period 11 ActualBudget Amount]
						,SUM([Period 12 ActualBudget Amount]) AS [Period 12 ActualBudget Amount]
						,SUM([Q1 ActualBudget Amount]) AS [Q1 ActualBudget Amount]
						,SUM([Q2 ActualBudget Amount]) AS [Q2 ActualBudget Amount]
						,SUM([Q3 ActualBudget Amount]) AS [Q3 ActualBudget Amount]
						,SUM([Q4 ActualBudget Amount]) AS [Q4 ActualBudget Amount]
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
					SELECT			 
					  FT.GroupID 
					 ,FT.TemplateID
					 ,DO.[OrgSkey]
					 ,DO.OrganizationID 
					 ,DO.[OrganizationDesc] 
					 ,CP.FiscalPeriodNumber
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
					,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 1 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END) )
					WHEN @FuncCurrency THEN ( SUM(PL.FuncP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 1 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END))
						END,0.000000) AS [Period 1 ActualBudget Amount]
					,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP2ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 2 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END) )
					WHEN @FuncCurrency THEN ( SUM(PL.FuncP2ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 2 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END))
						END,0.000000) AS [Period 2 ActualBudget Amount]
					,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP3ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 3 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END) )
					WHEN @FuncCurrency THEN ( SUM(PL.FuncP3ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 3 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END))
						END,0.000000) AS [Period 3 ActualBudget Amount]
					,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP4ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 4 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END) )
					WHEN @FuncCurrency THEN ( SUM(PL.FuncP4ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 4 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END))
						END,0.000000) AS [Period 4 ActualBudget Amount]
					,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP5ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 5 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END) )
					WHEN @FuncCurrency THEN ( SUM(PL.FuncP5ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 5 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END))
						END,0.000000) AS [Period 5 ActualBudget Amount]
					,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP6ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 6 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END) )
					WHEN @FuncCurrency THEN ( SUM(PL.FuncP6ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 6 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END))
						END,0.000000) AS [Period 6 ActualBudget Amount]
					,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP7ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 7 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END) )
					WHEN @FuncCurrency THEN ( SUM(PL.FuncP7ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 7 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END))
						END,0.000000) AS [Period 7 ActualBudget Amount]
					,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP8ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 8 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END) )
					WHEN @FuncCurrency THEN ( SUM(PL.FuncP8ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 8 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END))
						END,0.000000) AS [Period 8 ActualBudget Amount]
					,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP9ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END) )
					WHEN @FuncCurrency THEN ( SUM(PL.FuncP9ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END))
						END,0.000000) AS [Period 9 ActualBudget Amount]
					,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP10ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 10 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END) )
					WHEN @FuncCurrency THEN ( SUM(PL.FuncP10ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 10 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END))
						END,0.000000) AS [Period 10 ActualBudget Amount]
					,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP11ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 11 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END) )
					WHEN @FuncCurrency THEN ( SUM(PL.FuncP11ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 11 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END))
						END,0.000000) AS [Period 11 ActualBudget Amount]
					,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP12ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 12 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END) )
					WHEN @FuncCurrency THEN ( SUM(PL.FuncP12ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 12 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END))
						END,0.000000) AS [Period 12 ActualBudget Amount] 
					,ISNULL((Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 1 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END) )
					WHEN @FuncCurrency THEN ( SUM(PL.FuncP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 1 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END))
						END + 
					Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP2ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 2 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END) )
					WHEN @FuncCurrency THEN ( SUM(PL.FuncP2ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 2 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END))
						END + 
					Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP3ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 3 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END) )
					WHEN @FuncCurrency THEN ( SUM(PL.FuncP3ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 3 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END))
						END),0.000000) AS [Q1 ActualBudget Amount]
					,ISNULL((Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP4ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 4 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END) )
					WHEN @FuncCurrency THEN ( SUM(PL.FuncP4ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 4 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END))
						END + 
					Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP5ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 5 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END) )
					WHEN @FuncCurrency THEN ( SUM(PL.FuncP5ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 5 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END))
						END + 
					Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP6ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 6 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END) )
					WHEN @FuncCurrency THEN ( SUM(PL.FuncP6ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 6 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END))
						END),0.000000) AS [Q2 ActualBudget Amount]
					,ISNULL((Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP7ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 7 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END) )
					WHEN @FuncCurrency THEN ( SUM(PL.FuncP7ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 7 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END))
						END +
					Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP8ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 8 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END) )
					WHEN @FuncCurrency THEN ( SUM(PL.FuncP8ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 8 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END))
						END +
					Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP9ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END) )
					WHEN @FuncCurrency THEN ( SUM(PL.FuncP9ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END))
						END),0.000000) AS [Q3 ActualBudget Amount]
					,ISNULL((Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP10ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 10 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END) )
					WHEN @FuncCurrency THEN ( SUM(PL.FuncP10ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 10 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END))
						END + 
					Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP11ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 11 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END) )
					WHEN @FuncCurrency THEN ( SUM(PL.FuncP11ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 11 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END))
						END + 
					Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP12ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 12 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END) )
					WHEN @FuncCurrency THEN ( SUM(PL.FuncP12ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 12 THEN FT.IncomeStatementActualSign ELSE FT.IncomeStatementBudgetSign END))
						END),0.000000) AS [Q4 ActualBudget Amount]
-----
			FROM           
					FactProfitAndLossSummary AS PL 
					LEFT OUTER JOIN  MapFinancialTemplate AS FT  ON FT.AccountSkey = PL.AccountSkey 
					INNER JOIN DimCalendarPeriod AS CP ON PL.PostPeriodSkey = CP.FiscalPeriodSkey
					INNER JOIN [dbo].[DimOrganization] as DO on PL.OrgSkey = DO.OrgSkey
			WHERE        (PL.PostPeriodSkey = @pFiscalPeriod) 
						AND (FT.TemplateID = @pTemplate)
						AND PL.OrgSkey IN	( Select * from dbo.STRING_SPLIT(@pOrg, ','))
						and RemovedFlag = 'N'
	
			GROUP BY   DO.OrgSkey --added
					  ,DO.OrganizationID
					  ,DO.[OrganizationDesc] 
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
						)CYPL
			LEFT OUTER JOIN (
					Select FT.GroupID 
					  ,FT.TemplateID
					 ,LYPL.[OrgSkey]
					 ,CP.FiscalPeriodNumber
				,1 AS [PY Actual]
				,Case @pCurrency WHEN @ConsCurrency THEN 
				 	 SUM([ConsP1ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=1  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))
					WHEN @FuncCurrency THEN
					SUM([FuncP1ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=1  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))		    
				END AS [LY Period 1 Actual Amount]
				,Case @pCurrency WHEN @ConsCurrency THEN 
				 	 SUM([ConsP2ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=2  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))
					WHEN @FuncCurrency THEN
					SUM([FuncP2ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=2  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))		    
				END AS [LY Period 2 Actual Amount]
				,Case @pCurrency WHEN @ConsCurrency THEN 
				 	 SUM([ConsP3ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=3  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))
					WHEN @FuncCurrency THEN
					SUM([FuncP3ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=3  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))		    
				END AS [LY Period 3 Actual Amount]
				,Case @pCurrency WHEN @ConsCurrency THEN 
				 	 SUM([ConsP4ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=4  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))
					WHEN @FuncCurrency THEN
					SUM([FuncP4ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=4  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))		    
				END AS [LY Period 4 Actual Amount]
				,Case @pCurrency WHEN @ConsCurrency THEN 
				 	 SUM([ConsP5ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=5  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))
					WHEN @FuncCurrency THEN
					SUM([FuncP5ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=5  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))		    
				END AS [LY Period 5 Actual Amount]
				,Case @pCurrency WHEN @ConsCurrency THEN 
				 	 SUM([ConsP6ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=6  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))
					WHEN @FuncCurrency THEN
					SUM([FuncP6ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=6  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))		    
				END AS [LY Period 6 Actual Amount]
				,Case @pCurrency WHEN @ConsCurrency THEN 
				 	 SUM([ConsP7ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=7  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))
					WHEN @FuncCurrency THEN
					SUM([FuncP7ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=7  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))		    
				END AS [LY Period 7 Actual Amount]
				,Case @pCurrency WHEN @ConsCurrency THEN 
				 	 SUM([ConsP8ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=8  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))
					WHEN @FuncCurrency THEN
					SUM([FuncP8ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=8  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))		    
				END AS [LY Period 8 Actual Amount]
				,Case @pCurrency WHEN @ConsCurrency THEN 
				 	 SUM([ConsP9ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=9  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))
					WHEN @FuncCurrency THEN
					SUM([FuncP9ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=9  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))		    
				END AS [LY Period 9 Actual Amount]
				,Case @pCurrency WHEN @ConsCurrency THEN 
				 	 SUM([ConsP10ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=10  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))
					WHEN @FuncCurrency THEN
					SUM([FuncP10ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=10  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))		    
				END AS [LY Period 10 Actual Amount]
				,Case @pCurrency WHEN @ConsCurrency THEN 
				 	 SUM([ConsP11ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=11  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))
					WHEN @FuncCurrency THEN
					SUM([FuncP11ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=11  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))		    
				END AS [LY Period 11 Actual Amount]
				,Case @pCurrency WHEN @ConsCurrency THEN 
				 	 SUM([ConsP12ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=12  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))
					WHEN @FuncCurrency THEN
					SUM([FuncP12ActualBudgetAmt]* 
						 (CASE WHEN CP.FiscalPeriodNumber >=12  THEN FT.IncomeStatementActualSign 
														  ELSE  FT.[IncomeStatementBudgetSign]
														  END))		    
				END AS [LY Period 12 Actual Amount]

			FROM        FactProfitAndLossSummary  AS LYPL 
			LEFT OUTER JOIN MapFinancialTemplate as FT   ON FT.AccountSkey = LYPL.AccountSkey 
			INNER JOIN DimCalendarPeriod AS CP ON LYPL.PostPeriodSkey = CP.FiscalPeriodSkey
			WHERE  (LYPL.PostPeriodSkey = cast (substring (cast ((((@pFiscalPeriod-100)/100)*100 + 12)   as varchar(10)), 1, 6) as integer) ) 
					AND (FT.TemplateID = @pTemplate)
					AND LYPL.OrgSkey IN	( Select * from dbo.STRING_SPLIT(@pOrg, ','))

			GROUP BY  FT.GroupID 
				 ,FT.TemplateID
				 ,LYPL.[OrgSkey]
				 ,CP.FiscalPeriodNumber
		
		)LYPL on CYPL.GroupID = LYPL.GroupID
			 AND CYPL.TemplateID = LYPL.TemplateID
			 AND CYPL.OrgSkey = LYPL.OrgSkey
		INNER JOIN [dbo].[DimOrganization] as DO ON CYPL.OrgSkey = DO.OrgSkey
		GROUP BY	
					CYPL.OrgSkey 
					,CYPL.OrganizationID  
					,CYPL.OrganizationID + ' - ' + CYPL.[OrganizationDesc]
					,CYPL.TemplateID
					,CYPL.GroupID
					,CYPL.SortOrder 
					,CYPL.FiscalPeriodNumber
					,GroupDesc
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

			)
			
		
				SELECT Template.*
					--PCTE.*
						--,PCTE.OrganizationID
					,PCTE.FiscalPeriodNumber
					,ISNULL([Period 1 ActualBudget Amount],0.000000) AS [Period 1 ActualBudget Amount]
					,ISNULL([Period 2 ActualBudget Amount],0.000000) AS [Period 2 ActualBudget Amount]
					,ISNULL([Period 3 ActualBudget Amount],0.000000) AS [Period 3 ActualBudget Amount]
					,ISNULL([Period 4 ActualBudget Amount],0.000000) AS [Period 4 ActualBudget Amount]
					,ISNULL([Period 5 ActualBudget Amount],0.000000) AS [Period 5 ActualBudget Amount]
					,ISNULL([Period 6 ActualBudget Amount],0.000000) AS [Period 6 ActualBudget Amount]
					,ISNULL([Period 7 ActualBudget Amount],0.000000) AS [Period 7 ActualBudget Amount]
					,ISNULL([Period 8 ActualBudget Amount],0.000000) AS [Period 8 ActualBudget Amount]
					,ISNULL([Period 9 ActualBudget Amount],0.000000) AS [Period 9 ActualBudget Amount]
					,ISNULL([Period 10 ActualBudget Amount],0.000000) AS [Period 10 ActualBudget Amount]
					,ISNULL([Period 11 ActualBudget Amount],0.000000) AS [Period 11 ActualBudget Amount]
					,ISNULL([Period 12 ActualBudget Amount],0.000000) AS [Period 12 ActualBudget Amount]
					,ISNULL([Q1 ActualBudget Amount],0.000000) AS [Q1 ActualBudget Amount]
					,ISNULL([Q2 ActualBudget Amount],0.000000) AS [Q2 ActualBudget Amount]
					,ISNULL([Q3 ActualBudget Amount],0.000000) AS [Q3 ActualBudget Amount]
					,ISNULL([Q4 ActualBudget Amount],0.000000) AS [Q4 ActualBudget Amount]
					,ISNULL(NRCTE.[Period_1_ActualBudget_Net_Revenues],0.000000) AS [Period_1_ActualBudget_Net_Revenues]
					,ISNULL(NRCTE.[Period_2_ActualBudget_Net_Revenues],0.000000) AS [Period_2_ActualBudget_Net_Revenues]
					,ISNULL(NRCTE.[Period_3_ActualBudget_Net_Revenues],0.000000) AS [Period_3_ActualBudget_Net_Revenues]
					,ISNULL(NRCTE.[Period_4_ActualBudget_Net_Revenues],0.000000) AS [Period_4_ActualBudget_Net_Revenues]
					,ISNULL(NRCTE.[Period_5_ActualBudget_Net_Revenues],0.000000) AS [Period_5_ActualBudget_Net_Revenues]
					,ISNULL(NRCTE.[Period_6_ActualBudget_Net_Revenues],0.000000) AS [Period_6_ActualBudget_Net_Revenues]
					,ISNULL(NRCTE.[Period_7_ActualBudget_Net_Revenues],0.000000) AS [Period_7_ActualBudget_Net_Revenues]
					,ISNULL(NRCTE.[Period_8_ActualBudget_Net_Revenues],0.000000) AS [Period_8_ActualBudget_Net_Revenues]
					,ISNULL(NRCTE.[Period_9_ActualBudget_Net_Revenues],0.000000) AS [Period_9_ActualBudget_Net_Revenues]
					,ISNULL(NRCTE.[Period_10_ActualBudget_Net_Revenues],0.000000) AS [Period_10_ActualBudget_Net_Revenues]
					,ISNULL(NRCTE.[Period_11_ActualBudget_Net_Revenues],0.000000) AS [Period_11_ActualBudget_Net_Revenues]
					,ISNULL(NRCTE.[Period_12_ActualBudget_Net_Revenues],0.000000) AS [Period_12_ActualBudget_Net_Revenues]
					,ISNULL(NRCTE.[Q1_ActualBudget_Net_Revenues],0.000000) AS [Q1_ActualBudget_Net_Revenues]
					,ISNULL(NRCTE.[Q2_ActualBudget_Net_Revenues],0.000000) AS [Q2_ActualBudget_Net_Revenues]
					,ISNULL(NRCTE.[Q3_ActualBudget_Net_Revenues],0.000000) AS [Q3_ActualBudget_Net_Revenues]
					,ISNULL(NRCTE.[Q4_ActualBudget_Net_Revenues],0.000000) AS [Q4_ActualBudget_Net_Revenues]
					,ISNULL(DLCTE.[Period_1_ActualBudget_Direct_Labor],0.000000) AS [Period_1_ActualBudget_Direct_Labor]
					,ISNULL(DLCTE.[Period_2_ActualBudget_Direct_Labor],0.000000) AS [Period_2_ActualBudget_Direct_Labor]
					,ISNULL(DLCTE.[Period_3_ActualBudget_Direct_Labor],0.000000) AS [Period_3_ActualBudget_Direct_Labor]
					,ISNULL(DLCTE.[Period_4_ActualBudget_Direct_Labor],0.000000) AS [Period_4_ActualBudget_Direct_Labor]
					,ISNULL(DLCTE.[Period_5_ActualBudget_Direct_Labor],0.000000) AS [Period_5_ActualBudget_Direct_Labor]
					,ISNULL(DLCTE.[Period_6_ActualBudget_Direct_Labor],0.000000) AS [Period_6_ActualBudget_Direct_Labor]
					,ISNULL(DLCTE.[Period_7_ActualBudget_Direct_Labor],0.000000) AS [Period_7_ActualBudget_Direct_Labor]
					,ISNULL(DLCTE.[Period_8_ActualBudget_Direct_Labor],0.000000) AS [Period_8_ActualBudget_Direct_Labor]
					,ISNULL(DLCTE.[Period_9_ActualBudget_Direct_Labor],0.000000) AS [Period_9_ActualBudget_Direct_Labor]
					,ISNULL(DLCTE.[Period_10_ActualBudget_Direct_Labor],0.000000) AS [Period_10_ActualBudget_Direct_Labor]
					,ISNULL(DLCTE.[Period_11_ActualBudget_Direct_Labor],0.000000) AS [Period_11_ActualBudget_Direct_Labor]
					,ISNULL(DLCTE.[Period_12_ActualBudget_Direct_Labor],0.000000) AS [Period_12_ActualBudget_Direct_Labor]
					,ISNULL(DLCTE.[Q1_ActualBudget_Direct_Labor],0.000000) AS [Q1_ActualBudget_Direct_Labor]
					,ISNULL(DLCTE.[Q2_ActualBudget_Direct_Labor],0.000000) AS [Q2_ActualBudget_Direct_Labor]
					,ISNULL(DLCTE.[Q3_ActualBudget_Direct_Labor],0.000000) AS [Q3_ActualBudget_Direct_Labor]
					,ISNULL(DLCTE.[Q4_ActualBudget_Direct_Labor],0.000000) AS [Q4_ActualBudget_Direct_Labor]
					,ISNULL(FBCTE.[Period_1_ActualBudget_FringeBenefits],0.000000) AS [Period_1_ActualBudget_FringeBenefits]
					,ISNULL(FBCTE.[Period_2_ActualBudget_FringeBenefits],0.000000) AS [Period_2_ActualBudget_FringeBenefits]
					,ISNULL(FBCTE.[Period_3_ActualBudget_FringeBenefits],0.000000) AS [Period_3_ActualBudget_FringeBenefits]
					,ISNULL(FBCTE.[Period_4_ActualBudget_FringeBenefits],0.000000) AS [Period_4_ActualBudget_FringeBenefits]
					,ISNULL(FBCTE.[Period_5_ActualBudget_FringeBenefits],0.000000) AS [Period_5_ActualBudget_FringeBenefits]
					,ISNULL(FBCTE.[Period_6_ActualBudget_FringeBenefits],0.000000) AS [Period_6_ActualBudget_FringeBenefits]
					,ISNULL(FBCTE.[Period_7_ActualBudget_FringeBenefits],0.000000) AS [Period_7_ActualBudget_FringeBenefits]
					,ISNULL(FBCTE.[Period_8_ActualBudget_FringeBenefits],0.000000) AS [Period_8_ActualBudget_FringeBenefits]
					,ISNULL(FBCTE.[Period_9_ActualBudget_FringeBenefits],0.000000) AS [Period_9_ActualBudget_FringeBenefits]
					,ISNULL(FBCTE.[Period_10_ActualBudget_FringeBenefits],0.000000) AS [Period_10_ActualBudget_FringeBenefits]
					,ISNULL(FBCTE.[Period_11_ActualBudget_FringeBenefits],0.000000) AS [Period_11_ActualBudget_FringeBenefits]
					,ISNULL(FBCTE.[Period_12_ActualBudget_FringeBenefits],0.000000) AS [Period_12_ActualBudget_FringeBenefits]
					,ISNULL(FBCTE.[Q1_ActualBudget_FringeBenefits],0.000000) AS [Q1_ActualBudget_FringeBenefits]
					,ISNULL(FBCTE.[Q2_ActualBudget_FringeBenefits],0.000000) AS [Q2_ActualBudget_FringeBenefits]
					,ISNULL(FBCTE.[Q3_ActualBudget_FringeBenefits],0.000000) AS [Q3_ActualBudget_FringeBenefits]
					,ISNULL(FBCTE.[Q4_ActualBudget_FringeBenefits],0.000000) AS [Q4_ActualBudget_FringeBenefits]
					,ISNULL(SACTE.[Period_1_ActualBudget_Salaries],0.000000) AS [Period_1_ActualBudget_Salaries]
					,ISNULL(SACTE.[Period_2_ActualBudget_Salaries],0.000000) AS [Period_2_ActualBudget_Salaries]
					,ISNULL(SACTE.[Period_3_ActualBudget_Salaries],0.000000) AS [Period_3_ActualBudget_Salaries]
					,ISNULL(SACTE.[Period_4_ActualBudget_Salaries],0.000000) AS [Period_4_ActualBudget_Salaries]
					,ISNULL(SACTE.[Period_5_ActualBudget_Salaries],0.000000) AS [Period_5_ActualBudget_Salaries]
					,ISNULL(SACTE.[Period_6_ActualBudget_Salaries],0.000000) AS [Period_6_ActualBudget_Salaries]
					,ISNULL(SACTE.[Period_7_ActualBudget_Salaries],0.000000) AS [Period_7_ActualBudget_Salaries]
					,ISNULL(SACTE.[Period_8_ActualBudget_Salaries],0.000000) AS [Period_8_ActualBudget_Salaries]
					,ISNULL(SACTE.[Period_9_ActualBudget_Salaries],0.000000) AS [Period_9_ActualBudget_Salaries]
					,ISNULL(SACTE.[Period_10_ActualBudget_Salaries],0.000000) AS [Period_10_ActualBudget_Salaries]
					,ISNULL(SACTE.[Period_11_ActualBudget_Salaries],0.000000) AS [Period_11_ActualBudget_Salaries]
					,ISNULL(SACTE.[Period_12_ActualBudget_Salaries],0.000000) AS [Period_12_ActualBudget_Salaries]
					,ISNULL(SACTE.[Q1_ActualBudget_Salaries],0.000000) AS [Q1_ActualBudget_Salaries]
					,ISNULL(SACTE.[Q2_ActualBudget_Salaries],0.000000) AS [Q2_ActualBudget_Salaries]
					,ISNULL(SACTE.[Q3_ActualBudget_Salaries],0.000000) AS [Q3_ActualBudget_Salaries]
					,ISNULL(SACTE.[Q4_ActualBudget_Salaries],0.000000) AS [Q4_ActualBudget_Salaries]
					,ISNULL(EBGECTE.[Period_1_ActualBudget_EBGE],0.000000) AS [Period_1_ActualBudget_EBGE]
					,ISNULL(EBGECTE.[Period_2_ActualBudget_EBGE],0.000000) AS [Period_2_ActualBudget_EBGE]
					,ISNULL(EBGECTE.[Period_3_ActualBudget_EBGE],0.000000) AS [Period_3_ActualBudget_EBGE]
					,ISNULL(EBGECTE.[Period_4_ActualBudget_EBGE],0.000000) AS [Period_4_ActualBudget_EBGE]
					,ISNULL(EBGECTE.[Period_5_ActualBudget_EBGE],0.000000) AS [Period_5_ActualBudget_EBGE]
					,ISNULL(EBGECTE.[Period_6_ActualBudget_EBGE],0.000000) AS [Period_6_ActualBudget_EBGE]
					,ISNULL(EBGECTE.[Period_7_ActualBudget_EBGE],0.000000) AS [Period_7_ActualBudget_EBGE]
					,ISNULL(EBGECTE.[Period_8_ActualBudget_EBGE],0.000000) AS [Period_8_ActualBudget_EBGE]
					,ISNULL(EBGECTE.[Period_9_ActualBudget_EBGE],0.000000) AS [Period_9_ActualBudget_EBGE]
					,ISNULL(EBGECTE.[Period_10_ActualBudget_EBGE],0.000000) AS [Period_10_ActualBudget_EBGE]
					,ISNULL(EBGECTE.[Period_11_ActualBudget_EBGE],0.000000) AS [Period_11_ActualBudget_EBGE]
					,ISNULL(EBGECTE.[Period_12_ActualBudget_EBGE],0.000000) AS [Period_12_ActualBudget_EBGE]
					,ISNULL(EBGECTE.[Q1_ActualBudget_EBGE],0.000000) AS [Q1_ActualBudget_EBGE]
					,ISNULL(EBGECTE.[Q2_ActualBudget_EBGE],0.000000) AS [Q2_ActualBudget_EBGE]
					,ISNULL(EBGECTE.[Q3_ActualBudget_EBGE],0.000000) AS [Q3_ActualBudget_EBGE]
					,ISNULL(EBGECTE.[Q4_ActualBudget_EBGE],0.000000) AS [Q4_ActualBudget_EBGE]
					,ISNULL(EBRECTE.[Period_1_ActualBudget_EBRE],0.000000) AS [Period_1_ActualBudget_EBRE]
					,ISNULL(EBRECTE.[Period_2_ActualBudget_EBRE],0.000000) AS [Period_2_ActualBudget_EBRE]
					,ISNULL(EBRECTE.[Period_3_ActualBudget_EBRE],0.000000) AS [Period_3_ActualBudget_EBRE]
					,ISNULL(EBRECTE.[Period_4_ActualBudget_EBRE],0.000000) AS [Period_4_ActualBudget_EBRE]
					,ISNULL(EBRECTE.[Period_5_ActualBudget_EBRE],0.000000) AS [Period_5_ActualBudget_EBRE]
					,ISNULL(EBRECTE.[Period_6_ActualBudget_EBRE],0.000000) AS [Period_6_ActualBudget_EBRE]
					,ISNULL(EBRECTE.[Period_7_ActualBudget_EBRE],0.000000) AS [Period_7_ActualBudget_EBRE]
					,ISNULL(EBRECTE.[Period_8_ActualBudget_EBRE],0.000000) AS [Period_8_ActualBudget_EBRE]
					,ISNULL(EBRECTE.[Period_9_ActualBudget_EBRE],0.000000) AS [Period_9_ActualBudget_EBRE]
					,ISNULL(EBRECTE.[Period_10_ActualBudget_EBRE],0.000000) AS [Period_10_ActualBudget_EBRE]
					,ISNULL(EBRECTE.[Period_11_ActualBudget_EBRE],0.000000) AS [Period_11_ActualBudget_EBRE]
					,ISNULL(EBRECTE.[Period_12_ActualBudget_EBRE],0.000000) AS [Period_12_ActualBudget_EBRE]
					,ISNULL(EBRECTE.[Q1_ActualBudget_EBRE],0.000000) AS [Q1_ActualBudget_EBRE]
					,ISNULL(EBRECTE.[Q2_ActualBudget_EBRE],0.000000) AS [Q2_ActualBudget_EBRE]
					,ISNULL(EBRECTE.[Q3_ActualBudget_EBRE],0.000000) AS [Q3_ActualBudget_EBRE]
					,ISNULL(EBRECTE.[Q4_ActualBudget_EBRE],0.000000) AS [Q4_ActualBudget_EBRE]
					,ISNULL(EBITDACTE.[Period_1_ActualBudget_EBITDA],0.000000) AS [Period_1_ActualBudget_EBITDA]
					,ISNULL(EBITDACTE.[Period_2_ActualBudget_EBITDA],0.000000) AS [Period_2_ActualBudget_EBITDA]
					,ISNULL(EBITDACTE.[Period_3_ActualBudget_EBITDA],0.000000) AS [Period_3_ActualBudget_EBITDA]
					,ISNULL(EBITDACTE.[Period_4_ActualBudget_EBITDA],0.000000) AS [Period_4_ActualBudget_EBITDA]
					,ISNULL(EBITDACTE.[Period_5_ActualBudget_EBITDA],0.000000) AS [Period_5_ActualBudget_EBITDA]
					,ISNULL(EBITDACTE.[Period_6_ActualBudget_EBITDA],0.000000) AS [Period_6_ActualBudget_EBITDA]
					,ISNULL(EBITDACTE.[Period_7_ActualBudget_EBITDA],0.000000) AS [Period_7_ActualBudget_EBITDA]
					,ISNULL(EBITDACTE.[Period_8_ActualBudget_EBITDA],0.000000) AS [Period_8_ActualBudget_EBITDA]
					,ISNULL(EBITDACTE.[Period_9_ActualBudget_EBITDA],0.000000) AS [Period_9_ActualBudget_EBITDA]
					,ISNULL(EBITDACTE.[Period_10_ActualBudget_EBITDA],0.000000) AS [Period_10_ActualBudget_EBITDA]
					,ISNULL(EBITDACTE.[Period_11_ActualBudget_EBITDA],0.000000) AS [Period_11_ActualBudget_EBITDA]
					,ISNULL(EBITDACTE.[Period_12_ActualBudget_EBITDA],0.000000) AS [Period_12_ActualBudget_EBITDA]
					,ISNULL(EBITDACTE.[Q1_ActualBudget_EBITDA],0.000000) AS [Q1_ActualBudget_EBITDA]
					,ISNULL(EBITDACTE.[Q2_ActualBudget_EBITDA],0.000000) AS [Q2_ActualBudget_EBITDA]
					,ISNULL(EBITDACTE.[Q3_ActualBudget_EBITDA],0.000000) AS [Q3_ActualBudget_EBITDA]
					,ISNULL(EBITDACTE.[Q4_ActualBudget_EBITDA],0.000000) AS [Q4_ActualBudget_EBITDA]
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
					 LEFT OUTER JOIN(
						Select  OrganizationID
							,[Period 1 ActualBudget Amount] AS [Period_1_ActualBudget_Net_Revenues]
							,[Period 2 ActualBudget Amount] AS [Period_2_ActualBudget_Net_Revenues]
							,[Period 3 ActualBudget Amount] AS [Period_3_ActualBudget_Net_Revenues]
							,[Period 4 ActualBudget Amount] AS [Period_4_ActualBudget_Net_Revenues]
							,[Period 5 ActualBudget Amount] AS [Period_5_ActualBudget_Net_Revenues]
							,[Period 6 ActualBudget Amount] AS [Period_6_ActualBudget_Net_Revenues]
							,[Period 7 ActualBudget Amount] AS [Period_7_ActualBudget_Net_Revenues]
							,[Period 8 ActualBudget Amount] AS [Period_8_ActualBudget_Net_Revenues]
							,[Period 9 ActualBudget Amount] AS [Period_9_ActualBudget_Net_Revenues]
							,[Period 10 ActualBudget Amount] AS [Period_10_ActualBudget_Net_Revenues]
							,[Period 11 ActualBudget Amount] AS [Period_11_ActualBudget_Net_Revenues]
							,[Period 12 ActualBudget Amount] AS [Period_12_ActualBudget_Net_Revenues]
							,[Q1 ActualBudget Amount] AS [Q1_ActualBudget_Net_Revenues]
							,[Q2 ActualBudget Amount] AS [Q2_ActualBudget_Net_Revenues]
							,[Q3 ActualBudget Amount] AS [Q3_ActualBudget_Net_Revenues]
							,[Q4 ActualBudget Amount] AS [Q4_ActualBudget_Net_Revenues]
						FROM ProfitandLossCTE 
						WHERE [IsNetRevenues] = 'Y')NRCTE
							ON Template.OrganizationID = NRCTE.OrganizationID --on PCTE.GroupId in (106,95,108,96) = NRCTE.GroupId
						
				LEFT OUTER JOIN (
						Select  OrganizationID
							,[Period 1 ActualBudget Amount] AS [Period_1_ActualBudget_Direct_Labor]
							,[Period 2 ActualBudget Amount] AS [Period_2_ActualBudget_Direct_Labor]
							,[Period 3 ActualBudget Amount] AS [Period_3_ActualBudget_Direct_Labor]
							,[Period 4 ActualBudget Amount] AS [Period_4_ActualBudget_Direct_Labor]
							,[Period 5 ActualBudget Amount] AS [Period_5_ActualBudget_Direct_Labor]
							,[Period 6 ActualBudget Amount] AS [Period_6_ActualBudget_Direct_Labor]
							,[Period 7 ActualBudget Amount] AS [Period_7_ActualBudget_Direct_Labor]
							,[Period 8 ActualBudget Amount] AS [Period_8_ActualBudget_Direct_Labor]
							,[Period 9 ActualBudget Amount] AS [Period_9_ActualBudget_Direct_Labor]
							,[Period 10 ActualBudget Amount] AS [Period_10_ActualBudget_Direct_Labor]
							,[Period 11 ActualBudget Amount] AS [Period_11_ActualBudget_Direct_Labor]
							,[Period 12 ActualBudget Amount] AS [Period_12_ActualBudget_Direct_Labor]
							,[Q1 ActualBudget Amount] AS [Q1_ActualBudget_Direct_Labor]
							,[Q2 ActualBudget Amount] AS [Q2_ActualBudget_Direct_Labor]
							,[Q3 ActualBudget Amount] AS [Q3_ActualBudget_Direct_Labor]
							,[Q4 ActualBudget Amount] AS [Q4_ActualBudget_Direct_Labor]
						FROM ProfitandLossCTE 
						WHERE [IsDirectLabor] = 'Y'
								   )DLCTE on 
								   Template.OrganizationID = DLCTE.OrganizationID
								   AND Template.GroupId in (94,95,96,100,106,108)
								
				  LEFT OUTER JOIN (
						Select OrganizationID
							,[Period 1 ActualBudget Amount] AS [Period_1_ActualBudget_FringeBenefits]
							,[Period 2 ActualBudget Amount] AS [Period_2_ActualBudget_FringeBenefits]
							,[Period 3 ActualBudget Amount] AS [Period_3_ActualBudget_FringeBenefits]
							,[Period 4 ActualBudget Amount] AS [Period_4_ActualBudget_FringeBenefits]
							,[Period 5 ActualBudget Amount] AS [Period_5_ActualBudget_FringeBenefits]
							,[Period 6 ActualBudget Amount] AS [Period_6_ActualBudget_FringeBenefits]
							,[Period 7 ActualBudget Amount] AS [Period_7_ActualBudget_FringeBenefits]
							,[Period 8 ActualBudget Amount] AS [Period_8_ActualBudget_FringeBenefits]
							,[Period 9 ActualBudget Amount] AS [Period_9_ActualBudget_FringeBenefits]
							,[Period 10 ActualBudget Amount] AS [Period_10_ActualBudget_FringeBenefits]
							,[Period 11 ActualBudget Amount] AS [Period_11_ActualBudget_FringeBenefits]
							,[Period 12 ActualBudget Amount] AS [Period_12_ActualBudget_FringeBenefits]	
							,[Q1 ActualBudget Amount] AS [Q1_ActualBudget_FringeBenefits]
							,[Q2 ActualBudget Amount] AS [Q2_ActualBudget_FringeBenefits]
							,[Q3 ActualBudget Amount] AS [Q3_ActualBudget_FringeBenefits]
							,[Q4 ActualBudget Amount] AS [Q4_ActualBudget_FringeBenefits]
						FROM ProfitandLossCTE 
						WHERE [IsFringeBenefits] = 'Y'
								   )FBCTE on  Template.OrganizationID = FBCTE.OrganizationID
									AND Template.GroupId in (94,95,96,100,106,108)
			


						LEFT OUTER JOIN ( 
						Select  OrganizationID
							,SUM([Period 1 ActualBudget Amount]) AS [Period_1_ActualBudget_Salaries]
							,SUM([Period 2 ActualBudget Amount]) AS [Period_2_ActualBudget_Salaries]
							,SUM([Period 3 ActualBudget Amount]) AS [Period_3_ActualBudget_Salaries]
							,SUM([Period 4 ActualBudget Amount]) AS [Period_4_ActualBudget_Salaries]
							,SUM([Period 5 ActualBudget Amount]) AS [Period_5_ActualBudget_Salaries]
							,SUM([Period 6 ActualBudget Amount]) AS [Period_6_ActualBudget_Salaries]
							,SUM([Period 7 ActualBudget Amount]) AS [Period_7_ActualBudget_Salaries]
							,SUM([Period 8 ActualBudget Amount]) AS [Period_8_ActualBudget_Salaries]
							,SUM([Period 9 ActualBudget Amount]) AS [Period_9_ActualBudget_Salaries]
							,SUM([Period 10 ActualBudget Amount]) AS [Period_10_ActualBudget_Salaries]
							,SUM([Period 11 ActualBudget Amount]) AS [Period_11_ActualBudget_Salaries]
							,SUM([Period 12 ActualBudget Amount]) AS [Period_12_ActualBudget_Salaries]
							,SUM([Q1 ActualBudget Amount]) AS [Q1_ActualBudget_Salaries]
							,SUM([Q2 ActualBudget Amount]) AS [Q2_ActualBudget_Salaries]
							,SUM([Q3 ActualBudget Amount]) AS [Q3_ActualBudget_Salaries]
							,SUM([Q4 ActualBudget Amount]) AS [Q4_ActualBudget_Salaries]
						FROM ProfitandLossCTE 
						WHERE [IsDirectLabor] = 'Y' OR [IsManagementSalaries] = 'Y'
							 OR [IsMarketingSalaries] = 'Y' OR [IsTrainingSalaries] = 'Y'
							 GROUP BY OrganizationID
								   )SACTE on Template.OrganizationID = SACTE.OrganizationID
								   AND Template.GroupId in (94,95,96,100,106,108)
					   

						LEFT OUTER JOIN (
						Select  OrganizationID
							,[Period 1 ActualBudget Amount] AS [Period_1_ActualBudget_EBGE]
							,[Period 2 ActualBudget Amount] AS [Period_2_ActualBudget_EBGE]
							,[Period 3 ActualBudget Amount] AS [Period_3_ActualBudget_EBGE]
							,[Period 4 ActualBudget Amount] AS [Period_4_ActualBudget_EBGE]
							,[Period 5 ActualBudget Amount] AS [Period_5_ActualBudget_EBGE]
							,[Period 6 ActualBudget Amount] AS [Period_6_ActualBudget_EBGE]
							,[Period 7 ActualBudget Amount] AS [Period_7_ActualBudget_EBGE]
							,[Period 8 ActualBudget Amount] AS [Period_8_ActualBudget_EBGE]
							,[Period 9 ActualBudget Amount] AS [Period_9_ActualBudget_EBGE]
							,[Period 10 ActualBudget Amount] AS [Period_10_ActualBudget_EBGE]
							,[Period 11 ActualBudget Amount] AS [Period_11_ActualBudget_EBGE]
							,[Period 12 ActualBudget Amount] AS [Period_12_ActualBudget_EBGE]
							,[Q1 ActualBudget Amount] AS [Q1_ActualBudget_EBGE]
							,[Q2 ActualBudget Amount] AS [Q2_ActualBudget_EBGE]
							,[Q3 ActualBudget Amount] AS [Q3_ActualBudget_EBGE]
							,[Q4 ActualBudget Amount] AS [Q4_ActualBudget_EBGE]
						FROM ProfitandLossCTE 
						WHERE [IsEBGE] = 'Y'
								   )EBGECTE on Template.OrganizationID = EBGECTE.OrganizationID
									AND Template.GroupId in (94,95,96,100,106,108)
						LEFT OUTER JOIN (
						Select  OrganizationID
							,[Period 1 ActualBudget Amount] AS [Period_1_ActualBudget_EBRE]
							,[Period 2 ActualBudget Amount] AS [Period_2_ActualBudget_EBRE]
							,[Period 3 ActualBudget Amount] AS [Period_3_ActualBudget_EBRE]
							,[Period 4 ActualBudget Amount] AS [Period_4_ActualBudget_EBRE]
							,[Period 5 ActualBudget Amount] AS [Period_5_ActualBudget_EBRE]
							,[Period 6 ActualBudget Amount] AS [Period_6_ActualBudget_EBRE]
							,[Period 7 ActualBudget Amount] AS [Period_7_ActualBudget_EBRE]
							,[Period 8 ActualBudget Amount] AS [Period_8_ActualBudget_EBRE]
							,[Period 9 ActualBudget Amount] AS [Period_9_ActualBudget_EBRE]
							,[Period 10 ActualBudget Amount] AS [Period_10_ActualBudget_EBRE]
							,[Period 11 ActualBudget Amount] AS [Period_11_ActualBudget_EBRE]
							,[Period 12 ActualBudget Amount] AS [Period_12_ActualBudget_EBRE]
							,[Q1 ActualBudget Amount] AS [Q1_ActualBudget_EBRE]
							,[Q2 ActualBudget Amount] AS [Q2_ActualBudget_EBRE]
							,[Q3 ActualBudget Amount] AS [Q3_ActualBudget_EBRE]
							,[Q4 ActualBudget Amount] AS [Q4_ActualBudget_EBRE]
						FROM ProfitandLossCTE 
						WHERE [IsEBRE] = 'Y'
								   )EBRECTE on Template.OrganizationID = EBRECTE.OrganizationID
									AND Template.GroupId in (94,95,96,100,106,108)
						LEFT OUTER JOIN (
						Select  OrganizationID
							,[Period 1 ActualBudget Amount] AS [Period_1_ActualBudget_EBITDA]
							,[Period 2 ActualBudget Amount] AS [Period_2_ActualBudget_EBITDA]
							,[Period 3 ActualBudget Amount] AS [Period_3_ActualBudget_EBITDA]
							,[Period 4 ActualBudget Amount] AS [Period_4_ActualBudget_EBITDA]
							,[Period 5 ActualBudget Amount] AS [Period_5_ActualBudget_EBITDA]
							,[Period 6 ActualBudget Amount] AS [Period_6_ActualBudget_EBITDA]
							,[Period 7 ActualBudget Amount] AS [Period_7_ActualBudget_EBITDA]
							,[Period 8 ActualBudget Amount] AS [Period_8_ActualBudget_EBITDA]
							,[Period 9 ActualBudget Amount] AS [Period_9_ActualBudget_EBITDA]
							,[Period 10 ActualBudget Amount] AS [Period_10_ActualBudget_EBITDA]
							,[Period 11 ActualBudget Amount] AS [Period_11_ActualBudget_EBITDA]
							,[Period 12 ActualBudget Amount] AS [Period_12_ActualBudget_EBITDA]
							,[Q1 ActualBudget Amount] AS [Q1_ActualBudget_EBITDA]
							,[Q2 ActualBudget Amount] AS [Q2_ActualBudget_EBITDA]
							,[Q3 ActualBudget Amount] AS [Q3_ActualBudget_EBITDA]
							,[Q4 ActualBudget Amount] AS [Q4_ActualBudget_EBITDA]
						FROM ProfitandLossCTE 
						WHERE [IsEBITDA] = 'Y'
								   )EBITDACTE on Template.OrganizationID = EBITDACTE.OrganizationID
								   AND Template.GroupId in (94,95,96,100,106,108)

					 Order by Template.OrganizationID,Template.SortOrder,  Template.GroupID,  Template.GroupDesc
			
					-- PCTE.OrganizationID, SortOrder,GroupId, GroupDesc
	
END





GO

