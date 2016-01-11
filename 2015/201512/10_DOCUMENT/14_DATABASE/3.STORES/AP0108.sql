IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0158]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0158]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--- Created by Bảo Anh	Date: 06/01/2016
--- Purpose: Tính định mức tồn kho hàng hóa (customize Angel)
--- AP0158 'AS','SO/03/2012/0001','88f41e99-203e-4b6e-b7d7-52b4af5e7cb7'

CREATE PROCEDURE [dbo].[AP0158]  
				@DivisionID nvarchar(50),
				@TranMonth tinyint,
				@TranYear tinyint,
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

--- lấy số lượng bán ra của 2 tháng trước
SELECT T90.InventoryID, T90.Quantity
FROM AT9000 T90
WHERE T90.DivisionID = @DivisionID And T90.TransactionTypeID = 'T04' AND (T90.InventoryID between @FromInventoryID and @ToInventoryID)
and (T90.TranMonth + 100*T90.TranYear between @TranMonth + 100*@TranYear - 2 and @TranMonth + 100*@TranYear - 1)

SELECT 	@DivisionID as DivisionID, @TranMonth as TranMonth, @TranYear as TranYear, @FromDate as FromDate, @ToDate as ToDate,
		newid() as InventoryNormID,	AT1302.InventoryID, Isnull(AT2008.WareHouseID,'%') as WareHouseID,
		 (	Select sum(Isnull(Quantity,0))
			From AT9000
			Inner join AT2006 On AT9000.DivisionID = AT2006.DivisionID And AT9000.VoucherID = AT2006.VoucherID
			Where AT9000.DivisionID = AT1302.DivisionID And AT9000.TransactionTypeID = 'T04' and AT9000.InventoryID = AT1302.InventoryID
			and (AT9000.TranMonth + 100*AT9000.TranYear between @TranMonth + 100*@TranYear - 2 and @TranMonth + 100*@TranYear - 1)
			and AT2006.WarehouseID like Isnull(AT2008.WarehouseID,'%')) as SaleQuantity
INTO #TAM
FROM AT1302
LEFT JOIN AT2008 On AT1302.DivisionID = AT2008.DivisionID And AT1302.InventoryID = AT2008.InventoryID
WHERE AT1302.DivisionID = @DivisionID AND AT1302.Disabled = 0 AND (AT1302.InventoryID between @FromInventoryID and @ToInventoryID)
AND AT2008.WarehouseID like @WarehouseID

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
'UPDATE	AT1314 SET ReOrderQuantity = ' + Replace(@ReOderQtyFormula,'@MinQuantity','MinQuantity')
EXEC(@sSQL)