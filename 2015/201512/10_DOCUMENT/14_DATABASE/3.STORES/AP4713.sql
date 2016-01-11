IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP4713]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP4713]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Created by Nguyen Van Nhan,  12/03/2004
---- Cong  luy ke vao cac dong 
---- Modified on 15/11/2011 by Le Thi Thu Hien : Bo phan Print

CREATE PROCEDURE [dbo].[AP4713]
	@ReportCode AS nvarchar(50),
	@LineID AS nvarchar(50),
	@Level01 AS nvarchar(20),
	@Level02 AS nvarchar(20),
	@ColumnA AS decimal(28,8),
	@ColumnB AS decimal(28,8),
	@ColumnC AS decimal(28,8),
	@ColumnD AS decimal(28,8),
	@ColumnE AS decimal(28,8),	
	@AccuSign AS nvarchar(20)
	
AS

Set nocount on
DECLARE 	@CurrentAccumulator AS nvarchar(20),
			@CurrentAccuSign AS nvarchar(20),
			@ParentID as  nvarchar(50),
			@OldSign as nvarchar(20)

---Print ' Hello'
	


UPDATE 	AT4725
		SET		ColumnA = ColumnA + isnull(@ColumnA,0),
				ColumnB = ColumnB + isnull(@ColumnB,0),
				ColumnC = ColumnC + isnull(@ColumnC,0)
		WHERE	LineID = @LineID AND
				Level01 = @Level01 AND
				Level02 = @Level02
		Set @OldSign = @AccuSign
	
	SELECT 	@CurrentAccumulator = Accumulator,
			@CurrentAccuSign = ltrim(rtrim(AccuSign))
	FROM		AT4725
		WHERE	LineID = @LineID AND
				Level01 = @Level01 AND
				Level02 = @Level02
	
		Set @ParentID = @LineID
		Set @LineID = @CurrentAccumulator
		Set @AccuSign = @CurrentAccuSign

		

	While ( isnull(@LineID,'')<>'') AND ( isnull(@AccuSign,'') <>'') 
	    BEGIN
		
		
		 If @AccuSign ='-' 
			Begin
				Set @ColumnA = isnull(@ColumnA,0)* (-1)
				Set @ColumnB = isnull(@ColumnB,0)* (-1)
				Set @ColumnC = isnull(@ColumnC,0)* (-1)
				Set @ColumnD = isnull(@ColumnD,0)* (-1)			
				Set @ColumnE = isnull(@ColumnE,0)* (-1)			
			End
		--Print ' Dau :  '+ @AccuSign+' Line: '+@LineID + ' Gia tri : '+str(@ColumnA)

		If @AccuSign in ('+','-')
		UPDATE AT4725
		SET		ColumnA = ColumnA + isnull(@ColumnA,0)  ,
				ColumnB = ColumnB + isnull(@ColumnB,0) ,
				ColumnC = ColumnC + isnull(@ColumnC,0) 
		WHERE	LineID = @LineID AND
				Level01 = @Level01 AND
				Level02 = @Level02		
	
		set @CurrentAccumulator = null
		set @CurrentAccuSign =''
		Set @OldSign = @AccuSign

		SELECT 	@CurrentAccumulator = Accumulator,
				@CurrentAccuSign = ltrim(rtrim(AccuSign))
		FROM		AT4725
		WHERE	LineID = @LineID AND
				Level01 = @Level01 AND
				Level02 = @Level02
		--Set @AccuSign =''
		---set @LineID = null

		Set @LineID = isnull(@CurrentAccumulator,'')
		Set @AccuSign = isnull(@CurrentAccuSign,'')

	 END



Set Nocount off

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

