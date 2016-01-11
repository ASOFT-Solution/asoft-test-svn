
/****** Object:  StoredProcedure [dbo].[AP7461]    Script Date: 08/02/2010 11:13:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
------ Created by Nguyen Thi Ngoc Minh
------ Date 10/08/2004
------ In So chi phi san xuat, kinh doanh

/********************************************
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
					[Hoang Phuoc] [22/11/2010] Them DivisionID, delete from AT7461 where ObjectID is null or ObjectID=''
----- Modified by Thanh Thịnh on 23/09/2015: Lấy dữ liệu năm từ tháng bắt đầu niên độ TC
'********************************************/

ALTER PROCEDURE [dbo].[AP7461] 	
				@DivisionID as NVARCHAR(50),
				@FromMonth as int,
				@FromYear as int,
				@ToMonth as int,
				@ToYear as int,
				@IsMonth as tinyint,
				@FromInventoryID as NVARCHAR(50),
				@ToInventoryID as NVARCHAR(50),
				@AccountID as NVARCHAR(50),
				@CriteriaID as NVARCHAR(50),
				@FromCriteriaID as NVARCHAR(50),
				@ToCriteriaID as NVARCHAR(50)

 AS
Declare @sSQL as nvarchar(MAX),
	@sSQL1 as nvarchar(4000),
	@strWhere as nvarchar(4000),
	@BeginDate as datetime,
	@EndDate as datetime,
	@CriteriaName as nvarchar(250),
	@sBeginMonth as nvarchar(4000),
	@BeginMonth as int,
	@BeginYear as int,
	@ProductID as NVARCHAR(50),
	@ObjectID as NVARCHAR(50),
	@AT7461_Cursor as cursor,
	
	@sodudauky varchar(20),
	@soducuoiky varchar(20),
	@congphatsinh varchar(20),
	@ghicoTK varchar(20)

set @sodudauky =  'FFML000082'		-- - Số dư đầu kỳ
set @soducuoiky =  'FFML000083'		-- - Số dư cuối kỳ
set @congphatsinh = 'FFML000084'	-- - Cộng phát sinh
set @ghicoTK = 'FFML000085'			-- - Ghi có TK

SET @sBeginMonth = '';

If @IsMonth = 0 -- theo ky
   Begin
	Set @strWhere ='Where  AV5000.DivisionID = '''+@DivisionID+''' and
	(AV5000.TranMonth + AV5000.TranYear*100 Between ' + str(@FromMonth) + ' + 100*' + str(@FromYear) + ' and ' + str(@ToMonth) + ' + 100*' + str(@ToYear) + ') '
	Set @sBeginMonth = 'AV5000.TranMonth + AV5000.TranYear*100 < ' + str(@FromMonth) + ' + 100*' + str(@FromYear)
   End
Else		-- theo nam	
   Begin	
	Set @strWhere ='Where  AV5000.DivisionID = '''+@DivisionID+''' and
	(AV5000.TranMonth + AV5000.TranYear*100 Between ' + str(@FromMonth) + ' + 100*' + str(@FromYear) + ' and ' + str(@ToMonth) + ' + 100*' + str(@ToYear) + ') '
	Set @sBeginMonth = 'AV5000.TranMonth + AV5000.TranYear*100 < ' + str(@FromMonth) + ' + 100*' + str(@FromYear)
   End

Exec AP4700  @CriteriaID, @CriteriaName OUTPUT


Set @sSQL=N'Select  AV5000.DivisionID, VoucherID, VoucherNo, convert(nvarchar(10),VoucherDate,103) as VoucherDate,
	convert(nvarchar(10),AV5000.CreateDate,103) as CreateDate,
	isnull(TDescription,isnull(BDescription,VDescription)) as Description, 
	''' + @AccountID + ''' as AccountID, CorAccountID, AV5000.ProductID, InventoryName, 
	AV5000.ObjectID, ObjectName,
	AV5000.' + @CriteriaName + ' as Criteria,
	(Case when ''' + @CriteriaID + ''' = ''AC'' then AV6666.SelectionID else AV6666.SelectionName end) as SelectionName,
	isnull(ConvertedAmount,0) as ConvertedAmount,
	1 as Orders
From AV5000 left join  AV6666 on  (AV6666.SelectionType =''' + @CriteriaID + ''' and
				 AV6666.SelectionID = AV5000.' + @CriteriaName + ' and AV6666.DivisionID = AV5000.DivisionID )
		inner join AT1302 on AT1302.InventoryID = AV5000.ProductID and AT1302.DivisionID = AV5000.DivisionID
		inner join AT1202 on AT1202.ObjectID = AV5000.ObjectID and AT1202.DivisionID = AV5000.DivisionID
'+@strWhere+' and
	D_C = ''D'' and
	AV5000.AccountID like ''' + @AccountID + '%'' and 
	AV5000.TransactionTypeID <>''T00'' and
	(AV5000.' + @CriteriaName + ' between N''' + @FromCriteriaID + ''' and N''' + @ToCriteriaID + ''') and
	(AV5000.ProductID between N''' + @FromInventoryID + ''' and N''' + @ToInventoryID + ''')
 '

Set @sSQL = @sSQL + N'
Union all
Select AV5000.DivisionID, '''' as VoucherID, '''' as VoucherNo, '''' as VoucherDate, 
	'''' as CreateDate,
	'''+@congphatsinh+''' as Description, '''' as AccountID, '''' as CorAccount, isnull(ProductID,'''') as ProductID, isnull(InventoryName, '''') as InventoryName,
	AV5000.ObjectID, ObjectName, '''' as Criteria, '''' as SelectionName,
	sum(isnull(ConvertedAmount,0)) as ConvertedAmount, 
	2 as Orders
From AV5000	left join AT1202 on AT1202.ObjectID = AV5000.ObjectID and AT1202.DivisionID = AV5000.DivisionID
		left join AT1302 on AT1302.InventoryID = isnull(AV5000.ProductID,'''') and AT1302.DivisionID = AV5000.DivisionID
'+@strWhere+' and
	D_C = ''D'' and
	AV5000.AccountID like ''' + @AccountID + '%'' and 
	AV5000.TransactionTypeID <>''T00'' and
	(AV5000.' + @CriteriaName + ' between N''' + @FromCriteriaID + ''' and N''' + @ToCriteriaID + ''') and
	(AV5000.ProductID between N''' + @FromInventoryID + ''' and N''' + @ToInventoryID + ''')
Group by AV5000.DivisionID, AV5000.ObjectID, ObjectName, isnull(AV5000.ProductID,''''), isnull(InventoryName,'''')
'
 

Set @sSQL = @sSQL + N'
Union all
Select AV5000.DivisionID, '''' as VoucherID, '''' as VoucherNo, '''' as VoucherDate, '''' as CreateDate,
	'''+@sodudauky+''' as Description, '''' as AccountID, 
	'''' as CorAccount, isnull(ProductID,'''') as ProductID, isnull(InventoryName, '''') as InventoryName,
	AV5000.ObjectID, ObjectName, '''' as Criteria, '''' as SelectionName,
	sum(isnull(SignAmount,0)) as ConvertedAmount, 
	0 as Orders
From AV5000	left join AT1202 on AT1202.ObjectID = AV5000.ObjectID and AT1202.DivisionID = AV5000.DivisionID
		left join AT1302 on AT1302.InventoryID = isnull(AV5000.ProductID,'''') and AT1302.DivisionID = AV5000.DivisionID
Where AT1302.DivisionID = ''' + @DivisionID + ''' and
	AV5000.AccountID like ''' + @AccountID + '%'' and 
	(TransactionTypeID = ''T00'' or
	' + @sBeginMonth + ')
	--TranMonth + TranYear * 100 < ' + ltrim(str(@FromMonth + @FromYear * 100)) + ')	
Group by AV5000.DivisionID, AV5000.ObjectID, ObjectName, isnull(AV5000.ProductID,''''), isnull(InventoryName,'''')
'



Set @sSQL = @sSQL + N'
Union all
Select AV5000.DivisionID, '''' as VoucherID, '''' as VoucherNo, '''' as VoucherDate, 
	'''' as CreateDate,
	'''+@ghicoTK+''' as Description, '''' as AccountID, '''' as CorAccount, isnull(ProductID,'''') as ProductID, isnull(InventoryName, '''') as InventoryName,
	AV5000.ObjectID, ObjectName, '''' as Criteria, '''' as SelectionName,
	sum(isnull(SignAmount,0)) as ConvertedAmount, 
	3 as Orders
From AV5000	left join AT1202 on AT1202.ObjectID = AV5000.ObjectID and AT1202.DivisionID = AV5000.DivisionID
		left join AT1302 on AT1302.InventoryID = isnull(AV5000.ProductID,'''') and AT1302.DivisionID = AV5000.DivisionID
'+@strWhere+' and
	D_C = ''C'' and
	AV5000.AccountID like ''' + @AccountID + '%'' and 
	AV5000.TransactionTypeID <>''T00'' 
Group by AV5000.DivisionID, AV5000.ObjectID, ObjectName, isnull(AV5000.ProductID,''''), isnull(InventoryName,'''')--14
'



Set @sSQL = @sSQL + N'
Union all
Select AV5000.DivisionID, '''' as VoucherID, '''' as VoucherNo, '''' as VoucherDate, '''' as CreateDate,
	'''+@soducuoiky+''' as Description, '''' as AccountID, '''' as CorAccount, isnull(ProductID,'''') as ProductID, isnull(InventoryName, '''') as InventoryName,
	AV5000.ObjectID, ObjectName, '''' as Criteria, '''' as SelectionName,
	sum(isnull(SignAmount,0)) as ConvertedAmount, 
	4 as Orders
From AV5000	left join AT1202 on AT1202.ObjectID = AV5000.ObjectID and AT1202.DivisionID = AV5000.DivisionID
		left join AT1302 on AT1302.InventoryID = isnull(AV5000.ProductID,'''') and AT1302.DivisionID = AV5000.DivisionID
' + @strWhere + ' and
	AV5000.AccountID like ''' + @AccountID + '%''
Group by AV5000.DivisionID, AV5000.ObjectID, ObjectName, isnull(AV5000.ProductID,''''), isnull(InventoryName,'''')--13
'



--Print @sSQL1
--print @sSQL1
--print @soducuoiky -- @soducuoiky
--print @strWhere --@strWhere
--print @AccountID --@AccountID



If not Exists (Select top 1 1  From SysObjects Where Name ='AT7461' and Xtype ='U')
Begin
CREATE TABLE [dbo].[AT7461](
	[APK] [uniqueidentifier] NOT NULL,
	[DivisionID] [nvarchar](3) NOT NULL,
	[VoucherID] [nvarchar](50) NULL,
	[VoucherNo] [nvarchar](50) NULL,
	[VoucherDate] [datetime] NULL,
	[CreateDate] [datetime] NULL,
	[Description] [nvarchar](250) NULL,
	[AccountID] [nvarchar](50) NULL,
	[CorAccountID] [nvarchar](50) NULL,
	[ProductID] [nvarchar](50) NULL,
	[InventoryName] [nvarchar](250) NULL,
	[ObjectID] [nvarchar](50) NULL,
	[ObjectName] [nvarchar](250) NULL,
	[Criteria] [nvarchar](100) NULL,
	[SelectionName] [nvarchar](250) NULL,
	[ConvertedAmount] [decimal](28, 8) NULL,
	[Orders] [tinyint] NULL,
 CONSTRAINT [PK_AT7461] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[AT7461] ADD  DEFAULT (newid()) FOR [APK]

End
Else
  Delete  AT7461

Exec ( 'Insert into AT7461  (DivisionID, VoucherID, VoucherNo, VoucherDate, CreateDate, Description, 
			AccountID, CorAccountID, ProductID, InventoryName, ObjectID,
			ObjectName, Criteria, SelectionName, ConvertedAmount, Orders) ' + @sSQL )

Set @sSQL = ''
--hoangphuoc
delete from AT7461 where ObjectID is null or ObjectID=''

SET @AT7461_Cursor = CURSOR SCROLL KEYSET FOR
		SELECT distinct ObjectID, ProductID
		FROM AT7461 WHERE DivisionID = @DivisionID

OPEN @AT7461_Cursor
FETCH NEXT FROM @AT7461_Cursor INTO  @ObjectID, @ProductID

WHILE @@FETCH_STATUS = 0
  BEGIN
	Set @sSQL = ''
	If not Exists (Select top 1 1  From AT7461 Where ObjectID = @ObjectID and ProductID = @ProductID and Orders = 0 AND DivisionID = @DivisionID)
	  Begin
		 Set @sSQL = 'Select '''+@DivisionID+ ''' as DivisionID, '''' as VoucherID, '''' as VoucherNo, '''' as VoucherDate,
		'''' as CreateDate,
		'''+@sodudauky+'''  as Description, 
		'''' as AccountID, '''' as CorAccountID, 
		''' + @ProductID + ''' as ProductID, '''' as InventoryName, 
		''' + @ObjectID + ''' as ObjectID, '''' as ObjectName,
		'''' as Criteria,
		'''' as SelectionName,
		0 as ConvertedAmount,
		0 as Orders '
		Exec ( 'Insert into AT7461  (DivisionID, VoucherID, VoucherNo, VoucherDate, CreateDate, Description, 
					AccountID, CorAccountID, ProductID, InventoryName, ObjectID,
					ObjectName, Criteria, SelectionName, ConvertedAmount, Orders) ' + @sSQL)
	   End
	   
	   --print @sSQL
	If not Exists (Select top 1 1  From AT7461 Where ObjectID = @ObjectID and ProductID = @ProductID and Orders = 2)
	   Begin
		Set @sSQL = 'Select '''+@DivisionID+''' as DivisionID,'''' as VoucherID, '''' as VoucherNo, '''' as VoucherDate,
		'''' as CreateDate,
		'''+@congphatsinh+'''  as Description, 
		'''' as AccountID, '''' as CorAccountID,
			''' + @ProductID + ''' as ProductID, '''' as InventoryName, 
		''' + @ObjectID + ''' as ObjectID, '''' as ObjectName,
		'''' as Criteria,
		'''' as SelectionName,
		0 as ConvertedAmount,
		2 as Orders '
		Exec ( 'Insert into AT7461  (DivisionID, VoucherID, VoucherNo, VoucherDate, CreateDate, Description, 
					AccountID, CorAccountID, ProductID, InventoryName, ObjectID,
					ObjectName, Criteria, SelectionName, ConvertedAmount, Orders) ' + @sSQL)
	   End
	If not Exists (Select top 1 1  From AT7461 Where ObjectID = @ObjectID and ProductID = @ProductID and Orders = 3)
	   Begin
	   	Set @sSQL = N'Select '''+@DivisionID+''' as DivisionID, '''' as VoucherID, '''' as VoucherNo, '''' as VoucherDate,
		'''' as CreateDate,
		'''+@ghicoTK+''' as Description, 
		'''' as AccountID, '''' as CorAccountID, 
		''' + @ProductID + ''' as ProductID, '''' as InventoryName, 
		''' + @ObjectID + ''' as ObjectID, '''' as ObjectName,
		'''' as Criteria,
		'''' as SelectionName,
		0 as ConvertedAmount,
		3 as Orders '
		Exec ( 'Insert into AT7461  (DivisionID, VoucherID, VoucherNo, VoucherDate, CreateDate, Description, 
					AccountID, CorAccountID, ProductID, InventoryName, ObjectID,
					ObjectName, Criteria, SelectionName, ConvertedAmount, Orders) ' + @sSQL)
					--print @sSQL
	   End
	If not Exists (Select top 1 1  From AT7461 Where ObjectID = @ObjectID and ProductID = @ProductID and Orders = 4)
	   Begin
		Set @sSQL = 'Select '''+@DivisionID+''' as DivisionID, '''' as VoucherID, '''' as VoucherNo, '''' as VoucherDate, '''' as CreateDate,
		'''+@soducuoiky+''' as Description, '''' as AccountID, '''' as CorAccount, 
		''' + @ProductID + ''' as ProductID, '''' as InventoryName, 
		''' + @ObjectID + ''' as ObjectID, '''' as ObjectName,
		'''' as Criteria, '''' as SelectionName,
		sum(isnull(SignAmount,0)) as ConvertedAmount, 
		4 as Orders
		From AV5000	left join AT1202 on AT1202.ObjectID = AV5000.ObjectID
			left join AT1302 on AT1302.InventoryID = isnull(AV5000.ProductID,'''')
		' + @strWhere + ' and
		(AV5000.AccountID like ''' + @AccountID + '%'' or AV5000.CorAccountID like ''' + @AccountID + '%'') and
		AV5000.ObjectID = ''' + @ObjectID + ''' and
		ProductID = ''' + @ProductID + ''''
		Exec ( 'Insert into AT7461  (DivisionID, VoucherID, VoucherNo, VoucherDate, CreateDate, Description, 
					AccountID, CorAccountID, ProductID, InventoryName, ObjectID,
					ObjectName, Criteria, SelectionName, ConvertedAmount, Orders) ' + @sSQL)
					
					--print @sSQL
	   End
	FETCH NEXT FROM @AT7461_Cursor INTO  @ObjectID, @ProductID
  END

CLOSE @AT7461_Cursor
DEALLOCATE @AT7461_Cursor

--hoangphuoc
update AT7461 set CreateDate=null, VoucherDate=null
where CreateDate = '1900-01-01'