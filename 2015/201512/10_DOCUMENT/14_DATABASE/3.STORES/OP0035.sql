
/****** Object:  StoredProcedure [dbo].[OP0035]    Script Date: 12/16/2010 14:22:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

---- Created by Nguyen Thuy Tuyen
---- Date 26/05/2009
---- Purpose: Lay du lieu cho man hinh  Duyet  yeu cau mua hang
---- Edit by B.Anh, date 20/08/2009, sua loi ten MPT o master kg len du lieu
----Edit: Thuy Tuyen  2/11/2009 , lay truong IsConfirmName, 25/01/2010


/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[OP0035]  @DivisionID nvarchar(50)	,
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
 Set @sWhere = ' and  OT3101.IsConfirm = 0 '

----- Buoc  1 : Tra ra thong tin Master View OV0035


Set @sSQL1 =N' 
	select Distinct OT3101.ROrderID, 
		OT3101.VoucherTypeID, 
		OT3101.VoucherNo, 
		OT3101.DivisionID, 
		OT3101.TranMonth, 
		OT3101.TranYear,
		OT3101.OrderDate, 
		OT3101.ContractNo, 
		OT3101.ContractDate, 
		OT3101.InventoryTypeID, 
		InventoryTypeName,  
		OT3101.CurrencyID, 
		CurrencyName, 	
		OT3101.ExchangeRate,  
		OT3101.PaymentID, 

		OT3101.ObjectID,  
		isnull(OT3101.ObjectName, AT1202.ObjectName)   as ObjectName, 
		isnull(OT3101.VatNo, AT1202.VatNo)  as VatNo, 
		isnull( OT3101.Address, AT1202.Address)  as Address,
		OT3101.ReceivedAddress, 
		OT3101.ClassifyID, 
		ClassifyName, 
		OT3101.EmployeeID,  
		AT1103.FullName,  
		OT3101.Transport, 
		IsUpdateName, 
		IsCustomer, 
		IsSupplier,
		ConvertedAmount = (Select Sum(isnull(ConvertedAmount,0)- isnull(DiscountConvertedAmount,0) +
		isnull(VATConvertedAmount, 0))  From OT3102 Where OT3102.ROrderID = OT3101.ROrderID And OT3102.DivisionID = OT3101.DivisionID),
		OriginalAmount = (Select Sum(isnull(OriginalAmount,0)- isnull(DiscountOriginalAmount,0)  +
		isnull(VAToriginalAmount, 0))  From OT3102 Where OT3102.ROrderID = OT3101.ROrderID And OT3102.DivisionID = OT3101.DivisionID),
		OT3101.Description, 
		OT3101.Disabled, 
		OT3101.OrderStatus, 
		OV1001.Description as OrderStatusName, 
		OV1001.EDescription as EOrderStatusName, 
		OT3101.OrderType,  
		OV1002.Description as OrderTypeName,
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
		OT3101.CreateUserID, 
		OT3101.CreateDate, 

		AT1103_2.FullName as SalesManName, '
		
Set @sSQL11 =N' 
		ShipDate, 
		OT3101.LastModifyUserID, 
		OT3101.LastModifyDate, 
		OT3101.DueDate ,
		OT3101.SOrderID,
		OT3101.IsConfirm,
		
		OT1102.Description as  IsConfirmName,
		OT1102.EDescription as EIsConfirmName,

		OT3101.DescriptionConfirm
		
	
From OT3101 left join AT1202 on AT1202.ObjectID = OT3101.ObjectID And AT1202.DivisionID = OT3101.DivisionID
		left join OT1002 OT1002_1 on OT1002_1.AnaID = OT3101.Ana01ID and OT1002_1.AnaTypeID = ''P01'' And OT1002_1.DivisionID = OT3101.DivisionID
		left join OT1002 OT1002_2 on OT1002_2.AnaID = OT3101.Ana02ID and OT1002_2.AnaTypeID = ''P02'' And OT1002_2.DivisionID = OT3101.DivisionID
		left join OT1002 OT1002_3 on OT1002_3.AnaID = OT3101.Ana03ID and OT1002_3.AnaTypeID = ''P03'' And OT1002_3.DivisionID = OT3101.DivisionID
		left join OT1002 OT1002_4 on OT1002_4.AnaID = OT3101.Ana04ID and OT1002_4.AnaTypeID = ''P04'' And OT1002_4.DivisionID = OT3101.DivisionID
		left join OT1002 OT1002_5 on OT1002_5.AnaID = OT3101.Ana05ID and OT1002_5.AnaTypeID = ''P05'' And OT1002_5.DivisionID = OT3101.DivisionID
		left join AT1301 on AT1301.InventoryTypeID = OT3101.InventoryTypeID And AT1301.DivisionID = OT3101.DivisionID
		left join AT1004 on AT1004.CurrencyID = OT3101.CurrencyID And AT1004.DivisionID = OT3101.DivisionID
		left join AT1103 on AT1103.EmployeeID = OT3101.EmployeeID and AT1103.DivisionID = OT3101.DivisionID 
		left join AT1103 AT1103_2 on AT1103_2.EmployeeID = OT3101.EmployeeID and AT1103_2.DivisionID = OT3101.DivisionID 
		--left join AT1102 on AT1102.DepartmentID = OT3101.DepartmentID  and AT1102.DivisionID = OT3101.DivisionID
		left join OT1001 on OT1001.ClassifyID = OT3101.ClassifyID And OT1001.DivisionID = OT3101.DivisionID and OT1001.TypeID = ''RO'' 
		left join OV1001 on OV1001.OrderStatus = OT3101.OrderStatus And OV1001.DivisionID = OT3101.DivisionID and OV1001.TypeID = case when OT3101.OrderType <> 1 then ''RO'' else 
									''MO'' end 
		left join OV1002 on OV1002.OrderType = OT3101.OrderType And OV1002.DivisionID = OT3101.DivisionID and OV1002.TypeID =''RO''
		left join OT1102 on OT1102.Code = OT3101.IsConfirm and OT1102.TypeID = ''SO''
		

Where OT3101.ObjectID like '''+ @ObjectID+''' 
  and OT3101.TranMonth + OT3101.TranYear * 100 between '+str(@FromMonth)+' + '+str(@Fromyear)+' *100 and  '+str(@ToMonth)+' + '+str(@Toyear)+' *100
  and OT3101.DivisionID = '''+ @DivisionID+'''
  and OT3101.ROrderID  not in (select Distinct isnull(ROrderID,'''')  from OT3002 Where DivisionID = ''' + @DivisionID + ''')--chi cac phieu chua ke thua sang don hang mua
  
'
--Set @sSQL1 = @sSQL1 + @sWhere
	

---- Buoc  2 : Tra ra thong tin Detail View OV0036

Set @sSQL2= N'
Select Distinct	OT3102.DivisionID, 	
		OT3102.ROrderID, 
		OT3102.TransactionID, 
		OT3101.VoucherTypeID, 
		VoucherNo, 
		OrderDate,  
		ContractNo, 
		ContractDate, 
		OT3101.InventoryTypeID, 
		InventoryTypeName, 
		IsStocked,
		OT3102.InventoryID, 
		AT1302.InventoryName as AInventoryName, 
		case when isnull(OT3102.InventoryCommonName, '''') = '''' then AT1302.InventoryName else OT3102.InventoryCommonName end as 
		InventoryName, 		
		AT1302.UnitID, 
		UnitName, 
		OT3102.OrderQuantity, 
		RequestPrice, 
		ConvertedAmount, 
		OriginalAmount, 
		VATConvertedAmount, 
		VATOriginalAmount, 
		OT3102.VATPercent, 
		DiscountConvertedAmount,  
		DiscountOriginalAmount,'
		
Set @sSQL22= N'
		OT3102.Ana01ID,
		OT3102.Ana02ID,
		OT3102.Ana03ID,
		OT3102.Ana04ID,
		OT3102.Ana05ID,
		OT3102.DiscountPercent,
		OT3102.Orders, 				
		OT3102.Notes,
		OT3102.Notes01,
		OT3102.Notes02,
		OT3102.PriceList
		
From OT3102 left join AT1302 on AT1302.InventoryID= OT3102.InventoryID And 	AT1302.DivisionID= OT3102.DivisionID	
		inner join OT3101 on OT3101.ROrderID = OT3102.ROrderID And OT3101.DivisionID = OT3102.DivisionID
		left join AT1301 on AT1301.InventoryTypeID = OT3101.InventoryTypeID And AT1301.DivisionID = OT3101.DivisionID
		left join AT1304 on AT1304.UnitID = AT1302.UnitID And AT1304.DivisionID = AT1302.DivisionID'
			
---Print @sSQL1
If not Exists (Select 1 From SysObjects Where Xtype ='V' and Name = 'OV0035')
	Exec('Create View OV0035 ---tao boi OP0035
		 as '+@sSQL1+@sSQL11+@sWhere)
Else
	Exec('Alter View OV0035 ---tao boi OP0035
		 as '+@sSQL1+@sSQL11+@sWhere)



If not Exists (Select 1 From SysObjects Where Xtype ='V' and Name = 'OV0036')
	Exec('Create View OV0036  --tao boi OP0035
		as '+@sSQL2+@sSQL22)
Else
	Exec('Alter View OV0036 --- tao boi OP0035
		as '+@sSQL2+@sSQL22)