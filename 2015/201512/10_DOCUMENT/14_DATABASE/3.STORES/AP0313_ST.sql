IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0313_ST]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0313_ST]
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
---- Modified on 17/11/2014 by Mai Duyen: Bo sung @DatabaseName de in bao cao 2 database (Customized SIEUTHANH )
--- <Example>
---- AP0313_ST 'AS','0000000001','0000000001','1311','1311','VND',0,'05/01/2012','05/31/2012',5,2012,5,2012,0,0,AR0313
-----exec AP0313 @DivisionID=N'KC',@FromObjectID=N'0000000012',@ToObjectID=N'0000000012',@FromAccountID=N'1311',@ToAccountID=N'337',@CurrencyID=N'VND',@IsDate=0,@FromDate='2014-03-05 13:14:03.047',@ToDate='2014-03-05 13:14:03.047',@FromMonth=12,@FromYear=2013,@ToMonth=1,@ToYear=2014,@IsZero=1,@IsNotGiveUp=0,@DatabaseName=N''

CREATE PROCEDURE [dbo].[AP0313_ST]    
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
    @DatabaseName  as NVARCHAR(250)=''
 AS  
DECLARE 
  @sSQL AS nvarchar(4000),
  @sSQL1 AS nvarchar(4000),  
  @sSQL2 AS nvarchar(4000),  
  @sSQLGroup AS nvarchar(4000),  
  @sTime AS nvarchar(4000),  
  @sTime1 AS nvarchar(4000), --- Phan Union ALL  
  @sTime2 AS  nvarchar(4000) ,  --- Phuc vu lay view nhung phan giai tru den thoi gian ToMonth, ToDate - Ap dung cho PS No  
  @sTime3 AS  nvarchar(4000) ,  --- Phuc vu lay view nhung phan giai tru den thoi gian ToMonth, ToDate - Ap dung cho PS Co  
  @TableDBO as nvarchar(250)

If @DatabaseName  ='' 
	 Set @TableDBO=''
Else
	Set @TableDBO = '[' +  @DatabaseName + '].DBO.'
	

--Add by Dang Le Bao Quynh; Date 03/05/2013  
--Purpose: Kiem tra customize cho Sieu Thanh  
--Declare @AP4444 Table(CustomerName Int, Export Int)  
--Insert Into @AP4444(CustomerName,Export) EXEC('AP4444')  
--If (Select CustomerName From @AP4444)<>16
--BEGIN  
	
--END
--ELSE
--Customize cho Sieu Thanh, xu ly toc do in bao cao

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
	Select 
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
	From ' + @TableDBO + 'AT9000 AT9000 Where 
		DivisionID = ''' + @DivisionID + ''' AND     
		(ObjectID Between ''' + @FromObjectID + ''' AND ''' + @ToObjectID + ''') AND    
		CurrencyIDCN like ''' + @CurrencyID + ''' AND    
		DebitAccountID >= ''' + @FromAccountID + ''' AND DebitAccountID<= ''' + @ToAccountID + ''' AND ' + @sTime1
	SET @sSQL1 = '
	Group By DivisionID,DebitAccountID,ObjectID,TableID,VoucherTypeID,CurrencyID,CurrencyIDCN,VoucherID,BatchID,VoucherNo,VoucherDate) D
	LEFT JOIN ' + @TableDBO + 'AT1202  AT1202
		ON D.DivisionID = AT1202.DivisionID And D.ObjectID = AT1202.ObjectID
	INNER JOIN ' + @TableDBO + 'AT1005  AT1005 
		ON D.DivisionID = AT1005.DivisionID And D.DebitAccountID = AT1005.AccountID And AT1005.GroupID = ''G03'' And AT1005.IsObject = 1
	LEFT JOIN ' + @TableDBO + 'OT2001  OT2001
		ON D.DivisionID = OT2001.DivisionID And D.OrderID = OT2001.SOrderID 
	LEFT JOIN ' + @TableDBO + 'AT1011 A01 
		ON A01.AnaID = D.Ana01ID AND A01.AnaTypeID =''A01'' AND A01.DivisionID = D.DivisionID    
	LEFT JOIN ' + @TableDBO + 'AT1011 A02 
		ON A02.AnaID = D.Ana02ID AND A02.AnaTypeID =''A02'' AND A02.DivisionID = D.DivisionID    
	LEFT JOIN ' + @TableDBO + 'AT1011 A03 
		ON A03.AnaID = D.Ana03ID AND A03.AnaTypeID =''A03'' AND A03.DivisionID = D.DivisionID    
	LEFT JOIN ' + @TableDBO + 'AT1011 A04 
		ON A04.AnaID = D.Ana04ID AND A04.AnaTypeID =''A04'' AND A04.DivisionID = D.DivisionID    
	LEFT JOIN ' + @TableDBO + 'AT1011 A05 
		ON A05.AnaID = D.Ana05ID AND A05.AnaTypeID =''A05'' AND A05.DivisionID = D.DivisionID    
	LEFT JOIN ' + @TableDBO + 'AT1011 A06 
		ON A06.AnaID = D.Ana06ID AND A06.AnaTypeID =''A06'' AND A06.DivisionID = D.DivisionID    
	LEFT JOIN ' + @TableDBO + 'AT1011 A07 
		ON A07.AnaID = D.Ana07ID AND A07.AnaTypeID =''A07'' AND A07.DivisionID = D.DivisionID    
	LEFT JOIN ' + @TableDBO + 'AT1011 A08 
		ON A08.AnaID = D.Ana08ID AND A08.AnaTypeID =''A08'' AND A08.DivisionID = D.DivisionID    
	LEFT JOIN ' + @TableDBO + 'AT1011 A09 
		ON A09.AnaID = D.Ana09ID AND A09.AnaTypeID =''A09'' AND A09.DivisionID = D.DivisionID    
	LEFT JOIN ' + @TableDBO + 'AT1011 A10 
		ON A10.AnaID = D.Ana10ID AND A10.AnaTypeID =''A10'' AND A10.DivisionID = D.DivisionID 
	LEFT JOIN ' + @TableDBO + 'AT1015  T01 
		ON T01.DivisionID = AT1202.DivisionID and T01.AnaID =  AT1202.O01ID AND T01.AnaTypeID = ''O01''     
	LEFT JOIN ' + @TableDBO + 'AT1015  T02 
		ON T02.DivisionID = AT1202.DivisionID and T02.AnaID =  AT1202.O02ID AND T02.AnaTypeID = ''O02''    
	LEFT JOIN ' + @TableDBO + 'AT1015  T03 
		ON T03.DivisionID = AT1202.DivisionID and T03.AnaID =  AT1202.O03ID AND T03.AnaTypeID = ''O03''    
	LEFT JOIN ' + @TableDBO + 'AT1015  T04 
		ON T04.DivisionID = AT1202.DivisionID and T04.AnaID =  AT1202.O04ID AND T04.AnaTypeID = ''O04''    
	LEFT JOIN ' + @TableDBO + 'AT1015  T05 
		ON T05.DivisionID = AT1202.DivisionID and T05.AnaID =  AT1202.O05ID AND T05.AnaTypeID = ''O05''    
	'
	SET @sSQL2 = '	
	LEFT JOIN ' + @TableDBO + 'AT0303  AT0303
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
		From ' + @TableDBO + 'AT9000  AT9000 
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
				From ' + @TableDBO + 'AT9000  AT9000
				Where 
				DivisionID = ''' + @DivisionID + ''' AND 
				((Case When TransactionTypeID = ''T99'' Then CreditObjectID Else ObjectID End) Between ''' + @FromObjectID + ''' AND ''' + @ToObjectID + ''') AND 
				CurrencyIDCN like ''' + @CurrencyID + ''' AND    
				CreditAccountID >= ''' + @FromAccountID + ''' AND CreditAccountID<= ''' + @ToAccountID + ''' AND ' + @sTime1 + ' 
				Group By DivisionID,CreditAccountID,(Case When TransactionTypeID = ''T99'' Then CreditObjectID Else ObjectID End),TableID,CurrencyIDCN,VoucherID,BatchID) A
				INNER JOIN ' + @TableDBO + 'AT0303 B
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
 --Print @sSQL
 --Print @sSQL1
 --Print @sSQL2
 
	IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE NAME ='AV0313_ST')  
	 EXEC ('CREATE VIEW AV0313_ST --Create By AP0313_ST Customize Sieu Thanh
	 AS ' + @sSQL + @sSQL1 + @sSQL2
	 )   
	ELSE  
	 EXEC ('ALTER VIEW AV0313_ST --Create By AP0313_ST Customize Sieu Thanh
	 AS ' + @sSQL + @sSQL1 + @sSQL2)








GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
