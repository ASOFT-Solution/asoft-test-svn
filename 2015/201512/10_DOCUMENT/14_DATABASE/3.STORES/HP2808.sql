IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2808]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2808]
GO
-----Created by Nguyen Lam Hoa  
------ Created Date 30/06/2004  
----- Purpose: Kiem tra truoc khi tinh phep thang  
  
CREATE PROCEDURE  HP2808  @DivisionID as varchar(20),  
     @DepartmentID as varchar(20),  
     @TeamID as varchar(20),  
     @TranMonth as int,  
     @TranYear as int,  
     @GeneralAbsentID as varchar(20)  
        
AS  
  
 Declare @Status as tinyint,  
  @VietMess as varchar(250),  
  @EngMess as varchar(250),  
  @Type as tinyint,  
  @Days as money,  
  @sSQL as varchar(8000),  
  @IsMonth as tinyint,  
  @TimeConvert as money,  
  @FromDate as int,  
  @ToDate as int  
    
    
 Set @Status =0   
 Set @VietMess =''  
 Set @EngMess=''  
  
 Select  @IsMonth = IsMonth,  @FromDate = FromDate, @ToDate = ToDate    
  From HT5002 Where GeneralAbsentID =@GeneralAbsentID  And DivisionID =@DivisionID 
   
  
If not exists (Select top 1 1 From HT2809  Where  DivisionID = @DivisionID  and TranMonth = @TranMonth and TranYear =@TranYear   
  and DepartmentID like @DepartmentID and isnull(TeamID,0) like @TeamID)  
   
 Begin  
  Set @Status =1  
  Set @VietMess = N'HFML000122'--'Ch­a më hå s¬ phÐp th¸ng. B¹n ph¶i më hå s¬ phÐp tr­íc khi tÝnh phÐp th¸ng. '  
  Set @EngMess= N'HFML000122'--'File of leave of absence for this month has not been opened. You need to open it.'  
 End  
  
  
If @IsMonth =1 -----Tu cham cong thang  
    
 Begin  
 if not exists ( select top 1 1 from HT2402 Inner join (Select HT03.AbsentTypeID from HT5003 HT03 inner join HT1013 HT13 on  
     HT03.AbsentTypeID=HT13.AbsentTypeID   
     Where HT03.GeneralAbsentID =  @GeneralAbsentID) HT on HT2402.AbsentTypeID=HT.AbsentTypeID   
   where HT2402.TranMonth=@TranMonth and HT2402.TranYear=@TranYear and HT2402.DivisionID = @DivisionID    
    and HT2402.DepartmentID like @DepartmentID and isnull(HT2402.TeamID,0) like @TeamID)   
     
   
   Begin  
    Set @Status =1  
    Set @VietMess = N'HFML000123' + @DivisionID + N'HFML000124' + @GeneralAbsentID + N'HFML000125'--'§¬n vÞ  '+  @DivisionID + '  kh«ng cã c«ng phÐp '+  @GeneralAbsentID + ' trong th¸ng nµy'  
    Set @EngMess= N'HFML000123' + @DivisionID + N'HFML000124' + @GeneralAbsentID + N'HFML000125'--'No employee in division of  ' +  @DivisionID + ' has time off  of  ' +  @GeneralAbsentID + ' in this month.'  
      
   End  
 End  
   
Else ---tu cham cong ngay   
 Begin  
   if  not exists ( select top 1 1 from HT2401 Inner join (Select HT03.AbsentTypeID from HT5003 HT03 inner join HT1013 HT13 on  
     HT03.AbsentTypeID=HT13.AbsentTypeID   
     Where HT03.GeneralAbsentID =  @GeneralAbsentID ) HT on HT2401.AbsentTypeID=HT.AbsentTypeID   
   where HT2401.TranMonth=@TranMonth and HT2401.TranYear=@TranYear and HT2401.DivisionID like @DivisionID    
   and HT2401.DepartmentID like @DepartmentID and isnull(HT2401.TeamID,0) like @TeamID)   
   
   Begin  
    Set @Status =1  
    Set @VietMess = N'HFML000123' + @DivisionID + N'HFML000124' + @GeneralAbsentID + N'HFML000125'--'§¬n vÞ  ' +  @DivisionID + '  kh«ng cã c«ng phÐp '+  @GeneralAbsentID + ' trong th¸ng nµy'  
    Set @EngMess= N'HFML000123' + @DivisionID + N'HFML000124' + @GeneralAbsentID + N'HFML000125'--'No employee in division of  ' +  @DivisionID + ' has time off  of  ' +  @GeneralAbsentID + ' in this month.'  
   End  
  
 End  
  
If Exists (Select top 1 1 From HT2809  Where GeneralAbsentID=@GeneralAbsentID and DivisionID = @DivisionID  and TranMonth = @TranMonth and TranYear =@TranYear   
  and isnull(DaysSpent,0)<>0 and DepartmentID like @DepartmentID and isnull(TeamID,0) like @TeamID)  
 Begin  
  Set @Status =1  
  Set @VietMess = N'HFML000126' + @GeneralAbsentID + N'HFML000127'--'§· tÝnh phÐp víi c«ng ' +  @GeneralAbsentID + ' trong th¸ng nµy, b¹n kh«ng thÓ tÝnh phÐp lÇn n÷a'  
  Set @EngMess= N'HFML000126' + @GeneralAbsentID + N'HFML000127'--'Time off with ' +  @GeneralAbsentID + ' has been calculated for this month. You need to delete before recalculating. '  
 End  
  
  
--ENDMESS:  
  
Select @Status as Status, @VietMess as VieMessage,@EngMess as EngMessage
  
  
  
  
  
  
  
  
  
  
  
  
  
  