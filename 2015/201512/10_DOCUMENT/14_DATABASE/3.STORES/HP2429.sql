/****** Object:  StoredProcedure [dbo].[HP2429]    Script Date: 08/02/2010 15:14:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----Created by: Dang Le Bao Quynh, date: 15/10/2007
----purpose: Kiem tra du lieu truoc khi tinh cong
--- Modify on 30/06/2015 by Bảo Anh: Truyền thêm @DepartmentID và @EmployeeID
/********************************************
'* Edited by: [GS] [Thành Nguyên] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[HP2429]  @DivisionID nvarchar(50),				
				@TranMonth int,
				@TranYear int,
				@FromDate datetime,
				@ToDate datetime,
				@DepartmentID nvarchar(50) = '%',
				@EmployeeID nvarchar(50) = '%'
				                                               								
AS

Declare @Status int

Set @Status = 0

IF exists (Select Top 1 1 From  HT2407 Where (AbsentDate between @FromDate and @ToDate)  and
			DivisionID = @DivisionID and
			TranMonth = @TranMonth and
			TranYear = @TranYear and
			EmployeeID like @EmployeeID and
			(Select DepartmentID From HT1400 Where DivisionID = @DivisionID And EmployeeID = HT2407.EmployeeID) like @DepartmentID)
	Begin
		Set @Status =1
	End

Select @Status Status