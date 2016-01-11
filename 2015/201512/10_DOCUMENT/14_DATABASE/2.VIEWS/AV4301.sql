IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV4301]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AV4301]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

------ Created by Nguyen Van Nhan.
----- Created Date 05/11/2003.
----- Purpose: View chet, loc du lieu phuc vu cong tac bao cao
---- Last Update 21/05/2004
---- Edited by Nguyen Quoc Huy, Date: 28/03/2007
---- Edit by: Dang Le Bao Quynh, Date: 31/05/2007
--- last edit Thuy Tuyen , date 07/05/2009
--- Edit by: Huynh Tan Phu, Date: 10/02/2012, Them column BDescription
--- Edit by: Thien Huynh, Date: 10/05/2012, Them 5 Khoan muc
--- Edit by Bao Anh	Date: 09/08/2012	Bo sung truong DueDays
---- Modified on 30/10/2012 by Lê Thị Thu Hiền : Bổ sung 1 số 
---- Modified on 14/01/2013 by Lê Thị Thu Hiền : Bổ sung When 'P4' then 'B4'	When 'P5' then 'B5'
--- Modified by To Oanh: Bo sung PaymentTermID (khach hang tatung ngay 02/08/2013)
---- Modified by Thanh Sơn on 14/10/2013: Bổ sung lấy thêm cột WOrderID và WTransactionID (theo bug 0021588 - KINGCOM)
---- Modified by Thu Hiền on 31/12/2013: Bổ sung lấy thêm cột O01ID - O05ID, O01Name - O05Name (khách hàng CAAN)
---- Modified by Mai Duyen on 31/12/2013: Bổ sung lấy thêm cột InventoryTypeName,I01Name (khách hàng VIMEC)
---- Modified by Bảo Anh on 11/06/2015: Sửa cách lấy trường Quarter

CREATE VIEW [dbo].[AV4301]
AS  
  
SELECT  T90.DivisionID, T90.VoucherID, T90.BatchID, TransactionID, ISNULL(TransactionTypeID,'') AS TransactionTypeID,   
  ISNULL(T90.VoucherTypeID,'') AS VoucherTypeID,  
  T90.DebitAccountID AS AccountID, ISNULL(T90.CreditAccountID, '') AS CorAccountID, 'D' AS D_C,   
  ConvertedAmount, OriginalAmount, OriginalAmountCN, CurrencyIDCN,   
  T90.CurrencyID, T90.ExchangeRate, T90.WOrderID, T90.WTransactionID,
  T90.ConvertedAmount AS SignAmount, T90.OriginalAmount AS SignOriginal,  
  T90.Quantity AS Quantity, T90.Quantity AS SignQuantity,   
  T90.TranMonth, T90.TranYear, T90.VoucherNo, T90.VoucherDate, Serial, InvoiceNo, InvoiceDate, t90.DueDate, VATTypeID,  
  ISNULL(TDescription, ISNULL(BDescription,VDescription)) AS Description, ISNULL(VDescription,'') AS VDescription, ISNULL(BDescription,'') AS BDescription,  
  T90.UnitPrice, T90.CommissionPercent, T90.DiscountRate,   
  T90.CreateUserID,  
  T90.ObjectID,  
  T90.InventoryID, T90.UnitID,  
  T90.PeriodID,  
  ISNULL(T90.Ana01ID,'') AS Ana01ID, ISNULL(T90.Ana02ID,'') AS Ana02ID, ISNULL(T90.Ana03ID,'') AS Ana03ID ,  ISNULL(T90.Ana04ID,'') AS Ana04ID ,  ISNULL(T90.Ana05ID,'') AS Ana05ID ,  
  ISNULL(T90.Ana06ID,'') AS Ana06ID, ISNULL(T90.Ana07ID,'') AS Ana07ID, ISNULL(T90.Ana08ID,'') AS Ana08ID ,  ISNULL(T90.Ana09ID,'') AS Ana09ID ,  ISNULL(T90.Ana10ID,'') AS Ana10ID ,  
  ISNULL(T01.AnaName,'') AS AnaName01 , ISNULL(T022.AnaName,'') AS AnaName02,  ISNULL(T033.AnaName,'') AS AnaName03, ISNULL(T04.AnaName,'') AS AnaName04,  ISNULL(T05.AnaName,'') AS AnaName05,  
  ISNULL(T06.AnaName,'') AS AnaName06 , ISNULL(T07.AnaName,'') AS AnaName07,  ISNULL(T08.AnaName,'') AS AnaName08, ISNULL(T09.AnaName,'') AS AnaName09,  ISNULL(T101.AnaName,'') AS AnaName10,  
  MAX(ISNULL(T022.Amount01,0)) AS Ana02Amount01, MAX(ISNULL(T022.Amount02,0))  AS Ana02Amount02, MAX(ISNULL(T022.Amount03,0))  AS Ana02Amount03,   
  MAX(ISNULL(T022.Note01,'')) AS Ana02Note01,MAX(ISNULL(T022.Note02,''))  AS Ana02Note02, MAX(ISNULL(T022.Note03,''))  AS Ana02Note03,  
  MAX(ISNULL(T022.RefDate,'')) AS Ana02RefDate,  
  ISNULL(O01ID,'') AS O01ID, ISNULL(O02ID,'') AS O02ID, ISNULL(O03ID,'') AS O03ID, ISNULL(O04ID,'') AS O04ID, ISNULL(O05ID,'') AS O05ID,  
  O01.AnaName AS O01Name,
  O02.AnaName AS O02Name,
  O03.AnaName AS O03Name,
  O04.AnaName AS O04Name,
  O05.AnaName AS O05Name,
  ISNULL(I01ID,'') AS I01ID, ISNULL(I02ID,'') AS I02ID, ISNULL(I03ID,'') AS I03ID, ISNULL(I04ID,'') AS I04ID, ISNULL(I05ID,'') AS I05ID,   
  ISNULL(T02.S1,'') AS CO1ID,ISNULL(T02.S2,'') AS CO2ID,ISNULL(T02.S3,'') AS CO3ID,  
  ISNULL(T03.S1,'') AS CI1ID,ISNULL(T03.S2,'') AS CI2ID, ISNULL(T03.S3,'') AS CI3ID,    
  'AA'  AS BudgetID,   
  (CASE WHEN  T90.TranMonth <10 then '0'+rtrim(ltrim(str(T90.TranMonth)))+'/'+ltrim(Rtrim(str(T90.TranYear)))   
  Else rtrim(ltrim(str(T90.TranMonth)))+'/'+ltrim(Rtrim(str(T90.TranYear))) End) AS MonthYear,

  --('0'+ ltrim(rtrim(CASE WHEN T90.TranMonth %3 = 0 then T90.TranMonth/3  Else T90.TranMonth/3+1  End))+'/'+ltrim(Rtrim(str(T90.TranYear)))  
  --)  AS Quarter ,
  (select Quarter from AV9999 Where DivisionID = T90.DivisionID and TranMonth = T90.TranMonth and TranYear = T90.TranYear) as Quarter,
  
  str(T90.TranYear) AS Year,  
  T90.VATGroupID,  
  T10.VATRate,  
  T90.VATOriginalAmount,   
  T90.VATConvertedAmount,  
  T90.OrderID,  
  OT2001.OrderDate,  
  AT1208.DueDays,
  T90.PaymentTermID,
  Isnull(I01.AnaName,'') as I01Name,
  Isnull(AT1301.InventoryTypeName,'') as InventoryTypeName
  
FROM AT9000  T90    
LEFT JOIN AT1202 T02 ON T02.ObjectID = T90.ObjectID AND T02.DivisionID = T90.DivisionID  
LEFT JOIN AT1302 T03 ON T03.InventoryID = T90.InventoryID And T03.DivisionID = T90.DivisionID  
LEFT JOIN AT1011 T01 ON T01.AnaID = T90.Ana01ID AND T01.AnaTypeID = 'A01'  AND T01.DivisionID = T90.DivisionID  
LEFT JOIN AT1011 T022 ON T022.AnaID = T90.Ana02ID AND T022.AnaTypeID = 'A02'  AND T022.DivisionID = T90.DivisionID  
LEFT JOIN AT1011 T033 ON T033.AnaID = T90.Ana03ID AND T033.AnaTypeID = 'A03'  And T033.DivisionID = T90.DivisionID   
LEFT JOIN AT1011 T04 ON T04.AnaID = T90.Ana04ID AND T04.AnaTypeID = 'A04'  AND T04.DivisionID = T90.DivisionID  
LEFT JOIN AT1011 T05 ON T05.AnaID = T90.Ana05ID AND T05.AnaTypeID = 'A05'  AND T05.DivisionID = T90.DivisionID  
LEFT JOIN AT1011 T06 ON T06.AnaID = T90.Ana06ID AND T06.AnaTypeID = 'A06'  AND T06.DivisionID = T90.DivisionID  
LEFT JOIN AT1011 T07 ON T07.AnaID = T90.Ana07ID AND T07.AnaTypeID = 'A07'  AND T07.DivisionID = T90.DivisionID  
LEFT JOIN AT1011 T08 ON T08.AnaID = T90.Ana08ID AND T08.AnaTypeID = 'A08'  AND T08.DivisionID = T90.DivisionID   
LEFT JOIN AT1011 T09 ON T09.AnaID = T90.Ana09ID AND T09.AnaTypeID = 'A09'  AND T09.DivisionID = T90.DivisionID  
LEFT JOIN AT1011 T101 ON T101.AnaID = T90.Ana10ID AND T101.AnaTypeID = 'A10'  AND T101.DivisionID = T90.DivisionID 

LEFT JOIN AT1015 O01 ON O01.AnaID = T02.O01ID AND O01.AnaTypeID = 'O01'  AND O01.DivisionID = T02.DivisionID  
LEFT JOIN AT1015 O02 ON O02.AnaID = T02.O02ID AND O02.AnaTypeID = 'O02'  AND O02.DivisionID = T02.DivisionID  
LEFT JOIN AT1015 O03 ON O03.AnaID = T02.O03ID AND O03.AnaTypeID = 'O03'  And O03.DivisionID = T02.DivisionID   
LEFT JOIN AT1015 O04 ON O04.AnaID = T02.O04ID AND O04.AnaTypeID = 'O04'  AND O04.DivisionID = T02.DivisionID  
LEFT JOIN AT1015 O05 ON O05.AnaID = T02.O05ID AND O05.AnaTypeID = 'O05'  AND O05.DivisionID = T02.DivisionID  
 
LEFT JOIN AT1010 T10 ON T10.VATGroupID = T90.VATGroupID AND T10.DivisionID = T90.DivisionID  
LEFT JOIN OT2001 ON OT2001.SOrderID = T90.OrderID AND OT2001.DivisionID = T90.DivisionID  
LEFT JOIN AT1208 ON AT1208.PaymentTermID = T90.PaymentTermID AND AT1208.DivisionID = T90.DivisionID 
LEFT JOIN AT1015 I01 ON I01.AnaID = T03.I01ID AND I01.AnaTypeID = 'I01'  AND I01.DivisionID = T03.DivisionID  
LEFT JOIN AT1301 AT1301  ON AT1301.InventoryTypeID = T03.InventoryTypeID And T03.DivisionID = AT1301.DivisionID  
 
WHERE DebitAccountID IS NOT NULL AND DebitAccountID <> ''  
GROUP BY T90.DivisionID, T90.VoucherID, T90.BatchID, TransactionID,   
   ISNULL(TransactionTypeID,''),   
  ISNULL(T90.VoucherTypeID,'') ,  
  T90.DebitAccountID , ISNULL(T90.CreditAccountID, '') ,  
  ConvertedAmount, OriginalAmount, OriginalAmountCN, CurrencyIDCN,   
  T90.CurrencyID, T90.ExchangeRate, T90.WOrderID, T90.WTransactionID,  
  ConvertedAmount , OriginalAmount ,  
  T90.Quantity , T90.Quantity ,   
  T90.TranMonth, T90.TranYear, T90.VoucherNo, T90.VoucherDate, Serial, InvoiceNo, InvoiceDate, t90.DueDate, VATTypeID,  
  ISNULL(TDescription, ISNULL(BDescription,VDescription)) , ISNULL(VDescription,''), ISNULL(BDescription,'') ,  
  T90.UnitPrice, T90.CommissionPercent, T90.DiscountRate,   
  T90.CreateUserID,  
  T90.ObjectID,  
  T90.InventoryID, T90.UnitID,  
  T90.PeriodID,  
  ISNULL(T90.Ana01ID,'') , ISNULL(T90.Ana02ID,'') , ISNULL(T90.Ana03ID,'') ,  ISNULL(T90.Ana04ID,'') ,  ISNULL(T90.Ana05ID,'') ,  
  ISNULL(T90.Ana06ID,'') , ISNULL(T90.Ana07ID,'') , ISNULL(T90.Ana08ID,'') ,  ISNULL(T90.Ana09ID,'') ,  ISNULL(T90.Ana10ID,'') ,  
  ISNULL(T01.AnaName,'') , ISNULL(T022.AnaName,'') ,  ISNULL(T033.AnaName,'') , ISNULL(T04.AnaName,'') ,  ISNULL(T05.AnaName,''),  
  ISNULL(T06.AnaName,'') , ISNULL(T07.AnaName,'') ,  ISNULL(T08.AnaName,'') , ISNULL(T09.AnaName,'') ,  ISNULL(T101.AnaName,'') ,  
  ISNULL(O01ID,''), ISNULL(O02ID,''), ISNULL(O03ID,''), ISNULL(O04ID,''), ISNULL(O05ID,''), 
  O01.AnaName ,  O02.AnaName ,  O03.AnaName ,  O04.AnaName ,  O05.AnaName ,  
  ISNULL(I01ID,'') , ISNULL(I02ID,''), ISNULL(I03ID,''), ISNULL(I04ID,''), ISNULL(I05ID,''),   
  ISNULL(T02.S1,''),ISNULL(T02.S2,''),ISNULL(T02.S3,''),  
  ISNULL(T03.S1,'') ,ISNULL(T03.S2,''), ISNULL(T03.S3,''),    
  T90.TranMonth, T90.TranYear,  
  T90.VATGroupID,  
  T10.VATRate,  
  T90.VATOriginalAmount,   
  T90.VATConvertedAmount,  
  T90.OrderID,  
  OT2001.OrderDate,  
  AT1208.DueDays,
  T90.PaymentTermID  ,
  Isnull(I01.AnaName,''),
  Isnull(AT1301.InventoryTypeName,'')
  
UNION ALL  
  
  
SELECT  T90.DivisionID, T90.VoucherID, BatchID, TransactionID, ISNULL(TransactionTypeID,'') AS TransactionTypeID,   
  ISNULL(T90.VoucherTypeID,'') AS VoucherTypeID,  
  CreditAccountID AS AccountID, ISNULL(DebitAccountID,'') AS CorAccountID, 'C' AS D_C,    
  ConvertedAmount, OriginalAmount, OriginalAmountCN, CurrencyIDCN,   
  T90.CurrencyID, T90.ExchangeRate,T90.WOrderID, T90.WTransactionID, ConvertedAmount*-1 AS SignAmount, OriginalAmount*-1 AS SignOriginal,  
  T90.Quantity AS Quantity, -T90.Quantity AS SignQuantity,   
  T90.TranMonth, T90.TranYear, T90.VoucherNo, T90.VoucherDate, Serial, InvoiceNo, InvoiceDate, T90.DueDate, VATTypeID,  
  ISNULL(TDescription, ISNULL(BDescription,VDescription)) AS Description, ISNULL(VDescription,'') AS VDescription, ISNULL(BDescription,'') AS BDescription,  
  T90.UnitPrice, T90.CommissionPercent, T90.DiscountRate,  
  T90.CreateUserID,  
  CASE WHEN T90.TransactionTypeID ='T99' then CreditObjectID else T90.ObjectID end AS ObjectID,  
  T90.InventoryID,T90.UnitID,  
  T90.PeriodID,  
  ISNULL(T90.Ana01ID,'') AS Ana01ID,     ISNULL(T90.Ana02ID,'') AS Ana02ID, ISNULL(T90.Ana03ID,'') AS Ana03ID, ISNULL(T90.Ana04ID,'') AS Ana04ID ,  ISNULL(T90.Ana05ID,'') AS Ana05ID ,  
  ISNULL(T90.Ana06ID,'') AS Ana06ID, ISNULL(T90.Ana07ID,'') AS Ana07ID, ISNULL(T90.Ana08ID,'') AS Ana08ID ,  ISNULL(T90.Ana09ID,'') AS Ana09ID ,  ISNULL(T90.Ana10ID,'') AS Ana10ID ,  
  ISNULL(T01.AnaName,'') AS AnaName01 , ISNULL(T022.AnaName,'') AS AnaName02,  ISNULL(T033.AnaName,'') AS AnaName03, ISNULL(T04.AnaName,'') AS AnaName04,  ISNULL(T05.AnaName,'') AS AnaName05,  
  ISNULL(T06.AnaName,'') AS AnaName06 , ISNULL(T07.AnaName,'') AS AnaName07,  ISNULL(T08.AnaName,'') AS AnaName08, ISNULL(T09.AnaName,'') AS AnaName09,  ISNULL(T101.AnaName,'') AS AnaName10,  
  MAX(ISNULL(T022.Amount01,0)) AS Ana02Amount01, MAX(ISNULL(T022.Amount02,0))  AS Ana02Amount02, MAX(ISNULL(T022.Amount03,0))  AS Ana02Amount03,   
  MAX(ISNULL(T022.Note01,'')) AS Ana02Note01,MAX(ISNULL(T022.Note02,''))  AS Ana02Note02, MAX(ISNULL(T022.Note03,''))  AS Ana02Note03,  
  MAX(ISNULL(T022.RefDate,'')) AS Ana02RefDate,  
  ISNULL(O01ID,'') AS O01ID, ISNULL(O02ID,'') AS O02ID, ISNULL(O03ID,'') AS O03ID, ISNULL(O04ID,'') AS O04ID, ISNULL(O05ID,'') AS O05ID, 
  O01.AnaName AS O01Name,
  O02.AnaName AS O02Name,
  O03.AnaName AS O03Name,
  O04.AnaName AS O04Name,
  O05.AnaName AS O05Name,  
  ISNULL(I01ID,'') AS I01ID, ISNULL(I02ID,'') AS I02ID, ISNULL(I03ID,'') AS I03ID, ISNULL(I04ID,'') AS I04ID, ISNULL(I05ID,'') AS I05ID,   
  ISNULL(T02.S1,'') AS CO1ID,ISNULL(T02.S2,'') AS CO2ID,ISNULL(T02.S3,'') AS CO3ID,  
  ISNULL(T03.S1,'') AS CI1ID,ISNULL(T03.S2,'') AS CI2ID, ISNULL(T03.S3,'') AS CI3ID,  
  'AA'  AS BudgetID,   
  (CASE WHEN  T90.TranMonth <10 then '0'+rtrim(ltrim(str(T90.TranMonth)))+'/'+ltrim(Rtrim(str(T90.TranYear)))   
  Else rtrim(ltrim(str(T90.TranMonth)))+'/'+ltrim(Rtrim(str(T90.TranYear))) End) AS MonthYear,  
  
  --('0'+ ltrim(rtrim(CASE WHEN T90.TranMonth %3 = 0 then T90.TranMonth/3  Else T90.TranMonth/3+1  End))+'/'+ltrim(Rtrim(str(T90.TranYear)))  
  --)  AS Quarter ,
  (select Quarter from AV9999 Where DivisionID = T90.DivisionID and TranMonth = T90.TranMonth and TranYear = T90.TranYear) as Quarter,
   
  str(T90.TranYear) AS Year,  
  T90.VATGroupID,  
  T10.VATRate,  
  T90.VATOriginalAmount,   
  T90.VATConvertedAmount,  
  T90.OrderID,  
  OT2001.OrderDate,  
  AT1208.DueDays,
  T90.PaymentTermID  ,
 Isnull(I01.AnaName,'') as I01Name,
  Isnull(AT1301.InventoryTypeName,'') as InventoryTypeName
  
FROM AT9000  T90    
LEFT JOIN AT1202 T02 ON T02.ObjectID = (CASE WHEN T90.TransactionTypeID ='T99'  then T90.CreditObjectID Else T90.ObjectID End) AND T90.DivisionID = T02.DivisionID  
LEFT JOIN AT1302 T03 ON T03.InventoryID = T90.InventoryID AND T03.DivisionID = T90.DivisionID  
LEFT JOIN AT1011 T01 ON T01.AnaID = T90.Ana01ID AND T01.AnaTypeID = 'A01'  AND T01.DivisionID = T90.DivisionID  
LEFT JOIN AT1011 T022 ON T022.AnaID = T90.Ana02ID AND T022.AnaTypeID = 'A02' And T022.DivisionID = T90.DivisionID    
LEFT JOIN AT1011 T033 ON T033.AnaID = T90.Ana03ID AND T033.AnaTypeID = 'A03' AND T033.DivisionID = T90.DivisionID    
LEFT JOIN AT1011 T04 ON T04.AnaID = T90.Ana04ID AND T04.AnaTypeID = 'A04'  AND  T04.DivisionID = T90.DivisionID  
LEFT JOIN AT1011 T05 ON T05.AnaID = T90.Ana05ID AND T05.AnaTypeID = 'A05' And T05.DivisionID = T90.DivisionID  
LEFT JOIN AT1011 T06 ON T06.AnaID = T90.Ana06ID AND T06.AnaTypeID = 'A06'  AND T06.DivisionID = T90.DivisionID  
LEFT JOIN AT1011 T07 ON T07.AnaID = T90.Ana07ID AND T07.AnaTypeID = 'A07'  AND T07.DivisionID = T90.DivisionID  
LEFT JOIN AT1011 T08 ON T08.AnaID = T90.Ana08ID AND T08.AnaTypeID = 'A08'  AND T08.DivisionID = T90.DivisionID   
LEFT JOIN AT1011 T09 ON T09.AnaID = T90.Ana09ID AND T09.AnaTypeID = 'A09'  AND T09.DivisionID = T90.DivisionID  
LEFT JOIN AT1011 T101 ON T101.AnaID = T90.Ana10ID AND T101.AnaTypeID = 'A10'  AND T101.DivisionID = T90.DivisionID  

LEFT JOIN AT1015 O01 ON O01.AnaID = T02.O01ID AND O01.AnaTypeID = 'O01'  AND O01.DivisionID = T02.DivisionID  
LEFT JOIN AT1015 O02 ON O02.AnaID = T02.O02ID AND O02.AnaTypeID = 'O02'  AND O02.DivisionID = T02.DivisionID  
LEFT JOIN AT1015 O03 ON O03.AnaID = T02.O03ID AND O03.AnaTypeID = 'O03'  And O03.DivisionID = T02.DivisionID   
LEFT JOIN AT1015 O04 ON O04.AnaID = T02.O04ID AND O04.AnaTypeID = 'O04'  AND O04.DivisionID = T02.DivisionID  
LEFT JOIN AT1015 O05 ON O05.AnaID = T02.O05ID AND O05.AnaTypeID = 'O05'  AND O05.DivisionID = T02.DivisionID  

LEFT JOIN AT1010 T10 ON T10.VATGroupID = T90.VATGroupID AND T10.DivisionID = T90.DivisionID  
LEFT JOIN OT2001 ON OT2001.SOrderID = T90.OrderID AND OT2001.DivisionID = T90.DivisionID  
LEFT JOIN AT1208 ON AT1208.PaymentTermID = T90.PaymentTermID AND AT1208.DivisionID = T90.DivisionID  

LEFT JOIN AT1015 I01 ON I01.AnaID = T03.I01ID AND I01.AnaTypeID = 'I01'  AND I01.DivisionID = T03.DivisionID  
LEFT JOIN AT1301 AT1301  ON AT1301.InventoryTypeID = T03.InventoryTypeID And T03.DivisionID = AT1301.DivisionID  

WHERE CreditAccountID IS NOT NULL AND CreditAccountID <> ''  
GROUP BY T90.DivisionID, T90.VoucherID, T90.BatchID, TransactionID,   
   ISNULL(TransactionTypeID,''),   
  ISNULL(T90.VoucherTypeID,'') ,  
  T90.CreditAccountID , ISNULL(T90.DebitAccountID, '') ,  
  ConvertedAmount, OriginalAmount, OriginalAmountCN, CurrencyIDCN,   
  T90.CurrencyID, T90.ExchangeRate, T90.WOrderID, T90.WTransactionID,    
  ConvertedAmount , OriginalAmount ,  
  T90.Quantity , T90.Quantity ,   
  T90.TranMonth, T90.TranYear, T90.VoucherNo, T90.VoucherDate, Serial, InvoiceNo, InvoiceDate, t90.DueDate, VATTypeID,  
  ISNULL(TDescription, ISNULL(BDescription,VDescription)) , ISNULL(VDescription,''), ISNULL(BDescription,'') ,  
  T90.UnitPrice, T90.CommissionPercent, T90.DiscountRate,   
  T90.CreateUserID,  
  CASE WHEN T90.TransactionTypeID ='T99' then CreditObjectID else T90.ObjectID end,  
  T90.InventoryID, T90.UnitID,  
  T90.PeriodID,  
  ISNULL(T90.Ana01ID,'') , ISNULL(T90.Ana02ID,'') , ISNULL(T90.Ana03ID,'') ,  ISNULL(T90.Ana04ID,'') ,  ISNULL(T90.Ana05ID,'') ,  
  ISNULL(T90.Ana06ID,'') , ISNULL(T90.Ana07ID,'') , ISNULL(T90.Ana08ID,'') ,  ISNULL(T90.Ana09ID,'') ,  ISNULL(T90.Ana10ID,'') ,  
  ISNULL(T01.AnaName,'') , ISNULL(T022.AnaName,'') ,  ISNULL(T033.AnaName,'') , ISNULL(T04.AnaName,'') ,  ISNULL(T05.AnaName,''),  
  ISNULL(T06.AnaName,'') , ISNULL(T07.AnaName,'') ,  ISNULL(T08.AnaName,'') , ISNULL(T09.AnaName,'') ,  ISNULL(T101.AnaName,'') ,  
  ISNULL(O01ID,''), ISNULL(O02ID,''), ISNULL(O03ID,''), ISNULL(O04ID,''), ISNULL(O05ID,''),   
  O01.AnaName ,  O02.AnaName ,  O03.AnaName ,  O04.AnaName ,  O05.AnaName ,  
  ISNULL(I01ID,'') , ISNULL(I02ID,''), ISNULL(I03ID,''), ISNULL(I04ID,''), ISNULL(I05ID,''),   
  ISNULL(T02.S1,''),ISNULL(T02.S2,''),ISNULL(T02.S3,''),  
  ISNULL(T03.S1,'') ,ISNULL(T03.S2,''), ISNULL(T03.S3,''),    
  T90.TranMonth, T90.TranYear,  
  T90.VATGroupID,  
  T10.VATRate,  
  T90.VATOriginalAmount,   
  T90.VATConvertedAmount,  
  T90.OrderID,  
  OT2001.OrderDate,  
  AT1208.DueDays,
  T90.PaymentTermID  ,
  Isnull(I01.AnaName,''),
  Isnull(AT1301.InventoryTypeName,'')
  
--------------------------- Ngan sach thang   
Union All  
SELECT  T90.DivisionID, VoucherID, VoucherID AS BatchID, TransactionID,   
  ISNULL(TransactionTypeID,'') AS TransactionTypeID,   
  ISNULL(VoucherTypeID,'') AS VoucherTypeID,  
  CreditAccountID AS AccountID,  
  ISNULL(DebitAccountID,'') AS CorAccountID, 'C' AS D_C,    
  ConvertedAmount, OriginalAmount, OriginalAmount AS OriginalAmountCN,   
  T90.CurrencyID AS CurrencyIDCN,   
  T90.CurrencyID, ExchangeRate, NULL AS WOrderID, NULL AS WTransactionID, ConvertedAmount*-1 AS SignAmount,  
   OriginalAmount*-1 AS SignOriginal,  
  T90.Quantity AS Quantity, -T90.Quantity AS SignQuantity,   
  TranMonth, TranYear, VoucherNo, VoucherDate, '' AS Serial, '' AS InvoiceNo, null InvoiceDate, null DueDate, '' AS VATTypeID,  
  ISNULL(TDescription,VDescription) AS Description, ISNULL(VDescription,'') AS VDescription, '' AS BDescription,  
  T90.UnitPrice, null AS CommissionPercent, null AS DiscountRate,  
  T90.CreateUserID,  
   T90.ObjectID ,  
  T90.InventoryID,T90.UnitID,  
  null AS PeriodID,  
  ISNULL(t90.Ana01ID,'') AS Ana01ID,   ISNULL(Ana02ID,'') AS Ana02ID, ISNULL(Ana03ID,'') AS Ana03ID, ISNULL(Ana04ID,'') AS Ana04ID ,  ISNULL(Ana05ID,'') AS Ana05ID ,   
  ISNULL(T90.Ana06ID,'') AS Ana06ID, ISNULL(T90.Ana07ID,'') AS Ana07ID, ISNULL(T90.Ana08ID,'') AS Ana08ID ,  ISNULL(T90.Ana09ID,'') AS Ana09ID ,  ISNULL(T90.Ana10ID,'') AS Ana10ID ,  
  ISNULL(T01.AnaName,'') AS AnaName01 , ISNULL(T022.AnaName,'') AS AnaName02,  ISNULL(T033.AnaName,'') AS AnaName03, ISNULL(T04.AnaName,'') AS AnaName04,  ISNULL(T05.AnaName,'') AS AnaName05,  
  ISNULL(T06.AnaName,'') AS AnaName06 , ISNULL(T07.AnaName,'') AS AnaName07,  ISNULL(T08.AnaName,'') AS AnaName08, ISNULL(T09.AnaName,'') AS AnaName09,  ISNULL(T101.AnaName,'') AS AnaName10,  
  MAX(ISNULL(T022.Amount01,0)) AS Ana02Amount01, MAX(ISNULL(T022.Amount02,0))  AS Ana02Amount02, MAX(ISNULL(T022.Amount03,0))  AS Ana02Amount03,   
  MAX(ISNULL(T022.Note01,'')) AS Ana02Note01,MAX(ISNULL(T022.Note02,''))  AS Ana02Note02, MAX(ISNULL(T022.Note03,''))  AS Ana02Note03,  
  MAX(ISNULL(T022.RefDate,'')) AS Ana02RefDate,  
  ISNULL(O01ID,'') AS O01ID, ISNULL(O02ID,'') AS O02ID, ISNULL(O03ID,'') AS O03ID, ISNULL(O04ID,'') AS O04ID, ISNULL(O05ID,'') AS O05ID,   
  O01.AnaName AS O01Name,
  O02.AnaName AS O02Name,
  O03.AnaName AS O03Name,
  O04.AnaName AS O04Name,
  O05.AnaName AS O05Name,
  ISNULL(I01ID,'') AS I01ID, ISNULL(I02ID,'') AS I02ID, ISNULL(I03ID,'') AS I03ID, ISNULL(I04ID,'') AS I04ID, ISNULL(I05ID,'') AS I05ID,   
  ISNULL(T02.S1,'') AS CO1ID,ISNULL(T02.S2,'') AS CO2ID,ISNULL(T02.S3,'') AS CO3ID,  
  ISNULL(T03.S1,'') AS CI1ID,ISNULL(T03.S2,'') AS CI2ID, ISNULL(T03.S3,'') AS CI3ID,  
  (Case BudgetType when 'M' then 'B1'  
       When 'Q' then 'B2'  
       When 'Y' then 'B3'  
       When 'P4' then 'B4'  
       When 'P5' then 'B5'  
  Else BudgetType End ) AS BudgetID,     
  
  (CASE WHEN  T90.TranMonth <10 then '0'+rtrim(ltrim(str(T90.TranMonth)))+'/'+ltrim(Rtrim(str(T90.TranYear)))   
  Else rtrim(ltrim(str(T90.TranMonth)))+'/'+ltrim(Rtrim(str(T90.TranYear))) End) AS MonthYear,  
  
  --('0'+ ltrim(rtrim(CASE WHEN T90.TranMonth %3 = 0 then T90.TranMonth/3  Else T90.TranMonth/3+1  End))+'/'+ltrim(Rtrim(str(T90.TranYear)))  
  --)  AS Quarter ,  
  (select Quarter from AV9999 Where DivisionID = T90.DivisionID and TranMonth = T90.TranMonth and TranYear = T90.TranYear) as Quarter,
  
  str(T90.TranYear) AS Year,
  null AS VATGroupID,  
  null AS VATRate,  
  0 AS VATOriginalAmount,   
  0 AS VATConvertedAmount,  
  null OrderID,  
  null AS  orderdate,  
  NULL AS DueDays,
  Null as PaymentTermID,
  Isnull(I01.AnaName,'') as I01Name,
  Isnull(AT1301.InventoryTypeName,'') as InventoryTypeName
  
FROM AT9090  T90    
LEFT JOIN AT1202 T02 ON T02.ObjectID = T90.ObjectID AND T02.DivisionID = T90.DivisionID  
LEFT JOIN AT1302 T03 ON T03.InventoryID = T90.InventoryID AND T03.DivisionID = T90.DivisionID  
LEFT JOIN AT1011 T01 ON T01.AnaID = T90.Ana01ID AND T01.AnaTypeID = 'A01'   And T01.DivisionID = T90.DivisionID  
LEFT JOIN AT1011 T022 ON T022.AnaID = T90.Ana02ID AND T022.AnaTypeID = 'A02' AND T022.DivisionID = T90.DivisionID     
LEFT JOIN AT1011 T033 ON T033.AnaID = T90.Ana03ID AND T033.AnaTypeID = 'A03' And T033.DivisionID = T90.DivisionID   
LEFT JOIN AT1011 T04 ON T04.AnaID = T90.Ana04ID AND T04.AnaTypeID = 'A04'  AND T04.DivisionID = T90.DivisionID  
LEFT JOIN AT1011 T05 ON T05.AnaID = T90.Ana05ID AND T05.AnaTypeID = 'A05' And T05.DivisionID = T90.DivisionID  
LEFT JOIN AT1011 T06 ON T06.AnaID = T90.Ana06ID AND T06.AnaTypeID = 'A06'  AND T06.DivisionID = T90.DivisionID  
LEFT JOIN AT1011 T07 ON T07.AnaID = T90.Ana07ID AND T07.AnaTypeID = 'A07'  AND T07.DivisionID = T90.DivisionID  
LEFT JOIN AT1011 T08 ON T08.AnaID = T90.Ana08ID AND T08.AnaTypeID = 'A08'  AND T08.DivisionID = T90.DivisionID   
LEFT JOIN AT1011 T09 ON T09.AnaID = T90.Ana09ID AND T09.AnaTypeID = 'A09'  AND T09.DivisionID = T90.DivisionID  
LEFT JOIN AT1011 T101 ON T101.AnaID = T90.Ana10ID AND T101.AnaTypeID = 'A10'  AND T101.DivisionID = T90.DivisionID  

LEFT JOIN AT1015 O01 ON O01.AnaID = T02.O01ID AND O01.AnaTypeID = 'O01'  AND O01.DivisionID = T02.DivisionID  
LEFT JOIN AT1015 O02 ON O02.AnaID = T02.O02ID AND O02.AnaTypeID = 'O02'  AND O02.DivisionID = T02.DivisionID  
LEFT JOIN AT1015 O03 ON O03.AnaID = T02.O03ID AND O03.AnaTypeID = 'O03'  And O03.DivisionID = T02.DivisionID   
LEFT JOIN AT1015 O04 ON O04.AnaID = T02.O04ID AND O04.AnaTypeID = 'O04'  AND O04.DivisionID = T02.DivisionID  
LEFT JOIN AT1015 O05 ON O05.AnaID = T02.O05ID AND O05.AnaTypeID = 'O05'  AND O05.DivisionID = T02.DivisionID  
LEFT JOIN AT1015 I01 ON I01.AnaID = T03.I01ID AND I01.AnaTypeID = 'I01'  AND I01.DivisionID = T03.DivisionID  
LEFT JOIN AT1301 AT1301  ON AT1301.InventoryTypeID = T03.InventoryTypeID And T03.DivisionID = AT1301.DivisionID


WHERE ISNULL(CreditAccountID,'') <> ''--- AND BudgetType ='M'  
GROUP BY T90.DivisionID, T90.VoucherID,  TransactionID,   
   ISNULL(TransactionTypeID,''),   
  ISNULL(T90.VoucherTypeID,'') ,  
  T90.CreditAccountID , ISNULL(T90.DebitAccountID, '') ,  
  ConvertedAmount, OriginalAmount,   
  T90.CurrencyID, T90.ExchangeRate,   
  ConvertedAmount , OriginalAmount ,  
  T90.Quantity , T90.Quantity ,   
  T90.TranMonth, T90.TranYear, T90.VoucherNo, T90.VoucherDate,  t90.DueDate,   
  ISNULL(TDescription,VDescription) , ISNULL(VDescription,''),   
  T90.UnitPrice,   
  T90.CreateUserID,  
  T90.ObjectID,  
  T90.InventoryID, T90.UnitID,  
  BudgetType,  
  ISNULL(T90.Ana01ID,'') , ISNULL(T90.Ana02ID,'') , ISNULL(T90.Ana03ID,'') ,  ISNULL(T90.Ana04ID,'') ,  ISNULL(T90.Ana05ID,'') ,  
  ISNULL(T90.Ana06ID,'') , ISNULL(T90.Ana07ID,'') , ISNULL(T90.Ana08ID,'') ,  ISNULL(T90.Ana09ID,'') ,  ISNULL(T90.Ana10ID,'') ,  
  ISNULL(T01.AnaName,'') , ISNULL(T022.AnaName,'') ,  ISNULL(T033.AnaName,'') , ISNULL(T04.AnaName,'') ,  ISNULL(T05.AnaName,''),  
  ISNULL(T06.AnaName,'') , ISNULL(T07.AnaName,'') ,  ISNULL(T08.AnaName,'') , ISNULL(T09.AnaName,'') ,  ISNULL(T101.AnaName,'') ,  
  ISNULL(O01ID,''), ISNULL(O02ID,''), ISNULL(O03ID,''), ISNULL(O04ID,''), ISNULL(O05ID,''),  
  O01.AnaName ,  O02.AnaName ,  O03.AnaName ,  O04.AnaName ,  O05.AnaName ,   
  ISNULL(I01ID,'') , ISNULL(I02ID,''), ISNULL(I03ID,''), ISNULL(I04ID,''), ISNULL(I05ID,''),   
  ISNULL(T02.S1,''),ISNULL(T02.S2,''),ISNULL(T02.S3,''),  
  ISNULL(T03.S1,'') ,ISNULL(T03.S2,''), ISNULL(T03.S3,''),    
  T90.TranMonth, T90.TranYear  ,
  Isnull(I01.AnaName,'') ,
  Isnull(AT1301.InventoryTypeName,'')
  
    
Union all   SELECT  T90.DivisionID, VoucherID, VoucherID AS BatchID, TransactionID,   
  ISNULL(TransactionTypeID,'') AS TransactionTypeID,   
  ISNULL(VoucherTypeID,'') AS VoucherTypeID,  
  DebitAccountID AS AccountID,  
  ISNULL(CreditAccountID,'') AS CorAccountID, 'D' AS D_C,    
  ConvertedAmount, OriginalAmount, OriginalAmount AS OriginalAmountCN,   
  T90.CurrencyID AS CurrencyIDCN,   
  T90.CurrencyID, ExchangeRate, NULL AS WOrderID, NULL AS WTransactionID, ConvertedAmount AS SignAmount,  
   OriginalAmount AS SignOriginal,  
  T90.Quantity AS Quantity, T90.Quantity AS SignQuantity,   
  TranMonth, TranYear, VoucherNo, VoucherDate, '' AS Serial, '' AS InvoiceNo, null InvoiceDate, null DueDate, '' AS VATTypeID,  
  ISNULL(TDescription,VDescription) AS Description, ISNULL(VDescription,'') AS VDescription, '' AS BDescription,  
  T90.UnitPrice, null AS CommissionPercent, null AS DiscountRate,  
  T90.CreateUserID,  
   T90.ObjectID ,  
  T90.InventoryID,T90.UnitID,  
  null AS PeriodID,  
  ISNULL(Ana01ID,'') AS Ana01ID,  ISNULL(Ana02ID,'') AS Ana02ID,     ISNULL(Ana03ID,'') AS Ana03ID, ISNULL(Ana04ID,'') AS Ana04ID ,  ISNULL(Ana05ID,'') AS Ana05ID ,   
  ISNULL(T90.Ana06ID,'') AS Ana06ID, ISNULL(T90.Ana07ID,'') AS Ana07ID, ISNULL(T90.Ana08ID,'') AS Ana08ID ,  ISNULL(T90.Ana09ID,'') AS Ana09ID ,  ISNULL(T90.Ana10ID,'') AS Ana10ID ,  
  ISNULL(T01.AnaName,'') AS AnaName01 , ISNULL(T022.AnaName,'') AS AnaName02,  ISNULL(T033.AnaName,'') AS AnaName03, ISNULL(T04.AnaName,'') AS AnaName04,  ISNULL(T05.AnaName,'') AS AnaName05,  
  ISNULL(T06.AnaName,'') AS AnaName06 , ISNULL(T07.AnaName,'') AS AnaName07,  ISNULL(T08.AnaName,'') AS AnaName08, ISNULL(T09.AnaName,'') AS AnaName09,  ISNULL(T101.AnaName,'') AS AnaName10,  
  MAX(ISNULL(T022.Amount01,0)) AS Ana02Amount01, MAX(ISNULL(T022.Amount02,0))  AS Ana02Amount02, MAX(ISNULL(T022.Amount03,0))  AS Ana02Amount03,   
  MAX(ISNULL(T022.Note01,'')) AS Ana02Note01,MAX(ISNULL(T022.Note02,''))  AS Ana02Note02, MAX(ISNULL(T022.Note03,''))  AS Ana02Note03,  
  MAX(ISNULL(T022.RefDate,'')) AS Ana02RefDate,  
  ISNULL(O01ID,'') AS O01ID, ISNULL(O02ID,'') AS O02ID, ISNULL(O03ID,'') AS O03ID, ISNULL(O04ID,'') AS O04ID, ISNULL(O05ID,'') AS O05ID, 
  O01.AnaName AS O01Name,
  O02.AnaName AS O02Name,
  O03.AnaName AS O03Name,
  O04.AnaName AS O04Name,
  O05.AnaName AS O05Name,  
  ISNULL(I01ID,'') AS I01ID, ISNULL(I02ID,'') AS I02ID, ISNULL(I03ID,'') AS I03ID, ISNULL(I04ID,'') AS I04ID, ISNULL(I05ID,'') AS I05ID,   
  ISNULL(T02.S1,'') AS CO1ID,ISNULL(T02.S2,'') AS CO2ID,ISNULL(T02.S3,'') AS CO3ID,  
  ISNULL(T03.S1,'') AS CI1ID,ISNULL(T03.S2,'') AS CI2ID, ISNULL(T03.S3,'') AS CI3ID,  
  (Case BudgetType when 'M' then 'B1'  
       When 'Q' then 'B2'  
       When 'Y' then 'B3'  
       When 'P4' then 'B4'  
       When 'P5' then 'B5'  
  Else BudgetType End ) AS BudgetID,     
    
  (CASE WHEN  T90.TranMonth <10 then '0'+rtrim(ltrim(str(T90.TranMonth)))+'/'+ltrim(Rtrim(str(T90.TranYear)))   
  Else rtrim(ltrim(str(T90.TranMonth)))+'/'+ltrim(Rtrim(str(T90.TranYear))) End) AS MonthYear,  
  
  --('0'+ ltrim(rtrim(CASE WHEN T90.TranMonth %3 = 0 then T90.TranMonth/3  Else T90.TranMonth/3+1  End))+'/'+ltrim(Rtrim(str(T90.TranYear)))  
  --)  AS Quarter ,
  (select Quarter from AV9999 Where DivisionID = T90.DivisionID and TranMonth = T90.TranMonth and TranYear = T90.TranYear) as Quarter,

  str(T90.TranYear) AS Year,  
  null AS VATGroupID,  
  null AS VATRate,  
  0 AS VATOriginalAmount,   
  0 AS VATConvertedAmount,  
  null OrderID,  
  null AS  orderdate,  
  NULL AS DueDays,
  NULL AS PaymentTermID,
  Isnull(I01.AnaName,'') as I01Name,
  Isnull(AT1301.InventoryTypeName,'') as InventoryTypeName
  
FROM AT9090  T90    
LEFT JOIN AT1202 T02 ON T02.ObjectID = T90.ObjectID AND T02.DivisionID = T90.DivisionID  
LEFT JOIN AT1302 T03 ON T03.InventoryID = T90.InventoryID AND T03.DivisionID = T90.DivisionID  
LEFT JOIN AT1011 T01 ON T01.AnaID = T90.Ana01ID AND T01.AnaTypeID = 'A01'  AND T01.DivisionID = T90.DivisionID   
LEFT JOIN AT1011 T022 ON T022.AnaID = T90.Ana02ID AND T022.AnaTypeID = 'A02' AND T022.DivisionID = T90.DivisionID   
LEFT JOIN AT1011 T033 ON T033.AnaID = T90.Ana03ID AND T033.AnaTypeID = 'A03'  AND T033.DivisionID = T90.DivisionID  
LEFT JOIN AT1011 T04 ON T04.AnaID = T90.Ana04ID AND T04.AnaTypeID = 'A04'  AND T04.DivisionID = T90.DivisionID  
LEFT JOIN AT1011 T05 ON T05.AnaID = T90.Ana05ID AND T05.AnaTypeID = 'A05' And T05.DivisionID = T90.DivisionID  
LEFT JOIN AT1011 T06 ON T06.AnaID = T90.Ana06ID AND T06.AnaTypeID = 'A06'  AND T06.DivisionID = T90.DivisionID  
LEFT JOIN AT1011 T07 ON T07.AnaID = T90.Ana07ID AND T07.AnaTypeID = 'A07'  AND T07.DivisionID = T90.DivisionID  
LEFT JOIN AT1011 T08 ON T08.AnaID = T90.Ana08ID AND T08.AnaTypeID = 'A08'  AND T08.DivisionID = T90.DivisionID   
LEFT JOIN AT1011 T09 ON T09.AnaID = T90.Ana09ID AND T09.AnaTypeID = 'A09'  AND T09.DivisionID = T90.DivisionID  
LEFT JOIN AT1011 T101 ON T101.AnaID = T90.Ana10ID AND T101.AnaTypeID = 'A10'  AND T101.DivisionID = T90.DivisionID  

LEFT JOIN AT1015 O01 ON O01.AnaID = T02.O01ID AND O01.AnaTypeID = 'O01'  AND O01.DivisionID = T02.DivisionID  
LEFT JOIN AT1015 O02 ON O02.AnaID = T02.O02ID AND O02.AnaTypeID = 'O02'  AND O02.DivisionID = T02.DivisionID  
LEFT JOIN AT1015 O03 ON O03.AnaID = T02.O03ID AND O03.AnaTypeID = 'O03'  And O03.DivisionID = T02.DivisionID   
LEFT JOIN AT1015 O04 ON O04.AnaID = T02.O04ID AND O04.AnaTypeID = 'O04'  AND O04.DivisionID = T02.DivisionID  
LEFT JOIN AT1015 O05 ON O05.AnaID = T02.O05ID AND O05.AnaTypeID = 'O05'  AND O05.DivisionID = T02.DivisionID  

LEFT JOIN AT1015 I01 ON I01.AnaID = T03.I01ID AND I01.AnaTypeID = 'I01'  AND I01.DivisionID = T03.DivisionID  
LEFT JOIN AT1301 AT1301  ON AT1301.InventoryTypeID = T03.InventoryTypeID And T03.DivisionID = AT1301.DivisionID

WHERE ISNULL(DebitAccountID,'') <>'' --and BudgetType ='M'  
GROUP BY T90.DivisionID, T90.VoucherID,  TransactionID,   
   ISNULL(TransactionTypeID,''),   
  ISNULL(T90.VoucherTypeID,'') ,  
  T90.DebitAccountID , ISNULL(T90.CreditAccountID, '') ,  
  ConvertedAmount, OriginalAmount,   
  T90.CurrencyID, T90.ExchangeRate,   
  ConvertedAmount , OriginalAmount ,  
  T90.Quantity , T90.Quantity ,   
  T90.TranMonth, T90.TranYear, T90.VoucherNo, T90.VoucherDate,  t90.DueDate,   
  ISNULL(TDescription,VDescription) , ISNULL(VDescription,''),   
  T90.UnitPrice,   
  T90.CreateUserID,  
  T90.ObjectID,  
  T90.InventoryID, T90.UnitID,  
  BudgetType,  
  ISNULL(T90.Ana01ID,'') , ISNULL(T90.Ana02ID,'') , ISNULL(T90.Ana03ID,'') ,  ISNULL(T90.Ana04ID,'') ,  ISNULL(T90.Ana05ID,'') ,  
  ISNULL(T90.Ana06ID,'') , ISNULL(T90.Ana07ID,'') , ISNULL(T90.Ana08ID,'') ,  ISNULL(T90.Ana09ID,'') ,  ISNULL(T90.Ana10ID,'') ,  
  ISNULL(T01.AnaName,'') , ISNULL(T022.AnaName,'') ,  ISNULL(T033.AnaName,'') , ISNULL(T04.AnaName,'') ,  ISNULL(T05.AnaName,''),  
  ISNULL(T06.AnaName,'') , ISNULL(T07.AnaName,'') ,  ISNULL(T08.AnaName,'') , ISNULL(T09.AnaName,'') ,  ISNULL(T101.AnaName,'') ,  
  ISNULL(O01ID,''), ISNULL(O02ID,''), ISNULL(O03ID,''), ISNULL(O04ID,''), ISNULL(O05ID,''),
  O01.AnaName ,  O02.AnaName ,  O03.AnaName ,  O04.AnaName ,  O05.AnaName ,     
  ISNULL(I01ID,'') , ISNULL(I02ID,''), ISNULL(I03ID,''), ISNULL(I04ID,''), ISNULL(I05ID,''),   
  ISNULL(T02.S1,''),ISNULL(T02.S2,''),ISNULL(T02.S3,''),  
  ISNULL(T03.S1,'') ,ISNULL(T03.S2,''), ISNULL(T03.S3,''),    
  T90.TranMonth, T90.TranYear  ,
  Isnull(I01.AnaName,''),
  Isnull(AT1301.InventoryTypeName,'')
		

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON