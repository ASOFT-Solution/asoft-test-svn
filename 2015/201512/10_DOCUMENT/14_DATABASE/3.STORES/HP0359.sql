IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0359]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[HP0359]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-----Created by Nguyễn Thanh Thịnh, date: 11/11/2015
-----purpose: Load email nhân viên check

CREATE PROCEDURE [dbo].[HP0359] 
	@DivisionID nvarchar(20), 
	@StringEmployeeID nvarchar(max)
as
BEGIN
	
	SELECT STUFF(( SELECT  ';'+ HV14.Email
		FROM [dbo].[Split](@StringEmployeeID,';') DT
		INNER JOIN HV1400 HV14
			ON HV14.EmployeeID = DT.Data
			AND HV14.DivisionID = @DivisionID
		GROUP BY HV14.EMAIL
		HAVING ISNULL(HV14.EMAIL,'') <> ''
			FOR XML PATH('')),1,1,'') [Email]	
END