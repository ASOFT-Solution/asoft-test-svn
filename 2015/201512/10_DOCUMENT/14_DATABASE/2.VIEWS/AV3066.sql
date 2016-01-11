SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


---- Created by Nguyen Van Nhan, Date 07/08/2003
---- Purpose: Dung de truy van Phieu ban hang
---- Edit by Nguyen Quoc Huy, Date 25/01/2007,
---- Edit by Thuy Tuyen, Date 27/08/2008, bo don hang
---- Edit by: Dang Le Bao Quynh; Date: 09/10/2009
---- Purpose: Xu ly cho but toan chiet khau.
---- Edit date 25/11/2009		Them truong VATNo
---- Edit date 3/12/2010		Them truong PrintedTimes - So lan in
---- Edit by Tấn Phú, Date 11/06/2012:	Comment left join  (Select VoucherID, DivisionID From AT1112) AV1112 on AV1112.VoucherID = AT9000.VoucherID and AV1112.DivisionID = AT9000.DivisionID
---- Edit by Bảo Anh, Date: 28/08/2012: Thêm trường tên MPT 1 (IPL)
---- Edit by Bảo Anh, Date: 04/09/2012: Bổ sung WarehouseID
---- Edit by Bảo Quynh, Date: 17/01/2013: Rem Join den bang don hang

ALTER View [dbo].[AV3066]
as
Select  AT9000.DivisionID, TranMonth, TranYear,
	AT9000.VoucherID, BatchID,	  
	VoucherDate,VoucherNo, Serial, InvoiceNo,
	(Select count(AT1112.VoucherID) from AT1112 
	Where AT1112.VoucherID in (Select distinct A.VoucherID from AT9000 A Where A.TransactionTypeID ='T04' And A.VoucherID = AT9000.VoucherID)) as PrintedTimes,
	VoucherTypeID,
	VATTypeID, InvoiceDate,
	VDescription,
	--BDescription,
	AT9000.CurrencyID,
	ExchangeRate,
	--Sum(isnull(OriginalAmount,0)) as OriginalAmount,
	--Sum(Isnull(ConvertedAmount,0)) as ConvertedAmount,
	Sum ( Case when TransactionTypeID in ('T04') then OriginalAmount else Case When TransactionTypeID in ('T64') then -OriginalAmount else 0 end end) as OriginalAmount,
	Sum ( Case when TransactionTypeID in ('T04') then ConvertedAmount else Case When TransactionTypeID in ('T64') then -ConvertedAmount else 0 end end) as ConvertedAmount,
	
	AT9000.ObjectID,
	AT1202.ObjectName, AT1202.VATNo,
	AT1202.Address,AT1202.CityID,At1002.CityName,
	--(Case when AT1202.IsUpdateName = 0 then AT1202.ObjectName else VATObjectName End) as  ObjectName,
	AT9000.VATObjectID,
	(Case when A.IsUpdateName = 0 then A.ObjectName else VATObjectName End) as  VATObjectName,
	DueDate,
	'' as OrderID,
	--DH.OrderID,
	isnull(IsStock,0) as IsStock, 
	isnull((Select sum(ConvertedAmount)  From AT9000 C Where C.VoucherID = AT9000.VoucherID and TransactionTypeID ='T54'),0)  as CommissionAmount,
	Sum(isnull(DiscountAmount,0)) as DiscountAmount,
	Sum ( Case when TransactionTypeID ='T14' then ConvertedAmount else 0 end ) as TaxAmount,
	Sum ( Case when TransactionTypeID ='T14' then OriginalAmount  else 0 end ) as TaxOriginalAmount, --Tien Thue qui doi
	MIN(AT1011.AnaName) as Ana01Name,
	WareHouseID = (SELECT WareHouseID FROM AT2006 WHERE VoucherID = AT9000.VoucherID AND DivisionID = AT9000.DivisionID), 	AT9000.CreateUserID
	
From AT9000 
inner join AT1202 on AT1202.ObjectID = AT9000.ObjectID And AT1202.DivisionID = AT9000.DivisionID
Left join AT1202 A on A.ObjectID = AT9000.VATObjectID And A.DivisionID = AT9000.DivisionID 
--left join  (Select VoucherID, DivisionID From AT1112) AV1112 on AV1112.VoucherID = AT9000.VoucherID and AV1112.DivisionID = AT9000.DivisionID
left join AT1002 on AT1002.CityID = AT1202.CityID And AT1002.DivisionID = AT1202.DivisionID
/*
INNER JOIN (
	select DivisionID, VoucherID, 
		case isnull(OrderID,'') when '' then '' else SUBSTRING(OrderID,1,LEN(OrderID)-1) end as OrderID
		From(
		SELECT p1.DivisionID, p1.VoucherID, 
		( SELECT OrderID + ','
		FROM (select Distinct OrderID, VoucherID, DivisionID From AT9000) as p2
		WHERE p2.VoucherID = p1.VoucherID and p2.DivisionID = p1.DivisionID
		ORDER BY VoucherID
		FOR XML PATH('') ) AS OrderID
		FROM AT9000 p1
		GROUP BY VoucherID, DivisionID
		) as a
	) as DH ON DH.DivisionID =AT9000.DivisionID and DH.VoucherID=AT9000.VoucherID
*/
Left join AT1011 on AT9000.Ana01ID = AT1011.AnaID and AT9000.DivisionID = AT1011.DivisionID and AT1011.AnaTypeID = 'A01'
	 
Where TransactionTypeID in ('T04', 'T14','T64') and TableID in ( 'AT9000')

Group by  AT9000.DivisionID, TranMonth, TranYear,
	AT9000.VoucherID, BatchID,	  
	VoucherDate,VoucherNo, Serial, InvoiceNo,
	VoucherTypeID, VATTypeID, InvoiceDate,
	VDescription,
	--BDescription,
	AT9000.CurrencyID,
	ExchangeRate,	
	AT9000.ObjectID,
	AT1202.ObjectName, AT1202.VATNo, AT1202.Address, AT1202.CityID,AT1002.CityNAme,
	DueDate,
	--DH.OrderID,
	AT1202.IsUpdateName, VATObjectName,
	isnull(IsStock,0), 
	AT9000.VATObjectID,A.ObjectName,A.IsUpdateName, AT9000.CreateUserID
	




























GO


