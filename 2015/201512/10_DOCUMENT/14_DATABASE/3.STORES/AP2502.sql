/****** Object:  StoredProcedure [dbo].[AP2502]    Script Date: 08/05/2010 09:43:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO





---Created by: Vo Thanh Huong, date : 21/04/2005
---purpose: Tao du lieu ke thua  tu don hang mua cho phieu mua hang
--Edit : Thuy Tuyen , them OTransactionID,22/06/2009

/********************************************
'* Edited by: [GS] [Minh Lâm] [29/07/2010]
'********************************************/


ALTER PROCEDURE [dbo].[AP2502]
       @DivisionID nvarchar(50) ,
       @OrderID nvarchar(50) ,
       @Type nvarchar(50) , ---'PO'
       @VATGroupID nvarchar(50) ,
       @VoucherID nvarchar(50)
AS
DECLARE
        @sSQL nvarchar(4000) ,
        @VATRate decimal(28,8) ,
        @OrderID_Old nvarchar(50)


SELECT
    @OrderID_Old = isnull(OrderID , '')
FROM
    AT2007
WHERE
    DivisionID = @DivisionID AND VoucherID = @VoucherID
SELECT
    @VATRate = isnull(VATRate , 0)
FROM
    AT1010
WHERE
    DivisionID = @DivisionID AND VATGroupID = @VATGroupID

SET @VATRate = isnull(@VATRate , 0)

IF isnull(@VoucherID , '') <> '' AND isnull(@OrderID_Old , '') = isnull(@OrderID , '')
   BEGIN
         SET @sSQL = 'Select T02.ObjectID, T00.InventoryID,  T01.InventoryName, T01.UnitID, 
		T00.ActualQuantity as Quantity,  T00.UnitPrice, 
		OriginalAmount, T00.ConvertedAmount, T01.IsSource, T01.IsLocation, T01.SalesAccountID, T01.IsLimitDate, 
		T01.AccountID,  T01.PrimeCostAccountID, T01.MethodID, T01.IsStocked,  T00.Ana01ID, T00.Ana02ID, T00.Ana03ID, '''' as Ana04ID, '''' as Ana05ID, T00.Orders, T00.OTransactionID,
		'''' as BDescription, T02.DivisionID
	From AT2007 T00  inner join AT2006  T02 on T00.VoucherID =  T02.VoucherID and T00.DivisionID =  T02.DivisionID	
		inner  join AT1302 T01 on T00.InventoryID = T01.InventoryID and T00.DivisionID = T01.DivisionID  
	Where  T02.DivisionID = ''' + @DivisionID + ''' and 
		T00.VoucherID = ''' + @VoucherID + ''''
         PRINT @sSQL
   END
ELSE
   BEGIN
         SET @sSQL = 'Select T02.ObjectID, T02.CurrencyID, T00.InventoryID, isnull(T00.InventoryCommonName, T01.InventoryName)  as InventoryName1,  
		T01.InventoryName  as InventoryName ,  
		case when isnull(T00.InventoryCommonName, '''') = '''' then 0 else 1 end  as  IsEditInventoryName, T01.UnitID,
		V00.EndQuantity as Quantity,
		T00.PurchasePrice  as UnitPrice, 
		case when V00.EndQuantity = V00.OrderQuantity then isnull(T00.OriginalAmount,0) - isnull(T00.DiscountOriginalAmount, 0) 
			else EndQuantity*T00.PurchasePrice*(100- T00.DiscountPercent)/100 end  as OriginalAmount , 	  
		case when V00.EndQuantity = V00.OrderQuantity then isnull(T00.ConvertedAmount,0) - isnull(T00.DiscountConvertedAmount, 0)
			else V00.EndQuantity*T00.PurchasePrice*T02.ExchangeRate*(100- T00.DiscountPercent)/100 end   as ConvertedAmount,
		T00.DiscountPercent, T00.DiscountConvertedAmount, 
		NULL as CommissionPercent,
		T01.IsSource, 	T01.IsLocation, T01.IsLimitDate,
		T01.AccountID, T01.MethodID, T01.IsStocked,  T00.Ana01ID, T00.Ana02ID, T00.Ana03ID, T00.Ana04ID, T00.Ana05ID, T00.Orders , T00.TransactionID as OTransactionID,
		T02.notes as BDescription, T02.DivisionID
	From OT3002 T00  inner join OT3001  T02 on T00.POrderID =  T02.POrderID and T00.DivisionID =  T02.DivisionID
		inner join OV2902 V00 on V00.POrderID = T00.POrderID and V00.TransactionID = T00.TransactionID and V00.DivisionID = T00.DivisionID 
		inner  Join AT1302 T01 on T00.InventoryID = T01.InventoryID and T00.DivisionID = T01.DivisionID  
	Where  T02.DivisionID = ''' + @DivisionID + ''' and 
		T00.POrderID = ''' + @OrderID + '''  and 
		V00.EndQuantity > 0 ' + CASE
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 WHEN isnull(@VATGroupID , '') <> '' THEN ' and T00.VATPercent = ' + CAST(@VATRate AS nvarchar(50))
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 ELSE ''
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            END
   END
PRINT @sSQL
IF EXISTS ( SELECT TOP 1
                1
            FROM
                sysObjects
            WHERE
                XType = 'V' AND Name = 'AV2502' )
   BEGIN
         DROP VIEW AV2502
   END
EXEC ( 'Create view AV2502   ---tao boi AP2501 
as '+@sSQL )