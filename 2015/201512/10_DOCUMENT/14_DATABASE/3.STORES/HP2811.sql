

/****** Object:  StoredProcedure [dbo].[HP2811]    Script Date: 12/30/2011 17:06:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2811]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2811]
GO



/****** Object:  StoredProcedure [dbo].[HP2811]    Script Date: 12/30/2011 17:06:24 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER ON
GO

---Edit by Huynh Trung Dung ,date 14/12/2010  --- Them tham so @ToDepartmentID

CREATE PROCEDURE [dbo].[HP2811]  	@DivisionID nvarchar(50),
					@DepartmentID nvarchar(50),
					@ToDepartmentID nvarchar(50),
					@TranMonth int,
					@TranYear int
AS
DECLARE @sSQL nvarchar(4000)
SELECT @sSQL = ''
SET @sSQL = 'SELECT Distinct HT.DivisionID,HV.EmployeeID, HV.FullName, HV.DepartmentID,  
			HV.LoaCondName, HT.DaysPrevYear, HT.DaysInYear,
			HT.DaysSpent, HT.DaysRemained, HT.IsAdded,
			HV.WorkDate,HT.WorkTerm
FROM HT2803 HT inner join HV1400 HV on HT.EmployeeID = HV.EmployeeID AND HT.DivisionID = HV.DivisionID
WHERE HV.DivisionID = ''' + @DivisionID + ''' and
		HV.DepartmentID between ''' + @DepartmentID + ''' and ''' + @ToDepartmentID + ''' and
		HT.TranMonth = ' + str(@TranMonth) + ' and
		HT.TranYear = ' + str(@TranYear) 
--EXEC ( @sSQL)
if not exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2811')
	exec('Create view HV2811 ---- tao boi HP2811
				as ' + @sSQL)
else
	exec('Alter view HV2811 ---- tao boi HP2811
				as ' + @sSQL)



GO


