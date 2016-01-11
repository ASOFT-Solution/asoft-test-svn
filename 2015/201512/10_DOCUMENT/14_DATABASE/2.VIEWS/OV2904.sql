

/****** Object:  View [dbo].[OV2904]    Script Date: 12/16/2010 15:12:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

-----Created by: Vo Thanh Huong, date: 29/11/2005 
-----purpose: SO LUONG GIAO NHAN HANG CUA DON HANG HIEU CHINH

ALTER VIEW [dbo].[OV2904] as


--DON HANG HIEU CHINH
--LUONG 
Select		'AO' as Type, 
		T01.DivisionID, 
		T01.TranMonth, 
		T01.TranYear, 
		T00.VoucherID as OrderID,
		T01.OrderStatus, 
		T00.InventoryID as InventoryID, 
		T03.IsStocked,
		T00.TransactionID,
		T00.DataType,
		isnull(T00.AdjustQuantity, 0) as OrderQuantity, 
		isnull(T00.AdjustPrice,0)  as AdjustPrice,
		case when T03.IsStocked = 1 then isnull(T02.ActualQuantity, 0) else  isnull(T04.ActualQuantity, 0) end  as ActualQuantity,
		ABS(isnull(AdjustQuantity, 0)) - case when T03.IsStocked = 1 then isnull(T02.ActualQuantity, 0) else  isnull(T04.ActualQuantity, 0) end  AS EndQuantity,
 		0 as OriginalAmount, 
		0 as ConvertedAmount,
		0 as AOriginalAmount, 
		0 as AConvertedAmount,
		0 as EndOriginalAmount,
		0 as EndConvertedAmount
From  OT2007 T00 inner join OT2006 T01 on T00.VoucherID= T01.VoucherID 
	inner join AT1302 T03 on T03.InventoryID = T00.InventoryID
	left join  (--Giao hang SO cho mat hang co quan ly ton kho
		Select T00.OrderID, 	InventoryID, 	sum(ActualQuantity) as ActualQuantity
		From AT2007 T00 
			inner join AT2006 T01 on T00.VoucherID = T01.VoucherID
		Where  isnull(T00.OrderID, '') <> ''  ---PN: cho cac PHIEU DIEU CHINH TANG LUONG, 
						 ---PX: CHO CAC PHIEU DIEU CHINH GIAM LUONG
		Group by T00.OrderID, InventoryID
			) T02 	on T02.InventoryID = T00.InventoryID and 
			T02.OrderID = T00.VoucherID and 
			T03.IsStocked = 1
	left join  (--Giao hang SO cho mat hang dich vu
		Select T00.OrderID, 	InventoryID, 	sum(Quantity) as ActualQuantity
		From AT9000 T00 
		Where  isnull(T00.OrderID, '') <> ''  and TransactionTypeID in  ('T04', 'T24')
		Group by T00.OrderID, InventoryID
			) T04 	
			on T04.InventoryID = T00.InventoryID and 
			T04.OrderID = T00.VoucherID and 
			T03.IsStocked = 0	
Where OrderStatus not in (0, 3,4, 9) and 
		T01.Disabled = 0  and 
		T00.DataType = 2  --LUONG
		--and T00.Finish <> 1 
Union
Select		'AO' as Type, 
		T01.DivisionID, 
		T01.TranMonth, 
		T01.TranYear, 
		T00.VoucherID as OrderID,
		T01.OrderStatus, 
		T00.InventoryID as InventoryID, 
		9 as IsStocked,
		T00.TransactionID,
		T00.DataType,
		isnull(T00.AdjustQuantity, 0) as OrderQuantity, 
		isnull(T00.AdjustPrice, 0) as AdjustPrice,
		0  as ActualQuantity,
		0 as EndQuantity,
 		isnull(T00. OriginalAmount,0) as OriginalAmount, 
		isnull(T00.ConvertedAmount,0) as ConvertedAmount,
		isnull(T02.OriginalAmount,0) as AOriginalAmount, 
		isnull(T02.ConvertedAmount,0) as AConvertedAmount,
		abs(isnull(T00. OriginalAmount,0)) -  isnull(T02.OriginalAmount,0) as EndOriginalAmount,
		abs(isnull(T00.ConvertedAmount,0)) - isnull(T02.ConvertedAmount,0) as EndConvertedAmount
From  OT2007 T00 inner join OT2006 T01 on T00.VoucherID= T01.VoucherID 		
	left join  (--dieu chinh so tien 
		Select T00.OrderID, 	InventoryID, 	
			sum(isnull(OriginalAmount,0)) as OriginalAmount,
			sum(isnull(ConvertedAmount,0)) as ConvertedAmount
		From AT9000 T00 
		Where  isnull(T00.OrderID, '') <> ''  and TransactionTypeID in ('T04', 'T24')  --HD BAN HANG: cho PHIEU DIEU CHINH TANG GIA 
											---& HB TRA LAI: cho PHIEU DIEU CHINH GIAM GIA
		Group by T00.OrderID, InventoryID
			) T02	
			on T02.InventoryID = T00.InventoryID and 
			T02.OrderID = T00.VoucherID 
Where OrderStatus not in (0, 3,4, 9) and 
		T01.Disabled = 0  and 
		T00.DataType = 1
		--and T00.Finish <> 1

GO


