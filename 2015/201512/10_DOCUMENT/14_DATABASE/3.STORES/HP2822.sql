/****** Object:  StoredProcedure [dbo].[HP2822]    Script Date: 09/29/2011 17:19:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2822]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2822]
GO
/****** Object:  StoredProcedure [dbo].[HP2822]    Script Date: 09/29/2011 17:19:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO
--Create User Nguyen Lam Hoa
--Kiem tra viec xoa du lieu cua muc luong tinh dua vao dieu kien nao do

/**********************************************
** Edited by: [GS] [Cẩm Loan] [02/08/2010]
***********************************************/

CREATE PROCEDURE [dbo].[HP2822]  @DivisionID as nvarchar(50), 
				@SalaryCondID as nvarchar(50),
				@TranMonth as int,
				@TranYear as int
						
As 
Declare 
	@Status as tinyint,
	@VietMess as nvarchar(4000),
	@EngMess as nvarchar(4000)
Set @Status=0 
	if exists (Select top 1 1  From HT3400 Where DivisionID = @DivisionID and TranMonth=@TranMonth and TranYear=@TranYear ) 
	  begin
		set @Status=1
		set @VietMess="HFML000141"--'Nhân viên thuộc đơn vị ' + @DivisionID + ' đã được tính lương trong kỳ hiện tại. Nếu bạn xoá thì có thể xảy ra tình trạng dữ liệu không đúng.'
		set @EngMess="HFML000141"--'Employees in division of   ' + @DivisionID + ' has calculated salary for this period. If You delete data that is calculated basing on the condition of ' + @SalaryCondID+ ', data may not synchronize.' 

		goto Return_Values
	  end  	
Return_Values:
	select @Status as Status,@VietMess as VieMessage,@EngMess as  EngMessage
GO


