/****** Object:  StoredProcedure [dbo].[AP7607]    Script Date: 07/29/2010 11:21:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP7607]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AP7607]
GO

/****** Object:  StoredProcedure [dbo].[AP7607]    Script Date: 07/29/2010 11:21:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


------ Created by Nguyen Van Nhan, Date 13.09.2003
------ Cap nhat so lieu Phan III - Bao cao ket qua kinh doanh

/**********************************************
** Edited by: [GS] [Cẩm Loan] [30/07/2010]
***********************************************/

CREATE PROCEDURE [dbo].[AP7607]
	@DivisionID AS nvarchar(50),
	@ReportCode AS nvarchar(50),
	@LineCode AS nvarchar(50),
	@Amount1 AS decimal(28,8),
	@Amount2 AS decimal(28,8),
	@AccuSign AS nvarchar(5),
	@OriginalAccumulator AS nvarchar(100)
AS

DECLARE 	@CurrentAccumulator AS nvarchar(100),
		@CurrentAccuSign AS nvarchar(5),
		@TempSign as nvarchar(5),
		@TempLineCode as nvarchar(50),
		@TempParrentID as nvarchar(50)

	
	IF @AccuSign = '+'
		UPDATE 	AT7608
		SET		Amount1 = Amount1 + @Amount1,
				Amount2 = Amount2 + @Amount2
		WHERE	LineCode = @LineCode
				and DivisionID = @DivisionID
	ELSE
		UPDATE 	AT7608
		SET		Amount1 = Amount1 - @Amount1,
				Amount2 = Amount2 - @Amount2
		WHERE	LineCode = @LineCode
				and DivisionID = @DivisionID
	
	
	 SELECT 	@CurrentAccumulator = Accumulator,
			@CurrentAccuSign = AccuSign
	FROM		AT7608
	WHERE	LineCode = @LineCode
			and DivisionID = @DivisionID
	
	Set @TempSign =	isnull(@CurrentAccuSign,'')
	Set @TempLineCode  =   isnull(@CurrentAccumulator,'')


		WHILE @TempSign<>'' and @TempLineCode<>''
			Begin
				 
				IF @TempSign = '+'	---- lan dau tien phai cong vao dong chinh no
					UPDATE 	AT7608
				SET		Amount1 = Amount1 + @Amount1,
						Amount2 = Amount2 + @Amount2						
				WHERE	LineCode = @TempLineCode
						and DivisionID = @DivisionID
			ELSE
				UPDATE 	AT7608
				SET		Amount1 = Amount1 - @Amount1,
						Amount2 = Amount2 - @Amount2				
				WHERE	LineCode = @TempLineCode
						and DivisionID = @DivisionID
				
				Set @TempParrentID=''
				Set @TempSign =''
				Select  @TempParrentID = Accumulator, @TempSign = AccuSign
				From 	AT7608 
				Where LineCode = @TempLineCode
						and DivisionID = @DivisionID
				
				Set 	@TempLineCode = isnull(@TempParrentID,'')
				Set 	@TempSign =isnull(@TempSign,'')			
			End
GO

