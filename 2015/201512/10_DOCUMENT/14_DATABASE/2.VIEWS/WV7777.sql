IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WV7777]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[WV7777]
GO
/****** Object:  View [dbo].[WV7777]    Script Date: 12/16/2010 15:44:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

------- Created view by Van Nhan, Date 19/04/2009. 
------ View chet phuc vu viec tinh gia xuat kho

CREATE VIEW [dbo].[WV7777] as 
Select  D17.DivisionID,	D17.TranMonth, D17.TranYear,
	D16.WareHouseID, D17.InventoryID, D17.DebitAccountID as AccountID,
	'BD' as D_C,  
	D16.VoucherDate, 
	ActualQuantity, 
	ConvertedAmount,
	ActualQuantity as SignQuantity,  
	ConvertedAmount as SignAmount
From AT2017 as D17 inner join AT2016 as D16 On D16.VoucherID = D17.VoucherID
		Where isnull(DebitAccountID,'') <>''

Union All --- So du co hang ton kho

Select  D17.DivisionID, D17.TranMonth, D17.TranYear,
	D16.WareHouseID, D17.InventoryID,  D17.CreditAccountID as AccountID,
	'BC' as D_C,  --- So du Co
	D16.VoucherDate,
	ActualQuantity, 
	ConvertedAmount,	
	-ActualQuantity as SignQuantity, 
	-ConvertedAmount as SignAmount
From AT2017 as D17 inner join AT2016 as D16 On D16.VoucherID = D17.VoucherID
		Where isnull(CreditAccountID,'') <>''

Union All  -- Nhap kho

Select  D07.DivisionID, D07.TranMonth, D07.TranYear,
	D06.WareHouseID, D07.InventoryID, D07.DebitAccountID as AccountID,
	'D' as D_C,  
	D06.VoucherDate,
	ActualQuantity, 
	ConvertedAmount,
	ActualQuantity as SignQuantity, 
	ConvertedAmount as SignAmount

From AT2007 as D07 inner join AT2006 D06 On D06.VoucherID = D07.VoucherID	
Where D06.KindVoucherID in (1,5,7,9,15,17,19,21)

Union All  -- Nhap kho
Select  D07.DivisionID, D07.TranMonth, D07.TranYear, 
	D06.WareHouseID  as WareHouseID, 	D07.InventoryID, D07.CreditAccountID as AccountID, 
	'C' as D_C,  --- So du Co
	 D06.VoucherDate, 
	ActualQuantity, 
	ConvertedAmount,
	-ActualQuantity as SignQuantity, 
	-ConvertedAmount as SignAmount
From AT2007 as D07 inner join AT2006 D06 On D06.VoucherID = D07.VoucherID
Where D06.KindVoucherID in (2,4,6,8,14, 16,18,20)

GO


