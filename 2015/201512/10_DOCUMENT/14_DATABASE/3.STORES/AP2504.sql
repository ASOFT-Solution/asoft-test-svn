/****** Object:  StoredProcedure [dbo].[AP2504]    Script Date: 07/29/2010 09:19:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO




--Created by: Vo Thanh Huong, date : 21/04/2005
---purpose: Tao du lieu ke thua  tu don hang mua, DON HÀNG DIEU CHINH  cho phieu nhap
-- 10/07/2009

/********************************************
'* Edited by: [GS] [Hoàng Phước] [28/07/2010]
'********************************************/
-- Last Edit: Thien Huynh, date 10/05/2012: Bo sung 5 Khoan muc

ALTER PROCEDURE [dbo].[AP2504]  @DivisionID nvarchar(50),
				@OrderID nvarchar(50),
				@Type nvarchar(20), ---'PO': DON HANG MUA, 'AS': DON HANG BAN DIEU CHINH
				@VoucherID nvarchar(50)

AS
DECLARE @sSQL1 nvarchar(4000),
	@sSQL2 nvarchar(4000),
	@OrderID_Old nvarchar(50)

Select @OrderID_Old =  isnull(OrderID,'') From AT2007 Where DivisionID = @DivisionID and VoucherID = @VoucherID 

IF isnull(@VoucherID, '') <> '' and isnull(@OrderID_Old, '') = isnull(@OrderID,'') 
BEGIN
	Set @sSQL1 = N'
	Select T02.ObjectID, T00.InventoryID,  T01.InventoryName, T01.UnitID, 
		T00.ActualQuantity as Quantity,  T00.UnitPrice, 
		OriginalAmount, T00.ConvertedAmount, T01.IsSource, T01.IsLocation, T01.SalesAccountID, T01.IsLimitDate, 
		T01.AccountID,  T01.PrimeCostAccountID, T01.MethodID, T01.IsStocked,  
		T00.Ana01ID, T00.Ana02ID, T00.Ana03ID, T00.Ana04ID, T00.Ana05ID, 
		T00.Ana06ID, T00.Ana07ID, T00.Ana08ID, T00.Ana09ID, T00.Ana10ID, 
		T00.Orders, OTransactionID as TransactionID, T00.Notes, T02.DivisionID '
	Set @sSQL2 = '
	From AT2007 T00  inner join AT2006  T02 on T00.VoucherID =  T02.VoucherID and T00.DivisionID =  T02.DivisionID
		inner  join AT1302 T01 on T00.InventoryID = T01.InventoryID T00.DivisionID = T01.DivisionID
	Where  T02.DivisionID = ''' + @DivisionID + ''' and 
		T00.VoucherID = ''' + @VoucherID  + '''' 
END	
ELSE
BEGIN
IF @Type = 'PO'
BEGIN
	Set @sSQL1 = N'
	Select T02.ObjectID, T02.CurrencyID, T00.InventoryID, T01.InventoryName,   T01.UnitID,
		V00.EndQuantity as Quantity,
		T00.PurchasePrice  as UnitPrice, 
		case when V00.EndQuantity = V00.OrderQuantity then isnull(T00.OriginalAmount,0) - isnull(T00.DiscountOriginalAmount, 0) 
			else EndQuantity*T00.PurchasePrice*(100- T00.DiscountPercent)/100 end  as OriginalAmount , 	  
		case when V00.EndQuantity = V00.OrderQuantity then isnull(T00.ConvertedAmount,0) - isnull(T00.DiscountConvertedAmount, 0)
			else V00.EndQuantity*T00.PurchasePrice*T02.ExchangeRate*(100- T00.DiscountPercent)/100 end   as ConvertedAmount,
		T01.IsSource, 	T01.IsLocation, T01.IsLimitDate,	T01.AccountID, T01.PrimeCostAccountID, 
		T01.MethodID, T01.IsStocked,  
		T00.Ana01ID, T00.Ana02ID, T00.Ana03ID, T00.Ana04ID, T00.Ana05ID, 
		T00.Ana06ID, T00.Ana07ID, T00.Ana08ID, T00.Ana09ID, T00.Ana10ID, 
		T00.Orders , T00.TransactionID,T00.Notes, T02.DivisionID'
	Set @sSQL2 = N'
	From OT3002 T00  inner join OT3001  T02 on T00.POrderID =  T02.POrderID and T00.DivisionID =  T02.DivisionID
		inner join OV2902 V00 on V00.POrderID = T00.POrderID and V00.TransactionID = T00.TransactionID and V00.DivisionID = T00.DivisionID 
		inner  Join AT1302 T01 on T00.InventoryID = T01.InventoryID and T00.DivisionID = T01.DivisionID  
	Where  T02.DivisionID = ''' + @DivisionID + ''' and 
		T00.POrderID = ''' + @OrderID + '''  and 
		V00.EndQuantity > 0 ' 
END
ELSE --DON HANG DIEU CHINH
BEGIN
	Set @sSQL1 = N'
	Select T02.ObjectID, T02.CurrencyID, T00.InventoryID, T01.InventoryName, T01.UnitID, 		
		V00.EndQuantity as Quantity,	 T00.AdjustPrice as UnitPrice, 
		case when V00.EndQuantity = V00.OrderQuantity then isnull(T00.OriginalAmount,0) else
		V00.EndQuantity*T00.AdjustPrice end as OriginalAmount , 	  
		case when  V00.EndQuantity= V00.OrderQuantity then  isnull(T00.ConvertedAmount,0)  else 
		V00.EndQuantity*T00.AdjustPrice*ExchangeRate	end as ConvertedAmount,
		0 as DiscountPercent, 0 as DiscountConvertedAmount, T01.IsSource, T01.IsLocation, T01.SalesAccountID, T01.IsLimitDate, 
		T01.AccountID, T01.PrimeCostAccountID, T01.MethodID, T01.IsStocked,  
		T00.Ana01ID, T00.Ana02ID, T00.Ana03ID, T00.Ana04ID, T00.Ana05ID, 
		T00.Ana06ID, T00.Ana07ID, T00.Ana08ID, T00.Ana09ID, T00.Ana10ID, 
		T00.Orders ,T00.OTransactionID as TransactionID,T00.Notes, T02.DivisionID '
	Set @sSQL2 = N'
	From OT2007 T00  inner join OT2006 T02 on T00.VoucherID =  T02.VoucherID and T00.DivisionID =  T02.DivisionID
		inner join OV2904  V00 on V00.OrderID = T00.VoucherID and V00.TransactionID = T00.TransactionID and V00.DivisionID = T00.DivisionID 
		inner  join AT1302 T01 on T00.InventoryID = T01.InventoryID and T00.DivisionID = T01.DivisionID  
	Where  T02.DivisionID = ''' + @DivisionID + ''' and 
		T00.VoucherID = ''' + @OrderID + '''  and 
		T00.DataType = 2 and T00.AdjustQuantity > 0 and V00.EndQuantity > 0 ' 
END
END

--print @sSQL1 + @sSQL2
If Exists (Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'AV2504')
	Drop view AV2504
EXEC('Create view AV2504   ---tao boi AP2504
		as ' + @sSQL1 + @sSQL2 )