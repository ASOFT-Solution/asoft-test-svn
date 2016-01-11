IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP5111]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP5111]
GO

/***** Object:  StoredProcedure [dbo].[HP5111]    Script Date: 02/01/2013 *****/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

---- Created by Bảo Anh, Date 02/01/2013  
---- Purpose: In báo cáo lương sản phẩm theo phương pháp chỉ định
---- HP5111 'CTY',5,2013,'PQS','%','%'
 
CREATE PROCEDURE [dbo].[HP5111] 
  @DivisionID nvarchar(50),
  @TranMonth int,  
  @TranYear int,
  @DepartmentID nvarchar(50),  
  @TeamID nvarchar(50),
  @EmployeeID nvarchar(50)
AS  
  
DECLARE @sSQL varchar(max)

SET @sSQL = 'SELECT HT87.*,	Ltrim(RTrim(isnull(HT00.LastName,'''')))+ '' '' + LTrim(RTrim(isnull(HT00.MiddleName,''''))) + '' '' + LTrim(RTrim(Isnull(HT00.FirstName,''''))) As FullName,
					datename(dw,HT87.TrackingDate) as TrackingDateName,AT1102.DepartmentName, HT1101.TeamName, HT1020.ShiftName, HT1015.ProductName, HT1015.UnitPrice
			
			FROM HT0287 HT87
			INNER JOIN HT1400 HT00 On HT87.DivisionID = HT00.DivisionID And HT87.EmployeeID = HT00.EmployeeID
			INNER JOIN AT1102 On HT87.DivisionID = AT1102.DivisionID And HT87.DepartmentID = AT1102.DepartmentID
			LEFT JOIN HT1101 On HT87.DivisionID = HT1101.DivisionID And HT87.TeamID = HT1101.TeamID
			LEFT JOIN HT1020 On HT87.DivisionID = HT1020.DivisionID And HT87.ShiftID = HT1020.ShiftID
			LEFT JOIN HT1015 On HT87.DivisionID = HT1015.DivisionID And HT87.ProductID = HT1015.ProductID
			
			WHERE HT87.DivisionID = ''' + @DivisionID + '''
			AND HT87.TranMonth = ' + LTRIM(@TranMonth) + ' AND HT87.TranYear = ' + LTRIM(@TranYear) + '
			AND HT87.DepartmentID like ''' + @DepartmentID + ''' AND HT87.TeamID like ''' + @TeamID + '''
			AND HT87.EmployeeID like ''' + @EmployeeID + '''
			
			ORDER BY HT87.DepartmentID, HT87.TeamID, HT87.TrackingDate, HT87.ShiftID, HT87.EmployeeID, HT87.ProductID
'

EXEC(@sSQL)


