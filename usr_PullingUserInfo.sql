USE [BIDataWarehouse]
GO

/****** Object:  StoredProcedure [dbo].[usr_PullingUserInfo]    Script Date: 24/11/2016 11:10:53 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE Proc [dbo].[usr_PullingUserInfo]
as 
 
Select distinct A.[ADAccount] 
FROM [dbo].[DimEmployee] A 
JOIN [dbo].[DimOrgSecurity] B
ON A.[EmployeeSkey] = B.[EmployeeSkey]

 
GO

