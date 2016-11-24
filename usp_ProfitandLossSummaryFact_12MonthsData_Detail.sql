USE [BIDataWarehouse]
GO

/****** Object:  StoredProcedure [dbo].[usp_ProfitandLossSummaryFact_12MonthsData_Detail]    Script Date: 24/11/2016 11:06:16 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/**
	Author: Jude Chelliah
	Purpose: Reports - Profit and Loss; The SP is capable to produce most of the profit and loss related reports.
	Change Management: Added PY Actual to original Detail SP.
	TFS Capablity: added to source control

**/



CREATE Procedure [dbo].[usp_ProfitandLossSummaryFact_12MonthsData_Detail] 
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
						,[Current Month Amount],[Current Month Budget Amount],[YTD Amount]
						,[Current Month Forecast 1 Amount],[Current Month Forecast 2 Amount],[Current Month Forecast 3 Amount]
						,[YTD Budget Amount]
						,[Current Year Budget Amount]
						,[YTD Forecast 1 Amount],[YTD Forecast 2 Amount],[YTD Forecast 3 Amount]
						,[LY Current Month Amount],[LY YTD Amount],[LY YTD Budget Amount] 
						,[QTD Amount],[LY QTD Amount],[QTD Budget Amount],[LY QTD Budget Amount]
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
						DO.OrgSkey
						,DO.OrganizationID  
						,DO.OrganizationID + ' - ' + DO.[OrganizationDesc] as [Organization Name]
						,FT.TemplateID
						,FT.GroupID 
					    ,Case @pLanguage When @ENLanguage THEN FT.GroupDescEN 
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
					,SortOrder
					,CP.FiscalPeriodNumber
					,ISNULL(Case @pCurrency  WHEN @ConsCurrency THEN SUM(PL.ConsCMAmt * FT.IncomeStatementActualSign) 
									   WHEN @FuncCurrency THEN SUM(PL.FuncCMAmt * FT.IncomeStatementActualSign)
									   ELSE 0.000000
						END,0.000000) as [Current Month Amount]
					,ISNULL(Case @pCurrency  WHEN @ConsCurrency THEN SUM(PL.ConsCMBudgetAmt * FT.IncomeStatementBudgetSign)
									   WHEN @FuncCurrency THEN SUM(PL.FuncCMBudgetAmt * FT.IncomeStatementBudgetSign)
									   ELSE 0.000000
						END,0.000000) as [Current Month Budget Amount]
					,ISNULL(Case @pCurrency  WHEN @ConsCurrency THEN SUM(PL.ConsYTDAmt * FT.IncomeStatementActualSign)
										WHEN @FuncCurrency THEN SUM(PL.FuncYTDAmt * FT.IncomeStatementActualSign)
										ELSE 0.000000
						END,0.000000) as [YTD Amount]
					,ISNULL(SUM((Case @pCurrency  WHEN @ConsCurrency THEN PL.ConsCMFC1Amt 
									   WHEN @FuncCurrency THEN PL.FuncCMFC1Amt 
									   ELSE 0.000000
									   END) * 
							Case When CP.[FiscalPeriodNumber] <= 2 Then [IncomeStatementActualSign]  
										Else [IncomeStatementBudgetSign]
										END 
										),0.000000) as [Current Month Forecast 1 Amount]
					,ISNULL(SUM((Case @pCurrency  WHEN @ConsCurrency THEN PL.ConsCMFC2Amt 
									   WHEN @FuncCurrency THEN PL.FuncCMFC2Amt 
									   ELSE 0.000000
									   END) * 
							Case When CP.[FiscalPeriodNumber] <= 5 Then [IncomeStatementActualSign]  
										Else [IncomeStatementBudgetSign]
										END 
										),0.000000) as [Current Month Forecast 2 Amount]
					,ISNULL(SUM((Case @pCurrency  WHEN @ConsCurrency THEN PL.ConsCMFC3Amt 
									   WHEN @FuncCurrency THEN PL.FuncCMFC3Amt 
									   ELSE 0.000000
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
						ELSE 0.000000
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
							ELSE 0.000000
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
							ELSE 0.000000
							END,0.000000) AS [YTD Forecast 3 Amount]
--added
					,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN SUM(PL.ConsLYCMAmt * FT.IncomeStatementActualSign)
					  WHEN @FuncCurrency THEN SUM(PL.FuncLYCMAmt * FT.IncomeStatementActualSign)
							END,0.000000) AS [LY Current Month Amount]
					,ISNULL(Case @pCurrency  WHEN @ConsCurrency THEN SUM(PL.ConsLYYTDAmt * FT.IncomeStatementActualSign)
										WHEN @FuncCurrency THEN SUM(PL.FuncLYYTDAmt * FT.IncomeStatementActualSign)
										ELSE 0.000000
							END,0.000000) as [LY YTD Amount]
					,ISNULL(Case @pCurrency  WHEN @ConsCurrency THEN SUM(PL.ConsLYYTDBudgetAmt * FT.IncomeStatementBudgetSign)
									   WHEN @FuncCurrency THEN SUM(PL.FuncLYYTDBudgetAmt * FT.IncomeStatementBudgetSign)
							END,0.000000) as [LY YTD Budget Amount]
					,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN SUM(PL.ConsQTDAmt * FT.IncomeStatementActualSign)
					  WHEN @FuncCurrency THEN SUM(PL.FuncQTDAmt * FT.IncomeStatementActualSign)
							END,0.000000) AS [QTD Amount]
					,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN SUM(PL.ConsLYQTDAmt * FT.IncomeStatementActualSign)
					  WHEN @FuncCurrency THEN SUM(PL.FuncLYQTDAmt * FT.IncomeStatementActualSign)
							END,0.000000) AS [LY QTD Amount]
					,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN SUM(PL.ConsQTDBudgetAmt * FT.IncomeStatementBudgetSign)
					  WHEN @FuncCurrency THEN SUM(PL.FuncQTDBudgetAmt * FT.IncomeStatementBudgetSign)
							END,0.000000) AS [QTD Budget Amount]
					,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN SUM(PL.ConsLYQTDBudgetAmt * FT.IncomeStatementBudgetSign)
					  WHEN @FuncCurrency THEN SUM(PL.FuncLYQTDBudgetAmt * FT.IncomeStatementBudgetSign)
							END,0.000000) AS [LY QTD Budget Amount]
					,ISNULL(Case @pCurrency 
						WHEN @ConsCurrency THEN 
						  (CASE CP.[FiscalPeriodNumber] 
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
						  END)
					 WHEN @FuncCurrency THEN
						  (CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.FuncP1FC1Amt) * FT.IncomeStatementActualSign)) 				  
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
						  END)
						ELSE 0.000000
						END,0.000000) AS [QTD Forecast 1 Amount]
					,ISNULL(Case @pCurrency 
						WHEN @ConsCurrency THEN 
						  (CASE CP.[FiscalPeriodNumber] 
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
						  END)
					 WHEN @FuncCurrency THEN
						  (CASE CP.[FiscalPeriodNumber] 
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
						  END)
						ELSE 0.000000
						END,0.000000) AS [QTD Forecast 2 Amount]
					,ISNULL(Case @pCurrency 
						WHEN @ConsCurrency THEN 
						  (CASE CP.[FiscalPeriodNumber] 
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
						  END)
					 WHEN @FuncCurrency THEN
						  (CASE CP.[FiscalPeriodNumber] 
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
						  END)
						ELSE 0.000000
						END,0.000000) AS [QTD Forecast 3 Amount]
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN
						 ( SUM(PL.ConsP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 1 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0.000000 END ))
					  WHEN @FuncCurrency THEN
							( SUM(PL.FuncP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 1 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0.000000 END ))
							END,0.000000) AS [Period 1 Actual Amount]
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN
						 ( SUM(PL.ConsP2ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 2 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0.000000 END ))
					  WHEN @FuncCurrency THEN
							( SUM(PL.FuncP2ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 2 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0.000000 END ))
							END,0.000000) AS [Period 2 Actual Amount]
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN
						 ( SUM(PL.ConsP3ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 3 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0.000000 END ))
					  WHEN @FuncCurrency THEN
							( SUM(PL.FuncP3ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 3 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0.000000 END ))
							END,0.000000) AS [Period 3 Actual Amount]
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN
						 ( SUM(PL.ConsP4ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 4 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0.000000 END ))
					  WHEN @FuncCurrency THEN
							( SUM(PL.FuncP4ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 4 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0.000000 END ))
							END,0.000000) AS [Period 4 Actual Amount]
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN
						 ( SUM(PL.ConsP5ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 5 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0.000000 END ))
					  WHEN @FuncCurrency THEN
							( SUM(PL.FuncP5ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 5 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0.000000 END ))
							END,0.000000) AS [Period 5 Actual Amount]
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN
						 ( SUM(PL.ConsP6ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 6 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0.000000 END ))
					  WHEN @FuncCurrency THEN
							( SUM(PL.FuncP6ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 6 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0.000000 END ))
							END,0.000000) AS [Period 6 Actual Amount]
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN
						 ( SUM(PL.ConsP7ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 7 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0.000000 END ))
					  WHEN @FuncCurrency THEN
							( SUM(PL.FuncP7ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 7 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0.000000 END ))
							END,0.000000) AS [Period 7 Actual Amount]
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN
						 ( SUM(PL.ConsP8ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 8 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0.000000 END ))
					  WHEN @FuncCurrency THEN
							( SUM(PL.FuncP8ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 8 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0.000000 END ))
							END,0.000000) AS [Period 8 Actual Amount]
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN
						 ( SUM(PL.ConsP9ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0.000000 END ))
					  WHEN @FuncCurrency THEN
							( SUM(PL.FuncP9ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0.000000 END ))
							END,0.000000) AS [Period 9 Actual Amount]	
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN
						 ( SUM(PL.ConsP10ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 10 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0.000000 END ))
					  WHEN @FuncCurrency THEN
							( SUM(PL.FuncP10ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 10 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0.000000 END ))
							END,0.000000) AS [Period 10 Actual Amount]
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN
						 ( SUM(PL.ConsP11ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 11 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0.000000 END ))
					  WHEN @FuncCurrency THEN
							( SUM(PL.FuncP11ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 11 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0.000000 END ))
							END,0.000000) AS [Period 11 Actual Amount]
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN
						 ( SUM(PL.ConsP12ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 12 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0.000000 END ))
					  WHEN @FuncCurrency THEN
							( SUM(PL.FuncP12ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 12 AND 
								 CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0.000000 END ))
							END,0.000000) AS [Period 12 Actual Amount]
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP1BudgetAmt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP1BudgetAmt * FT.IncomeStatementBudgetSign) )
							END,0.000000) AS [Period 1 Budget Amount]
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP2BudgetAmt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP2BudgetAmt * FT.IncomeStatementBudgetSign) )
							END,0.000000) AS [Period 2 Budget Amount]
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP3BudgetAmt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP3BudgetAmt * FT.IncomeStatementBudgetSign) )
							END,0.000000) AS [Period 3 Budget Amount]
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP4BudgetAmt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP4BudgetAmt * FT.IncomeStatementBudgetSign) )
							END,0.000000) AS [Period 4 Budget Amount]
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP5BudgetAmt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP5BudgetAmt * FT.IncomeStatementBudgetSign) )
							END,0.000000) AS [Period 5 Budget Amount]
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP6BudgetAmt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP6BudgetAmt * FT.IncomeStatementBudgetSign) )
							END,0.000000) AS [Period 6 Budget Amount]
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP7BudgetAmt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP7BudgetAmt * FT.IncomeStatementBudgetSign) )
							END,0.000000) AS [Period 7 Budget Amount]
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP8BudgetAmt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP8BudgetAmt * FT.IncomeStatementBudgetSign) )
							END,0.000000) AS [Period 8 Budget Amount]
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP9BudgetAmt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP9BudgetAmt * FT.IncomeStatementBudgetSign) )
							END,0.000000) AS [Period 9 Budget Amount]
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP10BudgetAmt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP10BudgetAmt * FT.IncomeStatementBudgetSign) )
							END,0.000000) AS [Period 10 Budget Amount]
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP11BudgetAmt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP11BudgetAmt * FT.IncomeStatementBudgetSign) )
							END,0.000000) AS [Period 11 Budget Amount]
					  ,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP12BudgetAmt * FT.IncomeStatementBudgetSign) )
					  WHEN @FuncCurrency THEN ( SUM(PL.FuncP12BudgetAmt * FT.IncomeStatementBudgetSign) )
							END,0.000000) AS [Period 12 Budget Amount]
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
						,FT.GroupID, 
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
						
			)
			
		
				SELECT Template.*
					--PCTE.*
						--,PCTE.OrganizationID
					,PCTE.FiscalPeriodNumber
					,ISNULL([Current Month Amount],0.000000) AS [Current Month Amount]
					,ISNULL([Current Month Budget Amount],0.000000) AS [Current Month Budget Amount]
					,ISNULL([YTD Amount],0.000000) AS [YTD Amount]
					,ISNULL([LY YTD Amount],0.000000) AS [LY YTD Amount]
					,ISNULL([Current Month Forecast 1 Amount],0.000000) AS [Current Month Forecast 1 Amount]
					,ISNULL([Current Month Forecast 2 Amount],0.000000) AS [Current Month Forecast 2 Amount]
					,ISNULL([Current Month Forecast 3 Amount],0.000000) AS [Current Month Forecast 3 Amount]
					,ISNULL([YTD Budget Amount],0.000000) AS [YTD Budget Amount]
					,ISNULL([LY YTD Budget Amount],0.000000) AS [LY YTD Budget Amount]
					,ISNULL([Current Year Budget Amount],0.000000) AS [Current Year Budget Amount]
					,ISNULL([YTD Forecast 1 Amount],0.000000) AS [YTD Forecast 1 Amount]
					,ISNULL([YTD Forecast 2 Amount],0.000000) AS [YTD Forecast 2 Amount]
					,ISNULL([YTD Forecast 3 Amount],0.000000) AS [YTD Forecast 3 Amount]
					,ISNULL([LY Current Month Amount],0.000000) AS [LY Current Month Amount]
					,ISNULL([QTD Amount],0.000000) AS [QTD Amount]
					,ISNULL([LY QTD Amount],0.000000) AS [LY QTD Amount]
					,ISNULL([QTD Budget Amount],0.000000) AS [QTD Budget Amount]
					,ISNULL([LY QTD Budget Amount],0.000000) AS [LY QTD Budget Amount]
					,ISNULL([QTD Forecast 1 Amount],0.000000) AS [QTD Forecast 1 Amount]
					,ISNULL([QTD Forecast 2 Amount],0.000000) AS [QTD Forecast 2 Amount]
					,ISNULL([QTD Forecast 3 Amount],0.000000) AS [QTD Forecast 3 Amount]
					,ISNULL([Period 1 Actual Amount],0.000000) AS [Period 1 Actual Amount]
					,ISNULL([Period 2 Actual Amount],0.000000) AS [Period 2 Actual Amount]
					,ISNULL([Period 3 Actual Amount],0.000000) AS [Period 3 Actual Amount]
					,ISNULL([Period 4 Actual Amount],0.000000) AS [Period 4 Actual Amount]
					,ISNULL([Period 5 Actual Amount],0.000000) AS [Period 5 Actual Amount]
					,ISNULL([Period 6 Actual Amount],0.000000) AS [Period 6 Actual Amount]
					,ISNULL([Period 7 Actual Amount],0.000000) AS [Period 7 Actual Amount]
					,ISNULL([Period 8 Actual Amount],0.000000) AS [Period 8 Actual Amount]
					,ISNULL([Period 9 Actual Amount],0.000000) AS [Period 9 Actual Amount]
					,ISNULL([Period 10 Actual Amount],0.000000) AS [Period 10 Actual Amount]
					,ISNULL([Period 11 Actual Amount],0.000000) AS [Period 11 Actual Amount]
					,ISNULL([Period 12 Actual Amount],0.000000) AS [Period 12 Actual Amount]
					,ISNULL([Period 1 Budget Amount],0.000000) AS [Period 1 Budget Amount]
					,ISNULL([Period 2 Budget Amount],0.000000) AS [Period 2 Budget Amount]
					,ISNULL([Period 3 Budget Amount],0.000000) AS [Period 3 Budget Amount]
					,ISNULL([Period 4 Budget Amount],0.000000) AS [Period 4 Budget Amount]
					,ISNULL([Period 5 Budget Amount],0.000000) AS [Period 5 Budget Amount]
					,ISNULL([Period 6 Budget Amount],0.000000) AS [Period 6 Budget Amount]
					,ISNULL([Period 7 Budget Amount],0.000000) AS [Period 7 Budget Amount]
					,ISNULL([Period 8 Budget Amount],0.000000) AS [Period 8 Budget Amount]
					,ISNULL([Period 9 Budget Amount],0.000000) AS [Period 9 Budget Amount]
					,ISNULL([Period 10 Budget Amount],0.000000) AS [Period 10 Budget Amount]
					,ISNULL([Period 11 Budget Amount],0.000000) AS [Period 11 Budget Amount]
					,ISNULL([Period 12 Budget Amount],0.000000) AS [Period 12 Budget Amount]
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
					,ISNULL([LY Period 1 Actual Amount],0.000000) AS [LY Period 1 Actual Amount]
					,ISNULL([LY Period 2 Actual Amount],0.000000) AS [LY Period 2 Actual Amount]
					,ISNULL([LY Period 3 Actual Amount],0.000000) AS [LY Period 3 Actual Amount]
					,ISNULL([LY Period 4 Actual Amount],0.000000) AS [LY Period 4 Actual Amount]
					,ISNULL([LY Period 5 Actual Amount],0.000000) AS [LY Period 5 Actual Amount]
					,ISNULL([LY Period 6 Actual Amount],0.000000) AS [LY Period 6 Actual Amount]
					,ISNULL([LY Period 7 Actual Amount],0.000000) AS [LY Period 7 Actual Amount]
					,ISNULL([LY Period 8 Actual Amount],0.000000) AS [LY Period 8 Actual Amount]
					,ISNULL([LY Period 9 Actual Amount],0.000000) AS [LY Period 9 Actual Amount]
					,ISNULL([LY Period 10 Actual Amount],0.000000) AS [LY Period 10 Actual Amount]
					,ISNULL([LY Period 11 Actual Amount],0.000000) AS [LY Period 11 Actual Amount]
					,ISNULL([LY Period 12 Actual Amount],0.000000) AS [LY Period 12 Actual Amount]
					,ISNULL(NRCTE.[Current_Net_Revenues],0.000000) AS [Current_Net_Revenues]
					,ISNULL(NRCTE.[LY_Current_Net_Revenues],0.000000) AS [LY_Current_Net_Revenues]
					,ISNULL(NRCTE.Budget_Current_Net_Revenues,0.000000) AS Budget_Current_Net_Revenues
					,ISNULL(NRCTE.Forecast_Current_Net_Revenues_Q1,0.000000) AS Forecast_Current_Net_Revenues_Q1
					,ISNULL(NRCTE.Forecast_Current_Net_Revenues_Q2,0.000000) AS Forecast_Current_Net_Revenues_Q2
					,ISNULL(NRCTE.Forecast_Current_Net_Revenues_Q3,0.000000) AS Forecast_Current_Net_Revenues_Q3
					,ISNULL(NRCTE.YTD_Net_Revenues,0.000000) AS YTD_Net_Revenues
					,ISNULL(NRCTE.Budget_YTD_Net_Revenues,0.000000) AS Budget_YTD_Net_Revenues
					,ISNULL(NRCTE.Forecast_YTD_Net_Revenues_Q1,0.000000) AS Forecast_YTD_Net_Revenues_Q1
					,ISNULL(NRCTE.Forecast_YTD_Net_Revenues_Q2,0.000000) AS Forecast_YTD_Net_Revenues_Q2
					,ISNULL(NRCTE.Forecast_YTD_Net_Revenues_Q3,0.000000) AS Forecast_YTD_Net_Revenues_Q3
					,ISNULL(NRCTE.[Budget_Amount_Net_Revenues],0.000000) AS [Budget_Amount_Net_Revenues]
					,ISNULL(NRCTE.QTD_Net_Revenues,0.000000) AS QTD_Net_Revenues
					,ISNULL(NRCTE.Budget_QTD_Net_Revenues,0.000000) AS Budget_QTD_Net_Revenues
					,ISNULL(NRCTE.Forecast_QTD_Net_Revenues_Q1,0.000000) AS Forecast_QTD_Net_Revenues_Q1
					,ISNULL(NRCTE.Forecast_QTD_Net_Revenues_Q2,0.000000) AS Forecast_QTD_Net_Revenues_Q2
					,ISNULL(NRCTE.Forecast_QTD_Net_Revenues_Q3,0.000000) AS Forecast_QTD_Net_Revenues_Q3
					,ISNULL(NRCTE.LY_YTD_Net_Revenues,0.000000) AS LY_YTD_Net_Revenues
					,ISNULL(NRCTE.LY_Budget_YTD_Net_Revenues,0.000000) AS LY_Budget_YTD_Net_Revenues
					,ISNULL(NRCTE.LY_QTD_Net_Revenues,0.000000) AS LY_QTD_Net_Revenues
					,ISNULL(NRCTE.LY_Budget_QTD_Net_Revenues,0.000000) AS LY_Budget_QTD_Net_Revenues
					,ISNULL(DLCTE.[Current_Direct_Labor],0.000000) AS [Current_Direct_Labor]
					,ISNULL(DLCTE.[LY_Current_Direct_Labor],0.000000) AS [LY_Current_Direct_Labor]
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
					,ISNULL(DLCTE.QTD_Direct_Labor,0.000000) AS QTD_Direct_Labor
					,ISNULL(DLCTE.Budget_QTD_Direct_Labor,0.000000) AS Budget_QTD_Direct_Labor
					,ISNULL(DLCTE.Forecast_QTD_Direct_Labor_Q1,0.000000) AS Forecast_QTD_Direct_Labor_Q1
					,ISNULL(DLCTE.Forecast_QTD_Direct_Labor_Q2,0.000000) AS Forecast_QTD_Direct_Labor_Q2
					,ISNULL(DLCTE.Forecast_QTD_Direct_Labor_Q3,0.000000) AS Forecast_QTD_Direct_Labor_Q3
					,ISNULL(DLCTE.LY_YTD_Direct_Labor,0.000000) AS LY_YTD_Direct_Labor
					,ISNULL(DLCTE.LY_Budget_YTD_Direct_Labor,0.000000) AS LY_Budget_YTD_Direct_Labor
					,ISNULL(DLCTE.LY_QTD_Direct_Labor,0.000000) AS LY_QTD_Direct_Labor
					,ISNULL(DLCTE.LY_Budget_QTD_Direct_Labor,0.000000) AS LY_Budget_QTD_Direct_Labor
					,ISNULL(FBCTE.Current_FringeBenefits,0.000000) AS Current_FringeBenefits
					,ISNULL(FBCTE.LY_Current_FringeBenefits,0.000000) AS LY_Current_FringeBenefits
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
					,ISNULL(FBCTE.QTD_FringeBenefits,0.000000) AS QTD_FringeBenefits
					,ISNULL(FBCTE.Budget_QTD_FringeBenefits,0.000000) AS Budget_QTD_FringeBenefits
					,ISNULL(FBCTE.Forecast_QTD_FringeBenefits_Q1,0.000000) AS Forecast_QTD_FringeBenefits_Q1
					,ISNULL(FBCTE.Forecast_QTD_FringeBenefits_Q2,0.000000) AS Forecast_QTD_FringeBenefits_Q2
					,ISNULL(FBCTE.Forecast_QTD_FringeBenefits_Q3,0.000000) AS Forecast_QTD_FringeBenefits_Q3
					,ISNULL(FBCTE.LY_YTD_FringeBenefits,0.000000) AS LY_YTD_FringeBenefits
					,ISNULL(FBCTE.LY_Budget_YTD_FringeBenefits,0.000000) AS LY_Budget_YTD_FringeBenefits
					,ISNULL(FBCTE.LY_QTD_FringeBenefits,0.000000) AS LY_QTD_FringeBenefits
					,ISNULL(FBCTE.LY_Budget_QTD_FringeBenefits,0.000000) AS LY_Budget_QTD_FringeBenefits
					,ISNULL(SACTE.Current_Salaries,0.000000) AS Current_Salaries
					,ISNULL(SACTE.LY_Current_Salaries,0.000000) AS LY_Current_Salaries
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
					,ISNULL(SACTE.QTD_Salaries,0.000000) AS QTD_Salaries
					,ISNULL(SACTE.Budget_QTD_Salaries,0.000000) AS Budget_QTD_Salaries
					,ISNULL(SACTE.Forecast_QTD_Salaries_Q1,0.000000) AS Forecast_QTD_Salaries_Q1
					,ISNULL(SACTE.Forecast_QTD_Salaries_Q2,0.000000) AS Forecast_QTD_Salaries_Q2
					,ISNULL(SACTE.Forecast_QTD_Salaries_Q3,0.000000) AS Forecast_QTD_Salaries_Q3
					,ISNULL(SACTE.LY_YTD_Salaries,0.000000) AS LY_YTD_Salaries
					,ISNULL(SACTE.LY_Budget_YTD_Salaries,0.000000) AS LY_Budget_YTD_Salaries
					,ISNULL(SACTE.LY_QTD_Salaries,0.000000) AS LY_QTD_Salaries
					,ISNULL(SACTE.LY_Budget_QTD_Salaries,0.000000) AS LY_Budget_QTD_Salaries
					,ISNULL(EBGECTE.Current_EBGE,0.000000) AS Current_EBGE
					,ISNULL(EBGECTE.LY_Current_EBGE,0.000000) AS LY_Current_EBGE
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
					,ISNULL(EBGECTE.QTD_EBGE,0.000000) AS QTD_EBGE
					,ISNULL(EBGECTE.Budget_QTD_EBGE,0.000000) AS Budget_QTD_EBGE
					,ISNULL(EBGECTE.Forecast_QTD_EBGE_Q1,0.000000) AS Forecast_QTD_EBGE_Q1
					,ISNULL(EBGECTE.Forecast_QTD_EBGE_Q2,0.000000) AS Forecast_QTD_EBGE_Q2
					,ISNULL(EBGECTE.Forecast_QTD_EBGE_Q3,0.000000) AS Forecast_QTD_EBGE_Q3
					,ISNULL(EBGECTE.LY_YTD_EBGE,0.000000) AS LY_YTD_EBGE
					,ISNULL(EBGECTE.LY_Budget_YTD_EBGE,0.000000) AS LY_Budget_YTD_EBGE
					,ISNULL(EBGECTE.LY_QTD_EBGE,0.000000) AS LY_QTD_EBGE
					,ISNULL(EBGECTE.LY_Budget_QTD_EBGE,0.000000) AS LY_Budget_QTD_EBGE
					,ISNULL(EBRECTE.Current_EBRE,0.000000) AS Current_EBRE
					,ISNULL(EBRECTE.LY_Current_EBRE,0.000000) AS LY_Current_EBRE
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
					,ISNULL(EBRECTE.QTD_EBRE,0.000000) AS QTD_EBRE
					,ISNULL(EBRECTE.Budget_QTD_EBRE,0.000000) AS Budget_QTD_EBRE
					,ISNULL(EBRECTE.Forecast_QTD_EBRE_Q1,0.000000) AS Forecast_QTD_EBRE_Q1
					,ISNULL(EBRECTE.Forecast_QTD_EBRE_Q2,0.000000) AS Forecast_QTD_EBRE_Q2
					,ISNULL(EBRECTE.Forecast_QTD_EBRE_Q3,0.000000) AS Forecast_QTD_EBRE_Q3
					,ISNULL(EBRECTE.LY_YTD_EBRE,0.000000) AS LY_YTD_EBRE
					,ISNULL(EBRECTE.LY_Budget_YTD_EBRE,0.000000) AS LY_Budget_YTD_EBRE
					,ISNULL(EBRECTE.LY_QTD_EBRE,0.000000) AS LY_QTD_EBRE
					,ISNULL(EBRECTE.LY_Budget_QTD_EBRE,0.000000) AS LY_Budget_QTD_EBRE
					,ISNULL(EBITDACTE.Current_EBITDA,0.000000) AS Current_EBITDA
					,ISNULL(EBITDACTE.LY_Current_EBITDA,0.000000) AS LY_Current_EBITDA
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
					,ISNULL(EBITDACTE.QTD_EBITDA,0.000000) AS QTD_EBITDA
					,ISNULL(EBITDACTE.Budget_QTD_EBITDA,0.000000) AS Budget_QTD_EBITDA
					,ISNULL(EBITDACTE.Forecast_QTD_EBITDA_Q1,0.000000) AS Forecast_QTD_EBITDA_Q1
					,ISNULL(EBITDACTE.Forecast_QTD_EBITDA_Q2,0.000000) AS Forecast_QTD_EBITDA_Q2
					,ISNULL(EBITDACTE.Forecast_QTD_EBITDA_Q3,0.000000) AS Forecast_QTD_EBITDA_Q3
					,ISNULL(EBITDACTE.LY_YTD_EBITDA,0.000000) AS LY_YTD_EBITDA
					,ISNULL(EBITDACTE.LY_Budget_YTD_EBITDA,0.000000) AS LY_Budget_YTD_EBITDA
					,ISNULL(EBITDACTE.LY_QTD_EBITDA,0.000000) AS LY_QTD_EBITDA
					,ISNULL(EBITDACTE.LY_Budget_QTD_EBITDA,0.000000) AS LY_Budget_QTD_EBITDA

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
						,[LY QTD Budget Amount] as [LY_Budget_QTD_Net_Revenues]
						,[QTD Forecast 1 Amount] as [Forecast_QTD_Net_Revenues_Q1]
						,[QTD Forecast 2 Amount] as [Forecast_QTD_Net_Revenues_Q2]
						,[QTD Forecast 3 Amount] as [Forecast_QTD_Net_Revenues_Q3]
						,[Current Year Budget Amount]  as [Budget_Amount_Net_Revenues]
						FROM ProfitandLossCTE 
						WHERE [IsNetRevenues] = 'Y')NRCTE
							ON Template.OrganizationID = NRCTE.OrganizationID --on PCTE.GroupId in (106,95,108,96) = NRCTE.GroupId
						
				LEFT OUTER JOIN (
							Select  OrganizationID
						,[Current Month Amount] as [Current_Direct_Labor]
						,[LY Current Month Amount] as [LY_Current_Direct_Labor]
						,[Current Month Budget Amount] as   [Budget_Current_Direct_Labor]
						,[Current Month Forecast 1 Amount] as [Forecast_Current_Direct_Labor_Q1]
						,[Current Month Forecast 2 Amount] as [Forecast_Current_Direct_Labor_Q2]
						,[Current Month Forecast 3 Amount] as [Forecast_Current_Direct_Labor_Q3]
						,[YTD Amount] as [YTD_Direct_Labor]
						,[LY YTD Amount] as [LY_YTD_Direct_Labor]
						,[YTD Budget Amount] as [Budget_YTD_Direct_Labor]
						,[LY YTD Budget Amount] as [LY_Budget_YTD_Direct_Labor]
						,[YTD Forecast 1 Amount] as  [Forecast_YTD_Direct_Labor_Q1]
						,[YTD Forecast 2 Amount] as  [Forecast_YTD_Direct_Labor_Q2]
						,[YTD Forecast 3 Amount] as  [Forecast_YTD_Direct_Labor_Q3]
						,[QTD Amount] as [QTD_Direct_Labor]
						,[LY QTD Amount] as [LY_QTD_Direct_Labor]
						,[QTD Budget Amount] as [Budget_QTD_Direct_Labor]
						,[LY QTD Budget Amount] as [LY_Budget_QTD_Direct_Labor]
						,[QTD Forecast 1 Amount] as [Forecast_QTD_Direct_Labor_Q1]
						,[QTD Forecast 2 Amount] as [Forecast_QTD_Direct_Labor_Q2]
						,[QTD Forecast 3 Amount] as [Forecast_QTD_Direct_Labor_Q3]
						,[Current Year Budget Amount]  as [Budget_Amount_Direct_Labor]
						FROM ProfitandLossCTE 
						WHERE [IsDirectLabor] = 'Y'
								   )DLCTE on 
								   Template.OrganizationID = DLCTE.OrganizationID
								   AND Template.GroupId in (94,95,96,100,106,108)
								
				  LEFT OUTER JOIN (
							Select OrganizationID
					   ,[Current Month Amount] as [Current_FringeBenefits]
					   ,[LY Current Month Amount] as [LY_Current_FringeBenefits]
					   ,[Current Month Budget Amount] as   [Budget_Current_FringeBenefits]
					   ,[Current Month Forecast 1 Amount] as [Forecast_Current_FringeBenefits_Q1]
					   ,[Current Month Forecast 2 Amount] as [Forecast_Current_FringeBenefits_Q2]
					   ,[Current Month Forecast 3 Amount] as [Forecast_Current_FringeBenefits_Q3]
					   ,[YTD Amount] as [YTD_FringeBenefits]
					   ,[LY YTD Amount] as [LY_YTD_FringeBenefits]
					   ,[YTD Budget Amount] as [Budget_YTD_FringeBenefits]
					   ,[LY YTD Budget Amount] as [LY_Budget_YTD_FringeBenefits]
					   ,[YTD Forecast 1 Amount] as  [Forecast_YTD_FringeBenefits_Q1]
					   ,[YTD Forecast 2 Amount] as  [Forecast_YTD_FringeBenefits_Q2]
					   ,[YTD Forecast 3 Amount] as  [Forecast_YTD_FringeBenefits_Q3]
					   ,[QTD Amount] as [QTD_FringeBenefits]
					   ,[LY QTD Amount] as [LY_QTD_FringeBenefits]
					   ,[QTD Budget Amount] as [Budget_QTD_FringeBenefits]
					   ,[LY QTD Budget Amount] as [LY_Budget_QTD_FringeBenefits]
					   ,[QTD Forecast 1 Amount] as [Forecast_QTD_FringeBenefits_Q1]
					   ,[QTD Forecast 2 Amount] as [Forecast_QTD_FringeBenefits_Q2]
					   ,[QTD Forecast 3 Amount] as [Forecast_QTD_FringeBenefits_Q3]
					   ,[Current Year Budget Amount]  as [Budget_Amount_FringeBenefits]	
						FROM ProfitandLossCTE 
						WHERE [IsFringeBenefits] = 'Y'
								   )FBCTE on  Template.OrganizationID = FBCTE.OrganizationID
									AND Template.GroupId in (94,95,96,100,106,108)
			


						LEFT OUTER JOIN ( 
							Select  OrganizationID
					   ,SUM([Current Month Amount]) as [Current_Salaries]
					   ,SUM([LY Current Month Amount]) as [LY_Current_Salaries]
					   ,SUM([Current Month Budget Amount]) as   [Budget_Current_Salaries]
					   ,SUM([Current Month Forecast 1 Amount]) as [Forecast_Current_Salaries_Q1]
					   ,SUM([Current Month Forecast 2 Amount]) as [Forecast_Current_Salaries_Q2]
					   ,SUM([Current Month Forecast 3 Amount]) as [Forecast_Current_Salaries_Q3]
					   ,SUM([YTD Amount]) as [YTD_Salaries]
					   ,SUM([LY YTD Amount]) as [LY_YTD_Salaries]
					   ,SUM([YTD Budget Amount]) as [Budget_YTD_Salaries]
					   ,SUM([LY YTD Budget Amount]) as [LY_Budget_YTD_Salaries]
					   ,SUM([YTD Forecast 1 Amount]) as  [Forecast_YTD_Salaries_Q1]
					   ,SUM([YTD Forecast 2 Amount]) as  [Forecast_YTD_Salaries_Q2]
					   ,SUM([YTD Forecast 3 Amount]) as  [Forecast_YTD_Salaries_Q3]
					   ,SUM([QTD Amount]) as [QTD_Salaries]
					   ,SUM([LY QTD Amount]) as [LY_QTD_Salaries]
					   ,SUM([QTD Budget Amount]) as [Budget_QTD_Salaries]
					   ,SUM([LY QTD Budget Amount]) as [LY_Budget_QTD_Salaries]
					   ,SUM([QTD Forecast 1 Amount]) as [Forecast_QTD_Salaries_Q1]
					   ,SUM([QTD Forecast 2 Amount]) as [Forecast_QTD_Salaries_Q2]
					   ,SUM([QTD Forecast 3 Amount]) as [Forecast_QTD_Salaries_Q3]
					   ,SUM([Current Year Budget Amount])  as [Budget_Amount_Salaries]
						FROM ProfitandLossCTE 
						WHERE [IsDirectLabor] = 'Y' OR [IsManagementSalaries] = 'Y'
							 OR [IsMarketingSalaries] = 'Y' OR [IsTrainingSalaries] = 'Y'
							 GROUP BY OrganizationID
								   )SACTE on Template.OrganizationID = SACTE.OrganizationID
								   AND Template.GroupId in (94,95,96,100,106,108)
					   

						LEFT OUTER JOIN (
							Select  OrganizationID
					   ,[Current Month Amount] as [Current_EBGE]
					   ,[LY Current Month Amount] as [LY_Current_EBGE]
					   ,[Current Month Budget Amount] as   [Budget_Current_EBGE]
					   ,[Current Month Forecast 1 Amount] as [Forecast_Current_EBGE_Q1]
					   ,[Current Month Forecast 2 Amount] as [Forecast_Current_EBGE_Q2]
					   ,[Current Month Forecast 3 Amount] as [Forecast_Current_EBGE_Q3]
					   ,[YTD Amount] as [YTD_EBGE]
					   ,[LY YTD Amount] as [LY_YTD_EBGE]
					   ,[YTD Budget Amount] as [Budget_YTD_EBGE]
					   ,[LY YTD Budget Amount] as [LY_Budget_YTD_EBGE]
					   ,[YTD Forecast 1 Amount] as  [Forecast_YTD_EBGE_Q1]
					   ,[YTD Forecast 2 Amount] as  [Forecast_YTD_EBGE_Q2]
					   ,[YTD Forecast 3 Amount] as  [Forecast_YTD_EBGE_Q3]
					   ,[QTD Amount] as [QTD_EBGE]
					   ,[LY QTD Amount] as [LY_QTD_EBGE]
					   ,[QTD Budget Amount] as [Budget_QTD_EBGE]
					   ,[LY QTD Budget Amount] as [LY_Budget_QTD_EBGE]
					   ,[QTD Forecast 1 Amount] as [Forecast_QTD_EBGE_Q1]
					   ,[QTD Forecast 2 Amount] as [Forecast_QTD_EBGE_Q2]
					   ,[QTD Forecast 3 Amount] as [Forecast_QTD_EBGE_Q3]
					   ,[Current Year Budget Amount]  as [Budget_Amount_EBGE]
						FROM ProfitandLossCTE 
						WHERE [IsEBGE] = 'Y'
								   )EBGECTE on Template.OrganizationID = EBGECTE.OrganizationID
									AND Template.GroupId in (94,95,96,100,106,108)
						LEFT OUTER JOIN (
							Select  OrganizationID
					   ,[Current Month Amount] as [Current_EBRE]
					   ,[LY Current Month Amount] as [LY_Current_EBRE]
					   ,[Current Month Budget Amount] as   [Budget_Current_EBRE]
					   ,[Current Month Forecast 1 Amount] as [Forecast_Current_EBRE_Q1]
					   ,[Current Month Forecast 2 Amount] as [Forecast_Current_EBRE_Q2]
					   ,[Current Month Forecast 3 Amount] as [Forecast_Current_EBRE_Q3]
					   ,[YTD Amount] as [YTD_EBRE]
					   ,[LY YTD Amount] as [LY_YTD_EBRE]
					   ,[YTD Budget Amount] as [Budget_YTD_EBRE]
					   ,[LY YTD Budget Amount] as [LY_Budget_YTD_EBRE]
					   ,[YTD Forecast 1 Amount] as  [Forecast_YTD_EBRE_Q1]
					   ,[YTD Forecast 2 Amount] as  [Forecast_YTD_EBRE_Q2]
					   ,[YTD Forecast 3 Amount] as  [Forecast_YTD_EBRE_Q3]
					   ,[QTD Amount] as [QTD_EBRE]
					   ,[LY QTD Amount] as [LY_QTD_EBRE]
					   ,[QTD Budget Amount] as [Budget_QTD_EBRE]
					   ,[LY QTD Budget Amount] as [LY_Budget_QTD_EBRE]
					   ,[QTD Forecast 1 Amount] as [Forecast_QTD_EBRE_Q1]
					   ,[QTD Forecast 2 Amount] as [Forecast_QTD_EBRE_Q2]
					   ,[QTD Forecast 3 Amount] as [Forecast_QTD_EBRE_Q3]
					   ,[Current Year Budget Amount]  as [Budget_Amount_EBRE]
						FROM ProfitandLossCTE 
						WHERE [IsEBRE] = 'Y'
								   )EBRECTE on Template.OrganizationID = EBRECTE.OrganizationID
									AND Template.GroupId in (94,95,96,100,106,108)
						LEFT OUTER JOIN (
							Select  OrganizationID
					   ,[Current Month Amount] as [Current_EBITDA]
					   ,[LY Current Month Amount] as [LY_Current_EBITDA]
					   ,[Current Month Budget Amount] as   [Budget_Current_EBITDA]
					   ,[Current Month Forecast 1 Amount] as [Forecast_Current_EBITDA_Q1]
					   ,[Current Month Forecast 2 Amount] as [Forecast_Current_EBITDA_Q2]
					   ,[Current Month Forecast 3 Amount] as [Forecast_Current_EBITDA_Q3]
					   ,[YTD Amount] as [YTD_EBITDA]
					   ,[LY YTD Amount] as [LY_YTD_EBITDA]
					   ,[YTD Budget Amount] as [Budget_YTD_EBITDA]
					   ,[LY YTD Budget Amount] as [LY_Budget_YTD_EBITDA]
					   ,[YTD Forecast 1 Amount] as  [Forecast_YTD_EBITDA_Q1]
					   ,[YTD Forecast 2 Amount] as  [Forecast_YTD_EBITDA_Q2]
					   ,[YTD Forecast 3 Amount] as  [Forecast_YTD_EBITDA_Q3]
					   ,[QTD Amount] as [QTD_EBITDA]
					   ,[LY QTD Amount] as [LY_QTD_EBITDA]
					   ,[QTD Budget Amount] as [Budget_QTD_EBITDA]
					   ,[LY QTD Budget Amount] as [LY_Budget_QTD_EBITDA]
					   ,[QTD Forecast 1 Amount] as [Forecast_QTD_EBITDA_Q1]
					   ,[QTD Forecast 2 Amount] as [Forecast_QTD_EBITDA_Q2]
					   ,[QTD Forecast 3 Amount] as [Forecast_QTD_EBITDA_Q3]
					   ,[Current Year Budget Amount]  as [Budget_Amount_EBITDA]
						FROM ProfitandLossCTE 
						WHERE [IsEBITDA] = 'Y'
								   )EBITDACTE on Template.OrganizationID = EBITDACTE.OrganizationID
								   AND Template.GroupId in (94,95,96,100,106,108)
					LEFT OUTER JOIN (
										SELECT GROUPID
					,TemplateID
					,Orgskey
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
					Select FT.GroupID 
					  ,FT.TemplateID
					 ,LYPL.[OrgSkey]
					 ,CP.FiscalPeriodNumber
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
			INNER JOIN DimCalendarPeriod AS CP ON LYPL.PostPeriodSkey = CP.FiscalPeriodSkey
			WHERE  (CP.FiscalYear = cast (substring (cast (@pFiscalPeriod-100 as varchar(10)), 1, 4) as integer) )
					AND (FT.TemplateID = @pTemplate)
					AND LYPL.OrgSkey IN	( Select * from dbo.STRING_SPLIT(@pOrg, ','))

			GROUP BY  FT.GroupID 
				 ,FT.TemplateID
				 ,LYPL.[OrgSkey]
				 ,CP.FiscalPeriodNumber
		
		)TLYPL 
		GROUP BY GroupID
				  ,TemplateID
				  ,[OrgSkey]
		)GTLYPL ON Template.TemplateID = GTLYPL.TemplateID
														AND Template.GroupID = GTLYPL.GroupId
														AND Template.OrgSkey = GTLYPL.OrgSkey
					 Order by Template.OrganizationID,Template.SortOrder,  Template.GroupID,  Template.GroupDesc
			
					-- PCTE.OrganizationID, SortOrder,GroupId, GroupDesc
	
END





GO

