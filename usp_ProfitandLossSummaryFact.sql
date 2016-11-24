USE [BIDataWarehouse]
GO

/****** Object:  StoredProcedure [dbo].[usp_ProfitandLossSummaryFact]    Script Date: 24/11/2016 11:04:21 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO









CREATE Procedure [dbo].[usp_ProfitandLossSummaryFact] 
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
**/

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
SET @pCurrency = 'CONS';
SET @pGroup1Level = 'A'
SET @pGroup2Level = 'I';
SET @pGroup3Level = 'C';
**/

if @pSummaryDetail = 'S' 
BEGIN

		WITH ProfitandLossCTE (TemplateID, Group1Level,Group2Level,Group3Level,Group1LevelID, Group2LevelID, Group3LevelID
					,GroupID ,GroupDesc,[HeaderLine],[ShowDetail],[InsertSkipLineBefore],[SkipLine]
					,[IsMarkup] ,[IsNetRevenues],[IsDirectLabor],[IsFringeBenefitsPct],[IsFringeBenefits]
					,[IsManagementSalaries],[IsMarketingSalaries],[IsTrainingSalaries],[IsEBGEPct],[IsEBGE]
					,[IsEBREPct],[IsEBRE],[IsEBITDAPct],[IsEBITDA] ,[IsCalculatedUtilizationPct],SortOrder,FiscalPeriodNumber
					,[Current Month Amount],[Current Month Budget Amount],[YTD Amount]
					,[Current Month Forecast 1 Amount],[Current Month Forecast 2 Amount],[Current Month Forecast 3 Amount]
					,[YTD Budget Amount]
					,[Current Year Budget Amount]
					--,[QTD Forecast 1 Amount]
					,[YTD Forecast 1 Amount],[YTD Forecast 2 Amount],[YTD Forecast 3 Amount]
					,[LY Current Month Amount],[LY YTD Amount],[LY YTD Budget Amount] --added
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
					,SortOrder,FiscalPeriodNumber
					,ISNULL( Case @pCurrency  WHEN @ConsCurrency THEN SUM(PL.ConsCMAmt * FT.IncomeStatementActualSign) 
									   WHEN @FuncCurrency THEN SUM(PL.FuncCMAmt * FT.IncomeStatementActualSign)
									   Else 0.000000
					  END,0.000000) as [Current Month Amount]
					,ISNULL(Case @pCurrency  WHEN @ConsCurrency THEN SUM(PL.ConsCMBudgetAmt * FT.IncomeStatementBudgetSign)
									   WHEN @FuncCurrency THEN SUM(PL.FuncCMBudgetAmt * FT.IncomeStatementBudgetSign)
									   Else 0.000000
					  END,0.000000) as [Current Month Budget Amount]
					, ISNULL(Case @pCurrency  WHEN @ConsCurrency THEN SUM(PL.ConsYTDAmt * FT.IncomeStatementActualSign)
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
					,ISNULL(SUM((Case @pCurrency  WHEN @ConsCurrency THEN PL.ConsCMFC3Amt 
									   WHEN @FuncCurrency THEN PL.FuncCMFC3Amt 
									   Else 0.000000
									   END) * 
							Case When CP.[FiscalPeriodNumber] <= 8 Then [IncomeStatementActualSign]  
										Else [IncomeStatementBudgetSign]
										END 
										),0.000000) as [Current Month Forecast 3 Amount]
					,ISNULL( Case @pCurrency  WHEN @ConsCurrency THEN SUM(PL.ConsYTDBudgetAmt * FT.IncomeStatementBudgetSign)
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
							END,0.000000) AS [YTD Forecast 3 Amount]
--added
					,ISNULL(Case @pCurrency WHEN @ConsCurrency THEN SUM(PL.ConsLYCMAmt * FT.IncomeStatementActualSign)
					  WHEN @FuncCurrency THEN SUM(PL.FuncLYCMAmt * FT.IncomeStatementActualSign)
							END,0.000000) AS [LY Current Month Amount]
					,ISNULL(Case @pCurrency  WHEN @ConsCurrency THEN SUM(PL.ConsLYYTDAmt * FT.IncomeStatementActualSign)
										WHEN @FuncCurrency THEN SUM(PL.FuncLYYTDAmt * FT.IncomeStatementActualSign)
										Else 0.000000
						END,0.000000) as [LY YTD Amount]
					,ISNULL(Case @pCurrency  WHEN @ConsCurrency THEN SUM(PL.ConsLYYTDBudgetAmt * FT.IncomeStatementBudgetSign)
									   WHEN @FuncCurrency THEN SUM(PL.FuncLYYTDBudgetAmt * FT.IncomeStatementBudgetSign)
									   END,0.000000) as [LY YTD Budget Amount]
-----		
		FROM        FactProfitAndLossSummary   AS PL 
				LEFT OUTER JOIN MapFinancialTemplate as FT   ON FT.AccountSkey = PL.AccountSkey 
				INNER JOIN ( SELECT OrgSkey,Case @pLanguage When @ENLanguage THEN	Case @pGroup1Level	
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
						FROM [dbo].[DimOrganization]
					
					)DO ON PL.OrgSkey = DO.OrgSkey
				INNER JOIN DimCalendarPeriod AS CP ON PL.PostPeriodSkey = CP.FiscalPeriodSkey
		WHERE        (PL.PostPeriodSkey = @pFiscalPeriod) 
					AND (FT.TemplateID = @pTemplate)
					AND PL.OrgSkey IN	( Select * from dbo.STRING_SPLIT(@pOrg, ','))
					--AND HeaderLine = 'Y'
	
		GROUP BY	 FT.TemplateID
					 ,Group1Level
					,Group2Level
					 ,Group3Level
					 ,Group1LevelID
					 ,Group2LevelID
					 ,Group3LevelID 
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
			
		)



		
				SELECT  Template.*
				-- ,PCTE.*
				--, Group1Level,Group2Level,Group3Level,
					,ISNULL([Current Month Amount],0.000000) AS [Current Month Amount]
						,ISNULL([Current Month Budget Amount],0.000000) AS [Current Month Budget Amount]
						,ISNULL([YTD Amount],0.000000) AS [YTD Amount]
						,ISNULL([Current Month Forecast 1 Amount],0.000000) AS [Current Month Forecast 1 Amount]
						,ISNULL([Current Month Forecast 2 Amount],0.000000) AS [Current Month Forecast 2 Amount]
						,ISNULL([Current Month Forecast 3 Amount],0.000000) AS [Current Month Forecast 3 Amount]
						,ISNULL([YTD Budget Amount], 0.000000) AS [YTD Budget Amount]
						,ISNULL([Current Year Budget Amount], 0.000000) AS [Current Year Budget Amount]
						,ISNULL([YTD Forecast 1 Amount],0.000000) AS [YTD Forecast 1 Amount]
						,ISNULL([YTD Forecast 2 Amount],0.000000) AS [YTD Forecast 2 Amount]
						,ISNULL([YTD Forecast 3 Amount],0.000000) AS [YTD Forecast 3 Amount]
						,ISNULL([LY Current Month Amount],0.000000) AS [LY Current Month Amount]
						,ISNULL([LY YTD Amount],0.000000) AS [LY YTD Amount]
						,ISNULL([LY YTD Budget Amount],0.000000) AS [LY YTD Budget Amount]
						,ISNULL(NRCTE.[Current_Net_Revenues],0.000000) AS [Current_Net_Revenues]
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
						,ISNULL(NRCTE.LY_Current_Net_Revenues,0.000000) AS LY_Current_Net_Revenues
						,ISNULL(NRCTE.LY_YTD_Net_Revenues,0.000000) AS LY_YTD_Net_Revenues
						,ISNULL(NRCTE.LY_Budget_YTD_Net_Revenues,0.000000) AS LY_Budget_YTD_Net_Revenues
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
						,ISNULL(DLCTE.LY_Current_Direct_Labor,0.000000) AS LY_Current_Direct_Labor
						,ISNULL(DLCTE.LY_YTD_Direct_Labor,0.000000) AS LY_YTD_Direct_Labor
						,ISNULL(DLCTE.LY_Budget_YTD_Direct_Labor,0.000000) AS LY_Budget_YTD_Direct_Labor
						,ISNULL(FBCTE.Current_FringeBenefits,0.000000) AS Current_FringeBenefits
						,ISNULL(FBCTE.Budget_Current_FringeBenefits,0.0000000) AS Budget_Current_FringeBenefits
						,ISNULL(FBCTE.Forecast_Current_FringeBenefits_Q1,0.000000) AS Forecast_Current_FringeBenefits_Q1
						,ISNULL(FBCTE.Forecast_Current_FringeBenefits_Q2,0.000000) AS Forecast_Current_FringeBenefits_Q2
						,ISNULL(FBCTE.Forecast_Current_FringeBenefits_Q3,0.000000) AS Forecast_Current_FringeBenefits_Q3
						,ISNULL(FBCTE.YTD_FringeBenefits,0.000000) AS YTD_FringeBenefits
						,ISNULL(FBCTE.Budget_YTD_FringeBenefits,0.000000) AS Budget_YTD_FringeBenefits
						,ISNULL(FBCTE.Forecast_YTD_FringeBenefits_Q1,0.000000) AS Forecast_YTD_FringeBenefits_Q1
						,ISNULL(FBCTE.Forecast_YTD_FringeBenefits_Q2,0.000000) AS Forecast_YTD_FringeBenefits_Q2
						,ISNULL(FBCTE.Forecast_YTD_FringeBenefits_Q3,0.000000) AS Forecast_YTD_FringeBenefits_Q3
						,ISNULL(FBCTE.Budget_Amount_FringeBenefits,0.000000) AS Budget_Amount_FringeBenefits
						,ISNULL(FBCTE.LY_Current_FringeBenefits,0.000000) AS LY_Current_FringeBenefits
						,ISNULL(FBCTE.LY_YTD_FringeBenefits,0.000000) AS LY_YTD_FringeBenefits
						,ISNULL(FBCTE.LY_Budget_YTD_FringeBenefits,0.000000) AS LY_Budget_YTD_FringeBenefits
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
						,ISNULL(SACTE.LY_Current_Salaries,0.000000) AS LY_Current_Salaries
						,ISNULL(SACTE.LY_YTD_Salaries,0.000000) AS LY_YTD_Salaries
						,ISNULL(SACTE.LY_Budget_YTD_Salaries,0.000000) AS LY_Budget_YTD_Salaries
						,ISNULL(EBGECTE.Current_EBGE,0.000000) AS Current_EBGE
						,ISNULL(EBGECTE.Budget_Current_EBGE,0.000000) AS Budget_Current_EBGE
						,ISNULL(EBGECTE.Forecast_Current_EBGE_Q1,0.000000) AS Forecast_Current_EBGE_Q1
						,ISNULL(EBGECTE.Forecast_Current_EBGE_Q2,0.000000) AS Forecast_Current_EBGE_Q2
						,ISNULL(EBGECTE.Forecast_Current_EBGE_Q3,0.000000) AS Forecast_Current_EBGE_Q3
						,ISNULL(EBGECTE.YTD_EBGE,0.000000) AS YTD_EBGE
						,ISNULL(EBGECTE.Budget_YTD_EBGE,0.000000) AS Budget_YTD_EBGE
						,ISNULL(EBGECTE.Forecast_YTD_EBGE_Q1,0.000000) As Forecast_YTD_EBGE_Q1
						,ISNULL(EBGECTE.Forecast_YTD_EBGE_Q2,0.000000) AS Forecast_YTD_EBGE_Q2
						,ISNULL(EBGECTE.Forecast_YTD_EBGE_Q3,0.000000) AS Forecast_YTD_EBGE_Q3
						,ISNULL(EBGECTE.Budget_Amount_EBGE,0.0000000) AS Budget_Amount_EBGE
						,ISNULL(EBGECTE.LY_Current_EBGE,0.000000) AS LY_Current_EBGE
						,ISNULL(EBGECTE.LY_YTD_EBGE,0.000000) AS LY_YTD_EBGE
						,ISNULL(EBGECTE.LY_Budget_YTD_EBGE,0.000000) AS LY_Budget_YTD_EBGE
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
						,ISNULL(EBRECTE.LY_Current_EBRE,0.000000) AS LY_Current_EBRE
						,ISNULL(EBRECTE.LY_YTD_EBRE,0.000000) AS LY_YTD_EBRE
						,ISNULL(EBRECTE.LY_Budget_YTD_EBRE,0.000000) AS LY_Budget_YTD_EBRE
						,ISNULL(EBITDACTE.Current_EBITDA, 0.000000) AS Current_EBITDA
						,ISNULL(EBITDACTE.Budget_Current_EBITDA,0.000000) AS Budget_Current_EBITDA
						,ISNULL(EBITDACTE.Forecast_Current_EBITDA_Q1,0.000000) AS Forecast_Current_EBITDA_Q1
						,ISNULL(EBITDACTE.Forecast_Current_EBITDA_Q2,0.000000) AS Forecast_Current_EBITDA_Q2
						,ISNULL( EBITDACTE.Forecast_Current_EBITDA_Q3,0.000000) AS Forecast_Current_EBITDA_Q3
						,ISNULL(EBITDACTE.YTD_EBITDA,0.000000) AS YTD_EBITDA
						,ISNULL(EBITDACTE.Budget_YTD_EBITDA,0.000000) AS Budget_YTD_EBITDA
						,ISNULL(EBITDACTE.Forecast_YTD_EBITDA_Q1,0.000000) AS Forecast_YTD_EBITDA_Q1
						,ISNULL(EBITDACTE.Forecast_YTD_EBITDA_Q2,0.000000) AS Forecast_YTD_EBITDA_Q2
						,ISNULL(EBITDACTE.Forecast_YTD_EBITDA_Q3,0.000000) AS Forecast_YTD_EBITDA_Q3
						,ISNULL(EBITDACTE.Budget_Amount_EBITDA,0.000000) AS Budget_Amount_EBITDA
						,ISNULL(EBITDACTE.LY_Current_EBITDA,0.000000) AS LY_Current_EBITDA
						,ISNULL(EBITDACTE.LY_YTD_EBITDA,0.000000) AS LY_YTD_EBITDA
						,ISNULL(EBITDACTE.LY_Budget_YTD_EBITDA,0.000000) AS LY_Budget_YTD_EBITDA
				FROM 
			  (		SELECT Group1Level,Group2Level,Group3Level, Group1LevelID,Group2LevelID,Group3LevelID
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
				

				--ProfitandLossCTE as PCTE  
			 LEFT OUTER JOIN(
					Select  GroupID,Group1Level,Group2Level,Group3Level
						   ,[Current Month Amount] as [Current_Net_Revenues]
						   ,[Current Month Budget Amount] as   [Budget_Current_Net_Revenues]
						   ,[Current Month Forecast 1 Amount] as [Forecast_Current_Net_Revenues_Q1]
						   ,[Current Month Forecast 2 Amount] as [Forecast_Current_Net_Revenues_Q2]
						   ,[Current Month Forecast 3 Amount] as [Forecast_Current_Net_Revenues_Q3]
						   ,[YTD Amount] as [YTD_Net_Revenues]
						   ,[YTD Budget Amount] as [Budget_YTD_Net_Revenues]
						   ,[YTD Forecast 1 Amount] as  [Forecast_YTD_Net_Revenues_Q1]
						   ,[YTD Forecast 2 Amount] as  [Forecast_YTD_Net_Revenues_Q2]
						   ,[YTD Forecast 3 Amount] as  [Forecast_YTD_Net_Revenues_Q3]
						   ,[Current Year Budget Amount]  as [Budget_Amount_Net_Revenues]
						   ,[LY Current Month Amount] as [LY_Current_Net_Revenues] --added
						   ,[LY YTD Amount] as [LY_YTD_Net_Revenues] --added
						   ,[LY YTD Budget Amount] as [LY_Budget_YTD_Net_Revenues] --added
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
						   ,[LY Current Month Amount] as [LY_Current_Direct_Labor] --added
						   ,[LY YTD Amount] as [LY_YTD_Direct_Labor] --added
						   ,[LY YTD Budget Amount] as [LY_Budget_YTD_Direct_Labor] --added
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
						   ,[LY Current Month Amount] as [LY_Current_FringeBenefits] --added
						   ,[LY YTD Amount] as [LY_YTD_FringeBenefits] --added
						   ,[LY YTD Budget Amount] as [LY_Budget_YTD_FringeBenefits] --added						   
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
						   ,SUM([LY Current Month Amount]) as [LY_Current_Salaries] --added
						   ,SUM([LY YTD Amount]) as [LY_YTD_Salaries] --added
						   ,SUM([LY YTD Budget Amount]) as [LY_Budget_YTD_Salaries] --added
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
						   ,[LY Current Month Amount] as [LY_Current_EBGE] --added
						   ,[LY YTD Amount] as [LY_YTD_EBGE] --added
						   ,[LY YTD Budget Amount] as [LY_Budget_YTD_EBGE] --added
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
						   ,[LY Current Month Amount] as [LY_Current_EBRE] --added
						   ,[LY YTD Amount] as [LY_YTD_EBRE] --added
						   ,[LY YTD Budget Amount] as [LY_Budget_YTD_EBRE] --added
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
						   ,[LY Current Month Amount] as [LY_Current_EBITDA] --added
						   ,[LY YTD Amount] as [LY_YTD_EBITDA] --added
						   ,[LY YTD Budget Amount] as [LY_Budget_YTD_EBITDA] --added
					FROM ProfitandLossCTE 
					WHERE [IsEBITDA] = 'Y'
							   )EBITDACTE on Template.GroupId  in (94,95,96,100,106,108) --EBITDACTE.GroupId
													AND Template.Group1level = EBITDACTE.Group1level
													AND Template.Group2level = EBITDACTE.Group2level
													AND Template.Group3level = EBITDACTE.Group3level
						              
					ORDER BY  Template.Group1Level,Template.Group2Level,Template.Group3Level,Template.SortOrder,  Template.GroupID,  Template.GroupDesc
			
	
END




GO

