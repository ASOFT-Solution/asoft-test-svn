/****** Object:  StoredProcedure [dbo].[HP2403]    Script Date: 11/16/2011 17:35:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2403]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2403]
GO


/****** Object:  StoredProcedure [dbo].[HP2403]    Script Date: 11/16/2011 17:35:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO
--Created by Nguyen Lam Hoa
--Kiem tra viec xoa du lieu cua bang luong
----- Modify on 17/10/2014 Trí Thiện: Bổ sung kiểm tra dữ liệu đã chấm công và tính phụ cấp theo công trình
----- Modify on 06/02/2015 Quốc Tuấn: Kiểm tra thêm kỳ kế toán vào chấm công công trình

/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [30/07/2010]
'********************************************/

CREATE PROCEDURE [dbo].[HP2403]  @DivisionID as nvarchar(50), 
				@TranMonth as int,
				@TranYear as int,
				@DepartmentID as nvarchar(50),
				@TeamID as nvarchar(50),
				@EmployeeID as nvarchar(50)				
As 
Declare 
	@Status as tinyint,
	@VietMess as nvarchar(2000),
	@EngMess as nvarchar(2000)
Set @Status=0 
	if exists (Select top 1 1  From HT3400 Where DivisionID = @DivisionID and TranMonth=@TranMonth and TranYear=@TranYear and DepartmentID=@DepartmentID
			and isnull(TeamID,'')=ISNULL(@TeamID,'') and EmployeeID LIKE @EmployeeID) 
	  begin
		set @Status=1
		set @VietMess="HFML000294"
		set @EngMess= "HFML000294"--'Employee with ID as  ' + @EmployeeID + ' has calculated salary for this period, you cannot delete'
		goto Return_Values
	  end

---Kiem tra trong bang cham cong

	  if exists (Select top 1 1  From HT2401 Where DivisionID = @DivisionID and TranMonth=@TranMonth and TranYear=@TranYear and DepartmentID=@DepartmentID
			and isnull(TeamID,'')=ISNULL(@TeamID,'') and EmployeeID LIKE @EmployeeID) 
	  begin
		set @Status=1
		set @VietMess="HFML000295"--'Nh©n viªn cã m· sè ' + @EmployeeID + ' ®· ®­îc chÊm c«ng trong kú hiÖn t¹i, b¹n kh«ng thÓ xo¸ ®­îc'
		set @EngMess= "HFML000295"--'Employee with ID as  ' + @EmployeeID + ' has timekeeping for this period, you cannot delete'
		goto Return_Values
	  end

	  if exists (Select top 1 1  From HT2402 Where DivisionID = @DivisionID and TranMonth=@TranMonth and TranYear=@TranYear and DepartmentID=@DepartmentID
			and isnull(TeamID,'')=ISNULL(@TeamID,'') and EmployeeID LIKE @EmployeeID) 
	  begin
		set @Status=1
		set @VietMess="HFML000295"--'Nh©n viªn cã m· sè ' + @EmployeeID + ' ®· ®­îc chÊm c«ng trong kú hiÖn t¹i, b¹n kh«ng thÓ xo¸ ®­îc'
		set @EngMess= "HFML000295"--'Employee with ID as  ' + @EmployeeID + ' has timekeeping for this period, you cannot delete'
		goto Return_Values
	  end

	  --- >>> Đã chấm công công trình
	  if exists (Select top 1 1  From HT2416 Where DivisionID = @DivisionID and  EmployeeID LIKE @EmployeeID and TranMonth=@TranMonth and TranYear=@TranYear) 
	  begin
		set @Status=1
		set @VietMess="HFML000498"--'Nhân viên có mã số {0} đã được chấm công cho công trình, bạn không thể xóa được.'
		set @EngMess= "HFML000498"--'Nhân viên có mã số {0} đã được chấm công cho công trình, bạn không thể xóa được.'
		goto Return_Values
	  end

	  --- >>> Đã tính phụ cấp công trình cho hồ sơ lương
	  if exists (Select top 1 1  From HT2430 Where DivisionID = @DivisionID and  EmployeeID LIKE @EmployeeID and TranMonth=@TranMonth and TranYear=@TranYear) 
	  begin
		set @Status=1
		set @VietMess="HFML000499"--'Nhân viên có mã số {0} đã được tính phụ cấp công trìnhh, bạn không thể xóa được.'
		set @EngMess= "HFML000499"--'Nhân viên có mã số {0} đã được tính phụ cấp công trình, bạn không thể xóa được.'
		goto Return_Values
	  end
  	
Return_Values:
	select @Status as Status,@VietMess as VieMessage,@EngMess as  EngMessage

GO


