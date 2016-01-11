

/****** Object:  StoredProcedure [dbo].[HP1903]    Script Date: 01/11/2012 08:53:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP1903]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP1903]
GO



/****** Object:  StoredProcedure [dbo].[HP1903]    Script Date: 01/11/2012 08:53:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [30/07/2010]
'**************************************************************/
CREATE PROCEDURE [dbo].[HP1903] @DivisionID nvarchar(50),
								@PriceSheetID nvarchar(50), 
								@ProducingProcessID nvarchar(50), 
								@StepID nvarchar(50), 
								@ProductID nvarchar(50), 
								@UnitID nvarchar(50), 
								@UnitPrice decimal(28,8), 
								@Notes nvarchar ( 250 ), 
								@UserID nvarchar(50), 
								@IsNull tinyint
AS
If @IsNull=0 

	If not Exists (
		Select * From HT1903 
		Where PriceSheetID = @PriceSheetID
		And ProducingProcessID = @ProducingProcessID
		And StepID = @StepID
		And ProductID = @ProductID and DivisionID = @DivisionID
		)
		Insert  Into HT1903(DivisionID,PriceSheetID, ProducingProcessID,  StepID, ProductID, UnitID, UnitPrice, Notes,CreateUserID,CreateDate)
		Values (@DivisionID,@PriceSheetID, @ProducingProcessID,  @StepID, @ProductID, @UnitID, @UnitPrice, @Notes,@UserID,getDate())
	Else
	
		Update HT1903
		Set UnitID = @UnitID,
		UnitPrice	= @UnitPrice,
		Notes = @Notes,
		LastModifyUserID = @UserID,
		LastModifyDate = getDate()
		Where PriceSheetID = @PriceSheetID
			And ProducingProcessID = @ProducingProcessID
			And StepID = @StepID
			And ProductID = @ProductID and DivisionID = @DivisionID
Else 
	If  Exists (
		Select * From HT1903 
		Where PriceSheetID = @PriceSheetID
		And ProducingProcessID = @ProducingProcessID
		And StepID = @StepID
		And ProductID = @ProductID and DivisionID = @DivisionID
		)

 			Delete HT1903
			Where PriceSheetID = @PriceSheetID
			And ProducingProcessID = @ProducingProcessID
			And StepID = @StepID
			And ProductID = @ProductID and DivisionID = @DivisionID





GO


