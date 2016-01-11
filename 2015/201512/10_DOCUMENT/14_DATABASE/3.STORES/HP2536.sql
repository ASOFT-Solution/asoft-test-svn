
/****** Object:  StoredProcedure [dbo].[HP2536]    Script Date: 01/06/2012 11:34:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2536]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2536]
GO

/****** Object:  StoredProcedure [dbo].[HP2536]    Script Date: 01/06/2012 11:34:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

--Created by: Nguyen Lam Hoa  
--Kiem tra in bao cao luong thang  
--Date 14/6/2005  
  
/********************************************  
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]  
'********************************************/  
  
CREATE PROCEDURE [dbo].[HP2536] @DivisionID NVARCHAR(50),  
    @FromDepartmentID NVARCHAR(50),  
    @ToDepartmentID NVARCHAR(50),  
    @TeamID NVARCHAR(50),  
    @FromEmployeeID NVARCHAR(50),   
    @ToEmployeeID NVARCHAR(50),   
    @FromYear int,  
    @FromMonth int,      
    @ToYear int,  
    @ToMonth int,      
    @PayrollMethodID  nvarchar(500)  
         
As   
Declare  @Status as tinyint,  
 @VietMess as nvarchar(2000),  
 @EngMess as nvarchar(2000)  
  
Select  @Status = 0,  @VietMess = '', @EngMess = ''  
  
  
IF @PayrollMethodID = '%'   
BEGIN  
 If not exists (Select top 1 1  From HT3400 Where DivisionID = @DivisionID and   
   DepartmentID between @FromDepartmentID  and  @ToDepartmentID and   
   IsNull(TeamID,'') like IsNull(@TeamID,'') and   
   EmployeeID between @FromEmployeeID and  @ToEmployeeID and   
   TranMonth +TranYear*100 between  @FromMonth+@FromYear*100 and  @ToMonth+@ToYear*100 )   
   Begin  
  
  Set @Status=1  
  Set @VietMess= N'HFML000179' --'B¹n ch­a tÝnh l­¬ng cho nh©n viªn ë phßng ban ®­îc chän theo ph­¬ng ph¸p  '+ @PayrollMethodID+'  nªn kh«ng thÓ xem hoÆc in b¸o c¸o. '  
  Set @EngMess= N'HFML000179' --'Employees of the chosen departments have not been calculated salary by the method of '+ @PayrollMethodID+'. So there is not data to view or print report.'  
  Goto Return_Values  
  End     
END  
/*  
ELSE   
BEGIN  
Set @PayrollMethodID = '''' + replace(@PayrollMethodID, ',',''',''') + ''''  
If not exists (Select top 1 1  From HT3400   
 Where DivisionID  like  @DivisionID and DepartmentID between @FromDepartmentID  and  @ToDepartmentID    
  and IsNull(TeamID,'') like IsNull(@TeamID,'') and   
  EmployeeID between @FromEmployeeID and @ToEmployeeID  
  and TranMonth +TranYear*100 between  @FromMonth+@FromYear*100 and  @ToMonth+@ToYear*100 and   
  PayRollMethodID  in(@PayrollMethodID))  
  Begin  
  
  Set @Status=1  
  Set @VietMess='B¹n ch­a tÝnh l­¬ng cho nh©n viªn ë phßng ban ®­îc chän theo ph­¬ng ph¸p  '+ @PayrollMethodID+'  nªn kh«ng thÓ xem hoÆc in b¸o c¸o. '  
  Set @EngMess= 'Employees of the chosen departments have not been calculated salary by the method of '+ @PayrollMethodID+'. So there is not data to view or print report.'  
  goto Return_Values  
   End     
END  
*/  
Return_Values:  
 Select @Status as Status,@VietMess as VieMessage,@EngMess as  EngMessage
GO


