/****** Object:  StoredProcedure [dbo].[HP1025]    Script Date: 07/29/2010 13:48:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

--Create by: Dang Le Bao Quynh; Date: 26/09/2007
--Purpose: Tao view phuc vu truy van bang phan ca cong viec
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [30/07/2010]
'**************************************************************/
ALTER PROCEDURE [dbo].[HP1025] 
				@DivisionID nvarchar(50),
				@DepartmentID nvarchar(50),
				@TeamID nvarchar(50),
				@EmployeeID nvarchar(50),
				@TranMonth int,
				@TranYear int

AS

DECLARE @sSQL nvarchar(4000)	
	Set @sSQL = 	'Select HT10.DivisionID, HT10.TransactionID, HT10.EmployeeID, (Select FullName From HV1400 Where EmployeeID = HT10.EmployeeID) As FullName, 
			HT10.D01,HT10.D02,HT10.D03,HT10.D04,HT10.D05,HT10.D06,HT10.D07,HT10.D08,HT10.D09,HT10.D10,
			HT10.D11,HT10.D12,HT10.D13,HT10.D14,HT10.D15,HT10.D16,HT10.D17,HT10.D18,HT10.D19,HT10.D20,
			HT10.D21,HT10.D22,HT10.D23,HT10.D24,HT10.D25,HT10.D26,HT10.D27,HT10.D28,HT10.D29,HT10.D30,HT10.D31,HT10.Notes   
			From HT1025 HT10  
			Where 	HT10.DivisionID = ''' + @DivisionID + ''' And  
				HT10.EmployeeID Like ''' + @EmployeeID + ''' And 
				HT10.EmployeeID In 
					(Select EmployeeID From HT2400 
					Where 	DivisionID  = ''' + @DivisionID + ''' And DepartmentID Like ''' + @DepartmentID + ''' And 
						isnull(TeamID,'''') Like ''' + @TeamID + ''' And TranMonth = ' + ltrim(@TranMonth) + ' And TranYear = ' + ltrim(@TranYear) + ') And
				HT10.TranMonth = ' + ltrim(@TranMonth) + ' And 
				HT10.TranYear = ' + ltrim(@TranYear)

If not exists (Select id From sysobjects Where id = Object_id('HV1025') And Xtype = 'V')
	EXEC ( 'Create View HV1025 -- Create by HP1025 
		As 
		' + @sSQL
			)
Else
	EXEC ( 'Alter View HV1025 -- Create by HP1025 
		As 
		' + @sSQL
			)
 
	Set @sSQL = 	'Select HT24.DivisionID, Null As TransactionID, HT24.EmployeeID, HV14.FullName, 
			Null As D01,Null As D02,Null As D03,Null As D04,Null As D05,Null As D06,Null As D07,Null As D08,Null As D09,Null As D10,
			Null As D11,Null As D12,Null As D13,Null As D14,Null As D15,Null As D16,Null As D17,Null As D18,Null As D19,Null As D20,
			Null As D21,Null As D22,Null As D23,Null As D24,Null As D25,Null As D26,Null As D27,Null As D28,Null As D29,Null As D30,Null As D31,Null As Notes   
			From HT2400 HT24  Left Join HV1400 HV14 On HT24.EmployeeID = HV14.EmployeeID and HT24.DivisionID = HV14.DivisionID 
			Where 	HT24.DivisionID = ''' + @DivisionID + ''' And  
				HT24.DepartmentID Like ''' + @DepartmentID + ''' And 
				isnull(HT24.TeamID,'''') Like ''' + @TeamID + ''' And 
				HT24.EmployeeID Like ''' + @EmployeeID + ''' And 
				HT24.TranMonth = ' + ltrim(@TranMonth) + ' And 
				HT24.TranYear = ' + ltrim(@TranYear) + ' And 
				HT24.EmployeeID Not In 
				(Select EmployeeID From HT1025 Where DivisionID = ''' + @DivisionID + ''' And TranMonth = ' + ltrim(@TranMonth) + ' And TranYear = ' + ltrim(@TranYear) + ') And 
				HV14.EmployeeStatus = 1' 

If not exists (Select id From sysobjects Where id = Object_id('HV1026') And Xtype = 'V')
	EXEC ( 'Create View HV1026 -- Create by HP1025 
		As 
		' + @sSQL
			)
Else
	EXEC ( 'Alter View HV1026 -- Create by HP1025 
		As 
		' + @sSQL
			)