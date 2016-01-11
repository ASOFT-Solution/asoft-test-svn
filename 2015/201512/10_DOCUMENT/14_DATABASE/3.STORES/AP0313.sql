IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0313]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0313]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Bao cao chi tiet tinh hinh thanh toan no phai thu
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 17/11/2003 by Nguyen Van  Nhan
---- 
---- Edited By: Nguyen Quoc Huy, Date: 15/08/2006
---- Last Update :Nguyen Thi Thuy Tuyen ,Date 13/09/2006,18/06/2009
---- Last Update : Thuy Tuyen : WHere them dieu kien : AV0302.BatchID = AT0303.CreditBatchID , AV0301.BatchID = AT0303.DebitBatchID , date 10/07/2009, 29/07/2009 thêm  Istotal phuc vu cong tac bao cao
---- Modified on 02/12/2011 by Le Thi Thu Hien : Lay Sum so tien ben no ( sua bao cao cua khach hang Vien Tin khi SOrderID ke thua khong ke thua dong thue)
---- Modified on 06/12/2011 by Le Thi Thu Hien : Sua ngay CONVERT(varchar(10),VoucherDate,101)
---- Modified on 16/01/2012 by Le Thi Thu Hien : CONVERT lai ngay
---- Modified on 08/02/2012 by Le Thi Thu Hien : Bo sung them JOIN DivisionID
---- Modified on 19/11/2012 by Thiên Huỳnh: Lấy Max Khoản mục, không Group By
---- Modified on 04/03/2013 by Thiên Huỳnh: Bỏ Convert trường DebitDueDate
---- Modified on 08/02/2012 by Le Thi Thu Hien : Bo sung them 1 so truong
---- Modified on 06/03/2013 by Khanh Van: Bo sung tu tai khoan den tai khoan cho Sieu Thanh
---- Modified on 06/01/2014 by Bao Anh: Customize bao cao cong no cho Dacin
---- Modified on 05/03/2014 by Mai Duyen: bo sung them reportcode,Customize bao cao cong no cho King Com
---- Modified on 20/03/2014 by Mai Duyen: Sua lay Days cho truong hop cho phieu chua giai tru (Customized Kingcom) 
---- Modified on 17/11/2014 by Mai Duyen : Bổ sung thêm DatabaseName (tinh năng In báo cao chi tiet tinh hinh no phai thu 2 Database, KH SIEUTHANH)
---- Modified on 05/12/2014 by Mai Duyen : Bo sung field DB (Customized bao cao 2 DB cho SIEU THANH)
---- Modified on 03/02/2015 by Quốc Tuấn : Fix bug cho Car Ms.Tuyền
---- Modified on 30/11/2015 by Bảo Anh : Bỏ join AV0312 khi tạo view AV0329, bổ sung sum số tiền trong câu tạo view AV0330 (fix lỗi cho Tiên Tiến)
--- <Example>
---- AP0313 'AS','0000000001','0000000001','1311','1311','VND',0,'05/01/2012','05/31/2012',5,2012,5,2012,0,0,AR0313
-----exec AP0313 @DivisionID=N'KC',@FromObjectID=N'0000000012',@ToObjectID=N'0000000012',@FromAccountID=N'1311',@ToAccountID=N'337',@CurrencyID=N'VND',@IsDate=0,@FromDate='2014-03-05 13:14:03.047',@ToDate='2014-03-05 13:14:03.047',@FromMonth=12,@FromYear=2013,@ToMonth=1,@ToYear=2014,@IsZero=1,@IsNotGiveUp=0,@ReportCode='AR0324'

CREATE PROCEDURE [dbo].[AP0313]    
    @DivisionID nvarchar(50),   
    @FromObjectID AS nvarchar(50),  
    @ToObjectID AS nvarchar(50),  
    @FromAccountID AS nvarchar(50),  
    @ToAccountID AS nvarchar(50),  
    @CurrencyID  AS nvarchar(50),  
    @IsDate AS tinyint,  
    @FromDate AS Datetime,  
    @ToDate AS  Datetime,  
    @FromMonth AS int,  
    @FromYear AS int,  
    @ToMonth AS int,  
    @ToYear AS int,  
    @IsZero AS int,  
    @IsNotGiveUp AS int ,
    @ReportCode as varchar(50) ="AR0313",
    @DatabaseName  as NVARCHAR(250)=''
 AS  
DECLARE 
  @sSQL AS nvarchar(4000),
  @sSQL1 AS nvarchar(4000),  
  @sSQL2 AS nvarchar(4000),  
  @sSQLGroup AS nvarchar(4000),  
  @sSQLUnionAll AS nvarchar(max),  
  @sTime AS nvarchar(4000),  
  @sTime1 AS nvarchar(4000), --- Phan Union ALL  
  @sTime2 AS  nvarchar(4000) ,  --- Phuc vu lay view nhung phan giai tru den thoi gian ToMonth, ToDate - Ap dung cho PS No  
  @sTime3 AS  nvarchar(4000)   --- Phuc vu lay view nhung phan giai tru den thoi gian ToMonth, ToDate - Ap dung cho PS Co  

--Add by Dang Le Bao Quynh; Date 03/05/2013  
--Purpose: Kiem tra customize cho Sieu Thanh  
Declare @AP4444 Table(CustomerName Int, Export Int)  
Insert Into @AP4444(CustomerName,Export) EXEC('AP4444')  
If (Select CustomerName From @AP4444)<>16
BEGIN  
	SET @sSQLGroup = ''  
	SET @sSQL = '    
	 SELECT BatchID+ObjectID  AS LinkID, AV0301.DivisionID    
	 FROM AV0301  
	 WHERE  (DebitAccountID >= '''+@FromAccountID+''' AND DebitAccountID<= '''+@ToAccountID+''' )AND  
	   DivisionID = '''+@DivisionID+''' AND   
	   (ObjectID >= '''+@FromObjectID+''' AND ObjectID<= '''+@ToObjectID+''' )and  
	   CurrencyIDCN like '''+@CurrencyID+''' AND    
	   OriginalAmountCN-GivedOriginalAmount >0   '  
	  
	IF @IsDate =0   
	 SET @sTime ='TranMonth + 100*TranYear between '+str(@FromMonth)+' + 100*'+str(@FromYear)+'  AND  '+str(@ToMonth)+' + 100*'+str(@ToYear)+'  '  
	IF @IsDate =1  
	 SET @sTime ='CONVERT(DATETIME,CONVERT(varchar(10),VoucherDate,101),101)  BETWEEN '''+ convert(nvarchar(10),@FromDate,101) +''' AND '''+convert(nvarchar(10),@ToDate,101)+'''  '  
	IF  @IsDate =2  
	 SET @sTime ='CONVERT(DATETIME,CONVERT(varchar(10),InvoiceDate,101),101)  BETWEEN '''+ convert(nvarchar(10),@FromDate,101) +''' AND '''+convert(nvarchar(10),@ToDate,101)+'''   '  
	  
	SET @sSQL = @sSQL+' AND '+@sTime  
	  
	IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE NAME ='AV0314')  
	 EXEC ('CREATE VIEW AV0314 AS '+@sSQL)  
	ELSE  
	 EXEC( 'ALTER VIEW AV0314 AS '+@sSQL)  
	  
	  
	  
	SET @sTime =''  
	  
	--Print ' VAN NHAN'  
	IF @IsDate =0   
	  Begin   
	 SET @sTime ='AV0311.TranMonth + 100*AV0311.TranYear between '+str(@FromMonth)+' + 100*'+str(@FromYear)+'  AND  '+str(@ToMonth)+' + 100*'+str(@ToYear)+'  '  
	 SET @sTime1 ='T9.TranMonth + 100*T9.TranYear between '+str(@FromMonth)+' + 100*'+str(@FromYear)+'  AND  '+str(@ToMonth)+' + 100*'+str(@ToYear)+'  '  
	 SET @sTime2 ='AV0302.TranMonth + 100*AV0302.TranYear <=  '+str(@ToMonth)+' + 100*'+str(@ToYear)+'  '  
	 SET @sTime3 ='AV0301.TranMonth + 100*AV0301.TranYear <=  '+str(@ToMonth)+' + 100*'+str(@ToYear)+'  '  
	  
	  End  
	IF @IsDate =1  
	  Begin   
	 SET @sTime ='CONVERT(DATETIME,CONVERT(varchar(10),AV0311.VoucherDate,101),101)  Between '''+ convert(nvarchar(10),@FromDate,101) +''' AND '''+convert(nvarchar(10),@ToDate,101)+'''  '  
	 SET @sTime1 ='CONVERT(DATETIME,CONVERT(varchar(10),T9.VoucherDate,101),101)  Between '''+ convert(nvarchar(10),@FromDate,101) +''' AND '''+convert(nvarchar(10),@ToDate,101)+'''  '  
	 SET @sTime2 ='CONVERT(DATETIME,CONVERT(varchar(10),AV0302.VoucherDate,101),101)  <= '''+convert(nvarchar(10),@ToDate,101)+'''  '  
	 SET @sTime3 ='CONVERT(DATETIME,CONVERT(varchar(10),AV0301.VoucherDate,101),101)  <= '''+convert(nvarchar(10),@ToDate,101)+'''  '  
	  End  
	IF  @IsDate =2  
	  Begin   
	 SET @sTime ='CONVERT(DATETIME,CONVERT(varchar(10),AV0311.InvoiceDate,101),101)  Between '''+ convert(nvarchar(10),@FromDate,101) +''' AND '''+convert(nvarchar(10),@ToDate,101)+'''   '  
	 SET @sTime1 ='CONVERT(DATETIME,CONVERT(varchar(10),T9.InvoiceDate,101),101)  Between '''+ convert(nvarchar(10),@FromDate,101) +''' AND '''+convert(nvarchar(10),@ToDate,101)+'''   '  
	 SET @sTime2 ='CONVERT(DATETIME,CONVERT(varchar(10),AV0302.InvoiceDate,101),101)  <= '''+convert(nvarchar(10),@ToDate,101)+'''   '  
	 SET @sTime3 ='CONVERT(DATETIME,CONVERT(varchar(10),AV0301.InvoiceDate,101),101)  <= '''+convert(nvarchar(10),@ToDate,101)+'''   '  
	End  
	----- Tao view de lay len so da giai tru den thoi gian bao cao --------------------------------------------------  
	SET @sSQL ='   
	SELECT DISTINCT AT0303.GiveUpDate, AT0303.GiveUpEmployeeID, AT0303.DivisionID,   
		AT0303.ObjectID, AT0303.AccountID, AT0303.CurrencyID,   
		AT0303.DebitVoucherID, AT0303.DebitBatchID, AT0303.DebitTableID,   
		AT0303.CreditVoucherID, AT0303.CreditBatchID, AT0303.CreditTableID,   
		AT0303.OriginalAmount, AT0303.ConvertedAmount, AT0303.IsExrateDiff,   
		AT0303.CreateDate, AT0303.CreateUseID, AT0303.LastModifyDate, AT0303.LastModifyUserID,
		AV0302.BDescription, AV0302.Serial, AV0302.VoucherNo, AV0302.VoucherDate, AV0302.InvoiceDate, AV0302.InvoiceNo, AV0302.VoucherTypeID
	FROM  AT0303   
	INNER JOIN AV0302   
	 ON   AV0302.VoucherID = AT0303.CreditVoucherID AND  
	   AV0302.TableID = AT0303.CreditTableID AND  
	   AV0302.BatchID = AT0303.CreditBatchID AND  
	   AV0302.ObjectID = AT0303.ObjectID AND  
	   AV0302.CreditAccountID = AT0303.AccountID AND  
	   AV0302.DivisionID = AT0303.DivisionID      
	WHERE AT0303.DivisionID ='''+@DivisionID+'''  AND  
	  AT0303.ObjectID >= '''+@FromObjectID+''' AND   
	  AT0303.ObjectID<= '''+@ToObjectID+''' AND  
	  AT0303.CurrencyID like '''+@CurrencyID+''' AND  
	  AT0303.AccountID >= '''+@FromAccountID+''' AND   
	  AT0303.AccountID<= '''+@ToAccountID+''' AND '+@sTime2+' '  
	  
	IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE NAME ='AV0321')  
	 EXEC ('CREATE VIEW AV0321 AS '+@sSQL)  
	ELSE  
	 EXEC( 'ALTER VIEW AV0321 AS '+@sSQL)  
	   
	SET @sSQL ='   
	SELECT DISTINCT AT0303.GiveUpDate, AT0303.GiveUpEmployeeID, AT0303.DivisionID,   
	   AT0303.ObjectID, AT0303.AccountID, AT0303.CurrencyID,   
	   AT0303.DebitVoucherID, AT0303.DebitBatchID, AT0303.DebitTableID,   
	   AT0303.CreditVoucherID, AT0303.CreditBatchID, AT0303.CreditTableID,   
	   AT0303.OriginalAmount, AT0303.ConvertedAmount, AT0303.IsExrateDiff,   
	   AT0303.CreateDate, AT0303.CreateUseID, AT0303.LastModifyDate, AT0303.LastModifyUserID  
	FROM  AT0303   
	INNER JOIN AV0301   
	 ON   AV0301.VoucherID = AT0303.DebitVoucherID AND  
	   AV0301.TableID = AT0303.DebitTableID AND  
	   AV0301.BatchID = AT0303.DebitBatchID AND  
	   AV0301.ObjectID = AT0303.ObjectID AND  
	   AV0301.DebitAccountID = AT0303.AccountID AND  
	   AV0301.DivisionID = AT0303.DivisionID  
	WHERE AT0303.DivisionID ='''+@DivisionID+'''  AND  
	  AT0303.ObjectID >= '''+@FromObjectID+''' AND AT0303.ObjectID<= '''+@ToObjectID+''' AND  
	  AT0303.CurrencyID like '''+@CurrencyID+''' AND  
	  AT0303.AccountID >= '''+@FromAccountID+''' AND AT0303.AccountID<= '''+@ToAccountID+''' AND '+@sTime3+' '  
	  
	IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE NAME ='AV0323')  
	 EXEC ('CREATE VIEW AV0323 AS '+@sSQL)  
	ELSE  
	 EXEC( 'ALTER VIEW AV0323 AS '+@sSQL)  
	--Print  @sSQL  
	  
	-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
	  
	SET @sSQL ='  
	SELECT  AV0311.ObjectID+AV0311.DebitAccountID AS GroupID,  
	  AV0311.VoucherID, AV0311.BatchID,   
	  AV0311.ObjectID,   
	  AT1202.ObjectName,  
	  AV0311.DebitAccountID,   
	  AV0311.DebitAccountName,   
	  AV0311.CurrencyID,   
	  AV0311.CurrencyIDCN,  
	  AV0311.BDescription AS DebitDescription,  
	  AV0311.CDescription AS  DebitCDescription,  
	  SUM(AV0311.OriginalAmount) AS OriginalAmount,  
	  SUM(AV0311.OriginalAmountCN) AS OriginalAmountCN,   --- So tien nguyen te theo doi cong no  
	  SUM(AV0311.ConvertedAmount) AS ConvertedAmount,   --- So tien quy doi   
	  
	  SUM(isnull(AT0303.OriginalAmount,0)) AS GiveUpOrAmount, --- So tien nguyen te giai tru tuong ung  
	  SUM(isnull(AT0303.ConvertedAmount,0)) AS GiveUpCoAmount, --- So tien quy doi giai tru tuong ung  
	    
	  AV0311.VoucherNo AS DebitVoucherNo,    
	  AV0311.VoucherDate AS DebitVoucherDate,  
	  AV0311.Serial AS DebitSerial,  
	  AV0311.InvoiceDate AS DebitInvoiceDate,  
	  AV0311.InvoiceNo AS DebitInvoiceNo,  
	  --CONVERT (nvarchar(50), AV0311.Duedate,103) AS DebitDueDate,    
	  AV0311.Duedate As DebitDueDate,  
	  AT0303.BDescription AS CreditDescription,  
	  AT0303.BDesCription AS CreditCDescription,  
	  AT0303.Serial AS CreditSerial,  
	  AT0303.VoucherNo AS CreditVoucherNo,  
	  AT0303.VoucherDate AS CreditVoucherDate,  
	  AT0303.InvoiceDate AS CreditInvoiceDate,  
	  AT0303.InvoiceNo AS CreditInvoiceNo,  
	  AT0303.VoucherTypeID AS CreditVoucherTypeID,  
	  AV0311.VoucherTypeID AS DebitVoucherTypeID,  
	  Max(AV0311.Ana01ID) As Ana01ID, Max(AV0311.AnaName01) AS AnaName01,  
	  Max(AV0311.Ana02ID) As Ana02ID, Max(AV0311.AnaName02) AS AnaName02,  
	  Max(AV0311.Ana03ID) As Ana03ID, Max(AV0311.AnaName03) AS AnaName03,  
	  Max(AV0311.Ana04ID) As Ana04ID, Max(AV0311.AnaName04) AS AnaName04,  
	  Max(AV0311.Ana05ID) As Ana05ID, Max(AV0311.AnaName05) AS AnaName05,  
	  Max(AV0311.Ana06ID) As Ana06ID, Max(AV0311.AnaName06) AS AnaName06,  
	  Max(AV0311.Ana07ID) As Ana07ID, Max(AV0311.AnaName07) AS AnaName07,  
	  Max(AV0311.Ana08ID) As Ana08ID, Max(AV0311.AnaName08) AS AnaName08,  
	  Max(AV0311.Ana09ID) As Ana09ID, Max(AV0311.AnaName09) AS AnaName09,  
	  Max(AV0311.Ana10ID) As Ana10ID, Max(AV0311.AnaName10) AS AnaName10,  '
	SET @sSQL1 ='   
	  MAX(AV0311.Parameter01) AS Parameter01,  
	  MAX(AV0311.Parameter02) AS Parameter02,  
	  MAX(AV0311.Parameter03) AS Parameter03,  
	  MAX(AV0311.Parameter04) AS Parameter04,  
	  MAX(AV0311.Parameter05) AS Parameter05,  
	  MAX(AV0311.Parameter06) AS Parameter06,  
	  MAX(AV0311.Parameter07) AS Parameter07,  
	  MAX(AV0311.Parameter08) AS Parameter08,  
	  MAX(AV0311.Parameter09) AS Parameter09,  
	  MAX(AV0311.Parameter10) AS Parameter10,  
	  '''+convert(nvarchar(10),@FromDate,103)+''' AS Fromdate,  
	  ( CASE WHEN'+str(@IsDate)+'= 0 THEN ''30/'+Ltrim (str(@ToMonth))+'/'+ltrim(str(@ToYear))+'''  else   '''+convert(nvarchar(10),@ToDate,103)+''' end ) AS Todate,  
	  MAX(AV0311.SOrderID) AS SOrderID,   
	  MAX(AV0311.OrderDate) AS OrderDate,  
	  AV0311.ClassifyID,  
	  AV0311.O01ID, AV0311.O02ID, AV0311.O03ID,AV0311.O04ID, AV0311.O05ID,  
	  AV0311.O01Name , AV0311.O02Name ,AV0311.O03Name ,AV0311.O04Name,AV0311.O05Name,  
	  1 AS IsToltal, AV0311.DivisionID  
	  
	FROM  AV0311    
	LEFT JOIN AV0321 AS AT0303   
	 ON   AV0311.VoucherID = AT0303.DebitVoucherID AND  
	   AV0311.ObjectID = AT0303.ObjectID AND    
	   AV0311.BatchID = AT0303.DebitBatchID AND  
	   AV0311.TableID = AT0303.DebitTableID AND  
	   AV0311.DebitAccountID = AT0303.AccountID AND   
		  AV0311.DivisionID = AT0303.DivisionID   
	--LEFT JOIN   AV0312   
	-- ON   AV0312.VoucherID = AT0303.CreditVoucherID AND  
	--   AV0312.ObjectID = AT0303.ObjectID AND    
	--   AV0312.BatchID = AT0303.CreditBatchID AND  
	--   AV0312.TableID = AT0303.CreditTableID AND       
	--   AV0312.CreditAccountID =AT0303.AccountID AND  
	--   AV0312.DivisionID =AT0303.DivisionID  
	--   --and AV0312.TranMonth = 8  
	LEFT JOIN AT1202 on  AT1202.ObjectID = AV0311.ObjectID AND AT1202.DivisionID = AV0311.DivisionID  
	       
	WHERE  AV0311.DivisionID = '''+@DivisionID+''' AND   
	  AV0311.ObjectID >= '''+@FromObjectID+''' AND   
	  AV0311.ObjectID<= '''+@ToObjectID+''' AND  
	  AV0311.CurrencyIDCN like '''+@CurrencyID+''' AND  
	  AV0311.DebitAccountID >= '''+@FromAccountID+''' AND   
	  AV0311.DebitAccountID<= '''+@ToAccountID+'''  '  

	--print @sSQL  
	IF @IsZero = 1  --khong hien thi hoa don da giai tru het  
	 SET @sSQL1 = @sSQL1 +' AND AV0311.BatchID+AV0311.ObjectID in (Select LinkID From AV0314 ) '  
	  
	IF @IsNotGiveUp = 1 --khong hien thi hoa don chua giai tru   
	 SET @sSQL1 = @sSQL1 +' AND ( AV0311.Status <>0 ) '  
	  
	SET @sSQL1 = @sSQL1 +' AND '+@sTime  
	  
	SET @sSQLGroup = '  
	GROUP BY AV0311.ObjectID+AV0311.DebitAccountID ,  
	  AV0311.VoucherID, AV0311.BatchID,   
	  AV0311.ObjectID,   
	  AT1202.ObjectName,  
	  AV0311.DebitAccountID,   
	  AV0311.DebitAccountName,   
	  AV0311.CurrencyID,   
	  AV0311.CurrencyIDCN,  
	  AV0311.BDescription ,  
	  AV0311.CDescription ,  
	    
	  AV0311.VoucherNo ,    
	  AV0311.VoucherDate ,  
	  AV0311.Serial ,  
	  AV0311.InvoiceDate ,  
	  AV0311.InvoiceNo ,  
	  AV0311.Duedate ,    
	  AT0303.BDescription ,  
	  AT0303.BDescription ,  
	  AT0303.Serial ,  
	  AT0303.VoucherNo ,  
	  AT0303.VoucherDate ,  
	  AT0303.InvoiceDate ,  
	  AT0303.InvoiceNo ,  
	  AT0303.VoucherTypeID ,  
	  AV0311.VoucherTypeID ,  
	  --AV0311.Ana01ID,  
	  --AV0311.Ana02ID,  
	  --AV0311.Ana03ID,  
	  --AV0311.AnaName01,  
	  --AT1011.AnaName ,  
	    
	  AV0311.ClassifyID,  
	  AV0311.O01ID, AV0311.O02ID, AV0311.O03ID,AV0311.O04ID, AV0311.O05ID,  
	  AV0311.O01Name, AV0311.O02Name ,AV0311.O03Name ,AV0311.O04Name,AV0311.O05Name,  
	  AV0311.DivisionID  
	 '  
	IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE NAME ='AV0329')  
	 EXEC ('CREATE VIEW AV0329 AS '+@sSQL + @sSQL1 + @sSQLGroup)  
	ELSE  
	 EXEC( 'ALTER VIEW AV0329 AS '+@sSQL + @sSQL1 + @sSQLGroup)  

	SET @sSQL ='  
	SELECT  T9.ObjectID+ T9.CreditAccountID AS  GroupID,  
	  T9.VoucherID AS VoucherID,  
	  T9.BatchID,    
	  T9.ObjectID,  
	  A.ObjectName,     
	    
	  T9.CreditAccountID  AS DebitAccountID,  
	  AT1005.AccountName AS DebitAccountName,   
	  T9.CurrencyID, T9.CurrencyIDCN,  
	  T9.BDescription AS DebitDescription,  
	  T9.CDescription AS  DebitCDescription,  
	  -(sum(OriginalAmountCN) - isnull(T03.OriginalAmount,0)) AS OriginalAmount,  
	  -(sum(OriginalAmountCN) - isnull(T03.OriginalAmount,0)) AS OriginalAmountCN,    --- So tien nguyen te theo doi cong no  
	  -(sum(T9.ConvertedAmount) - T03.ConvertedAmount) AS ConvertedAmount,  --- So tien quy doi   
	  0 AS GiveUpOrAmount, --- So tien nguyen te giai tru tuong ung  
	  0 AS GiveUpCoAmount, --- So tien quy doi giai tru tuong ung  
	  T9.VoucherNo AS DebitVoucherNo,    
	  T9.VoucherDate AS DebitVoucherDate,  
	  T9.Serial AS DebitSerial,  
	  T9.InvoiceDate AS DebitInvoiceDate,  
	  T9.InvoiceNo AS DebitInvoiceNo,  
	   --convert (nvarchar(50), T9.Duedate,103) AS DebitDueDate,    
	   T9.Duedate As DebitDueDate,  
	  '' '' AS CreditDescription,  
	  '' '' AS CreditCDescriptinon,  
	  '' '' AS CreditSerial,  
	  '' '' AS CreditVoucherNo,  
	  null  AS CreditVoucherDate,  
	  null  AS CreditInvoiceDate,  
	  '' '' AS CreditInvoiceNo,  
	  '' '' AS CreditVoucherTypeID,  
	  T9.VoucherTypeID AS DebitVoucherTypeID,  
	  Max(T9.Ana01ID) As Ana01ID, Max(T9.AnaName01) AS AnaName01,  
	  Max(T9.Ana02ID) As Ana02ID, Max(T9.AnaName02) AS AnaName02,  
	  Max(T9.Ana03ID) As Ana03ID, Max(T9.AnaName03) AS AnaName03,  
	  Max(T9.Ana04ID) As Ana04ID, Max(T9.AnaName04) AS AnaName04,  
	  Max(T9.Ana05ID) As Ana05ID, Max(T9.AnaName05) AS AnaName05,  
	  Max(T9.Ana06ID) As Ana06ID, Max(T9.AnaName06) AS AnaName06,  
	  Max(T9.Ana07ID) As Ana07ID, Max(T9.AnaName07) AS AnaName07,  
	  Max(T9.Ana08ID) As Ana08ID, Max(T9.AnaName08) AS AnaName08,  
	  Max(T9.Ana09ID) As Ana09ID, Max(T9.AnaName09) AS AnaName09,  
	  Max(T9.Ana10ID) As Ana10ID, Max(T9.AnaName10) AS AnaName10,  
	  MAX(T9.Parameter01) AS Parameter01,  
	  MAX(T9.Parameter02) AS Parameter02,  
	  MAX(T9.Parameter03) AS Parameter03,  
	  MAX(T9.Parameter04) AS Parameter04,  
	  MAX(T9.Parameter05) AS Parameter05,  
	  MAX(T9.Parameter06) AS Parameter06,  
	  MAX(T9.Parameter07) AS Parameter07,  
	  MAX(T9.Parameter08) AS Parameter08,  
	  MAX(T9.Parameter09) AS Parameter09,  
	  MAX(T9.Parameter10) AS Parameter10,  
		'''+convert(nvarchar(10),@FromDate,103)+''' AS Fromdate,  
	  (  case when'+str(@IsDate)+'= 0 then    ''30/'+Ltrim (str(@ToMonth))+'/'+ltrim(str(@ToYear))+'''  else   '''+convert(nvarchar(10),@ToDate,103)+''' end ) AS Todate,  
	  MAX(T9.SOrderID) AS SOrderID,   
	  MAX(T9.OrderDate) AS OrderDate,T9.ClassifyID,  
	  T9.O01ID, T9.O02ID, T9.O03ID,T9.O04ID, T9.O05ID,  
	  T9.O01Name , T9.O02Name ,T9.O03Name ,T9.O04Name,T9.O05Name,  
	  0 AS IsToltal, T9.DivisionID  
	  
	FROM  AV0312 T9    
	FULL JOIN   ( SELECT CreditVoucherID, CreditbatchID, AccountID, sum(OriginalAMount) AS OriginalAMount,  
		  Sum(ConvertedAmount) AS ConvertedAMount, ObjectID , DivisionID  
		FROM AV0323   
				  GROUP BY CreditVoucherID, CreditbatchID, AccountID, ObjectID, DivisionID  
	   ) AS T03   
	 ON  T03.ObjectID = T9.ObjectID  AND  
	   T03.CreditVoucherID = T9.VoucherID AND  
		  T03.CreditbatchID = T9.BatchID AND  

	   T03.AccountID = T9.CreditAccountID AND  
	   T03.DivisionID = T9.DivisionID  
	INNER JOIN AT1005   
	 ON   AT1005.AccountID = T9.CreditAccountID AND  
	   AT1005.GroupID=''G03'' AND  
	   AT1005.DivisionID = T9.DivisionID  
	LEFT JOIN AT1202 A on A.ObjectID =  T9.ObjectID AND A.DivisionID = T9.DivisionID  
	  
	WHERE  T9.DivisionID ='''+@DivisionID+''' AND    
	  T9.ObjectID >= '''+@FromObjectID+''' AND   
	  T9.ObjectID<= '''+@ToObjectID+''' AND  
	  T9.CurrencyIDCN like '''+@CurrencyID+''' AND  
	  T9.CreditAccountID >= '''+@FromAccountID+''' AND   
	  T9.CreditAccountID <= '''+@ToAccountID+''' AND  
	  '+@sTime1
	  
	  SET @sSQL1 ='  
	GROUP BY  T9.VoucherID,--- T9.OriginalAmount,T9.OriginalAmountCN, T9.ConvertedAmount,  
	   T9.CreditAccountID,   
	   T9.BatchID,  --Ana01ID ,  AnaName01 , Ana02ID,Ana03ID,   AnaName ,  
	   T9.TableID, T9.DivisionID,T9.TranMonth, T9.TranYear,  
	   T9.ObjectID ,T9.CurrencyID, T9.CurrencyIDCN,  
	   ExchangeRate, ExchangeRateCN,  
	   VoucherTypeID, VoucherNO, VoucherDate,InvoiceDate,InvoiceNo, Serial,  
	   VDescription,    
	   T9.PaymentID, T9.DueDays, T9.DueDate, T9.CDescription,  
	   A.ObjectName , AT1005.AccountName,   T03.OriginalAmount, T03.ConvertedAmount, T9.BDescription,  
	   T9.ClassifyID , T9.O01ID, T9.O02ID, T9.O03ID,T9.O04ID, T9.O05ID,  
	   T9.O01Name , T9.O02Name ,T9.O03Name ,T9.O04Name,T9.O05Name, T9.DivisionID'  
	  
	IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE NAME ='AV0330')  
	 EXEC ('CREATE VIEW AV0330 AS '+@sSQL + @sSQL1)  
	ELSE  
	 EXEC( 'ALTER VIEW AV0330 AS '+@sSQL + @sSQL1)  
	  
	  
	  
	IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE NAME ='AV0315')  
	 EXEC ('CREATE VIEW AV0315 AS SELECT * FROM AV0329 UNION SELECT * FROM AV0330')  
	ELSE  
	 EXEC( 'ALTER VIEW AV0315 AS SELECT  * FROM AV0329 UNION SELECT * FROM AV0330')  
	  
	IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE NAME ='AV0313')  
	 EXEC ('CREATE VIEW AV0313 AS   
	 SELECT AV0315.*,(case when (select sum(1) from AT0303 where ObjectID=Av0315.ObjectID AND DebitBatchID = Av0315.BatchID AND DivisionID = Av0315.DivisionID  
	 GROUP BY AT0303.DebitBatchID) is NUll then 1 else (select sum(1) from AT0303 where ObjectID=Av0315.ObjectID AND DebitBatchID =Av0315.BatchID  
	 GROUP BY AT0303.DebitBatchID) end) AS CountSum, Av0315.OriginalAmountCN/(case when (select sum(1) from AT0303 where ObjectID=Av0315.ObjectID AND DebitBatchID =Av0315.BatchID  
	 GROUP BY AT0303.DebitBatchID) is NUll then 1 else (select sum(1) from AT0303 where ObjectID=Av0315.ObjectID AND DebitBatchID =Av0315.BatchID  
	 GROUP BY AT0303.DebitBatchID) end) AS OriginalSumCN, 
	 (Select Max(PaymentTermID) from AT9000 where AV0315.DivisionID = AT9000.DivisionID and AV0315.VoucherID = AT9000.VoucherID and AV0315.BatchID = AT9000.BatchID) as  PaymentTermID,
	 (Select PaymentTermName from AT1208 inner join (Select Max(DivisionID) as DivisionID, Max(PaymentTermID)as PaymentTermID from AT9000 where AV0315.DivisionID = AT9000.DivisionID and AV0315.VoucherID = AT9000.VoucherID and AV0315.BatchID = AT9000.BatchID) AT9000 on AT1208.DivisionID = AT9000.DivisionID and AT1208.PaymentTermID = AT9000.PaymentTermID) as PaymentTermName
	 From AV0315 Where AV0315.OriginalAmount <> 0 ')   
	ELSE  
	 EXEC ('ALTER VIEW AV0313 AS   
	 SELECT AV0315.*,(case when (select sum(1) from AT0303 where ObjectID=Av0315.ObjectID AND DebitBatchID = Av0315.BatchID AND DivisionID = Av0315.DivisionID  
	 GROUP BY AT0303.DebitBatchID) is NUll then 1 else (select sum(1) from AT0303 where ObjectID=Av0315.ObjectID AND DebitBatchID =Av0315.BatchID  
	 GROUP BY AT0303.DebitBatchID) end) AS CountSum, Av0315.OriginalAmountCN/(case when (select sum(1) from AT0303 where ObjectID=Av0315.ObjectID AND DebitBatchID =Av0315.BatchID  
	 GROUP BY AT0303.DebitBatchID) is NUll then 1 else (select sum(1) from AT0303 where ObjectID=Av0315.ObjectID AND DebitBatchID =Av0315.BatchID  
	 GROUP BY AT0303.DebitBatchID) end) AS OriginalSumCN ,
	 (Select  Max(PaymentTermID) from AT9000 where AV0315.DivisionID = AT9000.DivisionID and AV0315.VoucherID = AT9000.VoucherID and AV0315.BatchID = AT9000.BatchID) as  PaymentTermID,
		 (Select PaymentTermName from AT1208 inner join (Select Max(DivisionID) as DivisionID, Max(PaymentTermID)as PaymentTermID from AT9000 where AV0315.DivisionID = AT9000.DivisionID and AV0315.VoucherID = AT9000.VoucherID and AV0315.BatchID = AT9000.BatchID) AT9000 on AT1208.DivisionID = AT9000.DivisionID and AT1208.PaymentTermID = AT9000.PaymentTermID) as PaymentTermName
	 From AV0315 Where AV0315.OriginalAmount <> 0 ')  
END
ELSE

--Customize cho Sieu Thanh, xu ly toc do in bao cao
BEGIN
		SET @sTime =''  
		IF @IsDate =0   
		  Begin   
			SET @sTime ='TranMonth + 12*TranYear between '+str(@FromMonth)+' + 12*'+str(@FromYear)+'  AND  '+str(@ToMonth)+' + 12*'+str(@ToYear)+'  '  
			SET @sTime1 ='TranMonth + 12*TranYear <= '+str(@ToMonth)+' + 12*'+str(@ToYear)+'  '  
		  End  
		IF @IsDate =1  
		  Begin   
			SET @sTime ='CONVERT(DATETIME,CONVERT(varchar(10),VoucherDate,101),101)  Between '''+ convert(nvarchar(10),@FromDate,101) +''' AND '''+convert(nvarchar(10),@ToDate,101)+'''  '  
			SET @sTime1 ='CONVERT(DATETIME,CONVERT(varchar(10),VoucherDate,101),101)  <= '''+ convert(nvarchar(10),@ToDate,101)+'''  '  
		  End  
		IF  @IsDate =2  
		  Begin   
			SET @sTime ='CONVERT(DATETIME,CONVERT(varchar(10),InvoiceDate,101),101)  Between '''+ convert(nvarchar(10),@FromDate,101) +''' AND '''+convert(nvarchar(10),@ToDate,101)+'''   '  
			SET @sTime1 ='CONVERT(DATETIME,CONVERT(varchar(10),InvoiceDate,101),101)  <= '''+ convert(nvarchar(10),@ToDate,101)+'''   '  
		  End  
		----- Tao view de lay len so da giai tru den thoi gian bao cao --------------------------------------------------  
		SET @sSQL =' 
		Select 1 as DB,
		D.ObjectID + D.DebitAccountID as GroupID, D.VoucherID, D.BatchID, D.ObjectID, AT1202.ObjectName, 
		D.DebitAccountID, AT1005.AccountName As DebitAccountName,
		D.CurrencyID, D.CurrencyIDCN, D.VDescription As DebitDescription, D.BDescription As DebitCDescription, D.OriginalAmount, D.OriginalAmountCN,
		D.ConvertedAmount, (Case When C.VoucherID Is null Then 0 Else AT0303.OriginalAmount  End) As GiveUpOrAmount, (Case When C.VoucherID Is null Then 0 Else AT0303.ConvertedAmount End) As GiveUpCoAmount,
		D.VoucherNo As DebitVoucherNo, D.VoucherDate As DebitVoucherDate, D.Serial As DebitSerial, D.InvoiceDate As DebitInvoiceDate, D.InvoiceNo As DebitInvoiceNo, D.DueDate As DebitDueDate,
		C.VDescription As CreditDescription, C.BDescription As CreditCDescription, C.Serial As CreditSerial, C.VoucherNo As CreditVoucherNo, C.VoucherDate As CreditVoucherDate, C.InvoiceDate As CreditInvoiceDate,
		C.InvoiceNo As CreditInvoiceNo, C.VoucherTypeID As CreditVoucherTypeID, D.VoucherTypeID As DebitVoucherTypeID,
		D.Ana01ID, A01.AnaName As AnaName01, D.Ana02ID, A02.AnaName As AnaName02, D.Ana03ID, A03.AnaName As AnaName03, D.Ana04ID, A04.AnaName As AnaName04, D.Ana05ID, A05.AnaName As AnaName05,
		D.Ana06ID, A06.AnaName As AnaName06, D.Ana07ID, A07.AnaName As AnaName07, D.Ana08ID, A08.AnaName As AnaName08, D.Ana09ID, A09.AnaName As AnaName09, D.Ana10ID, A10.AnaName As AnaName10,
		D.Parameter01, D.Parameter02, D.Parameter03, D.Parameter04, D.Parameter05, 
		D.Parameter06, D.Parameter07, D.Parameter08, D.Parameter09, D.Parameter10,
		D.OrderID, OT2001.OrderDate, OT2001.ClassifyID, 
		'''+convert(nvarchar(10),@FromDate,103)+''' AS Fromdate,  
		(case when'+str(@IsDate)+'= 0 then    ''30/'+Ltrim (str(@ToMonth))+'/'+ltrim(str(@ToYear))+'''  else   '''+convert(nvarchar(10),@ToDate,103)+''' end ) AS Todate,  
		AT1202.O01ID, AT1202.O02ID, AT1202.O03ID, AT1202.O04ID, AT1202.O05ID, T01.AnaName As O01Name, T02.AnaName As O02Name, T03.AnaName As O03Name, T04.AnaName As O04Name, T05.AnaName As O05Name,
		0 As IsToltal, D.DivisionID, 1 As CountSum, AT03.GivedOriginalAmount As OriginalSumCN, 
		AT03.GivedOriginalAmount As SumGivedOriginalAmount ,AT03.GivedConvertedAmount As SumGivedConvertedAmount 
		From 
		(Select DivisionID,DebitAccountID,ObjectID,TableID,VoucherTypeID,CurrencyID,CurrencyIDCN,VoucherID,BatchID,
		VoucherNo,VoucherDate,Max(VDescription) As VDescription, Max(BDescription) As BDescription, 
		Sum(isnull(OriginalAmount,0)) As OriginalAmount, Sum(isnull(OriginalAmountCN,0)) As OriginalAmountCN, Sum(isnull(ConvertedAmount,0)) As ConvertedAmount, 
		Max(Serial) As Serial, Max(InvoiceDate) As InvoiceDate, Max(InvoiceNo) As InvoiceNo, Max(DueDate) As DueDate,
		Max(Ana01ID) As Ana01ID, Max(Ana02ID) As Ana02ID, Max(Ana03ID) As Ana03ID, Max(Ana04ID) As Ana04ID, Max(Ana05ID) As Ana05ID, 
		Max(Ana06ID) As Ana06ID, Max(Ana07ID) As Ana07ID, Max(Ana08ID) As Ana08ID, Max(Ana09ID) As Ana09ID, Max(Ana10ID) As Ana10ID, 
		Max(Parameter01) As Parameter01, Max(Parameter02) As Parameter02, Max(Parameter03) As Parameter03, Max(Parameter04) As Parameter04, Max(Parameter05) As Parameter05, 
		Max(Parameter06) As Parameter06, Max(Parameter07) As Parameter07, Max(Parameter08) As Parameter08, Max(Parameter09) As Parameter09, Max(Parameter10) As Parameter10,
		Max(OrderID) As OrderID, Max(Status) As Status
		From AT9000 Where 
			DivisionID = ''' + @DivisionID + ''' AND     
			(ObjectID Between ''' + @FromObjectID + ''' AND ''' + @ToObjectID + ''') AND    
			CurrencyIDCN like ''' + @CurrencyID + ''' AND    
			DebitAccountID >= ''' + @FromAccountID + ''' AND DebitAccountID<= ''' + @ToAccountID + ''' AND ' + @sTime1
		SET @sSQL1 = '
		Group By DivisionID,DebitAccountID,ObjectID,TableID,VoucherTypeID,CurrencyID,CurrencyIDCN,VoucherID,BatchID,VoucherNo,VoucherDate) D
		LEFT JOIN AT1202
			ON D.DivisionID = AT1202.DivisionID And D.ObjectID = AT1202.ObjectID
		INNER JOIN AT1005 
			ON D.DivisionID = AT1005.DivisionID And D.DebitAccountID = AT1005.AccountID And AT1005.GroupID = ''G03'' And AT1005.IsObject = 1
		LEFT JOIN OT2001
			ON D.DivisionID = OT2001.DivisionID And D.OrderID = OT2001.SOrderID 
		LEFT JOIN AT1011 A01 
			ON A01.AnaID = D.Ana01ID AND A01.AnaTypeID =''A01'' AND A01.DivisionID = D.DivisionID    
		LEFT JOIN AT1011 A02 
			ON A02.AnaID = D.Ana02ID AND A02.AnaTypeID =''A02'' AND A02.DivisionID = D.DivisionID    
		LEFT JOIN AT1011 A03 
			ON A03.AnaID = D.Ana03ID AND A03.AnaTypeID =''A03'' AND A03.DivisionID = D.DivisionID    
		LEFT JOIN AT1011 A04 
			ON A04.AnaID = D.Ana04ID AND A04.AnaTypeID =''A04'' AND A04.DivisionID = D.DivisionID    
		LEFT JOIN AT1011 A05 
			ON A05.AnaID = D.Ana05ID AND A05.AnaTypeID =''A05'' AND A05.DivisionID = D.DivisionID    
		LEFT JOIN AT1011 A06 
			ON A06.AnaID = D.Ana06ID AND A06.AnaTypeID =''A06'' AND A06.DivisionID = D.DivisionID    
		LEFT JOIN AT1011 A07 
			ON A07.AnaID = D.Ana07ID AND A07.AnaTypeID =''A07'' AND A07.DivisionID = D.DivisionID    
		LEFT JOIN AT1011 A08 
			ON A08.AnaID = D.Ana08ID AND A08.AnaTypeID =''A08'' AND A08.DivisionID = D.DivisionID    
		LEFT JOIN AT1011 A09 
			ON A09.AnaID = D.Ana09ID AND A09.AnaTypeID =''A09'' AND A09.DivisionID = D.DivisionID    
		LEFT JOIN AT1011 A10 
			ON A10.AnaID = D.Ana10ID AND A10.AnaTypeID =''A10'' AND A10.DivisionID = D.DivisionID 
		LEFT JOIN AT1015  T01 
			ON T01.DivisionID = AT1202.DivisionID and T01.AnaID =  AT1202.O01ID AND T01.AnaTypeID = ''O01''     
		LEFT JOIN AT1015  T02 
			ON T02.DivisionID = AT1202.DivisionID and T02.AnaID =  AT1202.O02ID AND T02.AnaTypeID = ''O02''    
		LEFT JOIN AT1015  T03 
			ON T03.DivisionID = AT1202.DivisionID and T03.AnaID =  AT1202.O03ID AND T03.AnaTypeID = ''O03''    
		LEFT JOIN AT1015  T04 
			ON T04.DivisionID = AT1202.DivisionID and T04.AnaID =  AT1202.O04ID AND T04.AnaTypeID = ''O04''    
		LEFT JOIN AT1015  T05 
			ON T05.DivisionID = AT1202.DivisionID and T05.AnaID =  AT1202.O05ID AND T05.AnaTypeID = ''O05''    
		'
		SET @sSQL2 = '	
		LEFT JOIN AT0303
		ON	D.DivisionID = AT0303.DivisionID And   
			D.ObjectID = AT0303.ObjectID And   
			D.CurrencyIDCN = AT0303.CurrencyID And  
			D.VoucherID = AT0303.DebitVoucherID And  
			D.BatchID = AT0303.DebitBatchID And  
			D.TableID = AT0303.DebitTableID And
			D.DebitAccountID = AT0303.AccountID
		LEFT JOIN 
		(Select DivisionID,CreditAccountID,(Case When TransactionTypeID = ''T99'' Then CreditObjectID Else ObjectID End) As ObjectID,TableID,VoucherTypeID,CurrencyID,CurrencyIDCN,VoucherID,BatchID,
			VoucherNo,VoucherDate,Max(VDescription) As VDescription, Max(BDescription) As BDescription, 
			Sum(isnull(OriginalAmount,0)) As OriginalAmount, Sum(isnull(OriginalAmountCN,0)) As OriginalAmountCN, Sum(isnull(ConvertedAmount,0)) As ConvertedAmount,
			Max(Serial) As Serial, Max(InvoiceDate) As InvoiceDate, Max(InvoiceNo) As InvoiceNo 
			From AT9000 
			Where 
			DivisionID = ''' + @DivisionID + ''' AND 
			((Case When TransactionTypeID = ''T99'' Then CreditObjectID Else ObjectID End) Between ''' + @FromObjectID + ''' AND ''' + @ToObjectID + ''') AND 
			CurrencyIDCN like ''' + @CurrencyID + ''' AND    
			CreditAccountID >= ''' + @FromAccountID + ''' AND CreditAccountID<= ''' + @ToAccountID + ''' AND ' + @sTime1 + ' 
			Group By DivisionID,CreditAccountID,(Case When TransactionTypeID = ''T99'' Then CreditObjectID Else ObjectID End),TableID,VoucherTypeID,CurrencyID,CurrencyIDCN,VoucherID,BatchID,VoucherNo,VoucherDate) C
			ON	C.DivisionID = AT0303.DivisionID And
				C.ObjectID = AT0303.ObjectID And   
				C.CurrencyIDCN = AT0303.CurrencyID And  
				C.VoucherID = AT0303.CreditVoucherID And  
				C.BatchID = AT0303.CreditBatchID And  
				C.TableID = AT0303.CreditTableID And
				C.CreditAccountID = AT0303.AccountID
		LEFT JOIN 
			(SELECT B.DivisionID,B.AccountID,B.ObjectID,B.DebitTableID,B.CurrencyID,B.DebitVoucherID,B.DebitBatchID,
					Sum(isnull(B.OriginalAmount,0)) As GivedOriginalAmount,Sum(isnull(B.ConvertedAmount,0)) As GivedConvertedAmount FROM
					(Select DivisionID,CreditAccountID,(Case When TransactionTypeID = ''T99'' Then CreditObjectID Else ObjectID End) As ObjectID,TableID,CurrencyIDCN,VoucherID,BatchID
					From AT9000 
					Where 
					DivisionID = ''' + @DivisionID + ''' AND 
					((Case When TransactionTypeID = ''T99'' Then CreditObjectID Else ObjectID End) Between ''' + @FromObjectID + ''' AND ''' + @ToObjectID + ''') AND 
					CurrencyIDCN like ''' + @CurrencyID + ''' AND    
					CreditAccountID >= ''' + @FromAccountID + ''' AND CreditAccountID<= ''' + @ToAccountID + ''' AND ' + @sTime1 + ' 
					Group By DivisionID,CreditAccountID,(Case When TransactionTypeID = ''T99'' Then CreditObjectID Else ObjectID End),TableID,CurrencyIDCN,VoucherID,BatchID) A
					INNER JOIN AT0303 B
					ON	A.DivisionID = B.DivisionID And
						A.ObjectID = B.ObjectID And   
						A.CurrencyIDCN = B.CurrencyID And  
						A.VoucherID = B.CreditVoucherID And  
						A.BatchID = B.CreditBatchID And  
						A.TableID = B.CreditTableID And
						A.CreditAccountID = B.AccountID	
					GROUP BY B.DivisionID,B.AccountID,B.ObjectID,B.DebitTableID,B.CurrencyID,B.DebitVoucherID,B.DebitBatchID		
			) AT03	
			ON	D.DivisionID = AT03.DivisionID And   
				D.ObjectID = AT03.ObjectID And   
				D.CurrencyIDCN = AT03.CurrencyID And  
				D.VoucherID = AT03.DebitVoucherID And  
				D.BatchID = AT03.DebitBatchID And  
				D.TableID = AT03.DebitTableID And
				D.DebitAccountID = AT03.AccountID		
		WHERE 0=0	
		'
		--print @sSQL  
		IF @IsZero = 1  --khong hien thi hoa don da giai tru het  
			SET @sSQL2 = @sSQL2 +' AND (D.OriginalAmountCN - isnull(AT03.GivedOriginalAmount,0))<>0'  
		IF @IsNotGiveUp = 1 --khong hien thi hoa don chua giai tru   
			SET @sSQL2 = @sSQL2 +' AND ( D.Status <>0 ) '  
			
		 IF Isnull(@DatabaseName,'') <>'' 
			BEGIN
				EXEC AP0313_ST  @DivisionID,@FromObjectID,@ToObjectID,@FromAccountID,@ToAccountID,@CurrencyID,@IsDate,@FromDate,@ToDate,@FromMonth,@FromYear,@ToMonth,@ToYear,@IsZero,@IsNotGiveUp,@DatabaseName  
				SET @sSQLUnionAll ='
					UNION ALL
					SELECT  2 as DB, GroupID,VoucherID,BatchID,ObjectID,ObjectName,DebitAccountID,DebitAccountName,CurrencyID,CurrencyIDCN,DebitDescription, 
					DebitCDescription,OriginalAmount,OriginalAmountCN,ConvertedAmount,GiveUpOrAmount,GiveUpCoAmount,DebitVoucherNo,DebitVoucherDate,
					DebitSerial,DebitInvoiceDate,DebitInvoiceNo,DebitDueDate,CreditDescription,CreditCDescription,CreditSerial,CreditVoucherNo,
					CreditVoucherDate,CreditInvoiceDate,CreditInvoiceNo,CreditVoucherTypeID,DebitVoucherTypeID,
					Ana01ID,AnaName01,Ana02ID,AnaName02,Ana03ID,AnaName03,Ana04ID,AnaName04,Ana05ID,AnaName05,
					Ana06ID,AnaName06,Ana07ID,AnaName07,Ana08ID,AnaName08,Ana09ID,AnaName09,Ana10ID,AnaName10,
					Parameter01,Parameter02,Parameter03,Parameter04,Parameter05, 
					Parameter06,Parameter07,Parameter08,Parameter09,Parameter10,
					OrderID,OrderDate,ClassifyID,Fromdate,Todate,  
					O01ID,O02ID,O03ID,O04ID,O05ID,O01Name,O02Name,O03Name,O04Name,O05Name,
					IsToltal,DivisionID,CountSum,OriginalSumCN, 
					SumGivedOriginalAmount ,SumGivedConvertedAmount 
					From AV0313_ST
					'
			END
		 ELSE
			SET @sSQLUnionAll =''
		 
		 --Print @sSQL
		 --Print @sSQL1
		 --Print @sSQL2
		 
	IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE NAME ='AV0313')  
		EXEC ('CREATE VIEW AV0313 --Create By AP0313 Customize Sieu Thanh
		AS ' + @sSQL + @sSQL1 + @sSQL2 + @sSQLUnionAll )   
	ELSE  
		EXEC ('ALTER VIEW AV0313 --Create By AP0313 Customize Sieu Thanh
		AS ' + @sSQL + @sSQL1 + @sSQL2 + @sSQLUnionAll)
END


IF (Select CustomerName From @AP4444) = 22 --- Dacin
BEGIN
	Declare @ContractAnaTypeID as nvarchar(50)
	
	IF @IsDate =0   
	 SET @sTime ='(T90.TranMonth + 100*T90.TranYear between '+str(@FromMonth)+' + 100*'+str(@FromYear)+'  AND  '+str(@ToMonth)+' + 100*'+str(@ToYear)+') '  
	IF @IsDate =1  
	 SET @sTime ='(CONVERT(DATETIME,CONVERT(varchar(10),T90.VoucherDate,101),101)  BETWEEN '''+ convert(nvarchar(10),@FromDate,101) +''' AND '''+convert(nvarchar(10),@ToDate,101)+''') '  
	IF  @IsDate =2  
	 SET @sTime ='(CONVERT(DATETIME,CONVERT(varchar(10),T90.InvoiceDate,101),101)  BETWEEN '''+ convert(nvarchar(10),@FromDate,101) +''' AND '''+convert(nvarchar(10),@ToDate,101)+''') '
	 
	SET @ContractAnaTypeID = ISNULL((SELECT TOP 1 SalesContractAnaTypeID FROM AT0000 WHERE DefDivisionID = @DivisionID), 'A03')

	SET @sSQL = 'SELECT T90.ObjectID, AT1202.ObjectName, getdate() as PrintDate, T20.ContractID,
				(CASE	WHEN ''' + @ContractAnaTypeID + ''' = ''A01'' THEN T90.Ana01ID
						WHEN ''' + @ContractAnaTypeID + ''' = ''A02'' THEN T90.Ana02ID
						WHEN ''' + @ContractAnaTypeID + ''' = ''A03'' THEN T90.Ana03ID
						WHEN ''' + @ContractAnaTypeID + ''' = ''A04'' THEN T90.Ana04ID
						WHEN ''' + @ContractAnaTypeID + ''' = ''A05'' THEN T90.Ana05ID
						WHEN ''' + @ContractAnaTypeID + ''' = ''A06'' THEN T90.Ana06ID
						WHEN ''' + @ContractAnaTypeID + ''' = ''A07'' THEN T90.Ana07ID
						WHEN ''' + @ContractAnaTypeID + ''' = ''A08'' THEN T90.Ana08ID
						WHEN ''' + @ContractAnaTypeID + ''' = ''A09'' THEN T90.Ana09ID
						WHEN ''' + @ContractAnaTypeID + ''' = ''A10'' THEN T90.Ana10ID
				END) as ContractNo, T20.Amount as ContractAmount,
				T21.StepID, T21.PaymentPercent, T21.PaymentAmount, T21.PaymentDate,
				(Select sum(ConvertedAmount) From AT9000 Where DivisionID = ''' + @DivisionID + '''
				And Isnull(ContractDetailID,'''') = T21.ContractDetailID) as Paymented,
				
				(Isnull(T21.PaymentAmount,0) - Isnull((Select sum(ConvertedAmount) From AT9000 Where DivisionID = ''' + @DivisionID + '''
													And Isnull(ContractDetailID,'''') = T21.ContractDetailID),0)) as RemainAmount,
				
				datediff(day,Isnull(T21.PaymentDate,getdate()),getdate()) as OverDays
	
				FROM AT9000 T90
				LEFT JOIN AT1202 On T90.DivisionID = AT1202.DivisionID And T90.ObjectID = AT1202.ObjectID '
				
	IF @ContractAnaTypeID = 'A01'
			Set @sSQL =	@sSQL +	'INNER JOIN AT1020 T20 On T90.DivisionID = T20.DivisionID And T90.Ana01ID = T20.ContractNo '
	IF @ContractAnaTypeID = 'A02'			
			Set @sSQL =	@sSQL +	'INNER JOIN AT1020 T20 On T90.DivisionID = T20.DivisionID And T90.Ana02ID = T20.ContractNo '
	IF @ContractAnaTypeID = 'A03'			
			Set @sSQL =	@sSQL +	'INNER JOIN AT1020 T20 On T90.DivisionID = T20.DivisionID And T90.Ana03ID = T20.ContractNo '
	IF @ContractAnaTypeID = 'A04'			
			Set @sSQL =	@sSQL +	'INNER JOIN AT1020 T20 On T90.DivisionID = T20.DivisionID And T90.Ana04ID = T20.ContractNo '
	IF @ContractAnaTypeID = 'A05'			
			Set @sSQL =	@sSQL +	'INNER JOIN AT1020 T20 On T90.DivisionID = T20.DivisionID And T90.Ana05ID = T20.ContractNo '
	IF @ContractAnaTypeID = 'A06'			
			Set @sSQL =	@sSQL +	'INNER JOIN AT1020 T20 On T90.DivisionID = T20.DivisionID And T90.Ana06ID = T20.ContractNo '
	IF @ContractAnaTypeID = 'A07'
			Set @sSQL =	@sSQL +	'INNER JOIN AT1020 T20 On T90.DivisionID = T20.DivisionID And T90.Ana07ID = T20.ContractNo '
	IF @ContractAnaTypeID = 'A08'
			Set @sSQL =	@sSQL +	'INNER JOIN AT1020 T20 On T90.DivisionID = T20.DivisionID And T90.Ana08ID = T20.ContractNo '
	IF @ContractAnaTypeID = 'A09'
			Set @sSQL =	@sSQL +	'INNER JOIN AT1020 T20 On T90.DivisionID = T20.DivisionID And T90.Ana09ID = T20.ContractNo '
	IF @ContractAnaTypeID = 'A10'
			Set @sSQL =	@sSQL +	'INNER JOIN AT1020 T20 On T90.DivisionID = T20.DivisionID And T90.Ana10ID = T20.ContractNo '
								
	Set @sSQL =	@sSQL +	'INNER JOIN AT1021 T21 On T20.DivisionID = T21.DivisionID And T20.ContractID = T21.ContractID						
				WHERE	T90.DivisionID = ''' + @DivisionID + ''' AND
						(T90.DebitAccountID between ''' + @FromAccountID + ''' AND ''' + @ToAccountID + ''') AND					  
						(T90.ObjectID between ''' + @FromObjectID + ''' AND ''' + @ToObjectID + ''') and  
						T90.CurrencyIDCN like ''' + @CurrencyID + ''' AND ' + @sTime + '
				ORDER BY T90.ObjectID, (CASE	WHEN ''' + @ContractAnaTypeID + ''' = ''A01'' THEN T90.Ana01ID
												WHEN ''' + @ContractAnaTypeID + ''' = ''A02'' THEN T90.Ana02ID
												WHEN ''' + @ContractAnaTypeID + ''' = ''A03'' THEN T90.Ana03ID
												WHEN ''' + @ContractAnaTypeID + ''' = ''A04'' THEN T90.Ana04ID
												WHEN ''' + @ContractAnaTypeID + ''' = ''A05'' THEN T90.Ana05ID
												WHEN ''' + @ContractAnaTypeID + ''' = ''A06'' THEN T90.Ana06ID
												WHEN ''' + @ContractAnaTypeID + ''' = ''A07'' THEN T90.Ana07ID
												WHEN ''' + @ContractAnaTypeID + ''' = ''A08'' THEN T90.Ana08ID
												WHEN ''' + @ContractAnaTypeID + ''' = ''A09'' THEN T90.Ana09ID
												WHEN ''' + @ContractAnaTypeID + ''' = ''A10'' THEN T90.Ana10ID
										END), T21.StepID'
	---print @sSQL
	EXEC(@sSQL)
END



-----05/03/2014--------Customize Report AR0324 theo doi cong no phai thu cho KingCom
IF (Select CustomerName From @AP4444) = 25  AND  @ReportCode = 'AR0324' --- KingCOm
	BEGIN
		SET @sSQL1='
		----Sinh boi AP0313 muc dich lay du lieu len report Customize cua KingCom ----
		----Khach hang khong muon hien thi nhung chung tu lien quan den Phieu Tong Hop - VoucherTypeID="TH" ----
		
		Select T00.*, T03.*,Case When Year(T00.DueDate)= 1900 then  Null else DATEDIFF(DAY, T00.DueDate, GETDATE()) End AS Days
		,(T00.OriginalAmount - (Select SUM(OriginalAmount) from AT0303 T3 Where T3.DebitVoucherID=T03.DebitVoucherID And T3.DebitBatchID=T03.DebitBatchID)) as RemainOriginalAmount
		,(T00.ConvertedAmount - (Select SUM(ConvertedAmount) from AT0303 T3 Where T3.DebitVoucherID=T03.DebitVoucherID And T3.DebitBatchID=T03.DebitBatchID)) as RemainConvertedAmount
		FROM (SELECT distinct
		T3.DebitVoucherID, T3.CreditVoucherID,T3.DebitBatchID, T3.CreditBatchID,T3.DebitVoucherDate,T3.CreditVoucherDate,T3.OriginalAmount as DebitOriginalAmount,T3.ConvertedAmount as DebitConvertedAmount
		,T90.DebitBankAccountID,T90.CreditBankAccountID,AT1016_Debit.BankName AS DebitBankName,AT1016_Credit.BankName AS CreditBankName,T90.VoucherTypeID as DebitVoucherTypeID,T90.VoucherNo as DebitVoucherNo--,
		--case When T90.VoucherTypeID = ''TH'' then T90.ObjectID  Else '''' end as  DebitObjectID , 
		--case When T90.VoucherTypeID = ''TH'' then ObjectName Else '''' end as  DebitObjectName 
		-----,isnull(T02.O01ID,'''') as O01ID, isnull(T02.O02ID,'''') as O02ID, isnull(T02.O03ID,'''') as O03ID, isnull(T02.O04ID,'''') as O04ID, isnull(T02.O05ID,'''') as O05ID
		from AT0303 T3
		Left JOIN AT9000 T90 ON T3.CreditVoucherID=T90.VoucherID AND T3.CreditBatchID=T90.BatchID
		left join AT1202 T02 on T02.ObjectID = T90.ObjectID
		Left join AT1016 AT1016_Debit on AT1016_Debit.BankAccountID=T90.DebitBankAccountID
		Left join AT1016 AT1016_Credit on AT1016_Credit.BankAccountID=T90.CreditBankAccountID
		) AS T03
		inner join (
		Select
		AV0311.DivisionID,AV0311.ObjectID,Max(AV0311.ObjectName) as ObjectName,DebitAccountID AS AccountID,VoucherTypeID,AV0311.CurrencyID,VoucherID,BatchID,Sum(ConvertedAmount) as ConvertedAmount,
		Sum(OriginalAmount) as OriginalAmount,Sum(OriginalAmountCN) as OriginalAmountCN,CurrencyIDCN,
		ExchangeRate,TranMonth ,TranYear,VoucherNo, VoucherDate, Max(Serial) as Serial,Max(InvoiceNo) as InvoiceNo,Max(InvoiceDate) as InvoiceDate,
		Max(ISNULL(DueDate,Null)) as DueDate, MAX(AV0311.PaymentTermID) AS PaymentTermID,MAX(AT1208.PaymentTermName) as PaymentTermName,Max([Description]) as [Description],Max(VDescription) as VDescription,Max(Ana01ID) as Ana01ID,Max(Ana02ID) as Ana02ID,
		Max(Ana03ID) as Ana03ID,Max(Ana04ID) as Ana04ID,Max(Ana05ID) as Ana05ID,Max(AnaName01) as AnaName01,Max(AnaName02) as AnaName02,
		Max(AnaName03) as AnaName03,Max(AnaName04) as AnaName04,Max(AnaName05) as AnaName05,	
		MAX(Isnull(OrderDate,Null)) AS OrderDate,MAX(SOrderNo) AS SOrderNo, MAX(AV0311.SalesMan) as OAna01Name
		from AV0311
		left join AT1208 on AT1208.PaymentTermID=AV0311.PaymentTermID
		left join AT1103 T15 on AV0311.SalesManID = T15.EmployeeID
		Group by AV0311.DivisionID,AV0311.ObjectID,DebitAccountID,VoucherTypeID,AV0311.CurrencyID,VoucherID,BatchID,CurrencyIDCN,
		ExchangeRate,TranMonth ,TranYear,VoucherNo,VoucherDate) as T00
		on T00.VoucherID = T03.DebitVoucherID And T00.BatchID = T03.DebitBatchID	
		Where T00.DivisionID ='''+@DivisionID+''' and 	
		T00.ObjectID Between '''+@FromObjectID+''' and '''+@ToObjectID+''' and
		T00.CurrencyIDCN like '''+@CurrencyID+''' and Left(VoucherNo,2) <>''TH'' and 
		(T00.AccountID >= '''+@FromAccountID+''' AND  T00.AccountID<= '''+@ToAccountID+''')  and '+REPLACE(@sTime1,'T9','T00')+' '
		
	
		IF @IsNotGiveUp = 0 -- hien thi hoa don chua giai tru 
			SET @sSQL2 = '
			Union All Select
			AV0311.DivisionID,AV0311.ObjectID,Max(AV0311.ObjectName) as ObjectName,DebitAccountID AS AccountID,VoucherTypeID,AV0311.CurrencyID,VoucherID,BatchID,Sum(ConvertedAmount) as ConvertedAmount,
			Sum(OriginalAmount) as OriginalAmount,Sum(OriginalAmountCN) as OriginalAmountCN,CurrencyIDCN,
			ExchangeRate,TranMonth ,TranYear,VoucherNo, VoucherDate, Max(Serial) as Serial,Max(InvoiceNo) as InvoiceNo,Max(InvoiceDate) as InvoiceDate,
			Max(ISNULL(DueDate,Null)) as DueDate, MAX(AV0311.PaymentTermID) AS PaymentTermID,MAX(AT1208.PaymentTermName) as PaymentTermName,Max([Description]) as [Description],Max(VDescription) as VDescription,Max(Ana01ID) as Ana01ID,Max(Ana02ID) as Ana02ID,
			Max(Ana03ID) as Ana03ID,Max(Ana04ID) as Ana04ID,Max(Ana05ID) as Ana05ID,Max(AnaName01) as AnaName01,Max(AnaName02) as AnaName02,
			Max(AnaName03) as AnaName03,Max(AnaName04) as AnaName04,Max(AnaName05) as AnaName05,	
			MAX(Isnull(OrderDate,Null)) AS OrderDate,MAX(SOrderNo) AS SOrderNo,MAX(AV0311.SalesMan) as OAna01Name,NULL AS DebitVoucherID,NULL AS CreditVoucherID,NULL AS DebitBatchID,NULL AS CreditBatchID,NULL AS DebitVoucherDate,NULL AS CreditVoucherDate,0 AS DebitOriginalAmount,
			0 AS DebitConvertedAmount, NULL AS DebitBankAccountID,NULL AS CreditBankAccountID,NULL AS DebitBankName,NULL AS CreditBankName,NULL AS DebitVoucherTypeID, NULL AS DebitVoucherNo,
			--Null as  DebitObjectID , 
			--Null as  DebitObjectName ,
		-------	NULL AS O01ID,NULL AS O02ID ,NULL AS O03ID,NULL AS O04ID,NULL AS O05ID,
			Case When Year(Max(ISNULL(DueDate,Null)))= 1900 then  Null else DATEDIFF(DAY, Max(ISNULL(DueDate,Null)), GETDATE()) End	as  Days,
			---0 as  Days,
			Sum(OriginalAmount) as RemainOriginalAmount,Sum(ConvertedAmount) as RemainConvertedAmount
			from AV0311
			left join AT1208 on AT1208.PaymentTermID=AV0311.PaymentTermID
			left join AT1103 T15 on AV0311.SalesManID = T15.EmployeeID
			WHERE 	VoucherID+BATCHID NOT IN (SELECT DebitVoucherID+DebitBatchID FROM AT0303)
			And AV0311.DivisionID ='''+@DivisionID+''' and 	
			AV0311.ObjectID Between '''+@FromObjectID+''' and '''+@ToObjectID+''' and
			AV0311.CurrencyIDCN like '''+@CurrencyID+''' and Left(VoucherNo,2) <>''TH'' and 
			(AV0311.DebitAccountID >= '''+@FromAccountID+''' AND  AV0311.DebitAccountID <= '''+@ToAccountID+''') and '+REPLACE(@sTime1,'T9.','')+'
			Group by AV0311.DivisionID,AV0311.ObjectID,DebitAccountID,VoucherTypeID,AV0311.CurrencyID,VoucherID,BatchID,CurrencyIDCN,
			ExchangeRate,TranMonth ,TranYear,VoucherNo,VoucherDate
			'
		ELSE
			SET @sSQL2 = ''
			
		--Print @sSQL1
		--Print @sSQL2

		EXEC(@sSQL1 + @sSQL2)
	END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
