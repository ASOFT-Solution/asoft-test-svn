IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV3044]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AV3044]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


------ Created by Nguyen Van Nhan
------ Create Date 20/09/2004
------ Purpose Truy van phieu thu - chi qua ngan hang
------ Edit by Nguyen Quoc Huy 23/10/2004
------ Edit by: Dang Le Bao Quynh;
------ Purpose: Them doi tuong tap hop chi phi,
------Edit by: Thuy Tuyen, date : 11/06/2010
-----Purpose: Them ma san pham va ten san pham
-----------Edit by: Thuy Tuyen, date : 15/06/2010
-----Purpose: Them tinh , TP theo ngan hang
---- Edit by: Trung Dung, date : 05/10/2011 - Lay them truong ReVoucherID,ReTransactionID (thong tin phieu tam ung ben HRM)
---- Modified on 29/12/2011 by Le Thi Thu Hien : Bo sung them DivisionID
---- Modified on 24/02/2011 by Le Thi Thu Hien : Bo sung them Note, Note1
---- Modified on 10/05/2012 by Thien Huynh : Bo sung 5 Khoan muc
---- Modified on 13/05/2012 by Thien Huynh : Convert DateTime
---- Modified on 14/03/2013 by Thien Huynh : Bổ sung TVoucherID
---- Modified on 07/05/2013 by Bảo Anh : Bổ sung các tham số
---- Modified on 21/06/2013 by Khánh Vân: Bổ sung TBatchID

CREATE View AV3044 AS 
SELECT 	
		VoucherTypeID, TransactionTypeID,
		VoucherNo, Convert(Date, VoucherDate) As VoucherDate,  
		DebitAccountID, VoucherID,	TransactionID,	BatchID,
		CreditAccountID,      ExchangeRate,          OriginalAmount ,
		ConvertedAmount,  InvoiceDate,	
		AT9000.CurrencyID  AS CurrencyID,
		AT9000.VATTypeID,    AT9000.VATGroupID,           
		Serial,      InvoiceNo,    Orders, AT9000.EmployeeID,
		DebitBankAccountID, D16.BankAccountNo AS DebitBankAccountNo, D16.BankName AS DebitBankName,
		CreditbankAccountID, C16.BankAccountNo AS CreditBankAccountNo, C16.BankName AS CreditBankName,
		AT9000.ObjectID, 
		(Case when  isnull(AT1202.IsUpdateName,0) <>0 then   VATObjectName else  AT1202.ObjectName end) AS ObjectName,
		AT1202.Note, AT1202.Note1,
		RefNo01, RefNo02,VDescription, 
		BDescription,TDescription,Quantity,
		AT9000.InventoryID ,      AT9000.UnitID,        Status ,              IsAudit,
		AT9000.CreateDate,     AT9000.CreateUserID ,        
		AT9000.LastModifyDate ,   AT9000.LastModifyUserID,
		AT9000.DivisionID, TranMonth, TranYear,
		SenderReceiver, SRAddress,  SRDivisionName,
		C.IsObject AS CIsObject, D.IsObject AS DIsObject,
		isnull(AT1202.IsUpdateName,0) AS IsUpdateName,
		AT9000.VATObjectName,
		AT9000.VATObjectAddress,
		(Case when  isnull(AT1202.IsUpdateName,0) <>0 then   AT9000.VATNo  else  AT1202.VATNo  end) AS VATNo,
		AT9000.CurrencyIDCN,
		AT9000.ExchangeRateCN,
		AT9000.OriginalAmountCN,
		AT9000.Ana01ID,
		AT9000.Ana02ID,
		AT9000.Ana03ID,
		AT9000.Ana04ID,
		AT9000.Ana05ID,
		AT9000.Ana06ID,
		AT9000.Ana07ID,
		AT9000.Ana08ID,
		AT9000.Ana09ID,
		AT9000.Ana10ID,
		AT9000.OrderID,AT0000.CurrencyID AS BaseCurrencyID, AT9000.PeriodID, M01.Description AS PeriodName	,
		AT9000.ProductID,
		AT02.InventoryName AS ProductName,

		T22.CityID AS CreditBankCityID,
		T02.CityName AS CreditBankCityName,
		T22.Note AS CreditNote,
		T22.Note1 AS CreditNote1,

		T12.CityID AS DebitBankCityID,
		AT1002.CityName AS DebitBankCityName,
		AT9000.ReVoucherID,AT9000.ReTransactionID,
		T12.Note AS DebitNote,
		T12.Note1 AS DebitNote1,
		AT9000.TVoucherID, AT9000.TBatchID,
		AT9000.Parameter01, AT9000.Parameter02, AT9000.Parameter03, AT9000.Parameter04, AT9000.Parameter05,
		AT9000.Parameter06, AT9000.Parameter07, AT9000.Parameter08, AT9000.Parameter09, AT9000.Parameter10

From  AT9000 	
LEFT JOIN AT1202 on AT9000.ObjectID =  AT1202.ObjectID AND AT1202.DivisionID = AT9000.DivisionID
INNER JOIN AT1005 D on D.AccountID =  AT9000.DebitAccountID AND D.DivisionID = AT9000.DivisionID
INNER JOIN AT1005 C on C.AccountID =  AT9000.CreditAccountID AND C.DivisionID = AT9000.DivisionID
LEFT JOIN AT1016 AS  D16 on D16.BankAccountID = AT9000.DebitBankAccountID AND D16.DivisionID = AT9000.DivisionID
LEFT JOIN AT1016 AS C16 on C16.BankAccountID = AT9000.CreditBankAccountID AND C16.DivisionID = AT9000.DivisionID
LEFT JOIN AT0000 on AT0000.DefDivisionID = AT9000.DivisionID
LEFT JOIN MT1601 M01 on M01.PeriodID = AT9000.PeriodID 
LEFT JOIN AT1302 AS AT02 on  AT02.InventoryID = AT9000.ProductID AND AT02.DivisionID = AT9000.DivisionID

LEFT JOIN AT1202  T12 on T12.ObjectID = D16.BankID AND T12.DivisionID = AT9000.DivisionID
LEFT JOIN AT1202  T22 on T22.ObjectID = C16.BankID AND T22.DivisionID = AT9000.DivisionID
LEFT JOIN AT1002   on AT1002.CityID =  T12.CityID AND AT1002.DivisionID = AT9000.DivisionID
LEFT JOIN AT1002   T02  on T02.CityID  = T22.CityID AND T02.DivisionID = AT9000.DivisionID

		---		and DefTranmonth = AT9000.TranMonth
		----		and DefTranyear = AT9000.TranYear
Where TransactionTypeID in ('T21','T22','T16')















GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

