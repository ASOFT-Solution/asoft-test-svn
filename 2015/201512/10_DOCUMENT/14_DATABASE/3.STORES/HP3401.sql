
/****** Object:  StoredProcedure [dbo].[HP3401]    Script Date: 11/30/2011 16:58:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP3401]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP3401]
GO

/****** Object:  StoredProcedure [dbo].[HP3401]    Script Date: 11/30/2011 16:58:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----Created date: 19/09/2005
----purpose: Luu luong khi hieu chinh luong thang 

/**********************************************
** Edited by: [GS] [Cẩm Loan] [02/08/2010]
***********************************************/

CREATE PROCEDURE [dbo].[HP3401] @DivisionID nvarchar(50),
				@DepartmentID nvarchar(50),
				@TeamID nvarchar(50),
				@EmployeeID nvarchar(50),
				@TranMonth int,
				@TranYear int,
				@IsIncome int,	-------0 la SubAmount, 1 la Income, 2 la TaxAmount
				@Orders int,	------thu tu cua Income, SubAmount tren HT3400, vd Income01 co thu tu la 01
				@SalaryAmount decimal(28,8),
				@PayrollMethodID as nvarchar(50)
				
AS
Declare @sSQL nvarchar(4000),
	@cur cursor,
	@DepartmentID1 nvarchar(50),
	@TeamID1 nvarchar(50),	
	@EmployeeID1 nvarchar(50),
	@TransactionID nvarchar(50)
	



Set @cur = Cursor scroll keyset for
	Select  DepartmentID, TeamID, EmployeeID
		 From HT2400
		Where DivisionID  = @DivisionID and
			DepartmentID like @DepartmentID and
			isnull(TeamID, '')  like isnull(@TeamID, '') and
			EmployeeID like @EmployeeID and
			TranMonth = @TranMonth and
			TranYear = @TranYear 
		 	
Open @cur
Fetch next from @cur into @DepartmentID1, @TeamID1, @EmployeeID1
While @@fetch_status = 0
	Begin 

--------------------------- kiểm tra không tồn tại -------------------	
		if not exists(Select Top 1 1 From HT3400 Where DivisionID = @DivisionID and
							DepartmentID = @DepartmentID1 and
							Isnull(TeamID,'')  like IsNull(@TeamID1,'') and
							EmployeeID = @EmployeeID1 and
							TranMonth = @TranMonth and
							TranYear = @TranYear and 
							PayrollMethodID = @PayrollMethodID )		

			Begin
			Exec AP0000 @DivisionID,  @TransactionID  OUTPUT, 'HT3400', 'EP', @TranYear ,'',15, 3, 0, '-'

--------------------------- insert vào HT3400 -------------------
			insert HT3400 (TransactionID, DivisionID, DepartmentID, TeamID, EmployeeID, TranMonth, TranYear, PayrollMethodID) 
				values  (@TransactionID,@DivisionID, @DepartmentID1, @TeamID1, @EmployeeID1, @TranMonth, @TranYear, @PayrollMethodID) 

--------------------------- update vào HT3400 -------------------
			Update  HT3400			
				Set		Income01 = (Case When @Orders =01 then @SalaryAmount Else Income01 end),
						Income02 = (Case When @Orders =02 then @SalaryAmount Else Income02 end),
						Income03 = (Case When @Orders =03 then @SalaryAmount Else Income03 end),
						Income04 = (Case When @Orders =04 then @SalaryAmount Else Income04 end),
						Income05 = (Case When @Orders =05 then @SalaryAmount Else Income05 end),
						Income06 = (Case When @Orders =06 then @SalaryAmount Else Income06 end),
						Income07 = (Case When @Orders =07 then @SalaryAmount Else Income07 end),
						Income08 = (Case When @Orders =08 then @SalaryAmount Else Income08 end),
						Income09= (Case When @Orders =09 then @SalaryAmount Else Income09 end),
						Income10 = (Case When @Orders =10 then @SalaryAmount Else Income10 end),
						Income11 = (Case When @Orders =11 then @SalaryAmount Else Income11 end),
						Income12 = (Case When @Orders =12 then @SalaryAmount Else Income12 end),
						Income13 = (Case When @Orders =13 then @SalaryAmount Else Income13 end),
						Income14 = (Case When @Orders =14 then @SalaryAmount Else Income14 end),
						Income15 = (Case When @Orders =15 then @SalaryAmount Else Income15 end),
						Income16 = (Case When @Orders =16 then @SalaryAmount Else Income16 end),
						Income17 = (Case When @Orders =17 then @SalaryAmount Else Income17 end),
						Income18 = (Case When @Orders =18 then @SalaryAmount Else Income18 end),
						Income19= (Case When @Orders =19 then @SalaryAmount Else Income19 end),
						Income20 = (Case When @Orders =20 then @SalaryAmount Else Income20 end)

				Where	DivisionID = @DivisionID and
					TransactionID=@TransactionID and
					DepartmentID = @DepartmentID1 and
					Isnull(TeamID,'')  like IsNull(@TeamID1,'') and
					EmployeeID = @EmployeeID1 and
					TranMonth = @TranMonth and
					TranYear = @TranYear and 			
					PayrollMethodID = @PayrollMethodID and
					@IsIncome = 1
					
--------------------------- update vào HT3400 -------------------
			Update  HT3400
				Set 	SubAmount01 = (Case When @Orders = 01 then @SalaryAmount Else SubAmount01 end),
					SubAmount02 = (Case When @Orders = 02 then @SalaryAmount Else SubAmount02 end),
					SubAmount03 = (Case When @Orders = 03 then @SalaryAmount Else SubAmount03 end),
					SubAmount04= (Case When @Orders = 04 then @SalaryAmount Else SubAmount04 end),
					SubAmount05 = (Case When @Orders = 05 then @SalaryAmount Else SubAmount05 end),
					SubAmount06 = (Case When @Orders = 06 then @SalaryAmount Else SubAmount06 end),
					SubAmount07 = (Case When @Orders = 07 then @SalaryAmount Else SubAmount07 end),
					SubAmount08 = (Case When @Orders = 08 then @SalaryAmount Else SubAmount08 end),
					SubAmount09= (Case When @Orders = 09 then @SalaryAmount Else SubAmount09 end),
					SubAmount10 = (Case When @Orders = 10 then @SalaryAmount Else SubAmount10 end), 	
					SubAmount11 = (Case When @Orders = 11 then @SalaryAmount Else SubAmount11 end),
					SubAmount12 = (Case When @Orders = 12 then @SalaryAmount Else SubAmount12 end),
					SubAmount13 = (Case When @Orders = 13 then @SalaryAmount Else SubAmount13 end),
					SubAmount14= (Case When @Orders = 14 then @SalaryAmount Else SubAmount14 end),
					SubAmount15 = (Case When @Orders = 15 then @SalaryAmount Else SubAmount15 end),
					SubAmount16 = (Case When @Orders = 16 then @SalaryAmount Else SubAmount16 end),
					SubAmount17 = (Case When @Orders = 17 then @SalaryAmount Else SubAmount17 end),
					SubAmount18 = (Case When @Orders = 18 then @SalaryAmount Else SubAmount18 end),
					SubAmount19= (Case When @Orders = 19 then @SalaryAmount Else SubAmount19 end),
					SubAmount20 = (Case When @Orders = 20 then @SalaryAmount Else SubAmount20 end)

				Where 	DivisionID = @DivisionID and
				TransactionID=@TransactionID and
				DepartmentID = @DepartmentID1 and
				Isnull(TeamID,'')  like IsNull(@TeamID1,'') and
				EmployeeID = @EmployeeID1 and
				TranMonth = @TranMonth and
				TranYear = @TranYear and 			
				PayrollMethodID = @PayrollMethodID and
				@IsIncome = 0
						
--------------------------- update vào HT3400 -------------------						
			Update  HT3400
					Set 	TaxAmount = @SalaryAmount
					Where 	DivisionID = @DivisionID and
					TransactionID=@TransactionID and
					DepartmentID = @DepartmentID1 and
					Isnull(TeamID,'')  like IsNull(@TeamID1,'') and
					EmployeeID = @EmployeeID1 and
					TranMonth = @TranMonth and
					TranYear = @TranYear and 			
					PayrollMethodID = @PayrollMethodID and
					@IsIncome = 2
			End

--------------------------- if tồn tại -------------------	
		else
		
--------------------------- update vào HT3400 -------------------								
			Update  HT3400
	
			Set		Income01 = (Case When @Orders =01 then @SalaryAmount Else Income01 end),
					Income02 = (Case When @Orders =02 then @SalaryAmount Else Income02 end),
					Income03 = (Case When @Orders =03 then @SalaryAmount Else Income03 end),
					Income04 = (Case When @Orders =04 then @SalaryAmount Else Income04 end),
					Income05 = (Case When @Orders =05 then @SalaryAmount Else Income05 end),
					Income06 = (Case When @Orders =06 then @SalaryAmount Else Income06 end),
					Income07 = (Case When @Orders =07 then @SalaryAmount Else Income07 end),
					Income08 = (Case When @Orders =08 then @SalaryAmount Else Income08 end),
					Income09= (Case When @Orders =09 then @SalaryAmount Else Income09 end),
					Income10 = (Case When @Orders =10 then @SalaryAmount Else Income10 end),
					Income11 = (Case When @Orders =11 then @SalaryAmount Else Income11 end),
					Income12 = (Case When @Orders =12 then @SalaryAmount Else Income12 end),
					Income13 = (Case When @Orders =13 then @SalaryAmount Else Income13 end),
					Income14 = (Case When @Orders =14 then @SalaryAmount Else Income14 end),
					Income15 = (Case When @Orders =15 then @SalaryAmount Else Income15 end),
					Income16 = (Case When @Orders =16 then @SalaryAmount Else Income16 end),
					Income17 = (Case When @Orders =17 then @SalaryAmount Else Income17 end),
					Income18 = (Case When @Orders =18 then @SalaryAmount Else Income18 end),
					Income19= (Case When @Orders =19 then @SalaryAmount Else Income19 end),
					Income20 = (Case When @Orders =20 then @SalaryAmount Else Income20 end)

			Where	DivisionID = @DivisionID and
				DepartmentID = @DepartmentID1 and
				Isnull(TeamID,'')  like IsNull(@TeamID1,'') and
				EmployeeID = @EmployeeID1 and
				TranMonth = @TranMonth and
				TranYear = @TranYear and 			
				PayrollMethodID = @PayrollMethodID and
				@IsIncome = 1

--------------------------- update vào HT3400 -------------------						
			Update  HT3400
				Set 	SubAmount01 = (Case When @Orders = 01 then @SalaryAmount Else SubAmount01 end),
					SubAmount02 = (Case When @Orders = 02 then @SalaryAmount Else SubAmount02 end),
					SubAmount03 = (Case When @Orders = 03 then @SalaryAmount Else SubAmount03 end),
					SubAmount04= (Case When @Orders = 04 then @SalaryAmount Else SubAmount04 end),
					SubAmount05 = (Case When @Orders = 05 then @SalaryAmount Else SubAmount05 end),
					SubAmount06 = (Case When @Orders = 06 then @SalaryAmount Else SubAmount06 end),
					SubAmount07 = (Case When @Orders = 07 then @SalaryAmount Else SubAmount07 end),
					SubAmount08 = (Case When @Orders = 08 then @SalaryAmount Else SubAmount08 end),
					SubAmount09= (Case When @Orders = 09 then @SalaryAmount Else SubAmount09 end),
					SubAmount10 = (Case When @Orders = 10 then @SalaryAmount Else SubAmount10 end), 	
					SubAmount11 = (Case When @Orders = 11 then @SalaryAmount Else SubAmount11 end),
					SubAmount12 = (Case When @Orders = 12 then @SalaryAmount Else SubAmount12 end),
					SubAmount13 = (Case When @Orders = 13 then @SalaryAmount Else SubAmount13 end),
					SubAmount14= (Case When @Orders = 14 then @SalaryAmount Else SubAmount14 end),
					SubAmount15 = (Case When @Orders = 15 then @SalaryAmount Else SubAmount15 end),
					SubAmount16 = (Case When @Orders = 16 then @SalaryAmount Else SubAmount16 end),
					SubAmount17 = (Case When @Orders = 17 then @SalaryAmount Else SubAmount17 end),
					SubAmount18 = (Case When @Orders = 18 then @SalaryAmount Else SubAmount18 end),
					SubAmount19= (Case When @Orders = 19 then @SalaryAmount Else SubAmount19 end),
					SubAmount20 = (Case When @Orders = 20 then @SalaryAmount Else SubAmount20 end)

				Where 	DivisionID = @DivisionID and
				DepartmentID = @DepartmentID1 and
				Isnull(TeamID,'')  like IsNull(@TeamID1,'') and
				EmployeeID = @EmployeeID1 and
				TranMonth = @TranMonth and
				TranYear = @TranYear and 			
				PayrollMethodID = @PayrollMethodID and
				@IsIncome = 0
			
--------------------------- update vào HT3400 -------------------										
		Update  HT3400
				Set 	TaxAmount = @SalaryAmount
				Where 	DivisionID = @DivisionID and
				DepartmentID = @DepartmentID1 and
				Isnull(TeamID,'')  like IsNull(@TeamID1,'') and
				EmployeeID = @EmployeeID1 and
				TranMonth = @TranMonth and
				TranYear = @TranYear and 			
				PayrollMethodID = @PayrollMethodID and
				@IsIncome = 2

Fetch next from @cur into @DepartmentID1, @TeamID1, @EmployeeID1
End
Close @cur

GO


