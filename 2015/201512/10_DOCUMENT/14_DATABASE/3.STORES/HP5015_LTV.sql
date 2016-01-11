IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP5015_LTV]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP5015_LTV]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--- Created by Bảo Anh	Date: 16/04/2014
--- Kết chuyển thu nhập cho bộ phận hỗ trợ từ tiền thưởng hoa hồng (Long Trường Vũ)
--- Example: HP5015_LTV 'LTV',1,2014,'PP02','A01','C08'

CREATE PROCEDURE 	[dbo].[HP5015_LTV] 	
					@DivisionID as nvarchar(50),   		---- Don vi tinh luong
					@TranMonth as int, 			---- Ky tinh luong
					@TranYear as int,			---- Nam tinh luong
					@PayrollMethodID as nvarchar(50),	---- PP tinh luong	
					@FromDepartmentID as nvarchar(50),
					@ToDepartmentID as nvarchar(50)
						
AS
	Declare @sSQL as nvarchar(4000),
			@Cur as cursor,
			@ObjectID as nvarchar(50),
			@Amount as decimal(28,8)
			
Set @Cur = Cursor scroll keyset for
SELECT ObjectID, Sum(ConvertedAmount)
FROM CMT0015
WHERE DivisionID = @DivisionID AND TranMonth = @TranMonth AND TranYear = @TranYear AND Status = 1
GROUP BY ObjectID

Open @Cur
Fetch next from @Cur into @ObjectID, @Amount
While @@fetch_status = 0
Begin
	UPDATE HT3400 SET Income05 = @Amount
	WHERE DivisionID = @DivisionID and
		(DepartmentID between @FromDepartmentID and @ToDepartmentID) and
		TranMonth = @TranMonth and 
		TranYear = @TranYear and
		PayrollMethodID = @PayrollMethodID and
		EmployeeID = @ObjectID
		
	Fetch next from @Cur into @ObjectID, @Amount
End
Close @Cur

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

