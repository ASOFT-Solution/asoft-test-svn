IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP8002]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[HP8002]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- Load tờ khai 05-3BK-TNCN
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by: on 
---- Modified by:
-- <Example>
/*
	 HP8002 'VK', '', 1,2014,12,2014
*/
				
 CREATE PROCEDURE HP8002
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50),
	@FromMonth INT,
	@FromYear INT,
	@ToMonth INT,
	@ToYear INT
)
AS

SELECT H34.EmployeeID, V40.FullName, V40.PersonalTaxID, H34.RelationName, H34.RelationBirthday, H34.RelationTaxID,
	H34.NationalityID, A011.CountryName NationalityName, H34.RelationIdentifyCardNo, H34.RelationID, A22.RelationName RelationText,
	H34.CertificateNo, H34.CertifiBook, H34.CountryID, A01.CountryName,
	H34.CityID, A02.CityName, H34.DistrictID, A13.DistrictName, H34.WardID, A14.WardName, H34.FromPeriod, H34.ToPeriod
FROM HT0334 H34
LEFT JOIN AT1014 A14 ON A14.DivisionID = H34.DivisionID AND A14.WardID = H34.WardID
LEFT JOIN AT1013 A13 ON A13.DivisionID = H34.DivisionID AND A13.DistrictID = H34.DistrictID
LEFT JOIN AT1002 A02 ON A02.DivisionID = H34.DivisionID AND A02.CityID = H34.CityID
LEFT JOIN AT1001 A011 ON A011.DivisionID = H34.DivisionID AND A011.CountryID = H34.NationalityID
LEFT JOIN AT1001 A01 ON A01.DivisionID = H34.DivisionID AND A01.CountryID = H34.CountryID
LEFT JOIN AT1022 A22 ON A22.DivisionID = H34.DivisionID AND A22.RelationID = H34.RelationID
LEFT JOIN HV1400 V40 ON V40.DivisionID = H34.DivisionID AND V40.EmployeeID = H34.EmployeeID
WHERE V40.DivisionID = @DivisionID
AND H34.EmployeeID IN (SELECT EmployeeID FROM HT3400 WHERE TranMonth + TranYear * 100 BETWEEN @FromMonth + @FromYear * 100 AND @ToMonth + @ToYear * 100)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
