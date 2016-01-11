/****** Object:  StoredProcedure [dbo].[HP2227]    Script Date: 07/30/2010 14:13:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----Created by: Vo Thanh Huong
----Created date: 23/07/2004
----purpose: Ke thua d? li?u báo cáo tình hình s? d?ng lao d?ng

/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [30/07/2010]
'********************************************/
 
ALTER PROCEDURE [dbo].[HP2227] @Mode tinyint,  ---0: ke thua tu khai bao, 1:ke thua tu thang da co
				@DivisionID nvarchar(50),
				@TranQuater int,
				@TranYear int,
				@FromTranQuater int,
				@FromTranYear int,
				@CreateUserID nvarchar(50)	
AS

IF @Mode = 0 
	Insert HT2228(Orders, DivisionID, TranYear, TranQuater, 
			Bold, Frame, Step, Code, Code0, Sign,
			Caption1, Caption2, Amount1, Amount2, FCaption1, FCaption2,
			CreateUserID, CreateDate, LastModifyUserID, LastModifyDate)		
		Select Orders, @DivisionID, @TranYear, @TranQuater, 
			Bold, Frame, Step, Code, Code0, Sign,
			Caption1, Caption2, Amount1, Amount2, FCaption1, FCaption2,
			@CreateUserID, getdate(), @CreateUserID, getdate()
		From HT2223 Where DivisionID = @DivisionID
ELSE
	Insert HT2228(Orders, DivisionID, TranYear, TranQuater, 
			Bold, Frame, Step, Code, Code0, Sign,
			Caption1, Caption2, Amount1, Amount2, FCaption1, FCaption2,
			CreateUserID, Createdate, LastModifyUserID, LastModifyDate )		
		Select Orders, @DivisionID, @TranYear, @TranQuater, 
			Bold, Frame, Step, Code, Code0, Sign,
			Caption1, Caption2, Amount1, Amount2, FCaption1, FCaption2, 
			@CreateUserID, getdate(), @CreateUserID, getdate()
		From HT2228
	 	Where DivisionID = @DivisionID and
			TranYear = @FromTranYear and
			TranQuater = @FromTranQuater