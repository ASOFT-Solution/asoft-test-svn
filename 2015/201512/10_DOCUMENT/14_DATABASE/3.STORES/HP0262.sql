IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0262]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0262]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--- Created by Bao Anh		Date: 09/01/2013
--- Purpose: Store tra ra du lieu khi edit thong ke san xuat

CREATE PROCEDURE [dbo].[HP0262] 
	@DivisionID as nvarchar(50),
	@ProducingProcessID as nvarchar(50),
	@StepID as nvarchar(50),
	@ShiftID as nvarchar(50),
	@WorkingDate as Datetime
as
declare @sSQL as nvarchar(4000)
		
set @sSQL = N'SELECT * FROM (
	Select HT0260.*, HT1900.ProducingProcessName, HT1901.StepName, HT1020.ShiftName, HT1015.ProductName, HV1400.FullName
	From HT0260
	
	Inner join HT1900
		on HT0260.ProducingProcessID = HT1900.ProducingProcessID
		And HT0260.DivisionID = HT1900.DivisionID
	Inner join HT1901
		on HT0260.StepID = HT1901.StepID
		And HT0260.DivisionID = HT1901.DivisionID
	Inner join HT1020
		on HT0260.ShiftID = HT1020.ShiftID
		And HT0260.DivisionID = HT1020.DivisionID
	Inner join HT1015
		on HT0260.ProductID = HT1015.ProductID
		And HT0260.DivisionID = HT1015.DivisionID
	Left join HV1400
		on HT0260.Tester = HV1400.EmployeeID
		And HT0260.DivisionID = HV1400.DivisionID
		
	Where HT0260.DivisionID = ''' + @DivisionID + '''
		And HT0260.ProducingProcessID = ''' + @ProducingProcessID + '''
		And HT0260.StepID = ''' + @StepID + '''
		And HT0260.ShiftID = ''' + @ShiftID + '''
		And WorkingDate = ''' + convert(varchar(20), @WorkingDate,101) + '''
	
	) A Order by ProductID'
	
EXEC(@sSQL)
