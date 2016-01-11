IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP03351]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[HP03351]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>

---- Create on 10/12/2013 by Khanh Van
---- Modified by Thanh Sơn 
CREATE PROCEDURE [dbo].[HP03351]
( 
	@DivisionID as nvarchar(50),
	@EmployeeID as nvarchar(50)
) 
AS
SELECT H34.EmployeeID, H34.TransactionID, V40.FullName, H34.Orders, H34.RelationName, H34.[Description], H34.[Status],
	(CASE WHEN H34.[Status] = 1 THEN N'Hết giảm trừ' ELSE N'Giảm trừ' END) StatusName,
	H34.CreateDate, H34.EndDate, H34.CreateUserID, H34.RelationBirthday, H34.RelationTaxID,
	H34.NationalityID, A011.CountryName NationalityName, H34.CountryID, A01.CountryName, H34.CityID, A02.CityName,
	H34.DistrictID, A13.DistrictName, H34.WardID, A14.WardName, H34.FromPeriod, H34.ToPeriod, H34.RelationID,
	A22.RelationName RelationText, H34.RelationIdentifyCardNo,
	H34.CertifiBook, H34.CertificateNo
FROM HV1400 V40
	INNER JOIN HT0334 H34 ON V40.DivisionID = H34.DivisionID AND V40.EmployeeID = H34.EmployeeID
	LEFT JOIN AT1001 A01 ON A01.DivisionID = H34.DivisionID AND A01.CountryID = H34.CountryID
	LEFT JOIN AT1001 A011 ON A011.DivisionID = H34.DivisionID AND A011.CountryID = H34.NationalityID
	LEFT JOIN AT1002 A02 ON A02.DivisionID = H34.DivisionID AND A02.CityID = H34.CityID
	LEFT JOIN AT1013 A13 ON A13.DivisionID = H34.DivisionID AND A13.DistrictID = H34.DistrictID
	LEFT JOIN AT1014 A14 ON A14.DivisionID = H34.DivisionID AND A14.WardID = H34.WardID
	LEFT JOIN AT1022 A22 ON A22.DivisionID = H34.DivisionID AND A22.RelationID = H34.RelationID
	
WHERE H34.DivisionID = @DivisionID and H34.EmployeeID = @EmployeeID

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
