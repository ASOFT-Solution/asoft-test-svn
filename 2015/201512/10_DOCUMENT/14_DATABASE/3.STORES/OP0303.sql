IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0303]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP0303]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



---Created by : Thuy Tuyen
---purpose: In bao cao Tong hop tinh hinh dat hang( So sanh giu Yeu cau- don hang mua- nhap kho )
-- date: 11/05/2009,26/05/2009
-- Last edit: Thuy Tuyen 05/06/2009 ,17/06/2009, 18/06/2009,26/10/2009,30/11/2009
--- Edit by B.Anh, date 11/12/2009	Sua loi khong len du lieu phan so luong giao thuc te va ngay giao tu nhap kho Asoft-T
--Edit Thuy Tuyen: Lay them truong don gia  khi lap don hang mua, date: 15/01/2009
---- Modified on 31/01/2012 by Le Thi Thu Hien : Sua dieu kien CONVERT theo ngay
/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [16/12/2010]
'********************************************/

CREATE PROCEDURE [dbo].[OP0303]  
				@DivisionID nvarchar(50),
				@IsDate tinyint,
				@FromMonth int,				
				@ToMonth int,
				@FromYear int,
				@ToYear int,
				@FromDate datetime,
				@ToDate datetime,				
				@FromInventoryID nvarchar(50),
				@ToInventoryID nvarchar(50),
				@IsGroup as tinyint,
				@GroupID nvarchar(50), -- GroupID: OB, CI1, CI2, CI3, I01, I02, I03, I04, I05	
				@IsCheck int,---- 0: co len du lieu cua thang truoc chua nhan,1: khong len du lieu cua thang truoc
				@FromObjectID nvarchar(50),
				@ToObjectID nvarchar(50)
AS
DECLARE @sSQL nvarchar(4000),
		@sSQL1 nvarchar(4000),
		@GroupField nvarchar(20),
		@sFROM nvarchar(500),
		@sSELECT nvarchar(500),
		@sWHERE nvarchar(500), 
    @FromMonthYearText NVARCHAR(20), 
    @ToMonthYearText NVARCHAR(20), 
    @FromDateText NVARCHAR(20), 
    @ToDateText NVARCHAR(20)
    
SET @FromMonthYearText = STR(@FromMonth + @FromYear * 100)
SET @ToMonthYearText = STR(@ToMonth + @ToYear * 100)
SET @FromDateText = CONVERT(NVARCHAR(20), @FromDate, 101)
SET @ToDateText = CONVERT(NVARCHAR(20), @ToDate, 101) + ' 23:59:59'

Select @sFROM = '',  @sSELECT = ''

---Step 1: Lay  so luong  giao thu te 
	--------Step 1.1: Lay  Tong so luong   giao thuc te (nhap kho).

Set @sSQL = N'
Select	A00.DivisionID , 
		A00.OrderID , 
		A00.InventoryID,  
		A00.OTransactionID,
		sum(ActualQuantity) as ActualQuantity, 
		Max(A01.VoucherDate) as ActualDate, 
		SUM(' + CASE WHEN @IsDate = 1 then  ' CASE WHEN CONVERT(DATETIME,CONVERT(VARCHAR(10),T01.OrderDate ,101),101)  < ''' + @FromDateText  + ''' THEN  ActualQuantity ELSE 0 END ' 
		ELSE '  CASE WHEN T01.TranMonth + T01.TranYear*100 < ' + @FromMonthYearText + '  THEN ActualQuantity ELSE 0 END'   END + ')
		AS ActualQuantity0
From AT2007 A00 
inner join AT2006 A01 on A00.VoucherID = A01.VoucherID and A01.KindVoucherID  in(1, 5, 7) And A00.DivisionID = A01.DivisionID
Inner join OT3002 T02 on T02.TransactionID = A00.OTransactionID And A00.DivisionID = T02.DivisionID
inner join OT3001 T01 on T01.POrderID  = T02.POrderID  and T01.OrderStatus not in ( 9)  And A00.DivisionID = T01.DivisionID

Where  T01.DivisionID = ''' + @DivisionID +  ''' /*AND    ' +
	CASE WHEN @IsDate = 1 then  ' CONVERT(DATETIME,CONVERT(VARCHAR(10),T01.OrderDate,101),101)  <= ''' + @ToDateText  + '''' 
	ELSE  '   T01.TranMonth + T01.TranYear*100 <= ' + @ToMonthYearText      end  + ' AND ' + 
	CASE WHEN @IsDate = 1 then  ' CONVERT(DATETIME,CONVERT(VARCHAR(10),A01.VoucherDate,101),101)  <= ''' + @ToDateText  + '''' 
	ELSE  '   A01.TranMonth + A01.TranYear*100 <= ' + @ToMonthYearText      end  +  ' */
	GROUP BY A00.DivisionID, A00.OrderID, A00.InventoryID, A00.OTransactionID'

IF EXISTS(SELECT TOP 1 1 FROM SYSOBJECTS WHERE XTYPE = 'V' AND NAME = 'OV0313')
	DROP VIEW OV0313
EXEC('CREATE VIEW OV0313 ---tao boi OP0303
		as ' + @sSQL)



--------Step 1.2: Lay  Tong so luong  dat hang thuc te(don  hang mua ) .
Set @sSQL =  -- chi tiet
N'Select A00.DivisionID as DivisionID, 
	A00.ROrderID as OrderID , 
	A00.POrderID , 	
	A00.InventoryID,  
	A00.RefTransactionID,
	A00.TransactionID,
	sum(A00.OrderQuantity) as ActualQuantity, 
	Avg(PurchasePrice) as PurchasePrice,
	Max(A01.OrderDate) as ActualDate, 
	A01.ShipDate as  POShipdate,
	SUM(' + CASE WHEN @IsDate = 1 then  ' CASE WHEN CONVERT(DATETIME,CONVERT(VARCHAR(10),T01.OrderDate ,101),101)  < ''' + @FromDateText  + ''' THEN  A00.OrderQuantity ELSE 0 END ' 
	ELSE '  CASE WHEN T01.TranMonth + T01.TranYear*100 < ' + @FromMonthYearText + '  THEN A00.OrderQuantity ELSE 0 END'   END + ')
	AS ActualQuantity0
From OT3002  A00 inner join OT3001 A01 on A00.POrderID = A01.POrderID  And A00.DivisionID = A01.DivisionID
Inner join OT3102 T02 on T02.TransactionID = isnull(A00.RefTransactionID,'''') And A00.DivisionID = T02.DivisionID
inner join OT3101 T01 on T01.ROrderID  = T02.ROrderID  and T01.OrderStatus not in ( 9) And A00.DivisionID = T01.DivisionID
Where  T01.DivisionID = ''' + @DivisionID +  ''' /* AND    ' +
	CASE WHEN @IsDate = 1 then  ' CONVERT(DATETIME,CONVERT(VARCHAR(10),T01.OrderDate,101),101)  <= ''' + @ToDateText  + '''' 
	ELSE  '   T01.TranMonth + T01.TranYear*100 <= ' + @ToMonthYearText      end  + ' AND ' + 
	CASE WHEN @IsDate = 1 then  ' CONVERT(DATETIME,CONVERT(VARCHAR(10),A01.OrderDate,101),101)  <= ''' + @ToDateText  + '''' 
	ELSE  '   A01.TranMonth + A01.TranYear*100 <= ' + @ToMonthYearText      end  +  '*/
	Group by A00.DivisionID, A00.ROrderID, A00.InventoryID,A00.POrderID, A00.RefTransactionID, A00.TransactionID,A01.ShipDate'

---print @sSQL
If exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'OV0331')
	Drop view OV0331
EXEC('Create view OV0331 ---tao boi OP0303
		as ' + @sSQL)

 --------Step 1.2: Lay  Tong so luong  dat hang thuc te(don  hang mua ) .
Set @sSQL =  -- tong hop
N'Select A00.DivisionID as DivisionID, 
	A00.ROrderID as OrderID , 
	A00.InventoryID,  
	A00.RefTransactionID,
	Avg(PurchasePrice) as PurchasePrice,
	sum(A00.OrderQuantity) as ActualQuantity, 
	Max(A01.OrderDate) as ActualDate, 
	'''' as  POShipdate,
	SUM(' + CASE WHEN @IsDate = 1 then  ' CASE WHEN CONVERT(DATETIME,CONVERT(VARCHAR(10),T01.OrderDate ,101),101) < ''' + @FromDateText  + ''' THEN  A00.OrderQuantity ELSE 0 END ' 
	ELSE '  CASE WHEN T01.TranMonth + T01.TranYear*100 < ' + @FromMonthYearText + '  THEN A00.OrderQuantity ELSE 0 END'   END + ')
	AS ActualQuantity0
From OT3002  A00 inner join OT3001 A01 on A00.POrderID = A01.POrderID  And A00.DivisionID = A01.DivisionID
Inner join OT3102 T02 on T02.TransactionID = isnull(A00.RefTransactionID,'''') And A00.DivisionID = T02.DivisionID
inner join OT3101 T01 on T01.ROrderID  = T02.ROrderID  and T01.OrderStatus not in ( 9) And A00.DivisionID = T01.DivisionID
Where  T01.DivisionID = ''' + @DivisionID +  ''' /* AND    ' +
	CASE WHEN @IsDate = 1 then  ' CONVERT(DATETIME,CONVERT(VARCHAR(10),T01.OrderDate ,101),101)  <= ''' + @ToDateText  + '''' 
	ELSE  '   T01.TranMonth + T01.TranYear*100 <= ' + @ToMonthYearText      end  + ' AND ' + 
	CASE WHEN @IsDate = 1 then  ' CONVERT(DATETIME,CONVERT(VARCHAR(10),A01.OrderDate ,101),101)  <= ''' + @ToDateText  + '''' 
	ELSE  '   A01.TranMonth + A01.TranYear*100 <= ' + @ToMonthYearText      end  +  '*/
	Group by A00.DivisionID ,A00.ROrderID, A00.InventoryID, A00.RefTransactionID '
If exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'OV0314')
	Drop view OV0314
EXEC('Create view OV0314 ---tao boi OP0303
		as ' + @sSQL)

---Step2: Lay du lieu nhom (OR0302,OR0321)
		
IF @IsGroup  = 1  ---Co nhom
	BEGIN
	Exec OP4700  	@GroupID,	@GroupField OUTPUT
	Select @sFROM = @sFROM + ' left join OV6666 V1 on V1.SelectionType = ''' + @GroupID + ''' and V1.SelectionID = OV2400.' + @GroupField + ' And V1.DivisionID = OV2400.DivisionID ',
		@sSELECT = @sSELECT + ', 
		V1.SelectionID as GroupID, V1.SelectionName as GroupName'
		
	END

ELSE  ---Khong  nhom
	Set @sSELECT = @sSELECT +  ', 
		'''' as GroupID, '''' as GroupName'	



---------Step3.1: Tong hop (OR6012)

If @IsCheck=1 ---co chon nhung phieu chua giao het
BEGIN
Set @sSQL =  N'
Select  OV2400.DivisionID as DivisionID, 
		OV2400.OrderID as POrderID,  
		OV2400.VoucherNo,           
		OV2400.VoucherDate as OrderDate,
		OV2400.ObjectID,
		OV2400.ObjectName,
		OV2400.OrderStatus,
		OT1101.Description as OrderStatusName,
		OV2400.InventoryID, 
		OV2400.InventoryName, 
		OV2400.UnitName,
		OV2400.Specification,
		 OV2400.InventoryTypeID,
		OV2400.OrderQuantity,
		OV2400.RequestPrice,
		isnull(OV2400.RequestPrice, 0)* isnull(OV2400.ExchangeRate, 0) as ConvertedPrice,	
		OV2400.OriginalAmount as TOriginalAmount,
		OV2400.ConvertedAmount as TConvertedAmount,
		OV2400.ShipDate,
		OV0314.ActualQuantity,
		OV0314.ActualDate,
		OV0314.PurchasePrice,

		
		case when isnull(OV2400.ShipDate, '''') = '''' or isnull(OV0314.ActualDate, '''') = '''' then 0 else 
		Datediff(day, OV2400.ShipDate, OV0314.ActualDate) end as AfterDayAmount, 
		(OV2400.OrderQuantity - isnull(OV0314.ActualQuantity, 0) + isnull(OV2400.AdjustQuantity, 0)) as RemainQuantity
		 ' 

Set @sSQL1 = @sSELECT  + N'
From OV2700  OV2400
 left join OV0314 on  OV2400.TransactionID =isnull( OV0314.RefTransactionID,'''') And OV2400.DivisionID = OV0314.DivisionID
left join OT1101 on OT1101.OrderStatus = OV2400.OrderStatus and TypeID =  ''RO'' And OV2400.DivisionID = OT1101.DivisionID
 
	           ' + @sFROM + ' 
Where  OV2400.DivisionID = ''' + @DivisionID + ''' and ' +   
		case when @IsDate = 1 then  ' ((OV2400.OrderStatus not in (   4, 9)   and 
		CONVERT(DATETIME,CONVERT(VARCHAR(10),OV2400.VoucherDate ,101),101)  < ''' + @FromDateText  + ''' AND  
		(OV2400.OrderQuantity - isnull(OV0314.ActualQuantity0, 0) + isnull(OV2400.AdjustQuantity, 0)) > 0) or
		CONVERT(DATETIME,CONVERT(VARCHAR(10),OV2400.VoucherDate ,101),101)  BETWEEN ''' + 					
		 @FromDateText + ''' and ''' +  @ToDateText  + ''') '
		else 	' ((OV2400.OrderStatus not in ( 9, 4)   and  
		OV2400.TranMonth + OV2400.TranYear*100 < ' + @FromMonthYearText +  '  AND  
		(OV2400.OrderQuantity - isnull(OV0314.ActualQuantity0, 0) + isnull(OV2400.AdjustQuantity, 0)) > 0) OR 
		OV2400.TranMonth + OV2400.TranYear*100 between ' +  @FromMonthYearText +  ' and ' + 
		@ToMonthYearText  + ') ' end +  
		  ' and  OV2400.InventoryID ' + case when @FromInventoryID = '%' then ' like ''%''' 
		else ' between ''' + @FromInventoryID + ''' and ''' + @ToInventoryID + ''''   end +
		  ' and  OV2400.ObjectID ' + case when @FromObjectID = '%' then ' like ''%''' 
		else ' between ''' + @FromObjectID + ''' and ''' + @ToObjectID + ''''   end 

END
Else	--- Khong chon nhung phieu chua giao het
BEGIN
Set @sSQL =  N'
Select  OV2400.DivisionID as DivisionID,
		OV2400.OrderID as POrderID,  
		OV2400.VoucherNo,           
		OV2400.VoucherDate as OrderDate,
		OV2400.ObjectID,
		OV2400.ObjectName,
		----OV2400.Orders,
		OV2400.OrderStatus,
		OT1101.Description as OrderStatusName,
		OV2400.InventoryID, 
		OV2400.InventoryName, 
		OV2400.UnitName,
		OV2400.Specification,
		 OV2400.InventoryTypeID,
		OV2400.OrderQuantity,
		OV2400.RequestPrice,
		isnull(OV2400.RequestPrice, 0)* isnull(OV2400.ExchangeRate, 0) as ConvertedPrice,	
		OV2400.OriginalAmount as TOriginalAmount,
		OV2400.ConvertedAmount as TConvertedAmount,
		OV2400.ShipDate,
		OV0314.ActualQuantity,
		OV0314.ActualDate,
		OV0314.PurchasePrice,
		
		case when isnull(OV2400.ShipDate, '''') = '''' or isnull(OV0314.ActualDate, '''') = '''' then 0 else 
		Datediff(day, OV2400.ShipDate, OV0314.ActualDate) end as AfterDayAmount, 
		(OV2400.OrderQuantity - isnull(OV0314.ActualQuantity, 0) + isnull(OV2400.AdjustQuantity, 0)) as RemainQuantity 
		
		' 

Set @sSQL1 = @sSELECT  + N'
From OV2700  OV2400
 left join OV0314 on  OV2400.TransactionID =isnull( OV0314.RefTransactionID,'''') And OV2400.DivisionID = OV0314.DivisionID
left join OT1101 on OT1101.OrderStatus = OV2400.OrderStatus and TypeID =  ''RO'' And OV2400.DivisionID = OT1101.DivisionID

	             ' + @sFROM + ' 
Where OV2400.DivisionID = ''' + @DivisionID + ''' and ' +   
		case when @IsDate = 1 then  ' OV2400.OrderStatus not in (  4, 9)   and 
		CONVERT(DATETIME,CONVERT(VARCHAR(10),OV2400.VoucherDate ,101),101)  BETWEEN ''' + 					
		 @FromDateText + ''' and ''' +  @ToDateText  + ''' '
		else 	' OV2400.OrderStatus not in (9,  4)   and  
		OV2400.TranMonth + OV2400.TranYear*100 between ' +  @FromMonthYearText +  ' and ' + 
		@ToMonthYearText   end +  
		  ' and  OV2400.InventoryID ' + case when @FromInventoryID = '%' then ' like ''%''' 
		else ' between ''' + @FromInventoryID + ''' and ''' + @ToInventoryID + ''''   end +
		  ' and  OV2400.ObjectID ' + case when @FromObjectID = '%' then ' like ''%''' 
		else ' between ''' + @FromObjectID + ''' and ''' + @ToObjectID + ''''   end 
END
--print @sSQL
If exists (Select top 1 1 From SysObjects Where name = 'OV0316' and Xtype ='V') 
	Drop view OV0316
Exec ('Create view OV0316  --tao boi OP0303
		as '+@sSQL+@sSQL1)




------Step3: Lay du lieu in bao cao
	---------Step3.1: Chi tiet  (OR6014, OR6015)

If @IsCheck=1 ---co chon nhung phieu chua giao het
BEGIN
Set @sSQL =  N'
Select  OV2400.DivisionID as DivisionID,
		OV2400.OrderID as POrderID,  
		OV2400.TransactionID,
		OV2400.VoucherNo,           
		OV2400.VoucherDate as OrderDate,
		OV2400.ObjectID,
		OV2400.ObjectName,
		OV2400.OrderStatus,
		OT1101.Description as OrderStatusName,
		OV2400.InventoryID, 
		OV2400.InventoryName, 
		OV2400.UnitName,
		OV2400.Specification,
		 OV2400.InventoryTypeID,
		OV2400.OrderQuantity,
		OV2400.RequestPrice,
		isnull(OV2400.RequestPrice, 0)* isnull(OV2400.ExchangeRate, 0) as ConvertedPrice,	
		OV2400.OriginalAmount as TOriginalAmount,
		OV2400.ConvertedAmount as TConvertedAmount,
		OV2400.ShipDate,
		OV0331.ActualQuantity,
		OV0331.ActualDate,
		OV0331.PurchasePrice,
		OV0331.POrderID as  ActualOrderID,
		case when isnull(OV2400.ShipDate, '''') = '''' or isnull(OV0331.ActualDate, '''') = '''' then 0 else 
		Datediff(day, OV2400.ShipDate, OV0331.ActualDate) end as AfterDayAmount, 
		(OV2400.OrderQuantity - isnull(OV0331.ActualQuantity, 0) + isnull(OV2400.AdjustQuantity, 0)) as RemainQuantity,

		OV0313.ActualQuantity as TActualQuantity,
		OV0313.ActualDate as TActualDate ,
		OV0331.POShipdate
		' 
		
Set @sSQL1 = @sSELECT + N'
From OV2700  OV2400
 left join OV0331  on  OV2400.TransactionID = OV0331.RefTransactionID And OV2400.DivisionID = OV0331.DivisionID
 left join OV0313  on OV0331.InventoryID = OV0313.InventoryID  and OV0313.OTransactionID = OV0331.TransactionID And OV2400.DivisionID = OV0313.DivisionID
left join OT1101 on OT1101.OrderStatus = OV2400.OrderStatus and TypeID =  ''RO'' And OV2400.DivisionID = OT1101.DivisionID
	           ' + @sFROM + ' 
Where  OV2400.DivisionID = ''' + @DivisionID + ''' and ' +   
		case when @IsDate = 1 then  ' ((OV2400.OrderStatus not in (   4, 9)   and 
		CONVERT(DATETIME,CONVERT(VARCHAR(10),OV2400.VoucherDate ,101),101)  < ''' + @FromDateText  + ''' AND  
		(OV2400.OrderQuantity - isnull(OV0331.ActualQuantity0, 0) + isnull(OV2400.AdjustQuantity, 0)) > 0) or
		CONVERT(DATETIME,CONVERT(VARCHAR(10),OV2400.VoucherDate ,101),101)  BETWEEN ''' + 					
		 @FromDateText + ''' and ''' +  @ToDateText  + ''') '
		else 	' ((OV2400.OrderStatus not in ( 9, 4)   and  
		OV2400.TranMonth + OV2400.TranYear*100 < ' + @FromMonthYearText +  '  AND  
		(OV2400.OrderQuantity - isnull(OV0331.ActualQuantity0, 0) + isnull(OV2400.AdjustQuantity, 0)) > 0) OR 
		OV2400.TranMonth + OV2400.TranYear*100 between ' +  @FromMonthYearText +  ' and ' + 
		@ToMonthYearText  + ') ' end +  
		  ' and  OV2400.InventoryID ' + case when @FromInventoryID = '%' then ' like ''%''' 
		else ' between ''' + @FromInventoryID + ''' and ''' + @ToInventoryID + ''''   end +
		  ' and  OV2400.ObjectID ' + case when @FromObjectID = '%' then ' like ''%''' 
		else ' between ''' + @FromObjectID + ''' and ''' + @ToObjectID + ''''   end 

END
Else	--- Khong chon nhung phieu chua giao het
BEGIN
Set @sSQL =  N'
Select  OV2400.DivisionID as DivisionID,
		OV2400.OrderID as POrderID,  
		OV2400.TransactionID,
		OV2400.VoucherNo,           
		OV2400.VoucherDate as OrderDate,
		OV2400.ObjectID,
		OV2400.ObjectName,
		----OV2400.Orders,
		OV2400.OrderStatus,
		OT1101.Description as OrderStatusName,
		OV2400.InventoryID, 
		OV2400.InventoryName, 
		OV2400.UnitName,
		OV2400.Specification,
		 OV2400.InventoryTypeID,
		OV2400.OrderQuantity,
		OV2400.RequestPrice,
		isnull(OV2400.RequestPrice, 0)* isnull(OV2400.ExchangeRate, 0) as ConvertedPrice,	
		OV2400.OriginalAmount as TOriginalAmount,
		OV2400.ConvertedAmount as TConvertedAmount,
		OV2400.ShipDate,
		OV0331.ActualQuantity,
		OV0331.ActualDate,
		OV0331.PurchasePrice,
		OV0331.POrderID as  ActualOrderID,
		case when isnull(OV2400.ShipDate, '''') = '''' or isnull(OV0313.ActualDate, '''') = '''' then 0 else 
		---Datediff(day, OV2400.ShipDate, OV0331.ActualDate) end as AfterDayAmount, 

		Datediff(day, OV2400.ShipDate, OV0313.ActualDate) end as AfterDayAmount, 

		(OV2400.OrderQuantity - isnull(OV0331.ActualQuantity, 0) + isnull(OV2400.AdjustQuantity, 0)) as RemainQuantity ,
		
		OV0313.ActualQuantity as TActualQuantity,
		OV0313.ActualDate as TActualDate ,
		OV0331.POShipdate
		  ' 
		  
Set @sSQL1 = @sSELECT  + N'
From OV2700  OV2400
 left join OV0331  on OV2400.TransactionID = OV0331.RefTransactionID And OV2400.DivisionID = OV0331.DivisionID
  left join OV0313  on OV0331.InventoryID = OV0313.InventoryID  and OV0313.OTransactionID = OV0331.TransactionID And OV2400.DivisionID = OV0313.DivisionID
left join OT1101 on OT1101.OrderStatus = OV2400.OrderStatus and TypeID =  ''RO'' And OV2400.DivisionID = OT1101.DivisionID
	             ' + @sFROM + ' 
Where OV2400.DivisionID = ''' + @DivisionID + ''' and ' +   
		case when @IsDate = 1 then  ' OV2400.OrderStatus not in (  4, 9)   and 
		CONVERT(DATETIME,CONVERT(VARCHAR(10),OV2400.VoucherDate ,101),101)  BETWEEN ''' + 					
		 @FromDateText + ''' and ''' +  @ToDateText  + ''' '
		else 	' OV2400.OrderStatus not in (9,  4)   and  
		OV2400.TranMonth + OV2400.TranYear*100 between ' +  @FromMonthYearText +  ' and ' + 
		@ToMonthYearText   end +  
		  ' and  OV2400.InventoryID ' + case when @FromInventoryID = '%' then ' like ''%''' 
		else ' between ''' + @FromInventoryID + ''' and ''' + @ToInventoryID + ''''   end +
		  ' and  OV2400.ObjectID ' + case when @FromObjectID = '%' then ' like ''%''' 
		else ' between ''' + @FromObjectID + ''' and ''' + @ToObjectID + ''''   end 

END
---Print @sSQL


If exists (Select top 1 1 From SysObjects Where name = 'OV0315' and Xtype ='V') 
	Drop view OV0315
Exec ('Create view OV0315  --tao boi OP0303
		as '+@sSQL+@sSQL1)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

