----- Created by: Dang Le Bao Quynh, date: 08/10/2007  
----- Purpose: Xu ly cham cong quet the .  
----- Modify on 25/07/2013 by Bảo Anh: Bổ sung trường hợp là ngày nghỉ bù (Thuận Lợi)  
----- Modify on 15/11/2013 by Khanh Van: Cai thien toc do
----- Modify on 30/06/2015 by Bảo Anh: Bổ sung chấm công theo từng nhân viên
----- Modify on 08/07/2015 by Bảo Anh: Cải tiến tốc độ
/********************************************  
'* Edited by: [GS] [Thành Nguyên] [02/08/2010]  
'********************************************/  
--- Hp2431 'CTY',11,2014,'11/01/2014','11/30/2014','%','admin','%'
SET NOCOUNT ON
GO
  
ALTER PROCEDURE [dbo].[HP2431]  @DivisionID nvarchar(50),      
    @TranMonth int,  
    @TranYear int,
    @FromDate datetime,  
    @ToDate datetime,  
    @DepartmentID nvarchar(50),  
    @CreateUserID nvarchar(50),
	@EmployeeID nvarchar(50) = '%'                                                     
AS  
  
DECLARE  @DateProcess datetime,  
  @DateTypeID nvarchar(3),  
  @TempDate datetime
  
Set @TempDate = DateAdd(d,2,@ToDate)
   
Delete HTT2408  
Insert into HTT2408  
Select HT08.APK,HT08.DivisionID,HT08.EmployeeID,HT08.TranMonth,HT08.TranYear,
		HT08.AbsentCardNo, HT08.AbsentDate, HT08.AbsentTime, HT08.CreateUserID,
		HT08.CreateDate, HT08.LastModifyUserID, HT08.LastModifyDate, HT08.MachineCode, HT08.ShiftCode,
		HT08.IOCode, HT08.InputMethod
	From HT2408 HT08
	inner join HT1400 T00 on T00.EmployeeID = HT08.EmployeeID and T00.DivisionID = HT08.DivisionID 
Where	HT08.AbsentDate between @FromDate and @TempDate  
		and HT08.DivisionID =@DivisionID 
		and T00.DepartmentID like @DepartmentID 
		and HT08.EmployeeID like @EmployeeID

Set @DateProcess = @FromDate  
--Lap tung ngay va thuc hien viec tinh toan  
While @DateProcess <= @ToDate  
Begin  
 --Gan gia tri DataTypeID, xac dinh ngay thu may trong tuan  
 IF exists (Select Top 1 1 From HT1026 Where DivisionID = @DivisionID And Tranyear = @TranYear And Holiday = @DateProcess And Isnull(IsTimeOff,0) = 0)  
  Set @DateTypeID = 'HOL'  
 ELSE IF exists (Select Top 1 1 From HT1026 Where DivisionID = @DivisionID And Tranyear = @TranYear And Holiday = @DateProcess And Isnull(IsTimeOff,0) <> 0)  
  Set @DateTypeID = 'SUN'  
 Else  
  Set @DateTypeID = DateName(dw,@DateProcess)  
  
 EXEC HP2432 @DivisionID, @TranMonth, @TranYear, @DateProcess, @DateTypeID, @DepartmentID, @CreateUserID, @EmployeeID 
  
 Set @DateProcess = DateAdd(d,1,@DateProcess)  
End

SET NOCOUNT OFF