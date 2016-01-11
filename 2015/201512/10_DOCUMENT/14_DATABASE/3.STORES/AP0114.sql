IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0114]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0114]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
-----  Created by Nguyen Van Nhan, Date 12/2/2003  
----  Purpose: In  bao cao Nhap xuat ton theo Lo  
-----  Edit by Nguyen Quoc Huy, Date 31/08/2006  
/********************************************  
'* Edited by: [GS] [Tố Oanh] [28/07/2010]  
'********************************************/  
---- Modified on 24/07/2013 by Lê Thị Thu Hiền : Bổ sung 5 khoản mục I01ID đến I05ID  
---- Bo sung cho 2T, load len 15 notes va 5 parameter  
---- Edit by Mai Duyen: Bo sung them 10AnaID,AnaName01,VoucherDate,Notes cho ViMec
---- Modified by Thanh Sơn on 16/07/2014: Lấy dữ liệu trực tiếp từ store, không sinh ra view (AV0114)
/*
 exec AP0114 @Divisionid=N'VM',@Fromwarehouseid=N'K01',@Towarehouseid=N'K99',@Frommonth=1,@Fromyear=2014,@Tomonth=1,
		@Toyear=2014,@Fromdate='2013-12-31 00:00:00',@Todate='2013-12-31 00:00:00',@Isdate=0,@Frominventoryid=N'001025-1',@Toinventoryid=N'X0003',@Isinner=1
  Select * from Av0114
 */

CREATE PROCEDURE [dbo].[AP0114]   
    @DivisionID AS nvarchar(50),   
    @FromWareHouseID AS nvarchar(50),  
    @ToWareHouseID AS nvarchar(50),  
    @FromMonth AS int,  
    @FromYear AS int,  
    @ToMonth AS int,  
    @ToYear AS int,  
    @FromDate datetime,  
    @ToDate datetime,  
    @IsDate AS tinyint,  --- (0 theo ky, 1 theo thang)  
    @FromInventoryID AS nvarchar(50),  
    @ToInventoryID AS  nvarchar(50),  
    @IsInner  AS tinyint ----- (0; khong co VCNB, 1: VCNB)  
AS  
Declare @sSQL AS nvarchar(4000),  
 @KindVoucherListEx  AS nvarchar(200),  
 @KindVoucherListIm  AS nvarchar(200),  
 @WareHouseID1 AS nvarchar(200),   
    @FromMonthYearText NVARCHAR(20),   
    @ToMonthYearText NVARCHAR(20),   
    @FromDateText NVARCHAR(20),   
    @ToDateText NVARCHAR(20)  
      
SET @FromMonthYearText = STR(@FromMonth + @FromYear * 100)  
SET @ToMonthYearText = STR(@ToMonth + @ToYear * 100)  
SET @FromDateText = CONVERT(NVARCHAR(20), @FromDate, 101)  
SET @ToDateText = CONVERT(NVARCHAR(20), @ToDate, 101) + ' 23:59:59'  
  
Set @KindVoucherListEx   = '';  
Set @KindVoucherListIm   = '';  
Set @WareHouseID1 = '';  
   
If @IsInner =0   
  Begin   
 Set @KindVoucherListIm ='(1,5,7,9,15,17) '  
 Set @KindVoucherListEx ='(2,4,6,8,10,14,20) '  
   
  End  
Else  
  Begin  
 Set @KindVoucherListIm ='(1,3,5,7,9,15,17) '  
 Set @KindVoucherListEx ='(2,3,4,6,8,10,14,20) '  
   
 End  
  
Set  @WareHouseID1 = ' Case When KindVoucherID = 3 then AT2006.WareHouseID2 else AT2006.WareHouseID end '  
  
---Step 01:  Xac dinh so du tra ra view AV0124  
 Exec AP0112 @DivisionID, @FromWareHouseID, @ToWareHouseID, @FromInventoryID, @ToInventoryID,@FromMonth, @FromYear,@ToMonth,@ToYear, @FromDate, @ToDate, @IsDate, @IsInner  
 
 --Exec AP0112 @Divisionid=N'VM',@Fromwarehouseid=N'K01',@Towarehouseid=N'K99',@Frominventoryid=N'001025-1',@Toinventoryid=N'X0003',@Frommonth=1,@Fromyear=2014,@Tomonth=1,@Toyear=2014,@Fromdate='2013-12-31 00:00:00',@Todate='2013-12-31 00:00:00',@Isdate=0,@Isinner=1
 
 
---Step 02:  Xac dinh so phat sinh.  
  
----- Step 02-1:  Xac dinh phat sinh nhap.  
If @IsDate =0  
Set @sSQL ='   
SELECT AT2007.InventoryID, AT2006.WareHouseID,AT2007.TransactionID AS ReTransactionID,   
  AT2006.VoucherNo, AT2006.VoucherDate,  AT2007.SourceNo, AT2007.LimitDate,   
  AT2007.UnitID, AT2007.UnitPrice, AT2007.ActualQuantity, AT2007.ConvertedQuantity,AT2007.OriginalAmount,   
  AT2007.ConvertedAmount, AT2007.DivisionID, AT2007.Notes01, AT2007.Notes02, AT2007.Notes03,   
  AT2007.Notes04, AT2007.Notes05, AT2007.Notes06, AT2007.Notes07, AT2007.Notes08,  
  AT2007.Notes09, AT2007.Notes10, AT2007.Notes11, AT2007.Notes12, AT2007.Notes13,   
  AT2007.Notes14, AT2007.Notes15, AT2007.Parameter01, AT2007.Parameter02, AT2007.Parameter03, AT2007.Parameter04, AT2007.Parameter05, isnull(AT2007.MarkQuantity,0) as MarkQuantity ,
 AT2007.Ana01ID,AT2007.Ana02ID,AT2007.Ana03ID,AT2007.Ana04ID,AT2007.Ana05ID,AT2007.Ana06ID,AT2007.Ana07ID,AT2007.Ana08ID,AT2007.Ana09ID,AT2007.Ana10ID,
 AT2007.Notes
FROM  AT2007   
INNER JOIN AT2006   
 ON  AT2006.VoucherID = AT2007.VoucherID AND AT2006.DivisionID = AT2007.DivisionID  
WHERE AT2006.DivisionID =''' + @DivisionID + ''' AND   
  (AT2007.InventoryID like '''+@FromInventoryID+''' or   
  AT2007.InventoryID between '''+@FromInventoryID+''' AND '''+@ToInventoryID+''') AND  
  (AT2006.WareHouseID  like '''+@FromWareHouseID+''' or   
  AT2006.WareHouseID between  '''+@FromWareHouseID+''' AND  '''+@ToWareHouseID+''') AND  
  (AT2006.TranMonth + AT2006.TranYear*100 >= '+@FromMonthYearText+ '    
  and AT2006.TranMonth + AT2006.TranYear*100 <= '+@ToMonthYearText+ '  
  )  AND  
  KindVoucherID in  '+ @KindVoucherListIm +'  
  
'  
Else  
 Set @sSQL ='  
SELECT AT2007.InventoryID, AT2006.WareHouseID,AT2007.TransactionID AS ReTransactionID,   
  AT2006.VoucherNo, AT2006.VoucherDate,  AT2007.SourceNo, AT2007.LimitDate, 
  AT2007.UnitID,  AT2007.UnitPrice,   
  AT2007.ActualQuantity, AT2007.ConvertedQuantity,AT2007.OriginalAmount, AT2007.ConvertedAmount, AT2007.DivisionID,   
  AT2007.Notes01, AT2007.Notes02, AT2007.Notes03,   
  AT2007.Notes04, AT2007.Notes05, AT2007.Notes06, AT2007.Notes07, AT2007.Notes08,  
  AT2007.Notes09, AT2007.Notes10, AT2007.Notes11, AT2007.Notes12, AT2007.Notes13,   
  AT2007.Notes14, AT2007.Notes15, AT2007.Parameter01, AT2007.Parameter02, AT2007.Parameter03, AT2007.Parameter04, AT2007.Parameter05, isnull(AT2007.MarkQuantity,0) as MarkQuantity , 
  AT2007.Ana01ID,AT2007.Ana02ID,AT2007.Ana03ID,AT2007.Ana04ID,AT2007.Ana05ID,AT2007.Ana06ID,AT2007.Ana07ID,AT2007.Ana08ID,AT2007.Ana09ID,AT2007.Ana10ID,
 AT2007.Notes
FROM AT2007   
INNER JOIN AT2006 ON AT2006.VoucherID = AT2007.VoucherID AND AT2006.DivisionID = AT2007.DivisionID  
WHERE AT2006.DivisionID =''' + @DivisionID + ''' AND   
  (AT2007.InventoryID like '''+@FromInventoryID+''' or   
  AT2007.InventoryID between '''+@FromInventoryID+''' AND '''+@ToInventoryID+''') AND  
  (AT2006.WareHouseID  like '''+@FromWareHouseID+''' or   
  AT2006.WareHouseID between  '''+@FromWareHouseID+''' AND  '''+@ToWareHouseID+''') AND  
  (AT2006.VoucherDate  >= '''+@FromDateText+'''    
  and AT2006.VoucherDate <= '''+@ToDateText+'''  
  )  AND  
  KindVoucherID in  '+ @KindVoucherListIm +'  
  
 '  
IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE XTYPE='V' AND NAME ='AV0128')  
 EXEC('CREATE VIEW AV0128  -----TAO BOI AP0114  
  AS '+@sSQL)  
ELSE  
 EXEC('ALTER VIEW AV0128  -----TAO BOI AP0114  
  AS '+@sSQL)  
  
  
------ Step 02-2:  Xac dinh phat sinh xuat.  
If @IsDate = 0  
Set @sSQL ='   
SELECT AT2007.ReTransactionID,   '+ @WareHouseID1 +' AS WareHouseID, AT2007.InventoryID, AT2007.UnitPrice,   
  SUM(ISNULL(AT2007.ActualQuantity,0)) AS ExQuantity,  
    SUM(ISNULL(AT2007.ConvertedQuantity,0)) AS ExConvertedQuantity,  
  SUM(ISNULL(AT2007.OriginalAmount,0)) AS ExOriginalAmount ,   
  SUM(ISNULL( AT2007.ConvertedAmount,0)) AS ExConvertedAmount, AT2007.DivisionID,   
  AT2007.Notes01, AT2007.Notes02, AT2007.Notes03,   
  AT2007.Notes04, AT2007.Notes05, AT2007.Notes06, AT2007.Notes07, AT2007.Notes08,  
  AT2007.Notes09, AT2007.Notes10, AT2007.Notes11, AT2007.Notes12, AT2007.Notes13,   
  AT2007.Notes14, AT2007.Notes15, AT2007.Parameter01, AT2007.Parameter02, AT2007.Parameter03, AT2007.Parameter04, AT2007.Parameter05, SUM(ISNULL(AT2007.MarkQuantity,0)) AS ExMarkQuantity  ,
  AT2007.Ana01ID,AT2007.Ana02ID,AT2007.Ana03ID,AT2007.Ana04ID,AT2007.Ana05ID,AT2007.Ana06ID,AT2007.Ana07ID,AT2007.Ana08ID,AT2007.Ana09ID,AT2007.Ana10ID,
  Max(isnull(AT2007.Notes,'''')) as Notes ,Max(AT2006.VoucherDate) as VoucherDate
FROM AT2007   
INNER JOIN AT2006 ON AT2006.VoucherID = AT2007.VoucherID AND AT2006.DivisionID = AT2007.DivisionID  
WHERE AT2006.DivisionID =''' + @DivisionID + ''' AND   
  (AT2007.InventoryID like '''+@FromInventoryID+''' or   
  AT2007.InventoryID between '''+@FromInventoryID+''' AND '''+@ToInventoryID+''') AND  
  ('+@WareHouseID1+' like '''+@FromWareHouseID+''' or   
  '+@WareHouseID1+' between  '''+@FromWareHouseID+''' AND  '''+@ToWareHouseID+''') AND  
  (AT2006.TranMonth + AT2006.TranYear*100 >= '+@FromMonthYearText+ '    
  and AT2006.TranMonth + AT2006.TranYear*100 <= '+@ToMonthYearText+ '  
  )  AND  
  KindVoucherID in '+ @KindVoucherListEx+'  
GROUP BY ReTransactionID,  '+ @WareHouseID1 +',  InventoryID, AT2007.UnitPrice, AT2007.DivisionID,   
  AT2007.Notes01, AT2007.Notes02, AT2007.Notes03,   
  AT2007.Notes04, AT2007.Notes05, AT2007.Notes06, AT2007.Notes07, AT2007.Notes08,  
  AT2007.Notes09, AT2007.Notes10, AT2007.Notes11, AT2007.Notes12, AT2007.Notes13,   
  AT2007.Notes14, AT2007.Notes15, AT2007.Parameter01, AT2007.Parameter02, AT2007.Parameter03, AT2007.Parameter04, AT2007.Parameter05 ,
  AT2007.Ana01ID,AT2007.Ana02ID,AT2007.Ana03ID,AT2007.Ana04ID,AT2007.Ana05ID,AT2007.Ana06ID,AT2007.Ana07ID,AT2007.Ana08ID,AT2007.Ana09ID,AT2007.Ana10ID
'  
  
Else   
Set @sSQL ='   
SELECT AT2007.ReTransactionID,   '+ @WareHouseID1 +' AS WareHouseID, AT2007.InventoryID, AT2007.UnitPrice,   
  SUM(AT2007.ActualQuantity) AS ExQuantity,  
    SUM(AT2007.ConvertedQuantity) AS ExConvertedQuantity,  
  SUM(AT2007.OriginalAmount) AS ExOriginalAmount ,   
  SUM( AT2007.ConvertedAmount) AS ExConvertedAmount, AT2007.DivisionID,   
  AT2007.Notes01, AT2007.Notes02, AT2007.Notes03,   
  AT2007.Notes04, AT2007.Notes05, AT2007.Notes06, AT2007.Notes07, AT2007.Notes08,  
  AT2007.Notes09, AT2007.Notes10, AT2007.Notes11, AT2007.Notes12, AT2007.Notes13,   
  AT2007.Notes14, AT2007.Notes15, AT2007.Parameter01, AT2007.Parameter02, AT2007.Parameter03, AT2007.Parameter04, AT2007.Parameter05, SUM(ISNULL(AT2007.MarkQuantity,0)) AS ExMarkQuantity,
  AT2007.Ana01ID,AT2007.Ana02ID,AT2007.Ana03ID,AT2007.Ana04ID,AT2007.Ana05ID,AT2007.Ana06ID,AT2007.Ana07ID,AT2007.Ana08ID,AT2007.Ana09ID,AT2007.Ana10ID,
  Max(isnull(AT2007.Notes,'''')) as Notes ,Max(AT2006.VoucherDate) as VoucherDate
FROM AT2007   
INNER JOIN AT2006 ON AT2006.VoucherID = AT2007.VoucherID AND AT2006.DivisionID = AT2007.DivisionID  
WHERE AT2006.DivisionID =''' + @DivisionID + ''' AND   
  (AT2007.InventoryID like '''+@FromInventoryID+''' or   
  AT2007.InventoryID between '''+@FromInventoryID+''' AND '''+@ToInventoryID+''') AND  
  ('+@WareHouseID1+' like '''+@FromWareHouseID+''' or   
  '+@WareHouseID1+' between  '''+@FromWareHouseID+''' AND  '''+@ToWareHouseID+''') AND  
  (AT2006.VoucherDate  >= '''+@FromDateText+'''    
  and AT2006.VoucherDate <= '''+@ToDateText+'''  
  )  AND  
  KindVoucherID in '+ @KindVoucherListEx+'  
GROUP BY ReTransactionID, '+ @WareHouseID1 +',InventoryID,AT2007.UnitPrice, AT2007.DivisionID,   
  AT2007.Notes01, AT2007.Notes02, AT2007.Notes03,   
  AT2007.Notes04, AT2007.Notes05, AT2007.Notes06, AT2007.Notes07, AT2007.Notes08,  
  AT2007.Notes09, AT2007.Notes10, AT2007.Notes11, AT2007.Notes12, AT2007.Notes13,   
  AT2007.Notes14, AT2007.Notes15, AT2007.Parameter01, AT2007.Parameter02, AT2007.Parameter03, AT2007.Parameter04, AT2007.Parameter05,
  AT2007.Ana01ID,AT2007.Ana02ID,AT2007.Ana03ID,AT2007.Ana04ID,AT2007.Ana05ID,AT2007.Ana06ID,AT2007.Ana07ID,AT2007.Ana08ID,AT2007.Ana09ID,AT2007.Ana10ID
  '  
--Print  @sSQL  
  
IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE XTYPE='V' AND NAME ='AV0129')  
 EXEC('CREATE VIEW AV0129  -----TAO BOI AP0114  
  AS '+@sSQL)  
ELSE  
 EXEC('ALTER VIEW AV0129  -----TAO BOI AP0114  
  AS '+@sSQL)  
    
------ Step 02-3:  Xac dinh phat sinh du-nhap  
Set @sSQL='  
SELECT AV01.InventoryID, AT1302.InventoryName, AV01.WareHouseID, WareHouseName, AV01.ReTransactionID,   
  AV01.VoucherNo, AV01.SourceNo, AV01.LimitDate, AV01.UnitID,  AV01.UnitPrice,   
  AV01.ActualQuantity AS BeginQuantity,   
    AV01.ConvertedQuantity AS BeginConvertedQuantity,   
  AV01.OriginalAmount AS BeginOriginalAmount,   
  AV01.ConvertedAmount AS BeginConvertedAmount,  
  0 AS DebitQuantity, 0 AS DebitConvertedQuantity,   
  0 AS DebitOriginalAmount, 0 AS DebitConvertedAmount, AV01.DivisionID,  
  AV01.Notes01, AV01.Notes02, AV01.Notes03,   
  AV01.Notes04, AV01.Notes05, AV01.Notes06, AV01.Notes07, AV01.Notes08,  
  AV01.Notes09, AV01.Notes10, AV01.Notes11, AV01.Notes12, AV01.Notes13,   
  AV01.Notes14, AV01.Notes15, AV01.Parameter01, AV01.Parameter02, AV01.Parameter03, AV01.Parameter04, AV01.Parameter05,AV01.MarkQuantity as BeginMarkQuantity, 0 as DebitMarkQuantity,  
  AT1302.I01ID,AT1302.I02ID,AT1302.I03ID,AT1302.I04ID,AT1302.I05ID ,
  AV01.Ana01ID,AV01.Ana02ID,AV01.Ana03ID,AV01.Ana04ID,AV01.Ana05ID,AV01.Ana06ID,AV01.Ana07ID,AV01.Ana08ID,AV01.Ana09ID,AV01.Ana10ID,
  AV01.Notes,AV01.VoucherDate 
  
FROM  AV0125 AV01   
INNER JOIN AT1302   
 ON  AT1302.InventoryID =AV01.InventoryID AND at1302.DivisionID = AV01.DivisionID  
INNER JOIN AT1303   
 ON  AT1303.WareHouseID =AV01.WareHouseID AND AT1303.DivisionID = AV01.DivisionID  
WHERE  IsSource = 1  
UNION ALL  
SELECT AV02.InventoryID,  AT1302.InventoryName, AV02.WareHouseID, WareHouseName, AV02.ReTransactionID,   
  AV02.VoucherNo, AV02.SourceNo, AV02.LimitDate, AV02.UnitID,  AV02.UnitPrice,   
  0 AS BeginQuantity, 0 AS BeginConvertedQuantity,0 AS BeginOriginalAmount, 0 AS BeginConvertedAmount,  
  AV02.ActualQuantity AS DebitQuantity, AV02.ConvertedQuantity AS DebitConvertedQuantity,AV02.OriginalAmount AS DebitOriginalAmount,   
  AV02.ConvertedAmount AS DebitConvertedAmount, AV02.DivisionID,  
  AV02.Notes01, AV02.Notes02, AV02.Notes03,   
  AV02.Notes04, AV02.Notes05, AV02.Notes06, AV02.Notes07, AV02.Notes08,  
  AV02.Notes09, AV02.Notes10, AV02.Notes11, AV02.Notes12, AV02.Notes13,   
  AV02.Notes14, AV02.Notes15,  
  AV02.Parameter01, AV02.Parameter02, AV02.Parameter03, AV02.Parameter04, AV02.Parameter05,  
  0 as BeginMarkQuantity, AV02.MarkQuantity AS DebitMarkQuantity,  
  AT1302.I01ID,AT1302.I02ID,AT1302.I03ID,AT1302.I04ID,AT1302.I05ID,
   AV02.Ana01ID,AV02.Ana02ID,AV02.Ana03ID,AV02.Ana04ID,AV02.Ana05ID,AV02.Ana06ID,AV02.Ana07ID,AV02.Ana08ID,AV02.Ana09ID,AV02.Ana10ID,
  AV02.Notes,AV02.VoucherDate   
FROM  AV0128 AV02   
INNER JOIN AT1302 on AT1302.InventoryID =AV02.InventoryID AND AT1302.DivisionID =AV02.DivisionID  
INNER JOIN AT1303 on AT1303.WareHouseID =AV02.WareHouseID AND AT1303.DivisionID =AV02.DivisionID  
WHERE  IsSource = 1 '  
  
IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE XTYPE='V' AND NAME ='AV0120')  
 EXEC('CREATE VIEW AV0120  -----TAO BOI AP0114  
  AS '+@sSQL)  
ELSE  
 EXEC('ALTER VIEW AV0120  -----TAO BOI AP0114  
  AS '+@sSQL)  
  
------ Step 02-4:  Xac dinh phat sinh du-nhap - xuat
SET @sSQL = '  
SELECT DISTINCT AV0120.InventoryID, AV0120.InventoryName,  AV0120.WareHouseID,AV0120.WareHouseName, AV0120.ReTransactionID,   
  AV0120.VoucherNo, AV0120.SourceNo , AV0120.LimitDate, AV0120.UnitID,   AV0120.UnitPrice,  
  AV0120.BeginQuantity, AV0120.BeginConvertedQuantity, AV0120.BeginOriginalAmount, AV0120.BeginConvertedAmount ,  
  AV0120.DebitQuantity, AV0120.DebitConvertedQuantity, AV0120.DebitOriginalAmount, AV0120.DebitConvertedAmount ,  
  EXQuantity,EXConvertedQuantity,EXMarkQuantity,ExOriginalAmount,ExConvertedAmount, Av0120.DivisionID,  
  AV0120.Notes01, AV0120.Notes02, AV0120.Notes03,   
  AV0120.Notes04, AV0120.Notes05, AV0120.Notes06, AV0120.Notes07, AV0120.Notes08,
  AV0120.Notes09, AV0120.Notes10, AV0120.Notes11, AV0120.Notes12, AV0120.Notes13,   
  AV0120.Notes14, AV0120.Notes15, AV0120.BeginMarkQuantity, AV0120.DebitMarkQuantity,  
  AV0120.Parameter01, AV0120.Parameter02, AV0120.Parameter03, AV0120.Parameter04, AV0120.Parameter05,  
  AV0120.I01ID,AV0120.I02ID,AV0120.I03ID,AV0120.I04ID,AV0120.I05ID  ,
  AV0120.Ana01ID,AV0120.Ana02ID,AV0120.Ana03ID,AV0120.Ana04ID,AV0120.Ana05ID,AV0120.Ana06ID,AV0120.Ana07ID,AV0120.Ana08ID,AV0120.Ana09ID,AV0120.Ana10ID,
  AV0120.Notes,AV0120.VoucherDate, 
  T1.AnaName as AnaName01, T2.AnaName as AnaName02, T3.AnaName as AnaName03, T4.AnaName as AnaName04, T5.AnaName as AnaName05
FROM AV0120  
LEFT  JOIN AT1011	T1 on T1.AnaID = AV0120.Ana01ID And T1.AnaTypeID = ''A01'' AND T1.DivisionID = AV0120.DivisionID
LEFT  JOIN AT1011	T2 on T2.AnaID = AV0120.Ana02ID And T2.AnaTypeID = ''A02'' AND T2.DivisionID = AV0120.DivisionID
LEFT  JOIN AT1011	T3 on T3.AnaID = AV0120.Ana03ID And T3.AnaTypeID = ''A03'' AND T3.DivisionID = AV0120.DivisionID
LEFT  JOIN AT1011	T4 on T4.AnaID = AV0120.Ana04ID And T4.AnaTypeID = ''A04'' AND T4.DivisionID = AV0120.DivisionID
LEFT  JOIN AT1011	T5 on T5.AnaID = AV0120.Ana05ID And T5.AnaTypeID = ''A05'' AND T5.DivisionID = AV0120.DivisionID
LEFT  JOIN  AV0129  AV0119 ON AV0119.InventoryID = AV0120.InventoryID   

   AND AV0119.DivisionID = AV0120.DivisionID  
      AND AV0119.WareHouseID = AV0120.WareHouseID  
      AND AV0119.ReTransactionID = AV0120.ReTransactionID '  

CREATE TABLE #CustomerIndex (CustomerName INT, ImportExcel INT)
INSERT INTO #CustomerIndex (CustomerName, ImportExcel) EXEC AP4444 
IF (SELECT TOP 1 CustomerName FROM #CustomerIndex) = 23
	EXEC AP0114VG @DivisionID, 'ASOFTADMIN', @FromMonth, @FromYear, @ToMonth, @ToYear, @FromDate, @ToDate, @IsDate, @FromInventoryID, @ToInventoryID, @FromWareHouseID, @ToWareHouseID, @IsInner

ELSE EXEC (@sSQL)  


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
