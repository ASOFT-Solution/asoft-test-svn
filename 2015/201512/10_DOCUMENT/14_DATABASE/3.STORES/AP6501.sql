/****** Object:  StoredProcedure [dbo].[AP6501]    Script Date: 12/16/2010 17:54:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
------ Created by Nguyen Van Nhan, Date 21/11/2003
----- Purpose : Update du lieu vao bang tam AT6503
----- Edit by hoàng Vũ on 2015-04-15: Bổ sung lấy giá trị hiện thi báo cáo dấu âm, nhưng không ảnh hưởng kết quả tính toán cũ
/********************************************
'* Edited by: [GS] [Thanh Nguyen] [01/08/2010]
'********************************************/

alter PROCEDURE [dbo].[AP6501]
			@DivisionID AS nvarchar(50),
			@ReportCode AS nvarchar(50),
			@LineCode AS nvarchar(50),
			@Amount1 AS decimal(28, 8),
			@Amount2 AS decimal(28, 8),
			@AccuSign AS nvarchar(50),
			@OriginalAccumulator AS nvarchar(50)
AS

DECLARE 	@CurrentAccumulator AS nvarchar(50),
		@CurrentAccuSign AS nvarchar(50)

	
	--Xử lý trường hợp thiết lập báo cáo hiển thị dấu lên báo cáo
	IF @AccuSign = '+'
	Begin	
		If (Select DisplayedMark From AT6503 Where LineCode = @LineCode  and DivisionID = @DivisionID) = 1
				UPDATE 	AT6503
				SET		Amount1 = -(Amount1 + @Amount1),
						Amount2 = -(Amount2 + @Amount2)
				WHERE	LineCode = @LineCode  and DivisionID = @DivisionID
		Else
				UPDATE 	AT6503
				SET		Amount1 = Amount1 + @Amount1,
						Amount2 = Amount2 + @Amount2
				WHERE	LineCode = @LineCode  and DivisionID = @DivisionID
	End
	ELSE
	Begin
		If (Select DisplayedMark From AT6503 Where LineCode = @LineCode  and DivisionID = @DivisionID) = 1
				UPDATE 	AT6503
				SET		Amount1 = -(Amount1 - @Amount1),
						Amount2 = -(Amount2 - @Amount2)
				WHERE	LineCode = @LineCode and DivisionID = @DivisionID
		Else
				UPDATE 	AT6503
				SET		Amount1 = Amount1 - @Amount1,
						Amount2 = Amount2 - @Amount2
				WHERE	LineCode = @LineCode and DivisionID = @DivisionID
	End

	
	SELECT 	@CurrentAccumulator = Accumulator,
			@CurrentAccuSign = AccuSign
	FROM		AT6503
	WHERE	LineCode = @LineCode and DivisionID = @DivisionID

	IF (@CurrentAccumulator IS NOT NULL) AND (@CurrentAccumulator <>'') AND (@CurrentAccumulator <>@OriginalAccumulator)
		AND (@LineCode <> @CurrentAccumulator)
	    BEGIN
		IF @Amount1 IS NULL 
		    SET @Amount1 = 0
		IF @Amount2 IS NULL
		    SET @Amount2 = 0

		IF @AccuSign = '-'
		    BEGIN
			SET @Amount1 = @Amount1*-1
			SET @Amount2 = @Amount2*-1
		    END


		DECLARE 	@CrossReference AS TINYINT
		SET 		@CrossReference = 0
		EXEC 		AP6502 @LineCode, @CurrentAccumulator, @Result = @CrossReference OUTPUT		
		IF @CrossReference = 0	
			EXEC AP6501  @DivisionID,@ReportCode, @CurrentAccumulator, @Amount1, @Amount2, @CurrentAccuSign, @OriginalAccumulator

	    END
GO
