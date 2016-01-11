IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2440]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2440]
GO
/****** Object:  StoredProcedure [dbo].[HP2440]    Script Date: 11/02/2011 11:05:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--Create by: Dang Le Bao Quynh; Date: 03/11/2006
--Purpose: Cap nhat he so tham nien vao ho so luong
--- Modify on 04/12/2013 by Bảo Anh: Cập nhật hệ số thâm niên cho phụ cấp công trình
--- Modify on 06/01/2014 by Bảo Anh: Cập nhật hệ số thâm niên = 0 nếu chức vụ khác CN (customize Unicare)
/********************************************
'* Edited by: [GS] [Thành Nguyên] [02/08/2010]
'********************************************/

CREATE PROCEDURE [dbo].[HP2440]
		@MethodID		nvarchar(50),
		@DivisionID 		nvarchar(50),
		@DepartmentID 	nvarchar(50),
		@TeamID		nvarchar(50),
		@EmployeeID		nvarchar(50),
		@TranMonth		int,
		@TranYear		int
AS

DECLARE	@Cur			Cursor,
		@EmployeeIDcur	nvarchar(50),
		@SeniorityOfDate 	int,
		@SeniorityOfMonth	int,
		@CalDate 		Datetime

	Set @CalDate = (Select Top 1 EndDate From HT9999 Where TranMonth = @TranMonth and TranYear = @TranYear and DivisionID=@DivisionID)
	-- Neu du lieu rong thi gan = ngay cuoi thang
	If @Caldate is null
	Begin
		Set @Caldate = 	Case  
				When @TranMonth In (1,3,5,7,8,10,12) then ltrim(@TranMonth) + '/31/' + ltrim(@TranYear)
				When @TranMonth In (4,6,9,11) then ltrim(@TranMonth) + '/30/' + ltrim(@TranYear)
				When @TranMonth = 2 And @TranYear%4=0 then ltrim(@TranMonth) + '/29/' + ltrim(@TranYear)
				Else ltrim(@TranMonth) + '/28/' + ltrim(@TranYear) End
		
	End
	
	if exists (Select Top 1 MethodID From HT1140 Where DivisionID = @DivisionID) And @MethodID is not null And Len(@MethodID)>0
	Update T24 Set  TimeCoefficient = (Case When Not Exists(Select * From HT1141 Where FromMonth <= Round(Datediff(d,T14.Workdate,@Caldate)/30,0) and ToMonth >= Round(Datediff(d,T14.Workdate,@Caldate)/30,0) And MethodID = @MethodID and DivisionID=@DivisionID)
						Then 
							isnull((Select Top 1 Coefficient From HT1141 Where DivisionID=@DivisionID and FromMonth < Round(Datediff(d,T14.Workdate,@Caldate)/30,0) and Tomonth=-1),0)
						Else
							isnull((Select Top 1 Coefficient From HT1141 Where DivisionID=@DivisionID and FromMonth < Round(Datediff(d,T14.Workdate,@Caldate)/30,0) and ToMonth >= Round(Datediff(d,T14.Workdate,@Caldate)/30,0)),0)
						End)
	From HT2400 T24, HT1403 T14
	Where T24.DivisionID=@DivisionID and T24.EmployeeID = T14.EmployeeID and T24.DivisionID = T14.DivisionID 
	And T24.DepartmentID = T14.DepartmentID And IsNull(T24.TeamID,'') = IsNull(T14.TeamID,'')	
	And TranMonth = @TranMonth And TranYear = @TranYear And T14.WorkDate is not null
	And T24.DepartmentID like @DepartmentID And IsNull(T24.TeamID,'') like IsNull(@TeamID,'')
	And T24.EmployeeID like @EmployeeID
	
	--- cập nhật cho phụ cấp công trình
	Declare @AP4444 Table(CustomerName Int, Export Int)
	Declare @CustomerName AS Int
	Insert Into @AP4444(CustomerName,Export) EXEC('AP4444')
	Select @CustomerName=CustomerName From @AP4444
	
	IF @CustomerName in (21,39) --- Unicare
		Update T24 Set  TimeCoefficient = case when T14.DutyID <> 'CN' then 0 else (Case When Not Exists(Select * From HT1141 Where FromMonth <= Round(Datediff(d,T14.Workdate,@Caldate)/30,0) and ToMonth >= Round(Datediff(d,T14.Workdate,@Caldate)/30,0) And MethodID = @MethodID and DivisionID=@DivisionID)
							Then 
								isnull((Select Top 1 Coefficient From HT1141 Where DivisionID=@DivisionID and FromMonth < Round(Datediff(d,T14.Workdate,@Caldate)/30,0) and Tomonth=-1),0)
							Else
								isnull((Select Top 1 Coefficient From HT1141 Where DivisionID=@DivisionID and FromMonth < Round(Datediff(d,T14.Workdate,@Caldate)/30,0) and ToMonth >= Round(Datediff(d,T14.Workdate,@Caldate)/30,0)),0)
							End) end
		From HT2430 T24, HT1403 T14
		Where T24.DivisionID=@DivisionID and T24.EmployeeID = T14.EmployeeID and T24.DivisionID = T14.DivisionID 
		And T24.DepartmentID = T14.DepartmentID And IsNull(T24.TeamID,'') = IsNull(T14.TeamID,'')	
		And TranMonth = @TranMonth And TranYear = @TranYear And T14.WorkDate is not null
		And T24.DepartmentID like @DepartmentID And IsNull(T24.TeamID,'') like IsNull(@TeamID,'')
		And T24.EmployeeID like @EmployeeID
	ELSE
		Update T24 Set TimeCoefficient = (Case When Not Exists(Select * From HT1141 Where FromMonth <= Round(Datediff(d,T14.Workdate,@Caldate)/30,0) and ToMonth >= Round(Datediff(d,T14.Workdate,@Caldate)/30,0) And MethodID = @MethodID and DivisionID=@DivisionID)
						Then 
							isnull((Select Top 1 Coefficient From HT1141 Where DivisionID=@DivisionID and FromMonth < Round(Datediff(d,T14.Workdate,@Caldate)/30,0) and Tomonth=-1),0)
						Else
							isnull((Select Top 1 Coefficient From HT1141 Where DivisionID=@DivisionID and FromMonth < Round(Datediff(d,T14.Workdate,@Caldate)/30,0) and ToMonth >= Round(Datediff(d,T14.Workdate,@Caldate)/30,0)),0)
						End)
		From HT2430 T24, HT1403 T14
		Where T24.DivisionID=@DivisionID and T24.EmployeeID = T14.EmployeeID and T24.DivisionID = T14.DivisionID 
		And T24.DepartmentID = T14.DepartmentID And IsNull(T24.TeamID,'') = IsNull(T14.TeamID,'')	
		And TranMonth = @TranMonth And TranYear = @TranYear And T14.WorkDate is not null
		And T24.DepartmentID like @DepartmentID And IsNull(T24.TeamID,'') like IsNull(@TeamID,'')
		And T24.EmployeeID like @EmployeeID
	
	/*Select T24.EmployeeID,Round(Datediff(d,Workdate,@Caldate)/30,0) as SeniorityOfMonth, 
		(Case When Not Exists(Select * From HT1141 Where FromMonth <= Round(Datediff(d,Workdate,@Caldate)/30,0) and ToMonth >= Round(Datediff(d,Workdate,@Caldate)/30,0) And MethodID = @MethodID)
		Then 
			isnull((Select Top 1 Coefficient From HT1141 Where FromMonth < Round(Datediff(d,Workdate,@Caldate)/30,0) and Tomonth=-1),0)
		Else
			isnull((Select Top 1 Coefficient From HT1141 Where FromMonth < Round(Datediff(d,Workdate,@Caldate)/30,0) and ToMonth >= Round(Datediff(d,Workdate,@Caldate)/30,0)),0)
		End) as Coefficient
		From HT2400 T24, HT1403 T14
		Where T24.EmployeeID = T14.EmployeeID And TranMonth = @TranMonth And TranYear = @TranYear And WorkDate is not null
	*/


