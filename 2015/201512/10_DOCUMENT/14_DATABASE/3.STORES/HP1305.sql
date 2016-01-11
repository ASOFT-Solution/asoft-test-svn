IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP1305]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP1305]
GO
---Created by: Vo Thanh Huong, date: 09/12/2004  
---purpose: Kiem tra truoc khi luu lich su cong tac  
---Edited by: Nguyen Lam Hoa,date:13/12/2004  
/***************************************************************  
'* Edited by : [GS] [Quoc Cuong] [30/07/2010]  
'**************************************************************/  
  
CREATE PROCEDURE [dbo].[HP1305]  @DivisionID nvarchar(50),  
    @EmployeeID nvarchar(50),  
    @IsPast tinyint,    
    @FromMonth int,  
    @FromYear int,  
    @ToMonth int,  
    @ToYear int   
As   
Declare   
 @Status as tinyint,  
 @VietMess as nvarchar(2000),  
 @EngMess as nvarchar(2000)  
Select @Status = 0, @VietMess = '', @EngMess = ''  
  
if exists (Select top 1 1  From HT2400 Where DivisionID = @DivisionID and EmployeeID = @EmployeeID And TranMonth=@FromMonth And TranYear=@FromYear)   
   Begin  
  set @Status=1  
  set @VietMess= N'HFML000360'  --'Nh©n viªn ' + @EmployeeID + ' ®· ®­îc sö dông trong kú nµy. B¹n kh«ng thÓ söa!'   
  set @EngMess= N'HFML000360' -- 'Employee with ID as  ' + @EmployeeID + ' has used at this period,you is not edit'  
  goto Return_Values  
   End     
Return_Values:  
 Select @Status as Status,@VietMess as VieMessage,@EngMess as  EngMessage  
  