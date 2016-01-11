/****** Object:  View [dbo].[AV3004]    Script Date: 12/16/2010 14:58:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

--View chet dung cho FIFO: chi lay nhung phieu nhap kho va nhap kho VCNB
--Creater By Nguyen Thi Thuy Tuyen
--Date: 07/10/2006
--- Edited by Bao Anh	Date: 30/10/2012
--- Purpose: Bo sung truong tham so, MPT, ConvertedUnitID, ConvertedQuantity, Loai chung tu
--- Modified on 08/03/2013 by Bao Anh: Bo sung 15 tham so, doi tuong
--- Modified on 14/03/2013 by Bao Anh: Bo sung ConvertedUnitName
--- Modified on 07/05/2013 by Bao Anh: Sua inner join AT1202 thanh left join
--- Modified on 22/08/2013 by Khanh Van: Select thêm số lượng mark 2T


ALTER VIEW [dbo].[AV3004] as 
Select   --Case When KindVoucherID=3 then WareHouseID2 else WareHouseID End as WareHouseID
	WareHouseID, 
	AT2007.TransactionID, AT2007.VoucherID, AT2007.InventoryID, AT2007.UnitID, 
	AT2007.ActualQuantity, 
	AT2007.MarkQuantity, AT2007.UnitPrice, 
	AT2007.OriginalAmount, AT2007.ConvertedAmount, AT2007.TranMonth, AT2007.TranYear, 
	AT2007.DivisionID, AT2007.ReTransactionID, AT2007.ReVoucherID,
	AT2007.exchangeRate,AT2007.currencyID,AT2007.notes,
	'T05'  as TransactionTypeID,
	AT2007.Parameter01, AT2007.Parameter02, AT2007.Parameter03, AT2007.Parameter04, AT2007.Parameter05,
	AT2007.Ana04ID, AT2007.Ana05ID, AT2007.ConvertedUnitID, AT2007.ConvertedQuantity, AT2006.VoucherTypeID,
	AT2007.Notes01, AT2007.Notes02, AT2007.Notes03, AT2007.Notes04, AT2007.Notes05, AT2007.Notes06, AT2007.Notes07, AT2007.Notes08,
	AT2007.Notes09, AT2007.Notes10, AT2007.Notes11, AT2007.Notes12, AT2007.Notes13, AT2007.Notes14, AT2007.Notes15,
	AT2006.ObjectID, AT1202.ObjectName, AT1304.UnitName as ConvertedUnitName
	
From AT2007 inner Join AT2006 On AT2006.VoucherID = AT2007.VoucherID And AT2006.DivisionID = AT2007.DivisionID
				and KindVoucherID in (1,3,5,7,9)
			left join AT1202 on AT2006.ObjectID = AT1202.ObjectID And AT2006.DivisionID = AT1202.DivisionID
			left join AT1304 on AT2007.ConvertedUnitID = AT1304.UnitID And AT2007.DivisionID = AT1304.DivisionID

Union 

Select   AT2016.WareHouseID, 
	AT2017.TransactionID, AT2017.VoucherID, AT2017.InventoryID, AT2017.UnitID, 
	AT2017.ActualQuantity,
	AT2017.MarkQuantity, AT2017.UnitPrice, 
	AT2017.OriginalAmount, AT2017.ConvertedAmount, AT2017.TranMonth, AT2017.TranYear, 
	AT2017.DivisionID, AT2017.ReTransactionID, AT2017.ReVoucherID ,
	AT2017.exchangeRate,AT2017.currencyID,AT2017.notes	,
	'T00' as TransactionTypeID,
	AT2017.Parameter01, AT2017.Parameter02, AT2017.Parameter03, AT2017.Parameter04, AT2017.Parameter05,
	AT2017.Ana04ID, AT2017.Ana05ID, AT2017.ConvertedUnitID, AT2017.ConvertedQuantity, AT2016.VoucherTypeID,
	AT2017.Notes01, AT2017.Notes02, AT2017.Notes03, AT2017.Notes04, AT2017.Notes05, AT2017.Notes06, AT2017.Notes07, AT2017.Notes08,
	AT2017.Notes09, AT2017.Notes10, AT2017.Notes11, AT2017.Notes12, AT2017.Notes13, AT2017.Notes14, AT2017.Notes15,
	AT2016.ObjectID, AT1202.ObjectName, AT1304.UnitName as ConvertedUnitName
	
From AT2017 inner Join AT2016 On AT2016.VoucherID = AT2017.VoucherID And AT2016.DivisionID = AT2017.DivisionID
			left join AT1202 on AT2016.ObjectID = AT1202.ObjectID And AT2016.DivisionID = AT1202.DivisionID
			left join AT1304 on AT2017.ConvertedUnitID = AT1304.UnitID And AT2017.DivisionID = AT1304.DivisionID