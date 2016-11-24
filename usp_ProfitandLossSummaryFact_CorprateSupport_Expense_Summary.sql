USE [BIDataWarehouse]
GO

/****** Object:  StoredProcedure [dbo].[usp_ProfitandLossSummaryFact_CorprateSupport_Expense_Summary]    Script Date: 24/11/2016 11:08:21 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




/*Leo Yang July 21
--Add sum of 12 Month Actual Amont and 12 Month Budget Amont
--Add NYBudget AKA Next Year Budget
--Add PYActual
*/

CREATE Procedure [dbo].[usp_ProfitandLossSummaryFact_CorprateSupport_Expense_Summary] 
	@pCurrency varchar(5),
	@pFiscalPeriod int,
	@pTemplate int,
	@pLanguage int
	,@pOrg varchar(max),
	@pGroup1Level varchar(20),
	@pGroup2Level varchar(20),
	@pGroup3Level varchar(20)
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
--Add in AccountID and AccountDesc From [dbo].[DimAccount]
WITH ProfitandLossCTE ( 
TemplateID, Group1Level,Group2Level,Group3Level,Group1LevelID,Group2LevelID,Group3LevelID, --Add on July 29
GroupID ,GroupDesc,[HeaderLine],[ShowDetail],[InsertSkipLineBefore],[SkipLine]
			,[IsMarkup] ,[IsNetRevenues],[IsDirectLabor],[IsFringeBenefitsPct],[IsFringeBenefits]
			,[IsManagementSalaries],[IsMarketingSalaries],[IsTrainingSalaries],[IsEBGEPct],[IsEBGE]
			,[IsEBREPct],[IsEBRE],[IsEBITDAPct],[IsEBITDA] ,[IsCalculatedUtilizationPct]
			,AccountID, AccountDesc --Add July 21
			,SortOrder,FiscalPeriodNumber
			,[Current Month Amount],[Current Month Budget Amount],[YTD Amount]
			,[Current Month Forecast 1 Amount],[Current Month Forecast 2 Amount],[Current Month Forecast 3 Amount]
			,[YTD Budget Amount]
			,[Current Year Budget Amount]
			--,[QTD Forecast 1 Amount]
			,[YTD Forecast 1 Amount],[YTD Forecast 2 Amount],[YTD Forecast 3 Amount]
			,[LY Current Month Amount], [QTD Amount], [QTD Budget Amount]
			,[QTD Forecast 1 Amount],[QTD Forecast 2 Amount],[QTD Forecast 3 Amount]
			,[Period 1 Actual Amount],[Period 2 Actual Amount],[Period 3 Actual Amount],[Period 4 Actual Amount]
			,[Period 5 Actual Amount],[Period 6 Actual Amount],[Period 7 Actual Amount],[Period 8 Actual Amount]
			,[Period 9 Actual Amount],[Period 10 Actual Amount],[Period 11 Actual Amount],[Period 12 Actual Amount]
			,TOT_Actual--July 21
			,[Period 1 Budget Amount],[Period 2 Budget Amount],[Period 3 Budget Amount],[Period 4 Budget Amount]
			,[Period 5 Budget Amount],[Period 6 Budget Amount],[Period 7 Budget Amount],[Period 8 Budget Amount]
			,[Period 9 Budget Amount],[Period 10 Budget Amount],[Period 11 Budget Amount],[Period 12 Budget Amount]
			,TOT_Budget--July 21
			,[Period 1 Forecast 1 Amount],[Period 2 Forecast 1 Amount],[Period 3 Forecast 1 Amount],[Period 4 Forecast 1 Amount]
			,[Period 5 Forecast 1 Amount],[Period 6 Forecast 1 Amount],[Period 7 Forecast 1 Amount],[Period 8 Forecast 1 Amount]
			,[Period 9 Forecast 1 Amount],[Period 10 Forecast 1 Amount],[Period 11 Forecast 1 Amount],[Period 12 Forecast 1 Amount]
			,[Period 1 Forecast 2 Amount],[Period 2 Forecast 2 Amount],[Period 3 Forecast 2 Amount],[Period 4 Forecast 2 Amount]
			,[Period 5 Forecast 2 Amount],[Period 6 Forecast 2 Amount],[Period 7 Forecast 2 Amount],[Period 8 Forecast 2 Amount]
			,[Period 9 Forecast 2 Amount],[Period 10 Forecast 2 Amount],[Period 11 Forecast 2 Amount],[Period 12 Forecast 2 Amount]
			,[Period 1 Forecast 3 Amount],[Period 2 Forecast 3 Amount],[Period 3 Forecast 3 Amount],[Period 4 Forecast 3 Amount]
			,[Period 5 Forecast 3 Amount],[Period 6 Forecast 3 Amount],[Period 7 Forecast 3 Amount],[Period 8 Forecast 3 Amount]
			,[Period 9 Forecast 3 Amount],[Period 10 Forecast 3 Amount],[Period 11 Forecast 3 Amount],[Period 12 Forecast 3 Amount]	
			, NYBudget -- Add July 21	
			, PYActual -- Add July 21	
			)
AS
(
    SELECT    FT.TemplateID 
/*Group level Begin*/	
			,Group1Level
			,Group2Level
			,Group3Level
			,Group1LevelID
			,Group2LevelID
			,Group3LevelID				 	
/*Group level end*/				     
	       
		    , FT.GroupID 
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
--Mark
			,DA.AccountID
			, Case @pLanguage when @ENLanguage THEN DA.[AccountNameEN]
							  WHEN @FRLanguage THEN DA.[AccountNameFR]
							  ELSE 'Unknown'
					END AS AccountDesc		
--Mark
			,SortOrder,FiscalPeriodNumber
			
			, Case @pCurrency  WHEN @ConsCurrency THEN SUM(PL.ConsCMAmt * FT.IncomeStatementActualSign) 
							   WHEN @FuncCurrency THEN SUM(PL.FuncCMAmt * FT.IncomeStatementActualSign)
							   Else 0
			  END as [Current Month Amount]
			, Case @pCurrency  WHEN @ConsCurrency THEN SUM(PL.ConsCMBudgetAmt * FT.IncomeStatementBudgetSign)
							   WHEN @FuncCurrency THEN SUM(PL.FuncCMBudgetAmt * FT.IncomeStatementBudgetSign)
							   Else 0
			  END as [Current Month Budget Amount]
			,  Case @pCurrency  WHEN @ConsCurrency THEN SUM(PL.ConsYTDAmt * FT.IncomeStatementActualSign)
								WHEN @FuncCurrency THEN SUM(PL.FuncYTDAmt * FT.IncomeStatementActualSign)
								Else 0
				END as [YTD Amount]
			--,SUM((Case @pCurrency  WHEN @ConsCurrency THEN PL.ConsCMFC1Amt 
			--				   WHEN @FuncCurrency THEN PL.FuncCMFC1Amt 
			--				   Else 0
			--				   END) * 
			--		Case When CP.[FiscalPeriodNumber] <= 2 Then [IncomeStatementActualSign]  
			--					Else [IncomeStatementBudgetSign]
			--					END 
			--					) as [Current Month Forecast 1 Amount]
			,CASE @pCurrency  WHEN  @ConsCurrency THEN 
	(SUM(PL.ConsP1FC1Amt * FT.IncomeStatementActualSign +
	PL.ConsP2FC1Amt * FT.IncomeStatementActualSign +
	PL.ConsP3FC1Amt * FT.IncomeStatementBudgetSign +
	PL.ConsP4FC1Amt * FT.IncomeStatementBudgetSign +
	PL.ConsP5FC1Amt * FT.IncomeStatementBudgetSign +
	PL.ConsP6FC1Amt * FT.IncomeStatementBudgetSign +
	PL.ConsP7FC1Amt * FT.IncomeStatementBudgetSign +
	PL.ConsP8FC1Amt * FT.IncomeStatementBudgetSign +
	PL.ConsP9FC1Amt * FT.IncomeStatementBudgetSign +
	PL.ConsP10FC1Amt * FT.IncomeStatementBudgetSign+
	PL.ConsP11FC1Amt * FT.IncomeStatementBudgetSign+
	PL.ConsP12FC1Amt * FT.IncomeStatementBudgetSign))
                  WHEN @FuncCurrency THEN
	(SUM(PL.FuncP1FC1Amt * FT.IncomeStatementActualSign +
	PL.FuncP2FC1Amt * FT.IncomeStatementActualSign  +
	PL.FuncP3FC1Amt * FT.IncomeStatementBudgetSign  +
	PL.FuncP4FC1Amt * FT.IncomeStatementBudgetSign  +
	PL.FuncP5FC1Amt * FT.IncomeStatementBudgetSign  +
	PL.FuncP6FC1Amt * FT.IncomeStatementBudgetSign  +
	PL.FuncP7FC1Amt * FT.IncomeStatementBudgetSign  +
	PL.FuncP8FC1Amt * FT.IncomeStatementBudgetSign  +
	PL.FuncP9FC1Amt * FT.IncomeStatementBudgetSign  +
	PL.FuncP10FC1Amt * FT.IncomeStatementBudgetSign+
	PL.FuncP11FC1Amt * FT.IncomeStatementBudgetSign+
	PL.FuncP12FC1Amt * FT.IncomeStatementBudgetSign))
	Else 0.000000
END AS [Current Month Forecast 1 Amount]
			,SUM((Case @pCurrency  WHEN @ConsCurrency THEN PL.ConsCMFC2Amt 
							   WHEN @FuncCurrency THEN PL.FuncCMFC2Amt 
							   Else 0
							   END) * 
					Case When CP.[FiscalPeriodNumber] <= 5 Then [IncomeStatementActualSign]  
								Else [IncomeStatementBudgetSign]
								END 
								) as [Current Month Forecast 2 Amount]
			,SUM((Case @pCurrency  WHEN @ConsCurrency THEN PL.ConsCMFC1Amt 
							   WHEN @FuncCurrency THEN PL.FuncCMFC1Amt 
							   Else 0
							   END) * 
					Case When CP.[FiscalPeriodNumber] <= 8 Then [IncomeStatementActualSign]  
								Else [IncomeStatementBudgetSign]
								END 
								) as [Current Month Forecast 3 Amount]
			, Case @pCurrency  WHEN @ConsCurrency THEN SUM(PL.ConsYTDBudgetAmt * FT.IncomeStatementBudgetSign)
							   WHEN @FuncCurrency THEN SUM(PL.FuncYTDBudgetAmt * FT.IncomeStatementBudgetSign)
							   END as [YTD Budget Amount]
			, Case @pCurrency  WHEN @ConsCurrency THEN SUM(PL.ConsCYBudgetAmt * FT.IncomeStatementBudgetSign) 
							   WHEN @FuncCurrency THEN SUM(PL.FuncCYBudgetAmt * FT.IncomeStatementBudgetSign)
							   END as [Current Year Budget Amount] --YTD
		

			, Case @pCurrency 
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
				ELSE 0
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
					ELSE 0
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
					  ELSE 0
				END AS [YTD Forecast 3 Amount]
		      ,Case @pCurrency WHEN @ConsCurrency THEN SUM(PL.ConsLYCMAmt * FT.IncomeStatementActualSign)
			  WHEN @FuncCurrency THEN SUM(PL.FuncLYCMAmt * FT.IncomeStatementActualSign)
					END AS [LY Current Month Amount]
		      ,Case @pCurrency WHEN @ConsCurrency THEN SUM(PL.ConsQTDAmt * FT.IncomeStatementActualSign)
			  WHEN @FuncCurrency THEN SUM(PL.FuncQTDAmt * FT.IncomeStatementActualSign)
					END AS [QTD Amount]
		      ,Case @pCurrency WHEN @ConsCurrency THEN SUM(PL.ConsQTDBudgetAmt * FT.IncomeStatementBudgetSign)
			  WHEN @FuncCurrency THEN SUM(PL.FuncQTDBudgetAmt * FT.IncomeStatementBudgetSign)
					END AS [QTD Budget Amount]
		      ,Case @pCurrency WHEN @ConsCurrency THEN SUM(PL.ConsQTDFC1Amt * FT.IncomeStatementActualSign)
			  WHEN @FuncCurrency THEN SUM(PL.FuncQTDFC1Amt * FT.IncomeStatementActualSign)
					END AS [QTD Forecast 1 Month Amount]
		      ,Case @pCurrency WHEN @ConsCurrency THEN SUM(PL.ConsQTDFC2Amt * FT.IncomeStatementActualSign)
			  WHEN @FuncCurrency THEN SUM(FuncQTDFC2Amt * FT.IncomeStatementActualSign)
					END AS [QTD Forecast 2 Month Amount]
		      ,Case @pCurrency WHEN @ConsCurrency THEN SUM(PL.ConsQTDFC3Amt * FT.IncomeStatementActualSign)
			  WHEN @FuncCurrency THEN SUM(FuncQTDFC3Amt * FT.IncomeStatementActualSign)
					END AS [QTD Forecast 3 Month Amount]



			/*Actual Begin*/																					
		      ,Case @pCurrency WHEN @ConsCurrency THEN
				 ( SUM(PL.ConsP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 1 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ))
			  WHEN @FuncCurrency THEN
					( SUM(PL.FuncP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 1 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ))
					END AS [Period 1 Actual Amount]
		      ,Case @pCurrency WHEN @ConsCurrency THEN
				 ( SUM(PL.ConsP2ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 2 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ))
			  WHEN @FuncCurrency THEN
					( SUM(PL.FuncP2ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 2 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ))
					END AS [Period 2 Actual Amount]
		      ,Case @pCurrency WHEN @ConsCurrency THEN
				 ( SUM(PL.ConsP3ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 3 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ))
			  WHEN @FuncCurrency THEN
					( SUM(PL.FuncP3ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 3 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ))
					END AS [Period 3 Actual Amount]
		      ,Case @pCurrency WHEN @ConsCurrency THEN
				 ( SUM(PL.ConsP4ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 4 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ))
			  WHEN @FuncCurrency THEN
					( SUM(PL.FuncP4ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 4 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ))
					END AS [Period 4 Actual Amount]
		      ,Case @pCurrency WHEN @ConsCurrency THEN
				 ( SUM(PL.ConsP5ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 5 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ))
			  WHEN @FuncCurrency THEN
					( SUM(PL.FuncP5ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 5 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ))
					END AS [Period 5 Actual Amount]
		      ,Case @pCurrency WHEN @ConsCurrency THEN
				 ( SUM(PL.ConsP6ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 6 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ))
			  WHEN @FuncCurrency THEN
					( SUM(PL.FuncP6ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 6 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ))
					END AS [Period 6 Actual Amount]
		      ,Case @pCurrency WHEN @ConsCurrency THEN
				 ( SUM(PL.ConsP7ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 7 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ))
			  WHEN @FuncCurrency THEN
					( SUM(PL.FuncP7ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 7 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ))
					END AS [Period 7 Actual Amount]
		      ,Case @pCurrency WHEN @ConsCurrency THEN
				 ( SUM(PL.ConsP8ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 8 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ))
			  WHEN @FuncCurrency THEN
					( SUM(PL.FuncP8ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 8 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ))
					END AS [Period 8 Actual Amount]
		      ,Case @pCurrency WHEN @ConsCurrency THEN
				 ( SUM(PL.ConsP9ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ))
			  WHEN @FuncCurrency THEN
					( SUM(PL.FuncP9ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ))
					END AS [Period 9 Actual Amount]	
		      ,Case @pCurrency WHEN @ConsCurrency THEN
				 ( SUM(PL.ConsP10ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 10 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ))
			  WHEN @FuncCurrency THEN
					( SUM(PL.FuncP10ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 10 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ))
					END AS [Period 10 Actual Amount]
		      ,Case @pCurrency WHEN @ConsCurrency THEN
				 ( SUM(PL.ConsP11ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 11 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ))
			  WHEN @FuncCurrency THEN
					( SUM(PL.FuncP11ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 11 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ))
					END AS [Period 11 Actual Amount]
		      ,Case @pCurrency WHEN @ConsCurrency THEN
				 ( SUM(PL.ConsP12ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 12 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ))
			  WHEN @FuncCurrency THEN
					( SUM(PL.FuncP12ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >=12 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ))
					END AS [Period 12 Actual Amount]

			 /*Total Actual Amont Begin*/

			 ,Case @pCurrency WHEN @ConsCurrency THEN
				 (		 SUM(PL.ConsP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 1 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ) +
						 SUM(PL.ConsP2ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 2 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ) +
						 SUM(PL.ConsP3ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 3 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ) +
						 SUM(PL.ConsP4ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 4 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ) +
						 SUM(PL.ConsP5ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 5 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ) +
						 SUM(PL.ConsP6ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 6 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ) +
						 SUM(PL.ConsP7ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 7 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ) +
						 SUM(PL.ConsP8ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 8 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ) +
						 SUM(PL.ConsP9ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ) +
						 SUM(PL.ConsP10ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 10 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ) +
						 SUM(PL.ConsP11ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 11 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ) +
						 SUM(PL.ConsP12ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 12 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END )
					)
			  WHEN @FuncCurrency THEN
					(	 SUM(PL.FuncP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 1 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ) +
						 SUM(PL.FuncP2ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 2 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ) +
						 SUM(PL.FuncP3ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 3 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ) +
						 SUM(PL.FuncP4ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 4 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ) +
						 SUM(PL.FuncP5ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 5 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ) +
						 SUM(PL.FuncP6ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 6 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ) +
						 SUM(PL.FuncP7ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 7 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ) +
						 SUM(PL.FuncP8ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 8 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ) +
						 SUM(PL.FuncP9ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ) +
						 SUM(PL.FuncP10ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 10 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ) +
						 SUM(PL.FuncP11ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 11 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END ) +
						 SUM(PL.FuncP12ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 12 AND 
                         CP.FiscalPeriodSkey = @pFiscalPeriod THEN FT.IncomeStatementActualSign ELSE 0 END )	)
					END AS [ToT_Actual]

			/*Total Actual Amont End*/


		      ,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP1BudgetAmt) )
			  WHEN @FuncCurrency THEN ( SUM(PL.FuncP1BudgetAmt) )
					END AS [Period 1 Budget Amount]
		      ,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP2BudgetAmt) )
			  WHEN @FuncCurrency THEN ( SUM(PL.FuncP2BudgetAmt) )
					END AS [Period 2 Budget Amount]
		      ,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP3BudgetAmt) )
			  WHEN @FuncCurrency THEN ( SUM(PL.FuncP3BudgetAmt) )
					END AS [Period 3 Budget Amount]
		      ,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP4BudgetAmt) )
			  WHEN @FuncCurrency THEN ( SUM(PL.FuncP4BudgetAmt) )
					END AS [Period 4 Budget Amount]
		      ,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP5BudgetAmt) )
			  WHEN @FuncCurrency THEN ( SUM(PL.FuncP5BudgetAmt) )
					END AS [Period 5 Budget Amount]
		      ,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP6BudgetAmt) )
			  WHEN @FuncCurrency THEN ( SUM(PL.FuncP6BudgetAmt) )
					END AS [Period 6 Budget Amount]
		      ,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP7BudgetAmt) )
			  WHEN @FuncCurrency THEN ( SUM(PL.FuncP7BudgetAmt) )
					END AS [Period 7 Budget Amount]
		      ,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP8BudgetAmt) )
			  WHEN @FuncCurrency THEN ( SUM(PL.FuncP8BudgetAmt) )
					END AS [Period 8 Budget Amount]
		      ,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP9BudgetAmt) )
			  WHEN @FuncCurrency THEN ( SUM(PL.FuncP9BudgetAmt) )
					END AS [Period 9 Budget Amount]
		      ,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP10BudgetAmt) )
			  WHEN @FuncCurrency THEN ( SUM(PL.FuncP10BudgetAmt) )
					END AS [Period 10 Budget Amount]
		      ,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP11BudgetAmt) )
			  WHEN @FuncCurrency THEN ( SUM(PL.FuncP11BudgetAmt) )
					END AS [Period 11 Budget Amount]
		      ,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP12BudgetAmt) )
			  WHEN @FuncCurrency THEN ( SUM(PL.FuncP12BudgetAmt) )
					END AS [Period 12 Budget Amount]

			 /*Total Budget Amont begin*/

			 ,Case @pCurrency WHEN @ConsCurrency THEN 
			 ( 
				SUM(PL.ConsP1BudgetAmt) + 
				SUM(PL.ConsP2BudgetAmt) + 
				SUM(PL.ConsP3BudgetAmt) + 
				SUM(PL.ConsP4BudgetAmt) + 
				SUM(PL.ConsP5BudgetAmt) + 
				SUM(PL.ConsP6BudgetAmt) + 
				SUM(PL.ConsP7BudgetAmt) + 
				SUM(PL.ConsP8BudgetAmt) + 
				SUM(PL.ConsP9BudgetAmt) + 
				SUM(PL.ConsP10BudgetAmt)+ 
				SUM(PL.ConsP11BudgetAmt)+ 
				SUM(PL.ConsP12BudgetAmt) 
			 )
			  WHEN @FuncCurrency THEN 
			 (
			    SUM(PL.FuncP1BudgetAmt) + 
				SUM(PL.FuncP2BudgetAmt) + 
				SUM(PL.FuncP3BudgetAmt) + 
				SUM(PL.FuncP4BudgetAmt) + 
				SUM(PL.FuncP5BudgetAmt) + 
				SUM(PL.FuncP6BudgetAmt) + 
				SUM(PL.FuncP7BudgetAmt) + 
				SUM(PL.FuncP8BudgetAmt) + 
				SUM(PL.FuncP9BudgetAmt) + 
				SUM(PL.FuncP10BudgetAmt)+ 
				SUM(PL.FuncP11BudgetAmt)+ 
				SUM(PL.FuncP12BudgetAmt) 
			 )
			  END AS [ToT_Budget]

			 /*Total Budget Amont end*/

		      ,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP1FC1Amt * FT.IncomeStatementBudgetSign) )
			  WHEN @FuncCurrency THEN ( SUM(PL.FuncP1FC1Amt * FT.IncomeStatementBudgetSign) )
					END AS [Period 1 Forecast 1 Amount] 
		      ,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP2FC1Amt * FT.IncomeStatementBudgetSign) )
			  WHEN @FuncCurrency THEN ( SUM(PL.FuncP2FC1Amt * FT.IncomeStatementBudgetSign) )
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
		      ,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP1FC2Amt * FT.IncomeStatementBudgetSign) )
			  WHEN @FuncCurrency THEN ( SUM(PL.FuncP1FC2Amt * FT.IncomeStatementBudgetSign) )
					END AS [Period 1 Forecast 2 Amount] 
		      ,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP2FC2Amt * FT.IncomeStatementBudgetSign) )
			  WHEN @FuncCurrency THEN ( SUM(PL.FuncP2FC2Amt * FT.IncomeStatementBudgetSign) )
					END AS [Period 2 Forecast 2 Amount] 
		      ,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP3FC2Amt * FT.IncomeStatementBudgetSign) )
			  WHEN @FuncCurrency THEN ( SUM(PL.FuncP3FC2Amt * FT.IncomeStatementBudgetSign) )
					END AS [Period 3 Forecast 2 Amount] 
		      ,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP4FC2Amt * FT.IncomeStatementBudgetSign) )
			  WHEN @FuncCurrency THEN ( SUM(PL.FuncP4FC2Amt * FT.IncomeStatementBudgetSign) )
					END AS [Period 4 Forecast 2 Amount] 
		      ,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP5FC2Amt * FT.IncomeStatementBudgetSign) )
			  WHEN @FuncCurrency THEN ( SUM(PL.FuncP5FC2Amt * FT.IncomeStatementBudgetSign) )
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
		      ,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP1FC3Amt * FT.IncomeStatementBudgetSign) )
			  WHEN @FuncCurrency THEN ( SUM(PL.FuncP1FC3Amt * FT.IncomeStatementBudgetSign) )
					END AS [Period 1 Forecast 3 Amount] 
		      ,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP2FC3Amt * FT.IncomeStatementBudgetSign) )
			  WHEN @FuncCurrency THEN ( SUM(PL.FuncP2FC3Amt * FT.IncomeStatementBudgetSign) )
					END AS [Period 2 Forecast 3 Amount] 
		      ,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP3FC3Amt * FT.IncomeStatementBudgetSign) )
			  WHEN @FuncCurrency THEN ( SUM(PL.FuncP3FC3Amt * FT.IncomeStatementBudgetSign) )
					END AS [Period 3 Forecast 3 Amount] 
		      ,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP4FC3Amt * FT.IncomeStatementBudgetSign) )
			  WHEN @FuncCurrency THEN ( SUM(PL.FuncP4FC3Amt * FT.IncomeStatementBudgetSign) )
					END AS [Period 4 Forecast 3 Amount] 
		      ,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP5FC3Amt * FT.IncomeStatementBudgetSign) )
			  WHEN @FuncCurrency THEN ( SUM(PL.FuncP5FC3Amt * FT.IncomeStatementBudgetSign) )
					END AS [Period 5 Forecast 3 Amount] 
		      ,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP6FC3Amt * FT.IncomeStatementBudgetSign) )
			  WHEN @FuncCurrency THEN ( SUM(PL.FuncP6FC3Amt * FT.IncomeStatementBudgetSign) )
					END AS [Period 6 Forecast 3 Amount] 
		      ,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP7FC3Amt * FT.IncomeStatementBudgetSign) )
			  WHEN @FuncCurrency THEN ( SUM(PL.FuncP7FC3Amt * FT.IncomeStatementBudgetSign) )
					END AS [Period 7 Forecast 3 Amount] 
		      ,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP8FC3Amt * FT.IncomeStatementBudgetSign) )
			  WHEN @FuncCurrency THEN ( SUM(PL.FuncP8FC3Amt * FT.IncomeStatementBudgetSign) )
					END AS [Period 8 Forecast 3 Amount] 
		      ,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(PL.ConsP9FC3Amt * FT.IncomeStatementBudgetSign) )
			  WHEN @FuncCurrency THEN ( SUM(PL.FuncP9FC3Amt * FT.IncomeStatementBudgetSign) )
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
		/*NYBudget*/
			  ,Case @pCurrency WHEN @ConsCurrency THEN ( SUM(FB.[ConsBudgetAmt] * FT.IncomeStatementBudgetSign) )
			  WHEN @FuncCurrency THEN ( SUM(FB.[FuncBudgetAmt] * FT.IncomeStatementBudgetSign) )
					END AS [NYBudget]

		/*PYActual*/
 ,Case @pCurrency WHEN @ConsCurrency THEN
				 (  
				     SUM(PL.ConsP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 1 AND 
                     CP.FiscalPeriodSkey = @pFiscalPeriod-100 THEN FT.IncomeStatementActualSign ELSE 0 END ) + 
				     SUM(PL.ConsP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 2 AND 
                     CP.FiscalPeriodSkey = @pFiscalPeriod-100 THEN FT.IncomeStatementActualSign ELSE 0 END ) + 
				     SUM(PL.ConsP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 3 AND 
                     CP.FiscalPeriodSkey = @pFiscalPeriod-100 THEN FT.IncomeStatementActualSign ELSE 0 END ) + 
					 SUM(PL.ConsP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 4 AND 
                     CP.FiscalPeriodSkey = @pFiscalPeriod-100 THEN FT.IncomeStatementActualSign ELSE 0 END ) +
					 SUM(PL.ConsP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 5 AND 
                     CP.FiscalPeriodSkey = @pFiscalPeriod-100 THEN FT.IncomeStatementActualSign ELSE 0 END ) + 
					 SUM(PL.ConsP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 6 AND 
                     CP.FiscalPeriodSkey = @pFiscalPeriod-100 THEN FT.IncomeStatementActualSign ELSE 0 END ) + 
					 SUM(PL.ConsP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 7 AND 
                     CP.FiscalPeriodSkey = @pFiscalPeriod-100 THEN FT.IncomeStatementActualSign ELSE 0 END ) + 
					 SUM(PL.ConsP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 8 AND 
                     CP.FiscalPeriodSkey = @pFiscalPeriod-100 THEN FT.IncomeStatementActualSign ELSE 0 END ) + 
					 SUM(PL.ConsP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9 AND 
                     CP.FiscalPeriodSkey = @pFiscalPeriod-100 THEN FT.IncomeStatementActualSign ELSE 0 END ) + 
					 SUM(PL.ConsP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 10 AND 
                     CP.FiscalPeriodSkey = @pFiscalPeriod-100 THEN FT.IncomeStatementActualSign ELSE 0 END ) + 
					 SUM(PL.ConsP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 11 AND 
                     CP.FiscalPeriodSkey = @pFiscalPeriod-100 THEN FT.IncomeStatementActualSign ELSE 0 END ) + 
					 SUM(PL.ConsP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 12 AND 
                     CP.FiscalPeriodSkey = @pFiscalPeriod-100 THEN FT.IncomeStatementActualSign ELSE 0 END ) 
					 ) -- @pFiscalPeriod - 100 to get Last Year
                  WHEN @FuncCurrency THEN
				( 
				     SUM(PL.FuncP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 1 AND 
                     CP.FiscalPeriodSkey = @pFiscalPeriod-100 THEN FT.IncomeStatementActualSign ELSE 0 END ) + 
				     SUM(PL.FuncP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 2 AND 
                     CP.FiscalPeriodSkey = @pFiscalPeriod-100 THEN FT.IncomeStatementActualSign ELSE 0 END ) + 
				     SUM(PL.FuncP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 3 AND 
                     CP.FiscalPeriodSkey = @pFiscalPeriod-100 THEN FT.IncomeStatementActualSign ELSE 0 END ) + 
					 SUM(PL.FuncP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 4 AND 
                     CP.FiscalPeriodSkey = @pFiscalPeriod-100 THEN FT.IncomeStatementActualSign ELSE 0 END ) +
					 SUM(PL.FuncP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 5 AND 
                     CP.FiscalPeriodSkey = @pFiscalPeriod-100 THEN FT.IncomeStatementActualSign ELSE 0 END ) + 
					 SUM(PL.FuncP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 6 AND 
                     CP.FiscalPeriodSkey = @pFiscalPeriod-100 THEN FT.IncomeStatementActualSign ELSE 0 END ) + 
					 SUM(PL.FuncP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 7 AND 
                     CP.FiscalPeriodSkey = @pFiscalPeriod-100 THEN FT.IncomeStatementActualSign ELSE 0 END ) + 
					 SUM(PL.FuncP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 8 AND 
                     CP.FiscalPeriodSkey = @pFiscalPeriod-100 THEN FT.IncomeStatementActualSign ELSE 0 END ) + 
					 SUM(PL.FuncP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9 AND 
                     CP.FiscalPeriodSkey = @pFiscalPeriod-100 THEN FT.IncomeStatementActualSign ELSE 0 END ) + 
					 SUM(PL.FuncP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 10 AND 
                     CP.FiscalPeriodSkey = @pFiscalPeriod-100 THEN FT.IncomeStatementActualSign ELSE 0 END ) + 
					 SUM(PL.FuncP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 11 AND 
                     CP.FiscalPeriodSkey = @pFiscalPeriod-100 THEN FT.IncomeStatementActualSign ELSE 0 END ) + 
					 SUM(PL.FuncP1ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 12 AND 
                     CP.FiscalPeriodSkey = @pFiscalPeriod-100 THEN FT.IncomeStatementActualSign ELSE 0 END ) 
					
				)
					END AS [PYActual]
					
/*END PYActual*/		  					 
FROM           
		FactProfitAndLossSummary AS PL 
		LEFT OUTER JOIN DimAccount DA ON PL.AccountSkey  = DA.AccountSkey
		LEFT OUTER JOIN MapFinancialTemplate AS FT ON FT.AccountSkey = PL.AccountSkey 
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
		LEFT OUTER JOIN [dbo].[FactGLBudgetingProcess] FB ON PL.[PostPeriodSkey] = FB.[PostPeriodSkey] --Join Budgeting Process
		 
WHERE        (PL.PostPeriodSkey = @pFiscalPeriod) 
			AND (FT.TemplateID = @pTemplate)
			AND PL.OrgSkey IN  ( Select * from dbo.STRING_SPLIT(@pOrg, ','))
			--and orgskey in( select orgskey from [dbo].[DimOrganization] where Companyid = '1')
			--AND HeaderLine = 'Y'
	
GROUP BY
			FT.TemplateID
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
			, Case @pLanguage when @ENLanguage THEN DA.[AccountNameEN]
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
			,AccountID
			,CP.FiscalPeriodNumber
			,SortOrder
)
--End of CTE Mark
		
		
		
		
		
		SELECT			 Template.* 
                        , FiscalPeriodNumber 
						,ISNULL([Current Month Amount]				,0.)	  as   [Current Month Amount]				
						,ISNULL([Current Month Budget Amount]		,0.)	  as   [Current Month Budget Amount]		
						,ISNULL([YTD Amount]						,0.)	  as   [YTD Amount]						
						,ISNULL([Current Month Forecast 1 Amount]	,0.)	  as   [Current Month Forecast 1 Amount]	
						,ISNULL([Current Month Forecast 2 Amount]	,0.)	  as   [Current Month Forecast 2 Amount]	
						,ISNULL([Current Month Forecast 3 Amount]	,0.)	  as   [Current Month Forecast 3 Amount]	
						,ISNULL([YTD Budget Amount]					,0.)	  as   [YTD Budget Amount]					
						,ISNULL([Current Year Budget Amount]		,0.)	  as   [Current Year Budget Amount]		
						,ISNULL([YTD Forecast 1 Amount]				,0.)	  as   [YTD Forecast 1 Amount]				
						,ISNULL([YTD Forecast 2 Amount]				,0.)	  as   [YTD Forecast 2 Amount]				
						,ISNULL([YTD Forecast 3 Amount]				,0.)	  as   [YTD Forecast 3 Amount]				
						,ISNULL([LY Current Month Amount]			,0.)	  as   [LY Current Month Amount]			
						,ISNULL( [QTD Amount],0)							  as    [QTD Amount]
						,ISNULL( [QTD Budget Amount]	,0.)				  as    [QTD Budget Amount]
						,ISNULL([QTD Forecast 1 Amount]				,0.)	  as   [QTD Forecast 1 Amount]				
						,ISNULL([QTD Forecast 2 Amount]				,0.)	  as   [QTD Forecast 2 Amount]				
						,ISNULL([QTD Forecast 3 Amount]				,0.)	  as   [QTD Forecast 3 Amount]				
						,ISNULL([Period 1 Actual Amount]			,0.)	  as   [Period 1 Actual Amount]			
						,ISNULL([Period 2 Actual Amount]			,0.)	  as   [Period 2 Actual Amount]			
						,ISNULL([Period 3 Actual Amount]			,0.)	  as   [Period 3 Actual Amount]			
						,ISNULL([Period 4 Actual Amount]			,0.)	  as   [Period 4 Actual Amount]			
						,ISNULL([Period 5 Actual Amount]			,0.)	  as   [Period 5 Actual Amount]			
						,ISNULL([Period 6 Actual Amount]			,0.)	  as   [Period 6 Actual Amount]			
						,ISNULL([Period 7 Actual Amount]			,0.)	  as   [Period 7 Actual Amount]			
						,ISNULL([Period 8 Actual Amount]			,0.)	  as   [Period 8 Actual Amount]			
						,ISNULL([Period 9 Actual Amount]			,0.)	  as   [Period 9 Actual Amount]			
						,ISNULL([Period 10 Actual Amount]			,0.)	  as   [Period 10 Actual Amount]			
						,ISNULL([Period 11 Actual Amount]			,0.)	  as   [Period 11 Actual Amount]			
						,ISNULL([Period 12 Actual Amount]			,0.)	  as   [Period 12 Actual Amount]			
						,ISNULL(TOT_Actual							,0.)	  as   TOT_Actual							
						,ISNULL([Period 1 Budget Amount]			,0.)	  as   [Period 1 Budget Amount]			
						,ISNULL([Period 2 Budget Amount]			,0.)	  as   [Period 2 Budget Amount]			
						,ISNULL([Period 3 Budget Amount]			,0.)	  as   [Period 3 Budget Amount]			
						,ISNULL([Period 4 Budget Amount]			,0.)	  as   [Period 4 Budget Amount]			
						,ISNULL([Period 5 Budget Amount]			,0.)	  as   [Period 5 Budget Amount]			
						,ISNULL([Period 6 Budget Amount]			,0.)	  as   [Period 6 Budget Amount]			
						,ISNULL([Period 7 Budget Amount]			,0.)	  as   [Period 7 Budget Amount]			
						,ISNULL([Period 8 Budget Amount]			,0.)	  as   [Period 8 Budget Amount]			
						,ISNULL([Period 9 Budget Amount]			,0.)	  as   [Period 9 Budget Amount]			
						,ISNULL([Period 10 Budget Amount]			,0.)	  as   [Period 10 Budget Amount]			
						,ISNULL([Period 11 Budget Amount]			,0.)	  as   [Period 11 Budget Amount]			
						,ISNULL([Period 12 Budget Amount]			,0.)	  as   [Period 12 Budget Amount]			
						,ISNULL(TOT_Budget							,0.)	  as   TOT_Budget							
						,ISNULL([Period 1 Forecast 1 Amount]		,0.)	  as   [Period 1 Forecast 1 Amount]		
						,ISNULL([Period 2 Forecast 1 Amount]		,0.)	  as   [Period 2 Forecast 1 Amount]		
						,ISNULL([Period 3 Forecast 1 Amount]		,0.)	  as   [Period 3 Forecast 1 Amount]		
						,ISNULL([Period 4 Forecast 1 Amount]		,0.)	  as   [Period 4 Forecast 1 Amount]		
						,ISNULL([Period 5 Forecast 1 Amount]		,0.)	  as   [Period 5 Forecast 1 Amount]		
						,ISNULL([Period 6 Forecast 1 Amount]		,0.)	  as   [Period 6 Forecast 1 Amount]		
						,ISNULL([Period 7 Forecast 1 Amount]		,0.)	  as   [Period 7 Forecast 1 Amount]		
						,ISNULL([Period 8 Forecast 1 Amount]		,0.)	  as   [Period 8 Forecast 1 Amount]		
						,ISNULL([Period 9 Forecast 1 Amount]		,0.)	  as   [Period 9 Forecast 1 Amount]		
						,ISNULL([Period 10 Forecast 1 Amount]		,0.)	  as   [Period 10 Forecast 1 Amount]		
						,ISNULL([Period 11 Forecast 1 Amount]		,0.)	  as   [Period 11 Forecast 1 Amount]		
						,ISNULL([Period 12 Forecast 1 Amount]		,0.)	  as   [Period 12 Forecast 1 Amount]		
						,ISNULL([Period 1 Forecast 2 Amount]		,0.)	  as   [Period 1 Forecast 2 Amount]		
						,ISNULL([Period 2 Forecast 2 Amount]		,0.)	  as   [Period 2 Forecast 2 Amount]		
						,ISNULL([Period 3 Forecast 2 Amount]		,0.)	  as   [Period 3 Forecast 2 Amount]		
						,ISNULL([Period 4 Forecast 2 Amount]		,0.)	  as   [Period 4 Forecast 2 Amount]		
						,ISNULL([Period 5 Forecast 2 Amount]		,0.)	  as   [Period 5 Forecast 2 Amount]		
						,ISNULL([Period 6 Forecast 2 Amount]		,0.)	  as   [Period 6 Forecast 2 Amount]		
						,ISNULL([Period 7 Forecast 2 Amount]		,0.)	  as   [Period 7 Forecast 2 Amount]		
						,ISNULL([Period 8 Forecast 2 Amount]		,0.)	  as   [Period 8 Forecast 2 Amount]		
						,ISNULL([Period 9 Forecast 2 Amount]		,0.)	  as   [Period 9 Forecast 2 Amount]		
						,ISNULL([Period 10 Forecast 2 Amount]		,0.)	  as   [Period 10 Forecast 2 Amount]		
						,ISNULL([Period 11 Forecast 2 Amount]		,0.)	  as   [Period 11 Forecast 2 Amount]		
						,ISNULL([Period 12 Forecast 2 Amount]		,0.)	  as   [Period 12 Forecast 2 Amount]		
						,ISNULL([Period 1 Forecast 3 Amount]		,0.)	  as   [Period 1 Forecast 3 Amount]		
						,ISNULL([Period 2 Forecast 3 Amount]		,0.)	  as   [Period 2 Forecast 3 Amount]		
						,ISNULL([Period 3 Forecast 3 Amount]		,0.)	  as   [Period 3 Forecast 3 Amount]		
						,ISNULL([Period 4 Forecast 3 Amount]		,0.)	  as   [Period 4 Forecast 3 Amount]		
						,ISNULL([Period 5 Forecast 3 Amount]		,0.)	  as   [Period 5 Forecast 3 Amount]		
						,ISNULL([Period 6 Forecast 3 Amount]		,0.)	  as   [Period 6 Forecast 3 Amount]		
						,ISNULL([Period 7 Forecast 3 Amount]		,0.)	  as   [Period 7 Forecast 3 Amount]		
						,ISNULL([Period 8 Forecast 3 Amount]		,0.)	  as   [Period 8 Forecast 3 Amount]		
						,ISNULL([Period 9 Forecast 3 Amount]		,0.)	  as   [Period 9 Forecast 3 Amount]		
						,ISNULL([Period 10 Forecast 3 Amount]		,0.)	  as   [Period 10 Forecast 3 Amount]		
						,ISNULL([Period 11 Forecast 3 Amount]		,0.)	  as   [Period 11 Forecast 3 Amount]		
						,ISNULL([Period 12 Forecast 3 Amount]		,0.)	  as   [Period 12 Forecast 3 Amount]		
						,ISNULL( NYBudget  							,0.)	  as    NYBudget  							
						,ISNULL( PYActual							,0.)      as    PYActual							
					
		FROM (Select Group1Level,Group2Level,Group3Level,Group1LevelID,Group2LevelID,Group3LevelID,Templ.*
								 FROM	(select Distinct TemplateID
										,GroupID 
									  ,Case @pLanguage When @ENLanguage THEN GroupDescEN 
										  WHEN @FRLanguage THEN GroupDescFR
										  Else 'Unknown'
										END as GroupDesc
										,GroupType
										,Sortorder 
										,AccountID
										,Case @pLanguage When @ENLanguage THEN AccountNameEN 
										  WHEN @FRLanguage THEN AccountNameFR
										  Else 'Unknown'
										END as AccountDesc
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
							from [dbo].[MapFinancialTemplate] left join dbo.DimAccount on
							MapFinancialTemplate.accountskey = dimaccount.accountskey
							WHERE TemplateID = @pTemplate 
							)Templ 
							CROSS JOIN ( Select Distinct Group1Level,Group2Level,Group3Level,Group1LevelID,Group2LevelID,Group3LevelID
										FROM ProfitandLossCTE
										)DistGroup
							)Template
					LEFT OUTER JOIN ProfitandLossCTE as PCTE ON Template.TemplateID = PCTE.TemplateID
													AND Template.AccountID = PCTE.AccountID--Add on Aug5 prevent Random combination
													AND Template.GroupID = PCTE.GroupId
													AND Template.Group1level = PCTE.Group1level
													AND Template.Group2level = PCTE.Group2level
													AND Template.Group3level = PCTE.Group3level						              
ORDER BY  Template.Group1Level,Template.Group2Level,Template.Group3Level,Template.SortOrder,  Template.GroupID,  Template.GroupDesc ,Template.AccountID
GO

