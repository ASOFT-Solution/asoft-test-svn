
/****** Object:  StoredProcedure [dbo].[OP0039]    Script Date: 12/16/2010 14:24:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

---- Created by : Thuy Tuyen
---- Date : 30/10/2009
---- Purpose: Loc ra cac don hang ban cho man hinh duyet don hang San Xuat.
----Edit: Thuy Tuyen  2/11/2009 , lay truong IsConfirmName,25/01/2010
----Edit: Hoàng vũ  10/08/2010 , Bổ sung phần quyền xem dữ liệu của người khác
----Test: EXEC OP0039 'AS', '', 1, 2013, 12, 2016, 1, 'NV004'
/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/


ALTER PROCEDURE [dbo].[OP0039]  @DivisionID nvarchar(50),
				@ObjectID nvarchar (50),
				 @FromMonth  int,
				 @FromYear int,
				 @ToMonth int,
				 @ToYear int ,
				 @IsCheck tinyint,
				 @UserID nvarchar(50)
 AS
Declare @sSQL1 as nvarchar(4000),
	@sSQL2 as nvarchar(4000),
	@sWhere as nvarchar(500)

	----------------->>>>>> Phân quyền xem chứng từ của người dùng khác		
		DECLARE @sSQLPer AS NVARCHAR(MAX),
				@sWHEREPer AS NVARCHAR(MAX)
		SET @sSQLPer = ''
		SET @sWHEREPer = ''		

		IF EXISTS (SELECT TOP 1 1 FROM OT0001 WHERE DivisionID = @DivisionID AND IsPermissionView = 1) -- Nếu check Phân quyền xem dữ liệu tại Thiết lập hệ thống thì mới thực hiện
			BEGIN
				SET @sSQLPer = ' LEFT JOIN AT0010 ON AT0010.DivisionID = OT2001.DivisionID 
													AND AT0010.AdminUserID = '''+@UserID+''' 
													AND AT0010.UserID = OT2001.CreateUserID '
				SET @sWHEREPer = ' AND (OT2001.CreateUserID = AT0010.UserID
										OR  OT2001.CreateUserID = '''+@UserID+''') '		
			END

		-----------------<<<<<< Phân quyền xem chứng từ của người dùng khác		

If @IsCheck  = 1
 Set @sWhere = ''
Else
 Set @sWhere = ' and  OT2001.IsConfirm = 0 '
	
	----- Buoc  1 : Tra ra thong tin Master View OV0033 ( De load truy van)


Set @sSQL1 =N' 
Select OT2001.SOrderID, 
		OT2001.VoucherTypeID, 
		OT2001.VoucherNo, 
		OT2001.DivisionID, 
		OT2001.TranMonth, 
		OT2001.TranYear,
		OT2001.OrderDate, 
		OT2001.ContractNo, 
		OT2001.ContractDate, 
		OT2001.InventoryTypeID, 
		InventoryTypeName,  
		OT2001.CurrencyID, 
		CurrencyName, 	
		OT2001.ExchangeRate,  
		OT2001.PaymentID, 
		OT2001.DepartmentID,  
		AT1102.DepartmentName, 
		IsPeriod, 
		IsPlan, 
		OT2001.ObjectID,  
		isnull(OT2001.ObjectName, AT1202.ObjectName)   as ObjectName, 
		isnull(OT2001.VatNo, AT1202.VatNo)  as VatNo, 
		isnull( OT2001.Address, AT1202.Address)  as Address,
		OT2001.DeliveryAddress, 
		OT2001.ClassifyID, 
		ClassifyName, 
		OT2001.InheritSOrderID,
		OT2001.EmployeeID,  
		AT1103.FullName,  
		OT2001.Transport, 
		AT1202.IsUpdateName, 
		AT1202.IsCustomer, 
		AT1202.IsSupplier,
		ConvertedAmount = (Select Sum(isnull(ConvertedAmount,0)- isnull(DiscountConvertedAmount,0)- isnull(CommissionCAmount,0) +
		isnull(VATConvertedAmount, 0))  From OT2002 Where OT2002.SOrderID = OT2001.SOrderID),
		OriginalAmount = (Select Sum(isnull(OriginalAmount,0)- isnull(DiscountOriginalAmount,0) - isnull(CommissionOAmount, 0) +
		isnull(VAToriginalAmount, 0))  From OT2002 Where OT2002.SOrderID = OT2001.SOrderID),
		OT2001.Notes, 
		OT2001.Disabled, 
		OT2001.OrderStatus, 
		OV1001.Description as OrderStatusName, 
		OV1001.EDescription as EOrderStatusName, 
		QuotationID,
		OT2001.OrderType,  
		OV1002.Description as OrderTypeName,
		'''' as Ana01ID, 
		'''' as Ana02ID, 
		'''' as Ana03ID, 
		'''' as Ana04ID, 
		'''' as Ana05ID, 
		'''' as Ana01Name, 
		''''as Ana02Name, 
		'''' as Ana03Name, 
		'''' as Ana04Name, 
		'''' as Ana05Name, 
		OT2001.CreateUserID, '
		
Set @sSQL2 =N' 
		OT2001.CreateDate, 
		SalesManID, 
		AT1103.FullName as SalesManName, 
		ShipDate, 
		OT2001.LastModifyUserID, 
		OT2001.LastModifyDate, 
		OT2001.DueDate, 
		OT2001.PaymentTermID,
		OT2001.contact,
		OT2001.VATObjectID,
		 isnull(OT2001.VATObjectName,T02.ObjectName) as  VATObjectName,
		OT2001.IsInherit,
		OT2001.IsConfirm,
		OT1102.Description as  IsConfirmName,
		OT1102.EDescription as EIsConfirmName,
		OT2001.DEscriptionConfirm,
		OT2001.PeriodID
From OT2001 left join AT1202 on AT1202.ObjectID = OT2001.ObjectID and AT1202.DivisionID = OT2001.DivisionID
		 left join AT1202 T02 on T02.ObjectID = OT2001.VATObjectID and T02.DivisionID = OT2001.DivisionID
		left join AT1301 on AT1301.InventoryTypeID = OT2001.InventoryTypeID and AT1301.DivisionID = OT2001.DivisionID
		left join AT1004 on AT1004.CurrencyID = OT2001.CurrencyID and AT1004.DivisionID = OT2001.DivisionID
		left join AT1103 on AT1103.EmployeeID = OT2001.EmployeeID and AT1103.DivisionID = OT2001.DivisionID 
		left join AT1102 on AT1102.DepartmentID = OT2001.DepartmentID  and AT1102.DivisionID = OT2001.DivisionID
		left join OT1001 on OT1001.ClassifyID = OT2001.ClassifyID and OT1001.TypeID = ''SO'' and OT1001.DivisionID = OT2001.DivisionID
		left join OT1101 OV1001  on OV1001.DivisionID = OT2001.DivisionID and OV1001.OrderStatus = OT2001.OrderStatus and OV1001.TypeID = case when OT2001.OrderType <> 1 then ''SO'' else 
									''MO'' end 
		left join OV1002 on OV1002.OrderType = OT2001.OrderType and OV1002.DivisionID = OT2001.DivisionID and OV1002.TypeID =''SO''
		left join OT1102 on OT1102.Code = OT2001.IsConfirm and OT1102.TypeID = ''SO''
		' + @sSQLPer+ '
		Where  OT2001.DivisionID = ''' + @DivisionID + ''' And OT2001.OrderType =1 '+ @sWHEREPer+ '
			 and OT2001.TranMonth + OT2001.TranYear * 100 between '+str(@FromMonth)+' + '+str(@Fromyear)+' *100 and  '+str(@ToMonth)+' + '+str(@Toyear)+' *100
			 and isnull(OT2001.ObjectID, '''') like '''+ @ObjectID+'''
			 and OT2001.SOrderID  not in (select distinct isnull(SOrderID,'''')  from  MQ2221 where isnull(InheritedQuantity,0)  <> 0  )--chi cac phieu chua ke thua sang ket qua san xuat
			  and OT2001.SOrderID  not in (select distinct isnull(InheritVoucherID,'''')  from  MT2008 where MT2008.DivisionID = OT2001.DivisionID  )--chi cac phieu chua ke thua sang phiếu giao việc (Customize cho secoin index = 43)
'
--Set @sSQL1 = @sSQL1 + @sWhere	


If exists (Select top 1 1 From SysObjects Where name = 'OV0039' and Xtype ='V') 
	Drop view OV0039
Exec ('Create view OV0039  --tao boi OP0039
		as '+@sSQL1+@sSQL2+ @sWhere	)
EXEC (@sSQL1+@sSQL2)
print @sSQL1
print @sSQL2

---- Buoc  2 : Tra ra thong tin Detail View OV0034

Set @sSQL1= N'
Select 	OT2002.DivisionID, 
		OT2002.SOrderID, 
		OT2002.TransactionID, 
		OT2001.VoucherTypeID, 
		VoucherNo, 
		OrderDate,  
		ContractNo, 
		ContractDate, 
		OT2001.InventoryTypeID, 
		InventoryTypeName, 
		IsStocked,
		OT2002.InventoryID, 
		AT1302.InventoryName as AInventoryName, 
		case when isnull(OT2002.InventoryCommonName, '''') = '''' then AT1302.InventoryName else OT2002.InventoryCommonName end as 
		InventoryName, 		
		AT1302.UnitID, AT1302.Barcode,
		UnitName, 
		OT2002.OrderQuantity, 
		SalePrice, 
		ConvertedAmount, 
		OriginalAmount, 
		VATConvertedAmount, 
		VATOriginalAmount, 
		OT2002.VATPercent, 
		DiscountConvertedAmount,  
		DiscountOriginalAmount,
		OT2002.DiscountPercent, 
		OT2002.CommissionPercent, 
		OT2002.CommissionCAmount, 
		OT2002.CommissionOAmount, 
		IsPicking, 
		OT2002.WareHouseID, 
		WareHouseName,  
		OT2002.AdjustQuantity, 
		Quantity01, Quantity02, Quantity03, Quantity04, Quantity05,
		Quantity06, Quantity07, Quantity08, Quantity09, Quantity10,
		Quantity11, Quantity12, Quantity13, Quantity14, Quantity15,
		Quantity16, Quantity17, Quantity18, Quantity19, Quantity20,
		Quantity21, Quantity22, Quantity23, Quantity24, Quantity25,
		Quantity26, Quantity27, Quantity28, Quantity29, Quantity30,		
		OT2003.Date01, OT2003.Date02, OT2003.Date03, OT2003.Date04, OT2003.Date05, 
		OT2003.Date06, OT2003.Date07, OT2003.Date08, OT2003.Date09, OT2003.Date10, 
		Date11, Date12, Date13, Date14, Date15, 
		Date16, Date17, Date18, Date19, Date20, 
		Date21, Date22, Date23, Date24, Date25, 
		Date26, Date27, Date28, Date29, Date30,'
		
Set @sSQL2= N'
		OT2002.LinkNo, 
		OT2002.EndDate, 
		OT2002.Orders, 
		OT2002.Description, 
		OT2002.RefInfor,
		OT2002.Ana01ID, 
		OT2002.Ana02ID, 
		OT2002.Ana03ID,
		OT2002.Ana04ID, 
		OT2002.Ana05ID,
		ActualQuantity, 
		EndQuantity as RemainQuantity,
		OT2002.Finish ,
		OT2002.Notes,
		OT2002.Notes01,
		OT2002.Notes02,
		OT2001.contact,
		OT2002.QuotationID,
		OT2002.VATGroupID,
		OT2002.SaleOffPercent01,
		OT2002.SaleOffAmount01,
		OT2002.SaleOffPercent02,
		OT2002.SaleOffAmount02,
		OT2002.SaleOffPercent03,
		OT2002.SaleOffAmount03,
		OT2002.SaleOffPercent04,
		OT2002.SaleOffAmount04,
		OT2002.SaleOffPercent05,
		OT2002.SaleOffAmount05
		
From OT2002 left join AT1302 on AT1302.InventoryID= OT2002.InventoryID and AT1302.DivisionID= OT2002.DivisionID
		inner join OT2001 on OT2001.SOrderID = OT2002.SOrderID and OT2001.DivisionID = OT2002.DivisionID And OT2001.OrderType =1
		left join AT1303 on AT1303.WareHouseID = OT2002.WareHouseID and AT1303.DivisionID = OT2001.DivisionID 
		left join AT1301 on AT1301.InventoryTypeID = OT2001.InventoryTypeID and AT1301.DivisionID = OT2001.DivisionID
		left join AT1304 on AT1304.UnitID = AT1302.UnitID and AT1304.DivisionID = AT1302.DivisionID
		left join OT2003 on OT2003.SOrderID = OT2001.SOrderID and OT2003.DivisionID = OT2001.DivisionID
		left join OV2901 on OV2901.SOrderID = OT2002.SOrderID and OV2901.TransactionID = OT2002.TransactionID and OV2901.DivisionID = OT2002.DivisionID '


If exists (Select top 1 1 From SysObjects Where name = 'OV0040' and Xtype ='V') 
	Drop view OV0040
Exec ('Create view OV0040  --tao boi OP0039
		as '+@sSQL1+@sSQL2)
