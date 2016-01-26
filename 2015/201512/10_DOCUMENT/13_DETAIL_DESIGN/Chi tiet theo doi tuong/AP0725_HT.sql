IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0725_HT]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0725_HT]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Created by Tieu Mai, on 09/11/2015
---- Purpose: In bao cao chi tiet nhap xuat ton theo doi tuong + theo quy cach hang hoa.
----- Modified On 25/01/2016 by Thị Phượng In báo cáo chi tiết theo đối tượng Customize Hoàng Trần
-- <Example>
---- EXEC AP0725 'AS', '','','','','', 10,2015,10,2015, '','', 1

CREATE PROCEDURE [dbo].[AP0725_HT] 		
			@DivisionID as nvarchar(50),					
			@WareHouseID  as nvarchar(50),					
			@FromObjectID  as nvarchar(50),
			@ToObjectID as nvarchar(50),
			@FromInventoryID as nvarchar(50),
			@ToInventoryID as nvarchar(50),
			@IsBottle as tinyint,
			@FromMonth as int,
			@FromYear as int,
			@ToMonth as int,
			@ToYear as int,
			@FromDate as Datetime,
			@ToDate as Datetime,
			@IsDate as tinyint,
			@FromAna01ID nvarchar(50), @ToAna01ID nvarchar(50),
			@FromAna02ID nvarchar(50), @ToAna02ID nvarchar(50),
			@FromAna03ID nvarchar(50), @ToAna03ID nvarchar(50),
			@FromAna04ID nvarchar(50), @ToAna04ID nvarchar(50),
			@FromAna05ID nvarchar(50), @ToAna05ID nvarchar(50),
			@FromAna06ID nvarchar(50), @ToAna06ID nvarchar(50),
			@FromAna07ID nvarchar(50), @ToAna07ID nvarchar(50),
			@FromAna08ID nvarchar(50), @ToAna08ID nvarchar(50),
			@FromAna09ID nvarchar(50), @ToAna09ID nvarchar(50),
			@FromAna10ID nvarchar(50), @ToAna10ID nvarchar(50),
			@FromO05ID   nvarchar(50), @ToO05ID nvarchar(50)
AS
Declare 
--@sSQL as nvarchar(4000),
	@sqlSelect as nvarchar(MAX),
    @sqlFrom as nvarchar(MAX),
    @sqlWhere as nvarchar(MAX),
    @sqlGroupBy as nvarchar(MAX),
	@WareHouseName as nvarchar(250),
	@WareHouseID2 as nvarchar(50),
	@strTime as nvarchar(4000),
	@OWhere as nvarchar(MAX),
	@AnaWhere as nvarchar(MAX), 
    @FromMonthYearText NVARCHAR(20), 
    @ToMonthYearText NVARCHAR(20), 
    @FromDateText NVARCHAR(20), 
    @ToDateText NVARCHAR(20),
    @WareHouseWhere NVARCHAR(250)
    
SET @FromMonthYearText = STR(@FromMonth + @FromYear * 100)
SET @ToMonthYearText = STR(@ToMonth + @ToYear * 100)
SET @FromDateText = CONVERT(NVARCHAR(20), @FromDate, 101)
SET @ToDateText = CONVERT(NVARCHAR(20), @ToDate, 101) + ' 23:59:59'

SET @AnaWhere = ''
SET @WareHouseWhere = ''

--------->>>> Lấy dữ liệu Hàng tồn kho
DECLARE @IsTime AS TINYINT
IF @IsDate = 0 SET @IsTime = 1
IF @IsDate = 1	SET @IsTime = 2

EXEC AP7000 @DivisionID , @UserID, @WareHouseID, @WareHouseID, @FromInventoryID, @ToInventoryID, @FromObjectID, @ToObjectID,
			@IsTime, @FromMonth, @FromYear, @ToMonth, @ToYear, @FromDate, @ToDate

-------- Trả ra AV7008
-------- Thay thế cho AV7000
---------<<<< Lấy dữ liệu Hàng tồn kho

	If Patindex('[%]',@FromAna01ID) > 0
		Begin
			Set @AnaWhere = @AnaWhere + N' And AV7008.Ana01ID Like N''' + @FromAna01ID + ''''
		End
	Else
		If @FromAna01ID is not null  And  @FromAna01ID <>''
			Begin
				Set @AnaWhere = @AnaWhere + N' And Isnull(AV7008.Ana01ID,'''') >= N''' + Replace(@FromAna01ID,'[]','') + ''' And Isnull(AV7008.Ana01ID,'''') <= N''' + Replace(@ToAna01ID,'[]','') + ''''
			End	

	If Patindex('[%]',@FromAna02ID) > 0
		Begin
			Set @AnaWhere = @AnaWhere + N' And AV7008.Ana02ID Like N''' + @FromAna02ID + ''''
		End
	Else
		If @FromAna02ID is not null  And @FromAna02ID <>''
			Begin
				Set @AnaWhere = @AnaWhere + N' And Isnull(AV7008.Ana02ID,'''') >= N''' + Replace(@FromAna02ID,'[]','') + ''' And Isnull(AV7008.Ana02ID,'''') <= N''' + Replace(@ToAna02ID,'[]','') + ''''
			End	

	If Patindex('[%]',@FromAna03ID) > 0
		Begin
			Set @AnaWhere = @AnaWhere + N' And AV7008.Ana03ID Like N''' + @FromAna03ID + ''''
		End
	Else
		If @FromAna03ID is not null  And @FromAna03ID <>''
			Begin
				Set @AnaWhere = @AnaWhere + N' And Isnull(AV7008.Ana03ID,'''') >= N''' + Replace(@FromAna03ID,'[]','') + ''' And Isnull(AV7008.Ana03ID,'''') <= N''' + Replace(@ToAna03ID,'[]','') + ''''
			End	

	If Patindex('[%]',@FromAna04ID) > 0
		Begin
			Set @AnaWhere = @AnaWhere + N' And AV7008.Ana04ID Like N''' + @FromAna04ID + ''''
		End
	Else 
		If @FromAna04ID is not null  And @FromAna04ID <>''
			Begin
				Set @AnaWhere = @AnaWhere + N' And Isnull(AV7008.Ana04ID,'''') >= N''' + Replace(@FromAna04ID,'[]','') + ''' And Isnull(AV7008.Ana04ID,'''') <= N''' + Replace(@ToAna04ID,'[]','') + ''''
			End	

	If Patindex('[%]',@FromAna05ID) > 0
		Begin
			Set @AnaWhere = @AnaWhere + N' And AV7008.Ana05ID Like N''' + @FromAna05ID + ''''
		End
	Else
		If @FromAna05ID is not null  And @FromAna05ID <>''
			Begin
				Set @AnaWhere = @AnaWhere + N' And Isnull(AV7008.Ana05ID,'''') >= N''' + Replace(@FromAna05ID,'[]','') + ''' And Isnull(AV7008.Ana05ID,'''') <= N''' + Replace(@ToAna05ID,'[]','') + ''''
			End
			
	If Patindex('[%]',@FromAna06ID) > 0
		Begin
			Set @AnaWhere = @AnaWhere + N' And AV7008.Ana06ID Like N''' + @FromAna06ID + ''''
		End
	Else
		If @FromAna06ID is not null  And  @FromAna06ID <>''
			Begin
				Set @AnaWhere = @AnaWhere + N' And Isnull(AV7008.Ana06ID,'''') >= N''' + Replace(@FromAna06ID,'[]','') + ''' And Isnull(AV7008.Ana06ID,'''') <= N''' + Replace(@ToAna06ID,'[]','') + ''''
			End	

	If Patindex('[%]',@FromAna07ID) > 0
		Begin
			Set @AnaWhere = @AnaWhere + N' And AV7008.Ana07ID Like N''' + @FromAna07ID + ''''
		End
	Else
		If @FromAna07ID is not null  And @FromAna07ID <>''
			Begin
				Set @AnaWhere = @AnaWhere + N' And Isnull(AV7008.Ana07ID,'''') >= N''' + Replace(@FromAna07ID,'[]','') + ''' And Isnull(AV7008.Ana07ID,'''') <= N''' + Replace(@ToAna07ID,'[]','') + ''''
			End	

	If Patindex('[%]',@FromAna08ID) > 0
		Begin
			Set @AnaWhere = @AnaWhere + N' And AV7008.Ana08ID Like N''' + @FromAna08ID + ''''
		End
	Else
		If @FromAna08ID is not null  And @FromAna08ID <>''
			Begin
				Set @AnaWhere = @AnaWhere + N' And Isnull(AV7008.Ana08ID,'''') >= N''' + Replace(@FromAna08ID,'[]','') + ''' And Isnull(AV7008.Ana08ID,'''') <= N''' + Replace(@ToAna08ID,'[]','') + ''''
			End	

	If Patindex('[%]',@FromAna09ID) > 0
		Begin
			Set @AnaWhere = @AnaWhere + N' And AV7008.Ana09ID Like N''' + @FromAna09ID + ''''
		End
	Else 
		If @FromAna09ID is not null  And @FromAna09ID <>''
			Begin
				Set @AnaWhere = @AnaWhere + N' And Isnull(AV7008.Ana09ID,'''') >= N''' + Replace(@FromAna09ID,'[]','') + ''' And Isnull(AV7008.Ana09ID,'''') <= N''' + Replace(@ToAna09ID,'[]','') + ''''
			End	

	If Patindex('[%]',@FromAna10ID) > 0
		Begin
			Set @AnaWhere = @AnaWhere + N' And AV7008.Ana10ID Like N''' + @FromAna10ID + ''''
		End
	Else
		If @FromAna10ID is not null  And @FromAna10ID <>''
			Begin
				Set @AnaWhere = @AnaWhere + N' And Isnull(AV7008.Ana10ID,'''') >= N''' + Replace(@FromAna10ID,'[]','') + ''' And Isnull(AV7008.Ana10ID,'''') <= N''' + Replace(@ToAna10ID,'[]','') + ''''
			End

	If @WareHouseID ='%'
		begin
			Set @WareHouseName = 'N''Tất cả'''
			Set @WareHouseID2  = 'N''%'''
			SET @WareHouseWhere = N' ISNULL(AV7008.IsTemp,0) = 0 AND '
		End
	Else
		begin
			Set @WareHouseName = 'AV7008.WareHouseName'
			Set @WareHouseID2  = 'AV7008.WareHouseID'
			SET @WareHouseWhere = N' '
		end
---Mã phân tích theo đối tượng
SET @OWhere = ''
IF PATINDEX('[%]', @FromO05ID) > 0
BEGIN
    SET @OWhere = @OWhere + ' And AV7008.O05ID Like N''' + @FromO05ID + ''''
END
ELSE
	IF @FromO05ID IS NOT NULL AND @FromO05ID <> ''
	BEGIN
		SET @OWhere = @OWhere + ' And Isnull(AV7008.O05ID,'''') >= N''' + REPLACE(@FromO05ID, '[]', '') + 
									''' And Isnull(AV7008.O05ID,'''') <= N''' + REPLACE(@ToO05ID, '[]', '') + ''''
	END 
--Theo dõi vỏ

IF @IsBottle = 1
   SET @OWhere = @OWhere +''---' and isnull(AV7008.IsBottle,0)  ='  +  @IsBottle
IF @IsDate = 1    ---- xac dinh so lieu theo ngay
	  Set @strTime =N' and (  D_C=''BD''   or AV7008.VoucherDate < ''' + @FromDateText +N''') ' 
Else 
	Set @strTime =N' and ( D_C=''BD'' or AV7008.TranMonth+ 100*TranYear< '+@FromMonthYearText+N' ) ' ---06/01/2014MTuyen edit

Set @sqlSelect = N' 
SELECT 	' + @WareHouseID2 + N' as WareHouseID ,
		' + @WareHouseName + N' as WareHouseName,
		AV7008.ObjectID,  
		AV7008.InventoryID,	 AV7008.InventoryName, 
		AV7008.UnitID,		 AV7008.S1, 	 AV7008.S2, 	 AV7008.S3, 	 
		AV7008.I01ID, 	 AV7008.I02ID, 	 AV7008.I03ID, 	 AV7008.I04ID, 	 AV7008.I05ID, 	 AV7008.UnitName,
		AV7008.Specification ,	AV7008.Notes01 , AV7008.Notes02 , AV7008.Notes03 ,
		sum(isnull(SignQuantity,0))  as BeginQuantity,
		sum(isnull(SignAmount,0)) as BeginAmount, AV7008.DivisionID,
		(isnull(AV7008.IsBottle,0)) as IsBottle, AV7008.O05ID'
Set @sqlFrom = N'
FROM	AV7008  '
Set @sqlWhere = N'
WHERE 	'+@WareHouseWhere+'
		AV7008.DivisionID like N'''+@DivisionID+N''' and
		D_C in (''D'',''C'', ''BD'' ) and
		(AV7008.O05ID between N'''+@FromO05ID+N''' and N'''+@ToO05ID+N''') and
		
		(AV7008.ObjectID between  N'''+@FromObjectID+N''' and  N'''+@ToObjectID+N''')  ' + @OWhere + N' ' 
set @sqlWhere = @sqlWhere + @strTime+' '

IF @WareHouseID <>'%'	
Set @sqlGroupBy = N' 
GROUP BY  AV7008.DivisionID,  ' + @WareHouseID2 + '  ,' + @WareHouseName + N',  
		AV7008.ObjectID, AV7008.InventoryID,	 AV7008.InventoryName,	  AV7008.UnitID,
		AV7008.S1, 	 AV7008.S2, 	 AV7008.S3, 	 
		AV7008.I01ID, 	 AV7008.I02ID, 	 AV7008.I03ID, 	 AV7008.I04ID, 	 AV7008.I05ID, 
		AV7008.UnitName , AV7008.Specification ,	
		AV7008.Notes01 , AV7008.Notes02 , AV7008.Notes03,
		isnull(AV7008.IsBottle,0), AV7008.O05ID
 '
Else
Set @sqlGroupBy = N' 
GROUP BY  AV7008.DivisionID,  AV7008.ObjectID,   AV7008.InventoryID,	 AV7008.InventoryName,	  AV7008.UnitID,
		AV7008.S1, 	 AV7008.S2, 	 AV7008.S3, 	 AV7008.I01ID, 	 AV7008.I02ID, 	 AV7008.I03ID, 	 AV7008.I04ID, 	 AV7008.I05ID, 
		AV7008.UnitName, AV7008.Specification ,	AV7008.Notes01 , AV7008.Notes02 , AV7008.Notes03,
		(isnull(AV7008.IsBottle,0)), AV7008.O05ID  '


IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE XTYPE ='V' AND NAME = 'AV0728')
   	EXEC ('CREATE VIEW AV0728 AS '+@sqlSelect + @sqlFrom + @sqlWhere + @sqlGroupBy)
ELSE
	EXEC('  ALTER VIEW  AV0728 AS '+ @sqlSelect + @sqlFrom + @sqlWhere + @sqlGroupBy)

-------- Lay tong so du 
Set @sqlSelect=N'
SELECT 	AV0728.ObjectID,
		AT1202.ObjectName,
		AT1202.O05ID,
		AT1202.Address, 
		WareHouseID ,
		WareHouseName,
		InventoryID,	
		InventoryName, 
		UnitID,		 
		AV0728.S1, AV0728.S2, AV0728.S3 ,  I01ID, I02ID, I03ID, I04ID, I05ID, UnitName,
		AV0728.Specification ,	AV0728.Notes01 , AV0728.Notes02 , AV0728.Notes03 ,
		sum(isnull(BeginQuantity,0))  as BeginQuantity ,
		sum(isnull( BeginAmount ,0)) as BeginAmount,
		AV0728.DivisionID,
	    (isnull(AV0728.IsBottle,0)) as IsBottle
'
set @sqlFrom = N'
FROM AV0728 
LEFT JOIN AT1202 on AT1202.ObjectID = AV0728.ObjectID and AT1202.DivisionID = AV0728.DivisionID '

set @sqlWhere = N''

set @sqlGroupBy = N'
GROUP BY AV0728.ObjectID, AT1202.ObjectName,	 
		AT1202.O05ID,
		AT1202.Address,  InventoryID,	 InventoryName,	 
		UnitID, AV0728.S1, AV0728.S2, AV0728.S3 , I01ID,I02ID,I03ID, I04ID, I05ID, 
		UnitName , AV0728.Specification ,
		AV0728.Notes01 , AV0728.Notes02 , AV0728.Notes03 ,
		WareHouseID ,WareHouseName, AV0728.DivisionID,
		(isnull(AV0728.IsBottle,0))'

--Print @sSQL

IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE XTYPE ='V' AND NAME = 'AV0729')
	EXEC ('CREATE VIEW AV0729 -- Tạo bởi AP0725
	        as '+@sqlSelect + @sqlFrom + @sqlWhere + @sqlGroupBy)
ELSE
	EXEC('  ALTER VIEW  AV0729 -- Tạo bởi AP0725
	        as '+ @sqlSelect + @sqlFrom + @sqlWhere + @sqlGroupBy)

------------------------------ KET HOP VOI SO  PHAT SINH


IF @IsDate = 1    ---- xac dinh so lieu theo ngay
	  Set @strTime =N' And (AV7008.VoucherDate  >=  CASE WHEN AV7008.D_C in (''D'', ''C'') Then ''' + @FromDateText +N''' Else AV7008.VoucherDate End)  And (AV7008.VoucherDate  <=  CASE WHEN AV7008.D_C in (''D'', ''C'') Then ''' + Convert(varchar(10),@TODate,101) +N'''  Else AV7008.VoucherDate End) ' --- MTuyen edit
Else 
	Set @strTime =N' And (AV7008.TranMonth+ 100*AV7008.TranYear >= CASE WHEN AV7008.D_C in (''D'', ''C'') Then  '+@FromMonthYearText+N' Else AV7008.TranMonth+ 100*AV7008.TranYear End) And  (AV7008.TranMonth+ 100*AV7008.TranYear <= CASE WHEN AV7008.D_C in (''D'', ''C'') Then '+@ToMonthYearText+N' Else AV7008.TranMonth+ 100*AV7008.TranYear End) ' --- My Tuyen edit


SET @sqlSelect = N'
SELECT
	AV7008.VoucherID,
	isnull( AV0729.ObjectID,	AV7008.ObjectID) as ObjectID, 
	AT1202.S1 As OS1, AT1202.S2 As OS2, AT1202.S3 As OS3, 
	O1.SName As OS1Name, O2.SName As OS2Name, O3.SName As OS3Name, 
	isnull(AV0729.ObjectName,AV7008.ObjectName) as ObjectName, 
	isnull(AV7008.O05ID, AV0729.O05ID) as O05ID,
	O5.AnaName,
	isnull(AV0729.Address, AV7008.Address) as Address, 
	AV7008.InventoryID,
	AV7008.InventoryName,
	AT1302.VATGroupID, 
	AT1302.VATPercent, 
	AV7008.UnitID,
	AT1309.UnitID As ConversionUnitID,
	AT1309.ConversionFactor As ConversionFactor,
	AT1309.Operator,
	AV7008.DebitAccountID, AV7008.CreditAccountID,
	AV7008.VoucherDate, AV7008.VoucherNo, AV7008.VoucherTypeID,
	AV7008.RefNo01, AV7008.RefNo02, AV7008.Notes,
	AV7008.S1, AV7008.S2, AV7008.S3, 
	AV7008.S1Name, AV7008.S2Name, AV7008.S3Name, 
	AV7008.I01ID, AV7008.I02ID, AV7008.I03ID, AV7008.I04ID, AV7008.I05ID, 
	AV7008.InAnaName1, AV7008.InAnaName2, AV7008.InAnaName3, AV7008.InAnaName4, AV7008.InAnaName5, 
	AV7008.UnitName, AV7008.Specification , AV7008.Notes01 , AV7008.Notes02 , AV7008.Notes03 ,
	AV7008.SourceNo,
	isnull(AV0729.BeginQuantity,0) as BeginQuantity,
	isnull(AV0729.BeginAmount,0) as BeginAmount,
	CASE WHEN D_C = ''D'' then isnull(AV7008.ActualQuantity,0) else 0 end as DebitQuantity,
	CASE WHEN D_C = ''C'' then isnull(AV7008.ActualQuantity,0) else 0 end as CreditQuantity,
        CASE WHEN D_C = ''C'' and AV7008.Ana04ID=''CXH'' then isnull(AV7008.ActualQuantity,0) else 0 end as CreditQuantityNo, 
	CASE WHEN D_C = ''D'' then isnull(AV7008.ConvertedAmount,0) else 0 end as DebitAmount,
	CASE WHEN D_C = ''C'' then isnull(AV7008.ConvertedAmount,0) else 0 end as CreditAmount,
	(isnull(AV0729.BeginQuantity,0) + Sum(CASE WHEN D_C = ''D'' then isnull(AV7008.ActualQuantity,0) else 0 end) -   Sum(CASE WHEN D_C = ''C'' then isnull(AV7008.ActualQuantity,0) else 0 end)  ) as  EndQuantity,
	(isnull(AV0729.BeginAmount,0)+Sum(CASE WHEN D_C = ''D'' then isnull(AV7008.ConvertedAmount,0) else 0 end)  -  Sum(CASE WHEN D_C = ''C'' then isnull(AV7008.ConvertedAmount,0) else 0 end)  ) as EndAmount,
	AV7008.DivisionID, AV7008.ProductID, AV7008.MOrderID, AV7008.ProductName,
	AV7008.VoucherDesc, 
	AV7008.Ana01ID,AV7008.Ana02ID,AV7008.Ana03ID,AV7008.Ana04ID,AV7008.Ana05ID,
	AV7008.Ana06ID,AV7008.Ana07ID,AV7008.Ana08ID,AV7008.Ana09ID,AV7008.Ana10ID,
	AV7008.Ana01Name,AV7008.Ana02Name,AV7008.Ana03Name,AV7008.Ana04Name,AV7008.Ana05Name,
	AV7008.Ana06Name,AV7008.Ana07Name,AV7008.Ana08Name,AV7008.Ana09Name,AV7008.Ana10Name,
	AV7008.LimitDate, AV7008.RevoucherDate, AV7008.WareHouseID, AV7008.WarehouseName, AT9000.VoucherNo  as BHVoucherNo, AT9000.VoucherDate as BHVoucherDate, AT9000.TDescription,  ---  06/01/2014MTuyen add new
	AT9000.InvoiceNo, AT1011.AnaName as Sale,
	isnull(AV0729.IsBottle, AV7008.IsBottle) as IsBottle
	'
set @sqlFrom = N'
FROM AV7008 
LEFT JOIN AV0729 on ( AV0729.InventoryID = AV7008.InventoryID) and (AV0729.ObjectID = AV7008.ObjectID) and (AV0729.DivisionID = AV7008.DivisionID) AND
					Isnull(AV7008.O05ID,'''') = Isnull(AV0729.O05ID,'''')
LEFT JOIN (Select InventoryID,Min(UnitID) As UnitID, Min(ConversionFactor) As ConversionFactor, Min(Operator) As Operator, DivisionID From AT1309 Group By InventoryID, DivisionID) AT1309 On AV7008.InventoryID = AT1309.InventoryID and AV7008.DivisionID = AT1309.DivisionID
LEFT JOIN AT1015 O5 On isnull(AV7008.O05ID, AV0729.O05ID) =  O5.AnaID And O5.AnaTypeID = ''O05'' and AV7008.DivisionID = O5.DivisionID
LEFT JOIN AT1202 On  isnull( AV0729.ObjectID,	AV7008.ObjectID) = AT1202.ObjectID and AV7008.DivisionID = AT1202.DivisionID
LEFT JOIN AT1207 O1 On AT1202.S1 = O1.S And O1.STypeID = ''O01'' and AV7008.DivisionID = O1.DivisionID
LEFT JOIN AT1207 O2 On AT1202.S2 = O2.S And O2.STypeID = ''O02'' and AV7008.DivisionID = O2.DivisionID
LEFT JOIN AT1207 O3 On AT1202.S3 = O3.S And O1.STypeID = ''O03'' and AV7008.DivisionID = O3.DivisionID
LEFT JOIN AT1302 On AV7008.InventoryID = AT1302.InventoryID and AV7008.DivisionID = AT1302.DivisionID
LEFT JOIN AT9000 ON AT9000.WOrderID=AV7008.VoucherID and AT9000.TransactionTypeID=''T04'' and AT9000.InventoryID = AV7008.InventoryID
LEFT JOIN AT1011 ON AT9000.Ana01ID=AT1011.AnaID and AT1011.AnaTypeID=''A01''
'
set @sqlWhere = N'
WHERE 	'+@WareHouseWhere+'
		AV7008.DivisionID =N'''+@DivisionID+N''' and
		(AV7008.O05ID between N''' + @FromO05ID + N''' and N''' + @ToO05ID + N''') and
		(AV7008.ObjectID between  N'''+@FromObjectID+N''' and  N'''+@ToObjectID+N''') AND 

		AV7008.D_C in (''D'',''BD'',''C'') ' + @OWhere + ' ' 
Set @sqlWhere = @sqlWhere + @strTime +N' 
'
set @sqlGroupBy = N'
GROUP BY AV7008.DivisionID, AV7008.VoucherID, AV0729.ObjectID,AV7008.ObjectID, AV0729.ObjectName, AV7008.ObjectName, 
	AT1202.S1, AT1202.S2, AT1202.S3, 
	O1.SName, O2.SName, O3.SName, 
    isnull( AV7008.O05ID,AV0729.O05ID),
	O5.AnaName,
	AV0729.Address, AV7008.Address, AV7008.InventoryID, AV7008.InventoryName, AT1302.VATGroupID, AT1302.VATPercent, 
	AV7008.UnitID, AV7008.UnitName, 
	AT1309.UnitID,
	AT1309.ConversionFactor,
	AT1309.Operator,
	AV7008.Specification , AV7008.Notes01 , AV7008.Notes02 , AV7008.Notes03 ,
	AV7008.DebitAccountID, AV7008.CreditAccountID,
	AV7008.VoucherDate, AV7008.VoucherNo,  AV7008.VoucherTypeID,
	AV7008.RefNo01, AV7008.RefNo02, AV7008.Notes,
	AV0729.BeginQuantity, AV0729.BeginAmount,
	AV7008.D_C,AV7008.ActualQuantity,AV7008.ConvertedAmount,
	AV7008.S1, AV7008.S2, AV7008.S3, 
	AV7008.S1Name, AV7008.S2Name, AV7008.S3Name, 
	AV7008.I01ID, AV7008.I02ID, AV7008.I03ID, AV7008.I04ID, AV7008.I05ID,
	AV7008.InAnaName1, AV7008.InAnaName2, AV7008.InAnaName3, AV7008.InAnaName4, AV7008.InAnaName5, AV7008.SourceNo, 
	AV7008.ProductID, AV7008.MOrderID, AV7008.ProductName,
	AV7008.VoucherDesc, 
	AV7008.Ana01ID,AV7008.Ana02ID,AV7008.Ana03ID,AV7008.Ana04ID,AV7008.Ana05ID,
	AV7008.Ana06ID,AV7008.Ana07ID,AV7008.Ana08ID,AV7008.Ana09ID,AV7008.Ana10ID,
	AV7008.Ana01Name,AV7008.Ana02Name,AV7008.Ana03Name,AV7008.Ana04Name,AV7008.Ana05Name,
	AV7008.Ana06Name,AV7008.Ana07Name,AV7008.Ana08Name,AV7008.Ana09Name,AV7008.Ana10Name,
	AV7008.LimitDate, AV7008.RevoucherDate,AV7008.WareHouseID,AV7008.WarehouseName,AT9000.VoucherNo, AT9000.VoucherDate,AT9000.TDescription,  ---06/01/2014 MTuyen add new
	AT9000.InvoiceNo, AT1011.AnaName,
	Isnull(AV0729.IsBottle, AV7008.IsBottle)
'
print @sqlSelect
print @sqlFrom
print @sqlWhere
Print @sqlGroupBy
EXEC (@sqlSelect + @sqlFrom + @sqlWhere + @sqlGroupBy)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

