USE [BIDataWarehouse]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetUserNameFull]    Script Date: 24/11/2016 10:54:02 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[usp_GetUserNameFull]
@UID varchar(50)
AS 


SELECT TOP 1 [FullName] FROM [dbo].[DimEmployee]
WHERE [ADAccount] = @UID
GO

