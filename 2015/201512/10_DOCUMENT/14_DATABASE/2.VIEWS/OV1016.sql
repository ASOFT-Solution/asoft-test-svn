
/****** Object:  View [dbo].[OV1016]    Script Date: 12/16/2010 14:47:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

---Created by: Vo Thanh Huong, date: 06/02/2006
---purpose: Lay ra so luong, gia tri  hang chua dieu chinh het (DON HANG DIEU CHINH)
----- Last edit  :27/05/2008
ALTER VIEW [dbo].[OV1016] as 
Select  Top 100 percent  DivisionID, TranMonth, TranYear,  OrderID, OrderStatus, DataType, InventoryID,
	OrderQuantity, AdjustPrice,	

	case when DataType = 2 then  sum(isnull(EndQuantity,0)) else 0 end as EndQuantity,  
	case when DataType = 1 then  sum(isnull(EndOriginalAmount,0)) else 0 end as EndOriginalAmount,
	case when DataType = 1 then  sum(isnull(EndConvertedAmount,0)) else 0 end as EndConvertedAmount
From OV2904
Where  EndQuantity >  case when DataType = 2 then 0 else -1 end  and
	EndOriginalAmount > case when DataType = 1 then 0 else -1 end and
	 EndConvertedAmount > case when DataType = 1 then 0 else -1 end
Group by DivisionID, TranMonth, TranYear, OrderID, OrderStatus, DataType, InventoryID, OrderQuantity, AdjustPrice
Order by OrderID

GO


