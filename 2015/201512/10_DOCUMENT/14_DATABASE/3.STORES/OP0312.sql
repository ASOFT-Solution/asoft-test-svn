IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OP0312]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[OP0312]
GO
/****** Object:  StoredProcedure [dbo].[OP0312]    Script Date: 12/16/2010 10:57:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

---Created by : Thuy Tuyen , date: 02/01/2005
---purpose: In bao cao Tong hop tinh hinh mua hang
-- Date: 29/04/2009

/********************************************
'* Edited by: [GS] [Thanh Trẫm] [03/08/2010]
'********************************************/

CREATE PROCEDURE [dbo].[OP0312]  @DivisionID nvarchar(50),
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
				@IsCheck int,---- 0: co len du lieu cu athang truoc chua nhan,1: khong len du lieu cua thang truoc
				@FromObjectID nvarchar(50),
				@ToObjectID nvarchar(50)
AS
DECLARE @sSQL nvarchar(max),
		@GroupField nvarchar(50),
		@sFROM nvarchar(max),
		@sSELECT nvarchar(max),
		@sWHERE nvarchar(max)


Select @sFROM = '',  @sSELECT = ''

---Step 1: Lay  so luong  giao thu te 
	--------Step 1.1: Lay  Tong so luong   giao thuc te.(OR0302)

Set @sSQL = 
'Select A00.DivisionID , 
	A00.OrderID , 
	InventoryID,  
	sum(ActualQuantity) as ActualQuantity, 
	Max(A01.VoucherDate) as ActualDate, 
	SUM(' + CASE WHEN @IsDate = 1 then  ' CASE WHEN T01.OrderDate  < ''' + convert(nvarchar(10), @FromDate, 101)  + ''' THEN  ActualQuantity ELSE 0 END ' 
	ELSE '  CASE WHEN T01.TranMonth + T01.TranYear*100 < ' + cast(@FromMonth + @FromYear*100 as nvarchar(10)) + '  THEN ActualQuantity ELSE 0 END'   END + ')
	AS ActualQuantity0
From AT2007 A00 inner join AT2006 A01 on A00.VoucherID = A01.VoucherID and A01.KindVoucherID  in(1, 5, 7)
inner join OT3001 T01 on T01.POrderID  = A00.OrderID  and T01.OrderStatus not in ( 9) 
Where  T01.DivisionID = ''' + @DivisionID +  ''' AND    ' +
	CASE WHEN @IsDate = 1 then  ' T01.OrderDate  <= ''' + convert(nvarchar(10), @ToDate, 101)  + '''' 
	ELSE  '   T01.TranMonth + T01.TranYear*100 <= ' + cast(@ToMonth + @ToYear*100 as nvarchar(10))      end  + ' AND ' + 
	CASE WHEN @IsDate = 1 then  ' A01.VoucherDate  <= ''' + convert(nvarchar(10), @ToDate, 101)  + '''' 
	ELSE  '   A01.TranMonth + A01.TranYear*100 <= ' + cast(@ToMonth + @ToYear*100 as nvarchar(10))      end  +  '
	Group by A00.DivisionID, A00.OrderID, InventoryID'


If exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'OV0308')
	Drop view OV0308
EXEC('Create view OV0308 ---tao boi OP0302
		as ' + @sSQL)

 --------Step 1.2: Lay so luong   giao thuc te chi ti?t  theo tung chung tu.(OR0321)

Set @sSQL = 
'Select A00.DivisionID,
	A00.OrderID , 
	A01.VoucherNo,
	A00.InventoryID,  
	0 as UnitPrice,
	A00. Ana01ID, 	A00. Ana02ID, 	 A00.Ana03ID, 	
		 A00.Ana04ID, 	 A00.Ana05ID,
	A00.OTransactionID,
	ActualQuantity =  Isnull ((select  sum (isnull(ActualQuantity,0)) From AT2007  Where
								 AT2007.InventoryID = A00.InventoryID	and  AT2007.OrderID = A00.OrderID  and AT2007.OTransactionID = A00.OTransactionID  
								 and AT2007.DivisionID = T01.DivisionID and AT2007.VoucherID =A00.VoucherID
								 and '+CASE WHEN @IsDate = 1 then  ' T01.OrderDate  <= ''' + convert(nvarchar(10), @ToDate, 101)  + '''' 
									ELSE  '   T01.TranMonth + T01.TranYear*100 <= ' + cast(@ToMonth + @ToYear*100 as nvarchar(10))      end  + ' AND ' + 
									CASE WHEN @IsDate = 1 then  ' A01.VoucherDate  <= ''' + convert(nvarchar(10), @ToDate, 101)  + '''' 
									ELSE  '   A01.TranMonth + A01.TranYear*100 <= ' + cast(@ToMonth + @ToYear*100 as nvarchar(10))      end  +  ' ),0),

	OriginalAmount =  Isnull ((select  sum (isnull(OriginalAmount,0)) from AT9000 Where
								 AT9000.InventoryID = A00.InventoryID	and  AT9000.OrderID = A00.OrderID   and AT9000.OTransactionID = A00.OTransactionID and AT9000.DivisionID = T01.DivisionID 
									and AT9000.VoucherID =A00.VoucherID and TransactionTypeID <> ''T13''
								 and '+CASE WHEN @IsDate = 1 then  ' T01.OrderDate  <= ''' + convert(nvarchar(10), @ToDate, 101)  + '''' 
									ELSE  '   T01.TranMonth + T01.TranYear*100 <= ' + cast(@ToMonth + @ToYear*100 as nvarchar(10))      end  + ' AND ' + 
									CASE WHEN @IsDate = 1 then  ' A01.VoucherDate  <= ''' + convert(nvarchar(10), @ToDate, 101)  + '''' 
									ELSE  '   A01.TranMonth + A01.TranYear*100 <= ' + cast(@ToMonth + @ToYear*100 as nvarchar(10))      end  +  ' ),0),
	/* OriginalAmountVAT =  Isnull ((select  sum (isnull(OriginalAmount,0)) from AT9000 Where
								 AT9000.InventoryID = A00.InventoryID	and  AT9000.OrderID = A00.OrderID  and AT9000.DivisionID = T01.DivisionID 
									and AT9000.VoucherID =A00.VoucherID and TransactionTypeID = ''T13''
								 and '+CASE WHEN @IsDate = 1 then  ' T01.OrderDate  <= ''' + convert(nvarchar(10), @ToDate, 101)  + '''' 
									ELSE  '   T01.TranMonth + T01.TranYear*100 <= ' + cast(@ToMonth + @ToYear*100 as nvarchar(10))      end  + ' AND ' + 
									CASE WHEN @IsDate = 1 then  ' A01.VoucherDate  <= ''' + convert(nvarchar(10), @ToDate, 101)  + '''' 
									ELSE  '   A01.TranMonth + A01.TranYear*100 <= ' + cast(@ToMonth + @ToYear*100 as nvarchar(10))      end  +  ' ),0), */
	
	OriginalAmountVAT =(Select  (Select isnull(Sum(OriginalAmount),0) From AT9000 
					Where 	OrderID = A00.OrderID 
						And InventoryID = A00.InventoryID 
						and AT9000.OTransactionID = A00.OTransactionID
						and AT9000.VoucherID =A00.VoucherID
						and AT9000.DivisionID = T01.DivisionID 
						and  '+CASE WHEN @IsDate = 1 then  ' T01.OrderDate  <= ''' + convert(nvarchar(10), @ToDate, 101)  + '''' 
									ELSE  '   T01.TranMonth + T01.TranYear*100 <= ' + cast(@ToMonth + @ToYear*100 as nvarchar(10))      end  + ' AND ' + 
									CASE WHEN @IsDate = 1 then  ' A01.VoucherDate  <= ''' + convert(nvarchar(10), @ToDate, 101)  + '''' 
									ELSE  '   A01.TranMonth + A01.TranYear*100 <= ' + cast(@ToMonth + @ToYear*100 as nvarchar(10))      end  +  '
						And TransactiontypeID<>''T13'')
						*'
set @sFROM = '
					(Select isnull(VATRate,0) from at1010 Where VATGroupID
						In 
						(Select Top 1 VATGroupID From AT9000 
							Where OrderID = A00.OrderID 
							    and AT9000.OTransactionID = A00.OTransactionID
							     and AT9000.VoucherID =A00.VoucherID 
							     and InventoryID = A00.InventoryID
							     and  '+CASE WHEN @IsDate = 1 then  ' T01.OrderDate  <= ''' + convert(nvarchar(10), @ToDate, 101)  + '''' 
								ELSE  '   T01.TranMonth + T01.TranYear*100 <= ' + cast(@ToMonth + @ToYear*100 as nvarchar(10))      end  + ' AND ' + 
								CASE WHEN @IsDate = 1 then  ' A01.VoucherDate  <= ''' + convert(nvarchar(10), @ToDate, 101)  + '''' 
								ELSE  '   A01.TranMonth + A01.TranYear*100 <= ' + cast(@ToMonth + @ToYear*100 as nvarchar(10))      end  +  '
							     And TransactiontypeID<>''T13''))/100),

	Max(A01.VoucherDate) as ActualDate, 
	SUM(' + CASE WHEN @IsDate = 1 then  ' CASE WHEN T01.OrderDate  < ''' + convert(nvarchar(10), @FromDate, 101)  + ''' THEN  ActualQuantity ELSE 0 END ' 
	ELSE '  CASE WHEN T01.TranMonth + T01.TranYear*100 < ' + cast(@FromMonth + @FromYear*100 as nvarchar(10)) + '  THEN ActualQuantity ELSE 0 END'   END + ')
	AS ActualQuantity0
From AT2007 A00
	inner join AT9000  on AT9000.VoucherID = A00.VoucherID
	 inner join AT2006 A01 on A00.VoucherID = A01.VoucherID and A01.KindVoucherID  in(1, 5, 7)
	inner join OT3001 T01 on T01.POrderID  = A00.OrderID AND T01.OrderType = 0 and T01.OrderStatus not in ( 9)
	
Where  T01.DivisionID = ''' + @DivisionID +  ''' AND    ' +
	CASE WHEN @IsDate = 1 then  ' T01.OrderDate  <= ''' + convert(nvarchar(10), @ToDate, 101)  + '''' 
	ELSE  '   T01.TranMonth + T01.TranYear*100 <= ' + cast(@ToMonth + @ToYear*100 as nvarchar(10))      end  + ' AND ' + 
	CASE WHEN @IsDate = 1 then  ' A01.VoucherDate  <= ''' + convert(nvarchar(10), @ToDate, 101)  + '''' 
	ELSE  '   A01.TranMonth + A01.TranYear*100 <= ' + cast(@ToMonth + @ToYear*100 as nvarchar(10))      end  +  '
Group by A00.DivisionID, A00.OrderID, A00.InventoryID, A01.VoucherNo,  A00.VoucherID,A00. Ana01ID, 	A00. Ana02ID, 	 A00.Ana03ID, 	
		 A00.Ana04ID, 	 A00.Ana05ID,
	T01.DivisionID,T01.TranMonth,T01.TranYear,A01.TranMonth,A01.TranYear,T01.OrderDate,  A01.VoucherDate, A00.OTransactionID'

If exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'OV0309')
	Drop view OV0309
EXEC('Create view OV0309 ---tao boi OP0302
		as ' + @sSQL + @sFROM)

 	

-----Step2: Lay du lieu nhom (OR0302,OR0321)
		
IF @IsGroup  = 1  ---Co nhom
	BEGIN
	Exec OP4700  	@GroupID,	@GroupField OUTPUT
	Select @sFROM = @sFROM + ' left join OV6666 V1 on V1.SelectionType = ''' + @GroupID + ''' and V1.SelectionID = OV2400.' + @GroupField,
		@sSELECT = @sSELECT + ', 
		V1.SelectionID as GroupID, V1.SelectionName as GroupName'
		
	END

ELSE  ---Khong  nhom
	Set @sSELECT = @sSELECT +  ', 
		'''' as GroupID, '''' as GroupName'	




------Step3: Lay du lieu in bao cao
	---------Step3.1: Tong hop (OR0302)

If @IsCheck=1 ---co chon nhung phieu chua giao het
Set @sSQL =  '
Select  OV2400.DivisionID as DivisionID,   
		OV2400.OrderID as POrderID,  
		OV2400.VoucherNo,           
		OV2400.VoucherDate as OrderDate,
		OV2400.ObjectID,
		OV2400.ObjectName,
		OV2400.OrderStatus,
		OV2400.InventoryID, 
		OV2400.InventoryName, 

		OV2400.UnitName,
		OV2400.Specification,
		 OV2400.InventoryTypeID,
		OV2400.OrderQuantity,
		OV2400.PurchasePrice,
		isnull(OV2400.PurchasePrice, 0)* isnull(OV2400.ExchangeRate, 0) as ConvertedPrice,	
		OV2400.OriginalAmount as TOriginalAmount,
		OV2400.ConvertedAmount as TConvertedAmount,
		OV2400.ShipDate,
		OV0308.ActualQuantity,
		OV0308.ActualDate,
		
		case when isnull(OV2400.ShipDate, '''') = '''' or isnull(OV0308.ActualDate, '''') = '''' then 0 else 
		Datediff(day, OV2400.ShipDate, OV0308.ActualDate) end as AfterDayAmount, 
		(OV2400.OrderQuantity - isnull(OV0308.ActualQuantity, 0) + isnull(OV2400.AdjustQuantity, 0)) as RemainQuantity 
From OV0307  OV2400 left join OV0308  on OV0308.OrderID = OV2400.OrderID and OV0308.InventoryID = OV2400.InventoryID 
Where  OV2400.DivisionID = ''' + @DivisionID + ''' and ' +   
		case when @IsDate = 1 then  ' ((OV2400.OrderStatus not in (   4, 9)   and 
		OV2400.VoucherDate  < ''' + convert(nvarchar(10), @FromDate, 101)  + ''' AND  
		(OV2400.OrderQuantity - isnull(OV0308.ActualQuantity0, 0) + isnull(OV2400.AdjustQuantity, 0)) > 0) or
		OV2400.VoucherDate  BETWEEN ''' + 					
		 convert(nvarchar(10), @FromDate, 101) + ''' and ''' +  convert(nvarchar(10), @ToDate, 101)  + ''') '
		else 	' ((OV2400.OrderStatus not in ( 9, 4)   and  
		OV2400.TranMonth + OV2400.TranYear*100 < ' + cast(@FromMonth + @FromYear*100 as nvarchar(10)) +  '  AND  
		(OV2400.OrderQuantity - isnull(OV0308.ActualQuantity0, 0) + isnull(OV2400.AdjustQuantity, 0)) > 0) OR 
		OV2400.TranMonth + OV2400.TranYear*100 between ' +  cast(@FromMonth + @FromYear*100 as nvarchar(10)) +  ' and ' + 
		cast(@ToMonth + @ToYear*100 as nvarchar(10))  + ') ' end +  
		  ' and  OV2400.InventoryID ' + case when @FromInventoryID = '%' then ' like ''%''' 
		else ' between ''' + @FromInventoryID + ''' and ''' + @ToInventoryID + ''''   end +
		  ' and  OV2400.ObjectID ' + case when @FromObjectID = '%' then ' like ''%''' 
		else ' between ''' + @FromObjectID + ''' and ''' + @ToObjectID + ''''   end 

Else	--- Khong chon nhung phieu chua giao het

Set @sSQL =  '
Select  OV2400.DivisionID as DivisionID,   
		OV2400.OrderID as POrderID,  
		OV2400.VoucherNo,           
		OV2400.VoucherDate as OrderDate,
		OV2400.ObjectID,
		OV2400.ObjectName,
		----OV2400.Orders,
OV2400.OrderStatus,
		OV2400.InventoryID, 
		OV2400.InventoryName, 

		OV2400.UnitName,
		OV2400.Specification,
		 OV2400.InventoryTypeID,
		OV2400.OrderQuantity,
		OV2400.PurchasePrice,
		isnull(OV2400.PurchasePrice, 0)* isnull(OV2400.ExchangeRate, 0) as ConvertedPrice,	
		OV2400.OriginalAmount as TOriginalAmount,
		OV2400.ConvertedAmount as TConvertedAmount,
		OV2400.ShipDate,
		OV0308.ActualQuantity,
		OV0308.ActualDate,
		
		case when isnull(OV2400.ShipDate, '''') = '''' or isnull(OV0308.ActualDate, '''') = '''' then 0 else 
		Datediff(day, OV2400.ShipDate, OV0308.ActualDate) end as AfterDayAmount, 
		(OV2400.OrderQuantity - isnull(OV0308.ActualQuantity, 0) + isnull(OV2400.AdjustQuantity, 0)) as RemainQuantity 
From OV0307 OV2400 left join OV0308  on OV0308.OrderID = OV2400.OrderID and OV0308.InventoryID = OV2400.InventoryID 
Where OV2400.DivisionID = ''' + @DivisionID + ''' and ' +   
		case when @IsDate = 1 then  ' OV2400.OrderStatus not in (  4, 9)   and 
		OV2400.VoucherDate  BETWEEN ''' + 					
		 convert(nvarchar(10), @FromDate, 101) + ''' and ''' +  convert(nvarchar(10), @ToDate, 101)  + ''' '
		else 	' OV2400.OrderStatus not in (9,  4)   and  
		OV2400.TranMonth + OV2400.TranYear*100 between ' +  cast(@FromMonth + @FromYear*100 as nvarchar(10)) +  ' and ' + 
		cast(@ToMonth + @ToYear*100 as nvarchar(10))   end +  
		  ' and  OV2400.InventoryID ' + case when @FromInventoryID = '%' then ' like ''%''' 
		else ' between ''' + @FromInventoryID + ''' and ''' + @ToInventoryID + ''''   end +
		  ' and  OV2400.ObjectID ' + case when @FromObjectID = '%' then ' like ''%''' 
		else ' between ''' + @FromObjectID + ''' and ''' + @ToObjectID + ''''   end 


--Print @sSQL


If exists (Select top 1 1 From SysObjects Where name = 'OV0302' and Xtype ='V') 
	Drop view OV0302

Exec ('Create view OV0302  --tao boi OP0302
		as '+@sSQL)



----Step 3.2: In bao cao chi tiet (OR0321)

If  @IsCheck =1 ---co chon nhung phieu chua giao het

Set @sSQL =  '
 Select OV2400.DivisionID as DivisionID,   
		OV2400.OrderID as POrderID,  
		OV2400.VoucherNo,           
		OV2400.VoucherDate as OrderDate,
		OV2400.ObjectID,
		OV2400.ObjectName,
		---OV2400.Orders,
		OV2400.OrderStatus,
		OV2400.InventoryID, 
		OV2400.InventoryName, 
		OV2400.VATPercent,
		OV2400.UnitName,
		OV2400.Specification,
		 OV2400.InventoryTypeID,
		OV2400.OrderQuantity,
		OV2400.PurchasePrice,
		isnull(OV2400.PurchasePrice, 0)* isnull(OV2400.ExchangeRate, 0) as ConvertedPrice,	
		OV2400.OriginalAmount as OriginalAmount,
		OV2400.ConvertedAmount as ConvertedAmount,
		OV2400.TotalOriginalAmount as TOriginalAmount,
		OV2400.TotalConvertedAmount as TConvertedAmount,
		OV2400.ShipDate,
		OV0309.ActualQuantity,
		OV0309.ActualDate,
		OV0309.UnitPrice as InputPrice,
		OV0309.VoucherNo as InputVoucher,
		OV0309.OriginalAmount as InputOriginalAmount,
		OV0309.OriginalAmountVAT,
		
		case when isnull(OV2400.ShipDate, '''') = '''' or isnull(OV0309.ActualDate, '''') = '''' then 0 else 
		Datediff(day, OV2400.ShipDate, OV0309.ActualDate) end as AfterDayAmount, 
		(OV2400.OrderQuantity - isnull(OV0309.ActualQuantity, 0) + isnull(OV2400.AdjustQuantity, 0)) as RemainQuantity 
From   OV2400
	            left join  OV0309  on OV0309.OrderID = OV2400.OrderID and OV0309.InventoryID = OV2400.InventoryID and OV0309.OTransactionID = OV2400.TransactionID    
Where OV2400.DivisionID = ''' + @DivisionID + ''' and ' +   
		case when @IsDate = 1 then  ' ((OV2400.OrderStatus not in (   4,9)   and 
		OV2400.VoucherDate  < ''' + convert(nvarchar(10), @FromDate, 101)  + ''' AND  
		(OV2400.OrderQuantity - isnull(OV0309.ActualQuantity0, 0) + isnull(OV2400.AdjustQuantity, 0)) > 0) or
		OV2400.VoucherDate  BETWEEN ''' + 					
		 convert(nvarchar(10), @FromDate, 101) + ''' and ''' +  convert(nvarchar(10), @ToDate, 101)  + ''') '
		else 	' ((OV2400.OrderStatus not in (9,   4)   and  
		OV2400.TranMonth + OV2400.TranYear*100 < ' + cast(@FromMonth + @FromYear*100 as nvarchar(10)) +  '  AND  
		(OV2400.OrderQuantity - isnull(OV0309.ActualQuantity0, 0) + isnull(OV2400.AdjustQuantity, 0)) > 0) OR 
		OV2400.TranMonth + OV2400.TranYear*100 between ' +  cast(@FromMonth + @FromYear*100 as nvarchar(10)) +  ' and ' + 
		cast(@ToMonth + @ToYear*100 as nvarchar(10))  + ') ' end +  
		  ' and  OV2400.InventoryID ' + case when @FromInventoryID = '%' then ' like ''%''' 
		else ' between ''' + @FromInventoryID + ''' and ''' + @ToInventoryID + ''''   end +
		  ' and  OV2400.ObjectID ' + case when @FromObjectID = '%' then ' like ''%''' 
		else ' between ''' + @FromObjectID + ''' and ''' + @ToObjectID + ''''   end +
		' and OV2400.Finish = 0'


Else ---Khong chon nhung phieu chua giao het

Set @sSQL =  '
Select  OV2400.DivisionID as DivisionID,   
		OV2400.OrderID as POrderID,  
		OV2400.VoucherNo,           

		OV2400.VoucherDate as OrderDate,
		OV2400.ObjectID,
		OV2400.ObjectName,
		---OV2400.Orders,
		OV2400.OrderStatus,
		OV2400.InventoryID, 
		OV2400.InventoryName, 
		OV2400.VATPercent,
		OV2400.UnitName,
		OV2400.Specification,
		 OV2400.InventoryTypeID,
		OV2400.OrderQuantity,
		OV2400.PurchasePrice,
		isnull(OV2400.PurchasePrice, 0)* isnull(OV2400.ExchangeRate, 0) as ConvertedPrice,	
		OV2400.OriginalAmount as OriginalAmount,
		OV2400.ConvertedAmount as ConvertedAmount,
		OV2400.TotalOriginalAmount as TOriginalAmount,
		OV2400.TotalConvertedAmount as TConvertedAmount,
		OV2400.ShipDate,
		OV0309.ActualQuantity,
		OV0309.ActualDate,
		OV0309.UnitPrice as InputPrice,
		OV0309.VoucherNo as InputVoucher,
		OV0309.OriginalAmount as InputOriginalAmount,
		OV0309.OriginalAmountVAT,

		case when isnull(OV2400.ShipDate, '''') = '''' or isnull(OV0309.ActualDate, '''') = '''' then 0 else 
		Datediff(day, OV2400.ShipDate, OV0309.ActualDate) end as AfterDayAmount, 
		(OV2400.OrderQuantity - isnull(OV0309.ActualQuantity, 0) + isnull(OV2400.AdjustQuantity, 0)) as RemainQuantity 
From   OV2400  
	            left join OV0309  on OV0309.OrderID = OV2400.OrderID and OV0309.InventoryID = OV2400.InventoryID	and OV0309.OTransactionID = OV2400.TransactionID  
Where OV2400.DivisionID = ''' + @DivisionID + ''' and ' +   
		case when @IsDate = 1 then  ' OV2400.OrderStatus not in (  4,9)   and 
		OV2400.VoucherDate  BETWEEN ''' + 					
		 convert(nvarchar(10), @FromDate, 101) + ''' and ''' +  convert(nvarchar(10), @ToDate, 101)  + ''' '
		else 	' OV2400.OrderStatus not in (9, 4)   and  
		OV2400.TranMonth + OV2400.TranYear*100 between ' +  cast(@FromMonth + @FromYear*100 as nvarchar(10)) +  ' and ' + 
		cast(@ToMonth + @ToYear*100 as nvarchar(10))   end +  
		  ' and  OV2400.InventoryID ' + case when @FromInventoryID = '%' then ' like ''%''' 
		else ' between ''' + @FromInventoryID + ''' and ''' + @ToInventoryID + ''''   end +
		  ' and  OV2400.ObjectID ' + case when @FromObjectID = '%' then ' like ''%''' 
		else ' between ''' + @FromObjectID + ''' and ''' + @ToObjectID + ''''   end +
		'and OV2400.Finish = 0'


--print @sSQL
If exists (Select top 1 1 From SysObjects Where name = 'OV0321' and Xtype ='V') 
	Drop view OV0321
Exec ('Create view OV0321  --tao boi OP0302
		as '+@sSQL)