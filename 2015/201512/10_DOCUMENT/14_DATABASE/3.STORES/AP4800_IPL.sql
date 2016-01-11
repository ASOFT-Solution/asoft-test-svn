IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP4800_IPL]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP4800_IPL]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-----	Created by Bao Anh	Date: 09/08/2012
-----	Purpose : Customize bao cao cong no theo MPT (IPL)
----	Modified on 19/10/2012 by Lê Thị Thu Hiền : Chỉnh sửa nếu chọn nhóm tiêu thức là OB
----	AP4800_IPL 'IPL','BC_002',7,2015,7,2015,'07/01/2015','07/31/2015',1,'V01-HTI-002','V01-HTI-002','','','','','',''
----	Modify on 21/09/2015 by Bảo Anh: Sửa cho trường hợp giải trừ sau tháng phát sinh hóa đơn
----	AP4800 'IPL','BC_002',8,2015,8,2015,'08/01/2015','08/31/2015',0,'C01-APH-004','C01-APH-004','','','','','',''

CREATE PROCEDURE [dbo].[AP4800_IPL] 	
				@DivisionID nvarchar(50), 
				@ReportCode AS nvarchar(50),
				@FromMonth AS int, 
				@FromYear AS int,
				@ToMonth AS int, 
				@ToYear AS int,
				@FromDate Datetime,
				@ToDate Datetime,
				@IsDate AS tinyint,
				@Selection01From nvarchar(20),  
				@Selection01To nvarchar(20),
				@Selection02From nvarchar(20),  
				@Selection02To nvarchar(20),
				@Selection03From nvarchar(20),  
				@Selection03To nvarchar(20),
				@Selection04From nvarchar(20),  
				@Selection04To nvarchar(20)

As

Declare 	@Column AS nvarchar(20),
			@join1 AS nvarchar(4000),
			@join2 AS nvarchar(4000),
			@join3 AS nvarchar(4000),
			@join4 AS nvarchar(4000),
			@sSQL AS nvarchar(max),
			@sSQLBalance AS nvarchar(4000),
			@sSQLGroup AS  nvarchar(4000),
			@sGroup  nvarchar(4000),
			@FromAccountID AS nvarchar(50),
			@ToAccountID AS nvarchar(50),
			@Selection01ID   AS nvarchar(50),      
			@Selection02ID  AS nvarchar(50),       
			@Selection03ID   AS nvarchar(50),      
			@Selection04ID   AS nvarchar(50),             		
			@Level01   AS nvarchar(20),                   
			@Level02   AS nvarchar(20),                   
			@Level03    AS nvarchar(20),                  
			@Level04  AS nvarchar(20),
			@I AS int,
			@ColumnType AS nvarchar(20),
			@ColumnData AS nvarchar(20),
			@sSQLColumn AS nvarchar(4000),
			@sSQLAV4301 AS nvarchar(4000),
			@sGiveUpDateBal as varchar(max),
			@sGiveUpDate as varchar(max)

Select 	top 1  @FromAccountID = FromAccountID, @ToAccountID = ToAccountID,
		@Selection01ID = Selection01ID, @Selection02ID = Selection02ID,
		@Selection03ID = Selection03ID, @Selection04ID = Selection04ID,
		@Level01 = Level01, @Level02 = Level02, 	
		@Level03 = Level03, @Level04 = Level04
From AT4801
Where ReportCode = @ReportCode and DivisionID = @DivisionID

--- Tạo view lấy dữ liệu giải trừ nợ phải thu (thay AV0301)
If Exists (Select 1 From SysObjects Where Xtype='V' and Name ='AV03011')
	DROP VIEW AV03011

EXEC('CREATE VIEW AV03011 AS
SELECT	GiveUpDate,ObjectID,AccountID,DebitVoucherID as VoucherID, DebitBatchID as BatchID,
		DebitTableID as TableID, CreditVoucherID, CreditBatchID, CreditTableID, CurrencyID,
		Sum(isnull(OriginalAmount,0)) as GivedOriginalAmount,
		Sum(isnull(ConvertedAmount,0)) as GivedConvertedAmount
FROM AT0303
WHERE DivisionID = ''' + @DivisionID + ''' And (AccountID between ''' + @FromAccountID + ''' and ''' + @ToAccountID + ''')
Group by GiveUpDate,ObjectID,AccountID,DebitVoucherID, DebitBatchID, DebitTableID, CreditVoucherID, CreditBatchID, CreditTableID, CurrencyID')

--- Tạo view lấy dữ liệu giải trừ nợ phải trả (thay AV0403)
If Exists (Select 1 From SysObjects Where Xtype='V' and Name ='AV04031')
	DROP VIEW AV04031

EXEC('CREATE VIEW AV04031 AS
SELECT	GiveUpDate,ObjectID,AccountID,CreditVoucherID as VoucherID, CreditBatchID as BatchID,
		CreditTableID as TableID, DebitVoucherID, DebitBatchID, DebitTableID,CurrencyID,
		Sum(isnull(OriginalAmount,0)) as GivedOriginalAmount,
		Sum(isnull(ConvertedAmount,0)) as GivedConvertedAmount
FROM AT0404
WHERE DivisionID = ''' + @DivisionID + ''' And (AccountID between ''' + @FromAccountID + ''' and ''' + @ToAccountID + ''')
Group by GiveUpDate,ObjectID,AccountID,CreditVoucherID,CreditBatchID,CreditTableID,DebitVoucherID, DebitBatchID, DebitTableID, CurrencyID')

---------1------------------- Xu ly Group-----------------------------------------------
Set @sSQLGroup = 'GROUP BY V31.DivisionID, V31.AccountID, V31.ObjectID, V31.VoucherID, V31.BatchID, V31.VoucherDate, V31.VoucherNo, V31.Serial, V31.InvoiceDate, V31.InvoiceNo, V31.DueDate, V31.CurrencyIDCN, V31.DueDays, V31.D_C'
Set @sSQL = 'SELECT  V31.DivisionID, V31.AccountID, V31.ObjectID, V31.VoucherID, V31.VoucherDate, V31.VoucherNo, V31.Serial, V31.InvoiceDate, V31.InvoiceNo, V31.DueDate, V31.CurrencyIDCN, V31.DueDays, Max(Ana01ID) AS Ana01ID, Max(AnaName01) AS AnaName01, D_C'
If @IsDate <> 0
	Begin
		Set @sGiveUpDateBal = ' And GiveUpDate < ''' + Convert(nvarchar(10),@FromDate,101) + ''''
		Set @sGiveUpDate = ' And (GiveUpDate between ''' + Convert(nvarchar(10),@FromDate,101) + ''' And ''' + Convert(nvarchar(10),@ToDate,101) + ''')'
	End
Else
	Begin
		Set @sGiveUpDateBal = ' And Month(GiveUpDate) + 100 * Year(GiveUpDate) < ' + ltrim(@FromMonth) + ' + 100 * ' + ltrim(@FromYear)
		Set @sGiveUpDate = ' And (Month(GiveUpDate) + 100 * Year(GiveUpDate) between ' + ltrim(@FromMonth) + ' + 100 * ' + ltrim(@FromYear) + ' and ' + ltrim(@ToMonth) + ' + 100 * ' + ltrim(@ToYear) + ')'
	End

Set @sSQLBalance ='SELECT V31.DivisionID, V31.AccountID, V31.ObjectID, V31.VoucherID, V31.BatchID, Cast(Convert(nvarchar(10),V31.VoucherDate,101) AS DateTime) AS VoucherDate, V31.VoucherNo, V31.Serial, V31.InvoiceDate, V31.InvoiceNo, V31.DueDate, V31.CurrencyIDCN, V31.DueDays, Max(V31.Ana01ID) AS Ana01ID, Max(V31.AnaName01) AS AnaName01,'
IF left(@FromAccountID,3) = '131'	--- báo cáo phải thu
BEGIN
	Set @sSQLBalance =	@sSQLBalance + '
	(CASE WHEN D_C =''D'' then sum(V31.OriginalAmountCN) - Isnull((select sum(Isnull(GivedOriginalAmount,0)) From AV03011
										Where VoucherID = V31.VoucherID and BatchID = V31.BatchID and ObjectID = V31.ObjectID and CurrencyID = V31.CurrencyIDCN and AccountID = V31.AccountID ' + @sGiveUpDateBal + '),0)
						else 0 end) AS BeginDebitOriginalAmount,

	(CASE WHEN D_C=''C'' then sum(V31.OriginalAmountCN) - Isnull((select sum(Isnull(GivedOriginalAmount,0)) From AV03011
										Where VoucherID = V31.VoucherID and BatchID = V31.BatchID and ObjectID = V31.ObjectID and CurrencyID = V31.CurrencyIDCN and AccountID = V31.AccountID ' + @sGiveUpDateBal + '),0)
						else 0 end) AS BeginCreditOriginalAmount,

	RDebitOriginalAmountGV = CASE WHEN D_C =''C'' then (select sum(Isnull(GivedOriginalAmount,0)) From AV03011
														Where VoucherID = V31.VoucherID and BatchID = V31.BatchID and ObjectID = V31.ObjectID and CurrencyID = V31.CurrencyIDCN and AccountID = V31.AccountID ' + @sGiveUpDate + ')
														else 0 end,	
	RCreditOriginalAmountGV = CASE WHEN D_C =''D'' then (select sum(Isnull(GivedOriginalAmount,0)) From AV03011
														Where VoucherID = V31.VoucherID and BatchID = V31.BatchID and ObjectID = V31.ObjectID and CurrencyID = V31.CurrencyIDCN and AccountID = V31.AccountID ' + @sGiveUpDate + ')
														else 0 end,	
	NULL as PDebitOriginalAmountGV, NULL as PCreditOriginalAmountGV'
END
ELSE	--- báo cáo phải trả
BEGIN
	Set @sSQLBalance = @sSQLBalance + '
	(CASE WHEN D_C =''D'' then sum(V31.OriginalAmountCN) - Isnull((select sum(Isnull(GivedOriginalAmount,0)) From AV04031
										Where VoucherID = V31.VoucherID and BatchID = V31.BatchID and ObjectID = V31.ObjectID and CurrencyID = V31.CurrencyIDCN and AccountID = V31.AccountID ' + @sGiveUpDateBal + '),0)
						else 0 end) AS BeginDebitOriginalAmount,

	(CASE WHEN D_C=''C'' then sum(V31.OriginalAmountCN) - Isnull((select sum(Isnull(GivedOriginalAmount,0)) From AV04031
										Where VoucherID = V31.VoucherID and BatchID = V31.BatchID and ObjectID = V31.ObjectID and CurrencyID = V31.CurrencyIDCN and AccountID = V31.AccountID ' + @sGiveUpDateBal + '),0)
						else 0 end) AS BeginCreditOriginalAmount,

	NULL as RDebitOriginalAmountGV, NULL as RCreditOriginalAmountGV,
	PDebitOriginalAmountGV = CASE WHEN D_C =''C'' then (select sum(Isnull(GivedOriginalAmount,0)) From AV04031
														Where VoucherID = V31.VoucherID and BatchID = V31.BatchID and ObjectID = V31.ObjectID and CurrencyID = V31.CurrencyIDCN and AccountID = V31.AccountID ' + @sGiveUpDate + ')
														else 0 end,	
	PCreditOriginalAmountGV = CASE WHEN D_C =''D'' then (select sum(Isnull(GivedOriginalAmount,0)) From AV04031
														Where VoucherID = V31.VoucherID and BatchID = V31.BatchID and ObjectID = V31.ObjectID and CurrencyID = V31.CurrencyIDCN and AccountID = V31.AccountID ' + @sGiveUpDate + ')
														else 0 end'
END

Set @sGroup ='  Group by DivisionID, AccountID, ObjectID, VoucherID, BatchID, VoucherDate, VoucherNo, Serial, InvoiceDate, InvoiceNo, DueDate, CurrencyIDCN, D_C, DueDays'
If isnull(@Level01,'') <>'' 
   Begin	
	Exec AP4700 @Level01 ,  @Column  output
	Set @sSQL = @sSQL+ ' ,V31.'+@Column+'  AS Group01ID'
	Set @sSQLBalance = @sSQLBalance+' , V31.'+@Column+'  AS Group01ID '
	Set @sSQLGroup = @sSQLGroup + ' ,V31.'+@Column+' '
	Set @sGroup = @sGroup+', '+@Column+' '
		--Print @sSQLBalance
  End
	Else
	  Begin
	    	Set @sSQL = @sSQL+ ', '''' as Group01ID '
			Set @sSQLBalance = @sSQLBalance+ ', '''' AS Group01ID '
	  End


Set  @Column =''     
If isnull(@Level02,'') <>'' 
   Begin
	Exec AP4700 @Level02 ,  @Column  output
	Set @sSQL = @sSQL+ ' ,V31.'+@Column+'  AS Group02ID'
	Set @sSQLBalance = @sSQLBalance+' , V31.'+@Column+'  AS Group02ID '
	Set @sGroup = @sGroup+', '+@Column+' '
	Set @sSQLGroup = @sSQLGroup+',  V31.'+@Column+' '
   End	
Else
	Begin
	   Set @sSQL = @sSQL+ ', '''' as Group02ID '
	   Set @sSQLBalance = @sSQLBalance+ ', '''' AS Group02ID '
	End

Set  @Column =''     
If isnull(@Level03,'') <>'' 
   Begin
	Exec AP4700 @Level03 ,  @Column  output
	Set @sSQL = @sSQL+ ' ,V31.'+@Column+'  AS Group03ID'
	Set @sSQLBalance = @sSQLBalance+' , V31.'+@Column+'  AS Group03ID '
	Set @sGroup = @sGroup+', '+@Column+' '
	Set @sSQLGroup = @sSQLGroup+',  V31.'+@Column+' '
 End	
Else
   Begin	
	    Set @sSQL = @sSQL+ ', '''' as Group03ID '
		Set @sSQLBalance = @sSQLBalance+ ', '''' AS Group03ID  '
   End	

If isnull(@Level04,'') <>'' 
   Begin
	Exec AP4700 @Level04 ,  @Column  output
	Set @sSQL = @sSQL+ ' ,V31.'+@Column+'  AS Group04ID'
	Set @sSQLBalance = @sSQLBalance+' , V31.'+@Column+'  AS Group04ID '
	Set @sGroup = @sGroup+', '+@Column+' '
	Set @sSQLGroup = @sSQLGroup+',  V31.'+@Column+' '
 End	
Else
   Begin	
		Set @sSQL = @sSQL+ ', '''' as Group04ID '
		Set @sSQLBalance = @sSQLBalance+ ', '''' AS Group04ID '
   End

Set @sSQL = @sSQL+', 
				sum(CASE WHEN D_C =''D'' then Isnull(OriginalAmountCN,0) else 0 end) as DebitOriginalAmount ,  
				sum(CASE WHEN D_C =''D'' then Isnull(OriginalAmountCN,0) else 0 end) as DebitConvertedAmount,
				sum(CASE WHEN D_C =''C'' then Isnull(OriginalAmountCN,0) else 0 end) as CreditOriginalAmount,
				sum(CASE WHEN D_C =''C'' then Isnull(OriginalAmountCN,0) else 0 end) as CreditConvertedAmount,
				'
IF left(@FromAccountID,3) = '131'	--- báo cáo phải thu
	Set @sSQL =	@sSQL + '
	RDebitOriginalAmountGV = CASE WHEN D_C =''C'' then (select sum(Isnull(GivedOriginalAmount,0)) From AV03011
														Where VoucherID = V31.VoucherID and ObjectID = V31.ObjectID and CurrencyID = V31.CurrencyIDCN and AccountID = V31.AccountID ' + @sGiveUpDate + ')
														else 0 end,	
	RCreditOriginalAmountGV = CASE WHEN D_C =''D'' then (select sum(Isnull(GivedOriginalAmount,0)) From AV03011
														Where VoucherID = V31.VoucherID and ObjectID = V31.ObjectID and CurrencyID = V31.CurrencyIDCN and AccountID = V31.AccountID ' + @sGiveUpDate + ')
														else 0 end,	
	NULL as PDebitOriginalAmountGV, NULL as PCreditOriginalAmountGV'
ELSE	--- báo cáo phải trả
	Set @sSQL =	@sSQL + '
	NULL as RDebitOriginalAmountGV, NULL as RCreditOriginalAmountGV,
	PDebitOriginalAmountGV = CASE WHEN D_C =''C'' then (select sum(Isnull(GivedOriginalAmount,0)) From AV04031
														Where VoucherID = V31.VoucherID and ObjectID = V31.ObjectID and CurrencyID = V31.CurrencyIDCN and AccountID = V31.AccountID ' + @sGiveUpDate + ')
														else 0 end,	
	PCreditOriginalAmountGV = CASE WHEN D_C =''D'' then (select sum(Isnull(GivedOriginalAmount,0)) From AV04031
														Where VoucherID = V31.VoucherID and ObjectID = V31.ObjectID and CurrencyID = V31.CurrencyIDCN and AccountID = V31.AccountID ' + @sGiveUpDate + ')
														else 0 end'
				
Set @sSQL = @sSQL+',Sum(Quantity) AS Quantity
	FROM	AV4301 V31
	Where  DivisionID = ''' + @DivisionID + ''' and  TransactionTypeID<>''T00''	and 		
				AccountID between '''+isnull(@FromAccountID,'')+''' and '''+isnull(@ToAccountID,'')+''' 
				And D_C = (CASE WHEN AccountID like ''331%'' then ''C'' else ''D'' end)'

If @IsDate =0
	Begin
		Set @sSQL =@sSQL+' and  (TranMonth + 100 * TranYear between '+str(@FromMonth)+' + 100 * '+str(@FromYear)+'  and  '+str(@ToMonth)+' + 100*'+str(@ToYear)+' ) '
	End
Else
	Begin
		Set @sSQL =@sSQL+' and (VoucherDate  between  '''+Convert(nvarchar(10),@FromDate,101)+''' and  '''+Convert(nvarchar(10),@ToDate,101)+''')  '
	End

--Print @sSQL (TranMonth + 100*TranYear between '+str(@FromMonth)+' + 100*'+str(@FromYear)+'  and  '+str(@ToMonth)+' + 100*'+str(@ToYear)+' ) and
	
Set @sSQLBalance = @sSQLBalance+' From AV4301 V31
								Where  DivisionID ='''+@DivisionID+'''  and
									AccountID between '''+isnull(@FromAccountID,'')+''' and '''+isnull(@ToAccountID,'')+'''
									And D_C = (CASE WHEN AccountID like ''331%'' then ''C'' else ''D'' end)'

If @IsDate =0
	Begin
		Set @sSQLBalance =@sSQLBalance + ' and ((TranMonth + 100 * TranYear < ' + str(@FromMonth) + ' + 100 * ' + str(@FromYear) + ' And TransactionTypeID <> ''T00'')
										Or (TransactionTypeID = ''T00''))'
	End
Else
	Begin
		Set @sSQLBalance =@sSQLBalance + ' and ((VoucherDate < ''' + Convert(nvarchar(10),@FromDate,101) + ''' And TransactionTypeID <> ''T00'')
											Or (TransactionTypeID = ''T00''))'
	End

---print @sSQL

If isnull(@Selection01ID,'') <>'' 
   Begin
	Exec AP4700 @Selection01ID ,  @Column  output
	Set @sSQL = @sSQL+ ' and ('+@Column+' Between '''+isnull(@Selection01From,'')+''' and '''+isnull(@Selection01To,'')+''' ) '
	Set @sSQLBalance = @sSQLBalance+' and ('+@Column+' Between '''+isnull(@Selection01From,'')+''' and '''+isnull(@Selection01To,'')+''' ) '
  End 


If isnull(@Selection02ID,'') <>'' 
   Begin
	Exec AP4700 @Selection02ID ,  @Column  output
	Set @sSQL = @sSQL+ ' and ('+@Column+' Between '''+isnull(@Selection02From,'')+''' and '''+isnull(@Selection02To,'')+''' ) '
	Set @sSQLBalance = @sSQLBalance+' and ('+@Column+' Between '''+isnull(@Selection02From,'')+''' and '''+isnull(@Selection02To,'')+''' ) '
  End 


If isnull(@Selection03ID,'') <>'' 
   Begin
	Exec AP4700 @Selection03ID ,  @Column  output
	Set @sSQL = @sSQL+ ' and ('+@Column+' Between '''+isnull(@Selection03From,'')+''' and '''+isnull(@Selection03To,'')+''' ) '
	Set  @sSQLBalance = @sSQLBalance+ ' and ('+@Column+' Between '''+isnull(@Selection03From,'')+''' and '''+isnull(@Selection03To,'')+''' ) ' 
  End 


If isnull(@Selection04ID,'') <>'' 
   Begin
	Exec AP4700 @Selection04ID ,  @Column  output
	Set @sSQL = @sSQL+ ' and ('+@Column+' Between '''+isnull(@Selection04From,'')+''' and '''+isnull(@Selection04To,'')+''' )  '
	Set @sSQLBalance = @sSQLBalance+ ' and ('+@Column+' Between '''+isnull(@Selection04From,'')+''' and '''+isnull(@Selection04To,'')+''' )  '
  End 

Set @sSQL = @sSQL+@sGroup
Set @sSQLBalance = @sSQLBalance+ @sSQLGroup--- ' GROUP BY DivisionID, AccountID, ObjectID, VoucherID, VoucherDate, D_C,VoucherNo, Serial, InvoiceDate, InvoiceNo, DueDate, CurrencyIDCN, DueDays ,AccountID ,  ObjectID'

IF left(@FromAccountID,3) = '131'	--- báo cáo phải thu
BEGIN
	Set @sSQLBalance = @sSQLBalance+'
	having SUM(V31.OriginalAmountCN) - Isnull((select sum(Isnull(GivedOriginalAmount,0)) From AV03011
			Where VoucherID = V31.VoucherID and BatchID = V31.BatchID and ObjectID = V31.ObjectID and CurrencyID = V31.CurrencyIDCN and AccountID = V31.AccountID ' +
			@sGiveUpDateBal + '),0) <> 0
			'
END
ELSE
BEGIN
	Set @sSQLBalance = @sSQLBalance+'
	having SUM(V31.OriginalAmountCN) - Isnull((select sum(Isnull(GivedOriginalAmount,0)) From AV04031
			Where VoucherID = V31.VoucherID and BatchID = V31.BatchID and ObjectID = V31.ObjectID and CurrencyID = V31.CurrencyIDCN and AccountID = V31.AccountID ' +
			@sGiveUpDateBal + '),0) <> 0
			'
END

---Print (@sSQL)

If not Exists (Select 1 From SysObjects Where Xtype='V' and Name ='AV4810')
	Exec('Create view AV4810 	--Created by AP4800
			as '+@sSQL)
Else	
	Exec('Alter view AV4810 		--Created by AP4800
			as '+@sSQL)

If not Exists (Select 1 From SysObjects Where Xtype='V' and Name ='AV4820')
	Exec('Create view AV4820 	--Created by AP4800
			as '+@sSQLBalance)
Else	
	Exec('Alter view AV4820 		--Created by AP4800
			as '+@sSQLBalance)

Set @sSQLBalance ='
Select DivisionID, AccountID, ObjectID, VoucherID, VoucherDate, VoucherNo, Serial, InvoiceDate, InvoiceNo,
	DueDate, DueDays, CurrencyIDCN, Group01ID, Group02ID, Group03ID, Group04ID, Ana01ID, AnaName01,
	BeginDebitOriginalAmount, BeginCreditOriginalAmount,
	RDebitOriginalAmountGV, RCreditOriginalAmountGV,
	PDebitOriginalAmountGV,	PCreditOriginalAmountGV
From	AV4820
'
---PRINT(@sSQLBalance)

If not Exists (Select 1 From SysObjects Where Xtype='V' and Name ='AV4821')
	Exec('Create view AV4821 	--Created by AP4800
			as '+@sSQLBalance)
Else	
	Exec('Alter view AV4821 		--Created by AP4800
			as '+@sSQLBalance)

Set @sSQL =' 	
Select 	ISNULL(V21.DivisionID, V10.DivisionID) AS DivisionID, 
		Isnull (T02.ObjectName,T03.ObjectName)as ObjectName,  
		Isnull(V21.AccountID, V10.AccountID) AS AccountID, ---V10.CorAccountID, 
		Isnull(V10.ObjectID,V21.ObjectID) AS ObjectID,
		Isnull(V21.VoucherID, V10.VoucherID) AS VoucherID,
		Isnull(V21.VoucherDate, V10.VoucherDate) AS VoucherDate,
		Isnull(V21.VoucherNo, V10.VoucherNo) AS VoucherNo, 
		Isnull(V21.Serial, V10.Serial) AS Serial,
		Isnull(V21.InvoiceDate, V10.InvoiceDate) AS InvoiceDate,
		Isnull(V21.InvoiceNo, V10.InvoiceNo) AS InvoiceNo,
		Isnull(V21.DueDate, V10.DueDate) AS DueDate, ---V10.VDescription, 
		Isnull(V21.CurrencyIDCN, V10.CurrencyIDCN) AS CurrencyIDCN,
		Isnull(V21.DueDays, V10.DueDays) AS DueDays,
		Isnull (V10.Group01ID, V21.Group01ID) AS Group01ID,
		Isnull (V10.Group02ID,V21.Group02ID) AS Group02ID, 
		Isnull (V10.Group03ID, V21.Group03ID) AS Group03ID ,
		Isnull (V10.Group04ID,V21.Group04ID) AS Group04ID,
		V10.D_C, Isnull(V21.Ana01ID, V10.Ana01ID) AS Ana01ID,
		Isnull(V21.AnaName01, V10.AnaName01) AS AnaName01,
		Isnull(T15.AccountName, T05.AccountName) AS AccountName,'
If @IsDate =0
	Set @sSQL =@sSQL+	
		'(CASE WHEN (month(V10.VoucherDate) + 100*year(V10.VoucherDate) between '+str(@FromMonth)+' + 100*'+str(@FromYear)+'  and  '+str(@ToMonth)+' + 100*'+str(@ToYear)+') then isnull (V10.DebitOriginalAmount,0) else 0 end) AS DebitOriginalAmount,
		(CASE WHEN (month(V10.VoucherDate) + 100*year(V10.VoucherDate) between '+str(@FromMonth)+' + 100*'+str(@FromYear)+'  and  '+str(@ToMonth)+' + 100*'+str(@ToYear)+') then Isnull (V10.DebitConvertedAmount,0) else 0 end) AS DebitConvertedAmount, 
		(CASE WHEN (month(V10.VoucherDate) + 100*year(V10.VoucherDate) between '+str(@FromMonth)+' + 100*'+str(@FromYear)+'  and  '+str(@ToMonth)+' + 100*'+str(@ToYear)+') then Isnull (V10.CreditOriginalAmount,0) else 0 end) AS CreditOriginalAmount,
		(CASE WHEN (month(V10.VoucherDate) + 100*year(V10.VoucherDate) between '+str(@FromMonth)+' + 100*'+str(@FromYear)+'  and  '+str(@ToMonth)+' + 100*'+str(@ToYear)+') then Isnull (V10.CreditConvertedAmount,0) else 0 end) AS CreditConvertedAmount,'
ELSE
	Set @sSQL =@sSQL+
		'(CASE WHEN (V10.VoucherDate between '''+Convert(nvarchar(10),@FromDate,101)+''' and  '''+Convert(nvarchar(10),@ToDate,101)+''') then isnull (V10.DebitOriginalAmount,0) else 0 end) AS DebitOriginalAmount,
		(CASE WHEN (V10.VoucherDate between '''+Convert(nvarchar(10),@FromDate,101)+''' and  '''+Convert(nvarchar(10),@ToDate,101)+''') then Isnull (V10.DebitConvertedAmount,0) else 0 end) AS DebitConvertedAmount,
		(CASE WHEN (V10.VoucherDate between '''+Convert(nvarchar(10),@FromDate,101)+''' and  '''+Convert(nvarchar(10),@ToDate,101)+''') then Isnull (V10.CreditOriginalAmount,0) else 0 end) AS CreditOriginalAmount,
		(CASE WHEN (V10.VoucherDate between '''+Convert(nvarchar(10),@FromDate,101)+''' and  '''+Convert(nvarchar(10),@ToDate,101)+''') then Isnull (V10.CreditConvertedAmount,0) else 0 end) AS CreditConvertedAmount,'
	
Set @sSQL = @sSQL + 'V10.Quantity,
		Isnull(BeginDebitOriginalAmount,0) AS BeginDebitOriginalAmount,
		Isnull(BeginCreditOriginalAmount,0) AS BeginCreditOriginalAmount,
		
		(CASE WHEN Isnull(V21.RDebitOriginalAmountGV,0) = 0 then isnull(V10.RDebitOriginalAmountGV,0) else Isnull(V21.RDebitOriginalAmountGV,0) end) AS RDebitOriginalAmountGV,
		(CASE WHEN Isnull(V21.RCreditOriginalAmountGV,0) = 0 then isnull(V10.RCreditOriginalAmountGV,0) else Isnull(V21.RCreditOriginalAmountGV,0) end) AS RCreditOriginalAmountGV,
		(CASE WHEN Isnull(V21.PDebitOriginalAmountGV,0) = 0 then isnull(V10.PDebitOriginalAmountGV,0) else isnull(V21.PDebitOriginalAmountGV,0) end) AS PDebitOriginalAmountGV,
		(CASE WHEN Isnull(V21.PCreditOriginalAmountGV,0) = 0 then isnull(V10.PCreditOriginalAmountGV,0) else Isnull(V21.PCreditOriginalAmountGV,0) end) AS PCreditOriginalAmountGV
'				
If isnull(@Level01,'') <>'' 
  	Set @sSQL =@sSQL +',  V61.SelectionName AS GroupName01 '
Else
	Set @sSQL =@sSQL +',  ''''  GroupName01 '	

if left( isnull(@Level01,''),2) ='A0'
	Begin
	
	   Set @join1 =' 
			Left join	AT1011 T1 
				on 		T1.AnaID =  Isnull (V10.Group01ID, V21.Group01ID)  
						and T1.AnaTypeID ='''+@Level01+''' '
	  Set @sSQL= @sSQL+', isnull(T1.Amount01,cast(0 AS decimal)) AS G1Amount01, isnull(T1.Amount02,cast(0 AS decimal)) AS G1Amount02,isnull(T1.Amount03,cast(0 AS decimal)) AS G1Amount03,isnull(T1.Amount04,cast(0 AS decimal)) AS G1Amount04,isnull(T1.Amount05,cast(0 AS decimal)) AS G1Amount05,
				isnull(T1.Note01,'''') AS G1Note01,isnull(T1.Note02,'''') AS G1Note02,isnull(T1.Note03,'''') AS G1Note03,isnull(T1.Note04,'''') AS G1Note04,isnull(T1.Note05,'''') AS G1Note05  '
	End
Else
	Begin
		Set @Join1 =' '
		Set @sSQL= @sSQL+', cast(0 AS decimal) AS  G1Amount01, cast(0 AS decimal) AS  G1Amount02, cast(0 AS decimal) AS  G1Amount03, cast(0 AS decimal) AS  G1Amount04, cast(0 AS decimal) AS G1Amount05,
				N'''' AS G1Note01, N'''' AS  G1Note02, N'''' AS  G1Note03, N'''' AS  G1Note04, N'''' AS  G1Note05  '

	End
 

 
If isnull(@Level02,'') <>'' 
  Set @sSQL =@sSQL +',   V62.SelectionName AS GroupName02 '		
Else
	Set @sSQL =@sSQL +' , ''''  GroupName02 '	


if left( isnull(@Level02,''),2) ='A0'
	Begin
	   Set @join2 =' 
			Left join	AT1011 T2 
				on 		T2.AnaID =  Isnull (V10.Group02ID, V21.Group02ID)  
						and T2.AnaTypeID ='''+@Level02+''' '
	  Set @sSQL= @sSQL+', isnull(T2.Amount01,cast(0 AS decimal)) AS G2Amount01, isnull(T2.Amount02,cast(0 AS decimal)) AS G2Amount02,isnull(T2.Amount03,cast(0 AS decimal)) AS G2Amount03,isnull(T2.Amount04,cast(0 AS decimal)) AS G2Amount04,isnull(T2.Amount05,cast(0 AS decimal)) AS G2Amount05,
				isnull(T2.Note01,'''') AS G2Note01,isnull(T2.Note02,'''') AS G2Note02,isnull(T2.Note03,'''') AS G2Note03,isnull(T2.Note04,'''') AS G2Note04,isnull(T2.Note05,'''') AS G2Note05  '
	End
Else
	Begin
		Set @Join2 =' '
		Set @sSQL= @sSQL+', cast(0 AS decimal) AS  G2Amount01, cast(0 AS decimal) AS  G2Amount02, cast(0 AS decimal) AS  G2Amount03, cast(0 AS decimal) AS  G2Amount04, cast(0 AS decimal) AS G2Amount05,
				N'''' AS G2Note01, N'''' AS  G2Note02, N'''' AS  G2Note03, N'''' AS  G2Note04, N'''' AS  G2Note05  '

	End


If isnull(@Level03,'') <>'' 
  Set @sSQL =@sSQL +',   V63.SelectionName AS GroupName03 '		
Else
  Set @sSQL =@sSQL +',  ''''  GroupName03 '	

if left( isnull(@Level03,''),2) ='A0'
	Begin
	   Set @join3 =' Left join  AT1011 T3 on 	T3.AnaID =  Isnull (V10.Group03ID, V21.Group03ID)  and 
						T3.AnaTypeID ='''+@Level03+''' '
	  Set @sSQL= @sSQL+', isnull(T3.Amount01,cast(0 AS decimal)) AS G3Amount01, isnull(T3.Amount02,cast(0 AS decimal)) AS G3Amount02,isnull(T3.Amount03,cast(0 AS decimal)) AS G3Amount03,isnull(T3.Amount04,cast(0 AS decimal)) AS G3Amount04,isnull(T3.Amount05,cast(0 AS decimal)) AS G3Amount05,
				isnull(T3.Note01,'''') AS G3Note01,isnull(T3.Note02,'''') AS G3Note02,isnull(T3.Note03,'''') AS G3Note03,isnull(T3.Note04,'''') AS G3Note04,isnull(T3.Note05,'''') AS G3Note05  '
	End
Else
	Begin
		Set @Join3 =' '
		Set @sSQL= @sSQL+', cast(0 AS decimal) AS  G3Amount01, cast(0 AS decimal) AS  G3Amount02, cast(0 AS decimal) AS  G3Amount03, cast(0 AS decimal) AS  G3Amount04, cast(0 AS decimal) AS G3Amount05,
				N'''' AS G3Note01, N'''' AS  G3Note02, N'''' AS  G3Note03, N'''' AS  G3Note04, N'''' AS  G3Note05  '

	End


If isnull(@Level04,'') <>'' 
  Set @sSQL =@sSQL +',   V64.SelectionName AS GroupName04 '		
Else
  Set @sSQL =@sSQL +',  ''''  GroupName04 '	

if left( isnull(@Level04,''),2) ='A0'
	Begin
	   Set @join4 =' Left join  AT1011 T4 on 	T4.AnaID =  Isnull (V10.Group04ID, V21.Group04ID)  and 
						T4.AnaTypeID ='''+@Level04+''' '
	  Set @sSQL= @sSQL+', isnull(T4.Amount01,cast(0 AS decimal)) AS G4Amount01, isnull(T4.Amount02,cast(0 AS decimal)) AS G4Amount02,isnull(T4.Amount03,cast(0 AS decimal)) AS G4Amount03,isnull(T4.Amount04,cast(0 AS decimal)) AS G4Amount04,isnull(T4.Amount05,cast(0 AS decimal)) AS G4Amount05,
				isnull(T4.Note01,'''') AS G4Note01,isnull(T4.Note02,'''') AS G4Note02,isnull(T4.Note03,'''') AS G4Note03,isnull(T3.Note04,'''') AS G4Note04,isnull(T3.Note05,'''') AS G4Note05  '
	End
Else
	Begin
		Set @Join4 =' '
		Set @sSQL= @sSQL+', cast(0 AS decimal) AS  G4Amount01, cast(0 AS decimal) AS  G4Amount02, cast(0 AS decimal) AS  G4Amount03, cast(0 AS decimal) AS  G4Amount04, cast(0 AS decimal) AS G4Amount05,
				N'''' AS G4Note01, N'''' AS  G4Note02, N'''' AS  G4Note03, N'''' AS  G4Note04, N'''' AS  G4Note05  '

	End

Set @sSQL =@sSQL+'
	From AV4821 V21 
	FULL join AV4810 V10  
			on V21.Group01ID = V10.Group01ID and
			V21.Group02ID = V10.Group02ID and
			V21.Group03ID = V10.Group03ID and
			V21.Group04ID = V10.Group04ID and
			V21.ObjectID = V10.ObjectID and
			V21.VoucherID = V10.VoucherID
	left join AT1202 T02 On T02.ObjectID = V10.ObjectID 
	Left Join At1202 T03 on T03.ObjectID = V21.ObjectID
	Left join AT1005 T05 on T05.AccountID = V10.AccountID
	Left join AT1005 T15 on T15.AccountID = V21.AccountID'
--print @sSQL

If isnull(@Level01,'') <>''  
Begin
	Set @sSQL = @sSQL +' left join AV6666 V61 on 	V61.SelectionType ='''+@Level01+''' And
							V61.SelectionID = isnull(V10.Group01ID,V21.Group01ID) 
											 '
	Set @sSQL=@sSQL+' '+@join1

End

If isnull(@Level02,'') <>'' 
begin
	Set @sSQL = @sSQL +' left join AV6666 V62 on 	V62.SelectionType ='''+@Level02+''' And
							V62.SelectionID =  isnull(V10.Group02ID,V21.Group02ID)  '

	Set @sSQL=@sSQL+' '+@join2
end

If isnull(@Level03,'') <>'' 
begin
	Set @sSQL = @sSQL +' left join AV6666 V63 on 	V63.SelectionType ='''+@Level03+''' And
							V63.SelectionID =  isnull(V10.Group03ID,V21.Group03ID)   '

	Set @sSQL=@sSQL+' '+@join3
end

If isnull(@Level04,'') <>'' 
begin
	Set @sSQL = @sSQL +' left join AV6666 V64 on 	V64.SelectionType ='''+@Level04+''' And
							V64.SelectionID = isnull(V10.Group04ID,V21.Group04ID)   '

	Set @sSQL=@sSQL+' '+@join4
END

If not Exists (Select 1 From SysObjects Where Xtype='V' and Name ='AV4800')
	Exec('Create view AV4800 	--Created by  AP4800_IPL
			as '+@sSQL)
Else	
	Exec('Alter view AV4800 		--Created by AP4800_IPL
			as '+@sSQL)
			
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON