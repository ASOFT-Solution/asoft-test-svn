/****** Object:  StoredProcedure [dbo].[AP7421]    Script Date: 08/02/2010 10:08:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



------ Created by Nguyen Thi Ngoc Minh, Date 16/09/2003
------- In to khai thue GTGT

/********************************************
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP7421]	@DivisionID AS NVARCHAR(50),
				@TranMonth AS INT,
				@TranYear AS INT,
				@IncreaseAdjustmentVAT1 as decimal(28,8),
				@DecreaseAdjustmentVAT1 as decimal(28,8),
				@IncreaseAdjustmentPurchase as decimal(28,8),
				@DecreaseAdjustmentPurchase as decimal(28,8),
				@IncreaseAdjustmentVAT2 as decimal(28,8),
				@DecreaseAdjustmentVAT2 as decimal(28,8),
				@IncreaseAdjustmentSales as decimal(28,8),
				@DecreaseAdjustmentSales as decimal(28,8),
				@PreviousVAT as decimal(28,8)

AS

DECLARE @sSQL NVARCHAR(max),
	@sSQL1 NVARCHAR(max),
	@sSQL2 NVARCHAR(max),
	@sWHERETO NVARCHAR(max),
	@sWHEREVAT NVARCHAR(max),
	@Period INT,
	@FirstPeriod INT,
	@WardIndex as int,
	@DistrictIndex as int,
	@ProvinceIndex as int,
	@Address as NVARCHAR(250),
	@Ward as NVARCHAR(100),
	@District as NVARCHAR(100),
	@Province as NVARCHAR(100),
	@NextPeriodVAT as decimal(28,8),
	@AT7420_Cur as cursor,
	@LineID as NVARCHAR(50),
	@IsIn as tinyint,
	@IsTurnOver as tinyint,
	@IsTax as tinyint,
	@IsBold as tinyint,
	@IsAccumulated as tinyint,
	@Sign as int,
	@AccumulateLineID1 as int,
	@AccumulateLineID2 as int,
	@TurnOverCode as NVARCHAR(50),
	@TaxCode as NVARCHAR(50),
	@Description as NVARCHAR(250),
	@TOAccountID1From NVARCHAR(50),
	@TOAccountID1To NVARCHAR(50),
	@TOAccountID2From NVARCHAR(50),
	@TOAccountID2To NVARCHAR(50),
	@TOAccountID3From NVARCHAR(50),
	@TOAccountID3To NVARCHAR(50),
	@TOAccountID4From NVARCHAR(50),
	@TOAccountID4To NVARCHAR(50),
	@TOAccountID5From NVARCHAR(50),
	@TOAccountID5To NVARCHAR(50),
	@TOInvoiceTypeFrom NVARCHAR(50),
	@TOInvoiceTypeTo NVARCHAR(50),
	@TOVATGroupFrom NVARCHAR(50),
	@TOVATGroupTo NVARCHAR(50),
	@TOVoucherTypeFrom NVARCHAR(50),
	@TOVoucherTypeTo NVARCHAR(50),
	@VATAccountID1From NVARCHAR(50),
	@VATAccountID1To NVARCHAR(50),
	@VATAccountID2From NVARCHAR(50),
	@VATAccountID2To NVARCHAR(50),
	@VATAccountID3From NVARCHAR(50),
	@VATAccountID3To NVARCHAR(50),
	@VATInvoiceTypeFrom NVARCHAR(50),
	@VATInvoiceTypeTo NVARCHAR(50),
	@VATGroupFrom NVARCHAR(50),
	@VATGroupTo NVARCHAR(50),
	@VATVoucherTypeFrom NVARCHAR(50),
	@VATVoucherTypeTo NVARCHAR(50),
	@TurnOverAmount as decimal(28,8),
	@TaxAmount as decimal(28,8),
	@Account as NVARCHAR(50),
	@Description1 as NVARCHAR(250),
	@Amount1 as decimal(28,8),
	@Amount2 as decimal(28,8),
	@IsBold1 as tinyint

Set @Address = ''
Select @Address = Address From AT1101 Where DivisionID = @DivisionID
Set @Province = ''
Set @District = ''

If CHARINDEX(',', @Address, 1) <> 0
  Begin
	Select @WardIndex = CHARINDEX(',', Address,1) From AT1101 Where DivisionID = @DivisionID
	Set @Ward = SUBSTRING(@Address, @WardIndex+1,300)
	If CHARINDEX(',', @Ward) <> 0
	  Begin
		Set @DistrictIndex = CHARINDEX(',', @Ward) 
		Set @District = SUBSTRING(@Ward, @DistrictIndex+1, 500)
		Set @Ward = SUBSTRING(@Address, @WardIndex+1, @DistrictIndex - 1)
		Set @Address = SUBSTRING(@Address, 1, @WardIndex - 1)
		If CHARINDEX(',', @District) <> 0
		  Begin
			Set @ProvinceIndex = CHARINDEX(',', @District) 
			Set @Province = SUBSTRING(@District, @ProvinceIndex +1,500)
			Set @District = SUBSTRING(@District, 1, @ProvinceIndex -1)
		  End
  	  End
	
  End

SET @FirstPeriod = (Select BeginMonth From AT1101 Where DivisionID = @DivisionID) + 
			(Select BeginYear From AT1101 Where DivisionID = @DivisionID)*100 
SET @Period = @TranYear*100 + @TranMonth
SET @sSQL = ''

If not Exists (Select top 1 1  From SysObjects Where Name ='AT7422' and Xtype ='U')
CREATE TABLE [dbo].[AT7422] (
	[DivisionID] [nvarchar] (50) NULL,
	[LineID] [int] NOT NULL ,
	[Sign] [int] NULL ,
	[AccumulateLineID1] [int] NULL ,
	[AccumulateLineID2] [int] NULL ,
	[TurnOverCode] [nvarchar] (50) NULL ,
	[TaxCode] [nvarchar] (50) NULL ,
	[IsBold] [tinyint] NOT NULL ,
	[Description] [nvarchar] (250) NULL ,
	[TurnOverAmount] [decimal] (28,8) NULL,
	[TaxAmount] [decimal] (28,8) NULL
) 
Else
  Delete  AT7422

Set @AT7420_Cur = CURSOR SCROLL KEYSET FOR
	Select 	LineID, IsIn, IsTurnOver, IsTax, IsBold, Sign, AccumulateLineID1, AccumulateLineID2,
		Description, TurnOverCode, TaxCode, TOAccountID1From, TOAccountID1To, TOAccountID2From, TOAccountID2To,
		TOAccountID3From, TOAccountID3To, TOAccountID4From, TOAccountID4To,
		TOAccountID5From, TOAccountID5To, TOInvoiceTypeFrom, TOInvoiceTypeTo,
		TOVATGroupFrom, TOVATGroupTo, TOVoucherTypeFrom, TOVoucherTypeTo,
		VATAccountID1From, VATAccountID1To, VATAccountID2From, VATAccountID2To,
		VATAccountID3From, VATAccountID3To, VATInvoiceTypeFrom, VATInvoiceTypeTo,
		VATGroupFrom, VATGroupTo, VATVoucherTypeFrom, VATVoucherTypeTo
	From AT7420
	Where IsAccumulated = 0 AND DivisionID = @DivisionID

OPEN @AT7420_Cur

FETCH NEXT FROM @AT7420_Cur INTO @LineID, @IsIn, @IsTurnOver, @IsTax, @IsBold, @Sign, @AccumulateLineID1, 
		@AccumulateLineID2, @Description, @TurnOverCode, @TaxCode, 
		@TOAccountID1From, @TOAccountID1To, @TOAccountID2From, 
		@TOAccountID2To, @TOAccountID3From, @TOAccountID3To, @TOAccountID4From, 
		@TOAccountID4To, @TOAccountID5From, @TOAccountID5To, @TOInvoiceTypeFrom, 
		@TOInvoiceTypeTo, @TOVATGroupFrom, @TOVATGroupTo, @TOVoucherTypeFrom, 
		@TOVoucherTypeTo, @VATAccountID1From, @VATAccountID1To, @VATAccountID2From, 
		@VATAccountID2To, @VATAccountID3From, @VATAccountID3To, @VATInvoiceTypeFrom, 
		@VATInvoiceTypeTo, @VATGroupFrom, @VATGroupTo, @VATVoucherTypeFrom, @VATVoucherTypeTo

While @@FETCH_STATUS = 0
Begin
	Set @TurnOverAmount = 0
	Set @TaxAmount = 0
	Set @sWHERETO = '1=1'
	Set @sWHEREVAT = '1=1'
	print str(@Sign)
	If @IsIn = 1
		Set @Account = 'DebitAccountID'
	Else
		Set @Account = 'CreditAccountID'
--------------------------Dieu kien loc doanh so--------------------
	If @TOAccountID1From is not null and @TOAccountID1To is not null
		Set @sWHERETO = @sWHERETO + ' and ((' + @Account + ' between ''' + @TOAccountID1From + ''' and ''' + @TOAccountID1To + ''')'
	If @TOAccountID2From is not null and @TOAccountID2To is not null
		Set @sWHERETO = @sWHERETO + '
			or (' + @Account + ' between ''' + @TOAccountID2From + ''' and ''' + @TOAccountID2To + ''')'
	If @TOAccountID3From is not null and @TOAccountID3To is not null
		Set @sWHERETO = @sWHERETO + '
			or (' + @Account + ' between ''' + @TOAccountID3From + ''' and ''' + @TOAccountID3To + ''')'
	If @TOAccountID4From is not null and @TOAccountID4To is not null
		Set @sWHERETO = @sWHERETO + '
			or (' + @Account + ' between ''' + @TOAccountID4From + ''' and ''' + @TOAccountID4To + ''')'
	If @TOAccountID5From is not null and @TOAccountID5To is not null
		Set @sWHERETO = @sWHERETO + '
			or (' + @Account + ' between ''' + @TOAccountID5From + ''' and ''' + @TOAccountID5To + ''')'
	If ( @TOAccountID1From is not null and @TOAccountID1To is not null) or (@TOAccountID2From is not null and @TOAccountID2To is not null) or
		( @TOAccountID3From is not null and @TOAccountID3To is not null) or (@TOAccountID4From is not null and @TOAccountID4To is not null)
		or (@TOAccountID5From is not null and @TOAccountID5To is not null)
		Set @sWHERETO = @sWHERETO + ')'
	If @TOInvoiceTypeFrom is not null and @TOInvoiceTypeTo is not null
		Set @sWHERETO = @sWHERETO + '
			and (VATTypeID between ''' + @TOInvoiceTypeFrom + ''' and ''' + @TOInvoiceTypeTo + ''')'
	If @TOVATGroupFrom is not null and @TOVATGroupTo is not null
		Set @sWHERETO = @sWHERETO + '
			and (VATGroupID between ''' + @TOVATGroupFrom + ''' and ''' + @TOVATGroupTo + ''')'
	If @TOVoucherTypeFrom is not null and @TOVoucherTypeTo is not null
		Set @sWHERETO = @sWHERETO + '
			and (VoucherTypeID between ''' + @TOVoucherTypeFrom + ''' and ''' + @TOVoucherTypeTo + ''')'

---------------------------Dieu kien loc VAT------------------------------
	If @VATAccountID1From is not null and @VATAccountID1To is not null
		Set @sWHEREVAT = @sWHEREVAT + ' and ((' + @Account + ' between ''' + @VATAccountID1From + ''' and ''' + @VATAccountID1To + ''')'
	If @VATAccountID2From is not null and @VATAccountID2To is not null
		Set @sWHEREVAT = @sWHEREVAT + '
			or (' + @Account + ' between ''' + @VATAccountID2From + ''' and ''' + @VATAccountID2To + ''')'
	If @VATAccountID3From is not null and @VATAccountID3To is not null
		Set @sWHEREVAT = @sWHEREVAT + '
			or (' + @Account + ' between ''' + @VATAccountID3From + ''' and ''' + @VATAccountID3To + ''')'
	If ( @VATAccountID1From is not null and @VATAccountID1To is not null) or (@VATAccountID2From is not null and @VATAccountID2To is not null) or
		( @VATAccountID3From is not null and @VATAccountID3To is not null) 
		Set @sWHEREVAT = @sWHEREVAT + ')'
	If @VATInvoiceTypeFrom is not null and @VATInvoiceTypeTo is not null
		Set @sWHEREVAT = @sWHEREVAT + '
			and (VATTypeID between ''' + @VATInvoiceTypeFrom + ''' and ''' + @VATInvoiceTypeTo + ''')'
	If @VATGroupFrom is not null and @VATGroupTo is not null
		Set @sWHEREVAT = @sWHEREVAT + '
			and (VATGroupID between ''' + @VATGroupFrom + ''' and ''' + @VATGroupTo + ''')'
	If @VATVoucherTypeFrom is not null and @VATVoucherTypeTo is not null
		Set @sWHEREVAT = @sWHEREVAT + '
			and (VoucherTypeID between ''' + @VATVoucherTypeFrom + ''' and ''' + @VATVoucherTypeTo + ''')'

-- print @LineID;
--------------Doanh so---------------
	If @IsTurnOver = 1
	   Begin

		Set @sSQL = 'Select sum(isnull(ConvertedAmount,0)) as ConvertedAmount From AT9000
		Where DivisionID = ''' + @DivisionID + ''' and ' + @sWHERETO 

		If not exists (Select name from sysobjects Where id = Object_id(N'[dbo].[AV7421]') and OBJECTPROPERTY(id, N'IsView') = 1)
     			Exec ('  Create View AV7421 	--created by AP7421
				as ' + @sSQL)
		Else
			Exec ('  Alter View AV7421  	--created by AP7421
				as ' + @sSQL)

		Set @TurnOverAmount = (Select isnull(ConvertedAmount,0) From AV7421)
	   End
--------------Thue GTGT---------------
	If @IsTax = 1
	   Begin
		Set @sSQL = 'Select sum(isnull(ConvertedAmount,0)) as ConvertedAmount From AT9000
		Where DivisionID = ''' + @DivisionID + ''' and ' + @sWHEREVAT 
--print @sSQL		
		If not exists (Select name from sysobjects Where id = Object_id(N'[dbo].[AV7421]') and OBJECTPROPERTY(id, N'IsView') = 1)
     			Exec ('  Create View AV7421 	--created by AP7421
				as ' + @sSQL)
		Else
			Exec ('  Alter View AV7421  	--created by AP7421
				as ' + @sSQL)

		Set @TaxAmount = (Select isnull(ConvertedAmount,0) From AV7421)
	   End
	--print str(@Sign)
	INSERT INTO AT7422 	(DivisionID, LineID, [Sign], AccumulateLineID1, AccumulateLineID2, TurnOverCode, 
				TaxCode, IsBold, Description, TurnOverAmount, TaxAmount)
		VALUES	(@DivisionID, @LineID, @Sign, @AccumulateLineID1, @AccumulateLineID2, @TurnOverCode, 
				@TaxCode, @IsBold, @Description, @TurnOverAmount, @TaxAmount)
	
	FETCH NEXT FROM @AT7420_Cur INTO @LineID, @IsIn, @IsTurnOver, @IsTax, @IsBold, @Sign, @AccumulateLineID1, 
			@AccumulateLineID2, @Description, @TurnOverCode, @TaxCode, 
			@TOAccountID1From, @TOAccountID1To, @TOAccountID2From, 
			@TOAccountID2To, @TOAccountID3From, @TOAccountID3To, @TOAccountID4From, 
			@TOAccountID4To, @TOAccountID5From, @TOAccountID5To, @TOInvoiceTypeFrom, 
			@TOInvoiceTypeTo, @TOVATGroupFrom, @TOVATGroupTo, @TOVoucherTypeFrom, 
			@TOVoucherTypeTo, @VATAccountID1From, @VATAccountID1To, @VATAccountID2From, 
			@VATAccountID2To, @VATAccountID3From, @VATAccountID3To, @VATInvoiceTypeFrom, 
			@VATInvoiceTypeTo, @VATGroupFrom, @VATGroupTo, @VATVoucherTypeFrom, @VATVoucherTypeTo

End

CLOSE @AT7420_Cur

----------------
UPDATE AT7422	 Set	TaxAmount = @PreviousVAT
			Where LineID = 1 AND DivisionID = @DivisionID

UPDATE AT7422	 Set	TurnOverAmount = @IncreaseAdjustmentPurchase,
				TaxAmount = @IncreaseAdjustmentVAT1
			Where LineID = 7 AND DivisionID = @DivisionID

UPDATE AT7422	 Set	TurnOverAmount = @DecreaseAdjustmentPurchase,
				TaxAmount = @DecreaseAdjustmentVAT1
			Where LineID = 8 AND DivisionID = @DivisionID

UPDATE AT7422	 Set	TurnOverAmount = @IncreaseAdjustmentSales,
				TaxAmount = @IncreaseAdjustmentVAT2
			Where LineID = 17 AND DivisionID = @DivisionID

UPDATE AT7422	 Set	TurnOverAmount = @DecreaseAdjustmentSales,
				TaxAmount = @DecreaseAdjustmentVAT2
			Where LineID = 18 AND DivisionID = @DivisionID

UPDATE AT7422	 Set	TurnOverAmount = 0,
				TaxAmount = 0
			Where LineID = 21 AND DivisionID = @DivisionID

----------------------------Tinh tong-------------------------------

Set @AT7420_Cur = CURSOR SCROLL KEYSET FOR
	Select 	LineID, IsIn, IsTurnOver, IsTax, IsBold, [Sign], AccumulateLineID1, AccumulateLineID2,
		Description, TurnOverCode, TaxCode, TOAccountID1From, TOAccountID1To, TOAccountID2From, TOAccountID2To,
		TOAccountID3From, TOAccountID3To, TOAccountID4From, TOAccountID4To,
		TOAccountID5From, TOAccountID5To, TOInvoiceTypeFrom, TOInvoiceTypeTo,
		TOVATGroupFrom, TOVATGroupTo, TOVoucherTypeFrom, TOVoucherTypeTo,
		VATAccountID1From, VATAccountID1To, VATAccountID2From, VATAccountID2To,
		VATAccountID3From, VATAccountID3To, VATInvoiceTypeFrom, VATInvoiceTypeTo,
		VATGroupFrom, VATGroupTo, VATVoucherTypeFrom, VATVoucherTypeTo
	From AT7420
	Where IsAccumulated = 1 AND DivisionID = @DivisionID

OPEN @AT7420_Cur


FETCH NEXT FROM @AT7420_Cur INTO @LineID, @IsIn, @IsTurnOver, @IsTax, @IsBold, @Sign, @AccumulateLineID1, 
		@AccumulateLineID2, @Description, @TurnOverCode, @TaxCode, 
		@TOAccountID1From, @TOAccountID1To, @TOAccountID2From, 
		@TOAccountID2To, @TOAccountID3From, @TOAccountID3To, @TOAccountID4From, 
		@TOAccountID4To, @TOAccountID5From, @TOAccountID5To, @TOInvoiceTypeFrom, 
		@TOInvoiceTypeTo, @TOVATGroupFrom, @TOVATGroupTo, @TOVoucherTypeFrom, 
		@TOVoucherTypeTo, @VATAccountID1From, @VATAccountID1To, @VATAccountID2From, 
		@VATAccountID2To, @VATAccountID3From, @VATAccountID3To, @VATInvoiceTypeFrom, 
		@VATInvoiceTypeTo, @VATGroupFrom, @VATGroupTo, @VATVoucherTypeFrom, @VATVoucherTypeTo

While @@FETCH_STATUS = 0
   Begin 
--print 'vao'
	Set @TurnOverAmount = 0
	Set @TaxAmount = 0
--print str(@LineID)
	If @IsTurnOver = 1
	   Begin
		Set @TurnOverAmount = (Select Sum( isnull(TurnOverAmount,0)*Sign)
		From AT7422
		Where AccumulateLineID1 = @LineID AND DivisionID = @DivisionID)
		--print str(@TurnOverAmount)
   	   End

	If @IsTax = 1
	   Begin
		Set @TaxAmount = (Select Sum( isnull(TaxAmount,0)*Sign)
		From AT7422
		Where AccumulateLineID2 = @LineID AND DivisionID = @DivisionID)
		--print str(@TaxAmount)
   	   End
	INSERT INTO AT7422 	(DivisionID, LineID, [Sign], AccumulateLineID1, AccumulateLineID2, TurnOverCode, 
				TaxCode, IsBold, Description, TurnOverAmount, TaxAmount)
		VALUES	(@DivisionID, @LineID, @Sign, @AccumulateLineID1, @AccumulateLineID2, @TurnOverCode, 
				@TaxCode, @IsBold, @Description, @TurnOverAmount, @TaxAmount)
	FETCH NEXT FROM @AT7420_Cur INTO @LineID, @IsIn, @IsTurnOver, @IsTax, @IsBold, @Sign, @AccumulateLineID1, 
			@AccumulateLineID2, @Description, @TurnOverCode, @TaxCode, 
			@TOAccountID1From, @TOAccountID1To, @TOAccountID2From, 
			@TOAccountID2To, @TOAccountID3From, @TOAccountID3To, @TOAccountID4From, 
			@TOAccountID4To, @TOAccountID5From, @TOAccountID5To, @TOInvoiceTypeFrom, 
			@TOInvoiceTypeTo, @TOVATGroupFrom, @TOVATGroupTo, @TOVoucherTypeFrom, 
			@TOVoucherTypeTo, @VATAccountID1From, @VATAccountID1To, @VATAccountID2From, 
			@VATAccountID2To, @VATAccountID3From, @VATAccountID3To, @VATInvoiceTypeFrom, 
			@VATInvoiceTypeTo, @VATGroupFrom, @VATGroupTo, @VATVoucherTypeFrom, @VATVoucherTypeTo
  End

CLOSE @AT7420_Cur

---------------------Tao view tra ra to khai thue--------------------------------
Select @Amount2 = TaxAmount From AT7422 Where LineID = 1 AND DivisionID = @DivisionID
Select @Description1 = Description From AT7422 Where LineID = 1 AND DivisionID = @DivisionID
Select @IsBold1 = IsBold From AT7422 Where LineID = 1 AND DivisionID = @DivisionID

Set @Amount2 = Isnull(@Amount2, 0)
Set @Description1 = ISNULL(@Description1, '');
SET @IsBold1 = ISNULL(@IsBold1, 0);

Set @sSQL = 'Select ' + ltrim(cast(@Amount2 as NVARCHAR(50))) + ' as PreviousVATAmount, 
	''' + @Description1 + ''' as Line1Description, ' + str(@IsBold1) + ' as Line1IsBold,
'

Select @Amount1 = TurnOverAmount From AT7422 Where LineID = 2 AND DivisionID = @DivisionID
Select @Amount2 = TaxAmount From AT7422 Where LineID = 2 AND DivisionID = @DivisionID
Select @Description1 = Description From AT7422 Where LineID = 2 AND DivisionID = @DivisionID
Select @IsBold1 = IsBold From AT7422 Where LineID =2 AND DivisionID = @DivisionID

Set @Amount1 = Isnull(@Amount1, 0)
Set @Amount2 = Isnull(@Amount2, 0)
Set @Description1 = ISNULL(@Description1, '');
SET @IsBold1 = ISNULL(@IsBold1, 0);

Set @sSQL = @sSQL + ltrim(cast(@Amount1 as NVARCHAR(50))) + ' as TotalPurchase, ' + ltrim(cast(@Amount2 as NVARCHAR(50))) + ' as TotalInVAT,
	''' + @Description1 + ''' as Line2Description, ' + str(@IsBold1) + ' as Line2IsBold,
'

/*print ltrim(str(@Amount1))
print ltrim(str(@Amount2))
print @Description1
print @sSQL*/

Select @Amount1 = TurnOverAmount From AT7422 Where LineID =3 AND DivisionID = @DivisionID
Select @Amount2 = TaxAmount From AT7422 Where LineID = 3 AND DivisionID = @DivisionID
Select @Description1 = Description From AT7422 Where LineID = 3 AND DivisionID = @DivisionID
Select @IsBold1 = IsBold From AT7422 Where LineID =3 AND DivisionID = @DivisionID

Set @sSQL = @sSQL + ltrim(cast(@Amount1 as NVARCHAR(50))) + ' as ImportPurchase, ' + ltrim(cast(@Amount2 as NVARCHAR(50))) + ' as ImportVAT,
	''' + @Description1 + ''' as Line3Description, ' + str(@IsBold1) + ' as Line3IsBold,
'
Select @Amount1 = TurnOverAmount From AT7422 Where LineID = 4 AND DivisionID = @DivisionID
Select @Amount2 = TaxAmount From AT7422 Where LineID = 4 AND DivisionID = @DivisionID
Select @Description1 = Description From AT7422 Where LineID = 4 AND DivisionID = @DivisionID
Select @IsBold1 = IsBold From AT7422 Where LineID = 4 AND DivisionID = @DivisionID

Set @sSQL = @sSQL + ltrim(cast(@Amount1 as NVARCHAR(50))) + ' as AssetPurchase, ' + ltrim(cast(@Amount2 as NVARCHAR(50))) + ' as AssetVAT,
	''' + @Description1 + ''' as Line4Description, ' + str(@IsBold1) + ' as Line4IsBold,
'

Select @Amount2 = TaxAmount From AT7422 Where LineID = 5 AND DivisionID = @DivisionID
Select @Description1 = Description From AT7422 Where LineID = 5 AND DivisionID = @DivisionID
Select @IsBold1 = IsBold From AT7422 Where LineID = 5 AND DivisionID = @DivisionID

Set @sSQL = @sSQL + ltrim(cast(@Amount2 as NVARCHAR(50))) + ' as VATIn,
	''' + @Description1 + ''' as Line5Description, ' + str(@IsBold1) + ' as Line5IsBold,
'

Select @Description1 = Description From AT7422 Where LineID = 6 AND DivisionID = @DivisionID
Select @IsBold1 = IsBold From AT7422 Where LineID = 6 AND DivisionID = @DivisionID

Set @sSQL = @sSQL + '''' + @Description1 + ''' as Line6Description, ' + str(@IsBold1) + ' as Line6IsBold,
'

Select @Amount1 = TurnOverAmount From AT7422 Where LineID = 7 AND DivisionID = @DivisionID
Select @Amount2 = TaxAmount From AT7422 Where LineID = 7 AND DivisionID = @DivisionID
Select @Description1 = Description From AT7422 Where LineID = 7 AND DivisionID = @DivisionID
Select @IsBold1 = IsBold From AT7422 Where LineID = 7 AND DivisionID = @DivisionID

Set @sSQL = @sSQL + ltrim(cast(@Amount1 as NVARCHAR(50))) + ' as IncreasePurchaseAdjust, ' + ltrim(cast(@Amount2 as NVARCHAR(50))) + ' as InVATIncreaseAdjust,
	''' + @Description1 + ''' as Line7Description, ' + str(@IsBold1) + ' as Line7IsBold,
'

Select @Amount1 = TurnOverAmount From AT7422 Where LineID = 8 AND DivisionID = @DivisionID
Select @Amount2 = TaxAmount From AT7422 Where LineID = 8 AND DivisionID = @DivisionID
Select @Description1 = Description From AT7422 Where LineID = 8 AND DivisionID = @DivisionID
Select @IsBold1 = IsBold From AT7422 Where LineID = 8 AND DivisionID = @DivisionID

Set @sSQL = @sSQL + ltrim(cast(@Amount1 as NVARCHAR(50))) + ' as DecreasePurchaseAdjust, ' + ltrim(cast(@Amount2 as NVARCHAR(50))) + ' as InVATDecreaseAdjust,
	''' + @Description1 + ''' as Line8Description, ' + str(@IsBold1) + ' as Line8IsBold,
'

Select @Amount2 = TaxAmount From AT7422 Where LineID = 9 AND DivisionID = @DivisionID
Select @Description1 = Description From AT7422 Where LineID = 9 AND DivisionID = @DivisionID
Select @IsBold1 = IsBold From AT7422 Where LineID = 9 AND DivisionID = @DivisionID

Set @sSQL = @sSQL + ltrim(cast(@Amount2 as NVARCHAR(50))) + ' as TotalDeductVAT,
	''' + @Description1 + ''' as Line9Description, ' + str(@IsBold1) + ' as Line9IsBold,
'
Select @Amount1 = TurnOverAmount From AT7422 Where LineID = 10 AND DivisionID = @DivisionID
Select @Description1 = Description From AT7422 Where LineID = 10 AND DivisionID = @DivisionID
Select @IsBold1 = IsBold From AT7422 Where LineID = 10 AND DivisionID = @DivisionID

Set @sSQL = @sSQL + ltrim(cast(@Amount1 as NVARCHAR(50))) + ' as TotalSale,
	''' + @Description1 + ''' as Line10Description, ' + str(@IsBold1) + ' as Line10IsBold,
'

Select @Amount2 = TaxAmount From AT7422 Where LineID = 11 AND DivisionID = @DivisionID
Select @Description1 = Description From AT7422 Where LineID = 11 AND DivisionID = @DivisionID
Select @IsBold1 = IsBold From AT7422 Where LineID = 11 AND DivisionID = @DivisionID

Set @sSQL1 = ltrim(cast(@Amount2 as NVARCHAR(50))) + ' as TotalOutVAT,
	''' + @Description1 + ''' as Line11Description, ' + str(@IsBold1) + ' as Line11IsBold,
'

Select @Amount1 = TurnOverAmount From AT7422 Where LineID = 12 AND DivisionID = @DivisionID
Select @Description1 = Description From AT7422 Where LineID = 12 AND DivisionID = @DivisionID
Select @IsBold1 = IsBold From AT7422 Where LineID = 12 AND DivisionID = @DivisionID

Set @sSQL1 = @sSQL1 + ltrim(cast(@Amount1 as NVARCHAR(50))) + ' as SaleNoVAT,
	''' + @Description1 + ''' as Line12Description, ' + str(@IsBold1) + ' as Line12IsBold,
'
Select @Amount1 = TurnOverAmount From AT7422 Where LineID = 13 AND DivisionID = @DivisionID
Select @Description1 = Description From AT7422 Where LineID = 13 AND DivisionID = @DivisionID
Select @IsBold1 = IsBold From AT7422 Where LineID = 13 AND DivisionID = @DivisionID

Set @sSQL1 = @sSQL1 + ltrim(cast(@Amount1 as NVARCHAR(50))) + ' as Sale0,
	''' + @Description1 + ''' as Line13Description, ' + str(@IsBold1) + ' as Line13IsBold,
'

Select @Amount1 = TurnOverAmount From AT7422 Where LineID = 14 AND DivisionID = @DivisionID
Select @Amount2 = TaxAmount From AT7422 Where LineID = 14 AND DivisionID = @DivisionID
Select @Description1 = Description From AT7422 Where LineID = 14 AND DivisionID = @DivisionID
Select @IsBold1 = IsBold From AT7422 Where LineID = 14 AND DivisionID = @DivisionID

Set @sSQL1 = @sSQL1 + ltrim(cast(@Amount1 as NVARCHAR(50))) + ' as Sale5, ' + ltrim(cast(@Amount2 as NVARCHAR(50))) + ' as VAT5,
	''' + @Description1 + ''' as Line14Description, ' + str(@IsBold1) + ' as Line14IsBold,
'
Select @Amount1 = TurnOverAmount From AT7422 Where LineID = 15 AND DivisionID = @DivisionID
Select @Amount2 = TaxAmount From AT7422 Where LineID = 15 AND DivisionID = @DivisionID
Select @Description1 = Description From AT7422 Where LineID = 15 AND DivisionID = @DivisionID
Select @IsBold1 = IsBold From AT7422 Where LineID = 15 AND DivisionID = @DivisionID

Set @sSQL1 = @sSQL1 + ltrim(cast(@Amount1 as NVARCHAR(50))) + ' as Sale10, ' + ltrim(cast(@Amount2 as NVARCHAR(50))) + ' as VAT10,
	''' + @Description1 + ''' as Line15Description, ' + str(@IsBold1) + ' as Line15IsBold,
'

Select @Description1 = Description From AT7422 Where LineID = 16 AND DivisionID = @DivisionID
Select @IsBold1 = IsBold From AT7422 Where LineID = 16 AND DivisionID = @DivisionID

Set @sSQL1 = @sSQL1 + '''' + @Description1 + ''' as Line16Description, ' + str(@IsBold1) + ' as Line16IsBold,
'
Select @Amount1 = TurnOverAmount From AT7422 Where LineID = 17 AND DivisionID = @DivisionID
Select @Amount2 = TaxAmount From AT7422 Where LineID = 17 AND DivisionID = @DivisionID
Select @Description1 = Description From AT7422 Where LineID = 17 AND DivisionID = @DivisionID
Select @IsBold1 = IsBold From AT7422 Where LineID = 17 AND DivisionID = @DivisionID

Set @sSQL1 = @sSQL1 + ltrim(cast(@Amount1 as NVARCHAR(50))) + ' as IncreaseSalesAdjust, ' + ltrim(cast(@Amount2 as NVARCHAR(50))) + ' as OutVATIncreaseAdjust,
	''' + @Description1 + ''' as Line17Description, ' + str(@IsBold1) + ' as Line17IsBold,
'
Select @Amount1 = TurnOverAmount From AT7422 Where LineID = 18 AND DivisionID = @DivisionID
Select @Amount2 = TaxAmount From AT7422 Where LineID = 18 AND DivisionID = @DivisionID
Select @Description1 = Description From AT7422 Where LineID = 18 AND DivisionID = @DivisionID
Select @IsBold1 = IsBold From AT7422 Where LineID = 18 AND DivisionID = @DivisionID

Set @sSQL2 = ltrim(cast(@Amount1 as NVARCHAR(50)))  + ' as DecreaseSalesAdjust, ' + ltrim(cast(@Amount2 as NVARCHAR(50))) + ' as OutVATDecreaseAdjust,
	''' + @Description1 + ''' as Line18Description, ' + str(@IsBold1) + ' as Line18IsBold,
'
Select @Amount2 = TaxAmount From AT7422 Where LineID = 19 AND DivisionID = @DivisionID
Select @Description1 = Description From AT7422 Where LineID = 19 AND DivisionID = @DivisionID
Select @IsBold1 = IsBold From AT7422 Where LineID = 19 AND DivisionID = @DivisionID

Set @sSQL2 = @sSQL2 + ltrim(cast(@Amount2 as NVARCHAR(50))) + ' as TotalGiveVAT,
	''' + @Description1 + ''' as Line19Description, ' + str(@IsBold1) + ' as Line19IsBold,
'
Select @Amount2 = TaxAmount From AT7422 Where LineID = 20 AND DivisionID = @DivisionID
Select @Description1 = Description From AT7422 Where LineID = 20 AND DivisionID = @DivisionID
Select @IsBold1 = IsBold From AT7422 Where LineID = 20 AND DivisionID = @DivisionID

Set @sSQL2 = @sSQL2 + ltrim(cast(@Amount2 as NVARCHAR(50))) + ' as NextPeriodVAT,
	''' + @Description1 + ''' as Line20Description, ' + str(@IsBold1) + ' as Line20IsBold,
'
Select @Description1 = Description From AT7422 Where LineID = 21 AND DivisionID = @DivisionID
Select @IsBold1 = IsBold From AT7422 Where LineID = 21 AND DivisionID = @DivisionID

Set @sSQL2 = @sSQL2 + '''' + @Description1 + ''' as Line21Description, ' + str(@IsBold1) + ' as Line21IsBold,
	AT1101.DivisionID, AT1101.DivisionName, AT1101.Tel, AT1101.Fax, AT1101.Email, ''' + @Address + ''' as Address,
	''' + @District + ''' as District, ''' + @Province + ''' as Province, AT1101.VATNO
From AT1101 
Where AT1101.DivisionID = ''' + @DivisionID + '''
'

/*Print @sSQL;
Print @sSQL1;
Print @sSQL2;*/


If not exists (Select name from sysobjects Where id = Object_id(N'[dbo].[AV7420]') and OBJECTPROPERTY(id, N'IsView') = 1)
	Exec ('  Create View AV7420 	--created by AP7421
		as ' + @sSQL + @sSQL1 + @sSQL2);
Else
	Exec ('  Alter View AV7420  	--created by AP7421
		as ' + @sSQL + @sSQL1 + @sSQL2);


Set @NextPeriodVAT = isnull((Select NextPeriodVAT From AV7420),0)


If @TranMonth < 12
   Begin
	If not exists (Select top 1 1 from AT7421 Where DivisionID = @DivisionID and TranMonth = @TranMonth + 1 and TranYear = @TranYear)
		INSERT INTO AT7421 	(DivisionID, TranMonth, TranYear, PreviousVAT)
			VALUES	(@DivisionID, @TranMonth + 1, @TranYear, @NextPeriodVAT)
	Else
		UPDATE AT7421 SET PreviousVAT = @NextPeriodVAT 
			WHERE DivisionID = @DivisionID and TranMonth = @TranMonth + 1 and TranYear = @TranYear
   End
ELSE
   Begin
	If not exists (Select top 1 1 from AT7421 Where DivisionID = @DivisionID and TranMonth = 1 and TranYear = @TranYear + 1)
		INSERT INTO AT7421 	(DivisionID, TranMonth, TranYear, PreviousVAT)
			VALUES	(@DivisionID, 1, @TranYear + 1, @NextPeriodVAT)
	Else
		UPDATE AT7421 SET PreviousVAT = @NextPeriodVAT 
			WHERE DivisionID = @DivisionID and TranMonth = 1 and TranYear = @TranYear + 1
   End





