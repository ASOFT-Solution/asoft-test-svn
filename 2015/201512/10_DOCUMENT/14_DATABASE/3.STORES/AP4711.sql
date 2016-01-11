IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP4711]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP4711]
GO
/****** Object:  StoredProcedure [dbo].[AP4711]    Script Date: 12/16/2010 17:54:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
------- Created by Nguyen Van Nhan, Date 14/03/2004
------ Purpose: Insert them dong Level

/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [29/07/2010]
'********************************************/

CREATE PROCEDURE [dbo].[AP4711] 
			@DivisionID nvarchar(50),
			@ReportCode nvarchar(50),
			@Level01Type as nvarchar(20),
			@Level01ID as nvarchar(50),
			@Level02Type as nvarchar(20),
			@Level02ID as nvarchar(50)

AS

DECLARE 	@CursorAT6101		AS CURSOR,
			@LineID as nvarchar(50),
			@LineCode AS nVarchar(50),
			@LineDesc AS nVarchar(250),
			@Level01IDDesc AS nvarchar(250),
			@Level02IDDesc AS nvarchar(250),
			@AccuSign AS nVarchar(5),
			@Accumulator AS nVarchar(20),
			@PrintStatus AS tinyint,
			@LevelPrint as tinyint

Declare @Amount01 as decimal(28,8),
		@Amount02 as decimal(28,8),
		@Amount03 as decimal(28,8),
		@Amount04 as decimal(28,8),
		@Amount05 as decimal(28,8),
		@Note01 as nvarchar(250),
		@Note02 as nvarchar(250),
		@Note03 as nvarchar(250),
		@Note04 as nvarchar(250),
		@Note05 as nvarchar(250)



	SELECT top 1	@Level01IDDesc = SelectionName
	FROM		AV6666
	WHERE	SelectionType = @Level01Type AND
			SelectionID = @Level01ID AND DivisionID = @DivisionID 

IF left(@Level02Type,2)<>'A0'
	SELECT 	top 1 @Level02IDDesc = SelectionName
	FROM		AV6666
	WHERE	SelectionType = @Level02Type AND
			SelectionID = @Level02ID AND DivisionID = @DivisionID 
Else
	SELECT 	top 1 @Level02IDDesc = AnaName,
			@Amount01=Amount01, @Amount02=Amount02,@Amount03=Amount03,@Amount04=Amount04,@Amount05=Amount05,
			@Note01 =Note01,@Note02 =Note02,@Note03 =Note03,@Note04 =Note04,@Note05 =Note05

	FROM		AT1011
	WHERE	AnaTypeID = @Level02Type AND
			AnaID = @Level02ID AND DivisionID = @DivisionID 


	SET @CursorAT6101 = CURSOR SCROLL KEYSET FOR
		SELECT	LineID, LineCode,	LineDescription,	Sign,	Accumulator,	PrintStatus , LevelID
		FROM 		AT6101
		WHERE	ReportCode = @ReportCode AND DivisionID = @DivisionID


	OPEN @CursorAT6101

	FETCH NEXT FROM @CursorAT6101 INTO
				@LineID, @LineCode,	@LineDesc,	@AccuSign,	@Accumulator,	@PrintStatus, @LevelPrint

	WHILE @@FETCH_STATUS = 0
	  BEGIN
		INSERT INTO AT4725 (DivisionID, LineID,
			Level01, 	Level01Desc,		Level02, 	Level02Desc,
			LineCode, 	LineDesc, 
			AccuSign, 	Accumulator, 	PrintStatus,
			ColumnA, 	ColumnB, 	ColumnC, 	ColumnD, 	ColumnE , LevelPrint,
			Amount01,Amount02,Amount03,Amount04,Amount05,
			Note01, Note02,Note03,Note04,Note05)
		VALUES (@DivisionID, @LineID, 
			@Level01ID, 	@Level01IDDesc,	@Level02ID,	@Level02IDDesc,
			@LineCode,	@LineDesc,	
			@AccuSign,	@Accumulator,	@PrintStatus,
			0,		0,		0,		0,		0, @LevelPrint,
			@Amount01,@Amount02,@Amount03,@Amount04,@Amount05,
			@Note01, @Note02,@Note03,@Note04,@Note05)	
			
		FETCH NEXT FROM @CursorAT6101 INTO
				@LineID, @LineCode,	@LineDesc,	@AccuSign,	@Accumulator,	@PrintStatus, @LevelPrint

	  END

	CLOSE @CursorAT6101
	DEALLOCATE @CursorAT6101
GO
