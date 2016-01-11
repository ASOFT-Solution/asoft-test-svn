/****** Object:  StoredProcedure [dbo].[OP4011]    Script Date: 12/27/2010 15:45:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----Created by: Vo Thanh Huong, date: 22/09/2005
----Purpose: In bao cao PP DAT HANG
/********************************************
'* Edited by: [GS] [Thành Nguyên] [04/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[OP4011] @ReportCode nvarchar(50),
				@DivisionID nvarchar(50),				
				@FromMonth int,
				@FromYear int,
				@ToMonth int,
				@ToYear int,				
				@FromValue01ID 	nvarchar(50),
				@ToValue01ID 		nvarchar(50),
				@FromValue02ID 	nvarchar(50),
				@ToValue02ID 		nvarchar(50),
				@FromValue03ID 	nvarchar(50),
				@ToValue03ID 		nvarchar(50),
				@FromValue04ID 	nvarchar(50),
				@ToValue04ID 		nvarchar(50)			
AS
DECLARE @sSQL		nvarchar(4000),
	@sFormular 		nvarchar(2000),	
	@FromPeriod 		int,
	@ToPeriod		int,
	@sPeriod		nvarchar(200),
	@sPeriod0  		nvarchar(200), 
	@cur			cursor,
	@LineID		nvarchar(50),
	@LineDescription	nvarchar(50),
	@Code			nvarchar(50),
	@Orders 		int,
	@Method 		int,
	@MonthAmount 	int,
	@DataType 		nvarchar(50),
	@IsQuantity 		tinyint,
	@AmountType 		nvarchar(50),
	@IsPast 		tinyint,
	@FromAccountID 	nvarchar(50),
	@ToAccountID 		nvarchar(50),
	@FromCorAccountID 	nvarchar(50),
	@ToCorAccountID 	nvarchar(50),
	@Sign10 		nvarchar(50),	
	@Sign20 		nvarchar(50),
	@Col10 		decimal(28,8),
	@Col20 		decimal(28,8),
	@Col11 		nvarchar(50),
	@Col12 		nvarchar(50),
	@Col13 		nvarchar(50),
	@Col14 		nvarchar(50),
	@Col15 		nvarchar(50),
	@Col21 		nvarchar(50),
	@Col22 		nvarchar(50),
	@Col23 		nvarchar(50),
	@Col24 		nvarchar(50),
	@Col25 		nvarchar(50), 
	@AmountField 		nvarchar(50),
	@sWhere		nvarchar(4000),
	@sWhere0		nvarchar(4000),
	@sFrom			nvarchar(4000),
	@FilterField01ID 	nvarchar(50),
	@FilterField02ID 	nvarchar(50),
	@FilterField03ID 	nvarchar(50),
	@FilterField04ID 	nvarchar(50),
	@Filter01ID		nvarchar(50),
	@Filter02ID		nvarchar(50),
	@Filter03ID		nvarchar(50),
	@Filter04ID		nvarchar(50),
	@sOT4445_INSERT	nvarchar(4000),
	@sOT4445_VALUE	nvarchar(4000)

if NOT exists (select top 1 1 from dbo.sysobjects where id = object_id(N'[dbo].[OT4444]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
CREATE TABLE [dbo].[OT4444] (
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar] (50)  NULL ,
	[InventoryID] [nvarchar] (50)  NULL ,
	[InventoryName] [nvarchar] (250)  NULL ,
	[UnitID] [nvarchar] (50)  NULL ,
	[UnitName] [nvarchar] (250)  NULL ,
	[Amount01] [decimal](26, 8) NULL ,
	[Amount02] [decimal](26, 8) NULL ,
	[Amount03] [decimal](26, 8) NULL ,
	[Amount04] [decimal](26, 8) NULL ,
	[Amount05] [decimal](26, 8) NULL ,
	[Amount06] [decimal](26, 8) NULL ,
	[Amount07] [decimal](26, 8) NULL ,
	[Amount08] [decimal](26, 8) NULL ,
	[Amount09] [decimal](26, 8) NULL ,
	[Amount10] [decimal](26, 8) NULL ,
	[Amount11] [decimal](26, 8) NULL ,
	[Amount12] [decimal](26, 8) NULL ,
	[Amount13] [decimal](26, 8) NULL ,
	[Amount14] [decimal](26, 8) NULL ,
	[Amount15] [decimal](26, 8) NULL ,
	[Amount16] [decimal](26, 8) NULL ,
	[Amount17] [decimal](26, 8) NULL ,
	[Amount18] [decimal](26, 8) NULL ,
	[Amount19] [decimal](26, 8) NULL ,
	[Amount20] [decimal](26, 8) NULL ,
	[Amount21] [decimal](26, 8) NULL ,
	[Amount22] [decimal](26, 8) NULL ,
	[Amount23] [decimal](26, 8) NULL ,
	[Amount24] [decimal](26, 8) NULL ,
	[Amount25] [decimal](26, 8) NULL ,
	[Amount26] [decimal](26, 8) NULL ,
	[Amount27] [decimal](26, 8) NULL ,
	[Amount28] [decimal](26, 8) NULL ,
	[Amount29] [decimal](26, 8) NULL ,
	[Amount30] [decimal](26, 8) NULL 
) ON [PRIMARY]
else if not exists(select top 1 1 from sys.columns col where col.name = 'DivisionID' and object_id = object_id('[dbo].[OT4444]'))
	ALTER TABLE OT4444 ADD DivisionID nvarchar(50) null;

IF not  exists (Select * From dbo.Sysobjects Where id = object_id(N'[dbo].[OT4445]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
CREATE TABLE [dbo].[OT4445] (
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar] (50)  NULL ,
	[Col01] [nvarchar] (50)  ,
	[Col02] [nvarchar] (50)  ,
	[Col03] [nvarchar] (50) ,
	[Col04] [nvarchar] (50) ,
	[Col05] [nvarchar] (50) ,
	[Col06] [nvarchar] (50) ,
	[Col07] [nvarchar] (50) ,
	[Col08] [nvarchar] (50) ,
	[Col09] [nvarchar] (50) ,
	[Col10] [nvarchar] (50) ,
	[Col11] [nvarchar] (50) ,
	[Col12] [nvarchar] (50) ,
	[Col13] [nvarchar] (50) ,
	[Col14] [nvarchar] (50) ,
	[Col15] [nvarchar] (50) ,
	[Col16] [nvarchar] (50) ,
	[Col17] [nvarchar] (50) ,
	[Col18] [nvarchar] (50) ,
	[Col19] [nvarchar] (50) ,
	[Col20] [nvarchar] (50) ,
	[Col21] [nvarchar] (50) ,
	[Col22] [nvarchar] (50) ,
	[Col23] [nvarchar] (50) ,
	[Col24] [nvarchar] (50) ,
	[Col25] [nvarchar] (50) ,
	[Col26] [nvarchar] (50) ,
	[Col27] [nvarchar] (50) ,
	[Col28] [nvarchar] (50) ,
	[Col29] [nvarchar] (50) ,
	[Col30] [nvarchar] (50) NULL 
) ON [PRIMARY]
else if not exists(select top 1 1 from sys.columns col where col.name = 'DivisionID' and object_id = object_id('[dbo].[OT4445]'))
	ALTER TABLE OT4445 ADD DivisionID nvarchar(50) null;
	
Select @FromPeriod = @FromMonth  + @FromYear*100,	@ToPeriod = @ToMonth  + @ToYear*100, @sWHERE0 = ''
Select @sPeriod0 = '  and V43.TranMonth + V43.TranYear*100 between ' + 
	cast(@FromPeriod as nvarchar(50)) + ' and ' +  cast(@ToPeriod as nvarchar(50)),	
	@sOT4445_VALUE = '', 	 @sOT4445_INSERT = '',  @sSQL = ''

Select @Filter01ID = Filter01ID, @Filter02ID = Filter02ID, @Filter03ID = Filter03ID, @Filter04ID = Filter04ID 
From OT4011 
Where ReportCode = @ReportCode 

---------------------------------------------Loc ----------------------------------------------
If isnull(@Filter01ID, '') <> ''
  Begin
	Exec AP4700	  @Filter01ID, 	@FilterField01ID OUTPUT
	Select @sWHERE0= @sWHERE0+ ' and (V43.' + @FilterField01ID + ' between N''' + @FromValue01ID + ''' and N''' + @ToValue01ID  + ''') '			
  End

If isnull(@Filter02ID, '') <> ''
  Begin
	Exec AP4700	  @Filter02ID, 	@FilterField02ID OUTPUT
	Select @sWHERE0= @sWHERE0+ ' and (V43.' + @FilterField02ID + ' between N''' + @FromValue02ID + ''' and N''' + @ToValue02ID  + ''') '			
  End

If isnull(@Filter03ID, '') <> ''
  Begin
	Exec AP4700	  @Filter03ID, 	@FilterField03ID OUTPUT
	Select @sWHERE0= @sWHERE0+ ' and (V43.' + @FilterField03ID + ' between N''' + @FromValue03ID + ''' and N''' + @ToValue03ID  + ''') '			
  End

If isnull(@Filter04ID, '') <> ''
  Begin
	Exec AP4700	  @Filter04ID, 	@FilterField04ID OUTPUT
	Select @sWHERE0= @sWHERE0+ ' and (V43.' + @FilterField04ID + ' between N''' + @FromValue04ID + ''' and N''' + @ToValue04ID  + ''') '			
  End

------------------------------------------------------------------------------------------------------------------------------	
Exec('DELETE OT4444 where DivisionID = '''+@DivisionID+'''');
Exec('DELETE OT4445 where DivisionID = '''+ @DivisionID +'''');

Set @sSQL = '
INSERT OT4444 (DivisionID,InventoryID, InventoryName, UnitID, UnitName)
	SELECT Distinct V43.DivisionID, V43.InventoryID, V43.InventoryName, V43.UnitID, AT1304.UnitName 
	FROM AT1302  V43  INNER JOIN AT1304 ON V43.UnitID = AT1304.UnitID And V43.DivisionID = AT1304.DivisionID
	Where V43.DivisionID =''' + @DivisionID + ''' And IsStocked = 1 ' + REPLACE(REPLACE( REPLACE(@sWHERE0 , 'V43.CI1ID', 'V43.S1'),
	'V43.CI2ID','V43.S2'), 'V43.CI1ID','V43.S3')

EXEC (@sSQL)

Set @sSQL = '
Select Distinct	OT4012.LineID, OT4012.Code, OT4012.Orders, OT4012.LineDescription, OT4012.Method, OT4012.MonthAmount, 
	OT4012.DataType, OT4012.AmountType, OT4012.IsPast, OT4012.FromAccountID, OT4012.ToAccountID, 
	OT4012.FromCorAccountID, OT4012.ToCorAccountID, OT4012.Sign10,  OT4012.Sign20, OT4012.Col10, 
	(''Amount'' + case when OT4012_11.Orders< 10 then ''0'' else '''' end + cast(OT4012_11.Orders as varchar(10))) as Col11,
	(''Amount'' + case when OT4012_12.Orders< 10 then ''0'' else '''' end + cast(OT4012_12.Orders as varchar(10))) as Col12,
	(''Amount'' + case when OT4012_13.Orders< 10 then ''0'' else '''' end + cast(OT4012_13.Orders as varchar(10))) as Col13,
	(''Amount'' + case when OT4012_14.Orders< 10 then ''0'' else '''' end + cast(OT4012_14.Orders as varchar(10))) as Col14,
	(''Amount'' + case when OT4012_15.Orders< 10 then ''0'' else '''' end + cast(OT4012_15.Orders as varchar(10))) as Col15,
	OT4012.Col20, 
	(''Amount'' + case when OT4012_21.Orders< 10 then ''0'' else '''' end + cast(OT4012_21.Orders as varchar(10))) as Col21,
	(''Amount'' + case when OT4012_22.Orders< 10 then ''0'' else '''' end + cast(OT4012_22.Orders as varchar(10))) as Col22,
	(''Amount'' + case when OT4012_23.Orders< 10 then ''0'' else '''' end + cast(OT4012_23.Orders as varchar(10))) as Col23,
	(''Amount'' + case when OT4012_24.Orders< 10 then ''0'' else '''' end + cast(OT4012_24.Orders as varchar(10))) as Col24,
	(''Amount'' + case when OT4012_25.Orders< 10 then ''0'' else '''' end + cast(OT4012_25.Orders as varchar(10))) as Col25

From OT4012  
	Left join OT4012 OT4012_11 on OT4012_11.Code = OT4012.Col11 And OT4012_11.DivisionID = OT4012.DivisionID
	Left join OT4012 OT4012_12 on OT4012_12.Code = OT4012.Col12 And OT4012_12.DivisionID = OT4012.DivisionID
	Left join OT4012 OT4012_13 on OT4012_13.Code = OT4012.Col13 And OT4012_13.DivisionID = OT4012.DivisionID
	Left join OT4012 OT4012_14 on OT4012_14.Code = OT4012.Col14 And OT4012_14.DivisionID = OT4012.DivisionID
	Left join OT4012 OT4012_15 on OT4012_15.Code = OT4012.Col15 And OT4012_15.DivisionID = OT4012.DivisionID
	Left join OT4012 OT4012_21 on OT4012_21.Code = OT4012.Col21 And OT4012_21.DivisionID = OT4012.DivisionID
	Left join OT4012 OT4012_22 on OT4012_22.Code = OT4012.Col22 And OT4012_22.DivisionID = OT4012.DivisionID
	Left join OT4012 OT4012_23 on OT4012_23.Code = OT4012.Col23 And OT4012_23.DivisionID = OT4012.DivisionID
	Left join OT4012 OT4012_24 on OT4012_24.Code = OT4012.Col24 And OT4012_24.DivisionID = OT4012.DivisionID
	Left join OT4012 OT4012_25 on OT4012_25.Code = OT4012.Col25 And OT4012_25.DivisionID = OT4012.DivisionID
WHERE OT4012.ReportCode  = N''' + @ReportCode + '''' + ' AND OT4012.DivisionID = ''' + @DivisionID + ''''


IF exists (Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'OV4014')
	DROP VIEW OV4014
EXEC('Create view OV4014   ---tao boi OP4011
	as ' + @sSQL)

Set @sWHERE0 =   @sWHERE0 + ' and V43.DivisionID like N'''  + @DivisionID + ''''

Set @cur = CURSOR SCROLL KEYSET FOR
	Select LineID, Code, Orders, LineDescription, isnull(Method, 9), isnull(MonthAmount, 0),
		isnull(DataType,''), isnull(AmountType,''), IsPast, isnull(FromAccountID,''),  isnull(ToAccountID,''),
		 isnull(FromCorAccountID,''), isnull(ToCorAccountID,''), 
		isnull(Sign10,''), isnull(Sign20,''),
		Col10, Col11, Col12, Col13, Col14, Col15, Col20, Col21, Col22, Col23, Col24, Col25
	From OV4014
	Order by Method Desc, Orders

OPEN @cur
FETCH NEXT FROM @cur INTO @LineID, @Code, @Orders, @LineDescription, @Method, @MonthAmount, 
		@DataType, @AmountType, @IsPast, @FromAccountID , @ToAccountID,
		@FromCorAccountID, @ToCorAccountID, 
		@Sign10, @Sign20,
		@Col10, @Col11, @Col12, @Col13, @Col14, @Col15, @Col20, @Col21, @Col22, @Col23, @Col24, @Col25

WHILE @@FETCH_STATUS =  0
BEGIN
Select @sWhere = @sWHERE0, @sFormular = '', @sFROM ='', @sSQL = ''	, @sPeriod = '',
	@sOT4445_VALUE   = @sOT4445_VALUE + 'N''' + @LineDescription + ''',',
	@sOT4445_INSERT = @sOT4445_INSERT + 'Col' +  case when @Orders<10 then '0' else '' end + cast(@Orders as nvarchar(50)) + ','
IF  @Method <> 1
BEGIN	

--------------- Lay caption cua cac cot
Set @sSQL = ''
	IF @IsPast = 1 and @MonthAmount >= 0
		Set @sPeriod =  '  and V43.TranMonth + V43.TranYear*100 between ' + 
			cast(@FromPeriod - @MonthAmount as nvarchar(50)) + ' and ' + 
			cast(@FromPeriod - 1 as nvarchar(50))    
	ELSE 
	IF @MonthAmount > 0 and @IsPast = 1
		Set @sPeriod =  ' and  V43.TranMonth + V43.TranYear*100 between ' + cast(@FromPeriod  as nvarchar(50)) + ' and ' +

			cast(@FromPeriod + @MonthAmount - 1 as nvarchar(50))
	ELSE 

		Set @sPeriod = @sPeriod0

	Set @sWHERE =  @sWHERE + @sPeriod

	------Lay So luong/Thanh tien
	IF @AmountType  = 'AQ' 
		Set @AmountField = 'Quantity'
	ELSE
		Set @AmountField = 'ConvertedAmount'	
	
	--------Cot so lieu
	Set @sWhere = @sWhere + case when   @DataType = 'PC'  then ' and V43.D_C = ''C''' else 
				case when  @DataType = 'PD'  then ' and V43.D_C = ''D''' else 
				case when  @DataType = 'PO'  then ' and V43.Type = ''PO''' else 
	 			case when  @DataType = 'SO'  then ' and V43.Type = ''SO'''
				else ''  end end end end 

	IF @DataType  in ('PC', 'PD') 	
	BEGIN		
		-----Kiem tra tai khoan, va tai khoan doi ung
		IF isnull(@FromAccountID, '') <> '' and  @FromAccountID <> '%' 
			Set @sWhere = @sWhere + ' and (V43.AccountID between N''' + @FromAccountID + ''' and N''' + @ToAccountID + ''') '   	

		IF isnull(@FromCorAccountID, '') <> '' and  @FromCorAccountID <> '%' 				
			Set @sWhere = @sWhere + ' and (V43.CorAccountID between N''' + @FromCorAccountID + ''' and N''' + @ToCorAccountID + ''') '   						
		Set @sFROM = '  AV4301 '
	END

	---------------------------------Lay so lieu tu don hang
	IF @DataType in ('SO', 'PO') 
	BEGIN
		Set @sFrom = '  OV2600 '
	END
	ELSE 
	IF @DataType = 'PE'  -------Ton kho thuc te 
	BEGIN		
		IF @AmountType  = 'AQ' 
			Set @AmountField = 'EndQuantity'
	ELSE
		Set @AmountField = 'EndAmount'	
	END 


Set @sWHERE = RIGHT(@sWHERE, LEN(@sWHERE) - 4)

	IF @DataType = 'PP'  ------Gia von 
		Set @sSQL = '
		Update  OT4444 Set Amount' + case when @Orders < 10 then '0' else '' end + 
			cast(@Orders as varchar(10)) + ' = V43.Amount
			From OT4444  inner join (Select V43.DivisionID, TranMonth, TranYear,   AT2008.InventoryID,  
				sum(isnull(DebitAmount,0))/ case when sum(isnull(DebitQuantity,0))  = 0 then 1 else sum(isnull(DebitQuantity,0)) end  as Amount,
				S1 as CI1ID, S2 as CI2ID, S3 as CI3ID,   I01ID, I02ID, I03ID, I04ID, I05ID
				From AT2008  inner join AT1302 V43 on AT2008.InventoryID  = V43.InventoryID And AT2008.DivisionID = V43.DivisionID
				Group by V43.DivisionID, TranMonth, TranYear,   AT2008.InventoryID,  			
				S1, S2, S3,   I01ID, I02ID, I03ID, I04ID, I05ID) 
			V43 on V43.InventoryID = OT4444.InventoryID And V43.DivisionID = OT4444.DivisionID
			Where OT4444.DivisionID = ''' + @DivisionID +''' And ' + @sWhere         		
	ELSE
	IF @DataType = 'PE' --ton kho TT
	Set @sSQL = '
		Update  OT4444 Set Amount' + case when @Orders < 10 then '0' else '' end + 
			cast(@Orders as varchar(10)) + ' = V43.Amount
			From OT4444  inner join (Select V43.DivisionID, TranMonth, TranYear,   AT2008.InventoryID, sum(isnull( ' + 
				@AmountField + ',0)) as Amount,
				S1 as CI1ID, S2 as CI2ID, S3 as CI3ID,   I01ID, I02ID, I03ID, I04ID, I05ID
				From AT2008  inner join AT1302 V43 on AT2008.InventoryID  = V43.InventoryID And AT2008.DivisionID = V43.DivisionID
				Group by V43.DivisionID, TranMonth, TranYear,   AT2008.InventoryID,  			
				S1, S2, S3,   I01ID, I02ID, I03ID, I04ID, I05ID) 
			V43 on V43.InventoryID = OT4444.InventoryID And V43.DivisionID = OT4444.DivisionID
			Where OT4444.DivisionID = ''' + @DivisionID +''' And ' + @sWhere         		      	
	ELSE  
	Set @sSQL = '
		Update  OT4444 Set Amount' + case when @Orders < 10 then '0' else '' end + 
		cast(@Orders as varchar(10)) + ' = V43.Amount
		From OT4444  inner join ( 
		Select InventoryID, sum(isnull(' + @AmountField + ',0)) as Amount 
		From ' + @sFROM + ' V43
		Where ' +@sWHERE + ' And DivisionID = ''' + @DivisionID + '''
		Group by InventoryID) V43 on V43.InventoryID = OT4444.InventoryID'	
END
ELSE  ---Tinh toan
BEGIN
	IF isnull(@Sign10, '') <> '' and @Sign10 <> '/'
		Set @sFormular = @sFormular + '((' +  case when isnull(@Col11, '') <> '' then 'isnull(' + @Col11+ ',0) ' else '' end + 
			case when isnull(@Col12, '') <> '' then @Sign10 + 'isnull(' + @Col12 + ',0) ' else '' end + 
			case when isnull(@Col13, '') <> '' then @Sign10 + 'isnull(' + @Col13 + ',0) '  else '' end + 
			case when isnull(@Col14, '') <> '' then @Sign10 + 'isnull(' + @Col14 + ',0) ' else '' end + 
			case when isnull(@Col15, '') <> '' then @Sign10 + 'isnull(' + @Col15 + ',0) ' else '' end + 
			case when isnull(@Col10, 0) <> 0 then @Sign10 + CAST(@Col10  AS VARCHAR(30))  else '' end + '))' 
			
	ELSE
	IF isnull(@Sign10, '') <> '' and @Sign10 = '/'
	Set @sFormular = @sFormular +  case when  isnull(@Col11,'') <> '' and (isnull(@Col12, '') <> '' or  isnull(@Col10, 0) <> 0)
			then ( '( case when ' + 
			case when isnull(@Col12, '') <> '' then '+ isnull(' + @Col12 + ',0)' else '' end + 
			case when isnull(@Col13, '') <> '' then '+ isnull(' + @Col13 + ',0)' else '' end + 
			case when isnull(@Col14, '') <> '' then '+ isnull(' + @Col14 + ',0)' else '' end + 
			case when isnull(@Col15, '') <> '' then '+ isnull(' + @Col15 + ',0)' else '' end +
			case when isnull(@Col10, 0) <> 0  then '+ ' + CAST(@Col10 AS VARCHAR(30))  else '' end +
			 ' <> 0 then  ' + 
			case when isnull(@Col11, '') <> '' then 'isnull(' + @Col11 + ',0) ' else '' end + 
			@Sign10 + '(' +
			case when isnull(@Col12, '') <> '' then '+ isnull(' + @Col12 + ',0)' else '' end + 
			case when isnull(@Col13, '') <> '' then '+ isnull(' + @Col13 + ',0)' else '' end + 
 			case when isnull(@Col14, '') <> '' then '+ isnull(' + @Col14 + ',0)' else '' end + 
			case when isnull(@Col15, '') <> '' then '+ isnull(' + @Col15 + ',0)' else '' end +
			case when isnull(@Col10, 0) <> 0  then '+ ' + CAST(@Col10 AS VARCHAR(30))  else '' end + ')'   + 
			' else 0 end) ')  else ' ' end   

	IF isnull(@Sign20, '') <> '' and @Sign20 <> '/' 
		Set @sFormular =  @sFormular +case when isnull(@Sign10, '') <> '' then @Sign20  else '' end + 
			'((' +  case when isnull(@Col21, '') <> '' then 'isnull(' + @Col21+',0) '  else '' end + 
			case when isnull(@Col22, '') <> '' then  @Sign20 + ' isnull(' + @Col22 + ',0) ' else '' end + 
			case when isnull(@Col23, '') <> '' then @Sign20 + ' insull(' + @Col23 + ',0) ' else '' end + 
			case when isnull(@Col24, '') <> '' then @Sign20 + ' isnull(' + @Col24 + ',0) ' else '' end + 
			case when isnull(@Col25, '') <> '' then @Sign20 + ' isnull(' + @Col25 +',0) ' else '' end + 
			case when isnull(@Col20, 0) <> 0 then @Sign10 + CAST(@Col20  AS VARCHAR(30))  else '' end + '))' 
			
	ELSE
	IF isnull(@Sign20, '') <> '' and @Sign20 = '/'
		Set @sFormular = @sFormular +  case when  isnull(@Col21,'') <> '' and (isnull(@Col22, '') <> '' or  isnull(@Col20, 0) <> 0)
			then ( '( case when ' + 
			case when isnull(@Col22, '') <> '' then '+ isnull(' + @Col22 + ',0)' else '' end + 
			case when isnull(@Col23, '') <> '' then '+ isnull(' + @Col23 + ',0)' else '' end + 
			case when isnull(@Col24, '') <> '' then '+ isnull(' + @Col24 + ',0)' else '' end + 
			case when isnull(@Col25, '') <> '' then '+ isnull(' + @Col25 + ',0)' else '' end +
			case when isnull(@Col20, 0) <> 0  then '+ ' + CAST(@Col20 AS VARCHAR(30))  else '' end +
			 ' <> 0 then  ' + 
			case when isnull(@Col21, '') <> '' then 'isnull(' + @Col21 + ',0) ' else '' end + 
			@Sign20 + '(' +
			case when isnull(@Col22, '') <> '' then '+ isnull(' + @Col22 + ',0)' else '' end + 
			case when isnull(@Col23, '') <> '' then '+ isnull(' + @Col23 + ',0)' else '' end + 
 			case when isnull(@Col24, '') <> '' then '+ isnull(' + @Col24 + ',0)' else '' end + 
			case when isnull(@Col25, '') <> '' then '+ isnull(' + @Col25 + ',0)' else '' end +
			case when isnull(@Col20, 0) <> 0  then '+ ' + CAST(@Col20 AS VARCHAR(30))  else '' end + ')'   + 
			' else 0 end) ')  else ' ' end   
	Set @sSQL = '
		Update  OT4444 Set Amount' + case when @Orders < 10 then '0' else '' end + 
			cast(@Orders as varchar(10)) + ' = ' + @sFormular + '
			Where DivisionID = ''' + @DivisionID + ''''

END		
EXEC(@sSQL)

FETCH NEXT FROM @cur INTO @LineID, @Code, @Orders, @LineDescription, @Method, @MonthAmount, 
	@DataType, @AmountType, @IsPast, @FromAccountID, @ToAccountID, @FromCorAccountID, @ToCorAccountID, 
	@Sign10, @Sign20,
	@Col10, @Col11, @Col12, @Col13, @Col14, @Col15, @Col20, @Col21, @Col22, @Col23, @Col24, @Col25			
END


Set @sOT4445_INSERT = 'INSERT OT4445 (DivisionID,'  + LEFT(@sOT4445_INSERT, LEN(@sOT4445_INSERT)-1) + ') VALUES (''' + @DivisionID + ''',' +
	LEFT(@sOT4445_VALUE, LEN(@sOT4445_VALUE)-1)  +')'

Exec('
DELETE OT4444 
WHERE DivisionID = ''' + @DivisionID + '''
And abs(isnull(Amount01, 0)) + abs(isnull(Amount02, 0)) + abs(isnull(Amount03, 0)) + abs(isnull(Amount04, 0)) + abs(isnull(Amount05, 0)) + 
	abs(isnull(Amount06, 0)) + abs(isnull(Amount07, 0)) + abs(isnull(Amount08, 0)) + abs(isnull(Amount09, 0)) + abs(isnull(Amount10, 0)) + 
	abs(isnull(Amount11, 0)) + abs(isnull(Amount12, 0)) + abs(isnull(Amount13, 0)) + abs(isnull(Amount14, 0)) + abs(isnull(Amount15, 0)) + 
	abs(isnull(Amount16, 0)) + abs(isnull(Amount17, 0)) + abs(isnull(Amount18, 0)) + abs(isnull(Amount19, 0)) + abs(isnull(Amount20, 0)) + 
	abs(isnull(Amount21, 0)) + abs(isnull(Amount22, 0)) + abs(isnull(Amount23, 0)) + abs(isnull(Amount24, 0)) + abs(isnull(Amount25, 0)) + 
	abs(isnull(Amount26, 0)) + abs(isnull(Amount27, 0)) + abs(isnull(Amount28, 0)) + abs(isnull(Amount29, 0)) + abs(isnull(Amount30, 0)) = 0
	');

Exec('
Update OT4444 Set 
		 Amount01 = case when Amount01 = 0 then NULL else Amount01 end,
		 Amount02 = case when Amount02 = 0 then NULL else Amount02 end,    
		 Amount03 = case when Amount03 = 0 then NULL else Amount03 end,   
		 Amount04 = case when Amount04 = 0 then NULL else Amount04 end,    
		 Amount05 = case when Amount05 = 0 then NULL else Amount05 end,    
		 Amount06 = case when Amount06 = 0 then NULL else Amount06 end,    
		 Amount07 = case when Amount07 = 0 then NULL else Amount07 end,    
		 Amount08 = case when Amount08 = 0 then NULL else Amount08 end,    
		 Amount09 = case when Amount09 = 0 then NULL else Amount09 end,    
		 Amount10 = case when Amount10 = 0 then NULL else Amount10 end,    
		 Amount11 = case when Amount11 = 0 then NULL else Amount11 end,
		 Amount12 = case when Amount12 = 0 then NULL else Amount12 end,    
		 Amount13 = case when Amount13 = 0 then NULL else Amount13 end,   
		 Amount14 = case when Amount14 = 0 then NULL else Amount14 end,    
		 Amount15 = case when Amount15 = 0 then NULL else Amount15 end,    
		 Amount16 = case when Amount16 = 0 then NULL else Amount16 end,    
		 Amount17 = case when Amount17 = 0 then NULL else Amount17 end,    
		 Amount18 = case when Amount18 = 0 then NULL else Amount18 end,    
		 Amount19 = case when Amount19 = 0 then NULL else Amount19 end,    
		 Amount20 = case when Amount20 = 0 then NULL else Amount20 end,
		 Amount21 = case when Amount21 = 0 then NULL else Amount21 end,
		 Amount22 = case when Amount22 = 0 then NULL else Amount22 end,    
		 Amount23 = case when Amount23 = 0 then NULL else Amount23 end,   
		 Amount24 = case when Amount24 = 0 then NULL else Amount24 end,    
		 Amount25 = case when Amount25 = 0 then NULL else Amount25 end,    
		 Amount26 = case when Amount26 = 0 then NULL else Amount26 end,    
		 Amount27 = case when Amount27 = 0 then NULL else Amount27 end,    
		 Amount28 = case when Amount28 = 0 then NULL else Amount28 end,    
		 Amount29 = case when Amount29 = 0 then NULL else Amount29 end,    
		 Amount30 = case when Amount30 = 0 then NULL else Amount30 end
Where DivisionID = ''' + @DivisionID + ''';
');
EXEC(@sOT4445_INSERT)
