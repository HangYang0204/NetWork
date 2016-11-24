USE [BIDataWarehouse]
GO

/****** Object:  StoredProcedure [dbo].[usp_CountOrganization]    Script Date: 24/11/2016 10:52:44 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE Procedure [dbo].[usp_CountOrganization] 
	@pUserID varchar(20),
	@pBusinessLine varchar(max),
	@pGeoRegion varchar(max),
	@pCompany varchar(max),
	@pRegion varchar(max),
	@pMarketSegment varchar(max),
	@pSubMarketSegment varchar(max),
	@pLocation varchar(max),
	@pBusinessUnit varchar(max)
	
AS
BEGIN
DECLARE @pFirstGroupCount int;
DECLARE @pSecondGroupCount int;

SET @pFirstGroupCount = (SELECT  Count(Distinct DO.[OrgSkey]) as Dist_Count
								FROM  DimOrganization DO
							INNER JOIN [dbo].[DimOrgSecurity] as DOS on DO.OrgSkey = DOS.OrgSkey
							WHERE  (ProductLineID IN (@pBusinessLine) OR MarketSegmentID IN ( @pMarketSegment)
										OR GeographicRegionID IN  (@pGeoRegion) OR SubMarketSegmentID IN (@pSubMarketSegment ) )
							 AND 
							( CompanyID IN (@pCompany) OR RegionID IN (@pRegion) OR LocationID IN (@pLocation) OR BusinessUnitID IN ( @pBusinessUnit))
							AND [ADAccount] = @pUserID
							and [RemovedFlag]= 'N'
							AND OrganizationID <> '99-ZZ-ZZZ-ZZZ'
						 );
SET @pSecondGroupCount = (SELECT  Count(Distinct DO.[OrgSkey]) as Dist_Count
								FROM  DimOrganization DO
							INNER JOIN [dbo].[DimOrgSecurity] as DOS on DO.OrgSkey = DOS.OrgSkey
							WHERE  (ProductLineID IN (@pBusinessLine) 
									 AND  GeographicRegionID IN  (@pGeoRegion) 
									 AND CompanyID IN (@pCompany)
									 )
									 OR ( RegionID IN (@pRegion) 
										  AND MarketSegmentID IN ( @pMarketSegment)
										  AND SubMarketSegmentID IN (@pSubMarketSegment )
										  AND LocationID IN (@pLocation)
										  AND BusinessUnitID IN ( @pBusinessUnit)
										)
								AND [ADAccount] = @pUserID
							and [RemovedFlag]= 'N'
							AND OrganizationID <> '99-ZZ-ZZZ-ZZZ'
							);

		If (@pFirstGroupCount > @pSecondGroupCount)
			BEGIN SELECT @pFirstGroupCount AS Dist_Count END
			ELSE 
				BEGIN	SELECT @pSecondGroupCount AS Dist_Count END
		
END
GO

