IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP03292]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[HP03292]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- THông báo những nhân viên hết hạn CMND, GPLX,Passport
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 26/10/2015 by Thanh Thịnh
---- 
-- <Example>
---- EXEC HP03292 'SAS',1

CREATE PROCEDURE HP03292
( 
		@DivisionID VARCHAR(50),
		@Type int
) 
AS 
DECLARE @sSQL NVARCHAR(MAX),
        @sWhere NVARCHAR(MAX)

if (@Type = 1)
BEGIN
	IF EXISTS (SELECT * FROM HT0000 WHERE ISNULL(IsWarningIDDef,0) >= 0)
		BEGIN
			  SELECT DISTINCT EmployeeID
			  FROM HT1400 EMD
			  left JOIN HT0000 DEF
			 ON EMD.DivisionID = DEF.DivisionID
			  WHERE EMD.DivisionID = @DivisionID
			  GROUP BY EMD.IdentifyDate,DEF.IsWarningIDDef,EmployeeID,EMD.IdentifyEnd
			  HAVING  DATEADD(DAY,DEF.IsWarningIDDef,GETDATE()) >= ISNULL(EMD.IdentifyEnd,'9999-12-31') 
		END
END
ELSE IF(@Type = 2)
BEGIN
	IF EXISTS (SELECT * FROM HT0000 WHERE ISNULL(IsWarningDrivingLic,0) >= 0)
		BEGIN
			 SELECT DISTINCT EmployeeID
			  FROM HT1400 EMD
			  INNER JOIN HT0000 DEF
			 ON EMD.DivisionID = DEF.DivisionID
			  WHERE EMD.DivisionID = @DivisionID
			  GROUP BY EMD.DrivingLicenceEnd,DEF.IsWarningDrivingLic,EmployeeID
			  HAVING DATEADD(DAY,DEF.IsWarningDrivingLic,GETDATE()) >= ISNULL(EMD.DrivingLicenceEnd,'9999-12-31') 
		END
END
ELSE IF(@Type = 3)
BEGIN
	IF EXISTS (SELECT * FROM HT0000 WHERE ISNULL(IsWarningPassport,0) >= 0)
		BEGIN
			  SELECT DISTINCT EmployeeID
			  FROM HT1400 EMD
			  left JOIN HT0000 DEF
			 ON EMD.DivisionID = DEF.DivisionID
			  WHERE EMD.DivisionID = @DivisionID
			  GROUP BY EMD.PassportDate,DEF.IsWarningPassport,EmployeeID,EMD.PassportEnd
			  HAVING  DATEADD(DAY,DEF.IsWarningPassport,GETDATE()) >= ISNULL(EMD.PassportEnd,'9999-12-31') 
		END
END


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
