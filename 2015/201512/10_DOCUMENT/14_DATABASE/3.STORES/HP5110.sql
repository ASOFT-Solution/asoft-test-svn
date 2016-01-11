IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP5110]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP5110]
GO

/***** Object:  StoredProcedure [dbo].[HP5110]    Script Date: 02/01/2013 *****/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

---- Created by Bảo Anh, Date 02/01/2013  
---- Purpose: In báo cáo lương sản phẩm theo phương pháp phân bổ
---- HP5110 'CTY',10,2013,'PQS','DUCNONG','%'
 
CREATE PROCEDURE [dbo].[HP5110] 
  @DivisionID nvarchar(50),
  @TranMonth int,  
  @TranYear int,
  @DepartmentID nvarchar(50),  
  @TeamID nvarchar(50),
  @EmployeeID nvarchar(50)
AS  
  
DECLARE @sSQL varchar(max)

IF EXISTS (SELECT *	FROM tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb.dbo.#TAM')) 
	DROP TABLE #TAM
	
SET @sSQL = 'SELECT HT89.*,	HT91.EmployeeID,
					Ltrim(RTrim(isnull(HT00.LastName,'''')))+ '' '' + LTrim(RTrim(isnull(HT00.MiddleName,''''))) + '' '' + LTrim(RTrim(Isnull(HT00.FirstName,''''))) As FullName,
					datename(dw,HT89.TrackingDate) as TrackingDateName,AT1102.DepartmentName, HT1101.TeamName, HT1020.ShiftName, HT1015.ProductName, HT1015.UnitPrice,
					
					(Select sum(AbsentAmount) from HT0284 Where DivisionID = HT89.DivisionID And convert(nvarchar(10),AbsentDate,101) = convert(nvarchar(10),HT89.TrackingDate,101)
						And Isnull(ShiftID,'''') = HT89.ShiftID And EmployeeID = HT91.EmployeeID) as AbsentAmount,
						
					(
					(Select sum(AbsentAmount) from HT0284 Where DivisionID = HT89.DivisionID And convert(nvarchar(10),AbsentDate,101) = convert(nvarchar(10),HT89.TrackingDate,101) And Isnull(ShiftID,'''') = HT89.ShiftID And EmployeeID = HT91.EmployeeID)
					* HT89.Quantity * HT1015.UnitPrice
					/ (Select sum(AbsentAmount) from HT0284 Where DivisionID = HT89.DivisionID And convert(nvarchar(10),AbsentDate,101) = convert(nvarchar(10),HT89.TrackingDate,101) And Isnull(ShiftID,'''') = HT89.ShiftID And DepartmentID = HT89.DepartmentID And Isnull(TeamID,'''') = HT89.TeamID)	
					) as EmployeeAmount
			INTO #TAM		
			FROM HT0289 HT89
			INNER JOIN HT0291 HT91 On HT89.DivisionID = HT91.DivisionID And HT89.AllocationID = HT91.AllocationID
			INNER JOIN HT1400 HT00 On HT91.DivisionID = HT00.DivisionID And HT91.EmployeeID = HT00.EmployeeID
			INNER JOIN AT1102 On HT89.DivisionID = AT1102.DivisionID And HT89.DepartmentID = AT1102.DepartmentID
			LEFT JOIN HT1101 On HT89.DivisionID = HT1101.DivisionID And HT89.TeamID = HT1101.TeamID
			LEFT JOIN HT1020 On HT89.DivisionID = HT1020.DivisionID And HT89.ShiftID = HT1020.ShiftID
			LEFT JOIN HT1015 On HT89.DivisionID = HT1015.DivisionID And HT89.ProductID = HT1015.ProductID
			
			WHERE HT89.DivisionID = ''' + @DivisionID + '''
			AND HT89.TranMonth = ' + LTRIM(@TranMonth) + ' AND HT89.TranYear = ' + LTRIM(@TranYear) + '
			AND HT89.DepartmentID like ''' + @DepartmentID + ''' AND HT89.TeamID like ''' + @TeamID + '''
			AND HT91.EmployeeID like ''' + @EmployeeID + '''
			
			ORDER BY HT89.DepartmentID, HT89.TeamID, HT89.TrackingDate, HT89.ShiftID, HT89.ProductID, HT91.EmployeeID '			

SET @sSQL = @sSQL + '
			SELECT DepartmentID, DepartmentName, TeamID, TeamName, TrackingDate, ShiftID, ShiftName, ProductID as ItemID, ProductName as ItemName,
					0 as TypeID, NULL as AbsentAmount, max(Quantity) as Quantity, max(UnitPrice) as UnitPrice, (Isnull(max(Quantity),0) * Isnull(max(UnitPrice),0)) as Amount
			FROM #TAM
			GROUP BY DepartmentID, DepartmentName, TeamID, TeamName, TrackingDate, ShiftID, ShiftName, ProductID, ProductName
			UNION ALL
			SELECT DepartmentID, DepartmentName, TeamID, TeamName, TrackingDate, ShiftID, ShiftName, EmployeeID as ItemID, FullName as ItemName,
					1 as TypeID, sum(AbsentAmount), NULL as Quantity, max(UnitPrice) as UnitPrice, sum(EmployeeAmount) as Amount
			FROM #TAM
			GROUP BY DepartmentID, DepartmentName, TeamID, TeamName, TrackingDate, ShiftID, ShiftName, EmployeeID, FullName
			ORDER BY DepartmentID, TeamID, TrackingDate, ShiftID, TypeID, ItemID'
EXEC(@sSQL)

			


