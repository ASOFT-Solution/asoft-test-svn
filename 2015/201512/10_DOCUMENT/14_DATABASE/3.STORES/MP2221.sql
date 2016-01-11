/****** Object:  StoredProcedure [dbo].[MP2221]    Script Date: 08/02/2010 09:58:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

----- ALTER  by: Dang Le Bao Quynh; Date 27/10/2009
----- Purpose: Kiem tra tinh hop ly khoi luong ke thua don hang sx lam ket qua sx

/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP2221] @OTransactionID nvarchar(50), 
				@Quantity decimal(28,8) = 0
AS

Declare 
	@Status as tinyint,
	@QuantityDecimal as int

Select Top 1 @QuantityDecimal = isnull(QuantityDecimal,0) From MT0000

If @OTransactionID = ''
	Begin
		Set @Status = 1
		GOTO RETURN_VALUES
	End 
Else
	Begin
		If 	isnull(Round((Select Sum(isnull(RemainQuantity,0)) From MQ2221 Where TransactionID = @OTransactionID),@QuantityDecimal),0) + 
			isnull(Round((Select Sum(isnull(Quantity,0)) From MT1001 Where OTransactionID = @OTransactionID),@QuantityDecimal),0) - Round(@Quantity,@QuantityDecimal) >=0
			Begin
				Set @Status = 1
				GOTO RETURN_VALUES
			End
		Else
			Begin
				Set @Status = 0
				GOTO RETURN_VALUES
			End
	End

RETURN_VALUES:
	Select @Status As Status