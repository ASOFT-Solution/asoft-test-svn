IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0223]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP0223]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Create by Bảo Anh	Date: 30/10/2013
---- Purpose : Bỏ tính hoa hồng đa cấp (Sinolife)
---- Modify on 11/12/2013 by Bảo Anh: Không xóa khi đơn hàng chưa tính hoa hồng, sửa lỗi khi xóa chưa update cấp và người quản lý
---- Modify on 18/08/2014 by Bảo Anh: Cập nhật người quản lý và giới thiệu khi có trường hợp người giới thiệu lên làm quản lý (dựa vào OT0153)
---- OP0223 'AS',2,2012,'02/01/2012','03/04/2012',1,'%','%','SO/02/2012/0001','SO/03/2012/0001'

CREATE PROCEDURE [dbo].[OP0223]
	@DivisionID nvarchar(50),
	@TranMonth int,
	@TranYear int,
	@FromDate datetime,
	@ToDate datetime,
	@IsDate tinyint,
	@ObjectID varchar(50),
	@SalesmanID varchar(50),
	@FromSOrderID nvarchar(50),
	@ToSOrderID nvarchar(50)
	
AS

DECLARE @SQL nvarchar(4000),
		@sWhere nvarchar(4000),
		@Cur AS cursor,
		@SOrderID nvarchar(50),
		@OrderDate datetime,
		@MaxLevelNo int
		
SELECT @MaxLevelNo = LevelCounts - 1 From AT0000 WHERE DefDivisionID = @DivisionID

IF @IsDate = 0
	Set  @sWhere = 'And (OT2001.TranMonth + OT2001.TranYear*100 = ' + cast(@TranMonth + @TranYear*100 as nvarchar(50)) + ')'
else
	Set  @sWhere = 'And (OT2001.OrderDate Between '''+Convert(nvarchar(10),@FromDate,21)+''' and '''+convert(nvarchar(10), @ToDate,21)+''')'

--- Tạo bảng tạm chứa các đơn hàng cần xóa hoa hồng
IF EXISTS (SELECT *	FROM tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb.dbo.#TAM')) 
	DROP TABLE #TAM

CREATE TABLE #TAM (SOrderID varchar(50),
					OrderDate datetime)

SET @SQL = 'INSERT INTO #TAM (SOrderID, OrderDate)
			SELECT SOrderID, OrderDate FROM OT2001
			WHERE OT2001.DivisionID = ''' + @DivisionID + '''
			AND OT2001.ObjectID like ''' + @ObjectID + ''' AND OT2001.SalesManID like ''' + @SalesmanID + '''' + @sWhere + '
			AND ((OT2001.SOrderID between ''' + @FromSOrderID + ''' And ''' + @ToSOrderID + ''')
			OR (OT2001.SOrderID in (Select OrderID From AT1212 WHERE DivisionID = ''' + @DivisionID + '''
						AND ObjectID in (SELECT ObjectID From AT1212 WHERE DivisionID = ''' + @DivisionID + '''
						And (OrderID between ''' + @FromSOrderID + ''' And ''' + @ToSOrderID + '''))
						AND OrderDate >= (Select top 1 OrderDate From OT2001 Where DivisionID = ''' + @DivisionID + '''
											And (SOrderID between ''' + @FromSOrderID + ''' And ''' + @ToSOrderID + ''') Order by OrderDate))))
			AND OT2001.SOrderID in (Select OrderID From OT0123 Where DivisionID = ''' + @DivisionID + ''')
'
EXEC(@SQL)

SET @Cur = CURSOR SCROLL KEYSET FOR
SELECT DISTINCT SOrderID, OrderDate FROM #TAM Order by OrderDate DESC,SOrderID DESC
	
OPEN @Cur
FETCH NEXT FROM @Cur INTO @SOrderID, @OrderDate
WHILE @@FETCH_STATUS = 0
BEGIN
	--- cập nhật lại người quản lý và người giới thiệu khi có trường hợp người giới thiệu lên làm quản lý
	UPDATE AT1202
	SET ManagerID = (Select top 1 ManagerID From OT0153 Where DivisionID = @DivisionID And OrderID = @SOrderID And SalesmanID = AT1202.ObjectID Order by OrderNo),
		MiddleID = (Select top 1 MiddleID From OT0153 Where DivisionID = @DivisionID And OrderID = @SOrderID And SalesmanID = AT1202.ObjectID Order by OrderNo)
	WHERE DivisionID = @DivisionID AND ObjectID in (Select SalesmanID From OT0153 WHERE DivisionID = @DivisionID And OrderID = @SOrderID)

	--- cập nhật doanh số, cấp, người quản lý của các nhân viên liên quan
	UPDATE AT1202
	SET AccAmount = AccAmount - (Select sum(OrderAmount) From AT1212 Where DivisionID = @DivisionID And OrderID = @SOrderID And ObjectID = AT1202.ObjectID),
		LevelNo = Isnull((Select top 1 LevelNo From AT1212 Where DivisionID = @DivisionID And OrderID = @SOrderID And ObjectID = AT1202.ObjectID Order by OrderDate, OrderID, OrderNo),@MaxLevelNo),
		ManagerID = (Select top 1 ManagerID From AT1212 Where DivisionID = @DivisionID And OrderID = @SOrderID And ObjectID = AT1202.ObjectID Order by OrderDate, OrderID, OrderNo)
	WHERE DivisionID = @DivisionID AND ObjectID in (Select ObjectID From AT1212 WHERE DivisionID = @DivisionID And OrderID = @SOrderID)
		
	--- xóa các bảng liên quan tính hoa hồng
	DELETE OT0133 WHERE DivisionID = @DivisionID
	DELETE OT0143 WHERE DivisionID = @DivisionID
	DELETE AT1212 WHERE DivisionID = @DivisionID AND Isnull(OrderID,'') = @SOrderID
	DELETE OT0123 WHERE DivisionID = @DivisionID AND Isnull(OrderID,'') = @SOrderID
	DELETE OT0153 WHERE DivisionID = @DivisionID AND Isnull(OrderID,'') = @SOrderID
	
	FETCH NEXT FROM @Cur INTO @SOrderID, @OrderDate
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON