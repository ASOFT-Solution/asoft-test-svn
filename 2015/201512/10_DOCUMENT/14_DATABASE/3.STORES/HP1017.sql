/****** Object:  StoredProcedure [dbo].[HP1017]    Script Date: 07/29/2010 13:46:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
----Created by: Vo Thanh Huong
----Creadted date: 03/06/2004
----Purpose: Kiem tra truoc khi xoa danh sach san pham duoc cham cong
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [30/07/2010]
'**************************************************************/
ALTER PROCEDURE [dbo].[HP1017]  @DivisionID nvarchar(50),
				@DepartmentID nvarchar(50),
				@TeamID nvarchar(50), 
				@ProductID nvarchar(50)
AS
Declare @Status  as tinyint,
	@VietMess as nvarchar(2000),
	@EngMess as nvarchar(2000)

Set @Status =0
Set @VietMess =''
Set @EngMess =''
If exists(Select Top 1 1 FROM HT2403 Where DivisionID =@DivisionID and
				DepartmentID like @DepartmentID and
				Isnull(TeamID,'') like @TeamID and 
				ProductID = @ProductID)
				
		Begin
			Set @Status =1
			Set @VietMess ='§· chÊm c«ng s¶n phÈm nµy cho nh©n viªn. B¹n không th?!'
			Set @EngMess ='This Product has been absent, you can not delete!'
			Goto MESS
		End


MESS:
Select @Status as Status, @VietMess  As VietMess,  @EngMess as EngMess
