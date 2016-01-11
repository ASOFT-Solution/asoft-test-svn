IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0158]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0158]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--- Created by Bảo Anh	Date: 06/01/2016
--- Purpose: Tính định mức tồn kho hàng hóa (customize Angel)
--- AP0158 'CTY',11,2013,'11/01/2013','11/30/2013','01CX01','ZZZ','%','@Amount*120/100/4','@MinQuantity*1.1',''

CREATE PROCEDURE [dbo].[AP0158]  
				@DivisionID nvarchar(50),
				@TranMonth int,
				@TranYear int,
				@FromDate datetime,
				@ToDate datetime,
				@FromInventoryID nvarchar(50),
				@ToInventoryID nvarchar(50),
				@WarehouseID nvarchar(50),
				@MinQtyFormula varchar(100),
				@ReOderQtyFormula varchar(100),
				@UserID nvarchar(50)
AS

Declare @sSQL AS nvarchar(4000)

DELETE AT1314 WHERE DivisionID = @DivisionID AND TranMonth = @TranMonth AND TranYear = @TranYear
AND (FromDate >= @FromDate And ToDate <= @ToDate) AND (InventoryID between @FromInventoryID and @ToInventoryID)
AND WarehouseID like @WarehouseID

SELECT 	@DivisionID as DivisionID, @TranMonth as TranMonth, @TranYear as TranYear, @FromDate as FromDate, @ToDate as ToDate,
		newid() as InventoryNormID,	T90.InventoryID, Isnull(T06.WareHouseID,'%') as WareHouseID,
		sum(Isnull(Quantity,0)) as SaleQuantity
INTO #TAM
FROM AT9000 T90
INNER JOIN AT2006 T06 On T90.DivisionID = T06.DivisionID And T90.WOrderID = T06.VoucherID
WHERE T90.DivisionID = @DivisionID AND (T90.InventoryID between @FromInventoryID and @ToInventoryID)
And T90.TransactionTypeID = 'T04' and (T90.TranMonth + 100*T90.TranYear between @TranMonth + 100*@TranYear - 2 and @TranMonth + 100*@TranYear - 1)
AND T06.WareHouseID like @WarehouseID
GROUP BY T90.InventoryID, Isnull(T06.WareHouseID,'%')

--- Tính mức tối thiểu
SET @sSQL = 
'INSERT INTO AT1314 (DivisionID, TranMonth, TranYear, FromDate, ToDate, InventoryNormID, InventoryID, WareHouseID,
					MinQuantity, CreateUserID, CreateDate, LastModifyUserID, LastModifyDate)
		
SELECT	DivisionID, TranMonth, TranYear, FromDate, ToDate, InventoryNormID, InventoryID, WareHouseID,
		(' + Replace(@MinQtyFormula,'@Amount','SaleQuantity') + ') as MinQuantity,''' + @UserID + ''',getdate(),''' + @UserID + ''',getdate()
FROM #TAM
'
EXEC(@sSQL)

--- Tính mức đặt hàng lại
SET @sSQL = 
'UPDATE	AT1314 SET ReOrderQuantity = ' + Replace(@ReOderQtyFormula,'@MinQuantity','MinQuantity') + '
WHERE DivisionID = ''' + @DivisionID + ''' AND TranMonth = ' + ltrim(@TranMonth) + ' AND TranYear = ' + ltrim(@TranYear) + '
AND (convert(nvarchar(20),FromDate,103) >= ''' + convert(nvarchar(20),@FromDate,103) + ''' And convert(nvarchar(20),ToDate,103) <= ''' + convert(nvarchar(20),@ToDate,103) + ''')
AND (InventoryID between ''' + @FromInventoryID + ''' and ''' + @ToInventoryID + ''') AND WarehouseID like ''' + @WarehouseID + ''''
EXEC(@sSQL)