IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP7613]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AP7613]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

---- Created on 21/05/2015 by Bảo Anh
---- Cộng vào các chi tiêu, lưu vào bảng KQKD nhiều kỳ

CREATE PROCEDURE [dbo].[AP7613]
	@DivisionID AS nvarchar(50),
	@ReportCode AS nvarchar(50),
	@LineCode AS nvarchar(50),
	@MonthYear nvarchar(7),
	@Amount AS decimal(28,8),
	@AccuSign AS nvarchar(5),
	@OriginalAccumulator AS nvarchar(100)

AS
Set nocount on
DECLARE @CurrentAccumulator AS nvarchar(100),
		@CurrentAccuSign AS nvarchar(50),
		@strAccumulators AS nvarchar(4000),
		@TempLineCode as nvarchar(100),
		@TempParrentID as nvarchar(100),
		@TempSign as nvarchar(5),
		@OldSign  nvarchar(5),
		@Sign  nvarchar(5),
		@Bug as nvarchar(4000)

		Set  @OldSign = ltrim(rtrim(@AccuSign))

		IF @AccuSign  = '+'	---- lan dau tien phai cong vao dong chinh no
		Begin	
				If ISNULL((Select DisplayedMark From AT7614 Where DivisionID = @DivisionID and LineCode = @LineCode and MonthYear = @MonthYear),0) = 1	
					UPDATE 	AT7614
					SET		Amount = -(Isnull(Amount,0) + isnull(@Amount,0))
					WHERE	DivisionID = @DivisionID
							and LineCode = @LineCode
							and MonthYear = @MonthYear
				Else
					UPDATE 	AT7614
					SET		Amount = Isnull(Amount,0) + isnull(@Amount,0)							
					WHERE	DivisionID = @DivisionID
							and LineCode = @LineCode
							and MonthYear = @MonthYear
		End	
		ELSE
		Begin
				If ISNULL((Select DisplayedMark From AT7614 Where DivisionID = @DivisionID and LineCode = @LineCode and MonthYear = @MonthYear),0) = 1	
					UPDATE 	AT7614
					SET		Amount = -(Amount - @Amount)							
					WHERE	DivisionID = @DivisionID
							and LineCode = @LineCode
							and MonthYear = @MonthYear
				Else
					UPDATE 	AT7614
					SET		Amount = Amount - @Amount							
					WHERE	DivisionID = @DivisionID
							and LineCode = @LineCode
							and MonthYear = @MonthYear
		End
		----- Duyet den cap cha

		SELECT 	@CurrentAccumulator = Accumulator,
				@TempSign  = AccuSign			
		FROM		AT7614
		WHERE	DivisionID = @DivisionID and LineCode = @LineCode and MonthYear = @MonthYear
		
		Set @TempLineCode  =   isnull(@CurrentAccumulator,'')
  		
		Set @Bug = @Bug+@LineCode+'  +'
		
		WHILE @TempLineCode <>''
			Begin
				--- Update TypeID của dòng cấp cha để nhận biết là doanh thu hay chi phí
				UPDATE AT7614 Set TypeID = (Select TypeID From AT7614 Where DivisionID = @DivisionID and LineCode = @LineCode and MonthYear = @MonthYear)
				WHERE DivisionID = @DivisionID And LineCode = @TempLineCode and MonthYear = @MonthYear and Isnull(TypeID,'') = ''

				 --if @TempLineCode in ('60' )
					--Print ' @TempSign  '+ @TempSign +' '+str(isnull(@Amount2,0))
				--if @LineCode ='04' 
					--Print 'A:  '+@TempLineCode+' dau '+@TempSign
 
				if @OldSign<> @TempSign  Set @Sign = '-' Else   Set @Sign = '+'
				--Print @OldSign+ @TempSign
				Set @OldSign = @Sign
				
				Set @Bug =@Bug+@TempLineCode+' '+@Sign
				IF @Sign = '+'	---- lan dau tien phai cong vao dong chinh no
				Begin
					If ISNULL((Select DisplayedMark From AT7614 Where DivisionID = @DivisionID and LineCode = @LineCode and MonthYear = @MonthYear),0) = 1	
						UPDATE 	AT7614
						SET		Amount = -(isnull(Amount,0) + isnull(@Amount,0))
						WHERE	DivisionID = @DivisionID
							and LineCode = @TempLineCode
							and MonthYear = @MonthYear
					Else
						UPDATE 	AT7614
						SET	Amount = isnull(Amount,0) + isnull(@Amount,0)
						WHERE	DivisionID = @DivisionID
							and LineCode = @TempLineCode
							and MonthYear = @MonthYear
				End
				ELSE
				Begin
					If ISNULL((Select DisplayedMark From AT7614 Where DivisionID = @DivisionID and LineCode = @LineCode and MonthYear = @MonthYear),0) = 1	
							UPDATE 	AT7614
							SET		Amount = -(isnull(Amount,0) - isnull(@Amount,0))
							WHERE	DivisionID = @DivisionID
							and LineCode = @TempLineCode
							and MonthYear = @MonthYear
					Else
							UPDATE 	AT7614
							SET		Amount = isnull(Amount,0) - isnull(@Amount,0)
							WHERE	DivisionID = @DivisionID
							and LineCode = @TempLineCode
							and MonthYear = @MonthYear
				End
				Set @TempParrentID=''		
				
				Select  	@TempParrentID = Accumulator,
					@TempSign = ltrim(rtrim(AccuSign))
				From 	AT7614 
				Where DivisionID = @DivisionID
				and LineCode = @TempLineCode
				and MonthYear = @MonthYear
				
				Set 	@TempLineCode = isnull(@TempParrentID,'')
				
			End

Set nocount off
