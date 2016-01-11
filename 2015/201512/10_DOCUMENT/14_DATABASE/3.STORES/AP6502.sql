/****** Object:  StoredProcedure [dbo].[AP6502]    Script Date: 12/16/2010 17:54:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
------ 	Created by Nguyen Van Nhan, Date 21/11/2003.
----- 	Purpose: Kiem tra vong lap
/********************************************
'* Edited by: [GS] [Thanh Nguyen] [01/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP6502]
	@LineCode AS nvarchar(50),
	@OriginalAccumulator AS nvarchar(50),
	@Result AS TINYINT OUTPUT

AS

DECLARE @CurrentAccumulator AS nvarchar(50)

SELECT 	@CurrentAccumulator = Accumulator
FROM		AT6503
WHERE	LineCode = @LineCode

SET	@Result = 0

IF @CurrentAccumulator IS NULL OR @CurrentAccumulator = ''
	SET	@Result = 0	
ELSE
    BEGIN
	DECLARE 	@Cursor AS CURSOR,
			@LineCode1 AS nvarchar(50),
			@Result1 AS TINYINT

		SET @Cursor = CURSOR SCROLL KEYSET FOR
			SELECT	LineCode
			FROM 		AT6503
			WHERE	Accumulator = @LineCode
		OPEN @Cursor
		FETCH NEXT FROM @Cursor INTO
			@LineCode1

		WHILE @@FETCH_STATUS = 0
  		    BEGIN
			IF @LineCode1 = @OriginalAccumulator
				SET @Result = 1
			ELSE
				EXEC AP6502 @LineCode1, @OriginalAccumulator, @Result = @Result1 OUTPUT
			
			SET @Result = @Result + @Result1
			FETCH NEXT FROM @Cursor INTO
				@LineCode1
		    END
		CLOSE @Cursor
		DEALLOCATE @Cursor
    END

IF @Result IS NULL 
	SET @Result = 0

RETURN @Result
GO
