
/****** Object:  StoredProcedure [dbo].[AP7602]    Script Date: 07/29/2010 10:44:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP7602]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AP7602]
GO

/****** Object:  StoredProcedure [dbo].[AP7602]    Script Date: 07/29/2010 10:44:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


------ Cong vao cac chi tieu; truong hop In bang ket qua kinh doanh phÇn Lçi, L·i
----- Created by Nguyen Van Nhan, Date 12.09.2003

/**********************************************
** Edited by: [GS] [Cẩm Loan] [30/07/2010]
** Edited by: [GS] [Hoàng vũ] [2015-04-15]
***********************************************/

CREATE PROCEDURE [dbo].[AP7602]
	@DivisionID AS nvarchar(50),
	@ReportCode AS nvarchar(50),
	@LineCode AS nvarchar(50),
	@Amount1 AS decimal(28,8),
	@Amount2 AS decimal(28,8),
	@Amount3 AS decimal(28,8),
	@AccuSign AS nvarchar(5),
	@OriginalAccumulator AS nvarchar(100)
AS
Set nocount on
DECLARE 	@CurrentAccumulator AS nvarchar(100),
		@CurrentAccuSign AS nvarchar(50),
		@strAccumulators AS nvarchar(4000),
		@TempLineCode as nvarchar(100),
		@TempParrentID as nvarchar(100),
		@TempSign as nvarchar(5),
		@OldSign  nvarchar(5),
		@Sign  nvarchar(5),
		@Bug as nvarchar(4000)	

		--Set @Bug =''

		Set  @OldSign = ltrim(rtrim(@AccuSign))

		IF @AccuSign  = '+'	---- lan dau tien phai cong vao dong chinh no
		Begin	
				If (Select DisplayedMark From AT7604 Where LineCode = @LineCode  and DivisionID = @DivisionID) = 1	
					UPDATE 	AT7604
					SET		Amount1 = -(Isnull(Amount1,0) + isnull(@Amount1,0)),
							Amount2 =  -(Isnull(Amount2,0) + isnull(@Amount2,0)),
							Amount3 = -(Isnull(Amount3,0) + isnull(@Amount3,0))
					WHERE	LineCode = @LineCode
							and DivisionID = @DivisionID
				Else
					UPDATE 	AT7604
					SET		Amount1 = Isnull(Amount1,0) + isnull(@Amount1,0),
							Amount2 =  Isnull(Amount2,0) + isnull(@Amount2,0),
							Amount3 = Isnull(Amount3,0) + isnull(@Amount3,0)
					WHERE	LineCode = @LineCode
							and DivisionID = @DivisionID
		End	
		ELSE
		Begin
				If (Select DisplayedMark From AT7604 Where LineCode = @LineCode  and DivisionID = @DivisionID) = 1	
					UPDATE 	AT7604
					SET		Amount1 = -(Amount1 - @Amount1),
							Amount2 = -(Amount2 - @Amount2),
							Amount3 = -(Amount3 - @Amount3)
					WHERE	LineCode = @LineCode
							and DivisionID = @DivisionID
				Else
					UPDATE 	AT7604
					SET		Amount1 = Amount1 - @Amount1,
							Amount2 = Amount2 - @Amount2,
							Amount3 = Amount3 - @Amount3
					WHERE	LineCode = @LineCode
							and DivisionID = @DivisionID
		End
		----- Duyet den cap cha

		SELECT 	@CurrentAccumulator = Accumulator,
				@TempSign  = AccuSign			
		FROM		AT7604
		WHERE	LineCode = @LineCode
				and DivisionID = @DivisionID
		
		Set @TempLineCode  =   isnull(@CurrentAccumulator,'')	

  		
		Set @Bug = @Bug+@LineCode+'  +'

		WHILE @TempLineCode <>''
			Begin
				
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
					If (Select DisplayedMark From AT7604 Where LineCode = @LineCode  and DivisionID = @DivisionID) = 1	
						UPDATE 	AT7604
							SET		
								Amount1 = -(isnull(Amount1,0) + isnull(@Amount1,0)),
								Amount2 = -(isnull(Amount2,0) + isnull(@Amount2,0)),
								Amount3 = -(isnull(Amount3,0) + isnull(@Amount3,0))
						WHERE	LineCode = @TempLineCode
								and DivisionID = @DivisionID
					Else
							UPDATE 	AT7604
							SET		Amount1 = isnull(Amount1,0) + isnull(@Amount1,0),
								Amount2 = isnull(Amount2,0) + isnull(@Amount2,0),
								Amount3 = isnull(Amount3,0) + isnull(@Amount3,0)
						WHERE	LineCode = @TempLineCode
								and DivisionID = @DivisionID
				End
				ELSE
				Begin
					If (Select DisplayedMark From AT7604 Where LineCode = @LineCode  and DivisionID = @DivisionID) = 1	
							UPDATE 	AT7604
							SET		Amount1 = -(isnull(Amount1,0) - isnull(@Amount1,0)),
									Amount2 = -(isnull(Amount2,0) - isnull(@Amount2,0)),
									Amount3 = -(isnull(Amount3,0) - isnull(@Amount3,0))
							WHERE	LineCode = @TempLineCode
									and DivisionID = @DivisionID
					Else
									UPDATE 	AT7604
							SET		Amount1 = isnull(Amount1,0) - isnull(@Amount1,0),
									Amount2 = isnull(Amount2,0) - isnull(@Amount2,0),
									Amount3 = isnull(Amount3,0) - isnull(@Amount3,0)
							WHERE	LineCode = @TempLineCode
									and DivisionID = @DivisionID
				End
				Set @TempParrentID=''		
				
				Select  	@TempParrentID = Accumulator,
					@TempSign = ltrim(rtrim(AccuSign))
				From 	AT7604 
				Where LineCode = @TempLineCode	
					  and DivisionID = @DivisionID				
					  
				Set 	@TempLineCode = isnull(@TempParrentID,'')
				
			End
--if @LineCode ='04' 
--Print @Bug


Set nocount off
GO

