/****** Object:  StoredProcedure [dbo].[AP2505]    Script Date: 07/29/2010 09:19:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

---Created by: Vo Thanh Huong, date: 4/01/2006
---Purpose: Tao du lieu ke thua phieu dieu chinh tu don hang cho hang ban tra lai

/********************************************
'* Edited by: [GS] [Hoàng Phước] [28/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP2505]  @DivisionID nvarchar(50),
				@OrderID nvarchar(50),
				@Type nvarchar(20), ---'SO' don hang ban, 'AS' DON HANG HIEU CHINH
				@VATGroupID nvarchar(50),
				@VoucherID nvarchar(50)								
AS 

DECLARE @sSQL1 nvarchar(4000),
	@sSQL2 nvarchar(4000),
	@VATRate decimal(28, 8),
	@OrderID_Old nvarchar(50)

Select @OrderID_Old =  isnull(OrderID,'') From AT2007 Where DivisionID = @DivisionID and VoucherID = @VoucherID 
Select @VATRate  = isnull(VATRate,0)   From AT1010 Where VATGroupID = @VATGroupID 
	
IF isnull(@VoucherID, '') <> '' and isnull(@OrderID_Old, '') = isnull(@OrderID,'') 
BEGIN
Set @sSQL1 = N'
Select 		AT2006.ObjectID, 
		AT2007.InventoryID,  
		AT1302.InventoryName, 
		AT1302.UnitID, 
		AT2007.ActualQuantity as Quantity,  
		AT2007.UnitPrice, 
		OriginalAmount, 
		AT2007.ConvertedAmount, 
		AT1302.IsSource, 
		AT1302.IsLocation, 
		AT1302.SalesAccountID, 
		AT1302.IsLimitDate, 
		AT1302.AccountID,  
		AT1302.PrimeCostAccountID, 
		AT1302.MethodID, 
		AT1302.IsStocked,  
		AT2007.Ana01ID, 
		AT2007.Ana02ID, 
		AT2007.Ana03ID, 
		'''' as Ana04ID, 
		'''' as Ana05ID, 
		AT2007.Orders, AT2006.DivisionID '
Set @sSQL2 = N'
From AT2007  inner join AT2006  on AT2007.VoucherID =  AT2006.VoucherID	and AT2007.DivisionID =  AT2006.DivisionID	
		inner  join AT1302  on AT2007.InventoryID = AT1302.InventoryID and AT2007.DivisionID = AT1302.DivisionID  
Where  AT2006.DivisionID = ''' + @DivisionID + ''' and 
		AT2007.VoucherID = ''' + @VoucherID  + '''' 
END
ELSE
IF @Type = 'AS'  --DON HANG HIEU CHINH
BEGIN
	Set @sSQL1 =N'
	Select T02.ObjectID, T02.CurrencyID, T00.InventoryID, 
		case when isnull(T00.InventoryCommonName, '''') = ''''  then T01.InventoryName else T00.InventoryCommonName end  as InventoryName,
		case when isnull(T00.InventoryCommonName, '''') = '''' then 0 else 1 end  as  IsEditInventoryName,  T01.UnitID, 		
		V00.EndQuantity as Quantity,	 case when T00.DataType = 1 then 0 else T00.AdjustPrice end  as UnitPrice, 		
		NULL as CommissionPercent, 
		case when T00.DataType = 1 then V00.EndOriginalAmount else 
		case when   V00.EndQuantity = abs(V00.OrderQuantity) then abs(isnull(T00.OriginalAmount,0)) else
		V00.EndQuantity*abs(T00.AdjustPrice) end end as OriginalAmount , 	  
		case when T00.DataType = 1 then V00.EndConvertedAmount else 
		case when  V00.EndQuantity = abs(V00.OrderQuantity) then abs(isnull(T00.OriginalAmount,0)) else
		V00.EndQuantity*abs(T00.AdjustPrice)*ExchangeRate	 end end as ConvertedAmount,			
			0 as DiscountPercent, 0 as DiscountConvertedAmount, T01.IsSource, 
			T01.IsLocation, T01.SalesAccountID, T01.IsLimitDate, 
			T01.AccountID, T01.PrimeCostAccountID, T01.MethodID, T01.IsStocked,  T00.Ana01ID, T00.Ana02ID, T00.Ana03ID, 
			NULL as Ana04ID, NULL as  Ana05ID, T00.Orders, T02.DivisionID '
			
	Set @sSQL2 = N'
		From OT2007 T00  inner join OT2006 T02 on T00.VoucherID =  T02.VoucherID and T00.DivisionID =  T02.DivisionID
			inner join OV2904  V00 on V00.OrderID = T00.VoucherID and V00.TransactionID = T00.TransactionID and V00.DivisionID = T00.DivisionID
			inner  join AT1302 T01 on T00.InventoryID = T01.InventoryID  and T00.DivisionID = T01.DivisionID
		Where  T02.DivisionID = ''' + @DivisionID + ''' and 
			T00.VoucherID = ''' + @OrderID + '''  and 
			T00.AdjustQuantity <= case when T00.DataType = 2 then 0 else T00.AdjustQuantity end and
			T00.AdjustPrice <= case when T00.DataType = 1 then 0 else T00.AdjustPrice end and
			V00.EndQuantity > case when T00.DataType = 2 then 0 else -1 end and
			V00.EndConvertedAmount > case when T00.DataType = 1 then 0 else - 1 end'
END


--print @sSQL1 + @sSQL2
If Exists (Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'AV2505')
	Drop view AV2505
EXEC('Create view AV2505   ---tao boi AP2505
		as ' + @sSQL1 + @sSQL2)