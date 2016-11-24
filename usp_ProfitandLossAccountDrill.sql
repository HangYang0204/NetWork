USE [BIDataWarehouse]
GO

/****** Object:  StoredProcedure [dbo].[usp_ProfitandLossAccountDrill]    Script Date: 24/11/2016 11:02:31 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE Procedure [dbo].[usp_ProfitandLossAccountDrill] 
	@pCurrency varchar(5),
	@pFiscalPeriod int,
	@pTemplate int,
	@pLanguage int,
	@pOrg varchar(max),
	@pGroup int
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
    SELECT      
			 AC.AccountID
			,ISNULL( ( Case @pLanguage When @ENLanguage THEN AC.AccountNameEN 
							  WHEN @FRLanguage THEN AC.AccountNameFR
							  Else 'Unknown'
				END),0.000000) as AccountDesc
					
			,FiscalPeriodNumber
			,ISNULL( ( Case @pCurrency  WHEN @ConsCurrency THEN SUM(PL.ConsCMAmt * FT.IncomeStatementActualSign) 
							   WHEN @FuncCurrency THEN SUM(PL.FuncCMAmt * FT.IncomeStatementActualSign)
							   Else 0.000000
			  END),0.000000) as [Current Month Amount]
			,ISNULL( ( Case @pCurrency  WHEN @ConsCurrency THEN SUM(PL.ConsCMBudgetAmt * FT.IncomeStatementBudgetSign)
							   WHEN @FuncCurrency THEN SUM(PL.FuncCMBudgetAmt * FT.IncomeStatementBudgetSign)
							   Else 0.000000
			  END),0.000000) as [Current Month Budget Amount]
			,ISNULL( (  Case @pCurrency  WHEN @ConsCurrency THEN SUM(PL.ConsYTDAmt * FT.IncomeStatementActualSign)
								WHEN @FuncCurrency THEN SUM(PL.FuncYTDAmt * FT.IncomeStatementActualSign)
								Else 0.000000
				END),0.000000) as [YTD Amount]
			,ISNULL( (SUM((Case @pCurrency  WHEN @ConsCurrency THEN PL.ConsCMFC1Amt 
							   WHEN @FuncCurrency THEN PL.FuncCMFC1Amt 
							   Else 0.000000
							   END) * 
					Case When CP.[FiscalPeriodNumber] <= 2 Then [IncomeStatementActualSign]  
								Else [IncomeStatementBudgetSign]
								END 
								)),0.000000) as [Current Month Forecast 1 Amount]
			,ISNULL( (SUM((Case @pCurrency  WHEN @ConsCurrency THEN PL.ConsCMFC2Amt 
							   WHEN @FuncCurrency THEN PL.FuncCMFC2Amt 
							   Else 0.000000
							   END) * 
					Case When CP.[FiscalPeriodNumber] <= 5 Then [IncomeStatementActualSign]  
								Else [IncomeStatementBudgetSign]
								END 
								)),0.000000) as [Current Month Forecast 2 Amount]
			,ISNULL( (SUM((Case @pCurrency  WHEN @ConsCurrency THEN PL.ConsCMFC1Amt 
							   WHEN @FuncCurrency THEN PL.FuncCMFC1Amt 
							   Else 0.000000
							   END) * 
					Case When CP.[FiscalPeriodNumber] <= 8 Then [IncomeStatementActualSign]  
								Else [IncomeStatementBudgetSign]
								END 
								)),0.000000) as [Current Month Forecast 3 Amount]
			,ISNULL( ( Case @pCurrency  WHEN @ConsCurrency THEN SUM(PL.ConsYTDBudgetAmt * FT.IncomeStatementBudgetSign)
							   WHEN @FuncCurrency THEN SUM(PL.FuncYTDBudgetAmt * FT.IncomeStatementBudgetSign)
							   END),0.000000) as [YTD Budget Amount]
			,ISNULL( ( Case @pCurrency  WHEN @ConsCurrency THEN SUM(PL.ConsCYBudgetAmt * FT.IncomeStatementBudgetSign) 
							   WHEN @FuncCurrency THEN SUM(PL.FuncCYBudgetAmt * FT.IncomeStatementBudgetSign)
							   END),0.000000) as [Current Year Budget Amount]
			,ISNULL( ( Case @pCurrency 
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
				END),0.000000) AS [YTD Forecast 1 Amount]
            
			 ,ISNULL( (Case @pCurrency WHEN @ConsCurrency THEN 
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
				END),0.000000) AS [YTD Forecast 2 Amount]
			  
           ,ISNULL( (Case @pCurrency WHEN @ConsCurrency THEN
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
					END),0.000000) AS [YTD Forecast 3 Amount]
FROM           
		FactProfitAndLossSummary AS PL 
		LEFT OUTER JOIN  MapFinancialTemplate AS FT  ON FT.AccountSkey = PL.AccountSkey 
		LEFT OUTER JOIN  DimAccount AS AC ON FT.AccountSkey = AC.AccountSkey
		INNER JOIN DimCalendarPeriod AS CP ON PL.PostPeriodSkey = CP.FiscalPeriodSkey
WHERE        (PL.PostPeriodSkey = @pFiscalPeriod) 
			AND (FT.TemplateID = @pTemplate)
			AND OrgSkey IN ( Select * from dbo.STRING_SPLIT(@pOrg, ','))
			AND [GroupID] in (@pGroup)
			--AND HeaderLine = 'Y'
	
GROUP BY		FT.AccountSkey  
				, Case @pLanguage When @ENLanguage THEN AC.AccountNameEN 
							  WHEN @FRLanguage THEN AC.AccountNameFR
							  Else 'Unknown'
				END 
			   ,CP.FiscalPeriodNumber, AC.AccountID
			
ORDER BY FT.AccountSkey, AccountDesc, CP.FiscalPeriodNumber
		

GO

