USE [BIDataWarehouse]
GO

/****** Object:  StoredProcedure [dbo].[usp_ProfitandLossAccountDrill_CorporateExpense]    Script Date: 24/11/2016 11:02:52 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE Procedure [dbo].[usp_ProfitandLossAccountDrill_CorporateExpense] 
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
			, Case @pLanguage When @ENLanguage THEN AC.AccountNameEN 
							  WHEN @FRLanguage THEN AC.AccountNameFR
							  Else 'Unknown'
				END as AccountDesc
					
			,FiscalPeriodNumber,DO.BusinessUnitID
					,ISNULL( ( Case @pCurrency  WHEN @ConsCurrency THEN 
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then SUM(PL.ConsCMAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then SUM(PL.ConsCMAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then SUM(PL.ConsCMAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then SUM(PL.ConsCMAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then SUM(PL.ConsCMAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then SUM(PL.ConsCMAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then SUM(PL.ConsCMAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then SUM(PL.ConsCMAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then SUM(PL.ConsCMAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then SUM(PL.ConsCMAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then SUM(PL.ConsCMAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then SUM(PL.ConsCMAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then SUM(PL.ConsCMAmt * FT.IncomeStatementActualSign) Else 0.000000 End  
												When FT.GroupID = -171 Then Case When (DO.BusinessUnitID <= '601' OR DO.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  DO.BusinessUnitID >= '701') AND DO.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then SUM(PL.ConsCMAmt * FT.IncomeStatementActualSign) Else 0.000000 End
												  Else SUM(PL.ConsCMAmt * FT.IncomeStatementActualSign)
											End					 
									   WHEN @FuncCurrency THEN 
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then SUM(PL.FuncCMAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then SUM(PL.FuncCMAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then SUM(PL.FuncCMAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then SUM(PL.FuncCMAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then SUM(PL.FuncCMAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then SUM(PL.FuncCMAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then SUM(PL.FuncCMAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then SUM(PL.FuncCMAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then SUM(PL.FuncCMAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then SUM(PL.FuncCMAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then SUM(PL.FuncCMAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then SUM(PL.FuncCMAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then SUM(PL.FuncCMAmt * FT.IncomeStatementActualSign) Else 0.000000 End  
												When FT.GroupID = -171 Then Case When (DO.BusinessUnitID <= '601' OR DO.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  DO.BusinessUnitID >= '701') AND DO.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then SUM(PL.FuncCMAmt * FT.IncomeStatementActualSign) Else 0.000000 End
												  Else SUM(PL.FuncCMAmt * FT.IncomeStatementActualSign)
											End	
										Else 0.000000
			  END),0.000000) as [Current Month Amount]
					,ISNULL( ( Case @pCurrency  WHEN @ConsCurrency THEN 
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then SUM(PL.ConsCMBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then SUM(PL.ConsCMBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then SUM(PL.ConsCMBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then SUM(PL.ConsCMBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then SUM(PL.ConsCMBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then SUM(PL.ConsCMBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then SUM(PL.ConsCMBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then SUM(PL.ConsCMBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then SUM(PL.ConsCMBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then SUM(PL.ConsCMBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then SUM(PL.ConsCMBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then SUM(PL.ConsCMBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then SUM(PL.ConsCMBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End  
												When FT.GroupID = -171 Then Case When (DO.BusinessUnitID <= '601' OR DO.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  DO.BusinessUnitID >= '701') AND DO.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then SUM(PL.ConsCMBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End
												  Else SUM(PL.ConsCMBudgetAmt * FT.IncomeStatementBudgetSign)
											End					 
									   WHEN @FuncCurrency THEN 
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then SUM(PL.FuncCMBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then SUM(PL.FuncCMBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then SUM(PL.FuncCMBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then SUM(PL.FuncCMBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then SUM(PL.FuncCMBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then SUM(PL.FuncCMBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then SUM(PL.FuncCMBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then SUM(PL.FuncCMBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then SUM(PL.FuncCMBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then SUM(PL.FuncCMBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then SUM(PL.FuncCMBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then SUM(PL.FuncCMBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then SUM(PL.FuncCMBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End  
												When FT.GroupID = -171 Then Case When (DO.BusinessUnitID <= '601' OR DO.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  DO.BusinessUnitID >= '701') AND DO.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then SUM(PL.FuncCMBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End
												  Else SUM(PL.FuncCMBudgetAmt * FT.IncomeStatementBudgetSign)
											End	
										Else 0.000000
			  END),0.000000) as [Current Month Budget Amount]
					,ISNULL( ( Case @pCurrency  WHEN @ConsCurrency THEN 
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then SUM(PL.ConsYTDAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then SUM(PL.ConsYTDAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then SUM(PL.ConsYTDAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then SUM(PL.ConsYTDAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then SUM(PL.ConsYTDAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then SUM(PL.ConsYTDAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then SUM(PL.ConsYTDAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then SUM(PL.ConsYTDAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then SUM(PL.ConsYTDAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then SUM(PL.ConsYTDAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then SUM(PL.ConsYTDAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then SUM(PL.ConsYTDAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then SUM(PL.ConsYTDAmt * FT.IncomeStatementActualSign) Else 0.000000 End  
												When FT.GroupID = -171 Then Case When (DO.BusinessUnitID <= '601' OR DO.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  DO.BusinessUnitID >= '701') AND DO.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then SUM(PL.ConsYTDAmt * FT.IncomeStatementActualSign) Else 0.000000 End
												  Else SUM(PL.ConsYTDAmt * FT.IncomeStatementActualSign)
											End					 
									   WHEN @FuncCurrency THEN 
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then SUM(PL.FuncYTDAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then SUM(PL.FuncYTDAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then SUM(PL.FuncYTDAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then SUM(PL.FuncYTDAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then SUM(PL.FuncYTDAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then SUM(PL.FuncYTDAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then SUM(PL.FuncYTDAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then SUM(PL.FuncYTDAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then SUM(PL.FuncYTDAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then SUM(PL.FuncYTDAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then SUM(PL.FuncYTDAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then SUM(PL.FuncYTDAmt * FT.IncomeStatementActualSign) Else 0.000000 End 
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then SUM(PL.FuncYTDAmt * FT.IncomeStatementActualSign) Else 0.000000 End  
												When FT.GroupID = -171 Then Case When (DO.BusinessUnitID <= '601' OR DO.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  DO.BusinessUnitID >= '701') AND DO.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then SUM(PL.FuncYTDAmt * FT.IncomeStatementActualSign) Else 0.000000 End
												  Else SUM(PL.FuncYTDAmt * FT.IncomeStatementActualSign)
											End	
										Else 0.000000
				END),0.000000) as [YTD Amount]
					,ISNULL( ( SUM((Case @pCurrency  WHEN @ConsCurrency THEN 
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then (PL.ConsCMFC1Amt) Else 0.000000 End 
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then (PL.ConsCMFC1Amt) Else 0.000000 End 
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then (PL.ConsCMFC1Amt) Else 0.000000 End 
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then (PL.ConsCMFC1Amt) Else 0.000000 End 
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then (PL.ConsCMFC1Amt) Else 0.000000 End 
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then (PL.ConsCMFC1Amt) Else 0.000000 End 
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then (PL.ConsCMFC1Amt) Else 0.000000 End 
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then (PL.ConsCMFC1Amt) Else 0.000000 End 
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then (PL.ConsCMFC1Amt) Else 0.000000 End 
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then (PL.ConsCMFC1Amt) Else 0.000000 End 
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then (PL.ConsCMFC1Amt) Else 0.000000 End 
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then (PL.ConsCMFC1Amt) Else 0.000000 End 
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then (PL.ConsCMFC1Amt) Else 0.000000 End  
												When FT.GroupID = -171 Then Case When (DO.BusinessUnitID <= '601' OR DO.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  DO.BusinessUnitID >= '701') AND DO.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then (PL.ConsCMFC1Amt) Else 0.000000 End
												  Else (PL.ConsCMFC1Amt)
											End					 
									   WHEN @FuncCurrency THEN 
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then (PL.FuncCMFC1Amt) Else 0.000000 End 
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then (PL.FuncCMFC1Amt) Else 0.000000 End 
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then (PL.FuncCMFC1Amt) Else 0.000000 End 
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then (PL.FuncCMFC1Amt) Else 0.000000 End 
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then (PL.FuncCMFC1Amt) Else 0.000000 End 
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then (PL.FuncCMFC1Amt) Else 0.000000 End 
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then (PL.FuncCMFC1Amt) Else 0.000000 End 
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then (PL.FuncCMFC1Amt) Else 0.000000 End 
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then (PL.FuncCMFC1Amt) Else 0.000000 End 
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then (PL.FuncCMFC1Amt) Else 0.000000 End 
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then (PL.FuncCMFC1Amt) Else 0.000000 End 
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then (PL.FuncCMFC1Amt) Else 0.000000 End 
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then (PL.FuncCMFC1Amt) Else 0.000000 End  
												When FT.GroupID = -171 Then Case When (DO.BusinessUnitID <= '601' OR DO.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  DO.BusinessUnitID >= '701') AND DO.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then (PL.FuncCMFC1Amt) Else 0.000000 End
												  Else (PL.FuncCMFC1Amt)
											End	
										Else 0.000000
									   END) * 
							Case When CP.[FiscalPeriodNumber] <= 2 Then [IncomeStatementActualSign]  
										Else [IncomeStatementBudgetSign]
										END 
								)),0.000000) as [Current Month Forecast 1 Amount]
					,ISNULL( (SUM((Case @pCurrency  WHEN @ConsCurrency THEN 
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then (PL.ConsCMFC2Amt) Else 0.000000 End 
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then (PL.ConsCMFC2Amt) Else 0.000000 End 
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then (PL.ConsCMFC2Amt) Else 0.000000 End 
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then (PL.ConsCMFC2Amt) Else 0.000000 End 
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then (PL.ConsCMFC2Amt) Else 0.000000 End 
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then (PL.ConsCMFC2Amt) Else 0.000000 End 
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then (PL.ConsCMFC2Amt) Else 0.000000 End 
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then (PL.ConsCMFC2Amt) Else 0.000000 End 
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then (PL.ConsCMFC2Amt) Else 0.000000 End 
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then (PL.ConsCMFC2Amt) Else 0.000000 End 
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then (PL.ConsCMFC2Amt) Else 0.000000 End 
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then (PL.ConsCMFC2Amt) Else 0.000000 End 
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then (PL.ConsCMFC2Amt) Else 0.000000 End  
												When FT.GroupID = -171 Then Case When (DO.BusinessUnitID <= '601' OR DO.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  DO.BusinessUnitID >= '701') AND DO.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then (PL.ConsCMFC2Amt) Else 0.000000 End
												  Else (PL.ConsCMFC2Amt)
											End					 
									   WHEN @FuncCurrency THEN 
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then (PL.FuncCMFC2Amt) Else 0.000000 End 
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then (PL.FuncCMFC2Amt) Else 0.000000 End 
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then (PL.FuncCMFC2Amt) Else 0.000000 End 
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then (PL.FuncCMFC2Amt) Else 0.000000 End 
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then (PL.FuncCMFC2Amt) Else 0.000000 End 
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then (PL.FuncCMFC2Amt) Else 0.000000 End 
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then (PL.FuncCMFC2Amt) Else 0.000000 End 
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then (PL.FuncCMFC2Amt) Else 0.000000 End 
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then (PL.FuncCMFC2Amt) Else 0.000000 End 
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then (PL.FuncCMFC2Amt) Else 0.000000 End 
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then (PL.FuncCMFC2Amt) Else 0.000000 End 
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then (PL.FuncCMFC2Amt) Else 0.000000 End 
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then (PL.FuncCMFC2Amt) Else 0.000000 End  
												When FT.GroupID = -171 Then Case When (DO.BusinessUnitID <= '601' OR DO.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  DO.BusinessUnitID >= '701') AND DO.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then (PL.FuncCMFC2Amt) Else 0.000000 End
												  Else (PL.FuncCMFC2Amt)
											End	
										Else 0.000000
									   END) * 
							Case When CP.[FiscalPeriodNumber] <= 5 Then [IncomeStatementActualSign]  
										Else [IncomeStatementBudgetSign]
										END 
								)),0.000000) as [Current Month Forecast 2 Amount]
					,ISNULL( (SUM((Case @pCurrency  WHEN @ConsCurrency THEN 
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then (PL.ConsCMFC3Amt) Else 0.000000 End 
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then (PL.ConsCMFC3Amt) Else 0.000000 End 
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then (PL.ConsCMFC3Amt) Else 0.000000 End 
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then (PL.ConsCMFC3Amt) Else 0.000000 End 
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then (PL.ConsCMFC3Amt) Else 0.000000 End 
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then (PL.ConsCMFC3Amt) Else 0.000000 End 
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then (PL.ConsCMFC3Amt) Else 0.000000 End 
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then (PL.ConsCMFC3Amt) Else 0.000000 End 
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then (PL.ConsCMFC3Amt) Else 0.000000 End 
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then (PL.ConsCMFC3Amt) Else 0.000000 End 
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then (PL.ConsCMFC3Amt) Else 0.000000 End 
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then (PL.ConsCMFC3Amt) Else 0.000000 End 
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then (PL.ConsCMFC3Amt) Else 0.000000 End  
												When FT.GroupID = -171 Then Case When (DO.BusinessUnitID <= '601' OR DO.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  DO.BusinessUnitID >= '701') AND DO.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then (PL.ConsCMFC3Amt) Else 0.000000 End
												  Else (PL.ConsCMFC3Amt)
											End					 
									   WHEN @FuncCurrency THEN 
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then (PL.FuncCMFC3Amt) Else 0.000000 End 
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then (PL.FuncCMFC3Amt) Else 0.000000 End 
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then (PL.FuncCMFC3Amt) Else 0.000000 End 
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then (PL.FuncCMFC3Amt) Else 0.000000 End 
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then (PL.FuncCMFC3Amt) Else 0.000000 End 
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then (PL.FuncCMFC3Amt) Else 0.000000 End 
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then (PL.FuncCMFC3Amt) Else 0.000000 End 
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then (PL.FuncCMFC3Amt) Else 0.000000 End 
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then (PL.FuncCMFC3Amt) Else 0.000000 End 
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then (PL.FuncCMFC3Amt) Else 0.000000 End 
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then (PL.FuncCMFC3Amt) Else 0.000000 End 
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then (PL.FuncCMFC3Amt) Else 0.000000 End 
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then (PL.FuncCMFC3Amt) Else 0.000000 End  
												When FT.GroupID = -171 Then Case When (DO.BusinessUnitID <= '601' OR DO.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  DO.BusinessUnitID >= '701') AND DO.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then (PL.FuncCMFC3Amt) Else 0.000000 End
												  Else (PL.FuncCMFC3Amt)
											End	
										Else 0.000000
									   END) * 
							Case When CP.[FiscalPeriodNumber] <= 8 Then [IncomeStatementActualSign]  
										Else [IncomeStatementBudgetSign]
										END 
								)),0.000000) as [Current Month Forecast 3 Amount]
					,ISNULL( ( Case @pCurrency  WHEN @ConsCurrency THEN 
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then SUM(PL.ConsYTDBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then SUM(PL.ConsYTDBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then SUM(PL.ConsYTDBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then SUM(PL.ConsYTDBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then SUM(PL.ConsYTDBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then SUM(PL.ConsYTDBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then SUM(PL.ConsYTDBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then SUM(PL.ConsYTDBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then SUM(PL.ConsYTDBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then SUM(PL.ConsYTDBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then SUM(PL.ConsYTDBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then SUM(PL.ConsYTDBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then SUM(PL.ConsYTDBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End  
												When FT.GroupID = -171 Then Case When (DO.BusinessUnitID <= '601' OR DO.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  DO.BusinessUnitID >= '701') AND DO.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then SUM(PL.ConsYTDBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End
												  Else SUM(PL.ConsYTDBudgetAmt * FT.IncomeStatementBudgetSign)
											End					 
									   WHEN @FuncCurrency THEN 
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then SUM(PL.FuncYTDBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then SUM(PL.FuncYTDBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then SUM(PL.FuncYTDBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then SUM(PL.FuncYTDBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then SUM(PL.FuncYTDBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then SUM(PL.FuncYTDBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then SUM(PL.FuncYTDBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then SUM(PL.FuncYTDBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then SUM(PL.FuncYTDBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then SUM(PL.FuncYTDBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then SUM(PL.FuncYTDBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then SUM(PL.FuncYTDBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then SUM(PL.FuncYTDBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End  
												When FT.GroupID = -171 Then Case When (DO.BusinessUnitID <= '601' OR DO.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  DO.BusinessUnitID >= '701') AND DO.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then SUM(PL.FuncYTDBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End
												  Else SUM(PL.FuncYTDBudgetAmt * FT.IncomeStatementBudgetSign)
											End	
										Else 0.000000
							   END),0.000000) as [YTD Budget Amount]
					,ISNULL( ( Case @pCurrency  WHEN @ConsCurrency THEN 
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then SUM(PL.ConsCYBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then SUM(PL.ConsCYBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then SUM(PL.ConsCYBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then SUM(PL.ConsCYBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then SUM(PL.ConsCYBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then SUM(PL.ConsCYBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then SUM(PL.ConsCYBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then SUM(PL.ConsCYBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then SUM(PL.ConsCYBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then SUM(PL.ConsCYBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then SUM(PL.ConsCYBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then SUM(PL.ConsCYBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then SUM(PL.ConsCYBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End  
												When FT.GroupID = -171 Then Case When (DO.BusinessUnitID <= '601' OR DO.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  DO.BusinessUnitID >= '701') AND DO.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then SUM(PL.ConsCYBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End
												  Else SUM(PL.ConsCYBudgetAmt * FT.IncomeStatementBudgetSign)
											End					 
									   WHEN @FuncCurrency THEN 
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then SUM(PL.FuncCYBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then SUM(PL.FuncCYBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then SUM(PL.FuncCYBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then SUM(PL.FuncCYBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then SUM(PL.FuncCYBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then SUM(PL.FuncCYBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then SUM(PL.FuncCYBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then SUM(PL.FuncCYBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then SUM(PL.FuncCYBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then SUM(PL.FuncCYBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then SUM(PL.FuncCYBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then SUM(PL.FuncCYBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End 
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then SUM(PL.FuncCYBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End  
												When FT.GroupID = -171 Then Case When (DO.BusinessUnitID <= '601' OR DO.BusinessUnitID in ( '612', '099', '499', 'A99', '899', '999', 'B99', 'C99', '299', '199', '399', '599', '618') OR  DO.BusinessUnitID >= '701') AND DO.BusinessUnitID not in ('094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093', '095', '495', 'A95', '895', '995', 'B95',  'C95', '295', '195', '395', '595', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597', '000') Then SUM(PL.FuncCYBudgetAmt * FT.IncomeStatementBudgetSign) Else 0.000000 End
												  Else SUM(PL.FuncCYBudgetAmt * FT.IncomeStatementBudgetSign)
											End	
										Else 0.000000
							   END),0.000000) as [Current Year Budget Amount]
					,ISNULL( ( Case @pCurrency  WHEN @ConsCurrency THEN 
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then 
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
											END) Else 0.000000 End
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then 
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
											END) Else 0.000000 End
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then 
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
											END) Else 0.000000 End
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then 
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
											END) Else 0.000000 End
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then 
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
											END) Else 0.000000 End
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then 
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
											END) Else 0.000000 End
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then 
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
											END) Else 0.000000 End
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then 
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
											END) Else 0.000000 End
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then 
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
											END) Else 0.000000 End
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then 
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
											END) Else 0.000000 End
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then 
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
											END) Else 0.000000 End
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then 
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
											END) Else 0.000000 End
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then 
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
											END) Else 0.000000 End
											End
					 WHEN @FuncCurrency THEN
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.FuncP1FC1Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + (PL.FuncP3FC1Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt)  * FT.IncomeStatementActualSign) + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt + PL.FuncP10FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt + PL.FuncP10FC1Amt + PL.FuncP11FC1Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt + PL.FuncP10FC1Amt + PL.FuncP11FC1Amt + PL.FuncP12FC1Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.FuncP1FC1Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + (PL.FuncP3FC1Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt)  * FT.IncomeStatementActualSign) + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt + PL.FuncP10FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt + PL.FuncP10FC1Amt + PL.FuncP11FC1Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt + PL.FuncP10FC1Amt + PL.FuncP11FC1Amt + PL.FuncP12FC1Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.FuncP1FC1Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + (PL.FuncP3FC1Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt)  * FT.IncomeStatementActualSign) + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt + PL.FuncP10FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt + PL.FuncP10FC1Amt + PL.FuncP11FC1Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt + PL.FuncP10FC1Amt + PL.FuncP11FC1Amt + PL.FuncP12FC1Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.FuncP1FC1Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + (PL.FuncP3FC1Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt)  * FT.IncomeStatementActualSign) + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt + PL.FuncP10FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt + PL.FuncP10FC1Amt + PL.FuncP11FC1Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt + PL.FuncP10FC1Amt + PL.FuncP11FC1Amt + PL.FuncP12FC1Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.FuncP1FC1Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + (PL.FuncP3FC1Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt)  * FT.IncomeStatementActualSign) + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt + PL.FuncP10FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt + PL.FuncP10FC1Amt + PL.FuncP11FC1Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt + PL.FuncP10FC1Amt + PL.FuncP11FC1Amt + PL.FuncP12FC1Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.FuncP1FC1Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + (PL.FuncP3FC1Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt)  * FT.IncomeStatementActualSign) + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt + PL.FuncP10FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt + PL.FuncP10FC1Amt + PL.FuncP11FC1Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt + PL.FuncP10FC1Amt + PL.FuncP11FC1Amt + PL.FuncP12FC1Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.FuncP1FC1Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + (PL.FuncP3FC1Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt)  * FT.IncomeStatementActualSign) + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt + PL.FuncP10FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt + PL.FuncP10FC1Amt + PL.FuncP11FC1Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt + PL.FuncP10FC1Amt + PL.FuncP11FC1Amt + PL.FuncP12FC1Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.FuncP1FC1Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + (PL.FuncP3FC1Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt)  * FT.IncomeStatementActualSign) + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt + PL.FuncP10FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt + PL.FuncP10FC1Amt + PL.FuncP11FC1Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt + PL.FuncP10FC1Amt + PL.FuncP11FC1Amt + PL.FuncP12FC1Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.FuncP1FC1Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + (PL.FuncP3FC1Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt)  * FT.IncomeStatementActualSign) + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt + PL.FuncP10FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt + PL.FuncP10FC1Amt + PL.FuncP11FC1Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt + PL.FuncP10FC1Amt + PL.FuncP11FC1Amt + PL.FuncP12FC1Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.FuncP1FC1Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + (PL.FuncP3FC1Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt)  * FT.IncomeStatementActualSign) + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt + PL.FuncP10FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt + PL.FuncP10FC1Amt + PL.FuncP11FC1Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt + PL.FuncP10FC1Amt + PL.FuncP11FC1Amt + PL.FuncP12FC1Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.FuncP1FC1Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + (PL.FuncP3FC1Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt)  * FT.IncomeStatementActualSign) + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt + PL.FuncP10FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt + PL.FuncP10FC1Amt + PL.FuncP11FC1Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt + PL.FuncP10FC1Amt + PL.FuncP11FC1Amt + PL.FuncP12FC1Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.FuncP1FC1Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + (PL.FuncP3FC1Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt)  * FT.IncomeStatementActualSign) + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt + PL.FuncP10FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt + PL.FuncP10FC1Amt + PL.FuncP11FC1Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt + PL.FuncP10FC1Amt + PL.FuncP11FC1Amt + PL.FuncP12FC1Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.FuncP1FC1Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + (PL.FuncP3FC1Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt)  * FT.IncomeStatementActualSign) + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt + PL.FuncP10FC1Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt + PL.FuncP10FC1Amt + PL.FuncP11FC1Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.FuncP1FC1Amt + PL.FuncP2FC1Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.FuncP3FC1Amt + PL.FuncP4FC1Amt + PL.FuncP5FC1Amt + PL.FuncP6FC1Amt + PL.FuncP7FC1Amt + PL.FuncP8FC1Amt + PL.FuncP9FC1Amt + PL.FuncP10FC1Amt + PL.FuncP11FC1Amt + PL.FuncP12FC1Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
											End
						Else 0.000000
				END),0.000000) AS [YTD Forecast 1 Amount]
   					 ,ISNULL( ( Case @pCurrency WHEN @ConsCurrency THEN 
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.ConsP1FC2Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + (PL.ConsP3FC2Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt)  * FT.IncomeStatementActualSign) + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt + PL.ConsP10FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt + PL.ConsP10FC2Amt + PL.ConsP11FC2Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt + PL.ConsP10FC2Amt + PL.ConsP11FC2Amt + PL.ConsP12FC2Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.ConsP1FC2Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + (PL.ConsP3FC2Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt)  * FT.IncomeStatementActualSign) + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt + PL.ConsP10FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt + PL.ConsP10FC2Amt + PL.ConsP11FC2Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt + PL.ConsP10FC2Amt + PL.ConsP11FC2Amt + PL.ConsP12FC2Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.ConsP1FC2Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + (PL.ConsP3FC2Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt)  * FT.IncomeStatementActualSign) + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt + PL.ConsP10FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt + PL.ConsP10FC2Amt + PL.ConsP11FC2Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt + PL.ConsP10FC2Amt + PL.ConsP11FC2Amt + PL.ConsP12FC2Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.ConsP1FC2Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + (PL.ConsP3FC2Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt)  * FT.IncomeStatementActualSign) + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt + PL.ConsP10FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt + PL.ConsP10FC2Amt + PL.ConsP11FC2Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt + PL.ConsP10FC2Amt + PL.ConsP11FC2Amt + PL.ConsP12FC2Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.ConsP1FC2Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + (PL.ConsP3FC2Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt)  * FT.IncomeStatementActualSign) + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt + PL.ConsP10FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt + PL.ConsP10FC2Amt + PL.ConsP11FC2Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt + PL.ConsP10FC2Amt + PL.ConsP11FC2Amt + PL.ConsP12FC2Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.ConsP1FC2Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + (PL.ConsP3FC2Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt)  * FT.IncomeStatementActualSign) + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt + PL.ConsP10FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt + PL.ConsP10FC2Amt + PL.ConsP11FC2Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt + PL.ConsP10FC2Amt + PL.ConsP11FC2Amt + PL.ConsP12FC2Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.ConsP1FC2Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + (PL.ConsP3FC2Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt)  * FT.IncomeStatementActualSign) + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt + PL.ConsP10FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt + PL.ConsP10FC2Amt + PL.ConsP11FC2Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt + PL.ConsP10FC2Amt + PL.ConsP11FC2Amt + PL.ConsP12FC2Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.ConsP1FC2Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + (PL.ConsP3FC2Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt)  * FT.IncomeStatementActualSign) + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt + PL.ConsP10FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt + PL.ConsP10FC2Amt + PL.ConsP11FC2Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt + PL.ConsP10FC2Amt + PL.ConsP11FC2Amt + PL.ConsP12FC2Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.ConsP1FC2Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + (PL.ConsP3FC2Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt)  * FT.IncomeStatementActualSign) + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt + PL.ConsP10FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt + PL.ConsP10FC2Amt + PL.ConsP11FC2Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt + PL.ConsP10FC2Amt + PL.ConsP11FC2Amt + PL.ConsP12FC2Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.ConsP1FC2Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + (PL.ConsP3FC2Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt)  * FT.IncomeStatementActualSign) + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt + PL.ConsP10FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt + PL.ConsP10FC2Amt + PL.ConsP11FC2Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt + PL.ConsP10FC2Amt + PL.ConsP11FC2Amt + PL.ConsP12FC2Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.ConsP1FC2Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + (PL.ConsP3FC2Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt)  * FT.IncomeStatementActualSign) + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt + PL.ConsP10FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt + PL.ConsP10FC2Amt + PL.ConsP11FC2Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt + PL.ConsP10FC2Amt + PL.ConsP11FC2Amt + PL.ConsP12FC2Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.ConsP1FC2Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + (PL.ConsP3FC2Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt)  * FT.IncomeStatementActualSign) + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt + PL.ConsP10FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt + PL.ConsP10FC2Amt + PL.ConsP11FC2Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt + PL.ConsP10FC2Amt + PL.ConsP11FC2Amt + PL.ConsP12FC2Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.ConsP1FC2Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + (PL.ConsP3FC2Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt)  * FT.IncomeStatementActualSign) + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt + PL.ConsP10FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt + PL.ConsP10FC2Amt + PL.ConsP11FC2Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.ConsP1FC2Amt + PL.ConsP2FC2Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.ConsP3FC2Amt + PL.ConsP4FC2Amt + PL.ConsP5FC2Amt + PL.ConsP6FC2Amt + PL.ConsP7FC2Amt + PL.ConsP8FC2Amt + PL.ConsP9FC2Amt + PL.ConsP10FC2Amt + PL.ConsP11FC2Amt + PL.ConsP12FC2Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
											End
					 WHEN @FuncCurrency THEN
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.FuncP1FC2Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + (PL.FuncP3FC2Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt)  * FT.IncomeStatementActualSign) + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt + PL.FuncP10FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt + PL.FuncP10FC2Amt + PL.FuncP11FC2Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt + PL.FuncP10FC2Amt + PL.FuncP11FC2Amt + PL.FuncP12FC2Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.FuncP1FC2Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + (PL.FuncP3FC2Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt)  * FT.IncomeStatementActualSign) + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt + PL.FuncP10FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt + PL.FuncP10FC2Amt + PL.FuncP11FC2Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt + PL.FuncP10FC2Amt + PL.FuncP11FC2Amt + PL.FuncP12FC2Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.FuncP1FC2Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + (PL.FuncP3FC2Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt)  * FT.IncomeStatementActualSign) + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt + PL.FuncP10FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt + PL.FuncP10FC2Amt + PL.FuncP11FC2Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt + PL.FuncP10FC2Amt + PL.FuncP11FC2Amt + PL.FuncP12FC2Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.FuncP1FC2Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + (PL.FuncP3FC2Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt)  * FT.IncomeStatementActualSign) + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt + PL.FuncP10FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt + PL.FuncP10FC2Amt + PL.FuncP11FC2Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt + PL.FuncP10FC2Amt + PL.FuncP11FC2Amt + PL.FuncP12FC2Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.FuncP1FC2Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + (PL.FuncP3FC2Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt)  * FT.IncomeStatementActualSign) + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt + PL.FuncP10FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt + PL.FuncP10FC2Amt + PL.FuncP11FC2Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt + PL.FuncP10FC2Amt + PL.FuncP11FC2Amt + PL.FuncP12FC2Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.FuncP1FC2Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + (PL.FuncP3FC2Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt)  * FT.IncomeStatementActualSign) + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt + PL.FuncP10FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt + PL.FuncP10FC2Amt + PL.FuncP11FC2Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt + PL.FuncP10FC2Amt + PL.FuncP11FC2Amt + PL.FuncP12FC2Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.FuncP1FC2Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + (PL.FuncP3FC2Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt)  * FT.IncomeStatementActualSign) + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt + PL.FuncP10FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt + PL.FuncP10FC2Amt + PL.FuncP11FC2Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt + PL.FuncP10FC2Amt + PL.FuncP11FC2Amt + PL.FuncP12FC2Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.FuncP1FC2Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + (PL.FuncP3FC2Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt)  * FT.IncomeStatementActualSign) + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt + PL.FuncP10FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt + PL.FuncP10FC2Amt + PL.FuncP11FC2Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt + PL.FuncP10FC2Amt + PL.FuncP11FC2Amt + PL.FuncP12FC2Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.FuncP1FC2Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + (PL.FuncP3FC2Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt)  * FT.IncomeStatementActualSign) + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt + PL.FuncP10FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt + PL.FuncP10FC2Amt + PL.FuncP11FC2Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt + PL.FuncP10FC2Amt + PL.FuncP11FC2Amt + PL.FuncP12FC2Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.FuncP1FC2Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + (PL.FuncP3FC2Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt)  * FT.IncomeStatementActualSign) + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt + PL.FuncP10FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt + PL.FuncP10FC2Amt + PL.FuncP11FC2Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt + PL.FuncP10FC2Amt + PL.FuncP11FC2Amt + PL.FuncP12FC2Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.FuncP1FC2Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + (PL.FuncP3FC2Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt)  * FT.IncomeStatementActualSign) + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt + PL.FuncP10FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt + PL.FuncP10FC2Amt + PL.FuncP11FC2Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt + PL.FuncP10FC2Amt + PL.FuncP11FC2Amt + PL.FuncP12FC2Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.FuncP1FC2Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + (PL.FuncP3FC2Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt)  * FT.IncomeStatementActualSign) + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt + PL.FuncP10FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt + PL.FuncP10FC2Amt + PL.FuncP11FC2Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt + PL.FuncP10FC2Amt + PL.FuncP11FC2Amt + PL.FuncP12FC2Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.FuncP1FC2Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + (PL.FuncP3FC2Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt)  * FT.IncomeStatementActualSign) + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt + PL.FuncP10FC2Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt + PL.FuncP10FC2Amt + PL.FuncP11FC2Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.FuncP1FC2Amt + PL.FuncP2FC2Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.FuncP3FC2Amt + PL.FuncP4FC2Amt + PL.FuncP5FC2Amt + PL.FuncP6FC2Amt + PL.FuncP7FC2Amt + PL.FuncP8FC2Amt + PL.FuncP9FC2Amt + PL.FuncP10FC2Amt + PL.FuncP11FC2Amt + PL.FuncP12FC2Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
											End
						Else 0.000000
				END),0.000000) AS [YTD Forecast 2 Amount]
				   ,ISNULL( ( Case @pCurrency WHEN @ConsCurrency THEN
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.ConsP1FC3Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + (PL.ConsP3FC3Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt)  * FT.IncomeStatementActualSign) + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt + PL.ConsP10FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt + PL.ConsP10FC3Amt + PL.ConsP11FC3Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt + PL.ConsP10FC3Amt + PL.ConsP11FC3Amt + PL.ConsP12FC3Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.ConsP1FC3Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + (PL.ConsP3FC3Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt)  * FT.IncomeStatementActualSign) + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt + PL.ConsP10FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt + PL.ConsP10FC3Amt + PL.ConsP11FC3Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt + PL.ConsP10FC3Amt + PL.ConsP11FC3Amt + PL.ConsP12FC3Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.ConsP1FC3Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + (PL.ConsP3FC3Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt)  * FT.IncomeStatementActualSign) + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt + PL.ConsP10FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt + PL.ConsP10FC3Amt + PL.ConsP11FC3Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt + PL.ConsP10FC3Amt + PL.ConsP11FC3Amt + PL.ConsP12FC3Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.ConsP1FC3Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + (PL.ConsP3FC3Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt)  * FT.IncomeStatementActualSign) + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt + PL.ConsP10FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt + PL.ConsP10FC3Amt + PL.ConsP11FC3Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt + PL.ConsP10FC3Amt + PL.ConsP11FC3Amt + PL.ConsP12FC3Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.ConsP1FC3Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + (PL.ConsP3FC3Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt)  * FT.IncomeStatementActualSign) + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt + PL.ConsP10FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt + PL.ConsP10FC3Amt + PL.ConsP11FC3Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt + PL.ConsP10FC3Amt + PL.ConsP11FC3Amt + PL.ConsP12FC3Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.ConsP1FC3Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + (PL.ConsP3FC3Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt)  * FT.IncomeStatementActualSign) + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt + PL.ConsP10FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt + PL.ConsP10FC3Amt + PL.ConsP11FC3Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt + PL.ConsP10FC3Amt + PL.ConsP11FC3Amt + PL.ConsP12FC3Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.ConsP1FC3Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + (PL.ConsP3FC3Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt)  * FT.IncomeStatementActualSign) + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt + PL.ConsP10FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt + PL.ConsP10FC3Amt + PL.ConsP11FC3Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt + PL.ConsP10FC3Amt + PL.ConsP11FC3Amt + PL.ConsP12FC3Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.ConsP1FC3Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + (PL.ConsP3FC3Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt)  * FT.IncomeStatementActualSign) + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt + PL.ConsP10FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt + PL.ConsP10FC3Amt + PL.ConsP11FC3Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt + PL.ConsP10FC3Amt + PL.ConsP11FC3Amt + PL.ConsP12FC3Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.ConsP1FC3Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + (PL.ConsP3FC3Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt)  * FT.IncomeStatementActualSign) + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt + PL.ConsP10FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt + PL.ConsP10FC3Amt + PL.ConsP11FC3Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt + PL.ConsP10FC3Amt + PL.ConsP11FC3Amt + PL.ConsP12FC3Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.ConsP1FC3Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + (PL.ConsP3FC3Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt)  * FT.IncomeStatementActualSign) + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt + PL.ConsP10FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt + PL.ConsP10FC3Amt + PL.ConsP11FC3Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt + PL.ConsP10FC3Amt + PL.ConsP11FC3Amt + PL.ConsP12FC3Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.ConsP1FC3Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + (PL.ConsP3FC3Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt)  * FT.IncomeStatementActualSign) + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt + PL.ConsP10FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt + PL.ConsP10FC3Amt + PL.ConsP11FC3Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt + PL.ConsP10FC3Amt + PL.ConsP11FC3Amt + PL.ConsP12FC3Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.ConsP1FC3Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + (PL.ConsP3FC3Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt)  * FT.IncomeStatementActualSign) + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt + PL.ConsP10FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt + PL.ConsP10FC3Amt + PL.ConsP11FC3Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt + PL.ConsP10FC3Amt + PL.ConsP11FC3Amt + PL.ConsP12FC3Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.ConsP1FC3Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + (PL.ConsP3FC3Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt)  * FT.IncomeStatementActualSign) + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt + PL.ConsP10FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt + PL.ConsP10FC3Amt + PL.ConsP11FC3Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.ConsP1FC3Amt + PL.ConsP2FC3Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.ConsP3FC3Amt + PL.ConsP4FC3Amt + PL.ConsP5FC3Amt + PL.ConsP6FC3Amt + PL.ConsP7FC3Amt + PL.ConsP8FC3Amt + PL.ConsP9FC3Amt + PL.ConsP10FC3Amt + PL.ConsP11FC3Amt + PL.ConsP12FC3Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
											End
					 WHEN @FuncCurrency THEN
											Case 
												When FT.GroupID = -159 Then Case When DO.BusinessUnitID = '602' Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.FuncP1FC3Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + (PL.FuncP3FC3Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt)  * FT.IncomeStatementActualSign) + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt + PL.FuncP10FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt + PL.FuncP10FC3Amt + PL.FuncP11FC3Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt + PL.FuncP10FC3Amt + PL.FuncP11FC3Amt + PL.FuncP12FC3Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -160 Then Case When DO.BusinessUnitID = '602' Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.FuncP1FC3Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + (PL.FuncP3FC3Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt)  * FT.IncomeStatementActualSign) + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt + PL.FuncP10FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt + PL.FuncP10FC3Amt + PL.FuncP11FC3Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt + PL.FuncP10FC3Amt + PL.FuncP11FC3Amt + PL.FuncP12FC3Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -161 Then Case When DO.BusinessUnitID in ('603', '000') Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.FuncP1FC3Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + (PL.FuncP3FC3Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt)  * FT.IncomeStatementActualSign) + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt + PL.FuncP10FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt + PL.FuncP10FC3Amt + PL.FuncP11FC3Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt + PL.FuncP10FC3Amt + PL.FuncP11FC3Amt + PL.FuncP12FC3Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -162 Then Case When DO.BusinessUnitID in ('604', '094', '494', 'A94', '894', '994', 'B94', 'C94', '294', '194', '394', '594', '093') Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.FuncP1FC3Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + (PL.FuncP3FC3Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt)  * FT.IncomeStatementActualSign) + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt + PL.FuncP10FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt + PL.FuncP10FC3Amt + PL.FuncP11FC3Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt + PL.FuncP10FC3Amt + PL.FuncP11FC3Amt + PL.FuncP12FC3Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -164 Then Case When DO.BusinessUnitID in ('605', '095', '495', 'A95', '895', '995', 'B95', 'C95', '295', '195', '395', '595') Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.FuncP1FC3Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + (PL.FuncP3FC3Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt)  * FT.IncomeStatementActualSign) + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt + PL.FuncP10FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt + PL.FuncP10FC3Amt + PL.FuncP11FC3Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt + PL.FuncP10FC3Amt + PL.FuncP11FC3Amt + PL.FuncP12FC3Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -165 Then Case When DO.BusinessUnitID in ('606', '096', '496', 'A96', '896', '996', 'B96', 'C96', '296', '196', '396', '596') Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.FuncP1FC3Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + (PL.FuncP3FC3Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt)  * FT.IncomeStatementActualSign) + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt + PL.FuncP10FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt + PL.FuncP10FC3Amt + PL.FuncP11FC3Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt + PL.FuncP10FC3Amt + PL.FuncP11FC3Amt + PL.FuncP12FC3Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -168 Then Case When DO.BusinessUnitID in ('607', '097', '497', 'A97', '897', '997', 'B97', 'C97', '297', '197', '397', '597') Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.FuncP1FC3Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + (PL.FuncP3FC3Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt)  * FT.IncomeStatementActualSign) + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt + PL.FuncP10FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt + PL.FuncP10FC3Amt + PL.FuncP11FC3Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt + PL.FuncP10FC3Amt + PL.FuncP11FC3Amt + PL.FuncP12FC3Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -170 Then Case When DO.BusinessUnitID = '608' Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.FuncP1FC3Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + (PL.FuncP3FC3Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt)  * FT.IncomeStatementActualSign) + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt + PL.FuncP10FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt + PL.FuncP10FC3Amt + PL.FuncP11FC3Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt + PL.FuncP10FC3Amt + PL.FuncP11FC3Amt + PL.FuncP12FC3Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -166 Then Case When DO.BusinessUnitID = '609' Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.FuncP1FC3Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + (PL.FuncP3FC3Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt)  * FT.IncomeStatementActualSign) + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt + PL.FuncP10FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt + PL.FuncP10FC3Amt + PL.FuncP11FC3Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt + PL.FuncP10FC3Amt + PL.FuncP11FC3Amt + PL.FuncP12FC3Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -167 Then Case When DO.BusinessUnitID = '610' Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.FuncP1FC3Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + (PL.FuncP3FC3Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt)  * FT.IncomeStatementActualSign) + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt + PL.FuncP10FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt + PL.FuncP10FC3Amt + PL.FuncP11FC3Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt + PL.FuncP10FC3Amt + PL.FuncP11FC3Amt + PL.FuncP12FC3Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -163 Then Case When DO.BusinessUnitID = '611' Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.FuncP1FC3Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + (PL.FuncP3FC3Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt)  * FT.IncomeStatementActualSign) + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt + PL.FuncP10FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt + PL.FuncP10FC3Amt + PL.FuncP11FC3Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt + PL.FuncP10FC3Amt + PL.FuncP11FC3Amt + PL.FuncP12FC3Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -169 Then Case When DO.BusinessUnitID = '615' Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.FuncP1FC3Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + (PL.FuncP3FC3Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt)  * FT.IncomeStatementActualSign) + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt + PL.FuncP10FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt + PL.FuncP10FC3Amt + PL.FuncP11FC3Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt + PL.FuncP10FC3Amt + PL.FuncP11FC3Amt + PL.FuncP12FC3Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
												When FT.GroupID = -294 Then Case When DO.BusinessUnitID In ('616', '617', '099') Then 
													(CASE CP.[FiscalPeriodNumber] WHEN 1 THEN SUM(((PL.FuncP1FC3Amt) * FT.IncomeStatementActualSign)) 				  
														WHEN  2  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign))				   
														WHEN  3  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + (PL.FuncP3FC3Amt * FT.IncomeStatementBudgetSign)) 				   
														WHEN  4  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt)  * FT.IncomeStatementActualSign) + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt) * FT.IncomeStatementBudgetSign)) 				   
														WHEN  5  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  6  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt) * FT.IncomeStatementBudgetSign))				  
														WHEN  7   THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  8  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  9  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  10   THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign)  + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt + PL.FuncP10FC3Amt) * FT.IncomeStatementBudgetSign))				   
														WHEN  11  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign) 
																+ ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt + PL.FuncP10FC3Amt + PL.FuncP11FC3Amt) * FT.IncomeStatementBudgetSign)) 				  
														WHEN 12  THEN SUM(((PL.FuncP1FC3Amt + PL.FuncP2FC3Amt) * FT.IncomeStatementActualSign) 
												 + ((PL.FuncP3FC3Amt + PL.FuncP4FC3Amt + PL.FuncP5FC3Amt + PL.FuncP6FC3Amt + PL.FuncP7FC3Amt + PL.FuncP8FC3Amt + PL.FuncP9FC3Amt + PL.FuncP10FC3Amt + PL.FuncP11FC3Amt + PL.FuncP12FC3Amt) * FT.IncomeStatementBudgetSign))
											END) Else 0.000000 End
											End
						Else 0.000000
					END),0.000000) AS [YTD Forecast 3 Amount]
FROM           
		FactProfitAndLossSummary AS PL 
		LEFT OUTER JOIN  MapFinancialTemplate AS FT  ON FT.AccountSkey = PL.AccountSkey 
		INNER JOIN [dbo].[DimOrganization] as DO ON PL.OrgSkey = DO.OrgSkey
		LEFT OUTER JOIN  DimAccount AS AC ON FT.AccountSkey = AC.AccountSkey
		INNER JOIN DimCalendarPeriod AS CP ON PL.PostPeriodSkey = CP.FiscalPeriodSkey
WHERE        (PL.PostPeriodSkey = @pFiscalPeriod) 
			AND (FT.TemplateID = @pTemplate)
			AND PL.OrgSkey IN ( Select * from dbo.STRING_SPLIT(@pOrg, ','))
			AND [GroupID] in (@pGroup)
			--AND HeaderLine = 'Y'
	
GROUP BY		FT.AccountSkey, FT.GroupID  
				, Case @pLanguage When @ENLanguage THEN AC.AccountNameEN 
							  WHEN @FRLanguage THEN AC.AccountNameFR
							  Else 'Unknown'
				END 
			   ,CP.FiscalPeriodNumber, AC.AccountID, DO.BusinessUnitID
			
ORDER BY FT.AccountSkey, AccountDesc, CP.FiscalPeriodNumber
		

GO

