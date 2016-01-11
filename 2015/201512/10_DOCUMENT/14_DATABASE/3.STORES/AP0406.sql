IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0406]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0406]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



------ Created by Nguyen Van Nhan, Date 07/04/2008
-----  Purpose: Tu dong giai tru but toan chenh lech ty gia thanh toan
----- Edit by: Dang Le Bao Quynh; Date 23/05/2008
----- Purpose: Them tham so @BacthID
---- Modified on 11/10/2011 by Le Thi Thu Hien : Truyen them @DivisionID vao AP0000
/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [28/07/2010]
'********************************************/

CREATE PROCEDURE [dbo].[AP0406] 	
					@DivisionID nvarchar(50),
					@TranMonth AS int,
					@TranYear AS int,		
					@GiveVoucherID nvarchar(50),		
					@GiveBatchID 	 nvarchar(50),		
					@GiveTableID 	 nvarchar(50),		
					@VoucherID AS nvarchar(50),
					@BacthID AS nvarchar(50),
					@AccountID AS nvarchar(50),
					@ObjectID AS nvarchar(50),
					@CurrencyID AS nvarchar(50),
					@DebitAccountID AS nvarchar(50),
					@CreditAccountID  AS nvarchar(50),
					@ConvertedAmount AS decimal(28,8),
					@UserID AS nvarchar(50)
					

 AS
DECLARE @GiveUpID AS nvarchar(50)

Exec AP0000 @DivisionID, @GiveUpID  OUTPUT, 'AT0404', 'G', @TranYear ,'',18, 3, 0, '-'

IF  	@CreditAccountID = @AccountID
	INSERT AT0404 (GiveUpID, GiveUpDate, GiveUpEmployeeID, DivisionID, ObjectID, AccountID, CurrencyID, 
		DebitVoucherID, DebitBatchID, DebitTableID, CreditVoucherID, CreditBatchID, CreditTableID, 
		OriginalAmount, ConvertedAmount, IsExrateDiff, CreateDate, CreateUserID, LastModifyUserID, LastModifyDate)
	VALUES  (@GiveUpID, getdate(), null, @DivisionID, @ObjectID, @AccountID, @CurrencyID,
		@GiveVoucherID, @GiveBatchID, @GiveTableID, @VoucherID, @BacthID, 'AT9000',
		0, @ConvertedAmount, 0, getdate(), @UserID, @UserID, getDate())
ELSE
	INSERT AT0404 (GiveUpID, GiveUpDate, GiveUpEmployeeID, DivisionID, ObjectID, AccountID, CurrencyID, 
		DebitVoucherID, DebitBatchID, DebitTableID, CreditVoucherID, CreditBatchID, CreditTableID, 
		OriginalAmount, ConvertedAmount, IsExrateDiff, CreateDate, CreateUserID, LastModifyUserID, LastModifyDate)
	VALUES  (@GiveUpID, getdate(), null, @DivisionID, @ObjectID, @AccountID, @CurrencyID,
		 @VoucherID, @BacthID, 'AT9000',@GiveVoucherID, @GiveBatchID, @GiveTableID,
		0, @ConvertedAmount, 0, getdate(), @UserID, @UserID, getDate())


UPDATE	AT9000 
SET		Status =1
WHERE	VoucherID = @VoucherID 
		AND TransactionTypeID = 'T10' 
		AND DivisionID = @DivisionID

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

