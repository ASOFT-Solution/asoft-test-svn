IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2411]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2411]
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   
----- Kiem tra dieu kien khi xoa bang cham cong ngay  
---- Created by Nguyen Thi Ngoc Minh, Date 08/04/2004  
----Edited by Nguyen Lam Hoa,Date 7/8/2004  
  
/********************************************  
'* Edited by: [GS] [Mỹ Tuyền] [30/07/2010]  
'********************************************/  
  
CREATE PROCEDURE  [dbo].[HP2411]  @DivisionID as nvarchar(50),   
    @DepartmentID as nvarchar(50),   
    @TeamID as nvarchar(50),   
    @EmployeeID as nvarchar(50),  
    @AbsentDate as datetime,  
    @AbsentTypeID as nvarchar(50),  
    @TranMonth as int,  
    @TranYear as int,  
    @IsEdit as tinyint,  
    @AbsentDateID as nvarchar(50)   
 AS  
  
Declare @sSQL as nvarchar(4000),  
  @HV2411Cursor as cursor,  
  @FullName as nvarchar(250),  
  @DepartmentName as nvarchar(250),  
  @Status as tinyint,  
  @VietMess as nvarchar(1000),  
  @EngMess as nvarchar(1000),  
  @BeginDate as datetime,  
  @EndDate as datetime,  
  @TempMonth as nvarchar(2)  
  
Set @Status =0  
Set @VietMess =''  
Set @EngMess =''  
  
Set @TempMonth = Case when @TranMonth <10 then ltrim(rtrim(str(@TranMonth))) else '0' + ltrim(rtrim(str(@TranMonth))) end  
Set @BeginDate = Convert(datetime, @TempMonth + '/01/' + ltrim(rtrim(str(@TranYear))),101)  
Set @TempMonth = Case when @TranMonth+1 <10 then ltrim(rtrim(str(@TranMonth+1))) else '0' + ltrim(rtrim(str(@TranMonth+1))) end  
Set @EndDate = Convert(datetime, @TempMonth + '/01/' + ltrim(rtrim(str(@TranYear))),101) - 1  
  
--If @AbsentDate not between @BeginDate and @EndDate  
  --Begin  
 --Set @VietMess = @VietMess + 'Baïn khoâng theå nhaäp ngaøy chaám coâng ' +  Convert(varchar(10),@AbsentDate,103) + ' trong kyø naøy !'  
-- Set @EngMess = @EngMess + 'You cannot enter the ' +  Convert(varchar(10),@AbsentDate,103) + ' absent date in this period !'  
-- Set @Status = 1  
-- Goto EndMess  
--  End  
    
  
Set @sSQL = '  
Select H01.DivisionID,H01.EmployeeID, H01.DepartmentID, H00.FullName, A02.DepartmentName  
From HT2401 as H01 inner join HV1400 as H00 on H01.EmployeeID = H00.EmployeeID and H01.DivisionID = H00.DivisionID  
   inner join AT1102 as A02 on H01.DepartmentID = A02.DepartmentID and H01.DivisionID = A02.DivisionID  
Where H01.DivisionID like ''' + @DivisionID + ''' and  
 H01.DepartmentID like ''' + @DepartmentID + ''' and  
 isnull(H01.TeamID,'''') like ''' + @TeamID + ''' and  
 H01.EmployeeID like ''' + @EmployeeID + ''' and  
 H01.AbsentTypeID = ''' + @AbsentTypeID + ''' and  
 H01.AbsentDate = ''' +  Convert(nvarchar(10),@AbsentDate,21) +''''  
  
  
If not Exists (Select 1 From  sysObjects Where Xtype ='V' and Name ='HV2411')  
 Exec(' Create view HV2411 as '+@sSQL)  
Else  
 Exec(' Alter view HV2411 as '+@sSQL)  
  
SET @HV2411Cursor = CURSOR SCROLL KEYSET FOR  
  SELECT *  
  FROM HV2411   
If Exists (Select EmployeeID From HV2411 Where DivisionID = @DivisionID)  
  Begin  
 Set @Status = 1  
 Set @VietMess = @VietMess + N'HFML000230' --'B¹n kh«ng theå chÊm cïng 1 lo¹i chÊm c«ng ' + char(13) + 'cho cïng 1 nh©n viªn trong cïng 1 ngµy'  
 Set @EngMess = @EngMess + N'HFML000230' --'You cannot choose the same absent type ' + char(13) + 'for a same employee in a same day: '  
  End  
  
OPEN @HV2411Cursor  
FETCH NEXT FROM @HV2411Cursor INTO @DivisionID, @EmployeeID, @DepartmentID, @FullName, @DepartmentName  
  
WHILE @@FETCH_STATUS = 0  
  BEGIN  
 Set @VietMess = @VietMess + char(13) + @FullName + ' - ' + @DepartmentName + ', '  
 Set @EngMess = @EngMess + char(13) + @FullName + ' - ' + @DepartmentName + ', '  
 FETCH NEXT FROM @HV2411Cursor INTO @DivisionID,@EmployeeID, @DepartmentID, @FullName, @DepartmentName  
  END  
CLOSE @HV2411Cursor  
DEALLOCATE @HV2411Cursor    
  
If Exists (Select EmployeeID From HV2411 Where DivisionID = @DivisionID)  
  Begin  
 Set @VietMess = left(ltrim(rtrim(@VietMess)),len(ltrim(rtrim(@VietMess)))-1) + '.'  
 Set @EngMess = left(ltrim(rtrim(@EngMess)),len(ltrim(rtrim(@EngMess)))-1) + '.'  
  End  
Goto EndMess  
  
EndMess:  
 Select @Status as Status, @VietMess as VieMessage, @EngMess as EngMessage  
  
  