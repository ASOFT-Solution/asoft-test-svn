IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0284]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0284]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Kiểm tra sửa/ xóa chấm công sản phẩm theo ca cho nhân viên
---- Create by Thanh Sơn on 10/10/2013
---- EXEC HP0284 'LAN01','CTY','PQS','%','VR.0000',10,2013

CREATE PROCEDURE HP0284
(
  @TimesID  NVARCHAR (50),
  @DivisionID  NVARCHAR (50),
  @DepartmentID  NVARCHAR(50),
  @TeamID  NVARCHAR(50),
  @EmployeeID  NVARCHAR(50),
  @TranMonth INT,
  @TranYear INT
)
AS
DECLARE @sSQL NVARCHAR(4000),
	@cur CURSOR,
	@FullName NVARCHAR(250),
	@DepartmentName NVARCHAR(250),
	@Status TINYINT,
	@Message NVARCHAR(1000),
	@VietMess NVARCHAR(1000),
	@EngMess NVARCHAR(1000)

SELECT @Status = 0, @VietMess ='',  @EngMess =''

SET @sSQL = N'
SELECT H00.DivisionID, H00.EmployeeID, H00.DepartmentID, FullName
FROM HT2403 H00  INNER JOIN HV1400 HV on H00.EmployeeID=HV.EmployeeID AND H00.DivisionID=HV.DivisionID			
WHERE H00.DivisionID=N''' + @DivisionID + ''' 
AND   H00.DepartmentID LIKE N''' + @DepartmentID + '''
AND   ISNULL(H00.TeamID,'''') LIKE N''' + @TeamID + ''' 
AND   H00.EmployeeID LIKE N''' + @EmployeeID + ''' 
AND	  H00.TranMonth =' + STR(@TranMonth) +  ' 
AND	  H00.TranYear =' + STR(@TranYear) + ' 
AND	  H00.TimesID = N''' + @TimesID + ''' 
AND H00.EmployeeID IN (SELECT DISTINCT EmployeeID 
					   FROM HT3400 INNER JOIN HT5012  ON HT3400.PayrollMethodID = HT5012.PayrollMethodID AND HT3400.DivisionID = HT5012.DivisionID 
					   WHERE HT3400.DivisionID = N''' + @DivisionID + ''' 
					   AND 	DepartmentID LIKE N''' + @DepartmentID + ''' 
					   AND	ISNULL(TeamID, ''' + ''') LIKE ISNULL(N'''+ @TeamID+ ''', ''' + ''') 
					   AND	TranMonth = ' + STR(@TranMonth)  + ' 
					   AND	TranYear = ' + STR(@TranYear) + ' and TimesID = N''' + @TimesID+ ''')'
					   
--Print (@sSQL)
IF NOT EXISTS (SELECT 1 FROM  sysObjects WHERE Xtype ='V' AND  Name ='HV0284')
  EXEC(' CREATE VIEW HV0284 --Tao boi HP0284
         AS '+@sSQL)
ELSE
  EXEC(' ALTER VIEW HV0284 --Tao boi HP0284
         AS '+@sSQL)

IF (EXISTS (SELECT TOP 1 1 FROM HV0284 WHERE DivisionID = @DivisionID) 
OR EXISTS (	SELECT TOP 1 * FROM HT3400 H00 LEFT JOIN HT5005 H05 ON H05.DivisionID = H00.DivisionID AND H05.PayRollMethodID = H00.PayRollMethodID
			WHERE H00.DivisionID = 'CTY'--@DivisionID 
			AND H05.MethodID IN ('P03','P04','P05')
			AND   EmployeeID LIKE @EmployeeID
			AND	  TranMonth = @TranMonth
			AND	  TranYear = @TranYear))
BEGIN
	SET @Status = 1
	SET @Message =N'HFML000056'
END
GOTO EndMess

EndMess:
  SELECT @Status AS STATUS, @Message AS [Message]

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

