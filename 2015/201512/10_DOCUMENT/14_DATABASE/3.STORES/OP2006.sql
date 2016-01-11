IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP2006]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP2006]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---Created by: Vo Thanh Huong, date: 07/09/2005
---purpose: IN PHIEU DIEU CHINH
---Modify on 15/07/2014 by Bảo Anh: Chuẩn hóa lại báo cáo
--- Modify on 07/08/2015 by Bảo Anh: Thay bảng tạm thành OT6666 do lỗi khi tạo view
/********************************************
'* Edited by: [GS] [Tố Oanh] [30/07/2010]
'********************************************/

CREATE PROCEDURE [dbo].[OP2006] @DivisionID nvarchar(50),
				@VoucherID nvarchar(50) 
 AS
DECLARE @sSQL varchar(max),
		@sSQL1 varchar(max),
		@OrderID nvarchar(50),
		@i int,
		@j int,
		@cur cursor,
		@AdjustQuantity decimal(28,8),
		@AdjustPrice decimal(28,8),
		@VoucherID_TAM nvarchar(50),
		@RefTransactionID nvarchar(50)

Select @OrderID = RefOrderID From OT2006 Where DivisionID = @DivisionID and VoucherID = @VoucherID 

----------------- OV2006 : Master, OV2007: Detail
------------------DataType : 0: Don hang, 1: Phieu dieu chinh, 2: Sau khi dieu chinh
Set @sSQL = 
'Select OT2006.VoucherID, 
		OT2006.DivisionID, 
		OT2006.TranMonth, 
		OT2006.TranYear, 
		OT2006.VoucherTypeID, 
		OT2006.VoucherNo, 
		OT2006.VoucherDate, 
		OT2006.CurrencyID, 
		OT2006.ExchangeRate, 
		OT2006.Description, 
		OT2006.ObjectID, 
		case when isnull(OT2006.ObjectName, '''') = '''' then AT1202.ObjectName else OT2006.ObjectName end as ObjectName,
		case when isnull(OT2006.Address, '''') = '''' then AT1202.Address else OT2006.Address end as Address,
		OT2006.DeliveryAddress, 
		OT2006.EmployeeID, 
		OT2006.OrderStatus, 		
		OT2006.RefOrderID, 
		OT2006.CreateDate, 
		OT2006.CreateUserID, 
		OT2006.LastModifyDate, 
		OT2006.LastModifyUserID,
		OT2006.Ana01ID, 
		OT2006.Ana02ID, 
		OT2006.Ana03ID, 
		OT2006.Ana04ID, 
		OT2006.Ana05ID, 
		OT1002_1.AnaName as Ana01Name, 
		OT1002_2.AnaName as Ana02Name, 
		OT1002_3.AnaName as Ana03Name, 
		OT1002_4.AnaName as Ana04Name, 
		OT1002_5.AnaName as Ana05Name, 
		AT1103.FullName		
From  OT2006		left join AT1202 on AT1202.ObjectID = OT2006.ObjectID and AT1202.DivisionID = OT2006.DivisionID
		left join OT1002 OT1002_1 on OT1002_1.AnaID = OT2006.Ana01ID and OT1002_1.AnaTypeID = ''P01'' and OT1002_1.DivisionID = OT2006.DivisionID
		left join OT1002 OT1002_2 on OT1002_2.AnaID = OT2006.Ana02ID and OT1002_2.AnaTypeID = ''P02'' and OT1002_2.DivisionID = OT2006.DivisionID
		left join OT1002 OT1002_3 on OT1002_3.AnaID = OT2006.Ana03ID and OT1002_3.AnaTypeID = ''P03'' and OT1002_3.DivisionID = OT2006.DivisionID
		left join OT1002 OT1002_4 on OT1002_4.AnaID = OT2006.Ana04ID and OT1002_4.AnaTypeID = ''P04'' and OT1002_4.DivisionID = OT2006.DivisionID
		left join OT1002 OT1002_5 on OT1002_5.AnaID = OT2006.Ana05ID and OT1002_5.AnaTypeID = ''P05'' and OT1002_5.DivisionID = OT2006.DivisionID
		inner join AT1004 on AT1004.CurrencyID = OT2006.CurrencyID and AT1004.DivisionID = OT2006.DivisionID
		left join AT1103 on AT1103.EmployeeID = OT2006.EmployeeID and AT1103.DivisionID = OT2006.DivisionID 	
Where OT2006.DivisionID like ''' + @DivisionID + ''' and  OT2006.VoucherID = ''' + @VoucherID + ''''

IF not exists (Select 1 From sysObjects Where XType = 'V' and Name = 'OV2006')
	EXEC('Create view OV2006    ----tao boi OP2006
			as ' + @sSQL)
ELSE 
	EXEC('Alter view OV2006    ----tao boi OP2006
			as ' + @sSQL)

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OT6666]') AND type in (N'U'))
	DROP TABLE OT6666
	
Create Table OT6666(  
    Orders int,
    VoucherID nvarchar(50),
    RefTransactionID nvarchar(50),
    AdjustPrice decimal(28,8),
    AdjustQuantity decimal(28,8)
)  
 Set @i=1  
 Set @j=1  
    
 Set @cur = cursor static for  
  Select VoucherID, RefTransactionID, AdjustPrice, AdjustQuantity From OT2007 Where DivisionID = @DivisionID And VoucherID = @VoucherID Order by InventoryID,DataType  
   
 Open @cur  
   
 Fetch Next From @cur Into @VoucherID_TAM, @RefTransactionID, @AdjustPrice, @AdjustQuantity  
 While @@Fetch_Status = 0  
 Begin  
    
  If @i%2=0  
   Begin  
    Update OT6666 Set AdjustQuantity = @AdjustQuantity Where Orders = @j  
    Set @j = @j + 1  
   End  
  Else  
   Begin  
    Insert Into OT6666 (VoucherID, RefTransactionID, Orders, AdjustPrice) Values (@VoucherID_TAM, @RefTransactionID, @j, @AdjustPrice)  
   End  
  Set @i = @i +1  
  Fetch Next From @cur Into @VoucherID_TAM, @RefTransactionID, @AdjustPrice, @AdjustQuantity  
 End
 
Set @sSQL =
'Select	distinct OT2002.DivisionID, 
		OT2007.VoucherID, 
		OT2002.InventoryID, 
		case when isnull(OT2002.InventoryCommonName, '''') = '''' then AT1302.InventoryName else 
		OT2002.InventoryCommonName end as InventoryName, 
		OT2002.UnitID, 
		AT1304.UnitName,
		isnull(OT2002.OrderQuantity, 0) as OrderQuantity,
		isnull(OT2002.SalePrice, 0) as SalePrice,
		isnull(OT2002.OriginalAmount,0) as OriginalAmount, 
		isnull(OT2002.ConvertedAmount,0) as ConvertedAmount,
		OT2002.IsPicking, 
		OT2002.WareHouseID, 
		OT2002.Description as TDescription, 
		OT2002.SOrderID as RefOrderID, 
		OT2007.RefTransactionID, 
		OT2002.Ana01ID, 
		OT2002.Ana02ID, 
		OT2002.Ana03ID, 
		NULL as Orders,
		0 as DataType 				
From OT2002
		inner join OT2007 on OT2002.TransactionID = OT2007.RefTransactionID and OT2002.DivisionID = OT2007.DivisionID
		inner join OT2006 on OT2007.VoucherID = OT2006.VoucherID and OT2007.DivisionID = OT2006.DivisionID
		left join AT1302 on AT1302.InventoryID = OT2007.InventoryID and AT1302.DivisionID = OT2007.DivisionID
		left join AT1304 on AT1304.UnitID = OT2007.UnitID and AT1304.DivisionID = OT2007.DivisionID
Where OT2006.DivisionID like ''' + @DivisionID + ''' and  OT2006.VoucherID = ''' + @VoucherID + '''

Union
Select	OT2007.DivisionID,
		OT2007.VoucherID, 
		OT2007.InventoryID, 
		case when isnull(OT2007.InventoryCommonName, '''') = '''' then AT1302.InventoryName else 
		OT2007.InventoryCommonName end as InventoryName, 
		OT2007.UnitID, 
		AT1304.UnitName,		
		isnull(OT2007.AdjustQuantity, 0)  as OrderQuantity,
		isnull(OT2007.AdjustPrice, 0)   as SalePrice,
		isnull(OT2007.OriginalAmount, 0) as OriginalAmount,
		isnull(OT2007.ConvertedAmount, 0) as ConvertedAmount,
		OT2007.IsPicking, 
		OT2007.WareHouseID, 
		OT2007.TDescription, 
		OT2007.RefOrderID, 
		OT2007.RefTransactionID, 
		OT2007.Ana01ID, 
		OT2007.Ana02ID, 
		OT2007.Ana03ID, 
		NULL as Orders,       	
		1 as DataType 				
From OT2007 inner join OT2006 on OT2007.VoucherID = OT2006.VoucherID and OT2007.DivisionID = OT2006.DivisionID
		left join AT1302 on AT1302.InventoryID = OT2007.InventoryID and AT1302.DivisionID = OT2007.DivisionID
		left join AT1304 on AT1304.UnitID = OT2007.UnitID and AT1304.DivisionID = OT2007.DivisionID
Where OT2006.DivisionID like ''' + @DivisionID + ''' and  OT2006.VoucherID = ''' + @VoucherID + ''''

Set @sSQL1 = '
Union
Select	OT2002.DivisionID,
		''' +  @VoucherID + ''' as VoucherID,  
		OT2002.InventoryID,
		case when isnull(OT2002.InventoryCommonName, '''') = '''' then AT1302.InventoryName else 
		OT2002.InventoryCommonName end as InventoryName, 
		OT2002.UnitID, 
		AT1304.UnitName,
		isnull(OT2007.AdjustQuantity, OT2002.OrderQuantity) as OrderQuantity ,
		isnull(OT2007.AdjustPrice, OT2002.SalePrice) as SalePrice,
		isnull(OT2007.AdjustQuantity, OT2002.OrderQuantity) * isnull(OT2007.AdjustPrice, OT2002.SalePrice) as  OriginalAmount, 
		isnull(OT2007.AdjustQuantity, OT2002.OrderQuantity) * isnull(OT2007.AdjustPrice, OT2002.SalePrice) * OT2006.ExchangeRate as ConvertedAmount,
		OT2002.IsPicking, 
		OT2002.WareHouseID, 
		OT2002.Description as TDescription, 
		OT2002.SOrderID as RefOrderID, 
		NULL as RefTransactionID, 
		OT2002.Ana01ID, 
		OT2002.Ana02ID, 
		OT2002.Ana03ID,  
		NULL as Orders,		
		2 as DataType 				
From OT2002 
	Inner join OT6666 OT2007 on OT2002.TransactionID = OT2007.RefTransactionID
	inner join OT2006 on OT2007.VoucherID = OT2006.VoucherID
	left join AT1302 on AT1302.InventoryID = OT2002.InventoryID and AT1302.DivisionID = OT2002.DivisionID
	left join AT1304 on AT1304.UnitID = OT2002.UnitID and AT1304.DivisionID = OT2002.DivisionID
Where OT2006.DivisionID like ''' + @DivisionID + ''' and OT2006.VoucherID = ''' + @VoucherID + ''''

---Print @sSQL

IF not exists (Select 1 From sysObjects Where XType = 'V' and Name = 'OV2007')
	EXEC('Create view OV2007    ----tao boi OP2006
			as ' + @sSQL + @sSQL1)
ELSE 
	EXEC('Alter view OV2007    ----tao boi OP2006
			as ' + @sSQL + @sSQL1)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON