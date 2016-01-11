/****** Object:  StoredProcedure [dbo].[AP4911]    Script Date: 12/16/2010 17:54:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
------- Created by Dang Le Bao Quynh, Date 25/05/2007
------ Purpose: Insert them dong Level

/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [30/07/2010]
'********************************************/

/***********************************
'* Edited by: [Cẩm Loan] thêm DivisionID khi insert AT4925 [06/12/2010]
'***********************************/

ALTER PROCEDURE [dbo].[AP4911] 
			@DivisionID nvarchar(50),
			@ReportCode nvarchar(50),
			@Level01Type as nvarchar(20),
			@Level01ID as nvarchar(50),
			@Level02Type as nvarchar(20),
			@Level02ID as nvarchar(50)

AS

DECLARE 	@CursorAT6201		AS CURSOR,
			@LineID as nvarchar(50),
			@LineCode AS nvarchar(50),
			@LineDesc AS nvarchar(250),
			@Level01IDDesc AS nvarchar(250),
			@Level02IDDesc AS nvarchar(250),
			@AccuSign AS nvarchar(5),
			@Accumulator AS nvarchar(20),
			@PrintStatus AS tinyint,
			@LevelPrint as tinyint


	SELECT 	@Level01IDDesc = SelectionName
	FROM		AV6666
	WHERE	SelectionType = @Level01Type AND
			SelectionID = @Level01ID AND
			DivisionID = @DivisionID

	SELECT 	@Level02IDDesc = SelectionName
	FROM		AV6666
	WHERE	SelectionType = @Level02Type AND
			SelectionID = @Level02ID AND
			DivisionID = @DivisionID


	SET @CursorAT6201 = CURSOR SCROLL KEYSET FOR
		SELECT	LineID, LineCode,	LineDescription,	Sign,	Accumulator,	PrintStatus , LevelID
		FROM 		AT6201
		WHERE	ReportCode = @ReportCode  AND DivisionID = @DivisionID


	OPEN @CursorAT6201

	FETCH NEXT FROM @CursorAT6201 INTO
				@LineID, @LineCode,	@LineDesc,	@AccuSign,	@Accumulator,	@PrintStatus, @LevelPrint

	WHILE @@FETCH_STATUS = 0
	  BEGIN
		INSERT INTO AT4925 (DivisionID, LineID,
			Level01, 	Level01Desc,		Level02, 	Level02Desc,
			LineCode, 	LineDesc, 
			AccuSign, 	Accumulator, 	PrintStatus,
			ColumnA, 	ColumnB, 	ColumnC, 	ColumnD, 	ColumnE ,  ColumnF, ColumnG, ColumnH, LevelPrint)
		VALUES (@DivisionID, @LineID, 
			@Level01ID, 	@Level01IDDesc,	@Level02ID,	@Level02IDDesc,
			@LineCode,	@LineDesc,	
			@AccuSign,	@Accumulator,	@PrintStatus,
			0,		0,		0,		0,		0,  0, 0, 0, @LevelPrint)	
			
		FETCH NEXT FROM @CursorAT6201 INTO
				@LineID, @LineCode,	@LineDesc,	@AccuSign,	@Accumulator,	@PrintStatus, @LevelPrint

	  END

	CLOSE @CursorAT6201
	DEALLOCATE @CursorAT6201
GO
