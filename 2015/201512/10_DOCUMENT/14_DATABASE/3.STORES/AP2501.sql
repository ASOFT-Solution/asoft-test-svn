/****** Object:  StoredProcedure [dbo].[AP2501]    Script Date: 08/05/2010 09:43:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/********************************************
'* Edited by: [GS] [Minh Lâm] [02/08/2010]
'********************************************/
---Created by: Vo Thanh Huong, date : 21/04/2005
---purpose: Tao du lieu ke thua  tu don hang  cho hoa don ban hang

ALTER PROCEDURE [dbo].[AP2501]
       @DivisionID nvarchar(50) ,
       @OrderID nvarchar(50) ,
       @Type nvarchar(50) , ---'SO' don hang ban, 'ES' du tru, 'AS': DON HANG BAN DIEU CHINH
       @VATGroupID nvarchar(50) ,
       @VoucherID nvarchar(50)
AS
DECLARE
        @sSQLSelect nvarchar(4000) ,
        @sSQLFrom nvarchar(4000) ,
        @sSQLWhere nvarchar(4000) ,
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
    VATGroupID = @VATGroupID

IF isnull(@VoucherID , '') <> '' AND isnull(@OrderID_Old , '') = isnull(@OrderID , '')
   BEGIN
         SET @sSQLSelect = 'Select T02.ObjectID,'''' as VATObjectID ,T00.InventoryID,  T01.InventoryName, T01.UnitID, 
		T00.ActualQuantity as Quantity,  T00.UnitPrice, 
		OriginalAmount, T00.ConvertedAmount, T01.IsSource, T01.IsLocation, T01.SalesAccountID, T01.IsLimitDate, 
		T01.AccountID,  T01.PrimeCostAccountID, T01.MethodID, T01.IsStocked,  T00.Ana01ID, T00.Ana02ID, T00.Ana03ID, 
		NULL as Ana04ID, NULL as Ana05ID, T00.Orders, '''' as VATNo, T02.DivisionID '

         SET @sSQLFrom = '	From AT2007 T00  inner join AT2006  T02 on T00.VoucherID =  T02.VoucherID and T00.DivisionID =  T02.DivisionID
		inner  join AT1302 T01 on T00.InventoryID = T01.InventoryID and T00.DivisionID = T01.DivisionID '

         SET @sSQLWhere = ' Where  T02.DivisionID = ''' + @DivisionID + ''' and 
		T00.VoucherID = ''' + @VoucherID + ''''
   END
ELSE
   BEGIN


         IF @Type = 'SO'
            BEGIN
                  SET @sSQLSelect = 'Select T02.ObjectID, T02.VATObjectID, T02.CurrencyID, T00.InventoryID, 
		isnull(T00.InventoryCommonName, T01.InventoryName)  as InventoryName, T01.UnitID, 
		case when isnull(T00.InventoryCommonName, '''') = '''' then 0 else 1 end  as  IsEditInventoryName, 
		V00.EndQuantity as Quantity,	 T00.SalePrice as UnitPrice, T00.CommissionPercent,
		case when V00.EndQuantity= V00.OrderQuantity then isnull(T00.OriginalAmount,0) - isnull(T00.DiscountOriginalAmount, 0)  else
		V00.EndQuantity*T00.SalePrice*(100- T00.DiscountPercent)/100	end as OriginalAmount , 	  
		case when  V00.EndQuantity= V00.OrderQuantity then  isnull(T00.ConvertedAmount,0) - isnull(T00.DiscountConvertedAmount, 0) else 
		V00.EndQuantity*T00.SalePrice*ExchangeRate*(100- T00.DiscountPercent)/100	end 	as ConvertedAmount,
		T00.DiscountPercent, T00.DiscountConvertedAmount, T01.IsSource, T01.IsLocation, T01.SalesAccountID, T01.IsLimitDate, 
		T01.AccountID, T01.MethodID, T01.IsStocked,  T00.Ana01ID, T00.Ana02ID, T00.Ana03ID, T00.Ana04ID, T00.Ana05ID, T00.Orders ,V00.DueDate,
		V00.ShipDate, V00.DueDays, T02.VATNo,T02.PaymentID, T02.PaymenttermID, T02.DivisionID '

                  SET @sSQLFrom = ' From OT2002 T00  inner join OT2001 T02 on T00.SOrderID =  T02.SOrderID and T00.DivisionID =  T02.DivisionID
		inner join OV2901 V00 on V00.SOrderID = T00.SOrderID and V00.TransactionID = T00.TransactionID and V00.DivisionID = T00.DivisionID
		inner  join AT1302 T01 on T00.InventoryID = T01.InventoryID and T00.DivisionID = T01.DivisionID '
                  SET @sSQLWhere = ' Where  T02.DivisionID = ''' + @DivisionID + ''' and 
		T00.SOrderID = ''' + @OrderID + '''  and 
		V00.EndQuantity > 0 ' + CASE
                                                                                                                                                                       WHEN isnull(@VATGroupID , '') <> '' THEN ' and T00.VATPercent = ' + CAST(@VATRate AS varchar(100))
                                                                                                                                                                       ELSE ''
                                                                                                                                                                  END
            END
         ELSE
            BEGIN
                  IF @Type = 'ES' --DU TRU NVL
                     BEGIN
                           SET @sSQLSelect = 'Select '''' as ObjectID, '''' as VATObjectID, '''' as CurrencyID,  T00.MaterialID as InventoryID, T01.InventoryName,  T01.UnitID, 
		0 as IsEditInventoryName,sum(isnull(EndQuantity, 0))  as Quantity, 0 as UnitPrice, 
		NULL as CommissionPercent, 	0 as OriginalAmount , 	0 as ConvertedAmount,
		0 as DiscountPercent, 0 as DiscountConvertedAmount, T01.IsSource, 
		T01.IsLocation, T01.SalesAccountID, T01.IsLimitDate,
		T01.AccountID, T01.MethodID, T01.IsStocked,  
		NULL as Ana01ID, NULL as Ana02ID, NULL as Ana03ID, NULL as Ana04ID, 
		NULL as Ana05ID, 0 as Orders ,'''' as VATNo, T00.DivisionID '
                           SET @sSQLFrom = ' From OT2203 T00  Left Join AT1302 T01 on T01.InventoryID = T00.MaterialID and T01.DivisionID = T00.DivisionID
		inner join OV2903 V00 on V00.EstimateID = T00.EstimateID and V00.TransactionID = T00.TransactionID and V00.TransactionID = T00.TransactionID'
                           SET @sSQLWhere = ' Where  T00.DivisionID = ''' + @DivisionID + ''' and 
		T00.EstimateID = ''' + @OrderID + '''
	Group by T00.MaterialID, T01.IsSource, T01.IsLocation, T01.InventoryName, T01.SalesAccountID, T01.IsLimitDate,
		T01.AccountID, T01.MethodID, T01.IsStocked, T01.UnitID, T02.DivisionID '
                     END
                  ELSE
                     BEGIN                           SET @sSQLSelect = '	Select   T02.ObjectID, '''' as VATObjectID,T02.CurrencyID, T00.InventoryID, 
		case when isnull(T00.InventoryCommonName, '''') = ''''  then T01.InventoryName else T00.InventoryCommonName end  as InventoryName,
		case when isnull(T00.InventoryCommonName, '''') = '''' then 0 else 1 end  as  IsEditInventoryName, 
		T01.UnitID, 	V00.EndQuantity as Quantity,	 
		case when T00.DataType = 1 then 0 else T00.AdjustPrice end  as UnitPrice, 
		NULL as CommissionPercent, 
		case when T00.DataType = 1 then V00.EndOriginalAmount else 
		case when   V00.EndQuantity = V00.OrderQuantity then isnull(T00.OriginalAmount,0) else
		V00.EndQuantity*T00.AdjustPrice end end as OriginalAmount , 	  
		case when T00.DataType = 1 then V00.EndConvertedAmount else 
		case when  V00.EndQuantity = V00.OrderQuantity then isnull(T00.OriginalAmount,0) else
		V00.EndQuantity*T00.AdjustPrice*ExchangeRate end end	as ConvertedAmount,
		0 as DiscountPercent, 0 as DiscountConvertedAmount, T01.IsSource, 
		T01.IsLocation, T01.SalesAccountID, T01.IsLimitDate, 
		T01.AccountID, T01.PrimeCostAccountID, T01.MethodID, T01.IsStocked,  T00.Ana01ID, T00.Ana02ID, T00.Ana03ID, 
		NULL as Ana04ID, NULL as  Ana05ID, T00.Orders ,'''' as VATNo, T02.DivisionID '
                     END
            END
   END
SET @sSQLFrom = ' From OT2007 T00  inner join OT2006 T02 on T00.VoucherID =  T02.VoucherID and T00.DivisionID =  T02.DivisionID
		inner join OV2904  V00 on V00.OrderID = T00.VoucherID and V00.TransactionID = T00.TransactionID and V00.DivisionID = T00.DivisionID 
		inner  join AT1302 T01 on T00.InventoryID = T01.InventoryID and T00.DivisionID = T01.DivisionID '

SET @sSQLWhere = ' Where  T02.DivisionID = ''' + @DivisionID + ''' and 
		T00.VoucherID = ''' + @OrderID + '''  and 
		T00.AdjustQuantity >= case when T00.DataType = 2 then 0 else T00.AdjustQuantity  end and 
		T00.AdjustPrice >= case when T00.DataType = 1 then 0 else T00.AdjustPrice end and 
		V00.EndQuantity > case when T00.DataType = 2 then 0  else -1 end and 
		V00.EndOriginalAmount > case when T00.DataType = 1 then 0 else -1 end AND
		V00.EndConvertedAmount > case when T00.DataType = 1 then 0 else -1 end '
PRINT @sSQLSelect + @sSQLFrom + @sSQLWhere

IF EXISTS ( SELECT TOP 1
                1
            FROM
                sysObjects
            WHERE
                XType = 'V' AND Name = 'AV2501' )
   BEGIN
         DROP VIEW AV2501
   END
EXEC ( 'Create view AV2501   ---tao boi AP2501	
as '+@sSQLSelect+@sSQLFrom+@sSQLWhere )