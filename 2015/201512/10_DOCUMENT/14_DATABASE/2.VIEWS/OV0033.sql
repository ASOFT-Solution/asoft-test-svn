IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OV0033]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[OV0033]
GO
/****** Object:  View [dbo].[OV0033]    Script Date: 12/16/2010 15:49:52 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[OV0033]  --tao boi OP0033
		as  
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
		'' as Ana01ID, 
		'' as Ana02ID, 
		'' as Ana03ID, 
		'' as Ana04ID, 
		'' as Ana05ID, 
		'' as Ana01Name, 
		''as Ana02Name, 
		'' as Ana03Name, 
		'' as Ana04Name, 
		'' as Ana05Name, 
		OT2001.CreateUserID, 
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
		OT2001.DEscriptionConfirm 
From OT2001 left join AT1202 on AT1202.ObjectID = OT2001.ObjectID
		 left join AT1202 T02 on T02.ObjectID = OT2001.VATObjectID
		-------left join OT1002 OT1002_1 on OT1002_1.AnaID = OT2001.Ana01ID and OT1002_1.AnaTypeID = 'S01'
		---------left join OT1002 OT1002_2 on OT1002_2.AnaID = OT2001.Ana02ID and OT1002_2.AnaTypeID = 'S02'
		---------left join OT1002 OT1002_3 on OT1002_3.AnaID = OT2001.Ana03ID and OT1002_3.AnaTypeID = 'S03'
		--------left join OT1002 OT1002_4 on OT1002_4.AnaID = OT2001.Ana04ID and OT1002_4.AnaTypeID = 'S04'
		---------left join OT1002 OT1002_5 on OT1002_5.AnaID = OT2001.Ana05ID and OT1002_5.AnaTypeID = 'S05'
		left join AT1301 on AT1301.InventoryTypeID = OT2001.InventoryTypeID 
		left join AT1004 on AT1004.CurrencyID = OT2001.CurrencyID
		left join AT1103 on AT1103.EmployeeID = OT2001.EmployeeID and AT1103.DivisionID = OT2001.DivisionID 
		------------left join AT1103 AT1103_2 on AT1103_2.EmployeeID = OT2001.EmployeeID and AT1103_2.DivisionID = OT2001.DivisionID 
		left join AT1102 on AT1102.DepartmentID = OT2001.DepartmentID  and AT1102.DivisionID = OT2001.DivisionID
		left join OT1001 on OT1001.ClassifyID = OT2001.ClassifyID and OT1001.TypeID = 'SO' 
		left join OT1101 OV1001  on OV1001.OrderStatus = OT2001.OrderStatus and OV1001.TypeID = case when OT2001.OrderType <> 1 then 'SO' else 
									'MO' end 
		left join OV1002 on OV1002.OrderType = OT2001.OrderType and OV1002.TypeID ='SO'
		left join OT1102 on OT1102.Code = OT2001.IsConfirm and OT1102.TypeID = 'SO'
		Where  OT2001.DivisionID = '1' And OT2001.OrderType = 0
			 and OT2001.TranMonth + OT2001.TranYear * 100 between         11 +          1 *100 and           1 +          1 *100
			  and OT2001.ObjectID like '1'
			  and OT2001.SOrderID  not in (select distinct isnull(OrderID,'')  from AT9000 )--chi cac phieu chua ke thua sang hoa  don  ban hang 
  

GO


