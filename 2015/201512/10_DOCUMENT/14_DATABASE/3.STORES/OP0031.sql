
/****** Object:  StoredProcedure [dbo].[OP0031]    Script Date: 12/16/2010 14:20:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




---op0031 'DNC','BZZ0001',2,2008,2,2008,0

---- Created by Thuy Tuyen
---- Date 26/05/2009
---- Purpose: Loc ra cac phieu chao gia cho man hinh duyet don hang 
---- Date: 2/11/2009 , lay truong IsConfirmName, Date 25/01/2009

/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[OP0031]  @DivisionID nvarchar(50),
			 @ObjectID nvarchar (50),
			 @FromMonth  int,
			 @FromYear int,
			 @ToMonth int,
			 @ToYear int ,
			 @IsCheck tinyint
 AS
Declare @sSQL1 as nvarchar(4000),
	@sSQL11 as nvarchar(4000),
	@sSQL2 as nvarchar(4000),
	@sSQL22 as nvarchar(4000),
	@sWhere as nvarchar(500)
If @IsCheck  = 1
 Set @sWhere = ''
Else
 Set @sWhere = ' 
				and  OT2101.IsConfirm = 0 '

----- Buoc  1 : Tr? ra thông tin Master View OV0031

Set @sSQL1 =N' 
Select OT2101.QuotationID, 
	OT2101.QuotationNo, 
	OT2101.DivisionID, 
	OT2101.TranMonth, 
	OT2101.TranYear,
	QuotationDate,  
	OT2101.InventoryTypeID, 
	InventoryTypeName,  	
	OT2101.ObjectID,  
	case when isnull(OT2101.ObjectName, '''') <> '''' then OT2101.ObjectName else AT1202.ObjectName end as ObjectName, 	
	OT2101.EmployeeID,  
	AT1103.FullName,  
	OriginalAmount = (Select Sum(isnull(OriginalAmount,0) + isnull(VATOriginalAmount, 0) - isnull(DiscountOriginalAmount, 0))  
			From OT2102 Where OT2102.QuotationID = OT2101.QuotationID),
	ConvertedAmount = (Select Sum(isnull(ConvertedAmount,0) + isnull(VATConvertedAmount, 0) - isnull(DiscountConvertedAmount, 0))  
			From OT2102 Where OT2102.QuotationID = OT2101.QuotationID),

	OT2101.Disabled, 
	OT2101.OrderStatus, 
	OV1001.Description as OrderStatusName, 
	OV1001.EDescription as EOrderStatusName, 
	OT2101.RefNo1, 
	OT2101.RefNo2, 
	OT2101.RefNo3, 
	Attention1, 
	Attention2, 
	Dear, 
	Condition, 
	SaleAmount, 
	PurchaseAmount,		
	OT2101.CurrencyID, 
	CurrencyName, 
	OT2101.ExchangeRate,
	Ana01ID, 
	Ana02ID, 
	Ana03ID,
	Ana04ID, 
	Ana05ID,
	OT1002_1.AnaName as Ana01Name, 
	OT1002_2.AnaName as Ana02Name, 
	OT1002_3.AnaName as Ana03Name,
	OT1002_4.AnaName as Ana04Name,
	OT1002_5.AnaName as Ana05Name,
	OT2101.CreateUserID, 
	OT2101.CreateDate, 
	OT2101.LastModifyUserID, 
	OT2101.LastModifyDate, 
	IsSO,OT2101.Description, 
	OT2101.VoucherTypeID,
	OT2101.EndDate, 
	OT2101.Transport, 
	OT2101.DeliveryAddress, '
	
Set @sSQL11 =N' 
	case when isnull(OT2101.Address,'''') <> '''' then OT2101.Address else AT1202.Address end as Address,
	OT2101.PaymentID, 
	OT2101.PaymentTermID,
	OT2101.ApportionID,
	OT2101. IsConfirm  ,

	OT1102.Description as  IsConfirmName,
	OT1102.EDescription as EIsConfirmName,

	OT2101.DescriptionConfirm
	

From OT2101 left join AT1202 on AT1202.ObjectID = OT2101.ObjectID
	left join AT1004 on AT1004.CurrencyID = OT2101.CurrencyID
	left join AT1301 on AT1301.InventoryTypeID = OT2101.InventoryTypeID 
	left join AT1103 on AT1103.EmployeeID = OT2101.EmployeeID and AT1103.DivisionID = OT2101.DivisionID 
	left join OV1001 on OV1001.OrderStatus = OT2101.OrderStatus and OV1001.TypeID = ''SO''
	left join OT1002 OT1002_1 on OT1002_1.AnaID = OT2101.Ana01ID and OT1002_1.AnaTypeID = ''S01''
	left join OT1002 OT1002_2 on OT1002_2.AnaID = OT2101.Ana02ID and OT1002_2.AnaTypeID = ''S02''
	left join OT1002 OT1002_3 on OT1002_3.AnaID = OT2101.Ana03ID and OT1002_3.AnaTypeID = ''S03''
	left join OT1002 OT1002_4 on OT1002_4.AnaID = OT2101.Ana04ID and OT1002_4.AnaTypeID = ''S04''
	left join OT1002 OT1002_5 on OT1002_5.AnaID = OT2101.Ana05ID and OT1002_5.AnaTypeID = ''S05''
	left join OT1102 on OT1102.Code = OT2101.IsConfirm and OT1102.TypeID = ''SO''
	
Where OT2101.ObjectID like  '''+ @ObjectID+''' 
  and OT2101.TranMonth + OT2101.TranYear * 100 between '+str(@FromMonth)+' + '+str(@Fromyear)+' *100 and  '+str(@ToMonth)+' + '+str(@Toyear)+' *100
  and OT2101.DivisionID = '''+ @DivisionID+'''
  and OT2101.QuotationID  not in(select distinct isnull (QuotationID,'''') from OT2002 )--chi cac phieu chua ke thua sang don hang ban'
  
--Set @sSQL1 = @sSQL1 + @sWhere

---- Buoc  2 : Tra ra thong tin Detail View OV0032

Set @sSQL2= N'
Select OT2102.DivisionID,
	OT2102.QuotationID, 
	OT2102.TransactionID, 
	QuotationNo, 
	QuotationDate,  
	OT2101.InventoryTypeID, 
	AT1301.InventoryTypeName,
	case when isnull(OT2102.InventoryCommonName, '''') = '''' then  AT1302.InventoryName else OT2102.InventoryCommonName end as InventoryName, 
	OT2102.InventoryID, 
	AT1302.UnitID, 
	AT1304.UnitName, 
	QuoQuantity, 
	OT2102.UnitPrice, 
	OriginalAmount, 
	OT2102.VATPercent,  
	OT2102.Notes, 
	VATOriginalAmount, 
	OT2102.DiscountPercent, 
	OT2102.DiscountOriginalAmount, '
	
Set @sSQL22= N'
	OT2102.Orders, 
	0 as ActualQuantity, 
	0 as RemainQuantity,
	ConvertedAmount, 
	VATConvertedAmount, 
	DiscountConvertedAmount,
	
	OT2102.Notes01,			
	OT2102.Notes02,
	OT2102.VATGroupID		
From OT2102 left join AT1302 on AT1302.InventoryID= OT2102.InventoryID
	inner join OT2101 on OT2101.QuotationID = OT2102.QuotationID
	left join AT1301 on AT1301.InventoryTypeID = OT2101.InventoryTypeID 	
	left join AT1304 on AT1304.UnitID = AT1302.UnitID'

---print @sSQL1

If not Exists (Select 1 From SysObjects Where Xtype ='V' and Name = 'OV0031')
	Exec('Create View OV0031 ---tao boi OP0031
		 as '+@sSQL1+@sSQL11+ @sWhere)Else
	Exec('Alter View OV0031 ---tao boi OP0031
		 as '+@sSQL1+@sSQL11+ @sWhere)

If not Exists (Select 1 From SysObjects Where Xtype ='V' and Name = 'OV0032')
	Exec('Create View OV0032  --tao boi OP0031
		as '+@sSQL2+@sSQL22)

Else
	Exec('Alter View OV0032  --- tao boi OP0031
		as '+@sSQL2+@sSQL22)