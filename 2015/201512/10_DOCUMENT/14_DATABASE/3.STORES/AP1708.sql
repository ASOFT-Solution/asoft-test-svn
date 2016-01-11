/****** Object:  StoredProcedure [dbo].[AP1708]    Script Date: 07/28/2010 15:44:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP1708]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AP1708]
GO

/****** Object:  StoredProcedure [dbo].[AP1708]    Script Date: 07/28/2010 15:44:40 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER ON
GO

------ Created by Thuy tuyen , Date 29/12/2006
------ Purpose Xoa but toan ket chuyen phan bo
------ Edit by: Dang Le Bao Quynh; date: 27/04/2007
------ Purpose: Xoa but toan ket chuyen theo chi tiet va tat ca
----- Modify on 24/03/2014 by Bảo Anh: Xóa nghiệp vụ tạm ứng ở HRM được kết chuyển từ phân bổ
/**********************************************
** Edited by: [GS] [Cẩm Loan] [29/07/2010]
***********************************************/

CREATE PROCEDURE [dbo].[AP1708] @DivisionID as nvarchar(50),
				@TranMonth as int,
				@TranYear as int,
				@D_C  as  nvarchar (50),
				@JobID as nvarchar(50)

AS
Declare @TransactionID nvarchar(50),
		@AdvanceID nvarchar(50)
		
if @JobID <> '%'
	Begin
	
		Select @TransactionID = TransactionID From AT1704 Where JobID = @JobID
		Select @AdvanceID = AdvanceID From AT1704 Where JobID = @JobID
		
		IF @D_C ='C'
		Begin
			Delete AT9000
			Where TranMonth = @TranMonth and
				TranYear = @TranYear and
				DivisionID =@DivisionID and
				TransactionTypeID ='T28' and
				TableID ='AT1704' And 
				TransactionID = @TransactionID
		End
		
		Else
		Begin
			Delete AT9000
			Where TranMonth = @TranMonth and
				TranYear = @TranYear and
				DivisionID =@DivisionID and
				TransactionTypeID ='T38' and
				TableID ='AT1704' And
				TransactionID = @TransactionID
				
			--- Xóa tạm ứng được kết chuyển từ phân bổ
			Delete HT2500
			Where DivisionID =@DivisionID and
				TranMonth = @TranMonth and
				TranYear = @TranYear and
				AdvanceID = @AdvanceID and
				ISNULL(IsTranfer,0) = 1
		End
		--------- Cap nhat but toan phan bo ket chuyen
		Update AT1704 Set  Status =0
		Where TranMonth = @TranMonth and
			TranYear = @TranYear and
			DivisionID =@DivisionID and
			JobID = @JobID
	End
Else
	Begin
	
		IF @D_C ='C'
		Begin
			Delete AT9000
			Where TranMonth = @TranMonth and
				TranYear = @TranYear and
				DivisionID =@DivisionID and
				TransactionTypeID ='T28' and
				TableID ='AT1704'
		End
		Else
		Begin
			Delete AT9000
			Where TranMonth = @TranMonth and
				TranYear = @TranYear and
				DivisionID =@DivisionID and
				TransactionTypeID ='T38' and
				TableID ='AT1704' 
			
			--- Xóa tạm ứng được kết chuyển từ phân bổ
			Delete HT2500
			Where DivisionID =@DivisionID and
				TranMonth = @TranMonth and
				TranYear = @TranYear and
				AdvanceID in (Select AdvanceID From AT1704 Where DivisionID = @DivisionID and TranMonth = @TranMonth and TranYear = @TranYear and D_C = 'D') and
				ISNULL(IsTranfer,0) = 1		
		End
		--------- Cap nhat but toan phan bo ket chuyen
		Update AT1704 Set  Status =0
		Where TranMonth = @TranMonth and
			TranYear = @TranYear and
			DivisionID =@DivisionID
			
	End

