

DECLARE	@return_value int

EXEC	@return_value = [dbo].[MP7212]
		@DivisionID = N'1',
		@PeriodID = N'1',
		@TranMonth = 1,
		@TranYear = 1,
		@MaterialTypeID = N'1',
		@CoefficientID = N'1',
		@EndApportionID = N'1',
		@BeginMethodID = 1,
		@FromPeriodID = N'1'

SELECT	'Return Value' = @return_value

GO
