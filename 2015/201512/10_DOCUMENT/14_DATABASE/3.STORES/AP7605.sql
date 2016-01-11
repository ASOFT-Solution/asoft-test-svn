
/****** Object:  StoredProcedure [dbo].[AP7605]    Script Date: 07/29/2010 11:12:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP7605]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AP7605]
GO

/****** Object:  StoredProcedure [dbo].[AP7605]    Script Date: 07/29/2010 11:12:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


-------- Created by Nguyen Van Nhan. Date 12.09.2003.
-------- Cap nhat so lieu len bao cao ket qua kinh doanh. Phan II

/**********************************************
** Edited by: [GS] [Cẩm Loan] [30/07/2010]
***********************************************/

CREATE PROCEDURE [dbo].[AP7605]
	@DivisionID AS nvarchar(50),
	@ReportCode AS nvarchar(50),
	@LineCode AS nvarchar(100),
	@Amount1 AS decimal(28,8),
	@Amount2 AS decimal(28,8),
	@Amount3 AS decimal(28,8),
	@Amount4 AS decimal(28,8),
	@Amount5 AS decimal(28,8),
	@Amount6 AS decimal(28,8),	
	@AccuSign AS nvarchar(5),
	@OriginalAccumulator AS nvarchar(100)
AS

DECLARE 	@CurrentAccumulator AS nvarchar(100),
		@CurrentAccuSign AS nvarchar(5),
		@TempLineCode as nvarchar(50),
		@TempParrentID as nvarchar(50),
		@TempSign as nvarchar(50)

	UPDATE 	AT7606
		SET		Amount1 = Amount1 + isnull(@Amount1,0),
				Amount2 = Amount2 + isnull(@Amount2,0),
				Amount3 = Amount3 + isnull(@Amount3,0),
				Amount4 = Amount4 + isnull(@Amount4,0),
				Amount5 = Amount5 + isnull(@Amount5,0),
				Amount6 = Amount6 + isnull(@Amount6,0)
		WHERE	LineCode = @LineCode
				and DivisionID = @DivisionID


			
	SELECT 	@LineCode =  isnull(Accumulator,''),
			@CurrentAccuSign = AccuSign
	FROM		AT7606
	WHERE	LineCode = @LineCode 
			and DivisionID = @DivisionID

	 	
	While   isnull(@CurrentAccuSign,'')<>'' and isnull(@LineCode,'') <>''
	Begin
		 IF @Amount1 IS NULL 
		    SET @Amount1 = 0
		IF @Amount2 IS NULL
		    SET @Amount2 = 0
		IF @Amount3 IS NULL
		    SET @Amount3 = 0
		IF @Amount4 IS NULL
		    SET @Amount4 = 0
		IF @Amount5 IS NULL
		    SET @Amount5 = 0
		IF @Amount6 IS NULL
		    SET @Amount6 = 0

		IF @CurrentAccuSign  = '-'
		    BEGIN
			SET @Amount1 = @Amount1*-1
			SET @Amount2 = @Amount2*-1
			SET @Amount3 = @Amount3*-1
			SET @Amount4 = @Amount4*-1
			SET @Amount5 = @Amount5*-1
			SET @Amount6 = @Amount6*-1
		    END

			UPDATE 	AT7606
			SET		Amount1 = Amount1 + isnull(@Amount1,0),
					Amount2 = Amount2 + isnull(@Amount2,0),
					Amount3 = Amount3 + isnull(@Amount3,0),
					Amount4 = Amount4 + isnull(@Amount4,0),
					Amount5 = Amount5 + isnull(@Amount5,0),
					Amount6 = Amount6 + isnull(@Amount6,0)
			WHERE	LineCode = @LineCode
					and DivisionID = @DivisionID
				
		SELECT 	@LineCode =  isnull(Accumulator,''),
				@CurrentAccuSign = AccuSign
		FROM		AT7606
		WHERE	LineCode = @LineCode 
				and DivisionID = @DivisionID
		End




GO

