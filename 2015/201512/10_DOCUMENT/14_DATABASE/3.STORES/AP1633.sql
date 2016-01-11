IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP1633]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AP1633]
GO


---- Tra ra man hinh khi ke thua nghiep vu tu ASOFT T sang FA  cho CCDC
---- Created by Khanh Van on 08/10/2013
---- Update by Khanh Van on 13/01/2014: Thay đổi cách load dữ liệu

CREATE PROCEDURE [dbo].[AP1633]   
    @DivisionID VARCHAR(50),  
    @FromMonth INT,  
    @FromYear INT,  
    @ToMonth INT,  
    @ToYear INT,   
    @FromDate DATETIME,  
    @ToDate DATETIME,  
    @IsDate TINYINT, -- 0 theo ky, 1 theo ngày  
    @TransactionTypeID VARCHAR(50), -- Mua hàng: "T03", Tổng hợp: "T99", Xuất kho: "T06"   
    @AccountID VARCHAR(50)   
AS  
  
DECLARE   
@sSQL1 NVARCHAR(4000), 
@sSQL2 NVARCHAR(4000), 
@sSQLWhere NVARCHAR(4000), 
@Union NVARCHAR(4000)  

If(@IsDate = 0)
	Set @sSQLWhere =   'AND AT9000.TranMonth + AT9000.TranYear * 100 BETWEEN ' + CAST(@FromMonth + @FromYear * 100 AS VARCHAR(20)) + ' AND ' + CAST(@ToMonth + @ToYear * 100 AS VARCHAR(20))+''
Else
	Set @sSQLWhere = 'AND AT9000.VoucherDate BETWEEN ''' + CONVERT(VARCHAR(10), @FromDate, 21) + ''' AND ''' + CONVERT(VARCHAR(10), @ToDate, 21) + ''''


 Set @sSQL1='  
Select AT9000.DivisionID, VoucherID, TransactionID, VoucherNo, VoucherDate, AT9000.InventoryID, ConvertedAmount, TDescription,DebitAccountID,CreditAccountID,  InventoryName, Quantity, AT9000.TransactionTypeID, IsEdit = CONVERT(TINYINT, 0),Serial, InvoiceNo, InvoiceDate, AT9000.ObjectID    
Into #AV1631
From AT9000    
 left join AT1302 on AT1302.InventoryID = AT9000.InventoryID and AT1302.DivisionID = AT9000.DivisionID   
 Where   AT9000.DivisionID = '''+@DivisionID+'''  
  and DebitAccountID = '''+@AccountID+'''  
  AND AT9000.TransactionTypeID LIKE ''' + @TransactionTypeID + '''  
  and VoucherID not in   
  (Select VoucherID from AT1703 Inner join AT1704 on AT1703.JobID = AT1704.JobID   
  Where AT1704.Status = 1 and  AT1703.DivisionID = '''+@DivisionID+''')' + @sSQLWhere
  
  
Set @sSQL2='  
 Select Convert(TinyInt, 0) As Choose,
  AV1631.DivisionID,  
  AV1631.VoucherID, 
    AV1631.InventoryID, 
      AV1631.InventoryName,  
            AV1631.Quantity, 
  AV1631.TransactionID,   
  AV1631.VoucherNo,   
  AV1631.VoucherDate,   
  '''' as VDescription,    
  AV1631.TDescription,
  AV1631.TransactionTypeID,   
  AV1631.DebitAccountID,    
  AV1631.CreditAccountID,
  (AV1631.ConvertedAmount - (isnull(A.ConvertedAmount,0))) as ConvertedAmount,
  AV1631.IsEdit, Serial, InvoiceNo, InvoiceDate, AV1631.ObjectID
 From #AV1631 AV1631 
 left join  (SELECT ISNULL(SUM(ISNULL(ConvertedAmount, 0)), 0) AS ConvertedAmount, ReTransactionID, DivisionID   
    FROM AT1633 
    GROUP BY ReTransactionID, DivisionID) A  on A.ReTransactionID = AV1631.TransactionID and A.DivisionID = AV1631.DivisionID  
 Group by  
  AV1631.DivisionID, AV1631.VoucherID, AV1631.TransactionID, AV1631.VoucherNo, AV1631.VoucherDate, AV1631.TransactionTypeID,    
  AV1631.TDescription, AV1631.DebitAccountID,   AV1631.CreditAccountID, AV1631.ConvertedAmount  ,AV1631.IsEdit,    AV1631.InventoryID,  AV1631.InventoryName,  AV1631.Quantity, Serial, InvoiceNo, InvoiceDate, AV1631.ObjectID, A.ConvertedAmount
 Having  (AV1631.ConvertedAmount - (isnull(A.ConvertedAmount,0)))  > 0  
  
'    
print @sSQL1
print @sSQL2
Exec (@sSQL1+@sSQL2)
