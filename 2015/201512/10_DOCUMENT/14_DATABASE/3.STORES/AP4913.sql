IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP4913]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP4913]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Created by Dang Le Bao Quynh,  25/05/2007
---- Cong  luy ke vao cac dong 
---- Modified on 15/11/2011 by Le Thi Thu Hien : Bo phan Print

CREATE PROCEDURE [dbo].[AP4913]
	@DivisionID NVARCHAR(50), 
	@ReportCode AS nvarchar(50),
	@LineID AS nvarchar(50),
	@Level01 AS nvarchar(20),
	@Level02 AS nvarchar(20),
	@ColumnA AS decimal(28,8),
	@ColumnB AS decimal(28,8),
	@ColumnC AS decimal(28,8),
	@ColumnD AS decimal(28,8),
	@ColumnE AS decimal(28,8),
	@ColumnF AS decimal(28,8),
	@ColumnG AS decimal(28,8),
	@ColumnH AS decimal(28,8),	
	@AccuSign AS nvarchar(5)
	
AS

SET NOCOUNT ON
DECLARE 	@CurrentAccumulator AS nvarchar(20),
			@CurrentAccuSign AS nvarchar(5),
			@ParentID as  nvarchar(50),
			@OldSign as nvarchar(5)

---Print ' Hello'
	


UPDATE 	AT4925
SET		ColumnA = ColumnA + ISNULL(@ColumnA,0),
		ColumnB = ColumnB + ISNULL(@ColumnB,0),
		ColumnC = ColumnC + ISNULL(@ColumnC,0),
		ColumnD = ColumnD + ISNULL(@ColumnD,0),
		ColumnE = ColumnE + ISNULL(@ColumnE,0),
		ColumnF = ColumnF + ISNULL(@ColumnF,0),
		ColumnG = ColumnG + ISNULL(@ColumnG,0),
		ColumnH = ColumnH + ISNULL(@ColumnH,0)
WHERE	LineID = @LineID AND
		Level01 = @Level01 AND
		Level02 = @Level02
		and DivisionID = @DivisionID
		
SET @OldSign = @AccuSign
	
SELECT 	@CurrentAccumulator = Accumulator,
		@CurrentAccuSign = ltrim(rtrim(AccuSign))
FROM	AT4925
WHERE	LineID = @LineID AND
		Level01 = @Level01 AND
		Level02 = @Level02
		and DivisionID = @DivisionID
	
Set @ParentID = @LineID
Set @LineID = @CurrentAccumulator
Set @AccuSign = @CurrentAccuSign

		

	While ( ISNULL(@LineID,'')<>'') AND ( ISNULL(@AccuSign,'') <>'') 
	    BEGIN
		
		
		 If @AccuSign ='-' 
			Begin
				Set @ColumnA = ISNULL(@ColumnA,0)* (-1)
				Set @ColumnB = ISNULL(@ColumnB,0)* (-1)
				Set @ColumnC = ISNULL(@ColumnC,0)* (-1)
				Set @ColumnD = ISNULL(@ColumnD,0)* (-1)			
				Set @ColumnE = ISNULL(@ColumnE,0)* (-1)
				Set @ColumnF = ISNULL(@ColumnF,0)* (-1)
				Set @ColumnG = ISNULL(@ColumnG,0)* (-1)
				Set @ColumnH = ISNULL(@ColumnH,0)* (-1)			
			End
		--Print ' Dau :  '+ @AccuSign+' Line: '+@LineID + ' Gia tri : '+str(@ColumnA)

		If @AccuSign in ('+','-')
		UPDATE AT4925
		SET		ColumnA = ColumnA + ISNULL(@ColumnA,0)  ,
				ColumnB = ColumnB + ISNULL(@ColumnB,0) ,
				ColumnC = ColumnC + ISNULL(@ColumnC,0),
				ColumnD = ColumnD + ISNULL(@ColumnD,0),
				ColumnE = ColumnE + ISNULL(@ColumnE,0),
				ColumnF = ColumnF + ISNULL(@ColumnF,0),
				ColumnG = ColumnG + ISNULL(@ColumnG,0),
				ColumnH = ColumnH + ISNULL(@ColumnH,0) 
		WHERE	LineID = @LineID AND
				Level01 = @Level01 AND
				Level02 = @Level02		
				and DivisionID = @DivisionID
	
		set @CurrentAccumulator = null
		set @CurrentAccuSign =''
		Set @OldSign = @AccuSign

		SELECT 	@CurrentAccumulator = Accumulator,
				@CurrentAccuSign = ltrim(rtrim(AccuSign))
		FROM		AT4925
		WHERE	LineID = @LineID AND
				Level01 = @Level01 AND
				Level02 = @Level02
				and DivisionID = @DivisionID
		--Set @AccuSign =''
		---set @LineID = null

		Set @LineID = ISNULL(@CurrentAccumulator,'')
		Set @AccuSign = ISNULL(@CurrentAccuSign,'')

	 END



SET NOCOUNT OFF

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

