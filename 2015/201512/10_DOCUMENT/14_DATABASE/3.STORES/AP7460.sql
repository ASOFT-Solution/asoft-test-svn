/****** Object:  StoredProcedure [dbo].[AP7460]    Script Date: 12/08/2010 13:23:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

------ Created by Nguyen Thi Ngoc Minh
------ Date 29/07/2004
------ In Nhat ky so cai
------ Edit by: Dang Le Bao Quynh; Date: 10/05/2007
------ Purpose: Cap nhat them dong so du
----- Modified on 10/06/2015 by Bảo Anh: Lấy dữ liệu năm theo niên độ TC người dùng thiết lập
/********************************************
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP7460] 	
				@DivisionID as  NVARCHAR(50),
				@FromMonth as int,
				@FromYear as int,
				@ToMonth as int,
				@ToYear as int,
				@FromDate as Datetime,
				@ToDate as Datetime,
				@IsDate as tinyint,
				@BeginBalance as NVARCHAR(250),
				@EndBalance as NVARCHAR(250),
				@Raising as NVARCHAR(250)
 AS
Declare @sSQL as nvarchar(4000),
	@strWhere as nvarchar(4000),
	@strWhereFilter as nvarchar(4000),
	@VoucherID as  NVARCHAR(50),
	@VoucherDate as datetime,
	@AV7460_Cursor as cursor,
	@BeginMonth as int,
	@EndMonth as int,
	@BeginYear as int,
	@EndYear as int

Select top 1 @BeginMonth = TranMonth From AV9999
Where DivisionID = @DivisionID
and Right(ltrim(Quarter),4) = @FromYear
Order by TranYear,TranMonth

Select top 1 @EndMonth = TranMonth From AV9999
Where DivisionID = @DivisionID
and Right(ltrim(Quarter),4) = @ToYear
Order by TranYear Desc,TranMonth Desc

Select top 1 @BeginYear = TranYear From AV9999
Where DivisionID = @DivisionID
and Right(ltrim(Quarter),4) = @FromYear
Order by TranYear

Select top 1 @EndYear = TranYear From AV9999
Where DivisionID = @DivisionID
and Right(ltrim(Quarter),4) = @ToYear
Order by TranYear Desc

If @IsDate = 0 -- theo ky
	Set @strWhere ='Where  AT9000.TransactionTypeID <>''T00'' and
				AT9000.DivisionID = '''+@DivisionID+''' and
				(AT9000.TranMonth + AT9000.TranYear*100 Between '+str(@FromMonth)+' + 100*'+str(@FromYear)+' and  '+str(@ToMonth)+' + 100*'+str(@ToYear)+') '

Else
   If @IsDate = 1 -- theo ngay
	Set @strWhere ='Where  AT9000.TransactionTypeID <>''T00'' and
				AT9000.DivisionID = '''+@DivisionID+''' and
				(AT9000.VoucherDate Between '''	+convert(nvarchar(10),@FromDate,101)+ ''' and  '''+convert(nvarchar(10),@ToDate,101)+ ''') '
   Else		-- theo nam
		Set @strWhere ='Where  AT9000.TransactionTypeID <>''T00'' and
				AT9000.DivisionID = '''+@DivisionID+''' and
				(AT9000.TranMonth + AT9000.TranYear*100 Between '+str(@BeginMonth)+' + 100*'+str(@BeginYear)+' and  '+str(@EndMonth)+' + 100*'+str(@EndYear)+') '

Set @sSQL='Select '''' as RecordNo, DivisionID, TableID, Case When TransactionTypeID =''T14'' then ''T04'' else  TransactionTypeID End as TransactionTypeID, VoucherID as VoucherID , VoucherNo, VoucherDate, 
	VDescription as Description, 
	sum(isnull(ConvertedAmount,0)) as ConvertedAmount
From AT9000

	 '+@strWhere+' 	
	Group by DivisionID,VoucherID, VoucherNo, VoucherDate, VDescription,  TableID,  Case When TransactionTypeID =''T14'' then ''T04'' else  TransactionTypeID End    '


--Print @sSQL

IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE SYSOBJECTS.NAME = 'AV7460' AND SYSOBJECTS.XTYPE = 'V')
	EXEC ('CREATE VIEW AV7460 	--- Created by AP7460
		AS ' + @sSQL)
ELSE
	EXEC ('ALTER VIEW AV7460 	--- Created by AP7460
		 AS ' + @sSQL)

--- Tao view lay so du dau
If @IsDate = 0 -- theo ky
Begin
	Set @strWhere ='Where  AV5000.DivisionID = '''+@DivisionID+''' and
				(AV5000.TranMonth + AV5000.TranYear*100 < '+str(@FromMonth)+' + 100*'+str(@FromYear)+') '

	Set @strWhereFilter ='Where  AV5000.DivisionID = '''+@DivisionID+''' and
				(AV5000.TranMonth + AV5000.TranYear*100 Between '+str(@FromMonth)+' + 100*'+str(@FromYear)+' and  '+str(@ToMonth)+' + 100*'+str(@ToYear)+') '
End

Else
   If @IsDate = 1 -- theo ngay
   Begin	
	Set @strWhere ='Where  AV5000.DivisionID = '''+@DivisionID+''' and
				(AV5000.VoucherDate < '''	+convert(nvarchar(10),@FromDate,101)+ ''') '

	Set @strWhereFilter ='Where  AV5000.DivisionID = '''+@DivisionID+''' and
				(AV5000.VoucherDate Between '''	+convert(nvarchar(10),@FromDate,101)+ ''' and  '''+convert(nvarchar(10),@ToDate,101)+ ''') '
   End
	
   Else	
	-- theo nam
	Begin		
	Set @strWhere ='Where  AV5000.DivisionID = '''+@DivisionID+''' and
				(AV5000.TranMonth + AV5000.TranYear*100 < '+str(@BeginMonth)+' + 100*'+str(@BeginYear)+') '
	
	Set @strWhereFilter ='Where  AV5000.DivisionID = '''+@DivisionID+''' and
				(AV5000.TranMonth + AV5000.TranYear*100 Between '+str(@BeginMonth)+' + 100*'+str(@BeginYear)+' and  '+str(@EndMonth)+' + 100*'+str(@EndYear)+') '
	End

Set @sSQL='Select DivisionID, AccountID,'''' as RecordNo, '''' as TableID, '''' as TransactionTypeID, '''' as VoucherID , '''' as VoucherNo, Null As VoucherDate, 
	N''' + @BeginBalance + ''' as Description, 
	sum(isnull(SignAmount,0)) as ConvertedAmount
From AV5000

	 '+@strWhere+' And (AccountID In (Select AccountID From AV5000 ' + @strWhereFilter + '))	
	Group by DivisionID,AccountID   '

IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE SYSOBJECTS.NAME = 'AV7461' AND SYSOBJECTS.XTYPE = 'V')
	EXEC ('CREATE VIEW AV7461 	--- Created by AP7460
		AS ' + @sSQL)
ELSE
	EXEC ('ALTER VIEW AV7461 	--- Created by AP7460
		 AS ' + @sSQL)


--- Tao view lay so du cuoi
If @IsDate = 0 -- theo ky
Begin
	Set @strWhere ='Where  AV5000.DivisionID = '''+@DivisionID+''' and
				(AV5000.TranMonth + AV5000.TranYear*100 <= '+str(@ToMonth)+' + 100*'+str(@ToYear)+') '

	Set @strWhereFilter ='Where  AV5000.DivisionID = '''+@DivisionID+''' and
				(AV5000.TranMonth + AV5000.TranYear*100 Between '+str(@FromMonth)+' + 100*'+str(@FromYear)+' and  '+str(@ToMonth)+' + 100*'+str(@ToYear)+') '
End

Else
   If @IsDate = 1 -- theo ngay
   Begin	
	Set @strWhere ='Where  AV5000.DivisionID = '''+@DivisionID+''' and
				(AV5000.VoucherDate <= '''	+convert(nvarchar(10),@ToDate,101)+ ''') '

	Set @strWhereFilter ='Where  AV5000.DivisionID = '''+@DivisionID+''' and
				(AV5000.VoucherDate Between '''	+convert(nvarchar(10),@FromDate,101)+ ''' and  '''+convert(nvarchar(10),@ToDate,101)+ ''') '
   End
	
   Else	
	-- theo nam
	Begin		
	Set @strWhere ='Where  AV5000.DivisionID = '''+@DivisionID+''' and
				(AV5000.TranMonth + AV5000.TranYear*100 <= '+str(@EndMonth)+' + 100*'+str(@EndYear)+') '
	
	Set @strWhereFilter ='Where  AV5000.DivisionID = '''+@DivisionID+''' and
				(AV5000.TranMonth + AV5000.TranYear*100 Between '+str(@BeginMonth)+' + 100*'+str(@BeginYear)+' and  '+str(@EndMonth)+' + 100*'+str(@EndYear)+') '
	End

Set @sSQL='Select DivisionID,AccountID,'''' as RecordNo, '''' as TableID, '''' as TransactionTypeID, '''' as VoucherID , '''' as VoucherNo, Null As VoucherDate, 
	N''' + @EndBalance + ''' as Description, 
	sum(isnull(SignAmount,0)) as ConvertedAmount
From AV5000

	 '+@strWhere+' And (AccountID In (Select AccountID From AV5000 ' + @strWhereFilter + '))	
	Group by DivisionID,AccountID   '

IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE SYSOBJECTS.NAME = 'AV7462' AND SYSOBJECTS.XTYPE = 'V')
	EXEC ('CREATE VIEW AV7462 	--- Created by AP7460
		AS ' + @sSQL)
ELSE
	EXEC ('ALTER VIEW AV7462 	--- Created by AP7460
		 AS ' + @sSQL)

IF EXISTS (SELECT 1 FROM SYSOBJECTS WHERE SYSOBJECTS.NAME = 'AV7463' AND SYSOBJECTS.XTYPE = 'V')
	DROP VIEW AV7463

exec ('Create View AV7463 as  -- Create by AP7460

SELECT 1 As Orders, AV5001.AccountID, AV5001.D_C, AV5001.VoucherDate As AV5001_VoucherDate, AV5001.ConvertedAmount As AV5001_ConvertedAmount,
    AV7460.VoucherNo, AV7460.VoucherDate, AV7460.Description, AV7460.ConvertedAmount, AV5001.DivisionID
    , NULL as PageNo,  NULL as RowNo 
FROM
    AV5001 AV5001, AV7460 AV7460 
WHERE
    AV5001.TableID = AV7460.TableID AND AV5001.TransactionTypeID = AV7460.TransactionTypeID AND AV5001.VoucherID = AV7460.VoucherID 

UNION ALL 

Select 1 As Orders, AccountID,(case when min(D_C)=''D'' Then ''C'' Else ''D'' End) As D_C, Null As AV5001_VoucherDate, Null As AV5001_ConvertedAmount, 
Null as VoucherNo, Null As VoucherDate, Null AS Description, Null As ConvertedAmount, B.DivisionID 
, NULL as PageNo,  NULL as RowNo 
From (Select AccountID, D_C, DivisionID From 
	(SELECT AV5001.AccountID, AV5001.D_C, AV5001.VoucherDate As VoucherDate1, 
		AV5001.ConvertedAmount AS ConvertedAmount1, AV7460.VoucherNo, 
		AV7460.VoucherDate, AV7460.Description, AV7460.ConvertedAmount, AV5001.DivisionID 
		FROM AV5001 AV5001, AV7460 AV7460 
		WHERE AV5001.TableID = AV7460.TableID AND AV5001.TransactionTypeID = AV7460.TransactionTypeID AND AV5001.VoucherID = AV7460.VoucherID
	)A Group By AccountID,D_C, DivisionID 
     ) B Group By AccountID, B.DivisionID
Having count(D_C) = 1 

UNION ALL 

SELECT 0 As Orders, AV7461.AccountID, Case When AV7461.ConvertedAmount>=0 Then ''D'' Else ''C'' End As D_C, AV7461.VoucherDate AS AV5001_VoucherDate, 
Case When AV7461.ConvertedAmount>=0 Then AV7461.ConvertedAmount Else AV7461.ConvertedAmount*-1 End As AV5001_ConvertedAmount, 
AV7461.VoucherNo, AV7461.VoucherDate, AV7461.Description, Null As ConvertedAmount, DivisionID 
, NULL as PageNo,  NULL as RowNo 
FROM AV7461

UNION ALL

SELECT 2 As Orders,AV5001.AccountID, AV5001.D_C, Null As AV5001_VoucherDate, Sum(AV5001.ConvertedAmount) As AV5001_ConvertedAmount,
    Null As VoucherNo, Null as VoucherDate, N''' + @Raising + ''' As Description, Null as ConvertedAmount, AV5001.DivisionID
    , NULL as PageNo,  NULL as RowNo 
FROM
    AV5001 AV5001, AV7460 AV7460 
WHERE
    AV5001.TableID = AV7460.TableID AND AV5001.TransactionTypeID = AV7460.TransactionTypeID AND AV5001.VoucherID = AV7460.VoucherID
GROUP BY AV5001.AccountID, AV5001.D_C, AV5001.DivisionID

UNION ALL

SELECT 3 As Orders, AV7462.AccountID, Case When AV7462.ConvertedAmount>=0 Then ''D'' Else ''C'' End As D_C, AV7462.VoucherDate AS AV5001_VoucherDate, 
Case When AV7462.ConvertedAmount>=0 Then AV7462.ConvertedAmount Else AV7462.ConvertedAmount*-1 End As AV5001_ConvertedAmount, 
AV7462.VoucherNo, AV7462.VoucherDate, AV7462.Description, Null As ConvertedAmount, DivisionID 
, NULL as PageNo,  NULL as RowNo 
FROM AV7462')