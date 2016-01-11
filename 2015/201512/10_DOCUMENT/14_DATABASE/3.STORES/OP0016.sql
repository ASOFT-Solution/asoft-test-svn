
/****** Object:  StoredProcedure [dbo].[OP0016]    Script Date: 12/16/2010 14:15:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


---- Created by Nguyen Thuy Tuyen
---- Date 26/10/2006
---- Purpose: Lay du lieu cho man hinh truy van yeu cau mua hang
---- Last Edit  ThuyTuyen, date 09/01/2008 lay them truong OT3102.PriceList, 18/06/2009
---- Edit by B.Anh, date 20/08/2009, sua loi ten MPT o master kg len du lieu,23/10/2009
--- Edit by B.Anh, date 30/12/2009	Lay truong RefTransactionID
--- Edit Thuy Tuyen, Date 25/01/2010
-- Edited Việt Khánh: Do store procedure tạo view có lọc theo @DivisionID nên sẽ sinh ra lỗi khi nhiều client cùng thao tác. 
--   Giải pháp: tách OV0021 và OV0022 thành 2 view chết, điều kiện lọc sẽ đưa vào trong câu select view

/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[OP0016] @DivisionID nvarchar(50)
 AS
--Declare @sSQL1 as nvarchar(4000),
--	@sSQL11 as nvarchar(4000),
--	@sSQL2 as nvarchar(4000),
--	@sSQL22 as nvarchar(4000)

------- Buoc  1 : Tra ra thong tin Master View OV0021


--Set @sSQL1 = N' 
--	select OT3101.ROrderID, 
--		OT3101.VoucherTypeID, 
--		OT3101.VoucherNo, 
--		OT3101.DivisionID, 
--		OT3101.TranMonth, 
--		OT3101.TranYear,
--		OT3101.OrderDate, 
--		OT3101.ContractNo, 
--		OT3101.ContractDate, 
--		OT3101.InventoryTypeID, 
--		InventoryTypeName,  
--		OT3101.CurrencyID, 
--		CurrencyName, 	
--		OT3101.ExchangeRate,  
--		OT3101.PaymentID, 

--		OT3101.ObjectID,  
--		ISNULL(OT3101.ObjectName, AT1202.ObjectName)   as ObjectName, 
--		ISNULL(OT3101.VatNo, AT1202.VatNo)  as VatNo, 
--		ISNULL(OT3101.Address, AT1202.Address)  as Address,
--		OT3101.ReceivedAddress, 
--		OT3101.ClassifyID, 
--		ClassifyName, 
--		OT3101.EmployeeID,  
--		AT1103.FullName,  
--		OT3101.Transport, 
--		IsUpdateName, 
--		IsCustomer, 
--		IsSupplier,
--		ConvertedAmount = (Select Sum(ISNULL(ConvertedAmount,0)- ISNULL(DiscountConvertedAmount,0) +
--		ISNULL(VATConvertedAmount, 0))  FROM OT3102 Where OT3102.ROrderID = OT3101.ROrderID),
--		OriginalAmount = (Select Sum(ISNULL(OriginalAmount,0)- ISNULL(DiscountOriginalAmount,0)  +
--		ISNULL(VAToriginalAmount, 0))  FROM OT3102 Where OT3102.ROrderID = OT3101.ROrderID),
--		OT3101.Description, 
--		OT3101.Disabled, 
--		OT3101.OrderStatus, 
--		OV1001.Description as OrderStatusName, 
--		OV1001.EDescription as EOrderStatusName, 
--		OT3101.OrderType,  
--		OV1002.Description as OrderTypeName,
--		Ana01ID, 
--		Ana02ID, 
--		Ana03ID, 
--		Ana04ID, 
--		Ana05ID, 
--		OT1002_1.AnaName as Ana01Name, 
--		OT1002_2.AnaName as Ana02Name, 
--		OT1002_3.AnaName as Ana03Name, 
--		OT1002_4.AnaName as Ana04Name, 
--		OT1002_5.AnaName as Ana05Name, '
		
--Set @sSQL11 = N' 
--		OT3101.CreateUserID, 
--		OT3101.CreateDate, 

--		AT1103_2.FullName as SalesManName, 
--		ShipDate, 
--		OT3101.LastModifyUserID, 
--		OT3101.LastModifyDate, 
--		OT3101.DueDate ,
--		OT3101.SOrderID,
--		OT1102.Description as  IsConfirm,
--		OT1102.EDescription as EIsConfirm,
--		OT3101.DescriptionConfirm
		
	
--FROM OT3101 LEFT JOIN AT1202 ON AT1202.ObjectID = OT3101.ObjectID AND AT1202.DivisionID = OT3101.DivisionID
--		LEFT JOIN OT1002 OT1002_1 ON OT1002_1.AnaID = OT3101.Ana01ID AND OT1002_1.AnaTypeID = ''P01'' AND OT1002_1.DivisionID = OT3101.DivisionID
--		LEFT JOIN OT1002 OT1002_2 ON OT1002_2.AnaID = OT3101.Ana02ID AND OT1002_2.AnaTypeID = ''P02''  AND OT1002_2.DivisionID = OT3101.DivisionID
--		LEFT JOIN OT1002 OT1002_3 ON OT1002_3.AnaID = OT3101.Ana03ID AND OT1002_3.AnaTypeID = ''P03''   AND OT1002_3.DivisionID = OT3101.DivisionID
--		LEFT JOIN OT1002 OT1002_4 ON OT1002_4.AnaID = OT3101.Ana04ID AND OT1002_4.AnaTypeID = ''P04''  AND OT1002_4.DivisionID = OT3101.DivisionID
--		LEFT JOIN OT1002 OT1002_5 ON OT1002_5.AnaID = OT3101.Ana05ID AND OT1002_5.AnaTypeID = ''P05''  AND OT1002_5.DivisionID = OT3101.DivisionID
--		LEFT JOIN AT1301 ON AT1301.InventoryTypeID = OT3101.InventoryTypeID  AND AT1301.DivisionID = OT3101.DivisionID
--		LEFT JOIN AT1004 ON AT1004.CurrencyID = OT3101.CurrencyID AND AT1004.DivisionID = OT3101.DivisionID
--		LEFT JOIN AT1103 ON AT1103.EmployeeID = OT3101.EmployeeID AND AT1103.DivisionID = OT3101.DivisionID 
--		LEFT JOIN AT1103 AT1103_2 ON AT1103_2.EmployeeID = OT3101.EmployeeID AND AT1103_2.DivisionID = OT3101.DivisionID 
--		--LEFT JOIN AT1102 ON AT1102.DepartmentID = OT3101.DepartmentID  AND AT1102.DivisionID = OT3101.DivisionID
--		LEFT JOIN OT1001 ON OT1001.ClassifyID = OT3101.ClassifyID AND OT1001.TypeID = ''RO'' AND OT1001.DivisionID = OT3101.DivisionID
--		LEFT JOIN OV1001 ON OV1001.OrderStatus = OT3101.OrderStatus AND OV1001.TypeID = case WHEN OT3101.OrderType <> 1 THEN ''RO'' ELSE 
--									''MO'' END AND OV1001.DivisionID = OT3101.DivisionID
--		LEFT JOIN OV1002 ON OV1002.OrderType = OT3101.OrderType AND OV1002.TypeID = ''RO'' AND OV1002.DivisionID = OT3101.DivisionID

--		LEFT JOIN OT1102 ON OT1102.Code = OT3101.IsConfirm AND OT1102.TypeID = ''SO'' AND OT1102.DivisionID = OT3101.DivisionID
--		Where  OT3101.DivisionID = ''' + @DivisionID + ''''		

------ Buoc  2 : Tra ra thong tin Detail View OV0022

--Set @sSQL2 = N'
--Select 	OT3102.DivisionID, 
--		OT3102.ROrderID, 
--		OT3102.TransactionID, 
--		OT3101.VoucherTypeID, 
--		VoucherNo, 
--		OrderDate,  
--		ContractNo, 
--		ContractDate, 
--		OT3101.InventoryTypeID, 
--		InventoryTypeName, 
--		IsStocked,
--		OT3102.InventoryID, 
--		AT1302.InventoryName as AInventoryName, 
--		case WHEN ISNULL(OT3102.InventoryCommonName, '''') = '''' THEN AT1302.InventoryName ELSE OT3102.InventoryCommonName END as 
--		InventoryName, 		
--		ISNULL(OT3102.UnitID,AT1302.UnitID) as  UnitID,
--		ISNULL(T04.UnitName,AT1304.UnitName) as  UnitName,
--		OT3102.OrderQuantity, 
--		RequestPrice, 
--		ConvertedAmount, 
--		OriginalAmount, 
--		VATConvertedAmount, 
--		VATOriginalAmount, 
--		OT3102.VATPercent, 
--		DiscountConvertedAmount,  
--		DiscountOriginalAmount,'
		
--Set @sSQL22 = N'
--		OT3102.Ana01ID,
--		OT3102.Ana02ID,
--		OT3102.Ana03ID,
--		OT3102.Ana04ID,
--		OT3102.Ana05ID,
--		OT3102.DiscountPercent,
--		OT3102.Orders, 				
--		OT3102.Notes,
--		OT3102.Notes01,
--		OT3102.Notes02,
--		OT3102.PriceList,
--		OT3102.Finish,
--		OT3102.ConvertedQuantity,OT3102.ConvertedSaleprice,
--		OT3102.RefTransactionID
		
--FROM OT3102 LEFT JOIN AT1302 ON AT1302.InventoryID = OT3102.InventoryID	and OT3102.DivisionID = AT1302.DivisionID
--		inner join OT3101 ON OT3101.ROrderID = OT3102.ROrderID AND OT3102.DivisionID = OT3101.DivisionID
--		LEFT JOIN AT1301 ON AT1301.InventoryTypeID = OT3101.InventoryTypeID AND OT3102.DivisionID = AT1301.DivisionID
--		LEFT JOIN AT1304 ON AT1304.UnitID = AT1302.UnitID AND OT3102.DivisionID = AT1304.DivisionID
--		LEFT JOIN AT1304  T04 ON T04.UnitID = OT3102.UnitID  AND OT3102.DivisionID = T04.DivisionID
--		'
			
-----Print @sSQL1
--If not Exists(Select 1 FROM SysObjects Where Xtype = 'V' AND Name = 'OV0021')
--	Exec('Create View OV0021 ---tao boi OP0016
--		 as '+@sSQL1+@sSQL11)
--Else
--	Exec('Alter View OV0021 ---tao boi OP0016
--		 as '+@sSQL1+@sSQL11)



--If not Exists(Select 1 FROM SysObjects Where Xtype = 'V' AND Name = 'OV0022')
--	Exec('Create View OV0022  --tao boi OP0016
--		as '+@sSQL2+@sSQL22)
--Else
--	Exec('Alter View OV0022 --- tao boi OP0016
--		as '+@sSQL2+@sSQL22)