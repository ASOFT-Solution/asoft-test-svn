IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2804]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2804]
GO
--Created by Nguyen Lam Hoa  
--Kiem tra viec xoa du lieu cua ho so phep  
--Date 14/6/2005  
  
/**********************************************  
** Edited by: [GS] [Cẩm Loan] [02/08/2010]  
***********************************************/  
  
CREATE PROCEDURE [dbo].[HP2804]  
	@DivisionID as nvarchar(50),   
    @TranMonth as int,  
    @TranYear as int,  
    @DepartmentID as nvarchar(50),  
    @TeamID as nvarchar(50),  
    @EmployeeID as nvarchar(50)      
As   
Declare   
 @Status as tinyint,  
 @VietMess as nvarchar(4000),  
 @EngMess as nvarchar(4000)  
 ---,@aa as varchar(5000)  
Set @Status=0   
 ----set @aa = 'select DaysSpent from HT2809'  
   
if exists (Select top 1 1  From HT2809 Where DivisionID = @DivisionID and TranMonth=@TranMonth and TranYear=@TranYear and DepartmentID like @DepartmentID  
  and isnull(TeamID,'') LIKE ISNULL(@TeamID,'') and EmployeeID LIKE @EmployeeID and isnull(DaysSpent,0)<>0)  
  begin  
 set @Status=1  
 set @VietMess= N'HFML000181' --'Nhân viên có mã số ' + @EmployeeID + ' đã được tính phép trong kỳ hiện tại, bạn không thể xoá được.'  
 set @EngMess= N'HFML000181' --'Employee with ID as  ' + @EmployeeID + ' has been calculated leave of absence in this period, you cannot delete.'  
 goto Return_Values  
  end     
    
Return_Values:  
 select @Status as Status,@VietMess as VieMessage,@EngMess as  EngMessage  
  