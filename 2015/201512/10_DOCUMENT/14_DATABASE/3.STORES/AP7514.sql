
/****** Object:  StoredProcedure [dbo].[AP7514]    Script Date: 07/29/2010 09:49:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP7514]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AP7514]
GO

/****** Object:  StoredProcedure [dbo].[AP7514]    Script Date: 07/29/2010 09:49:32 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


---- Created by Nguyen Van Nhan.
----- Date 12/12/2007
----- So tien gui ngan hang, nhom theo Ngan hang, Tai khoan
----- Modified on 03/10/2013 by Khanh Van : bo sung orderby
----- Modified on 03/10/2014 by Quốc Tuấn : bo sung điều kiện where

/**********************************************
** Edited by: [GS] [Cẩm Loan] [30/07/2010]
***********************************************/

CREATE PROCEDURE [dbo].[AP7514] @DivisionID as nvarchar(50),
				@BankID as nvarchar(50),
				@AccountID as nvarchar(50),			
				@CurrencyID as nvarchar(50),
				@FromMonth as int,
				@FromYear as int,
				@ToMonth as int,
				@ToYear as int,	
				@FromDate as datetime,
				@ToDate as datetime,
				@IsDate as tinyint,
				@Orderby as nvarchar(1000),
				@SqlWhere AS NVARCHAR(MAX)
AS

Declare @BegOrginalAmount as decimal(28,8),
	@BegConvertedAmount as decimal(28,8),
	@EndOrginalAmount as decimal(28,8),
	@EndConvertedAmount as decimal(28,8)

--Set @BankAccountID = replace(@BankAccountID,'''','''''')
If isnull(@Orderby,'')=''
	Set @Orderby = 'Order by BankAccountID,Voucherdate,TransactionTypeID'

If @IsDate = 0 		--- Xac dinh theo thang
	Exec AP7515 @DivisionID, @BankID, @AccountID, @CurrencyID, @FromMonth, @FromYear , @ToMonth, @ToYear, @Orderby,@SqlWhere
Else
	Exec AP7516 @DivisionID, @BankID, @AccountID,  @CurrencyID, @FromDate, @ToDate, @Orderby,@SqlWhere

GO

