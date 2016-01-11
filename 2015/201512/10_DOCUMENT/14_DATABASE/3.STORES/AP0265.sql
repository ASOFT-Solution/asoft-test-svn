IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0265]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0265]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Created by: Bao Anh
---- Date: 22/08/2012
---- Purpose: Tra ra du lieu cho luoi Master (ke thua nhieu phieu xuat kho - AF0265)
---- Edited by: Bao Anh		Date: 18/12/2012
---- Purpose:	1/ Bo sung Isnull trong dieu kien Where ObjectID
----			2/ Sua lai khi Edit: lay chung tu nhap kho (hien tai dang lay phieu mua hang)
---- Edited by: Bao Anh		Date: 10/01/2013	Where them TableID de loai tru cac phieu xuat kho bán hang
---- Edited by: Bao Anh		Date: 24/09/2013	Cai thien toc do
---- AP0265 N'TL',6,2013,6,2013,'2013-09-24 00:00:00','2013-09-24 00:00:00',0,N'%',N'%',N'','((''''))', '((0 = 0))'

CREATE PROCEDURE [dbo].[AP0265]    @DivisionID nvarchar(50),
				    @FromMonth int,
	  			    @FromYear int,
				    @ToMonth int,
				    @ToYear int,  
				    @FromDate as datetime,
				    @ToDate as Datetime,
				    @IsDate as tinyint, ----0 theo ky, 1 theo ngày
				    @ObjectID nvarchar(50),
				    @WareHouseID NVARCHAR(50),
				    @VoucherID nvarchar(50), --- Addnew: truyen ''; Edit:  so chung tu vua duoc chon sua
					@ConditionOB nvarchar(max),
					@IsUsedConditionOB nvarchar(20)
 AS
Declare
 @sSQL as varchar(max),
 @sWhere  as nvarchar(4000)

IF @IsDate = 0
	Set  @sWhere = '
		And (AT2006.TranMonth + AT2006.TranYear*100 between ' + cast(@FromMonth + @FromYear*100 as nvarchar(50)) + ' and ' +  cast(@ToMonth + @ToYear*100 as nvarchar(50))  + ')'
else
	Set  @sWhere = '
		And (AT2006.VoucherDate  Between '''+Convert(nvarchar(10),@FromDate,21)+''' and '''+convert(nvarchar(10), @ToDate,21)+''')'

IF EXISTS (SELECT *	FROM tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb.dbo.#TAM')) 
	DROP TABLE #TAM

CREATE TABLE #TAM
(
	VoucherID nvarchar(50),
	EndQuantity decimal(28,8)
)

Set  @sSQL = '
INSERT INTO #TAM (VoucherID, EndQuantity)
Select Top 100 percent VoucherID, sum(isnull(EndQuantity,0))
FROM (
Select 
	AT2006.DivisionID, AT2006.TranMonth, AT2006.TranYear, AT2007.VoucherID,
	AT2007.TransactionID, AT2007.InventoryID, AT2007.ActualQuantity,
	(isnull(ActualQuantity, 0) - isnull(ActualQuantityHD,0)) as EndQuantity
From AT2006
inner join AT2007 on AT2007.DivisionID = AT2006.DivisionID and AT2007.VoucherID = AT2006.VoucherID

Left join (
	Select AT2006.DivisionID, AT2006.WOrderID, AT2006.WTransactionID, AT2006.InventoryID, sum(AT2006.Quantity) As ActualQuantityHD
	From AT9000 AT2006
	Where AT2006.DivisionID = ''' + @DivisionID + ''' and Isnull(AT2006.ObjectID,'''') like ''' + @ObjectID + '''
		and isnull(AT2006.WOrderID,'''') <> '''' and AT2006.TransactionTypeID IN (''T04'')
		And (ISNULL(AT2006.ObjectID, ''#'') IN (' + @ConditionOB + ') Or ' + @IsUsedConditionOB + ') ' + @sWhere + '
	Group by AT2006.DivisionID, AT2006.WOrderID, AT2006.InventoryID, AT2006.WTransactionID
	) as K  on AT2006.DivisionID = K.DivisionID and AT2007.DivisionID = K.DivisionID and
			AT2007.VoucherID = K.WOrderID and AT2007.InventoryID = K.InventoryID and
			AT2007.TransactionID = K.WTransactionID	

WHERE AT2006.DivisionID = ''' + @DivisionID + ''' and Isnull(AT2006.ObjectID,'''') like ''' + @ObjectID + '''
 	And AT2006.WarehouseID like ''' + @WareHouseID + ''' AND AT2006.KindVoucherID = 2 And AT2006.TableID = ''AT2006''' + @sWhere + '
	And (ISNULL(AT2006.ObjectID, ''#'') IN (' + @ConditionOB + ') Or ' + @IsUsedConditionOB + ')) A
Where EndQuantity > 0
Group by VoucherID'

EXEC(@sSQL)

if isnull(@VoucherID,'')<> ''	--- khi load edit

	Set  @sSQL ='SELECT * FROM ( 
	Select  top 100 percent AT9000.WOrderID, AT2006.VoucherNo, AT2006.VoucherDate, AT2006.ObjectID, AT1202.ObjectName,AT2006.Description,cast(1 as tinyint) as IsCheck, AT2006.VoucherTypeID, AT2006.DivisionID
	From AT9000
	Inner Join AT2006 On AT9000.WOrderID = AT2006.VoucherID and AT9000.DivisionID = AT2006.DivisionID 
	Left Join AT1202 on AT1202.ObjectID = AT2006.ObjectID and AT1202.DivisionID = AT2006.DivisionID
	Where AT9000.VoucherID = ''' + @VoucherID + ''' And TransactionTypeID = ''T04''
	And  AT9000.DivisionID = ''' + @DivisionID + '''	

	union
	Select AT2006.VoucherID as WOrderID, AT2006.VoucherNo ,AT2006.VoucherDate, AT2006.ObjectID, AT1202.ObjectName,AT2006.Description, cast(0 as tinyint) as IsCheck, AT2006.VoucherTypeID, AT2006.DivisionID
	From AT2006
	Left Join AT1202 on AT1202.ObjectID = AT2006.ObjectID and AT1202.DivisionID = AT2006.DivisionID
	WHERE AT2006.DivisionID = ''' + @DivisionID + ''' AND VoucherID In (Select VoucherID From #TAM Where EndQuantity > 0) 
		and VoucherID not in (Select WOrderID from AT9000 Where DivisionID = ''' + @DivisionID + ''' And AT9000.VoucherID = ''' + @VoucherID + ''' And TransactionTypeID = ''T04'') ' + @sWhere + '
	) A'

else --- khi load add new

Set @sSQL ='SELECT * FROM ( 
	Select AT2006.VoucherID as WOrderID, AT2006.VoucherNo, AT2006.VoucherDate, AT2006.ObjectID, AT1202.ObjectName,AT2006.Description, cast(0 as tinyint) as IsCheck, AT2006.VoucherTypeID, AT2006.DivisionID
	From AT2006
	Left Join AT1202 on AT1202.ObjectID = AT2006.ObjectID and AT1202.DivisionID = AT2006.DivisionID
	WHERE AT2006.DivisionID = ''' + @DivisionID + ''' AND VoucherID In (Select VoucherID From #TAM Where EndQuantity>0) ' + @sWhere + '
	) A'

SET @sSQL = @sSQL + ' ' + 'Order by WOrderID, VoucherDate'

EXEC(@sSQL)