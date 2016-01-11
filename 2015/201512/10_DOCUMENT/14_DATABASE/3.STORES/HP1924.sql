

/****** Object:  StoredProcedure [dbo].[HP1924]    Script Date: 12/10/2011 14:51:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP1924]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP1924]
GO


/****** Object:  StoredProcedure [dbo].[HP1924]    Script Date: 12/10/2011 14:51:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [30/07/2010]
'********************************************/

CREATE PROCEDURE [dbo].[HP1924] 
			@TranMonth int, 
			@TranYear int, 
			@DivisionID nvarchar (50), 
			@EmployeeID nvarchar (50), 
			@ProduceDate datetime, 
			@ProductID nvarchar (50), 
			@PriceSheetID nvarchar (50), 
			@ProducingProcessID nvarchar (50), 
			@StepID nvarchar (50), 
			@UnitID nvarchar (50), 
			@Quantity decimal(28,8), 
			@Notes nvarchar (250), 
			@IsNull tinyint
AS

Declare @DepartmentID nvarchar(50),
		@TeamID nvarchar(50)

	Select @DepartmentID = DepartmentID, @TeamID = TeamID From HT2400 
	Where EmployeeID = @EmployeeID And DivisionID = @DivisionID And TranMonth = @TranMonth And TranYear = @TranYear

If @IsNull=0 

	If not Exists (
		Select * From HT1904
		Where TranMonth = @TranMonth
		And TranYear = @TranYear
		And DivisionID = @DivisionID
		And EmployeeID = @EmployeeID
		And CONVERT(VARCHAR(10),ProduceDate,105) = CONVERT(VARCHAR(10),@ProduceDate,105)
		--And ProduceDate = @ProduceDate
		And PriceSheetID = @PriceSheetID
		And ProducingProcessID = @ProducingProcessID
		And StepID = @StepID
		And ProductID = @ProductID
		)
		Insert  Into HT1904(TranMonth,TranYear,DivisionID,DepartmentID,TeamID, EmployeeID,ProduceDate,PriceSheetID, ProducingProcessID,  StepID, ProductID, UnitID, Quantity, Notes)
		Values (@TranMonth,@TranYear,@DivisionID,@DepartmentID,@TeamID,@EmployeeID,@ProduceDate,@PriceSheetID, @ProducingProcessID,  @StepID, @ProductID, @UnitID, @Quantity, @Notes)
	Else
	
		Update HT1904
		Set UnitID = @UnitID,
		Quantity	= @Quantity,
		Notes = @Notes
		Where TranMonth = @TranMonth
		And TranYear = @TranYear
		And DivisionID = @DivisionID
		And EmployeeID = @EmployeeID
		And CONVERT(VARCHAR(10),ProduceDate,105) = CONVERT(VARCHAR(10),@ProduceDate,105)
		--And ProduceDate = @ProduceDate
		And PriceSheetID = @PriceSheetID
		And ProducingProcessID = @ProducingProcessID
		And StepID = @StepID
		And ProductID = @ProductID
Else 
	If  Exists (
		Select * From HT1904
		Where TranMonth = @TranMonth
		And TranYear = @TranYear
		And DivisionID = @DivisionID
		And EmployeeID = @EmployeeID
		And CONVERT(VARCHAR(10),ProduceDate,105) = CONVERT(VARCHAR(10),@ProduceDate,105)
		--And ProduceDate = @ProduceDate
		And PriceSheetID = @PriceSheetID
		And ProducingProcessID = @ProducingProcessID
		And StepID = @StepID
		And ProductID = @ProductID
		)

 			Delete HT1904
			Where TranMonth = @TranMonth
			And TranYear = @TranYear
			And DivisionID = @DivisionID
			And EmployeeID = @EmployeeID
			And CONVERT(VARCHAR(10),ProduceDate,105) = CONVERT(VARCHAR(10),@ProduceDate,105)
			--And ProduceDate = @ProduceDate
			And PriceSheetID = @PriceSheetID
			And ProducingProcessID = @ProducingProcessID
			And StepID = @StepID
			And ProductID = @ProductID
GO


