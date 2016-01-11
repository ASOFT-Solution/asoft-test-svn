IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP1302_AG]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP1302_AG]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- In báo cáo chi tiết sản phẩm theo mẫu Angel
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 30/12/2003 by Bảo Anh
-- <Example> AP1302_AG 'CTY','TES'
---- 

CREATE PROCEDURE [dbo].[AP1302_AG]
				@DivisionID as nvarchar(50), 	
				@InventoryID AS nvarchar(50)			
				
 AS

Declare @KITID AS nvarchar(50),
		@ApportionID AS nvarchar(50),
		@Cur as Cursor,
		@ItemID as nvarchar(50)

--- Trả dữ liệu report chính
SELECT	T02.InventoryID, T02.InventoryName, T02.UnitID, T04.UnitName, T02.Image01ID, T02.QCList,
		T02.CreateDate, T02.CreateUserID, T03.FullName as CreateUserName
FROM AT1302 T02
LEFT JOIN AT1304 T04 On T02.DivisionID = T04.DivisionID and T02.UnitID = T04.UnitID
LEFT JOIN AT1103 T03 On T02.DivisionID = T03.DivisionID and T02.CreateUserID = T03.EmployeeID
WHERE T02.DivisionID = @DivisionID AND T02.InventoryID = @InventoryID

--- Trả dữ liệu sub report 1
SELECT * FROM AT1302_AG WHERE DivisionID = @DivisionID AND InventoryID = @InventoryID AND TypeID = 'QC'

--- Trả dữ liệu sub report 2
SELECT TOP 1 @KITID = KITID FROM AT1326 WHERE DivisionID = @DivisionID AND InventoryID = @InventoryID AND [Disabled] = 0
SELECT T26.ItemID, T02.InventoryName as ItemName, T04.UnitName as ItemUnitName, T26.ItemQuantity, T26.DDescription
FROM AT1326 T26
LEFT JOIN AT1302 T02 On T02.DivisionID = T26.DivisionID and T02.InventoryID = T26.ItemID
LEFT JOIN AT1304 T04 On T02.DivisionID = T04.DivisionID and T02.UnitID = T04.UnitID
WHERE T26.DivisionID = @DivisionID AND T26.KITID = @KITID AND T26.InventoryID = @InventoryID

--- Trả dữ liệu sub report 3
IF EXISTS (SELECT *	FROM tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb.dbo.#TAM')) 
	DROP TABLE #TAM

CREATE TABLE #TAM (	ProductID nvarchar(50),
					MaterialID nvarchar(50),
					RepMaterialID nvarchar(50),
					MaterialGroupID nvarchar(50)
)

SET @Cur = CURSOR SCROLL KEYSET FOR
SELECT ItemID FROM AT1326 WHERE DivisionID = @DivisionID AND KITID = @KITID AND InventoryID = @InventoryID
OPEN @Cur
FETCH NEXT FROM @Cur INTO @ItemID

WHILE @@Fetch_Status = 0 
BEGIN
	SELECT TOP 1 @ApportionID = ApportionID FROM MT1603 WHERE DivisionID = @DivisionID AND ProductID = @ItemID AND ExpenseID = 'COST001'
	
	INSERT INTO #TAM (ProductID,MaterialID,RepMaterialID,MaterialGroupID)
	SELECT MT1603.ProductID, MT1603.MaterialID, MT0007.MaterialID as RepMaterialID,MT0007.MaterialGroupID
	FROM MT1603
	LEFT JOIN MT0007 On MT1603.DivisionID = MT0007.DivisionID AND MT1603.IsExtraMaterial = 1 And MT1603.MaterialGroupID = MT0007.MaterialGroupID
	WHERE MT1603.DivisionID = @DivisionID AND ApportionID = @ApportionID AND ProductID = @ItemID AND ExpenseID = 'COST001'
	
	FETCH NEXT FROM @Cur INTO @ItemID
END

SELECT #TAM.*, T02.InventoryName as ProductName,T03.InventoryName as MaterialName, T04.InventoryName as RepMaterialName
FROM #TAM
LEFT JOIN AT1302 T02 On #TAM.ProductID = T02.InventoryID and T02.DivisionID = @DivisionID
LEFT JOIN AT1302 T03 On #TAM.MaterialID = T03.InventoryID and T03.DivisionID = @DivisionID
LEFT JOIN AT1302 T04 On #TAM.RepMaterialID = T04.InventoryID and T04.DivisionID = @DivisionID

--- Trả dữ liệu sub report 4
SELECT * FROM AT1302_AG WHERE DivisionID = @DivisionID AND InventoryID = @InventoryID AND TypeID = 'PA'

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON