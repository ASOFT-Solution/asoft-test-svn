
/****** Object:  StoredProcedure [dbo].[HP4703]    Script Date: 07/30/2010 11:51:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP4703]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP4703]
GO

/****** Object:  StoredProcedure [dbo].[HP4703]    Script Date: 07/30/2010 11:51:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

---- Created Date 20/09/2005
---- purpose: tinh toan cac so lieu luong, phuc vu cho HP7007

/**********************************************
** Edited by: [GS] [Cẩm Loan] [02/08/2010]
***********************************************/

CREATE PROCEDURE [dbo].[HP4703] 
				@DivisionID nvarchar(50),
				@AmountCombine as nvarchar(500),
				@IsChangeCurrency as tinyint,
				@FromCurrency as nvarchar(50),
				@ToCurrency as nvarchar(50),
				@RateExchange as decimal(28,8),
				@ListOfCo as nvarchar(500) OUTPUT
AS


Set @AmountCombine=ltrim(rtrim(@AmountCombine))


	If @IsChangeCurrency =1 
		Begin
			If @FromCurrency='USD'
				Begin
					Set @AmountCombine= 'IsNull(' + @AmountCombine+ ',0) * ' + str(@RateExchange)
					SELECT @ListOfCo=@AmountCombine
					RETURN
				End
			Else
				Begin
					Set @AmountCombine= 'IsNull(' + @AmountCombine+ ',0)/ ' + str(@RateExchange)
					SELECT @ListOfCo=@AmountCombine
					RETURN
				End
		End

	Else ---------khong doi sang loai tien khac
				Begin
					
					SELECT @ListOfCo='IsNull(' + @AmountCombine+ ',0) ' 
					RETURN
				End
		
	




GO

