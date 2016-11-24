USE [BIDataWarehouse]
GO

/****** Object:  StoredProcedure [dbo].[usp_ProfitandLossSummaryFact_QuarterlyReportReforecast]    Script Date: 24/11/2016 11:10:38 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


 
CREATE Procedure [dbo].[usp_ProfitandLossSummaryFact_QuarterlyReportReforecast] 
	@pCurrency varchar(5),
	@pFiscalPeriod int,
	@pTemplate int,
	@pLanguage int,
	@pOrg varchar(max),
	@pGroup1Level varchar(20),
	@pSummaryDetail varchar(1)
	AS 
Declare @FuncCurrency as Varchar(5);
Declare @ConsCurrency as Varchar(5);
Declare @ENLanguage as int;
Declare @FRLanguage as int;
SET @FuncCurrency = 'FUNC';
SET @ConsCurrency = 'CONS';
SET @ENLanguage = 1;
SET @FRLanguage = 2; 
if @pSummaryDetail = 'S' 
BEGIN

		WITH ProfitandLossCTE (TemplateID, Group1Level,Group1LevelID , GroupID ,GroupDesc,[HeaderLine],[ShowDetail],[InsertSkipLineBefore],[SkipLine]
					,[IsMarkup] ,[IsNetRevenues],[IsDirectLabor],[IsFringeBenefitsPct],[IsFringeBenefits]
					,[IsManagementSalaries],[IsMarketingSalaries],[IsTrainingSalaries],[IsEBGEPct],[IsEBGE]
					,[IsEBREPct],[IsEBRE],[IsEBITDAPct],[IsEBITDA] ,[IsCalculatedUtilizationPct],SortOrder,FiscalPeriodNumber
					,[Current Month Amount]				--Current
					,[Current Month Budget Amount]		--Budget
					,[YTD Amount]						--YTD
					,[YTD Budget Amount]				--Budget YTD
					,[LY Current Month Amount]			--Prior Year Current 
					,[LY YTD Amount]					--Prior Year YTD				
					,[QTD Amount]						--Quarter
					,[QTD Budget Amount]				--Budget Quarter
					,[Prior Year QTD Amount]			--Prior Year Quarter
					)
		AS
		(  
			SELECT  FT.TemplateID
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
			
					, Case @pCurrency  WHEN @ConsCurrency THEN SUM(PL.ConsYTDBudgetAmt * FT.IncomeStatementBudgetSign)
									   WHEN @FuncCurrency THEN SUM(PL.FuncYTDBudgetAmt * FT.IncomeStatementBudgetSign)
									   END as [YTD Budget Amount]
 
					,Case @pCurrency WHEN @ConsCurrency THEN SUM(PL.ConsLYCMAmt * FT.IncomeStatementActualSign)
					  WHEN @FuncCurrency THEN SUM(PL.FuncLYCMAmt * FT.IncomeStatementActualSign)
							END AS [LY Current Month Amount]
					,Case @pCurrency  WHEN @ConsCurrency THEN SUM(PL.ConsLYYTDAmt * FT.IncomeStatementActualSign)
										WHEN @FuncCurrency THEN SUM(PL.FuncLYYTDAmt * FT.IncomeStatementActualSign)
										Else 0
						END as [LY YTD Amount]
--Quarter
                  ,Case @pCurrency  WHEN @ConsCurrency THEN SUM(PL.[ConsQTDAmt] * FT.IncomeStatementActualSign)
										WHEN @FuncCurrency THEN SUM(PL.[FuncQTDAmt] * FT.IncomeStatementActualSign)
										Else 0
						end as [QTD Amount]
--Budget Quarter
				 ,Case @pCurrency  WHEN @ConsCurrency THEN SUM(PL.[ConsQTDBudgetAmt] * FT.IncomeStatementActualSign)
										WHEN @FuncCurrency THEN SUM(PL.[FuncQTDBudgetAmt] * FT.IncomeStatementActualSign)
										Else 0
						end as [QTD Budget Amount]				
--Prior Year Quarter
				,Case @pCurrency  WHEN @ConsCurrency THEN SUM(PL.[ConsLYQTDAmt] * FT.IncomeStatementActualSign)
										WHEN @FuncCurrency THEN SUM(PL.[FuncLYQTDAmt] * FT.IncomeStatementActualSign)
										Else 0	
						end as [Prior Year QTD Amount]
 	
		FROM        FactProfitAndLossSummary   AS PL 
				LEFT OUTER JOIN MapFinancialTemplate as FT   ON FT.AccountSkey = PL.AccountSkey 
				INNER JOIN [dbo].[DimOrganization] as DO ON PL.OrgSkey = DO.OrgSkey
				INNER JOIN DimCalendarPeriod AS CP ON PL.PostPeriodSkey = CP.FiscalPeriodSkey
		WHERE        (PL.PostPeriodSkey = @pFiscalPeriod) 
					AND (FT.TemplateID = @pTemplate)
					AND PL.OrgSkey IN	( Select * from dbo.STRING_SPLIT(@pOrg, ','))
					AND DO.GeographicRegionID IS NOT NULL
					--AND FT.GroupID IN (49,51)
					--AND HeaderLine = 'Y'
	--Filtered by Org, period and template
		GROUP BY	 FT.TemplateID
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
						,Case @pGroup1Level			WHEN 'I' THEN	[ProductLineID]
												WHEN 'B' THEN	[GeographicRegionID]
												WHEN 'C' THEN	[CompanyID]
												WHEN 'D' THEN	[RegionID]
												WHEN 'E' THEN	[MarketSegmentID]
												WHEN 'F' THEN	[SubMarketSegmentID]
												WHEN 'G' THEN	[LocationID]
												WHEN 'H' THEN	[BusinessUnitID]
												WHEN 'Z' THEN	'None'
												
							END
				 
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
					,[Current Month Amount]						 
					,[Current Month Budget Amount]				 
					,[YTD Amount]								 
					,[YTD Budget Amount]						 
					,[LY Current Month Amount]					 
					,[LY YTD Amount]							 
					,[QTD Amount]								 
					,[QTD Budget Amount]						 
					,[Prior Year QTD Amount]
					
					,NRCTE.[Current_Net_Revenues]		
					,NRCTE.Budget_Current_Net_Revenues
					,NRCTE.YTD_Net_Revenues
					,NRCTE.Budget_YTD_Net_Revenues
					,NRCTE.LY_Current_Net_Revenues
					,NRCTE.LY_YTD_Net_Revenues
					,NRCTE.[QTD_Net_Revenues]								 
					,NRCTE.[Budget_QTD_Net_Revenues]						 
					,NRCTE.[LY_QTD_Net_Revenues]

					,DLCTE.[Current_Direct_Labor]		
					,DLCTE.Budget_Current_Direct_Labor
					,DLCTE.YTD_Direct_Labor
					,DLCTE.Budget_YTD_Direct_Labor
					,DLCTE.LY_Current_Direct_Labor
					,DLCTE.LY_YTD_Direct_Labor
					,DLCTE.[QTD_Direct_Labor]			
					,DLCTE.[Budget_QTD_Direct_Labor]	
					,DLCTE.[LY_QTD_Direct_Labor]

					,FBCTE.[Current_FringeBenefits]		
					,FBCTE.Budget_Current_FringeBenefits
					,FBCTE.YTD_FringeBenefits
					,FBCTE.Budget_YTD_FringeBenefits
					,FBCTE.LY_Current_FringeBenefits
					,FBCTE.LY_YTD_FringeBenefits
					,FBCTE.[QTD_FringeBenefits]			
					,FBCTE.[Budget_QTD_FringeBenefits]	
					,FBCTE.[LY_QTD_FringeBenefits]

					,SACTE.[Current_Salaries]		
					,SACTE.Budget_Current_Salaries
					,SACTE.YTD_Salaries
					,SACTE.Budget_YTD_Salaries
					,SACTE.LY_Current_Salaries
					,SACTE.LY_YTD_Salaries
					,SACTE.[QTD_Salaries]			
					,SACTE.[Budget_QTD_Salaries]	
					,SACTE.[LY_QTD_Salaries]

					,EBGECTE.[Current_EBGE]		
					,EBGECTE.Budget_Current_EBGE
					,EBGECTE.YTD_EBGE
					,EBGECTE.Budget_YTD_EBGE
					,EBGECTE.LY_Current_EBGE
					,EBGECTE.LY_YTD_EBGE
					,EBGECTE.[QTD_EBGE]			
					,EBGECTE.[Budget_QTD_EBGE]	
					,EBGECTE.[LY_QTD_EBGE]

				    ,EBRECTE.[Current_EBRE]		
					,EBRECTE.Budget_Current_EBRE
					,EBRECTE.YTD_EBRE
					,EBRECTE.Budget_YTD_EBRE
					,EBRECTE.LY_Current_EBRE
					,EBRECTE.LY_YTD_EBRE
					,EBRECTE.[QTD_EBRE]			
					,EBRECTE.[Budget_QTD_EBRE]	
					,EBRECTE.[LY_QTD_EBRE]
				     
					,EBITDACTE.[Current_EBITDA]		
					,EBITDACTE.Budget_Current_EBITDA
					,EBITDACTE.YTD_EBITDA
					,EBITDACTE.Budget_YTD_EBITDA
					,EBITDACTE.LY_Current_EBITDA
					,EBITDACTE.LY_YTD_EBITDA
					,EBITDACTE.[QTD_EBITDA]			
					,EBITDACTE.[Budget_QTD_EBITDA]	
					,EBITDACTE.[LY_QTD_EBITDA]
					
				FROM 
			  (		SELECT Group1Level, Group1LevelID, Templ.*
			
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
							and GroupID in (49,51)
						)Templ
						 CROSS JOIN ( Select Distinct Group1Level,Group1LevelID
										FROM ProfitandLossCTE
										)DistGroup
						)Template	

				LEFT OUTER JOIN ProfitandLossCTE as PCTE ON Template.TemplateID = PCTE.TemplateID
													AND Template.GroupID = PCTE.GroupId
													AND Template.Group1level = PCTE.Group1level
 
				

				--ProfitandLossCTE as PCTE  
			 LEFT OUTER JOIN(
					Select  GroupID,Group1Level
					,[Current Month Amount]			 AS 	[Current_Net_Revenues]		
					,[Current Month Budget Amount]	 AS 	Budget_Current_Net_Revenues
					,[YTD Amount]					 AS 	YTD_Net_Revenues
					,[YTD Budget Amount]			 AS 	Budget_YTD_Net_Revenues
					,[LY Current Month Amount]		 AS 	LY_Current_Net_Revenues
					,[LY YTD Amount]				 AS 	LY_YTD_Net_Revenues
					,[QTD Amount]					 AS 	[QTD_Net_Revenues]			
					,[QTD Budget Amount]			 AS 	[Budget_QTD_Net_Revenues]	
					,[Prior Year QTD Amount]         AS   	[LY_QTD_Net_Revenues]
					FROM ProfitandLossCTE 
					WHERE [IsNetRevenues] = 'Y')NRCTE  on   --(Template.GroupId is not NULL)
														Template.Group1level = NRCTE.Group1level
 

			
				LEFT OUTER JOIN (
						Select GroupID,Group1Level
					,[Current Month Amount]			 AS 	 [Current_Direct_Labor]		
					,[Current Month Budget Amount]	 AS 	 Budget_Current_Direct_Labor
					,[YTD Amount]					 AS 	 YTD_Direct_Labor
					,[YTD Budget Amount]			 AS 	 Budget_YTD_Direct_Labor
					,[LY Current Month Amount]		 AS 	 LY_Current_Direct_Labor
					,[LY YTD Amount]				 AS 	 LY_YTD_Direct_Labor
					,[QTD Amount]					 AS 	 [QTD_Direct_Labor]			
					,[QTD Budget Amount]			 AS 	 [Budget_QTD_Direct_Labor]	
					,[Prior Year QTD Amount]         AS		 [LY_QTD_Direct_Labor]	   
					FROM ProfitandLossCTE 
					WHERE [IsDirectLabor] = 'Y'
							   )DLCTE on Template.GroupId in (94,95,96,100,106,108)
													AND Template.Group1level = DLCTE.Group1level
 
		
				 LEFT OUTER JOIN (
						Select GroupID,Group1Level 
                    ,[Current Month Amount]			 AS 	 [Current_FringeBenefits]		
                    ,[Current Month Budget Amount]	 AS 	 Budget_Current_FringeBenefits
                    ,[YTD Amount]					 AS 	 YTD_FringeBenefits
                    ,[YTD Budget Amount]			 AS 	 Budget_YTD_FringeBenefits
                    ,[LY Current Month Amount]		 AS 	 LY_Current_FringeBenefits
                    ,[LY YTD Amount]				 AS 	 LY_YTD_FringeBenefits
                    ,[QTD Amount]					 AS 	 [QTD_FringeBenefits]			
                    ,[QTD Budget Amount]			 AS 	 [Budget_QTD_FringeBenefits]	
                    ,[Prior Year QTD Amount]         AS		 [LY_QTD_FringeBenefits]				   
					FROM ProfitandLossCTE 
					WHERE [IsFringeBenefits] = 'Y'
							   )FBCTE on Template.GroupId  in (94,95,96,100,106,108)
													AND Template.Group1level = FBCTE.Group1level
 
					LEFT OUTER JOIN (
						Select Group1Level 
					,SUM([Current Month Amount])		 AS 	[Current_Salaries]		
					,SUM([Current Month Budget Amount])	 AS 	Budget_Current_Salaries
					,SUM([YTD Amount])					 AS 	YTD_Salaries
					,SUM([YTD Budget Amount])			 AS 	Budget_YTD_Salaries
					,SUM([LY Current Month Amount])		 AS 	LY_Current_Salaries
					,SUM([LY YTD Amount])				 AS 	LY_YTD_Salaries
					,SUM([QTD Amount])					 AS 	[QTD_Salaries]			
					,SUM([QTD Budget Amount])			 AS 	[Budget_QTD_Salaries]	
					,SUM([Prior Year QTD Amount] )       AS		[LY_QTD_Salaries]
					FROM ProfitandLossCTE 
					WHERE [IsDirectLabor] = 'Y' OR [IsManagementSalaries] = 'Y'
						 OR [IsMarketingSalaries] = 'Y' OR [IsTrainingSalaries] = 'Y'
						 GROUP BY  Group1Level 
							   )SACTE on Template.GroupId in (94,95,96,100,106,108)
													AND Template.Group1level = SACTE.Group1level
										 
				
				LEFT OUTER JOIN (
						Select GroupID,Group1Level 
					,[Current Month Amount]			 AS 	   [Current_EBGE]		
					,[Current Month Budget Amount]	 AS 	   Budget_Current_EBGE
					,[YTD Amount]					 AS 	   YTD_EBGE
					,[YTD Budget Amount]			 AS 	   Budget_YTD_EBGE
					,[LY Current Month Amount]		 AS 	   LY_Current_EBGE
					,[LY YTD Amount]				 AS 	   LY_YTD_EBGE
					,[QTD Amount]					 AS 	   [QTD_EBGE]			
					,[QTD Budget Amount]			 AS 	   [Budget_QTD_EBGE]	
					,[Prior Year QTD Amount]         AS	       [LY_QTD_EBGE] 
					FROM ProfitandLossCTE 
					WHERE [IsEBGE] = 'Y'
							   )EBGECTE on Template.GroupId in (94,95,96,100,106,108)
													AND Template.Group1level = EBGECTE.Group1level
 
				
					LEFT OUTER JOIN (
						Select GroupID,Group1Level 
 					,[Current Month Amount]			 AS 	   [Current_EBRE]		
					,[Current Month Budget Amount]	 AS 	   Budget_Current_EBRE
					,[YTD Amount]					 AS 	   YTD_EBRE
					,[YTD Budget Amount]			 AS 	   Budget_YTD_EBRE
					,[LY Current Month Amount]		 AS 	   LY_Current_EBRE
					,[LY YTD Amount]				 AS 	   LY_YTD_EBRE
					,[QTD Amount]					 AS 	   [QTD_EBRE]			
					,[QTD Budget Amount]			 AS 	   [Budget_QTD_EBRE]	
					,[Prior Year QTD Amount]         AS	       [LY_QTD_EBRE] 
					FROM ProfitandLossCTE 
					WHERE [IsEBRE] = 'Y'
							   )EBRECTE on Template.GroupId	in (94,95,96,100,106,108)
													AND Template.Group1level = EBRECTE.Group1level
 
			
				LEFT OUTER JOIN (
						Select GroupID,Group1Level 
					,[Current Month Amount]			 AS 				   [Current_EBITDA]		
					,[Current Month Budget Amount]	 AS 				   Budget_Current_EBITDA
					,[YTD Amount]					 AS 				   YTD_EBITDA
					,[YTD Budget Amount]			 AS 				   Budget_YTD_EBITDA
					,[LY Current Month Amount]		 AS 				   LY_Current_EBITDA
					,[LY YTD Amount]				 AS 				   LY_YTD_EBITDA
					,[QTD Amount]					 AS 				   [QTD_EBITDA]			
					,[QTD Budget Amount]			 AS 				   [Budget_QTD_EBITDA]	
					,[Prior Year QTD Amount]         AS	    			   [LY_QTD_EBITDA]
					FROM ProfitandLossCTE 
					WHERE [IsEBITDA] = 'Y'
							   )EBITDACTE on Template.GroupId  in (94,95,96,100,106,108) --EBITDACTE.GroupId
													AND Template.Group1level = EBITDACTE.Group1level
 
						              
					ORDER BY  Template.Group1Level ,Template.SortOrder,  Template.GroupID,  Template.GroupDesc
			
	
END




GO

