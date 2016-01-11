IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP2522]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP2522]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




---date 7/4/2005
---purpose : In bao cao tam ung
---Edit by Huynh Trung Dung ,date 14/12/2010 --- Them tham so @ToDepartmentID

CREATE PROCEDURE HP2522 @DivisionID varchar(50),
				@DepartmentID nvarchar(50),
				@ToDepartmentID nvarchar(50),
				@TeamID nvarchar(50),
				@EmployeeID nvarchar(50), 
				@FromDate datetime,
				@ToDate datetime	
							
AS
declare	@sSQL  nvarchar(4000)

set @sSQL='Select H5.AdvanceID, H5.DivisionID, H5.DepartmentID, AT1102.DepartmentName, H5.TeamID, HT1101.TeamName, H5.EmployeeID, HV4.FullName,
		H5.TranMonth, H5.TranYear, H5.AdvanceDate, H5. AdvanceAmount, H5.Description 
		From HT2500 H5 left join HV1400 HV4 on H5.DivisionID=HV4.DivisionID and H5.EmployeeID=HV4.EmployeeID 
		left join AT1102 on H5.DepartmentID=AT1102.DepartmentID and H5.DivisionID=AT1102.DivisionID 
		left join HT1101 on H5.TeamID=HT1101.TeamID and H5.DivisionID=HT1101.DivisionID'
Set @sSQL=@sSQL+ '  Where H5.DivisionID = ''' + @DivisionID + ''' and
		H5.DepartmentID between ''' + @DepartmentID +  ''' and ''' + @ToDepartmentID +  ''' and
		isnull(H5.TeamID,'''') like ''' + ISNULL(@TeamID, '')  + ''' and
		H5.EmployeeID like ''' + @EmployeeID +  ''' and
		H5.AdvanceDate between  '''+convert(varchar(10),@FromDate,101)+'''  and '''+convert(varchar(10),@ToDate,101)+'''  		
		Group by  H5.AdvanceID, H5.DivisionID, H5.DepartmentID, AT1102.DepartmentName,H5.TeamID, HT1101.TeamName,H5.EmployeeID, HV4.FullName,
		H5.TranMonth, H5.TranYear, H5.AdvanceDate, H5. AdvanceAmount, H5.Description '

 If  exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2522')
	Drop view HV2522
exec('Create view HV2522 ----created by HP2522
	as  ' + @sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

