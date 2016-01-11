/****** Object:  StoredProcedure [dbo].[AP2503]    Script Date: 07/29/2010 09:17:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO







--Created by: Vo Thanh Huong, date : 12/05/2005
---purpose: Tao du lieu ke thua  tu don hang ban, DON HANG HIEU CHINH ,  du tru cho PX
-- Last Edit: Thuy Tuyen, date 11/09/2008, 10/07/2009

/********************************************
'* Edited by: [GS] [Hoàng Phước] [28/07/2010]
'********************************************/
-- Last Edit: Thien Huynh, date 10/05/2012: Bo sung 5 Khoan muc
-- Modified by Tiểu Mai, on 03/11/2015: Bổ sung 20 quy cách hàng hóa.


ALTER PROCEDURE [dbo].[AP2503]  @DivisionID nvarchar(50),
				@OrderID nvarchar(50),
				@Type nvarchar(20)	,  ---'SO' don hang ban, 'ES' du tru, 'AS' DON HANG BAN DIEU CHINH
				@VoucherID nvarchar(50)				

AS
DECLARE @sSQL1 nvarchar(4000),
		@sSQL2 nvarchar(4000),
		@OrderID_Old nvarchar(50)

Select @OrderID_Old =  isnull(OrderID,'') From AT2007 Where DivisionID = @DivisionID and VoucherID = @VoucherID 

IF isnull(@VoucherID, '') <> '' and isnull(@OrderID_Old, '') = isnull(@OrderID,'') 
BEGIN
	Set @sSQL1 = N'Select T02.ObjectID, T00.InventoryID,  T01.InventoryName, T01.UnitID,
		T00.ActualQuantity as Quantity,  T00.UnitPrice, 
		OriginalAmount, T00.ConvertedAmount, T01.IsSource, T01.IsLocation, T01.SalesAccountID, T01.IsLimitDate, 
		T01.AccountID,  T01.PrimeCostAccountID, T01.MethodID, T01.IsStocked,  
		T00.Ana01ID, T00.Ana02ID, T00.Ana03ID, T00.Ana04ID, T00.Ana05ID, 
		T00.Ana06ID, T00.Ana07ID, T00.Ana08ID, T00.Ana09ID, T00.Ana10ID, 
		T00.Orders, T00.OTransactionID, T00.Notes, T02.DivisionID,
		O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
		O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID '
		
	Set @sSQL2=N'
	From AT2007 T00  inner join AT2006  T02 on T00.VoucherID =  T02.VoucherID and T00.DivisionID =  T02.DivisionID	
		inner  join AT1302 T01 on T00.InventoryID = T01.InventoryID and T00.DivisionID = T01.DivisionID
		left join WT8899 O99 on O99.DivisionID = T00.DivisionID and O99.VoucherID = T00.VoucherID and O99.TransactionID = T00.TransactionID 
	Where  T02.DivisionID = ''' + @DivisionID + ''' and 
		T00.VoucherID = ''' + @VoucherID  + '''' 
END
ELSE
BEGIN
IF @Type = 'SO'
BEGIN
	Set @sSQL1 = N'
	Select T02.ObjectID, T02.CurrencyID, T00.InventoryID, T01.InventoryName, T01.UnitID, 		
		V00.EndQuantity as Quantity,	 T00.SalePrice as UnitPrice, 
		case when V00.EndQuantity= V00.OrderQuantity then isnull(T00.OriginalAmount,0) - isnull(T00.DiscountOriginalAmount, 0)  else
		V00.EndQuantity*T00.SalePrice*(100- T00.DiscountPercent)/100	end as OriginalAmount , 	  
		case when  V00.EndQuantity= V00.OrderQuantity then  isnull(T00.ConvertedAmount,0) - isnull(T00.DiscountConvertedAmount, 0) else 
		V00.EndQuantity*T00.SalePrice*ExchangeRate*(100- T00.DiscountPercent)/100	end 	as ConvertedAmount,
		T00.DiscountPercent, T00.DiscountConvertedAmount, T01.IsSource, T01.IsLocation, T01.SalesAccountID, T01.IsLimitDate, 
		T01.AccountID, T01.PrimeCostAccountID, T01.MethodID, T01.IsStocked,  
		T00.Ana01ID, T00.Ana02ID, T00.Ana03ID, T00.Ana04ID, T00.Ana05ID, 
		T00.Ana06ID, T00.Ana07ID, T00.Ana08ID, T00.Ana09ID, T00.Ana10ID, 
		T00.Orders ,T00.TransactionID , T00.Notes, T02.DivisionID,
		O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
		O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID'
		
	Set @sSQL2 = N'
	From OT2002 T00  inner join OT2001 T02 on T00.SOrderID =  T02.SOrderID and T00.DivisionID =  T02.DivisionID
		inner join OV2901 V00 on V00.SOrderID = T00.SOrderID and V00.TransactionID = T00.TransactionID and V00.DivisionID = T00.DivisionID 
		inner  join AT1302 T01 on T00.InventoryID = T01.InventoryID and T00.DivisionID = T01.DivisionID
		left join OT8899 O99 on O99.DivisionID = T00.DivisionID and O99.VoucherID = T00.SOrderID and O99.TransactionID = T00.TransactionID 
  
	Where  T02.DivisionID = ''' + @DivisionID + ''' and 
		T00.SOrderID = ''' + @OrderID + '''  and 
		V00.EndQuantity > 0  and
		 T01.IsStocked <> 0'
END	
ELSE
	IF @Type = 'ES'
	BEGIN
		Set @sSQL1 = N'
		Select '''' as ObjectID, '''' as CurrencyID,  T00.MaterialID as InventoryID, T01.InventoryName,  T01.UnitID, 
			0 as IsEditInventoryName, isnull(EndQuantity, 0)  as Quantity, 0 as UnitPrice, 
			NULL as CommissionPercent, 	0 as OriginalAmount , 	0 as ConvertedAmount,
			0 as DiscountPercent, 0 as DiscountConvertedAmount, T01.IsSource, 
			T01.IsLocation, T01.SalesAccountID, T01.IsLimitDate,
			T01.AccountID,  T01.PrimeCostAccountID, T01.MethodID, T01.IsStocked,  
			NULL as Ana01ID, NULL as Ana02ID, NULL as Ana03ID, NULL as Ana04ID, NULL as Ana05ID, 
			NULL as Ana06ID, NULL as Ana07ID, NULL as Ana08ID, NULL as Ana09ID, NULL as Ana10ID, 
			Orders , T00.TransactionID, null  as Notes, T00.DivisionID,
			'''' as S01ID, '''' as S02ID, '''' as S03ID, '''' as S04ID, '''' as S05ID, '''' as S06ID, '''' as S07ID, '''' as S08ID, '''' as S09ID, '''' as S10ID,
			'''' as S11ID, '''' as S12ID, '''' as S13ID, '''' as S14ID, '''' as S15ID, '''' as S16ID, '''' as S17ID, '''' as S18ID, '''' as S19ID, '''' as S20ID '
		
		Set @sSQL2 = N'
		From OT2203 T00  Left Join AT1302 T01 on T01.InventoryID = T00.MaterialID and T01.DivisionID = T00.DivisionID
			inner join OV2903 V00 on V00.EstimateID = T00.EstimateID and V00.TransactionID = T00.TransactionID and V00.DivisionID = T00.DivisionID 
		Where  T00.DivisionID = ''' + @DivisionID + ''' and 
			T00.EstimateID = ''' + @OrderID + ''' and 
			T00.ExpenseID = ''COST001'''
	END
	ELSE  ---DON HANG BAN DIEU CHINH
	BEGIN
		Set @sSQL1 = N'
		Select T02.ObjectID, T02.CurrencyID, T00.InventoryID, T01.InventoryName, T01.UnitID, 		
			V00.EndQuantity as Quantity,	 T00.AdjustPrice as UnitPrice, 
			NULL as CommissionPercent, 
			case when V00.EndQuantity = V00.OrderQuantity then isnull(T00.OriginalAmount,0) else
			V00.EndQuantity*T00.AdjustPrice end as OriginalAmount , 	  
			case when  V00.EndQuantity= V00.OrderQuantity then  isnull(T00.ConvertedAmount,0)  else 
			V00.EndQuantity*T00.AdjustPrice*ExchangeRate	end as ConvertedAmount,
			0 as DiscountPercent, 0 as DiscountConvertedAmount, T01.IsSource, 
			T01.IsLocation, T01.SalesAccountID, T01.IsLimitDate, 
			T01.AccountID, T01.PrimeCostAccountID, T01.MethodID, T01.IsStocked,  
			T00.Ana01ID, T00.Ana02ID, T00.Ana03ID, T00.Ana04ID, T00.Ana05ID, 
			T00.Ana06ID, T00.Ana07ID, T00.Ana08ID, T00.Ana09ID, T00.Ana10ID, 
			T00.Orders , T00.TransactionID, T00.Notes, T02.DivisionID,
			O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
			O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID '
		
		Set @sSQL2 = N'
		From OT2007 T00  inner join OT2006 T02 on T00.VoucherID =  T02.VoucherID and T00.DivisionID =  T02.DivisionID
			inner join OV2904  V00 on V00.OrderID = T00.VoucherID and V00.TransactionID = T00.TransactionID and V00.DivisionID = T00.DivisionID 
			inner  join AT1302 T01 on T00.InventoryID = T01.InventoryID and T00.DivisionID = T01.DivisionID
			left join OT8899 O99 on O99.DivisionID = T00.DivisionID and O99.VoucherID = T00.VoucherID and O99.TransactionID = T00.TransactionID 
		Where  T02.DivisionID = ''' + @DivisionID + ''' and 
			T00.VoucherID = ''' + @OrderID + '''  and 
			T00.DataType = 2 and 
			V00.EndQuantity > 0 and 
			T00.AdjustQuantity>0'
	END
END

---print @sSQL1 + @sSQL2
If Exists (Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'AV2503')
	Drop view AV2503
	
	
EXEC('Create view AV2503   ---tao boi AP2503
		as ' + @sSQL1 + @sSQL2)