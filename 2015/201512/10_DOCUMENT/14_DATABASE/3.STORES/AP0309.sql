IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP0309]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AP0309]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



---- Created by Nguyen Van Nhan.
--- Date 12/02/2004.
---- purpose: In bao cao tong hop  doi chieu cong no
/********************************************
'* Edited by: [GS] [To Oanh] [29/07/2010]
'********************************************/
---- Modify on 18/03/2013 by bao Anh: Bo sung truong
---- Modify on 15/04/2013 by bao Anh: Sua loi khong len du lieu khi 1 doi tuong chi co so du,kg co phat sinh (Sieu Thanh - 0020460)
---- Modified on 06/06/2013 by Lê Thị Thu Hiền : LEFT JOIN AV0315

CREATE PROCEDURE [dbo].[AP0309] 
			@DivisionID AS nvarchar(50), 
			@FromObjectID  AS nvarchar(50),  
			@ToObjectID  AS nvarchar(50),  
			@FromAccountID  AS nvarchar(50),  
			@ToAccountID AS nvarchar(50),  
			@CurrencyID  AS nvarchar(50),  
			@FromInventoryID AS nvarchar(50),
			@ToInventoryID AS nvarchar(50),
			@IsDate AS tinyint, 
			@FromMonth AS int, 
			@FromYear  AS int,  
			@ToMonth AS int,
			@ToYear AS int,
			@FromDate AS Datetime, 
			@ToDate AS Datetime

AS


Declare @sSQL AS nvarchar(MAX),
		@CurrencyName AS varchar(MAX)

Set @CurrencyName = (Case When  Isnull(@CurrencyID,'') ='%' then 'Tất cả' else Isnull(@CurrencyID,'') End) 

----- Xac dinh so du.

	Exec AP0328 @DivisionID, @FromObjectID, @ToObjectID, @FromAccountID, @ToAccountID, @CurrencyID, @FromInventoryID, 
			@ToInventoryID, @IsDate, @FromMonth, @FromYear, @FromDate

----- Xac dinh so phat sinh 
	Exec AP0319 @DivisionID, @FromObjectID, @ToObjectID, @FromAccountID, @ToAccountID, @CurrencyID, @FromInventoryID,
			@ToInventoryID, @IsDate, @FromMonth, @FromYear, @ToMonth, @ToYear, @FromDate, @ToDate


Set @sSQL='
Select 	Isnull(AV0319.TransactionTypeID, AV0328.TransactionTypeID) AS TransactionTypeID,
	Isnull(AV0319.ObjectID, AV0328.ObjectID) AS GroupID,
	Isnull(AV0319.ObjectName, AV0328.ObjectName) AS GroupName,
	'''+@CurrencyName+''' AS CurrencyID,
	VoucherDate,VoucherNo,
	VDescription, BDescription, TDescription, DebitAccountID, CreditAccountID, InvoiceNo,
	AV0319.InventoryID, AV0319.InventoryName, UnitID,
	isnull(DebitOriginalAmount,0) AS DebitOriginalAmount,
	isnull(DebitConvertedAmount,0) AS DebitConvertedAmount,
	isnull(DebitQuantity,0) AS DebitQuantity,
	isnull(CreditOriginalAmount,0) AS CreditOriginalAmount,
	isnull(CreditConvertedAmount,0) AS CreditConvertedAmount,
	isnull(CreditQuantity,0) AS CreditQuantity,
	isnull(OpeningOriginalAmount,0) AS OpeningOriginalAmount,
	isnull(OpeningConvertedAmount,0) AS OpeningConvertedAmount,
	Isnull(AV0319.DivisionID, AV0328.DivisionID) AS DivisionID,
	AV0319.Parameter01, AV0319.Parameter02, AV0319.Parameter03, AV0319.Parameter04, AV0319.Parameter05,
	AV0319.ConvertedUnitID, AV0319.ConvertedUnitName,
	Isnull(AV0319.DebitConvertedQuantity,0) AS DebitConvertedQuantity, Isnull(AV0319.CreditConvertedQuantity,0) AS CreditConvertedQuantity,
	AV0319.Serial, Isnull(AV0319.MarkQuantity,0) AS MarkQuantity
FROM AV0319 
FULL JOIN  AV0328 on AV0328.ObjectID = AV0319.ObjectID and AV0328.DivisionID = AV0319.DivisionID' 

IF NOT EXISTS (SELECT NAME FROM SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV0315]') AND OBJECTPROPERTY(ID, N'ISVIEW') = 1)
	EXEC ('  CREATE VIEW AV0315 --AP0309
		AS ' + @sSQL)
ELSE
	EXEC ('  ALTER VIEW AV0315  --AP0309
		AS ' + @sSQL)

 --print @sSQL

Set @sSQL =' 
Select TransactionTypeID, GroupID, GroupName, AT1202.Address, AT1202.Tel, AT1202.Fax,
	AV0315.CurrencyID,  VoucherDate,VoucherNo,
	VDescription, BDescription, TDescription, DebitAccountID, CreditAccountID, InvoiceNo, AT1202.VATNo,
	InventoryID, InventoryName, UnitID, DebitOriginalAmount,
	DebitConvertedAmount, DebitQuantity, CreditOriginalAmount,
	CreditConvertedAmount, CreditQuantity, OpeningOriginalAmount,
	OpeningConvertedAmount, AV0315.DivisionID,
	AV0315.Parameter01, AV0315.Parameter02, AV0315.Parameter03, AV0315.Parameter04, AV0315.Parameter05,
	AV0315.ConvertedUnitID, AV0315.ConvertedUnitName,
	AV0315.DebitConvertedQuantity, AV0315.CreditConvertedQuantity, AV0315.Serial, AV0315.MarkQuantity
From AV0315 
LEFT JOIN AT1202 on AT1202.ObjectID = AV0315.GroupID and AT1202.DivisionID = AV0315.DivisionID
UNION ALL
Select  ''T00'' AS TransactionTypeID, AV0328.ObjectID AS GroupID,  AV0328.ObjectName AS GroupName,
	AT1202.Address, AT1202.Tel, AT1202.Fax,
	'''+@CurrencyName+''' AS CurrencyID,
	null AS VoucherDate, null AS VoucherNo,
	null AS VDescription, null AS BDescription, null AS TDescription, null AS DebitAccountID, null AS CreditAccountID,
	null AS InvoiceNo, AT1202.VATNo,
	null AS InventoryID,
	null AS InventoryName,
	null AS UnitID,
	0 AS DebitOriginalAmount,
	0 AS DebitConvertedAmount,
	0 AS DebitQuantity,
	0 AS CreditOriginalAmount,
	0 AS CreditConvertedAmount,
	0 AS CreditQuantity,
	IsNull(AV0328.OpeningOriginalAmount,0) AS OpeningOriginalAmount,
	IsNull(AV0328.OpeningConvertedAmount,0) AS OpeningConvertedAmount,
	AV0328.DivisionID,
	null AS Parameter01, null AS Parameter02, null AS Parameter03, null AS Parameter04, null AS Parameter05,
	null AS ConvertedUnitID, null AS ConvertedUnitName,
	0 AS DebitConvertedQuantity, 0 AS CreditConvertedQuantity, null AS Serial, 0 AS MarkQuantity
FROM	AV0328 
LEFT JOIN AT1202 on AT1202.ObjectID = AV0328.ObjectID and  AT1202.DivisionID = AV0328.DivisionID
LEFT JOIN AV0315 ON AV0315.DivisionID = AV0328.DivisionID AND AV0315.GroupID = AV0328.ObjectID
WHERE	AV0328.ObjectID <> AV0315.GroupID
		--AV0328.ObjectID NOT IN (SELECT DISTINCT GroupID FROM AV0315) 
		AND (AV0328.OpeningConvertedAmount >0)'

---print @sSQL

IF NOT EXISTS (SELECT NAME FROM SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV0309]') AND OBJECTPROPERTY(ID, N'ISVIEW') = 1)
	EXEC ('  CREATE VIEW AV0309 --AP0309
     		AS ' + @sSQL)
ELSE
	EXEC ('  ALTER VIEW AV0309   --AP0309
		AS ' + @sSQL)

