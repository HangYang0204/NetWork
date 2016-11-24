USE [BIDataWarehouse]
GO

/****** Object:  StoredProcedure [dbo].[usp_ProfitandLossSummaryFact_CorprateSupportExpense_Detail]    Script Date: 24/11/2016 11:08:28 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




/*Leo Yang July 21
--Add sum of 12 Month Actual Amont and 12 Month Budget Amont
--Add NYBudget AKA Next Year Budget
--Add PYActual
*/

CREATE  Procedure [dbo].[usp_ProfitandLossSummaryFact_CorprateSupportExpense_Detail]
	@pCurrency varchar(5),
	@pFiscalPeriod int,
	@pTemplate int,
	@pLanguage int
	,@pOrg varchar(max)
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
WITH ProfitandLossCTE ( OrganizationID,[Organization Name],TemplateID,GroupID ,GroupDesc,[HeaderLine],[ShowDetail],[InsertSkipLineBefore],[SkipLine]
			,[IsMarkup] ,[IsNetRevenues],[IsDirectLabor],[IsFringeBenefitsPct],[IsFringeBenefits]
			,[IsManagementSalaries],[IsMarketingSalaries],[IsTrainingSalaries],[IsEBGEPct],[IsEBGE]
			,[IsEBREPct],[IsEBRE],[IsEBITDAPct],[IsEBITDA] ,[IsCalculatedUtilizationPct]
			 /************************************************/
			 ,AccountID, AccountDesc
			 /************************************************/
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
    SELECT  
			 DO.OrganizationID  
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
			 /************************************************/
			,DA.AccountID
			, Case @pLanguage when @ENLanguage THEN DA.[AccountNameEN]
							  WHEN @FRLanguage THEN DA.[AccountNameFR]
							  ELSE 'Unknown'
					END AS AccountDesc	
			/************************************************/	
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
										WHEN 9 THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt+ PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt ) * FT.IncomeStatementActualSign) 
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
					( SUM(PL.FuncP12ActualBudgetAmt * CASE WHEN CP.FiscalPeriodNumber >= 9 AND 
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
		
		LEFT OUTER JOIN MapFinancialTemplate AS FT ON FT.AccountSkey = PL.AccountSkey 
		--LEFT OUTER JOIN DimAccount DA ON PL.AccountSkey  = DA.AccountSkey
		INNER JOIN DimAccount DA ON PL.AccountSkey  = DA.AccountSkey

		INNER JOIN DimCalendarPeriod AS CP ON PL.PostPeriodSkey = CP.FiscalPeriodSkey
		LEFT OUTER JOIN [dbo].[FactGLBudgetingProcess] FB ON PL.[PostPeriodSkey] = FB.[PostPeriodSkey] --Join Budgeting Process
		INNER JOIN [dbo].[DimOrganization] as DO on PL.OrgSkey = DO.OrgSkey
		 
WHERE        (PL.PostPeriodSkey = @pFiscalPeriod) 
			AND (FT.TemplateID = @pTemplate)
			AND PL.OrgSkey IN  ( Select * from dbo.STRING_SPLIT(@pOrg, ','))
			--and orgskey in( select orgskey from [dbo].[DimOrganization] where Companyid = '1')
			--AND HeaderLine = 'Y'
	
GROUP BY 
           DO.OrganizationID
		  ,DO.OrganizationID + ' - ' + DO.[OrganizationDesc]
		  ,TemplateID 
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


SELECT				     Template.*
                       , FiscalPeriodNumber						 
                 		,ISNULL([Current Month Amount]					,0.)		as  	 [Current Month Amount]					
						,ISNULL([Current Month Budget Amount]			,0.)		as  	 [Current Month Budget Amount]			
						,ISNULL([YTD Amount]							,0.)		as  	 [YTD Amount]							
						,ISNULL([Current Month Forecast 1 Amount]		,0.)		as  	 [Current Month Forecast 1 Amount]		
						,ISNULL([Current Month Forecast 2 Amount]		,0.)		as  	 [Current Month Forecast 2 Amount]		
						,ISNULL([Current Month Forecast 3 Amount]		,0.)		as  	 [Current Month Forecast 3 Amount]		
						,ISNULL([YTD Budget Amount]						,0.)		as  	 [YTD Budget Amount]						
						,ISNULL([Current Year Budget Amount]			,0.)		as  	 [Current Year Budget Amount]			
						,ISNULL([YTD Forecast 1 Amount]					,0.)		as  	 [YTD Forecast 1 Amount]					
						,ISNULL([YTD Forecast 2 Amount]					,0.)		as  	 [YTD Forecast 2 Amount]					
						,ISNULL([YTD Forecast 3 Amount]					,0.)		as  	 [YTD Forecast 3 Amount]					
						,ISNULL([LY Current Month Amount]				,0.)		as  	 [LY Current Month Amount]				
						,ISNULL([QTD Amount]							,0.)		as  	 [QTD Amount]							
						,ISNULL([QTD Budget Amount]						,0.)		as  	 [QTD Budget Amount]						
						,ISNULL([QTD Forecast 1 Amount]					,0.)		as  	 [QTD Forecast 1 Amount]					
						,ISNULL([QTD Forecast 2 Amount]					,0.)		as  	 [QTD Forecast 2 Amount]					
						,ISNULL([QTD Forecast 3 Amount]					,0.)		as  	 [QTD Forecast 3 Amount]					
						,ISNULL([Period 1 Actual Amount]				,0.)		as  	 [Period 1 Actual Amount]				
						,ISNULL([Period 2 Actual Amount]				,0.)		as  	 [Period 2 Actual Amount]				
						,ISNULL([Period 3 Actual Amount]				,0.)		as  	 [Period 3 Actual Amount]				
						,ISNULL([Period 4 Actual Amount]				,0.)		as  	 [Period 4 Actual Amount]				
						,ISNULL([Period 5 Actual Amount]				,0.)		as  	 [Period 5 Actual Amount]				
						,ISNULL([Period 6 Actual Amount]				,0.)		as  	 [Period 6 Actual Amount]				
						,ISNULL([Period 7 Actual Amount]				,0.)		as  	 [Period 7 Actual Amount]				
						,ISNULL([Period 8 Actual Amount]				,0.)		as  	 [Period 8 Actual Amount]				
						,ISNULL([Period 9 Actual Amount]				,0.)		as  	 [Period 9 Actual Amount]				
						,ISNULL([Period 10 Actual Amount]				,0.)		as  	 [Period 10 Actual Amount]				
						,ISNULL([Period 11 Actual Amount]				,0.)		as  	 [Period 11 Actual Amount]				
						,ISNULL([Period 12 Actual Amount]				,0.)		as  	 [Period 12 Actual Amount]				
						,ISNULL(TOT_Actual								,0.)		as  	 TOT_Actual								
						,ISNULL([Period 1 Budget Amount]				,0.)		as  	 [Period 1 Budget Amount]				
						,ISNULL([Period 2 Budget Amount]				,0.)		as  	 [Period 2 Budget Amount]				
						,ISNULL([Period 3 Budget Amount]				,0.)		as  	 [Period 3 Budget Amount]				
						,ISNULL([Period 4 Budget Amount]				,0.)		as  	 [Period 4 Budget Amount]				
						,ISNULL([Period 5 Budget Amount]				,0.)		as  	 [Period 5 Budget Amount]				
						,ISNULL([Period 6 Budget Amount]				,0.)		as  	 [Period 6 Budget Amount]				
						,ISNULL([Period 7 Budget Amount]				,0.)		as  	 [Period 7 Budget Amount]				
						,ISNULL([Period 8 Budget Amount]				,0.)		as  	 [Period 8 Budget Amount]				
						,ISNULL([Period 9 Budget Amount]				,0.)		as  	 [Period 9 Budget Amount]				
						,ISNULL([Period 10 Budget Amount]				,0.)		as  	 [Period 10 Budget Amount]				
						,ISNULL([Period 11 Budget Amount]				,0.)		as  	 [Period 11 Budget Amount]				
						,ISNULL([Period 12 Budget Amount]				,0.)		as  	 [Period 12 Budget Amount]				
						,ISNULL(TOT_Budget								,0.)		as  	 TOT_Budget								
						,ISNULL([Period 1 Forecast 1 Amount]			,0.)		as  	 [Period 1 Forecast 1 Amount]			
						,ISNULL([Period 2 Forecast 1 Amount]			,0.)		as  	 [Period 2 Forecast 1 Amount]			
						,ISNULL([Period 3 Forecast 1 Amount]			,0.)		as  	 [Period 3 Forecast 1 Amount]			
						,ISNULL([Period 4 Forecast 1 Amount]			,0.)		as  	 [Period 4 Forecast 1 Amount]			
						,ISNULL([Period 5 Forecast 1 Amount]			,0.)		as  	 [Period 5 Forecast 1 Amount]			
						,ISNULL([Period 6 Forecast 1 Amount]			,0.)		as  	 [Period 6 Forecast 1 Amount]			
						,ISNULL([Period 7 Forecast 1 Amount]			,0.)		as  	 [Period 7 Forecast 1 Amount]			
						,ISNULL([Period 8 Forecast 1 Amount]			,0.)		as  	 [Period 8 Forecast 1 Amount]			
						,ISNULL([Period 9 Forecast 1 Amount]			,0.)		as  	 [Period 9 Forecast 1 Amount]			
						,ISNULL([Period 10 Forecast 1 Amount]			,0.)		as  	 [Period 10 Forecast 1 Amount]			
						,ISNULL([Period 11 Forecast 1 Amount]			,0.)		as  	 [Period 11 Forecast 1 Amount]			
						,ISNULL([Period 12 Forecast 1 Amount]			,0.)		as  	 [Period 12 Forecast 1 Amount]			
						,ISNULL([Period 1 Forecast 2 Amount]			,0.)		as  	 [Period 1 Forecast 2 Amount]			
						,ISNULL([Period 2 Forecast 2 Amount]			,0.)		as  	 [Period 2 Forecast 2 Amount]			
						,ISNULL([Period 3 Forecast 2 Amount]			,0.)		as  	 [Period 3 Forecast 2 Amount]			
						,ISNULL([Period 4 Forecast 2 Amount]			,0.)		as  	 [Period 4 Forecast 2 Amount]			
						,ISNULL([Period 5 Forecast 2 Amount]			,0.)		as  	 [Period 5 Forecast 2 Amount]			
						,ISNULL([Period 6 Forecast 2 Amount]			,0.)		as  	 [Period 6 Forecast 2 Amount]			
						,ISNULL([Period 7 Forecast 2 Amount]			,0.)		as  	 [Period 7 Forecast 2 Amount]			
						,ISNULL([Period 8 Forecast 2 Amount]			,0.)		as  	 [Period 8 Forecast 2 Amount]			
						,ISNULL([Period 9 Forecast 2 Amount]			,0.)		as  	 [Period 9 Forecast 2 Amount]			
						,ISNULL([Period 10 Forecast 2 Amount]			,0.)		as  	 [Period 10 Forecast 2 Amount]			
						,ISNULL([Period 11 Forecast 2 Amount]			,0.)		as  	 [Period 11 Forecast 2 Amount]			
						,ISNULL([Period 12 Forecast 2 Amount]			,0.)		as  	 [Period 12 Forecast 2 Amount]			
						,ISNULL([Period 1 Forecast 3 Amount]			,0.)		as  	 [Period 1 Forecast 3 Amount]			
						,ISNULL([Period 2 Forecast 3 Amount]			,0.)		as  	 [Period 2 Forecast 3 Amount]			
						,ISNULL([Period 3 Forecast 3 Amount]			,0.)		as  	 [Period 3 Forecast 3 Amount]			
						,ISNULL([Period 4 Forecast 3 Amount]			,0.)		as  	 [Period 4 Forecast 3 Amount]			
						,ISNULL([Period 5 Forecast 3 Amount]			,0.)		as  	 [Period 5 Forecast 3 Amount]			
						,ISNULL([Period 6 Forecast 3 Amount]			,0.)		as  	 [Period 6 Forecast 3 Amount]			
						,ISNULL([Period 7 Forecast 3 Amount]			,0.)		as  	 [Period 7 Forecast 3 Amount]			
						,ISNULL([Period 8 Forecast 3 Amount]			,0.)		as  	 [Period 8 Forecast 3 Amount]			
						,ISNULL([Period 9 Forecast 3 Amount]			,0.)		as  	 [Period 9 Forecast 3 Amount]			
						,ISNULL([Period 10 Forecast 3 Amount]			,0.)		as  	 [Period 10 Forecast 3 Amount]			
						,ISNULL([Period 11 Forecast 3 Amount]			,0.)		as  	 [Period 11 Forecast 3 Amount]			
						,ISNULL([Period 12 Forecast 3 Amount]			,0.)		as  	 [Period 12 Forecast 3 Amount]			
						,ISNULL(NYBudget 								,0.)		as  	 NYBudget 								
						,ISNULL(PYActual  								,0.)		as  	 PYActual  								
						,ISNULL(NRCTE.[Current_Net_Revenues]			,0.)		as  	 [Current_Net_Revenues]			
						,ISNULL(NRCTE.Budget_Current_Net_Revenues		,0.)		as  	 Budget_Current_Net_Revenues		
						,ISNULL(NRCTE.Forecast_Current_Net_Revenues_Q1	,0.)		as  	 Forecast_Current_Net_Revenues_Q1	
						,ISNULL(NRCTE.Forecast_Current_Net_Revenues_Q2	,0.)		as  	 Forecast_Current_Net_Revenues_Q2	
						,ISNULL(NRCTE.Forecast_Current_Net_Revenues_Q3	,0.)		as  	 Forecast_Current_Net_Revenues_Q3	
						,ISNULL(NRCTE.YTD_Net_Revenues					,0.)		as  	 YTD_Net_Revenues					
						,ISNULL(NRCTE.Budget_YTD_Net_Revenues			,0.)		as  	 Budget_YTD_Net_Revenues			
						,ISNULL(NRCTE.Forecast_YTD_Net_Revenues_Q1		,0.)		as  	 Forecast_YTD_Net_Revenues_Q1		
						,ISNULL(NRCTE.Forecast_YTD_Net_Revenues_Q2		,0.)		as  	 Forecast_YTD_Net_Revenues_Q2		
						,ISNULL(NRCTE.Forecast_YTD_Net_Revenues_Q3		,0.)		as  	 Forecast_YTD_Net_Revenues_Q3		
						,ISNULL(NRCTE.[Budget_Amount_Net_Revenues]		,0.)		as  	 [Budget_Amount_Net_Revenues]		
						,ISNULL(DLCTE.[Current_Direct_Labor]			,0.)		as  	 [Current_Direct_Labor]			
						,ISNULL(DLCTE.Budget_Current_Direct_Labor		,0.)		as  	 Budget_Current_Direct_Labor		
						,ISNULL(DLCTE.Forecast_Current_Direct_Labor_Q1	,0.)		as  	 Forecast_Current_Direct_Labor_Q1	
						,ISNULL(DLCTE.Forecast_Current_Direct_Labor_Q2	,0.)		as  	 Forecast_Current_Direct_Labor_Q2	
						,ISNULL(DLCTE.Forecast_Current_Direct_Labor_Q3	,0.)		as  	 Forecast_Current_Direct_Labor_Q3	
						,ISNULL(DLCTE.YTD_Direct_Labor					,0.)		as  	 YTD_Direct_Labor					
						,ISNULL(DLCTE.Budget_YTD_Direct_Labor			,0.)		as  	 Budget_YTD_Direct_Labor			
						,ISNULL(DLCTE.Forecast_YTD_Direct_Labor_Q1		,0.)		as  	 Forecast_YTD_Direct_Labor_Q1		
						,ISNULL(DLCTE.Forecast_YTD_Direct_Labor_Q2		,0.)		as  	 Forecast_YTD_Direct_Labor_Q2		
						,ISNULL(DLCTE.Forecast_YTD_Direct_Labor_Q3		,0.)		as  	 Forecast_YTD_Direct_Labor_Q3		
						,ISNULL(DLCTE.Budget_Amount_Direct_Labor		,0.)		as  	 Budget_Amount_Direct_Labor		
						,ISNULL(FBCTE.Current_FringeBenefits			,0.)		as  	 Current_FringeBenefits			
						,ISNULL(FBCTE.Budget_Current_FringeBenefits		,0.)		as  	 Budget_Current_FringeBenefits		
						,ISNULL(FBCTE.Forecast_Current_FringeBenefits_Q1,0.)		as  	 Forecast_Current_FringeBenefits_Q1
						,ISNULL(FBCTE.Forecast_Current_FringeBenefits_Q2,0.)		as  	 Forecast_Current_FringeBenefits_Q2
						,ISNULL(FBCTE.Forecast_Current_FringeBenefits_Q3,0.)		as  	 Forecast_Current_FringeBenefits_Q3
						,ISNULL(FBCTE.YTD_FringeBenefits				,0.)		as  	 YTD_FringeBenefits				
						,ISNULL(FBCTE.Budget_YTD_FringeBenefits			,0.)		as  	 Budget_YTD_FringeBenefits			
						,ISNULL(FBCTE.Forecast_YTD_FringeBenefits_Q1	,0.)		as  	 Forecast_YTD_FringeBenefits_Q1	
						,ISNULL(FBCTE.Forecast_YTD_FringeBenefits_Q2	,0.)		as  	 Forecast_YTD_FringeBenefits_Q2	
						,ISNULL(FBCTE.Forecast_YTD_FringeBenefits_Q3	,0.)		as  	 Forecast_YTD_FringeBenefits_Q3	
						,ISNULL(FBCTE.Budget_Amount_FringeBenefits		,0.)		as  	 Budget_Amount_FringeBenefits		
						,ISNULL(SACTE.Current_Salaries					,0.)		as  	 Current_Salaries					
						,ISNULL(SACTE.Budget_Current_Salaries			,0.)		as  	 Budget_Current_Salaries			
						,ISNULL(SACTE.Forecast_Current_Salaries_Q1		,0.)		as  	 Forecast_Current_Salaries_Q1		
						,ISNULL(SACTE.Forecast_Current_Salaries_Q2		,0.)		as  	 Forecast_Current_Salaries_Q2		
						,ISNULL(SACTE.Forecast_Current_Salaries_Q3		,0.)		as  	 Forecast_Current_Salaries_Q3		
						,ISNULL(SACTE.YTD_Salaries						,0.)		as  	 YTD_Salaries						
						,ISNULL(SACTE.Budget_YTD_Salaries				,0.)		as  	 Budget_YTD_Salaries				
						,ISNULL(SACTE.Forecast_YTD_Salaries_Q1			,0.)		as  	 Forecast_YTD_Salaries_Q1			
						,ISNULL(SACTE.Forecast_YTD_Salaries_Q2			,0.)		as  	 Forecast_YTD_Salaries_Q2			
						,ISNULL(SACTE.Forecast_YTD_Salaries_Q3			,0.)		as  	 Forecast_YTD_Salaries_Q3			
						,ISNULL(SACTE.Budget_Amount_Salaries			,0.)		as  	 Budget_Amount_Salaries			
						,ISNULL(EBGECTE.Current_EBGE					,0.)		as  	 Current_EBGE					
						,ISNULL(EBGECTE.Budget_Current_EBGE				,0.)		as  	 Budget_Current_EBGE				
						,ISNULL(EBGECTE.Forecast_Current_EBGE_Q1		,0.)		as  	 Forecast_Current_EBGE_Q1		
						,ISNULL(EBGECTE.Forecast_Current_EBGE_Q2		,0.)		as  	 Forecast_Current_EBGE_Q2		
						,ISNULL(EBGECTE.Forecast_Current_EBGE_Q3		,0.)		as  	 Forecast_Current_EBGE_Q3		
						,ISNULL(EBGECTE.YTD_EBGE						,0.)		as  	 YTD_EBGE						
						,ISNULL(EBGECTE.Budget_YTD_EBGE					,0.)		as  	 Budget_YTD_EBGE					
						,ISNULL(EBGECTE.Forecast_YTD_EBGE_Q1			,0.)		as  	 Forecast_YTD_EBGE_Q1			
						,ISNULL(EBGECTE.Forecast_YTD_EBGE_Q2			,0.)		as  	 Forecast_YTD_EBGE_Q2			
						,ISNULL(EBGECTE.Forecast_YTD_EBGE_Q3			,0.)		as  	 Forecast_YTD_EBGE_Q3			
						,ISNULL(EBGECTE.Budget_Amount_EBGE				,0.)		as  	 Budget_Amount_EBGE				
						,ISNULL(EBRECTE.Current_EBRE					,0.)		as  	 Current_EBRE					
						,ISNULL(EBRECTE.Budget_Current_EBRE				,0.)		as  	 Budget_Current_EBRE				
						,ISNULL(EBRECTE.Forecast_Current_EBRE_Q1		,0.)		as  	 Forecast_Current_EBRE_Q1		
						,ISNULL(EBRECTE.Forecast_Current_EBRE_Q2		,0.)		as  	 Forecast_Current_EBRE_Q2		
						,ISNULL(EBRECTE.Forecast_Current_EBRE_Q3		,0.)		as  	 Forecast_Current_EBRE_Q3		
						,ISNULL(EBRECTE.YTD_EBRE						,0.)		as  	 YTD_EBRE						
						,ISNULL(EBRECTE.Budget_YTD_EBRE					,0.)		as  	 Budget_YTD_EBRE					
						,ISNULL(EBRECTE.Forecast_YTD_EBRE_Q1			,0.)		as  	 Forecast_YTD_EBRE_Q1			
						,ISNULL(EBRECTE.Forecast_YTD_EBRE_Q2			,0.)		as  	 Forecast_YTD_EBRE_Q2			
						,ISNULL(EBRECTE.Forecast_YTD_EBRE_Q3			,0.)		as  	 Forecast_YTD_EBRE_Q3			
						,ISNULL(EBRECTE.Budget_Amount_EBRE				,0.)		as  	 Budget_Amount_EBRE				
						,ISNULL(EBITDACTE.Current_EBITDA				,0.)		as  	 Current_EBITDA				
						,ISNULL(EBITDACTE.Budget_Current_EBITDA			,0.)		as  	 Budget_Current_EBITDA			
						,ISNULL(EBITDACTE.Forecast_Current_EBITDA_Q1	,0.)		as  	 Forecast_Current_EBITDA_Q1	
						,ISNULL(EBITDACTE.Forecast_Current_EBITDA_Q2	,0.)		as  	 Forecast_Current_EBITDA_Q2	
						,ISNULL(EBITDACTE.Forecast_Current_EBITDA_Q3	,0.)		as  	 Forecast_Current_EBITDA_Q3	
						,ISNULL(EBITDACTE.YTD_EBITDA					,0.)		as  	 YTD_EBITDA					
						,ISNULL(EBITDACTE.Budget_YTD_EBITDA				,0.)		as  	 Budget_YTD_EBITDA				
						,ISNULL(EBITDACTE.Forecast_YTD_EBITDA_Q1		,0.)		as  	 Forecast_YTD_EBITDA_Q1		
						,ISNULL(EBITDACTE.Forecast_YTD_EBITDA_Q2		,0.)		as  	 Forecast_YTD_EBITDA_Q2		
						,ISNULL(EBITDACTE.Forecast_YTD_EBITDA_Q3		,0.)		as  	 Forecast_YTD_EBITDA_Q3		
						,ISNULL(EBITDACTE.Budget_Amount_EBITDA			,0.)     	as    	 Budget_Amount_EBITDA			
					FROM (Select OrganizationID
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
							Cross JOIN [dbo].[DimOrganization]	
							--Cross JOIN [dbo].[DimAccount]
							WHERE OrgSkey IN	( Select * from dbo.STRING_SPLIT(@pOrg, ','))	
							)Template
					LEFT OUTER JOIN ProfitandLossCTE as PCTE ON Template.TemplateID = PCTE.TemplateID
														AND Template.AccountID = PCTE.AccountID
														AND Template.GroupID = PCTE.GroupId
														AND Template.OrganizationID = PCTE.OrganizationID
					 LEFT OUTER JOIN(
						Select  OrganizationID
								, [Current Month Amount] as [Current_Net_Revenues]
							   ,[Current Month Budget Amount] as   [Budget_Current_Net_Revenues]
							   ,[Current Month Forecast 1 Amount] as [Forecast_Current_Net_Revenues_Q1]
							   ,[Current Month Forecast 2 Amount] as [Forecast_Current_Net_Revenues_Q2]
							   ,[Current Month Forecast 3 Amount] as [Forecast_Current_Net_Revenues_Q3]
							   ,[YTD Amount]  as [YTD_Net_Revenues]
							   ,[YTD Budget Amount]  as [Budget_YTD_Net_Revenues]
							   ,[YTD Forecast 1 Amount] as  [Forecast_YTD_Net_Revenues_Q1]
							   ,[YTD Forecast 2 Amount] as  [Forecast_YTD_Net_Revenues_Q2]
							   ,[YTD Forecast 3 Amount] as  [Forecast_YTD_Net_Revenues_Q3]
							   ,[Current Year Budget Amount] as [Budget_Amount_Net_Revenues]
						FROM ProfitandLossCTE 
						WHERE [IsNetRevenues] = 'Y')NRCTE
							ON Template.OrganizationID = NRCTE.OrganizationID --on PCTE.GroupId in (106,95,108,96) = NRCTE.GroupId
						
				LEFT OUTER JOIN (
							Select  OrganizationID
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
						FROM ProfitandLossCTE 
						WHERE [IsDirectLabor] = 'Y'
								   )DLCTE on 
								   Template.OrganizationID = DLCTE.OrganizationID
								   --AND Template.GroupId in (94,95,96,100,106,108)
								
				  LEFT OUTER JOIN (
							Select OrganizationID
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
						FROM ProfitandLossCTE 
						WHERE [IsFringeBenefits] = 'Y'
								   )FBCTE on  Template.OrganizationID = FBCTE.OrganizationID
									--AND Template.GroupId in (94,95,96,100,106,108)
			


						LEFT OUTER JOIN ( 
							Select  OrganizationID
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
						FROM ProfitandLossCTE 
						WHERE [IsDirectLabor] = 'Y' OR [IsManagementSalaries] = 'Y'
							 OR [IsMarketingSalaries] = 'Y' OR [IsTrainingSalaries] = 'Y'
							 GROUP BY OrganizationID
								   )SACTE on Template.OrganizationID = SACTE.OrganizationID
								   --AND Template.GroupId in (94,95,96,100,106,108)
					   

						LEFT OUTER JOIN (
							Select  OrganizationID
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
						FROM ProfitandLossCTE 
						WHERE [IsEBGE] = 'Y'
								   )EBGECTE on Template.OrganizationID = EBGECTE.OrganizationID
									AND Template.GroupId in (94,95,96,100,106,108)
						LEFT OUTER JOIN (
							Select  OrganizationID
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
						FROM ProfitandLossCTE 
						WHERE [IsEBRE] = 'Y'
								   )EBRECTE on Template.OrganizationID = EBRECTE.OrganizationID
									AND Template.GroupId in (94,95,96,100,106,108)
						LEFT OUTER JOIN (
							Select  OrganizationID
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
						FROM ProfitandLossCTE 
						WHERE [IsEBITDA] = 'Y'
								   )EBITDACTE on Template.OrganizationID = EBITDACTE.OrganizationID
								   --AND Template.GroupId in (94,95,96,100,106,108)

					 Order by Template.OrganizationID,Template.SortOrder,  Template.GroupID,  Template.GroupDesc ,Template.AccountID
			
					-- PCTE.OrganizationID, SortOrder,GroupId, GroupDesc
	






		
GO

