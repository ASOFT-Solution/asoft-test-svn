/****** Object:  StoredProcedure [dbo].[HP2224]    Script Date: 07/30/2010 13:57:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----Created by: Vo Thanh Huong
----Created date: 17/07/2004
----purpose: Ke thua bang doi chieu so lieu nop BHXH, BHYT

/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [30/07/2010]
'********************************************/
 
ALTER PROCEDURE [dbo].[HP2224]  @Mode tinyint,  ---0: ke thua tu khai bao, 1:ke thua tu thang da co
				@DivisionID nvarchar(50),
				@TranQuater int,
				@TranYear int,
				@FromTranQuater int,
				@FromTranYear int,
				@CreateUserID nvarchar(50)
AS

IF @Mode = 0 
	Insert HT2226(DivisionID, TranYear, TranQuater, Orders, 
		 Description,Bold, Amount1, Amount2, Step, Code, Code0)
	Select DivisionID, @TranYear as TranYear, @TranQuater as TranQuater, 
		Orders, Description, Bold, Amount1, Amount2, Step, Code, Code0
	From HT2225 Where DivisionID = @DivisionID
ELSE
	Insert HT2226(DivisionID, TranYear, TranQuater,
		Orders, Description,Bold, Amount1, Amount2, Step, Code, Code0, CreateUserID, CreateDate, LastModifyUserID, LastModifyDate)
	Select @DivisionID as DivisionID, @TranYear as TranYear, @TranQuater as TranQuater,
		Orders,  Description,Bold, Amount1, Amount2, Step, Code, Code0,
		@CreateUserID, getdate(), @CreateUserID, getdate()
	From HT2226
	Where DivisionID = @DivisionID and
		TranYear = @FromTranYear and
		TranQuater = @FromTranQuater 

EXEC HP2226		 @DivisionID,		@TranQuater,  		  @TranYear , 	@CreateUserID


	














