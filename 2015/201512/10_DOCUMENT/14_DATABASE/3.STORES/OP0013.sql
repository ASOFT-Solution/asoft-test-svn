
/****** Object:  StoredProcedure [dbo].[OP0013]    Script Date: 07/29/2010 18:00:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


---- Created by Vo Thanh Huong
---- Date 09/09/2004
---- Purpose: Loc ra cac don hang ban cho man hinh du toan don hang.

/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/


ALTER PROCEDURE [dbo].[OP0013]  

AS
Declare @sSQL1 as nvarchar(4000),
		 @sSQL2 as nvarchar(4000)

Set @sSQL1 = N'
Select 		OT2001.SOrderID, 
		OT2001.VoucherTypeID, 
		VoucherNo, 
		OT2001.DivisionID, 
		OT2001.TranMonth, 
		OT2001.TranYear,
		OrderDate, 
		ContractNo, 
		ContractDate, 
		OT2001.ObjectID,
		isnull(OT2001.ObjectName, 
		AT1202.ObjectName)  as ObjectName, 
		isnull(OT2001.VATNo, AT1202.VatNo) as VatNo,  
		DeliveryAddress, 
		OT2001.ClassifyID, 
		ClassifyName,
		OT2001.EmployeeID,  
		AT1103.FullName,  
		SalesManID,	
		OT4001.Sales, 
		(isnull(OT4001.PrimeCost, 0) + isnull(OT4001.OthersCost, 0) + isnull(OT4001.DiscountAmount, 0) + isnull(OT4001.CommissionAmount, 0)) as  TotalCosts,  
		(isnull(OT4001.Sales, 0) - isnull(OT4001.PrimeCost, 0) - isnull(OT4001.OthersCost, 0) - isnull(OT4001.DiscountAmount, 0)) as Profits, 
		OT2001.Notes, 
		OT2001.Disabled, 
		OT2001.OrderStatus, 
		OV1001.Description as OrderStatusName, 
		OV1001.EDescription as EOrderStatusName, 
		OT2001.OrderType,  
		OV1002.Description as OrderTypeName,
		Ana01ID, Ana02ID, 
		Ana03ID, 
		Ana04ID, 
		Ana05ID,
		OT2001.CreateUserID, 
		OT2001.CreateDate, 
		OT2001.LastModifyUserID, 
		OT2001.LastModifyDate'
		
Set @sSQL2 = '
From OT4001 
       inner join OT2001 ON OT2001.DivisionID = OT4001.DivisionID AND OT4001.SOrderID = OT2001.SOrderID 
		left join AT1202 ON AT1202.DivisionID = OT4001.DivisionID AND AT1202.ObjectID = OT2001.ObjectID		
		left join AT1004 ON AT1004.DivisionID = OT4001.DivisionID AND AT1004.CurrencyID = OT2001.CurrencyID
		left join AT1103 ON AT1103.DivisionID = OT4001.DivisionID AND AT1103.EmployeeID = OT2001.EmployeeID and AT1103.DivisionID = OT2001.DivisionID 
		left join OT1001 ON OT1001.DivisionID = OT4001.DivisionID AND OT1001.ClassifyID = OT2001.ClassifyID and OT1001.TypeID = ''SO''
		left join OV1001 ON OV1001.DivisionID = OT4001.DivisionID AND OV1001.OrderStatus = OT2001.OrderStatus and OV1001.TypeID = ''SO''
		left join OV1002 ON OV1002.DivisionID = OT4001.DivisionID AND OV1002.OrderType = OT2001.OrderType and OV1002.TypeID =''SO'''


If not exists (Select 1 From sysObjects Where XType = 'V' and Name = 'OV0023')
	exec('Create view OV0023 ---tao boi OP0013
			as ' + @sSQL1+@sSQL2)	
else
	exec('Alter view OV0023 ---tao boi OP0013
			as ' + @sSQL1+@sSQL2)