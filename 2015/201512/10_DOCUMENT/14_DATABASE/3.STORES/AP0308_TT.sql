IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0308_TT]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0308_TT]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO










---- Created by Nguyen Van Nhan.
---- Date 12/02/2004.
---- purpose: In bao cao chi tiet doi chieu cong no
---- Edited by Nguyen Quoc Huy.
---- Edit by: Dang Le Bao Quynh; Date 05/10/2009
---- Purpose: Bo sung 5 truong ten ma phan tich doi tuong,PhoneNumber, Contactor, DueDate
---- Edit by B.Anh, date 27/12/2009	Lay ten MPT va VATNo
--- Edit by B.Anh, date 26/04/2010	Bo sung MPT mat hang
---- Modify on 25/04/2013 by bao Anh: Sua loi khong len du lieu khi 1 doi tuong chi co so du,kg co phat sinh (Sieu Thanh - 0020460)
---- Modified on 27/05/2013 by Lê Thị Thu Hiền : Bổ sung Ana06ID --> Ana10ID
---- Modified on 06/06/2013 by Lê Thị Thu Hiền : Thêm @sSQL1, LEFT JOIN chứ không NOT IN
---- Modified on 09/09/2013 by Lê Thị Thu Hiền : Join them dieu kien AccountID
---- Modified on 08/01/2014 by Mai Duyen : Bố sung thêm thông tin tuoi no
---- Modified on 03/03/2014 by Mai Duyen : thay AP0316 ->AP0316_TT
---- Modified on 05/03/2015 by Mai Duyen : lay them field @ReportDate
---- Modified by Tieu Mai on 16/12/2015: fix bug InventoryID
	-- exec AP0308_TT @DivisionID=N'AA',@FromObjectID=N'0001',@ToObjectID=N'ZZ-DUPH-01',@FromAccountID=N'131',@ToAccountID=N'131',
	--@CurrencyID=N'%',@FromInventoryID=N'B11-PA15-000-01',@ToInventoryID=N'XK',@IsDate=0,@FromMonth=9,@FromYear=2013,@ToMonth=10,
	--@ToYear=2013,@FromDate='2014-01-03 09:37:39.877',@ToDate='2014-01-03 09:37:39.877',@ReportCode=N'CNTN001',@ReportDate ='2014-01-03 09:37:39.877',@IsBefore=1,@IsType=1,
	--@Filter1IDFrom=N'001',@Filter1IDTo=N'999',@Filter2IDFrom=N'CBB',@Filter2IDTo=N'ZZ',@Filter3IDFrom=N'',@Filter3IDTo=N''
	-- --Select distinct groupID  from AV0310
	
CREATE PROCEDURE [dbo].AP0308_TT 
		@DivisionID AS nvarchar(50), 
		@FromObjectID  AS nvarchar(50),  
		@ToObjectID  AS nvarchar(50),  
		@FromAccountID  AS nvarchar(50),  
		@ToAccountID  AS nvarchar(50),  
		@CurrencyID  AS nvarchar(50),  
		@FromInventoryID AS nvarchar(50),
		@ToInventoryID AS nvarchar(50),
		@IsDate AS tinyint, 
		@FromMonth AS int, 
		@FromYear  AS int,  
		@ToMonth AS int,
		@ToYear AS int,
		@FromDate AS Datetime, 
		@ToDate AS Datetime,
		@ReportCode AS nvarchar(50), -- Mẫu báo cáo tuoi nợ
		@ReportDate AS Datetime,   ---Ngày in tuổi nợ
		@IsBefore AS TINYINT, --Từ mốc thời gian trở về trước, về sau
		@IsType AS TINYINT,--Ngày
		@Filter1IDFrom AS nvarchar(50), -- Thiet lap dieu kien loc tuoi no
		@Filter1IDTo AS nvarchar(50),
		@Filter2IDFrom AS nvarchar(50),
		@Filter2IDTo AS nvarchar(50),
		@Filter3IDFrom AS nvarchar(50),
		@Filter3IDTo AS nvarchar(50)

AS

DECLARE @sSQL AS NVARCHAR(MAX),
		@sSQL1 AS NVARCHAR(MAX),
		@sSQL2 AS NVARCHAR(MAX),
		@CurrencyName AS NVARCHAR(MAX)


Set @CurrencyName = (CASE WHEN  ISNULL(@CurrencyID,'') ='%' then N'Tất cả' else ISNULL(@CurrencyID,'') End) 

----- Xac dinh so du.

	Exec AP0328 @DivisionID, @FromObjectID, @ToObjectID, @FromAccountID, @ToAccountID, @CurrencyID, @FromInventoryID, 
			@ToInventoryID, @IsDate, @FromMonth, @FromYear, @FromDate

----- Xac dinh so phat sinh 
	Exec AP0318 @DivisionID, @FromObjectID, @ToObjectID, @FromAccountID, @ToAccountID, @CurrencyID,  @FromInventoryID, 
			@ToInventoryID, @IsDate, @FromMonth, @FromYear, @ToMonth, @ToYear, @FromDate, @ToDate
------Mai Duyen Date 03/01/2013: Xác định tuổi nợ		
  exec AP0316_TT @DivisionID,@ReportCode,@FromObjectID,@ToObjectID,@FromAccountID,@ToAccountID,@CurrencyID,
		@Filter1IDFrom,@Filter1IDTo,@Filter2IDFrom,@Filter2IDTo,@Filter3IDFrom,@Filter3IDTo,@ReportDate,@IsBefore,@IsType,
		 @IsDate, @FromMonth, @FromYear, @ToMonth, @ToYear, @FromDate, @ToDate
  

Set @sSQL= N'
SELECT 	AV0318.Orders,
		AV0318.TransactionTypeID,
		ISNULL(AV0318.ObjectID, AV0328.ObjectID) AS GroupID,
		ISNULL(AV0318.ObjectName, AV0328.ObjectName) AS GroupName,
		AV0318.PhoneNumber,
		AV0318.Contactor,
		N'''+@CurrencyName+''' AS CurrencyID,
		DebitAccountID, CreditAccountID,
		VoucherDate,
		DueDate,
		VoucherNo,
		VoucherTypeID,
		AV0318.Ana01ID, AV0318.Ana02ID, AV0318.Ana03ID, AV0318.Ana04ID, AV0318.Ana05ID,
		AV0318.Ana06ID, AV0318.Ana07ID, AV0318.Ana08ID, AV0318.Ana09ID, AV0318.Ana10ID,
		AV0318.O01ID, AV0318.O02ID, AV0318.O03ID, AV0318.O04ID, AV0318.O05ID, 
		AV0318.O01Name, AV0318.O02Name, AV0318.O03Name, AV0318.O04Name, AV0318.O05Name, 
		AV0318.I01ID, AV0318.I02ID, AV0318.I03ID, AV0318.I04ID, AV0318.I05ID, 
		AV0318.I01Name, AV0318.I02Name, AV0318.I03Name, AV0318.I04Name, AV0318.I05Name,
		AV0318.VATRate,
		InvoiceDate,
		InvoiceNo,
		Serial,
		AV0318.InventoryID,
		AV0318.UnitID,
		AV0318.InventoryName,VDescription, TDescription,
		DebitQuantity,
		DebitUnitPrice,
		ISNULL(DebitOriginalAmount,0) AS DebitOriginalAmount,
		ISNULL(DebitConvertedAmount,0) AS DebitConvertedAmount,
		ISNULL(CreditOriginalAmount,0) AS CreditOriginalAmount,
		ISNULL(CreditConvertedAmount,0) AS CreditConvertedAmount,
		ISNULL(OpeningConvertedAmount,0) AS OpeningConvertedAmount,
		ISNULL(OpeningOriginalAmount,0) AS OpeningOriginalAmount,
		ISNULL(CreditQuantity,0) AS CreditQuantity,
		ISNULL(AV0318.DivisionID,AV0328.DivisionID) AS DivisionID
FROM	AV0318 
FULL JOIN AV0328 on AV0318.ObjectID = AV0328.ObjectID 
		and AV0318.DivisionID = AV0328.DivisionID
		AND (AV0318.DebitAccountID = AV0328.AccountID OR AV0318.CreditAccountID = AV0328.AccountID)'

IF NOT EXISTS (SELECT NAME FROM SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV0314]') AND OBJECTPROPERTY(ID, N'ISVIEW') = 1)
	EXEC ('  CREATE VIEW AV0314 --AP0308
		AS ' + @sSQL)
ELSE
	EXEC ('  ALTER VIEW AV0314 --AP0308
		AS ' + @sSQL)
		
--print @sSQL
		

Set @sSQL = N' 
SELECT 	AV0314.Orders,
		AV0314.TransactionTypeID,
		GroupID, GroupName, AT1202.Address, AT1202.Tel, AT1202.Fax, AT1202.VATNo,
		AV0314.PhoneNumber,
		AV0314.Contactor,
		AV0314.CurrencyID, 
		DebitAccountID, CreditAccountID,
		AV0314.VoucherDate, AV0314.DueDate, AV0314.VoucherNo, VoucherTypeID, 
		AV0314.Ana01ID, AV0314.Ana02ID, AV0314.Ana03ID, AV0314.Ana04ID, AV0314.Ana05ID,
		AV0314.Ana06ID, AV0314.Ana07ID, AV0314.Ana08ID, AV0314.Ana09ID, AV0314.Ana10ID,
		A1.AnaName AS Ana01Name, A2.AnaName AS Ana02Name, A3.AnaName AS Ana03Name, A4.AnaName AS Ana04Name, A5.AnaName AS Ana05Name,
		A6.AnaName AS Ana06Name, A7.AnaName AS Ana07Name, A8.AnaName AS Ana08Name, A9.AnaName AS Ana09Name, A10.AnaName AS Ana10Name,
		AV0314.O01ID, AV0314.O02ID, AV0314.O03ID, AV0314.O04ID, AV0314.O05ID, 
		AV0314.O01Name, AV0314.O02Name, AV0314.O03Name, AV0314.O04Name, AV0314.O05Name, 
		AV0314.I01ID, AV0314.I02ID, AV0314.I03ID, AV0314.I04ID, AV0314.I05ID, 
		AV0314.I01Name, AV0314.I02Name, AV0314.I03Name, AV0314.I04Name, AV0314.I05Name,
		AV0314.VATRate,
		AV0314.InvoiceDate,AV0314.InvoiceNo, AV0314.Serial, AV0314.InventoryID, UnitID, InventoryName,AV0314.VDescription, TDescription,
		DebitQuantity, DebitUnitPrice, DebitOriginalAmount, DebitConvertedAmount,
		CreditOriginalAmount, CreditConvertedAmount,
		OpeningConvertedAmount, OpeningOriginalAmount, CreditQuantity, AV0314.DivisionID ,
		AV0316.Title1,AV0316.ConvertedAmount1 as ConvertedAmountTN01,
		AV0316.Title2,AV0316.ConvertedAmount2 as ConvertedAmountTN02,AV0316.Title3,AV0316.ConvertedAmount3 as ConvertedAmountTN03,
		AV0316.Title4,AV0316.ConvertedAmount4 as ConvertedAmountTN04,AV0316.Title5,AV0316.ConvertedAmount5 as ConvertedAmountTN05,
		CONVERT(DATETIME,(''' + CONVERT(nvarchar(10),@ReportDate,101) + '''),101) AS ReportDate

FROM	AV0314 
LEFT JOIN AV0316 on AV0316.ObjectID = AV0314.GroupID and AV0316.DivisionID = AV0314.DivisionID
LEFT JOIN AT1202 on AT1202.ObjectID = AV0314.GroupID and AT1202.DivisionID = AV0314.DivisionID
LEFT JOIN AT1011 A1 on AV0314.Ana01ID = A1.AnaID and A1.AnaTypeID = ''A01'' and A1.DivisionID = AV0314.DivisionID
LEFT JOIN AT1011 A2 on AV0314.Ana02ID = A2.AnaID and A2.AnaTypeID = ''A02'' and A2.DivisionID = AV0314.DivisionID
LEFT JOIN AT1011 A3 on AV0314.Ana03ID = A3.AnaID and A3.AnaTypeID = ''A03'' and A3.DivisionID = AV0314.DivisionID
LEFT JOIN AT1011 A4 on AV0314.Ana04ID = A4.AnaID and A4.AnaTypeID = ''A04'' and A4.DivisionID = AV0314.DivisionID
LEFT JOIN AT1011 A5 on AV0314.Ana05ID = A5.AnaID and A5.AnaTypeID = ''A05'' and A5.DivisionID = AV0314.DivisionID
LEFT JOIN AT1011 A6 on AV0314.Ana06ID = A6.AnaID and A6.AnaTypeID = ''A06'' and A6.DivisionID = AV0314.DivisionID
LEFT JOIN AT1011 A7 on AV0314.Ana07ID = A7.AnaID and A7.AnaTypeID = ''A07'' and A7.DivisionID = AV0314.DivisionID
LEFT JOIN AT1011 A8 on AV0314.Ana08ID = A8.AnaID and A8.AnaTypeID = ''A08'' and A8.DivisionID = AV0314.DivisionID
LEFT JOIN AT1011 A9 on AV0314.Ana09ID = A9.AnaID and A9.AnaTypeID = ''A09'' and A9.DivisionID = AV0314.DivisionID
LEFT JOIN AT1011 A10 on AV0314.Ana10ID = A10.AnaID and A10.AnaTypeID = ''A10'' and A10.DivisionID = AV0314.DivisionID
'
SET @sSQL1 = N'
UNION ALL
SELECT  0 AS Orders,
		''''  AS TransactionTypeID, 
		AV0328.ObjectID AS GroupID,  AV0328.ObjectName AS GroupName,
		AT1202.Address, AT1202.Tel, AT1202.Fax, AT1202.VATNo,
		AT1202.PhoneNumber,
		AT1202.Contactor,
		N'''+@CurrencyName+''' AS CurrencyID,
		NULL AS DebitAccountID, 
		NULL AS CreditAccountID,
		NULL AS VoucherDate, NULL AS DueDate, NULL AS VoucherNo,
		NULL AS VoucherTypeID,
		NULL AS Ana01ID, 
		NULL AS Ana02ID, 
		NULL AS Ana03ID, 
		NULL AS Ana04ID,
		NULL AS Ana05ID,
		NULL AS Ana06ID, 
		NULL AS Ana07ID, 
		NULL AS Ana08ID, 
		NULL AS Ana09ID,
		NULL AS Ana10ID,
		NULL AS Ana01Name,
		NULL AS Ana02Name,
		NULL AS Ana03Name,
		NULL AS Ana04Name,
		NULL AS Ana05Name,
		NULL AS Ana06Name,
		NULL AS Ana07Name,
		NULL AS Ana08Name,
		NULL AS Ana09Name,
		NULL AS Ana10Name,
		NULL AS O01ID, 
		NULL AS O02ID, 
		NULL AS O03ID, 
		NULL AS O04ID, 
		NULL AS O05ID, 
		NULL AS O01Name, 
		NULL AS O02Name, 
		NULL AS O03Name, 
		NULL AS O04Name, 
		NULL AS O05Name, 
		NULL AS I01ID, 
		NULL AS I02ID, 
		NULL AS I03ID, 
		NULL AS I04ID, 
		NULL AS I05ID, 
		NULL AS I01Name, 
		NULL AS I02Name, 
		NULL AS I03Name, 
		NULL AS I04Name, 
		NULL AS I05Name,
		NULL AS VATRate,
		NULL AS InvoiceDate,
		NULL AS InvoiceNo,
		NULL AS Serial,
		NULL AS InventoryID,
		NULL AS UnitID,
		NULL AS InventoryName, '''' AS VDescription, '''' AS TDescription,
		0 AS DebitQuantity,
		0 AS DebitUnitPrice,
		0 AS DebitOriginalAmount,
		0 AS DebitConvertedAmount,
		0 AS CreditOriginalAmount,
		0 AS CreditConvertedAmount,
		ISNULL(AV0328.OpeningConvertedAmount,0) AS OpeningConvertedAmount,
		ISNULL(AV0328.OpeningOriginalAmount,0) AS OpeningOriginalAmount,
		0 AS CreditQuantity, AV0328.DivisionID ,'''' as Title1,0 as ConvertedAmountTN01,
		'''' as  Title2,0 as ConvertedAmountTN02,'''' as  Title3,0 as ConvertedAmountTN03,
		'''' as Title4,0 as ConvertedAmountTN04,'''' as Title5,0 as ConvertedAmountTN05,
		CONVERT(DATETIME,(''' + CONVERT(nvarchar(10),@ReportDate,101) + '''),101) AS ReportDate
FROM	AV0328 
LEFT JOIN AT1202 on AT1202.ObjectID = AV0328.ObjectID and AT1202.DivisionID = AV0328.DivisionID 
LEFT JOIN AV0314 ON AV0314.DivisionID = AV0328.DivisionID AND AV0314.GroupID = AV0328.ObjectID
WHERE	AV0328.ObjectID <> AV0314.GroupID
		-- AV0328.ObjectID NOT IN (SELECT DISTINCT GroupID FROM AV0314) 
		AND (AV0328.OpeningConvertedAmount >0)'
		
		
--		SET @sSQL2 = N'
--UNION ALL
--SELECT  0 AS Orders,
--		''''  AS TransactionTypeID, 
--		AV0316.ObjectID AS GroupID,  AV0316.ObjectName AS GroupName,
--		--AT1202.Address, AT1202.Tel, AT1202.Fax, AT1202.VATNo,
--		--AT1202.PhoneNumber,
--		--AT1202.Contactor,
--		Null as Address, Null as Tel, Null as Fax, Null as VATNo,
--		Null as PhoneNumber,
--		Null as Contactor,
		
--		N'''+@CurrencyName+''' AS CurrencyID,
--		NULL AS DebitAccountID, 
--		NULL AS CreditAccountID,
--		NULL AS VoucherDate, NULL AS DueDate, NULL AS VoucherNo,
--		NULL AS VoucherTypeID,
--		NULL AS Ana01ID, 
--		NULL AS Ana02ID, 
--		NULL AS Ana03ID, 
--		NULL AS Ana04ID,
--		NULL AS Ana05ID,
--		NULL AS Ana06ID, 
--		NULL AS Ana07ID, 
--		NULL AS Ana08ID, 
--		NULL AS Ana09ID,
--		NULL AS Ana10ID,
--		NULL AS Ana01Name,
--		NULL AS Ana02Name,
--		NULL AS Ana03Name,
--		NULL AS Ana04Name,
--		NULL AS Ana05Name,
--		NULL AS Ana06Name,
--		NULL AS Ana07Name,
--		NULL AS Ana08Name,
--		NULL AS Ana09Name,
--		NULL AS Ana10Name,
--		NULL AS O01ID, 
--		NULL AS O02ID, 
--		NULL AS O03ID, 
--		NULL AS O04ID, 
--		NULL AS O05ID, 
--		NULL AS O01Name, 
--		NULL AS O02Name, 
--		NULL AS O03Name, 
--		NULL AS O04Name, 
--		NULL AS O05Name, 
--		NULL AS I01ID, 
--		NULL AS I02ID, 
--		NULL AS I03ID, 
--		NULL AS I04ID, 
--		NULL AS I05ID, 
--		NULL AS I01Name, 
--		NULL AS I02Name, 
--		NULL AS I03Name, 
--		NULL AS I04Name, 
--		NULL AS I05Name,
--		NULL AS VATRate,
--		NULL AS InvoiceDate,
--		NULL AS InvoiceNo,
--		NULL AS Serial,
--		NULL AS InventoryID,
--		NULL AS UnitID,
--		NULL AS InventoryName, '''' AS VDescription, '''' AS TDescription,
--		0 AS DebitQuantity,
--		0 AS DebitUnitPrice,
--		0 AS DebitOriginalAmount,
--		0 AS DebitConvertedAmount,
--		0 AS CreditOriginalAmount,
--		0 AS CreditConvertedAmount,
--		0 AS OpeningConvertedAmount,
--		0 AS OpeningOriginalAmount,
--		0 AS CreditQuantity, AV0316.DivisionID , AV0316.Title1,AV0316.ConvertedAmount1 as ConvertedAmountCN01,
--		AV0316.Title2,AV0316.ConvertedAmount2 as ConvertedAmountCN02,AV0316.Title3,AV0316.ConvertedAmount3 as ConvertedAmountCN03,
--		AV0316.Title4,AV0316.ConvertedAmount4 as ConvertedAmountCN04,AV0316.Title5,AV0316.ConvertedAmount5 as ConvertedAmountCN05
		
--FROM	AV0314
--LEFT JOIN AV0316 ON AV0314.DivisionID = AV0316.DivisionID  AND AV0314.GroupID = AV0316.ObjectID  '
	

--PRINT( @sSQL )
--PRINT(  @sSQL1 )
--PRINT( @sSQL2)



EXEC ( @sSQL + @sSQL1 +@sSQL2)

/*
IF NOT EXISTS (SELECT NAME FROM SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV0310]') AND OBJECTPROPERTY(ID, N'ISVIEW') = 1)
	EXEC ('  CREATE VIEW AV0310 --AP0308_TT
		AS ' + @sSQL + @sSQL1 +@sSQL2 )
ELSE
	EXEC ('  ALTER VIEW AV0310   --AP0308_TT
		AS ' + @sSQL + @sSQL1  +@sSQL2 )


	
Select 	*
	Into AF001302
	From AV0310

*/




   



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

