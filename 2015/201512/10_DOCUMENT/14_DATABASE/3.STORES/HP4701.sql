/****** Object:  StoredProcedure [dbo].[HP4701]    Script Date: 04/06/2012 10:07:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP4701]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP4701]
GO


/****** Object:  StoredProcedure [dbo].[HP4701]    Script Date: 04/06/2012 10:07:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


---- Created Date 20/09/2005
---- purpose: tinh toan cac so lieu luong, phuc vu cho HP7007

/**********************************************
** Edited by: [GS] [Cẩm Loan] [02/08/2010]
***********************************************/

CREATE PROCEDURE [dbo].[HP4701] 
				@DivisionID nvarchar(50),
				@AmountTypeFrom nvarchar(4000), 	----------loai chi tieu 1
				@AmountTypeTo nvarchar(4000),	----------loai chi tieu n
				@Signs as nvarchar(20),		---------dau +,-,*, /
				@IsSerie as tinyint,		---------tinh lien tuc hay cach quang
				@IsChangeCurrency as tinyint,	-------co doi sang loai tien khac khong
				@FromCurrency as nvarchar(20),	------tu loai tien
				@ToCurrency as nvarchar(20),	-----sang loai tien
				@RateExchange as decimal(28,8),	------ty gia
				@ListOfCo as nvarchar(4000) OUTPUT -------ket qua tra ra
AS

Declare @AmountCombine as nvarchar(4000),
	@count1 as int,
	@count2 as int,
	@max as int,
	@ListOfCo1 as nvarchar(4000),
	@First tinyint
Select  @AmountCombine=''	

If @AmountTypeFrom<>@AmountTypeTo 
Begin
If @IsSerie=1 ----------tinh lien tuc
	Begin
	Set @count1=right(@AmountTypeFrom,2)
	Set @count2=right(@AmountTypeTo,2)
	If @count1<@count2 
		Begin			
			Set @max=@count2
			Set @AmountCombine=@AmountCombine + CASE WHEN  @Signs = '+' OR  @Signs= '-' THEN @Signs Else '' End + 'IsNull('+ @AmountTypeFrom+ ',0)'
			
			While @count1 < @max	
				Begin
				Set @count1=@count1+1	
				Set @AmountCombine=@AmountCombine+@Signs + 'IsNull(' + Left(@AmountTypeFrom, len(@AmountTypeFrom)-2) + 
					case when @count1 <10 then '0' + cast(@count1 as varchar(1)) else ''+ cast(@count1 as varchar(2))  end + ',0)'		End

		End
	Else
		Begin			
			Set @max=@count1

			Set @AmountCombine=@AmountCombine + CASE WHEN  @Signs = '+' OR  @Signs= '-' THEN @Signs Else '' End  +  'IsNull('+ @AmountTypeTo + ',0)'
			While @count2 < @max	
				Begin
				Set @count2=@count2+1	
				Set @AmountCombine=@AmountCombine+@Signs + 'IsNull(' + Left(@AmountTypeTo, len(@AmountTypeTo)-2) + 
					case when @count2 <10 then '0' + cast(@count2 as varchar(1)) else ''+ cast(@count2 as varchar(2))  end + ',0)'
				End
			
		End
	Exec HP4703 @DivisionID, @AmountCombine, @IsChangeCurrency , @FromCurrency , @ToCurrency, @RateExchange , @ListOfCo1  OUTPUT
	SELECT @ListOfCo= Replace(@ListOfCo1, 'SubAmount00', 'TaxAmount')

--	Set @ListOfCo = right(@ListOfCo, len(@ListOfCo)-1)
	RETURN		
End


Else------tinh cach quang
Begin
	Set @AmountCombine=@AmountCombine +  CASE WHEN  @Signs = '+' OR  @Signs= '-' THEN @Signs Else '' End  +  'IsNull('+ @AmountTypeFrom + ',0)' + @Signs +  'IsNull('+ @AmountTypeTo + ',0)'

	Exec HP4703 @DivisionID, @AmountCombine, @IsChangeCurrency , @FromCurrency , @ToCurrency, @RateExchange , @ListOfCo1  OUTPUT

	SELECT @ListOfCo= Replace(@ListOfCo1, 'SubAmount00', 'TaxAmount')
	Return

End

End

Else -----2 doi so giong nhau @AmountTypeFrom=@AmountTypeTo 
Begin
	Set @AmountCombine=@AmountCombine + 'IsNull('+ @AmountTypeFrom + ',0)' 
	Exec HP4703 @DivisionID, @AmountCombine, @IsChangeCurrency , @FromCurrency , @ToCurrency, @RateExchange , @ListOfCo1  OUTPUT
	SELECT @ListOfCo= Replace(@ListOfCo1, 'SubAmount00', 'TaxAmount')
	Return

End
GO


