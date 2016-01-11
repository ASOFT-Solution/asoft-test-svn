IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0348]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0348]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Load màn hình cập nhật chấm công công trình theo ca
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 07/10/2014 by Le Thi Thu Hien
---- 
---- Modified on 07/10/2014 by 
-- <Example>
---- 
CREATE PROCEDURE HP0348
( 
		@DivisionID AS NVARCHAR(50),
		@TranMonth AS INT,
		@TranYear AS INT,
		@APK AS NVARCHAR(50)
) 
AS 

SELECT HT2416.APK, HT2416.DivisionID, HT2416.TranMonth, HT2416.Tranyear,
       HT2416.AbsentCardNo, HT2416.ProjectID, HT1120.ProjectName,
       HT2416.AbsentDate, HT2416.ShiftCode, HT1020.ShiftName,
       HT2416.AbsentTime, HT2416.PeriodID, 
       HT2416.Notes,
       HT2416.EmployeeID, 
       LTRIM(RTRIM(ISNULL(HT1400.LastName,'')))+ ' ' + LTRIM(RTRIM(ISNULL(HT1400.MiddleName,''))) + ' ' + LTRIM(RTRIM(ISNULL(HT1400.FirstName,''))) AS EmployeeName
        
FROM HT2416 HT2416
INNER JOIN HT1400 HT1400 ON HT1400.DivisionID = HT2416.DivisionID AND HT1400.EmployeeID = HT2416.EmployeeID
LEFT JOIN HT1120 HT1120 ON HT1120.DivisionID = HT1400.DivisionID AND HT1120.ProjectID = HT2416.ProjectID
LEFT JOIN HT1020 HT1020 ON HT1020.DivisionID = HT1120.DivisionID AND HT1020.ShiftID = HT2416.ShiftCode
WHERE HT2416.APK = @APK

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

