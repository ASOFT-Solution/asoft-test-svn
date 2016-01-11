IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0214]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0214]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-----Created by Nguyen Van Nhan.
-----Created Date 27/03/2006.
-----Purpose: In chi tiet phieu xuat theo thuc te dich danh.
-----Last Update: Nguyen Thi Thuy Tuyen Date:05/09/2006 , Purpose: Lay them truong ObjectID, ObjectName
-----Edited by Nguyen Quoc Huy, Date 07/11/2006
-----Last Edit by  Nguyen Quoc Huy ,Date 29/12/2006-- Them phan union 
-----Modified on 08/02/2012 by Le Thi Thu Hien : Bo sung them JOIN DivisionID
-----Edited by: [GS] [Tố Oanh] [27/09/2013]: bổ sung trường RefNo01, RefNo02, UnitName
-----Modified by Thanh Sơn on 16/07/2014: lấy dữ liệu trực tiếp từ store, không sinh view AV0214
-----Modified by Tiểu Mai on 02/12/2015: Lấy trường Ana01ID và AnaName01 từ AV2777
/********************************************
'* Edited by: [GS] [Tố Oanh] [28/07/2010]
'********************************************/

CREATE PROCEDURE  [dbo].[AP0214] 
				@DivisionID AS nvarchar(50), 
				@FromWareHouseID AS nvarchar(50),
				@ToWareHouseID AS nvarchar(50),
				@FromMonth AS int,
				@FromYear AS int,
				@ToMonth AS int,
				@ToYear AS int,
				@FromDate datetime,
				@ToDate datetime,
				@IsDate AS tinyint,
				@FromInventoryID AS nvarchar(50),
				@ToInventoryID AS  nvarchar(50),
				@IsInner  AS tinyint ----- (0; khong co VCNB, 1: VCNB)
	
 AS

Declare @sSQLSelect AS nvarchar(max),
		@sSQLFrom AS nvarchar(max),
		@sSQLWhere AS nvarchar(max),
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

Set  @WareHouseID1 = ' CASE WHEN A.KindVoucherID = 3 then A.WareHouseID2 else A.WareHouseID end '

If @IsDate =1  --- Theo ngay
begin
Set @sSQLSelect ='
---lay phieu xuat kho cua ky nay tuong ung voi phieu nhap kho
SELECT 	A.VoucherDate AS DeVoucherDate, 
	A.VoucherNo AS DeVoucherNo,
	' +@WareHouseID1 +' AS WareHouseID,
	B.InventoryID, 
	AT1302.InventoryName,
	AT1302.UnitID,
	AT1302.I01ID,
	AT1302.I02ID,
	AT1302.I03ID,
	AT1302.I04ID,
	AT1302.I05ID,	
	I1.AnaName AS AnaName1,
	I2.AnaName AS AnaName2,
	I3.AnaName AS AnaName3,
	I4.AnaName AS AnaName4,
	I5.AnaName AS AnaName5,
	AT1302.VATPercent,
	AT1302.Notes01, AT1302.Notes02,AT1302.Notes03, AT1302.Specification,
	B.ActualQuantity AS DeQuantity,
	B.ConvertedAmount AS DeAmount,
	E.ActualQuantity AS ReQuantity,
	E.ConvertedAmount AS ReAmount,
	B.ReVoucherID,
	D.VoucherNo AS ReVoucherNo,
	D.VoucherDate AS ReVoucherDate, 
	D.ObjectID AS ReObjectID,
	F.ObjectName AS ReObjectName ,
	B.ReTransactionID,
	B.SourceNo AS ReSourceNo,		
	B.LimitDate,
	A.ObjectID,
	AT1202.ObjectName,
	B.DivisionID,
	A.RefNo01,  
	A.RefNo02,
	G.UnitName,
	B.Ana01ID,
	A01.AnaName as AnaName01

From  AV2777 B 
INNER JOIN AV2666  A on A.VoucherID = B.VoucherID AND A.DivisionID = B.DivisionID
INNER JOIN AT1302 C on C.InventoryID = B.InventoryID and C.DivisionID = B.DivisionID
INNER JOIN AV2666  D on D.VoucherID = B.ReVoucherID and D.DivisionID = B.DivisionID
INNER JOIN AT1302 on AT1302.InventoryID = B.InventoryID and AT1302.DivisionID = B.DivisionID
INNER JOIN AV2777 E on E.TransactionID = B.ReTransactionID and E.DivisionID = B.DivisionID
LEFT JOIN AT1015 I1 on I1.AnaID = AT1302.I01ID and I1.AnaTypeID =''I01'' and I1.DivisionID = AT1302.DivisionID
LEFT JOIN AT1015 I2 on I2.AnaID = AT1302.I01ID and I2.AnaTypeID =''I02'' and I2.DivisionID = AT1302.DivisionID
LEFT JOIN AT1015 I3 on I3.AnaID = AT1302.I01ID and I3.AnaTypeID =''I03'' and I3.DivisionID = AT1302.DivisionID
LEFT JOIN AT1015 I4 on I4.AnaID = AT1302.I01ID and I4.AnaTypeID =''I04'' and I4.DivisionID = AT1302.DivisionID
LEFT JOIN AT1015 I5 on I5.AnaID = AT1302.I01ID and I5.AnaTypeID =''I05'' and I5.DivisionID = AT1302.DivisionID
LEFT JOIN AT1202 on    AT1202.ObjectID = A.ObjectID and AT1202.DivisionID = A.DivisionID
LEFT JOIN AT1202 F on    F.ObjectID = D.ObjectID and F.DivisionID = D.DivisionID
LEFT JOIN AT1304 G on G.UnitID = AT1302.UnitID AND  G.DivisionID = AT1302.DivisionID
LEFT JOIN AT1011 A01 ON A01.DivisionID = B.DivisionID AND A01.AnaID = B.Ana01ID and A01.AnaTypeID = ''A01''
Where  (B.InventoryID between '''+@FromInventoryID+''' and '''+@ToInventoryID+''') and 
	B.ReTransactionID in (Select ReTransactionID From AT0114 
				Where 
					(ReVoucherDate < ='''+@ToDateText+''' ) and
					( '+@WareHouseID1+' between '''+@FromWareHouseID+''' and ''' + @ToWareHouseID + ''') and
					DivisionID ='''+@DivisionID+''' ) And

	B.VoucherID IN (Select  VoucherID FROM AV2666 
				WHERE KINDVOUCHERID IN  '+ @KindVoucherListEx+'  AND 
					(VoucherDate  Between   '''+@FromDateText+'''  and  '''+@ToDateText+''' ) And
						( '+@WareHouseID1+' between '''+@FromWareHouseID+''' and ''' + @ToWareHouseID + ''') and
						DivisionID ='''+@DivisionID+''' ) and
	AT1302.IsSource = 1 and
            A.VoucherDate <=  '''+@ToDateText+''' 

Union all'

Set @sSQLFrom ='
---Lay phieu chua xuat kho
Select 	null  AS DeVoucherdate,
	'''' AS DeVoucherNo, 	
	A.WareHouseID,
	B.InventoryID, 
	AT1302.InventoryName,
	AT1302.UnitID,
	AT1302.I01ID,
	AT1302.I02ID,
	AT1302.I03ID,
	AT1302.I04ID,
	AT1302.I05ID,	
	I1.AnaName AS AnaName1,
	I2.AnaName AS AnaName2,
	I3.AnaName AS AnaName3,
	I4.AnaName AS AnaName4,
	I5.AnaName AS AnaName5,
	AT1302.VATPercent,
	AT1302.Notes01, AT1302.Notes02,AT1302.Notes03, AT1302.Specification,
	0 AS DeQuantity,
	0 AS DeAmount,
	B.ReQuantity AS ReQuantity,
	E.ConvertedAmount  AS ReAmount,
	B.ReVoucherID,
	A.VoucherNo AS ReVoucherNo,
	A.VoucherDate AS ReVoucherDate, 
	A.ObjectID AS ReObjectID,
	AT1202.ObjectName AS ReObjectName,
	--B.ReTransactionID,
	B.ReTransactionID AS ReTransactionID ,
	B.ReSourceNo AS ReSourceNo,		
	B.LimitDate,
	null AS ObjectID,
	Null AS ObjectName,
	B.DivisionID,
	A.RefNo01,  
	A.RefNo02,
	G.UnitName,
	E.Ana01ID,
	A01.AnaName as AnaName01

From  AT0114 B  
INNER JOIN AV2666  A on A.VoucherID = B.ReVoucherID and A.DivisionID = B.DivisionID
INNER JOIN AV2777 E on E.TransactionID = B.ReTransactionID and E.DivisionID = B.DivisionID
INNER JOIN AT1302 C on C.InventoryID = B.InventoryID and C.DivisionID = B.DivisionID
INNER JOIN AT1302 on 	AT1302.InventoryID = B.InventoryID and AT1302.DivisionID = B.DivisionID
LEFT JOIN AT1015 I1 on I1.AnaID = AT1302.I01ID and I1.AnaTypeID =''I01'' and I1.DivisionID = AT1302.DivisionID
LEFT JOIN AT1015 I2 on I2.AnaID = AT1302.I01ID and I2.AnaTypeID =''I02'' and I2.DivisionID = AT1302.DivisionID
LEFT JOIN AT1015 I3 on I3.AnaID = AT1302.I01ID and I3.AnaTypeID =''I03'' and I3.DivisionID = AT1302.DivisionID
LEFT JOIN AT1015 I4 on I4.AnaID = AT1302.I01ID and I4.AnaTypeID =''I04'' and I4.DivisionID = AT1302.DivisionID
LEFT JOIN AT1015 I5 on I5.AnaID = AT1302.I01ID and I5.AnaTypeID =''I05'' and I5.DivisionID = AT1302.DivisionID
LEFT JOIN AT1202 on    AT1202.ObjectID = A.ObjectID and AT1202.DivisionID = A.DivisionID
LEFT JOIN AT1304 G on G.UnitID = AT1302.UnitID AND  G.DivisionID = AT1302.DivisionID
LEFT JOIN AT1011 A01 ON A01.DivisionID = E.DivisionID AND A01.AnaID = E.Ana01ID and A01.AnaTypeID = ''A01''
Where  (B.InventoryID between '''+@FromInventoryID+''' and '''+@ToInventoryID+''') and 
	B.DeQuantity =0 and							
	A.KindVoucherID   in '+ @KindVoucherListIm +' and 
	(ReVoucherDate Between '''+@FromDateText+'''  and  '''+@ToDateText+''' ) and
						(A.WareHouseID between '''+@FromWareHouseID+''' and ''' + @ToWareHouseID + ''') and
						A.DivisionID ='''+@DivisionID+''' and

	AT1302.IsSource = 1

---- Begin q.huy them vao
union all'

Set @sSQLWhere ='
Select 	null AS DeVoucherDate, 
	null AS DeVoucherNo,
	WareHouseID ,
	B.InventoryID, 
	AT1302.InventoryName,
	AT1302.UnitID,
	AT1302.I01ID,
	AT1302.I02ID,
	AT1302.I03ID,
	AT1302.I04ID,
	AT1302.I05ID,	
	I1.AnaName AS AnaName1,
	I2.AnaName AS AnaName2,
	I3.AnaName AS AnaName3,
	I4.AnaName AS AnaName4,
	I5.AnaName AS AnaName5,
	AT1302.VATPercent,
	AT1302.Notes01, AT1302.Notes02,AT1302.Notes03, AT1302.Specification,
	null AS DeQuantity,
	null  AS DeAmount,
	B.ActualQuantity  AS ReQuantity,
	B.ConvertedAmount AS ReAmount,
	B.ReVoucherID,
	
	A.VoucherNo  AS ReVoucherNo,
	A.VoucherDate AS ReVoucherDate, 
	A.ObjectID AS ReObjectID,
	
	AT1202.ObjectName AS ReObjectName ,
	B.TransactionID AS ReTransactionID,
	B.SourceNo AS ReSourceNo,		
	B.LimitDate,
	null AS ObjectID,
	null AS ObjectName,
	B.DivisionID,
	A.RefNo01,  
	A.RefNo02,
	G.UnitName,
	B.Ana01ID,
	A01.AnaName as AnaName01

From  AV2777   B 
INNER JOIN AV2666   A on A.VoucherID = B.VoucherID and A.DivisionID = B.DivisionID
INNER JOIN AT1302 C on C.InventoryID = B.InventoryID and C.DivisionID = B.DivisionID
INNER JOIN AT1302 on 	AT1302.InventoryID = B.InventoryID and AT1302.DivisionID = B.DivisionID
LEFT JOIN AT1015 I1 on I1.AnaID = AT1302.I01ID and I1.AnaTypeID =''I01'' and I1.DivisionID = AT1302.DivisionID
LEFT JOIN AT1015 I2 on I2.AnaID = AT1302.I01ID and I2.AnaTypeID =''I02'' and I2.DivisionID = AT1302.DivisionID
LEFT JOIN AT1015 I3 on I3.AnaID = AT1302.I01ID and I3.AnaTypeID =''I03'' and I3.DivisionID = AT1302.DivisionID
LEFT JOIN AT1015 I4 on I4.AnaID = AT1302.I01ID and I4.AnaTypeID =''I04'' and I4.DivisionID = AT1302.DivisionID
LEFT JOIN AT1015 I5 on I5.AnaID = AT1302.I01ID and I5.AnaTypeID =''I05'' and I5.DivisionID = AT1302.DivisionID
LEFT JOIN AT1202 on    AT1202.ObjectID = A.ObjectID and AT1202.DivisionID = A.DivisionID
LEFT JOIN AT1304 G on G.UnitID = AT1302.UnitID AND  G.DivisionID = AT1302.DivisionID
LEFT JOIN AT1011 A01 ON A01.DivisionID = B.DivisionID AND A01.AnaID = B.Ana01ID and A01.AnaTypeID = ''A01''
Where  (B.InventoryID between '''+@FromInventoryID+''' and '''+@ToInventoryID+''') and 
	A.KindVoucherID   in '+ @KindVoucherListIm +' and 
	B.VoucherID not in ( select ReVoucherID From AV2666 INNER JOIN AV2777 on AV2777.VoucherID = AV2666.VoucherID
				where KindVoucherID in '+ @KindVoucherListEx +'  and isnull(KindVoucherID,'''')<>'''' and (AV2666.TranMonth + 100*AV2666.TranYear  Between '+@FromMonthYearText+'  and '+@ToMonthYearText+' )) and
	( WareHouseID  between '''+@FromWareHouseID+''' and ''' + @ToWareHouseID + ''') and
	AT1302.IsSource = 1 and
	B.DivisionID ='''+@DivisionID+''' And
	(VoucherDate Between '''+@FromDateText+'''  and  '''+@ToDateText+''' )
---end q.huy them vao'
end
Else   --- Theo Ky
begin
Set @sSQLSelect ='
---lay phieu xuat kho cua ky nay tuong ung voi phieu nhap kho
Select 	A.VoucherDate AS DeVoucherDate, 
	A.VoucherNo AS DeVoucherNo,

	' +@WareHouseID1 +' AS WareHouseID,

	B.InventoryID, 
	AT1302.InventoryName,
	AT1302.UnitID,
	AT1302.I01ID,
	AT1302.I02ID,
	AT1302.I03ID,
	AT1302.I04ID,
	AT1302.I05ID,	
	I1.AnaName AS AnaName1,
	I2.AnaName AS AnaName2,
	I3.AnaName AS AnaName3,
	I4.AnaName AS AnaName4,
	I5.AnaName AS AnaName5,
	AT1302.VATPercent,
	AT1302.Notes01, AT1302.Notes02,AT1302.Notes03, AT1302.Specification,
	B.ActualQuantity AS DeQuantity,
	B.ConvertedAmount AS DeAmount,
	E.ActualQuantity AS ReQuantity,
	E.ConvertedAmount AS ReAmount,
	B.ReVoucherID,
	D.VoucherNo AS ReVoucherNo,
	D.VoucherDate AS ReVoucherDate, 
	D.ObjectID AS ReObjectID,
	F.ObjectName AS ReObjectName ,
	B.ReTransactionID,
	B.SourceNo AS ReSourceNo,		
	B.LimitDate,
	A.ObjectID,
	AT1202.ObjectName,
	B.DivisionID,
	A.RefNo01,  
	A.RefNo02,
	G.UnitName,
	B.Ana01ID,
	A01.AnaName as AnaName01


From  AV2777   B 
INNER JOIN AV2666   A on A.VoucherID = B.VoucherID and A.DivisionID = B.DivisionID
INNER JOIN AT1302 C on C.InventoryID = B.InventoryID and C.DivisionID = B.DivisionID
INNER JOIN  AV2666  D on D.VoucherID = B.ReVoucherID and D.DivisionID = B.DivisionID
INNER JOIN AT1302 on 	AT1302.InventoryID = B.InventoryID and AT1302.DivisionID = B.DivisionID
INNER JOIN AV2777 E on E.TransactionID = B.ReTransactionID and E.DivisionID = B.DivisionID
LEFT JOIN AT1015 I1 on I1.AnaID = AT1302.I01ID and I1.AnaTypeID =''I01'' and I1.DivisionID = AT1302.DivisionID
LEFT JOIN AT1015 I2 on I2.AnaID = AT1302.I01ID and I2.AnaTypeID =''I02'' and I2.DivisionID = AT1302.DivisionID		
LEFT JOIN AT1015 I3 on I3.AnaID = AT1302.I01ID and I3.AnaTypeID =''I03'' and I3.DivisionID = AT1302.DivisionID
LEFT JOIN AT1015 I4 on I4.AnaID = AT1302.I01ID and I4.AnaTypeID =''I04'' and I4.DivisionID = AT1302.DivisionID
LEFT JOIN AT1015 I5 on I5.AnaID = AT1302.I01ID and I5.AnaTypeID =''I05'' and I5.DivisionID = AT1302.DivisionID
LEFT JOIN AT1202 on    AT1202.ObjectID = A.ObjectID and AT1202.DivisionID = A.DivisionID
LEFT JOIN AT1202  F on    F.ObjectID = D.ObjectID and F.DivisionID = D.DivisionID
LEFT JOIN AT1304 G on G.UnitID = AT1302.UnitID AND  G.DivisionID = AT1302.DivisionID
LEFT JOIN AT1011 A01 ON A01.DivisionID = B.DivisionID AND A01.AnaID = B.Ana01ID and A01.AnaTypeID = ''A01''
Where  (B.InventoryID between '''+@FromInventoryID+''' and '''+@ToInventoryID+''') and 
	B.ReTransactionID in (Select ReTransactionID From AT0114 
					Where 
						(ReTranMonth + 100*ReTranYear < = '+@ToMonthYearText+') and
						( '+@WareHouseID1+' between '''+@FromWareHouseID+''' and ''' + @ToWareHouseID + ''') and
						DivisionID ='''+@DivisionID+''' ) and

	B.VoucherID IN (Select  VoucherID FROM AV2666 
				WHERE KINDVOUCHERID in '+ @KindVoucherListEx+' AND 
					(TranMonth + 100*TranYear Between    '+@FromMonthYearText+'  and '+@ToMonthYearText+' ) and
						( '+@WareHouseID1+' between '''+@FromWareHouseID+''' and ''' + @ToWareHouseID + ''') and
						DivisionID ='''+@DivisionID+''' ) and
					
	AT1302.IsSource = 1	and
	B.TranMonth + 100*B.TranYear  < = '+@ToMonthYearText+'

Union all'

Set @sSQLFrom ='
---Lay phieu chua xuat kho
Select 	null  AS DeVoucherdate,
	'''' AS DeVoucherNo, 	

	A.WareHouseID,
	B.InventoryID, 
	AT1302.InventoryName,
	AT1302.UnitID,
	AT1302.I01ID,
	AT1302.I02ID,
	AT1302.I03ID,
	AT1302.I04ID,
	AT1302.I05ID,	
	I1.AnaName AS AnaName1,
	I2.AnaName AS AnaName2,
	I3.AnaName AS AnaName3,
	I4.AnaName AS AnaName4,
	I5.AnaName AS AnaName5,
	AT1302.VATPercent,
	AT1302.Notes01, AT1302.Notes02,AT1302.Notes03, AT1302.Specification,
	0 AS DeQuantity,
	0 AS DeAmount,
	B.ReQuantity AS ReQuantity,
	E.ConvertedAmount  AS ReAmount,
	B.ReVoucherID,
	A.VoucherNo AS ReVoucherNo,
	A.VoucherDate AS ReVoucherDate, 
	A.ObjectID AS ReObjectID,
	AT1202.ObjectName AS ReObjectName,
	--B.ReTransactionID,
	B.ReTransactionID AS ReTransactionID ,
	B.ReSourceNo AS ReSourceNo,		
	B.LimitDate,
	null AS ObjectID,
	Null AS ObjectName,
	B.DivisionID,
	A.RefNo01,  
	A.RefNo02,
	G.UnitName,
	E.Ana01ID,
	A01.AnaName as AnaName01

From  AT0114 B
INNER JOIN AV2666  A on A.VoucherID = B.ReVoucherID and A.DivisionID = B.DivisionID
INNER JOIN  AV2777  E on E.TransactionID = B.ReTransactionID and E.DivisionID = B.DivisionID
INNER JOIN AT1302 C on C.InventoryID = B.InventoryID and C.DivisionID = B.DivisionID
INNER JOIN AT1302 on 	AT1302.InventoryID = B.InventoryID and AT1302.DivisionID = B.DivisionID
LEFT JOIN AT1015 I1 on I1.AnaID = AT1302.I01ID and I1.AnaTypeID =''I01'' and I1.DivisionID = AT1302.DivisionID
LEFT JOIN AT1015 I2 on I2.AnaID = AT1302.I01ID and I2.AnaTypeID =''I02'' and I2.DivisionID = AT1302.DivisionID
LEFT JOIN AT1015 I3 on I3.AnaID = AT1302.I01ID and I3.AnaTypeID =''I03'' and I3.DivisionID = AT1302.DivisionID
LEFT JOIN AT1015 I4 on I4.AnaID = AT1302.I01ID and I4.AnaTypeID =''I04'' and I4.DivisionID = AT1302.DivisionID
LEFT JOIN AT1015 I5 on I5.AnaID = AT1302.I01ID and I5.AnaTypeID =''I05'' and I5.DivisionID = AT1302.DivisionID
LEFT JOIN AT1202 on    AT1202.ObjectID = A.ObjectID and AT1202.DivisionID = A.DivisionID
LEFT JOIN AT1304 G on G.UnitID = AT1302.UnitID AND  G.DivisionID = AT1302.DivisionID
LEFT JOIN AT1011 A01 ON A01.DivisionID = E.DivisionID AND A01.AnaID = E.Ana01ID and A01.AnaTypeID = ''A01''
Where  (B.InventoryID between '''+@FromInventoryID+''' and '''+@ToInventoryID+''') and 
	B.DeQuantity =0 and	
	A.KindVoucherID   in '+ @KindVoucherListIm +' and 
						
	(B.ReTranMonth + 100*B.ReTranYear Between '+@FromMonthYearText+'  and '+@ToMonthYearText+' ) and
						(A.WareHouseID between '''+@FromWareHouseID+''' and ''' + @ToWareHouseID + ''') and
						A.DivisionID ='''+@DivisionID+'''and
	AT1302.IsSource = 1'

Set @sSQLWhere ='
---- Begin q.huy them vao
----Nhung phieu da xuat kho o ky truoc ma khong xuat kho o ky nay.
union all

Select 	null AS DeVoucherDate, 
	null AS DeVoucherNo,
	 WareHouseID,
	----'+@WareHouseID1+' AS WareHouseID,

	B.InventoryID, 
	AT1302.InventoryName,
	AT1302.UnitID,
	AT1302.I01ID,
	AT1302.I02ID,
	AT1302.I03ID,
	AT1302.I04ID,
	AT1302.I05ID,	
	I1.AnaName AS AnaName1,
	I2.AnaName AS AnaName2,
	I3.AnaName AS AnaName3,
	I4.AnaName AS AnaName4,
	I5.AnaName AS AnaName5,
	AT1302.VATPercent,
	AT1302.Notes01, AT1302.Notes02,AT1302.Notes03, AT1302.Specification,
	null AS DeQuantity,
	null  AS DeAmount,
	B.ActualQuantity  AS ReQuantity,
	B.ConvertedAmount AS ReAmount,

	B.ReVoucherID,
	
	A.VoucherNo  AS ReVoucherNo,
	A.VoucherDate AS ReVoucherDate, 
	A.ObjectID AS ReObjectID,

	
	AT1202.ObjectName AS ReObjectName ,

	B.TransactionID AS ReTransactionID,
	B.SourceNo AS ReSourceNo,		
	B.LimitDate,
	
	null AS ObjectID,
	null AS ObjectName,
	B.DivisionID,
	A.RefNo01,  
	A.RefNo02,
	G.UnitName,
	B.Ana01ID,
	A01.AnaName as AnaName01


From  AV2777   B 
INNER JOIN AV2666   A on A.VoucherID = B.VoucherID and A.DivisionID = B.DivisionID
INNER JOIN AT1302 C on C.InventoryID = B.InventoryID and C.DivisionID = B.DivisionID
INNER JOIN AT1302 on 	AT1302.InventoryID = B.InventoryID and AT1302.DivisionID = B.DivisionID
LEFT JOIN AT1015 I1 on I1.AnaID = AT1302.I01ID and I1.AnaTypeID =''I01'' and I1.DivisionID = AT1302.DivisionID
LEFT JOIN AT1015 I2 on I2.AnaID = AT1302.I01ID and I2.AnaTypeID =''I02'' and I2.DivisionID = AT1302.DivisionID
LEFT JOIN AT1015 I3 on I3.AnaID = AT1302.I01ID and I3.AnaTypeID =''I03'' and I3.DivisionID = AT1302.DivisionID
LEFT JOIN AT1015 I4 on I4.AnaID = AT1302.I01ID and I4.AnaTypeID =''I04'' and I4.DivisionID = AT1302.DivisionID
LEFT JOIN AT1015 I5 on I5.AnaID = AT1302.I01ID and I5.AnaTypeID =''I05'' and I5.DivisionID = AT1302.DivisionID
LEFT JOIN AT1202 on    AT1202.ObjectID = A.ObjectID and AT1202.DivisionID = A.DivisionID
LEFT JOIN AT1304 G on G.UnitID = AT1302.UnitID AND  G.DivisionID = AT1302.DivisionID
LEFT JOIN AT1011 A01 ON A01.DivisionID = B.DivisionID AND A01.AnaID = B.Ana01ID and A01.AnaTypeID = ''A01''
Where  (B.InventoryID between '''+@FromInventoryID+''' and '''+@ToInventoryID+''') and 
	A.KindVoucherID   in '+ @KindVoucherListIm +' and 
	B.VoucherID not in ( select ReVoucherID From AV2666 INNER JOIN AV2777 on AV2777.VoucherID = AV2666.VoucherID
				where KindVoucherID in  '+ @KindVoucherListEx +'  and isnull(KindVoucherID,'''')<>'''' and (AV2666.TranMonth + 100*AV2666.TranYear  Between '+@FromMonthYearText+'  and '+@ToMonthYearText+' )) and

	( WareHouseID  between '''+@FromWareHouseID+''' and ''' + @ToWareHouseID + ''') and

	AT1302.IsSource = 1 and
	B.DivisionID ='''+@DivisionID+'''  And
	B.TranMonth + 100*B.TranYear  Between '+@FromMonthYearText+'  and '+@ToMonthYearText+' 
---end q.huy them vao
'
end
--print @sSQL

IF NOT EXISTS (SELECT 1 FROM  SYSOBJECTS WHERE XTYPE ='V' AND NAME ='AV0244')
	EXEC(' CREATE VIEW AV0244  -----TAO BOI AP0214
		AS '+ @sSQLSelect + @sSQLFrom + @sSQLWhere)
ELSE
	EXEC(' ALTER VIEW AV0244  -----TAO BOI AP0214
		AS '+ @sSQLSelect + @sSQLFrom + @sSQLWhere)

Set @sSQLSelect ='Select AV0244.*, AT1303.WareHouseName From AV0244 INNER JOIN AT1303 on AT1303.WareHouseID = AV0244.WareHouseID and  AT1303.DivisionID ='''+@DivisionID+'''  '

EXEC (@sSQLSelect)

--IF NOT EXISTS (SELECT 1 FROM  SYSOBJECTS WHERE XTYPE ='V' AND NAME ='AV0214')
--	EXEC(' CREATE VIEW AV0214 AS '+ @sSQLSelect)
--ELSE
--	EXEC(' ALTER VIEW AV0214 AS '+ @sSQLSelect)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
