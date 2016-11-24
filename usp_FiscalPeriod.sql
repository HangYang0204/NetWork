USE [BIDataWarehouse]
GO

/****** Object:  StoredProcedure [dbo].[usp_FiscalPeriod]    Script Date: 24/11/2016 10:52:57 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[usp_FiscalPeriod] 
	@pUserID varchar(20)	
	AS 

Declare @pPeriodFlag as varchar(1);

SET @pPeriodFlag = (select Distinct [AllPeriodFlag]
							FROM [dbo].[DimOrgSecurity]
							where [ADAccount] = @pUserID
					);


SELECT
	CP.FiscalPeriodSkey
	,CP.FiscalPeriodName
FROM DimCalendarPeriod CP
WHERE  CP.FiscalPeriodStartDate <= (SELECT StartDate FROM DimRelativeTime
									 WHERE RelativeTimeCode = CASE WHEN @pPeriodFlag = 'Y' THEN 'CM'							ELSE 'LCP'
			   END
									) 
AND  CP.FiscalPeriodStartDate < GETDATE() and CP.FiscalPeriodStartDate > DATEADD("mm", -36, GETDATE())
Order by CP.FiscalPeriodSkey DESC
GO

