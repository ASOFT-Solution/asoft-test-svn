IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0358]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[HP0358]
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---- Create on 11/11/2015 by Thanh Thinh
---- Load Những Lịch Sử Gởi Mail Của Nhân Vien Theo Kì Hiện Tại
/***************************************************************
'* Edited by : [SOF] [ThanhThinh] [30/07/2010]
'**************************************************************/
CREATE PROCEDURE [dbo].[HP0358]	
	@DivisionID nvarchar(50),
	@TranYear INT,
	@TranMonth INT 	
AS
BEGIN
				
	SELECT HT14.FullName, DepartmentID, DepartmentName ,HT03.EmployeeID , HT03.[EmailReceiver],	
		   CASE WHEN HT03.[Type] = 1 THEN N'Tính Lương' 
									 ELSE N'Tính Thường' End [Type],
			HT03.[SendDate],HT03.[Subject],HT03.[Content]
	FROM HT0358 HT03
		INNER JOIN HV1400 HT14
			ON HT03.DivisionID = HT14.DivisionID
				AND HT03.EmployeeID = HT14.EmployeeID
	WHERE HT03.DivisionID = @DivisionID 
		AND HT03.TranYear = @TranYear
		AND HT03.TranMonth = @TranMonth

END
