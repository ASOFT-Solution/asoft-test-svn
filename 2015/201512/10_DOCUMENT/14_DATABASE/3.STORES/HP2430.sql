/****** Object:  StoredProcedure [dbo].[HP2430]    Script Date: 08/02/2010 15:14:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----Created by: Vo Thanh Huong, date: 05/10/2004
----purpose: Xu ly so lieu tu may ch?m công
--- Modify on 30/06/2015 by Bảo Anh: Bổ sung chấm công theo từng nhân viên
/********************************************
'* Edited by: [GS] [Thành Nguyên] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[HP2430]  @DivisionID nvarchar(50),				
				@TranMonth int,
				@TranYear int,
				@FromDate datetime,
				@ToDate datetime,
				@DepartmentID nvarchar(50),
				@CreateUserID nvarchar(50),
				@EmployeeID nvarchar(50) = '%'                              								
AS

Delete HT2407
From HT2407 HT07 inner join HT1400 T00 on T00.EmployeeID = HT07.EmployeeID and T00.DivisionID = HT07.DivisionID
Where HT07.AbsentDate between @FromDate and @ToDate  
and HT07.DivisionID = @DivisionID 
and HT07.TranMonth = @TranMonth
and HT07.TranYear = @TranYear 
and T00.DepartmentID like @DepartmentID
and T00.EmployeeID like @EmployeeID

-----Xu ly thong tin quet the  
EXEC HP2431  @DivisionID,	 @TranMonth , 		@TranYear,	@FromDate , 	@ToDate , @DepartmentID	,@CreateUserID, @EmployeeID
GO
