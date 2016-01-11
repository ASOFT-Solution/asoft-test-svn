/****** Object:  StoredProcedure [dbo].[OP4012]    Script Date: 12/20/2010 15:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Cteated by: VoThanh Huong, date: 29/09/2005
--Purpose: Lay so lieu load len man hinh chi tiet chung tu cua  bao cao PP DAT HANG
/********************************************
'* Edited by: [GS] [Thành Nguyên] [04/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[OP4012]  @ReportCode nvarchar(50),
				@DivisionID nvarchar(50),
				@FromMonth int,
				@FromYear int,
				@ToMonth int,
				@ToYear int,
				@InventoryID nvarchar(50),
				@Orders int, ---------Tu 1--> 30
				@FromValue01ID 	nvarchar(50),
				@ToValue01ID 		nvarchar(50),
				@FromValue02ID 	nvarchar(50),
				@ToValue02ID 		nvarchar(50),
				@FromValue03ID 	nvarchar(50),
				@ToValue03ID 		nvarchar(50),
				@FromValue04ID 	nvarchar(50),
				@ToValue04ID 		nvarchar(50)
AS
DECLARE @sSQL 		nvarchar(4000),
	@FromPeriod 		int,
	@ToPeriod 		int,	
	@LineID		nvarchar(50),
	@LineDescription	nvarchar(250),
	@Code 			nvarchar(50),
	@Method		 int,
	@MonthAmount 	int,
	@DataType 		nvarchar(50),
	@IsQuantity 		tinyint,
	@AmountType 		nvarchar(50),
	@IsPast 		tinyint,
	@FromAccountID 	nvarchar(50),
	@ToAccountID		nvarchar(50),
	@FromCorAccountID 	nvarchar(50),
	@ToCorAccountID 	nvarchar(50),	
	@AmountField 		nvarchar(50),
	@sWhere 		nvarchar(4000),
	@FilterField01ID 	nvarchar(50),
	@FilterField02ID 	nvarchar(50),
	@FilterField03ID 	nvarchar(50),
	@FilterField04ID 	nvarchar(50),
	@Filter01ID		nvarchar(50),
	@Filter02ID		nvarchar(50),
	@Filter03ID		nvarchar(50),
	@Filter04ID		nvarchar(50)

Select @LineID = LineID, @Code = Code, @Orders = Orders, @LineDescription = LineDescription, 
		@Method = Method, @MonthAmount = MonthAmount, @DataType = DataType, 
		@AmountType = AmountType, @IsPast = IsPast, 	@FromAccountID = FromAccountID, 
		@ToAccountID = ToAccountID, @FromCorAccountID = FromCorAccountID, @ToCorAccountID = ToCorAccountID		
From OT4012
Where ReportCode =   @ReportCode  and Orders =  @Orders  	

IF @DataType in('SO','PO')
BEGIN
	Select @Filter01ID = Filter01ID, @Filter01ID = Filter01ID, @Filter01ID = Filter01ID, @Filter01ID = Filter01ID 
	From OT4011 
	Where ReportCode = @ReportCode 

	-------------------------Cac dieu kien
	Select @sWhere = ' DivisionID like N''' + @DivisionID + ''' and InventoryID like N''' +isnull(@InventoryID, '''')  + '''', 
		@sSQL ='', 
		@FromPeriod = @FromMonth  + @FromYear*100,	
		@ToPeriod = @ToMonth  + @ToYear*100

	IF @MonthAmount <0
		Set  @sWhere   =  @sWhere  +  ' and TranMonth + TranYear*100  between ' + 
			cast(@FromPeriod + @MonthAmount as nvarchar(50)) + ' and ' + cast(@FromPeriod - 1 as nvarchar(50))
	ELSE 
		IF @MonthAmount >0
			Set @sWhere  =   @sWhere  +  ' and TranMonth + TranYear*100  between ' + cast(@FromPeriod  as nvarchar(50)) + ' and ' +
				cast(@FromPeriod + @MonthAmount - 1 as nvarchar(50))
		ELSE 
			Set @sWhere  =   @sWhere  +  ' and TranMonth + TranYear*100  between ' + cast(@FromPeriod  as nvarchar(50)) + ' and ' +
				cast(@ToPeriod as nvarchar(50))

	--Lay So luong/Thanh tien
	IF @AmountType  = 'AQ' 
		Set @AmountField = 'Quantity'
	ELSE
		Set @AmountField = 'ConvertedAmount'	

	--Cot so lieu
	Set @sWhere = @sWhere + 	case when  @DataType = 'PO'  then ' and Type = ''PO''' else 
		case when  @DataType = 'SO'  then ' and Type = ''SO''' end end 


	---------------------------------------------Loc ---------------------------------------------------------
	If isnull(@Filter01ID, '') <> ''
	  Begin
		Exec AP4700	  @Filter01ID, 	@FilterField01ID OUTPUT
		Select @sWHERE = @sWHERE + ' and 
			(' + @FilterField01ID + ' between N''' + @FromValue01ID + ''' and N''' + @ToValue01ID  + ''') '			
	  End

	If isnull(@Filter02ID, '') <> ''
	Begin
		Exec AP4700	  @Filter02ID, 	@FilterField02ID OUTPUT
		Select @sWHERE = @sWHERE + ' and 
			(' + @FilterField02ID + ' between N''' + @FromValue02ID + ''' and N''' + @ToValue02ID  + ''') '			
	  End

	If isnull(@Filter04ID, '') <> ''
	  Begin
		Exec AP4700	  @Filter04ID, 	@FilterField04ID OUTPUT
		Select @sWHERE = @sWHERE + ' and 
			(' + @FilterField04ID + ' between N''' + @FromValue04ID + ''' and N''' + @ToValue04ID  + ''') '			
	End
---------------------------------------------------------------------------
	Set @sSQL = '
	Select DivisionID, VoucherID, VoucherTypeID, VoucherNo, VoucherDate,
		ObjectID, ObjectName, case when Isnull(TDescription, '''') = '''' then VDescription else TDescription end as Description,
		Orders, Quantity, ConvertedAmount	
	From OV2600
	Where ' + @sWhere 
END
ELSE 
	Set @sSQL  = 'Select '''' as VoucherID, '''' as VoucherTypeID, '''' as VoucherNo, '''' as VoucherDate, '''' as ObjectID, '''' as ObjectName,
		'''' as Description, NULL as Orders, NULL  as Quantity, NULL as ConvertedAmount'



IF not  exists (Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'OV4012')
	EXEC('Create view OV4012 ---tao boi OP4012 as ' + @sSQL)
ELSE 
	EXEC('Alter view OV4012 ---tao boi OP4012 as ' + @sSQL)
