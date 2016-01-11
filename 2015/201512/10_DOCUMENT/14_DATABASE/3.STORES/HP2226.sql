/****** Object:  StoredProcedure [dbo].[HP2226]    Script Date: 07/30/2010 14:07:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----Created by: Vo Thanh Huong
----Created date: 16/07/2004
----purpose: Tính lao d?ng, qu?  ti?n luong n?p BHXH  d? in b?ng d?i chi?u s? li?u n?p BHXH

/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [30/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[HP2226] @DivisionID  nvarchar(50),
				@TranQuater int,
				@TranYear int, 
				@CreateUserID nvarchar(50)
 AS
DECLARE @cur_Result cursor, 
		@cur_Method cursor,
		@FromMonth int,
		@ToMonth int,
		@TranMonth int,
		@Amount1 decimal(28,8),
		@Amount2 decimal(28,8),
		@Amount3 decimal(28,8)
		
SET @FromMonth = 3*@TranQuater - 2
SET @ToMonth = 3*@TranQuater

SET @cur_Result = CURSOR SCROLL KEYSET FOR
	Select  HT01.TranMonth, 
		COUNT(Distinct HT01.EmployeeID) as Amount1,
		SUM(HT01.BaseSalary * GeneralCo) AS Amount2,
		SUM(SAmount + HAmount + SAmount2  + HAmount2) as Amount3
	From HT2461 HT01 inner join HT2460 HT00 on 
		   HT00.EmployeeID = HT01.EmployeeID and HT01.TranMonth =HT00.TranMonth and HT01.TranYear = HT00.TranYear and HT01.DivisionID = HT00.DivisionID
	Where HT01.DivisionID = @DivisionID and HT01.TranYear = @TranYear  and HT01.TranMonth BETWEEN @FromMonth and @ToMonth
	Group by  HT01.TranMonth

OPEN @cur_Result
FETCH NEXT FROM @cur_Result INTO @TranMonth, @Amount1, @Amount2, @Amount3

While @@FETCH_STATUS = 0
Begin
	If not exists(Select Top 1 1 From HT2224
		 Where DivisionID = @DivisionID and 
			TranQuater = @TranQuater and 
			TranYear = @TranYear  and 
			TranMonth = @TranMonth)
	Insert HT2224(DivisionID, TranQuater, TranYear, TranMonth, Amount1, Amount2, Amount3,
				CreateUserID, CreateDate, LastModifyUserID, LastModifydate) 
		 VALUES (@DivisionID, @TranQuater, @TranYear, @TranMonth, @Amount1, @Amount2, @Amount3,
				@CreateUserID, getdate(), @CreateUserID, getdate()) 

	ELSE
		Update HT2224 SET Amount1 = @Amount1, Amount2 = @Amount2, Amount3 = @Amount3
			 Where DivisionID = @DivisionID and 
				TranQuater = @TranQuater and 
				TranYear = @TranYear  and TranMonth = @TranMonth


FETCH NEXT FROM @cur_Result INTO @TranMonth, @Amount1, @Amount2, @Amount3
END

While @FromMonth <= @ToMonth 
BEGIN
	If not exists(Select Top 1 1 From HT2224
		 Where DivisionID = @DivisionID and 
			TranQuater = @TranQuater and 
			TranYear = @TranYear  and TranMonth = @FromMonth)
	Insert HT2224(DivisionID, TranQuater, TranYear, TranMonth,
		CreateUserID, CreateDate, LastModifyUserID, LastModifydate) 
	Values (	@DivisionID, @TranQuater, @TranYear, @FromMonth,
		@CreateUserID, getdate(), @CreateUserID, getdate()) 		
	SET @FromMonth = @FromMonth + 1
END