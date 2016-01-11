IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP2017]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP2017]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/********************************************
'* Edited by: [GS] [Minh Lâm] [28/07/2010]
'********************************************/

---- Create by Nguyen Thi Ngoc Minh, Date 10/04/2004
---- Purpose: Nhat ky nhap xuat kho
---- Last edit by Van Nhan. Date 17/01/2005
---- Edit by Nguyen Quoc Huy, Date 04/07/2007
-----Edit by: Dang Le Bao Quynh; 09/06/2008
-----Purpose: Them truong he so quy doi
-----Edit by: Dang Le Bao Quynh; 24/11/2008
-----Purpose: Bo dieu kien NOT NULL khi tao bang tam AT2018 (Orders)
---- Edit by: Dang Le Bao Quynh; Date: 16/01/2009
---- Purpose: Bo sung truong hop xuat hang mua tra lai
---- Edit By: Dang Le Bao Quynh, 20/05/2009
---- Purpose: Thêm truong Ana01Name .. Ana05Name, Notes01 vao bang AT2018
---- Edit By: Dang Le Bao Quynh, 30/09/2009
---- Purpose: Thêm tat cac ma phan tich mat hang
---- Edit By: Dang Le Bao Quynh, 19/10/2009
---- Purpose: Thêm truong ma doi tuong , ten doi tuong
---- Modified on 12/10/2011 by Le Thi Thu Hien : Bi loi tran chuoi
---- Modified on 21/11/2012 by Tan Phu : [ TT4091 ] [ESACO] Lấy trường mã tham chiếu 1,2 giúp ra bảng AT2018 phục vụ cho report AR7006, AR7007,... 
---- Modified on 22/04/2013 by Le Thi Thu Hien : Bỏ trường APK trong bảng AT2018 (0020470 )
---- Modified on 16/07/2014 by Thanh Sơn: Lấy dữ liệu trực tiếp từ store
---- Modified on 17/09/2014 by Mai Duyen: Fix lỗi báo cáo nhập xuất kho âm (KH Printech)
---- Modified on 18/05/2015 by Mai Duyen: Bo sung DebitAccountID, CreditAccountID (KH Sieu Thanh)
---- Modified on 26/11/2015 by Tiểu Mai: Bổ sung trường Notes từ AT2007

-- <Example>
---- EXEC AP2017 @Divisionid=N'CDA',@Fromwarehouseid=N'KBH',@Towarehouseid=N'KDA',@Frominventoryid=N'101322',@Toinventoryid=N'414143',@Fromdate='2013-01-01 00:00:00',@Todate='2013-03-10 00:00:00'

CREATE PROCEDURE [dbo].[AP2017]
       @DivisionID AS nvarchar(50) ,
       @FromWareHouseID AS nvarchar(50) ,
       @ToWareHouseID AS nvarchar(50) ,
       @FromInventoryID AS nvarchar(50) ,
       @ToInventoryID AS nvarchar(50) ,
       @FromDate AS datetime ,
       @ToDate AS datetime
AS
SET NOCOUNT ON
DECLARE
        @sSQLSelect AS nvarchar(4000) ,
        @AT2018Cursor AS cursor ,
        @WareHouseID AS nvarchar(50) ,
        @VoucherID AS nvarchar(50) ,
        @TransactionID AS nvarchar(50) ,
        @VoucherDate AS datetime ,
        @InventoryID AS nvarchar(50) ,
        @BeginQuantity AS decimal(28,8) ,
        @BeginAmount AS decimal(28,8) ,
        @ImQuantity AS decimal(28,8) ,
        @ExQuantity AS decimal(28,8) ,
        @ImQuant AS decimal(28,8) ,
        @ExQuant AS decimal(28,8) ,
        @EndQuant AS decimal(28,8) ,
        @ImAmount AS decimal(28,8) ,
        @ExAmount AS decimal(28,8) ,
        @ImportAmount AS decimal(28,8) ,
        @ExportAmount AS decimal(28,8) ,
        @EndAmount AS decimal(28,8) ,
        @Orders AS nvarchar(250) ,
        @WareHouseName AS nvarchar(250) ,
        @WareHouseName1 AS nvarchar(250) ,
        @WareHouseID2 AS nvarchar(50) ,
        @WareHouseID1 AS nvarchar(200) ,
        @KindVoucherListIm AS nvarchar(200) ,
        @KindVoucherListEx1 AS nvarchar(200), 
        @KindVoucherListEx2 AS nvarchar(200), 
    @FromDateText NVARCHAR(20), 
    @ToDateText NVARCHAR(20)
    
SET @FromDateText = CONVERT(NVARCHAR(20), @FromDate, 101)
SET @ToDateText = CONVERT(NVARCHAR(20), @ToDate, 101) + ' 23:59:59'

SET @KindVoucherListEx1 = '(2,4,3,8,10,14,20) '
SET @KindVoucherListEx2 = '(2,4,8,10,14,20) '
SET @KindVoucherListIm = '(1,3,5,7,9,15,17) '

SET @WareHouseID2 = ' AT2006.WareHouseID '
SET @WareHouseID1 = ' Case When KindVoucherID = 3 then AT2006.WareHouseID2 else AT2006.WareHouseID end '
EXEC AP7016 @DivisionID , @FromWareHouseID , @ToWareHouseID , @FromInventoryID , @ToInventoryID , '%' , 01 , 2004 , 01 , 2004 , @FromDate , @ToDate , 1 , 1

SET @sSQLSelect = '
SELECT		DivisionID, WareHouseID, 
			InventoryID,
			sum(isnull(BeginQuantity,0)) AS BeginQuantity,
			sum(isnull(BeginAmount,0)) AS BeginAmount
FROM		AV7016
WHERE		DivisionID = ''' + @DivisionID + '''
GROUP BY	DivisionID, WareHouseID, InventoryID
'

IF NOT EXISTS ( SELECT
                    name
                FROM
                    sysobjects
                WHERE
                    id = Object_id(N'[dbo].[AV2015]') AND OBJECTPROPERTY(id , N'IsView') = 1 )
   BEGIN
         EXEC ( '  CREATE VIEW AV2015 	--CREATED BY AP2017
					AS '+@sSQLSelect )
   END
ELSE
   BEGIN
         EXEC ( '  ALTER VIEW AV2015 	--CREATED BY AP2017
					AS '+@sSQLSelect )
   END

--Edit by: Dang Le Bao Quynh; 02/06/2009
--Purpose: chuyen AV2015 vao bang tam de tang toc do xu ly
IF EXISTS ( SELECT TOP 1
                1
            FROM
                SysObjects
            WHERE
                ID = Object_ID('AT2015_Tmp') AND xType = 'U' )
   BEGIN
         DROP TABLE AT2015_Tmp
   END
EXEC ( 'SELECT * INTO AT2015_Tmp FROM AV2015' )

DECLARE
        @sSQLFrom AS nvarchar(4000) ,
        @sSQLWhere AS nvarchar(4000) ,
        @sSQLUnionSelect AS nvarchar(4000) ,
        @sSQLUnionFrom AS nvarchar(4000) ,
        @sSQLUnionWhere AS nvarchar(4000)

SET @sSQLSelect = '
---1 Phan Nhap kho
Select 	' + @WareHouseID2 + ' AS WareHouseID,
	AT1303.WareHouseName, 
	AT2006.VoucherID,
	AT2007.TransactionID,
	--cast(Day(AT2006.VoucherDate)+Month(AT2006.VoucherDate)* 100 + Year(AT2006.VoucherDate)*10000 AS char(8)) +  cast((Case when AT2006.KindVoucherID in' + @KindVoucherListIm + ' then 1 else 2 end) AS char(1)) + cast(AT2006.VoucherNo AS char(20))+ cast(AT2007.TransactionID AS char(20)) + cast(AT2007.InventoryID AS char(20))  AS Orders,
	cast(Day(AT2006.VoucherDate)+Month(AT2006.VoucherDate)* 100 + Year(AT2006.VoucherDate)*10000 AS char(8)) +  cast((Case when AT2006.KindVoucherID in(1,5,7,9,15,17)  then 1  When AT2006.KindVoucherID=3 then 2 Else  3 end) AS char(1)) + cast(AT2006.VoucherNo AS char(20))+ cast(AT2007.TransactionID AS char(20)) + cast(AT2007.InventoryID AS char(20))  AS Orders,
	AT2006.VoucherDate,
	VoucherNo,	
	VoucherDate AS ImVoucherDate,
	VoucherNo AS ImVoucherNo,		
	SourceNo AS ImSourceNo,
	AT2006.WareHouseID AS ImWareHouseID,		
	AT2007.ActualQuantity AS ImQuantity,
	AT2007.UnitPrice AS ImUnitPrice ,
	AT2007.ConvertedAmount AS ImConvertedAmount,
	AT2007.OriginalAmount AS ImOriginalAmount,
	isnull(AT2007.ConversionFactor ,1)*ActualQuantity AS ImConvertedQuantity,
	Null AS ExVoucherDate,
	Null AS ExVoucherNo,		
	Null AS ExSourceNo,
	Null AS ExWareHouseID,		
	0 AS ExQuantity,
	Null AS ExUnitPrice ,
	0 AS ExConvertedAmount,
	0 AS ExOriginalAmount,
	0 AS ExConvertedQuantity,
	VoucherTypeID,
	AT2006.Description,
	AT2006.RefNo01,AT2006.RefNo02,
	AT2007.InventoryID,	
	AT1302.InventoryName,
	AT2007.UnitID,		
	isnull(AT2007.ConversionFactor ,1) AS ConversionFactor,
	AT1309.UnitID AS ConversionUnitID,
	AT1309.ConversionFactor AS ConversionFactor2,
	AT1309.Operator,
	isnull(AV2015.BeginQuantity,0) AS BeginQuantity,
	isnull(AV2015.BeginAmount,0) AS BeginAmount,
	0 AS EndQuantity,
	0 AS EndAmount,
	AT2007.Ana01ID, AT2007.Ana02ID, AT2007.Ana03ID, AT2007.Ana04ID, AT2007.Ana05ID,
	A1.AnaName AS Ana01Name, A2.AnaName AS Ana02Name, A3.AnaName AS Ana03Name, A4.AnaName AS Ana04Name, A5.AnaName AS Ana05Name, AT1302.Notes01,
	AT1302.I01ID, AT1302.I02ID, AT1302.I03ID, AT1302.I04ID, AT1302.I05ID,
	I1.AnaName AS I01Name, I2.AnaName AS I02Name, I3.AnaName AS I03Name, I4.AnaName AS I04Name, I5.AnaName AS I05Name,
	AT2006.ObjectID, AT1202.ObjectName, AT2007.DivisionID, AT2007.DebitAccountID, AT2007.CreditAccountID, AT2007.Notes '

SET @sSQLFrom = ' 
FROM AT2007 	
INNER JOIN AT1302 on AT1302.InventoryID = AT2007.InventoryID AND AT1302.DivisionID = AT2007.DivisionID
INNER JOIN AT2006 on AT2006.VoucherID = AT2007.VoucherID AND AT2006.DivisionID = AT2007.DivisionID
INNER JOIN AT1303 on AT1303.WarehouseID = AT2006.WarehouseID AND AT1303.DivisionID = AT2007.DivisionID
LEFT JOIN AT2015_Tmp AV2015 on AV2015.InventoryID = AT2007.InventoryID and
 		AV2015.WareHouseID = AT2006.WareHouseID  AND AV2015.DivisionID = AT2007.DivisionID
LEFT JOIN (SELECT	DivisionID,InventoryID,Min(UnitID) AS UnitID, 
					Min(ConversionFactor) AS ConversionFactor, 
					Min(Operator) AS Operator 
           FROM		AT1309 
           GROUP BY DivisionID,InventoryID) AT1309 
	ON	AT2007.InventoryID = AT1309.InventoryID AND AT1309.DivisionID = AT2007.DivisionID
LEFT JOIN AT1011 A1 On AT2007.Ana01ID = A1.AnaID AND A1.AnaTypeID = ''A01''  AND A1.DivisionID = AT2007.DivisionID
LEFT JOIN AT1011 A2 On AT2007.Ana02ID = A2.AnaID AND A2.AnaTypeID = ''A02''  AND A2.DivisionID = AT2007.DivisionID
LEFT JOIN AT1011 A3 On AT2007.Ana03ID = A3.AnaID AND A3.AnaTypeID = ''A03''  AND A3.DivisionID = AT2007.DivisionID
LEFT JOIN AT1011 A4 On AT2007.Ana04ID = A4.AnaID AND A4.AnaTypeID = ''A04''  AND A4.DivisionID = AT2007.DivisionID
LEFT JOIN AT1011 A5 On AT2007.Ana05ID = A5.AnaID AND A5.AnaTypeID = ''A05''  AND A5.DivisionID = AT2007.DivisionID
LEFT JOIN AT1015 I1 On AT1302.I01ID = I1.AnaID AND I1.AnaTypeID = ''I01''  AND I1.DivisionID = AT2007.DivisionID
LEFT JOIN AT1015 I2 On AT1302.I02ID = I2.AnaID AND I2.AnaTypeID = ''I02''  AND I2.DivisionID = AT2007.DivisionID
LEFT JOIN AT1015 I3 On AT1302.I03ID = I3.AnaID AND I3.AnaTypeID = ''I03''  AND I3.DivisionID = AT2007.DivisionID
LEFT JOIN AT1015 I4 On AT1302.I04ID = I4.AnaID AND I4.AnaTypeID = ''I04''  AND I4.DivisionID = AT2007.DivisionID
LEFT JOIN AT1015 I5 On AT1302.I05ID = I5.AnaID AND I5.AnaTypeID = ''I05''  AND I5.DivisionID = AT2007.DivisionID
LEFT JOIN AT1202 On AT2006.ObjectID = AT1202.ObjectID  AND AT1202.DivisionID = AT2007.DivisionID'
SET @sSQLWhere = ' 
WHERE	AT2007.DivisionID =''' + @DivisionID + ''' and
	(AT2006.VoucherDate Between ''' + @FromDateText + ''' AND ''' + @ToDateText + ''' ) and
	KindVoucherID in ' + @KindVoucherListIm + ' and
	(AT2007.InventoryID between N''' + @FromInventoryID + ''' AND N''' + @ToInventoryID + ''') and
	(AT2006.WareHouseID between N''' + @FromWareHouseID + ''' AND N''' + @ToWareHouseID + ''')'
SET @sSQLUnionSelect = ' 
UNION ALL

--- Phan Xuat kho
SELECT 	' + @WareHouseID1 + ' AS WareHouseID,
	AT1303.WareHouseName, 
	AT2006.VoucherID,
	AT2007.TransactionID,
	--cast(Day(AT2006.VoucherDate)+Month(AT2006.VoucherDate)* 100 + Year(AT2006.VoucherDate)*10000 AS char(8)) +  cast((Case when AT2006.KindVoucherID in' + @KindVoucherListIm + ' then 1 else 2 end) AS char(1)) + cast(AT2006.VoucherNo AS char(20))+ cast(AT2007.TransactionID AS char(20)) + cast(AT2007.InventoryID AS char(20))  AS Orders,
	cast(Day(AT2006.VoucherDate)+Month(AT2006.VoucherDate)* 100 + Year(AT2006.VoucherDate)*10000 AS char(8)) +  cast((Case when AT2006.KindVoucherID in(1,5,7,9,15,17)  then 1  When AT2006.KindVoucherID=3 then 2 Else  3 end) AS char(1)) + cast(AT2006.VoucherNo AS char(20))+ cast(AT2007.TransactionID AS char(20)) + cast(AT2007.InventoryID AS char(20))  AS Orders,
	AT2006.VoucherDate,
	VoucherNo,	
	Null AS ImVoucherDate,
	Null AS ImVoucherNo,		
	Null AS ImSourceNo,
	Null AS ImWareHouseID,	
	0 AS ImQuantity,
	Null AS ImUnitPrice ,
	0 AS ImConvertedAmount,
	0 AS ImOriginalAmount,
	0 AS ImConvertedQuantity,
	VoucherDate AS ExVoucherDate,
	VoucherNo AS ExVoucherNo,		
	SourceNo AS ExSourceNo,
	(Case when KindVoucherID = 3 then WareHouseID2 else AT2006.WareHouseID end) AS ExWareHouseID,	
	AT2007.ActualQuantity AS ExQuantity,
	AT2007.UnitPrice AS ExUnitPrice ,
	AT2007.ConvertedAmount AS ExConvertedAmount,
	AT2007.OriginalAmount AS ExOriginalAmount,
	isnull(AT2007.ConversionFactor ,1)*ActualQuantity AS ExConvertedQuantity,
	VoucherTypeID,
	AT2006.Description,
	AT2006.RefNo01,AT2006.RefNo02,
	AT2007.InventoryID,	
	AT1302.InventoryName,
	AT2007.UnitID,		
	isnull(AT2007.ConversionFactor ,1) AS ConversionFactor,
	AT1309.UnitID AS ConversionUnitID,
	AT1309.ConversionFactor AS ConversionFactor2,
	AT1309.Operator,
	isnull(AV2015.BeginQuantity,0) AS BeginQuantity,
	isnull(AV2015.BeginAmount,0) AS BeginAmount,
	0 AS EndQuantity,
	0 AS EndAmount,

	AT2007.Ana01ID, AT2007.Ana02ID, AT2007.Ana03ID, AT2007.Ana04ID, AT2007.Ana05ID,
	A1.AnaName AS Ana01Name, A2.AnaName AS Ana02Name, A3.AnaName AS Ana03Name, A4.AnaName AS Ana04Name, A5.AnaName AS Ana05Name, AT1302.Notes01,
	AT1302.I01ID, AT1302.I02ID, AT1302.I03ID, AT1302.I04ID, AT1302.I05ID,
	I1.AnaName AS I01Name, I2.AnaName AS I02Name, I3.AnaName AS I03Name, I4.AnaName AS I04Name, I5.AnaName AS I05Name,
	AT2006.ObjectID, AT1202.ObjectName, AT2007.DivisionID ,AT2007.DebitAccountID, AT2007.CreditAccountID, AT2007.Notes '

SET @sSQLUnionFrom = ' 
FROM AT2007 	
INNER JOIN AT1302 on AT1302.InventoryID = AT2007.InventoryID AND  AT1302.DivisionID = AT2007.DivisionID
INNER JOIN AT2006 on AT2006.VoucherID = AT2007.VoucherID AND  AT2006.DivisionID = AT2007.DivisionID
INNER JOIN AT1303 on AT1303.WareHouseID = 
	(Case When KindVoucherID = 3 then AT2006.WareHouseID2 else AT2006.WareHouseID end)  AND  AT1303.DivisionID = AT2007.DivisionID
LEFT JOIN AT2015_Tmp AV2015 on AV2015.InventoryID = AT2007.InventoryID and
	AV2015.WareHouseID = (Case When KindVoucherID = 3 then AT2006.WareHouseID2 else AT2006.WareHouseID end)  AND  AV2015.DivisionID = AT2007.DivisionID
LEFT JOIN (SELECT	DivisionID,InventoryID,Min(UnitID) AS UnitID, 
					Min(ConversionFactor) AS ConversionFactor, 
					Min(Operator) AS Operator 
           FROM		AT1309 
           GROUP BY DivisionID,InventoryID) AT1309 
	ON	AT2007.InventoryID = AT1309.InventoryID AND  AT1309.DivisionID = AT2007.DivisionID
LEFT JOIN AT1011 A1 On AT2007.Ana01ID = A1.AnaID AND A1.AnaTypeID = ''A01''  AND  A1.DivisionID = AT2007.DivisionID
LEFT JOIN AT1011 A2 On AT2007.Ana02ID = A2.AnaID AND A2.AnaTypeID = ''A02''  AND  A2.DivisionID = AT2007.DivisionID
LEFT JOIN AT1011 A3 On AT2007.Ana03ID = A3.AnaID AND A3.AnaTypeID = ''A03''  AND  A3.DivisionID = AT2007.DivisionID
LEFT JOIN AT1011 A4 On AT2007.Ana04ID = A4.AnaID AND A4.AnaTypeID = ''A04''  AND  A4.DivisionID = AT2007.DivisionID
LEFT JOIN AT1011 A5 On AT2007.Ana05ID = A5.AnaID AND A5.AnaTypeID = ''A05''  AND  A5.DivisionID = AT2007.DivisionID
LEFT JOIN AT1015 I1 On AT1302.I01ID = I1.AnaID AND I1.AnaTypeID = ''I01''  AND  I1.DivisionID = AT2007.DivisionID
LEFT JOIN AT1015 I2 On AT1302.I02ID = I2.AnaID AND I2.AnaTypeID = ''I02''  AND  I2.DivisionID = AT2007.DivisionID
LEFT JOIN AT1015 I3 On AT1302.I03ID = I3.AnaID AND I3.AnaTypeID = ''I03''  AND  I3.DivisionID = AT2007.DivisionID
LEFT JOIN AT1015 I4 On AT1302.I04ID = I4.AnaID AND I4.AnaTypeID = ''I04''  AND  I4.DivisionID = AT2007.DivisionID
LEFT JOIN AT1015 I5 On AT1302.I05ID = I5.AnaID AND I5.AnaTypeID = ''I05''  AND  I5.DivisionID = AT2007.DivisionID
LEFT JOIN AT1202 On AT2006.ObjectID = AT1202.ObjectID  AND  AT1202.DivisionID = AT2007.DivisionID'
SET @sSQLUnionWhere = ' 
Where	AT2007.DivisionID =''' + @DivisionID + ''' and
	(AT2006.VoucherDate Between ''' + @FromDateText + ''' AND ''' + @ToDateText + ''' ) and
	(AT2007.InventoryID between N''' + @FromInventoryID + ''' AND N''' + @ToInventoryID + ''') and
	( (KindVoucherID in ' + @KindVoucherListEx2 + ' AND  
	(AT2006.WareHouseID between N''' + @FromWareHouseID + ''' AND N''' + @ToWareHouseID + ''')) 
	or  (KindVoucherID = 3 AND (AT2006.WareHouseID2 between N''' + @FromWareHouseID + ''' AND N''' + @ToWareHouseID + ''')))
'
--PRINT (@sSQLSelect)
--PRINT (@sSQLFrom)
--PRINT(@sSQLWhere)
--PRINT(@sSQLUnionSelect)
--PRINT(@sSQLUnionFrom)
--PRINT(@sSQLUnionWhere)

IF EXISTS ( SELECT TOP 1
                1
            FROM
                SysObjects
            WHERE
                Name = 'AT2018' AND Xtype = 'U' )
	BEGIN
         DROP TABLE [dbo].[AT2018]
	
         CREATE TABLE [dbo].[AT2018]
         (
			--[APK] [uniqueidentifier] DEFAULT NEWID(),
           [WareHouseID] [nvarchar](50) NOT NULL ,
           [WareHouseName] [nvarchar](250) NULL ,
           [VoucherID] [nvarchar](50) NOT NULL ,
           [TransactionID] [nvarchar](50) NOT NULL ,
           [Orders] [nvarchar](250) NULL ,
           [VoucherDate] [datetime] NULL ,
           [VoucherNo] [nvarchar](50) NULL ,
           [ImVoucherDate] [datetime] NULL ,
           [ImVoucherNo] [nvarchar](50) NULL ,
           [ImSourceNo] [nvarchar](50) NULL ,
           [ImWareHouseID] [nvarchar](50) NULL ,
           [ImQuantity] [decimal](28,8) NULL ,
           [ImUnitPrice] [decimal](28,8) NULL ,
           [ImConvertedAmount] [decimal](28,8) NULL ,
           [ImOriginalAmount] [decimal](28,8) NULL ,
           [ImConvertedQuantity] [decimal](28,8) NULL ,
           [ExVoucherDate] [datetime] NULL ,
           [ExVoucherNo] [nvarchar](50) NULL ,
           [ExSourceNo] [nvarchar](50) NULL ,
           [ExWareHouseID] [nvarchar](50) NULL ,
           [ExQuantity] [decimal](28,8) NULL ,
           [ExUnitPrice] [decimal](28,8) NULL ,
           [ExConvertedAmount] [decimal](28,8) NULL ,
           [ExOriginalAmount] [decimal](28,8) NULL ,
           [ExConvertedQuantity] [decimal](28,8) NULL ,
           [VoucherTypeID] [nvarchar](50) NULL ,
           [Description] [nvarchar](250) NULL ,
           RefNo01 [nvarchar](100) NULL ,
           RefNo02 [nvarchar](100) NULL ,
           [InventoryID] [nvarchar](50) NULL ,
           [InventoryName] [nvarchar](250) NULL ,
           [UnitID] [nvarchar](50) NULL ,
           [ConversionFactor] [decimal](28,8) NULL ,
           [ConversionUnitID] [nvarchar](50) NULL ,
           [ConversionFactor2] [decimal](28,8) NULL ,
           [Operator] [tinyint] NULL ,
           [BeginQuantity] [decimal](28,8) NULL ,
           [BeginAmount] [decimal](28,8) NULL ,
           [EndQuantity] [decimal](28,8) NULL ,
           [EndAmount] [decimal](28,8) NULL ,
           [Ana01ID] [nvarchar](50) NULL ,
           [Ana02ID] [nvarchar](50) NULL ,
           [Ana03ID] [nvarchar](50) NULL ,
           [Ana04ID] [nvarchar](50) NULL ,
           [Ana05ID] [nvarchar](50) NULL ,
           [Ana01Name] [nvarchar](250) NULL ,
           [Ana02Name] [nvarchar](250) NULL ,
           [Ana03Name] [nvarchar](250) NULL ,
           [Ana04Name] [nvarchar](250) NULL ,
           [Ana05Name] [nvarchar](250) NULL ,
           [Notes01] [nvarchar](500) NULL ,
           [I01ID] [nvarchar](50) NULL ,
           [I02ID] [nvarchar](50) NULL ,
           [I03ID] [nvarchar](50) NULL ,
           [I04ID] [nvarchar](50) NULL ,
           [I05ID] [nvarchar](50) NULL ,
           [I01Name] [nvarchar](250) NULL ,
           [I02Name] [nvarchar](250) NULL ,
           [I03Name] [nvarchar](250) NULL ,
           [I04Name] [nvarchar](250) NULL ,
           [I05Name] [nvarchar](250) NULL ,
           [ObjectID] [nvarchar](50) NULL ,
           [ObjectName] [nvarchar](250) NULL ,
           [DivisionID] [nvarchar] (3) NOT NULL,
           [DebitAccountID] [nvarchar] (50) NULL,
           [CreditAccountID] [nvarchar] (50) NULL,
           [Notes] [nvarchar] (250) NULL,
--	CONSTRAINT [PK_AT2018] PRIMARY KEY NONCLUSTERED 
--(
--	[APK] ASC
--    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

--) ON [PRIMARY]
) ON [PRIMARY]

   END
EXEC ( 'INSERT INTO AT2018  (WareHouseID, WareHouseName, 	VoucherID,
	TransactionID, Orders,VoucherDate,
	VoucherNo, ImVoucherDate, ImVoucherNo,ImSourceNo, ImWareHouseID, ImQuantity, ImUnitPrice ,
	ImConvertedAmount, ImOriginalAmount, ImConvertedQuantity, ExVoucherDate,
	 ExVoucherNo,	 ExSourceNo, ExWareHouseID,	ExQuantity,ExUnitPrice ,
	ExConvertedAmount,ExOriginalAmount, ExConvertedQuantity,
	VoucherTypeID, Description, RefNo01,RefNo02,InventoryID,	
	InventoryName,UnitID,	 ConversionFactor, ConversionUnitID, ConversionFactor2, Operator, 
	BeginQuantity, BeginAmount, EndQuantity,EndAmount,
	Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID,Ana01Name, Ana02Name, Ana03Name, Ana04Name, Ana05Name,Notes01,
	I01ID, I02ID, I03ID, I04ID, I05ID,I01Name, I02Name, I03Name, I04Name, I05Name, ObjectID, ObjectName, DivisionID,
	DebitAccountID ,CreditAccountID, Notes
)'+@sSQLSelect+@sSQLFrom+@sSQLWhere+@sSQLUnionSelect+@sSQLUnionFrom+@sSQLUnionWhere )



SET @AT2018Cursor = CURSOR SCROLL KEYSET FOR SELECT
                                                 WareHouseID ,
                                                 VoucherID ,
                                                 TransactionID ,
                                                 VoucherDate ,
                                                 InventoryID ,
                                                 BeginQuantity ,
                                                 BeginAmount ,
                                                 ImQuantity ,
                                                 ExQuantity ,
                                                 ImConvertedAmount ,
                                                 ExConvertedAmount ,
                                                 Orders
                                             FROM
                                                 AT2018
                                             Where DivisionID = @DivisionID

OPEN @AT2018Cursor
FETCH NEXT FROM @AT2018Cursor INTO @WareHouseID,@VoucherID,@TransactionID,@VoucherDate,@InventoryID,@BeginQuantity,@BeginAmount,@ImQuantity,@ExQuantity,@ImAmount,@ExAmount,@Orders
WHILE @@FETCH_STATUS = 0
      BEGIN
            SET @ImQuant = ( SELECT
                                 sum(isnull(ImConvertedQuantity , 0))
                             FROM
                                 AT2018
                             WHERE
                                 Orders < @Orders AND WareHouseID = @WareHouseID AND InventoryID = @InventoryID AND DivisionID = @DivisionID)
            SET @ExQuant = ( SELECT
                                 sum(isnull(ExConvertedQuantity , 0))
                             FROM
                                 AT2018
                             WHERE
                                 Orders < @Orders AND WareHouseID = @WareHouseID AND InventoryID = @InventoryID  AND DivisionID = @DivisionID)
			SET @ImportAmount = ( SELECT
                                      sum(isnull(ImConvertedAmount , 0))
                                  FROM
                                      AT2018
                                  WHERE
                                      Orders < @Orders AND WareHouseID = @WareHouseID AND InventoryID = @InventoryID  AND DivisionID = @DivisionID)
            SET @ExportAmount = ( SELECT
                                      sum(isnull(ExConvertedAmount , 0))
                                  FROM
                                      AT2018
                                  WHERE
                                      Orders < @Orders AND WareHouseID = @WareHouseID AND InventoryID = @InventoryID  AND DivisionID = @DivisionID)
            SET @BeginQuantity = isnull(@BeginQuantity , 0) + isnull(@ImQuant , 0) - isnull(@ExQuant , 0)




	--Set @BeginAmount = isnull(@BeginAmount,0) + isnull(@ImAmount,0) - isnull(@ExAmount,0)
            SET @BeginAmount = isnull(@BeginAmount , 0) + isnull(@ImportAmount , 0) - isnull(@ExportAmount , 0)

            SET @EndQuant = isnull(@BeginQuantity , 0) + isnull(@ImQuantity , 0) - isnull(@ExQuantity , 0)

	--Set @EndAmount = @BeginAmount + isnull(@ImportAmount,0) - isnull(@ExportAmount,0)
            SET @EndAmount = isnull(@BeginAmount , 0) + isnull(@ImAmount , 0) - isnull(@ExAmount , 0)

            UPDATE
                AT2018
            SET
                BeginQuantity = @BeginQuantity ,
                BeginAmount = @BeginAmount ,
                EndQuantity = @EndQuant ,
                EndAmount = @EndAmount
            WHERE
                WareHouseID = @WareHouseID AND VoucherID = @VoucherID AND TransactionID = @TransactionID AND VoucherDate = @VoucherDate AND InventoryID = @InventoryID AND DivisionID = @DivisionID
            FETCH NEXT FROM @AT2018Cursor INTO @WareHouseID,@VoucherID,@TransactionID,@VoucherDate,@InventoryID,@BeginQuantity,@BeginAmount,@ImQuantity,@ExQuantity,@ImAmount,@ExAmount,@Orders
      END

CLOSE @AT2018Cursor
DEALLOCATE @AT2018Cursor

SET NOCOUNT OFF
-------------SELECT dữ liệu
SELECT * FROM AT2018

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

