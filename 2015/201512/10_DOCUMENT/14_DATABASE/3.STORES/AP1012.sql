
/****** Object:  StoredProcedure [dbo].[AP1012]    Script Date: 07/29/2010 17:23:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----- Created by Nguyen Van Nhan, Date 23/09/2003
---- Lay ty gia theo ngay
/********************************************
'* Edited by: [GS] [Thanh Nguyen] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP1012] @CurrencyID as nvarchar(50), @ExDate as datetime

 AS

Declare @ExchangeRate as decimal(28, 8)

Set @ExchangeRate = (Select top 1 ExchangeRate From AT1012 Where CurrencyID =@CurrencyID and ExchangeDate =@ExDate)
If @ExchangeRate is null
	Set @ExchangeRate = (Select ExchangeRate From AT1004 Where CurrencyID =@CurrencyID)

Select isnull(@ExchangeRate,1) as ExchangeRate
GO
