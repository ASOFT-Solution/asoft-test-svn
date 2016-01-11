/****** Object:  StoredProcedure [dbo].[HP2807]    Script Date: 07/30/2010 10:22:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2807]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2807]
GO

/****** Object:  StoredProcedure [dbo].[HP2807]    Script Date: 07/30/2010 10:22:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

--Created by Nguyen Lam Hoa
--Kiem tra viec ke thua cua ho so phep
--Date 14/6/2005

/**********************************************
** Edited by: [GS] [Cẩm Loan] [02/08/2010]
***********************************************/

CREATE PROCEDURE [dbo].[HP2807]  @DivisionID as nvarchar(50), 
				@TranMonth as int,
				@TranYear as int
							
As 
Declare 
	@Status as tinyint,
	@VietMess as nvarchar(4000),
	@EngMess as nvarchar(4000)
Set @Status=0 

if exists (Select top 1 1  From HT2809 Where DivisionID = @DivisionID and TranMonth=@TranMonth and TranYear=@TranYear ) 
  begin
	set @Status=1
	set @VietMess='Hồ sơ phép của đơn vị ' + @DivisionID+' trong tháng ' + cast(@TranMonth as varchar(2)) + ' đã kế thừa, bạn không thể kế thừa được nữa. '
	set @EngMess= 'File of Leave of Absence of this month has been opened. Delete it before reopening. '
	goto Return_Values
  end  	
  
Return_Values:
	select @Status as Status,@VietMess as VietMess,@EngMess as  EngMess



GO

