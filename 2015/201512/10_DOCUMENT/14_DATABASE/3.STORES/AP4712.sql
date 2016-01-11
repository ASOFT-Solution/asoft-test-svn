/****** Object:  StoredProcedure [dbo].[AP4712]    Script Date: 12/16/2010 17:54:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
--- Created by Nguyen Van Nhan, 14/03/2004
--- Purpose: Kiem tra vong lap

/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP4712]
	@LineCode AS nvarchar(50),
	@OriginalAccumulator AS nvarchar(20),
	@Result AS tinyint OUTPUT

AS

DECLARE @CurrentAccumulator AS nvarchar(20)

Set @Result =0

SELECT 	@CurrentAccumulator = Accumulator
FROM		AT6101
WHERE	LineCode = @LineCode

SET	@Result = 0

IF @CurrentAccumulator IS NULL OR @CurrentAccumulator = ''
	SET	@Result = 0	
ELSE
    BEGIN
	DECLARE 	@Cursor AS CURSOR,
			@LineCode1 AS nvarchar(50),
			@Result1 AS tinyint

		SET @Cursor = CURSOR SCROLL KEYSET FOR
			SELECT	LineCode
			FROM 		AT6101
			WHERE	Accumulator = @LineCode
		OPEN @Cursor
		FETCH NEXT FROM @Cursor INTO
			@LineCode1

		WHILE @@FETCH_STATUS = 0
  		    BEGIN
			IF @LineCode1 = @OriginalAccumulator
				SET @Result = 1
			ELSE
				EXEC AP6101 @LineCode1, @OriginalAccumulator, @Result = @Result1 OUTPUT
			
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
