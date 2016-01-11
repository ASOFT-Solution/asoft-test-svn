/****** Object:  StoredProcedure [dbo].[HP2435]    Script Date: 08/02/2010 15:14:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---Created by : Dang Le Bao Quynh, Date : 15/10/2007
---Purpose: Kiem tra du lieu truoc khi ket chuyen sang cham cong ngay 
--- Modify on 27/12/2013 by Bao Anh: Sửa thứ tự Where cho các bảng HT2407, HT2401 theo Index để cải thiện tốc độ
/********************************************
'* Edited by: [GS] [Thành Nguyên] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[HP2435]   	@DivisionID nvarchar(50),
					@DepartmentID nvarchar(50),
					@EmployeeID nvarchar(50),
				 	@TranMonth int,
				 	@TranYear int,
				 	@FromDate datetime,
				 	@ToDate datetime
				
AS

Declare @Status int

Set @Status = 0

If exists (Select Top 1 1 From HT2401 Where DivisionID = @DivisionID and TranYear = @TranYear And TranMonth = @TranMonth
			and DepartmentID Like @DepartmentID And EmployeeID Like @EmployeeID and	(AbsentDate between @FromDate and @ToDate))
	Begin
		Set @Status = 1
	End

Select @Status as Status
