IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[CSP9999]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[CSP9999]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Khóa sổ kỳ kế toán
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 12/04/2012 by Lê Thị Thu Hiền
---- Modify on 08/06/2015 by Bảo Anh: Lấy PeriodNum từ thông tin đơn vị AT1101
-- <Example>
---- 
CREATE PROCEDURE CSP9999
( 
		@DivisionID AS nvarchar(50), 
		@TranMonth AS int, 
		@TranYear AS int,
		@BeginDate AS datetime,
		@EndDate AS datetime
) 
AS 

DECLARE @Closing	Bit,
		@NextMonth 	TinyInt,
		@NextYear 	Smallint,
		@PeriodNum 	TinyInt,
		@MaxPeriod	Int 
	
	
	SELECT 	@PeriodNum = PeriodNum
	FROM	AT1101 ---AT0001
	
	IF @PeriodNum IS NULL 
		SET @PeriodNum = 12

	SET @NextMonth = @TranMonth % @PeriodNum + 1
	SET @NextYear = @TranYear + @TranMonth/@PeriodNum

	SELECT  @Closing = Closing
	FROM 	CST9999
	WHERE 	DivisionID = @DivisionID 
			AND TranMonth = @TranMonth 
			AND TranYear = @TranYear
		
	SELECT 	@MaxPeriod = MAX(TranMonth + TranYear * 100)
 	FROM	CST9999
	WHERE	DivisionID = @DivisionID

	IF  @Closing <> 1 
	BEGIN		
		UPDATE 	CST9999
		SET 	Closing = 1
		FROM 	CST9999
		WHERE 	DivisionID = @DivisionID 
				AND TranMonth = @TranMonth 
				AND TranYear = @TranYear

		IF	@MaxPeriod < (@NextMonth + @NextYear * 100)
		BEGIN
			INSERT CST9999(TranMonth,TranYear, DivisionID,Closing, BeginDate, EndDate) 
			VALUES(@NextMonth,@NextYear, @DivisionID,0,@BeginDate, @EndDate)


		END
		
		IF	@MaxPeriod >= (@NextMonth + @NextYear * 100)
		BEGIN	
			UPDATE 	CST9999
			SET 	BeginDate = @BeginDate,
					EndDate = @EndDate
			FROM 	CST9999
			WHERE 	DivisionID = @DivisionID 
					AND TranMonth = @NextMonth 
					AND TranYear = @NextYear
		END

	
	END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON