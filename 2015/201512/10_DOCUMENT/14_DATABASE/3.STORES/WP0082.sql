IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WP0082]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[WP0082]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Báo cáo tuổi hàng tồn kho
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 03/12/2012 by Lê Thị Thu Hiền 
---- 
---- Modified on 25/07/2013 by Lê Thị Thu Hiền : Sửa lỗi Font chữ Title
---- Modified on 29/07/2013 by Khánh Vân: Lấy tồn kho âm
---- Modified on 15/09/2015 by Quốc Tuấn: Thay đổi KindVoucherID và thêm kiểm tra ToDate Null thì lấy hết
-- <Example>
---- 
    
CREATE PROCEDURE WP0082
( 
		@DivisionID AS NVARCHAR(50),
		@ReportCode AS NVARCHAR(50),
		@FromInventoryID AS NVARCHAR(50),
		@ToInventoryID AS NVARCHAR(50),
		@FromWareHouseID AS NVARCHAR(50),
		@ToWareHouseID AS NVARCHAR(50),
		@IsTimes AS INT ,	-- 0 : ky
							-- 1 : ngay
		@TranMonth AS INT,
		@TranYear AS INT,
		@Date AS DATETIME
) 
AS 

DECLARE @sSQL1 AS NVARCHAR(4000),
		@sSQL2 AS NVARCHAR(4000),
		@sSQL3 AS NVARCHAR(4000),
		@sSQL4 AS NVARCHAR(4000),
		@sSQL5 AS NVARCHAR(4000),
		@sSQL6 AS NVARCHAR(4000),
		@sSQL7 AS NVARCHAR(4000),
		@sSQL71 AS NVARCHAR(4000),
		@sSQL72 AS NVARCHAR(4000),
		@sSQL8 AS NVARCHAR(4000)
		
SET @sSQL7 = ''
SET @sSQL71 = ''
SET @sSQL72 = ''

		
IF @IsTimes = 1
	BEGIN
		SET @TranMonth = Month(@Date)
		SET @TranYear = Year(@Date)
	END
ELSE
	BEGIN
		SELECT @Date = EndDate FROM WT9999 WHERE DivisionID = @DivisionID AND TranMonth = @TranMonth AND TranYear =@TranYear
	END

--------- Lấy số lượng nhập vào

SET @sSQL1 = N'
SELECT	B.VoucherDate,	A.DivisionID,
		A.InventoryID,	A.UnitID, 
		SUM(Isnull(A.ActualQuantity,0)) AS Quantity, CAST(0 as Decimal(28,8)) AS ExportQuantity,
		(Case When SUM(Isnull(A.ActualQuantity,0))<>0 Then Round((SUM(Isnull(A.ConvertedAmount,0))/SUM(Isnull(A.ActualQuantity,0))),2) Else 0 End) As UnitPrice, 
		SUM(Isnull(A.ConvertedAmount,0)) AS ConvertedAmount
INTO	#Import
FROM	(SELECT DivisionID, VoucherID, InventoryID, UnitID, ActualQuantity, ConvertedAmount FROM AT2017 Union All SELECT DivisionID, VoucherID, InventoryID, UnitID, ActualQuantity, ConvertedAmount FROM AT2007) A
LEFT JOIN (SELECT DivisionID, 1 As KindVoucherID, WareHouseID, VoucherID, VoucherDate, TranMonth, TranYear FROM AT2016 Union All SELECT DivisionID, KindVoucherID, WareHouseID, VoucherID, VoucherDate, TranMonth, TranYear FROM AT2006) B 
	ON		B.VoucherID = A.VoucherID AND B.DivisionID = A.DivisionID
WHERE	B.KindVoucherID IN (1, 5,3,7,9)
		AND A.DivisionID = '''+@DivisionID+''' 
		AND A.InventoryID BETWEEN '''+@FromInventoryID+''' AND '''+@ToInventoryID+''' 
		AND B.WareHouseID BETWEEN '''+@FromWareHouseID+''' AND '''+@ToWareHouseID+''' 
		'
IF @IsTimes = 0		
		SET @sSQL1 = @sSQL1 + N' AND B.TranMonth + B.TranYear*12 <= ' + LTRIM(@TranMonth + @TranYear*12)
ELSE
		SET @sSQL1 = @sSQL1 + N' AND B.VoucherDate <= ''' + LTRIM(@Date) + ''' '
		
SET @sSQL1 = @sSQL1	+ N' 
GROUP BY A.DivisionID, B.VoucherDate, A.InventoryID, A.UnitID
ORDER BY A.DivisionID, A.InventoryID, A.UnitID, B.VoucherDate
'
------ Lấy số lượng xuất ra
SET @sSQL2 = N'
SELECT	B.VoucherDate, A.DivisionID,	A.InventoryID, A.UnitID, 
		CAST(0 as Decimal(28,8)) AS Quantity, SUM(Isnull(A.ActualQuantity,0)) AS ExportQuantity,
		(Case When SUM(Isnull(A.ActualQuantity,0))<>0 Then Round((SUM(Isnull(A.ConvertedAmount,0))/SUM(Isnull(A.ActualQuantity,0))),2) Else 0 End) As UnitPrice, 
		SUM(Isnull(A.ConvertedAmount,0)) AS ConvertedAmount
INTO	#Export
FROM	AT2007 A
LEFT JOIN AT2006 B ON B.VoucherID = A.VoucherID AND B.DivisionID = A.DivisionID
WHERE	B.KindVoucherID IN (2, 4,3,6,8,10)
		AND A.DivisionID = '''+@DivisionID+''' 
		AND A.InventoryID BETWEEN '''+@FromInventoryID+''' AND '''+@ToInventoryID+''' 
		AND (Case when B.KindVoucherID=3 then B.WareHouseID2 else B.WareHouseID end) BETWEEN '''+@FromWareHouseID+''' AND '''+@ToWareHouseID+''' 
		'
IF @IsTimes = 0		
		SET @sSQL2 = @sSQL2 + N' AND B.TranMonth + B.TranYear*12 <= ' + LTRIM(@TranMonth + @TranYear*12)
ELSE
		SET @sSQL2 = @sSQL2 + N' AND B.VoucherDate <= ''' + LTRIM(@Date) + ''' '
		
SET @sSQL2 = @sSQL2	+ N' 
GROUP BY  B.VoucherDate, A.DivisionID, A.InventoryID, A.UnitID
'

SET @sSQL3 = N'
CREATE TABLE #BAOCAO
(
	ImportVoucherDate Datetime,
	ExportVoucherDate Datetime,
	InventoryID NVARCHAR(50)  COLLATE database_default,
	InventoryName NVARCHAR(250)  COLLATE database_default,
	UnitID NVARCHAR(50)  COLLATE database_default,
	I01ID NVARCHAR(50), 
	AnaName NVARCHAR(50), 
	UnitPrice DECIMAL(28,8) ,
	Title1 NVARCHAR(50),
	Title2 NVARCHAR(50),
	Title3 NVARCHAR(50),
	Title4 NVARCHAR(50),
	Title5 NVARCHAR(50),
	Title6 NVARCHAR(50),
	Title7 NVARCHAR(50),
	Title8 NVARCHAR(50),
	Title9 NVARCHAR(50),
	Title10 NVARCHAR(50),
	EndQuantity1 DECIMAL(28,8),
	EndQuantity2 DECIMAL(28,8),
	EndQuantity3 DECIMAL(28,8),
	EndQuantity4 DECIMAL(28,8),
	EndQuantity5 DECIMAL(28,8),
	EndQuantity6 DECIMAL(28,8),
	EndQuantity7 DECIMAL(28,8),
	EndQuantity8 DECIMAL(28,8),
	EndQuantity9 DECIMAL(28,8),	
	EndQuantity10 DECIMAL(28,8)
	
)

INSERT INTO #BAOCAO
SELECT		
		Null as ImportVoucherDate,
		Null as ExportVoucherDate,
		InventoryID, InventoryName, UnitID,I01ID, AnaName,
		0 AS UnitPrice,
		N'''' AS Title1,
		N'''' AS Title2,
		N'''' AS Title3,
		N'''' AS Title4,
		N'''' AS Title5,
		N'''' AS Title6,
		N'''' AS Title7,
		N'''' AS Title8,
		N'''' AS Title9,
		N'''' AS Title10,
		0 AS EndQuantity1,
		0 AS EndQuantity2,
		0 AS EndQuantity3,
		0 AS EndQuantity4,
		0 AS EndQuantity5,
		0 AS EndQuantity6,
		0 AS EndQuantity7,
		0 AS EndQuantity8,
		0 AS EndQuantity9,
		0 AS EndQuantity10
FROM	AT1302 left join AT1015 on AT1302.I01ID = AT1015.AnaID and AT1302.DivisionID = AT1015.DivisionID and AT1015.AnaTypeID=''I01''
WHERE	AT1302.DivisionID = '''+@DivisionID+'''
		AND InventoryID BETWEEN '''+@FromInventoryID+''' AND '''+@ToInventoryID+'''
'

--Add by: Bao Quynh; Date 09/05/2013, Bo sung tinh don gia = don gia xuat binh quan
SET @sSQL4 = N'
CREATE TABLE #UNION
(
	ImportVoucherDate Datetime,
	ExportVoucherDate Datetime,
	VoucherDate Datetime,
	DivisionID NVARCHAR(50),
	InventoryID NVARCHAR(50),
	UnitID NVARCHAR(50),
	Quantity DECIMAL(28,8),
	ExportQuantity DECIMAL(28,8),
	UnitPrice DECIMAL(28,8),
	ConvertedAmount DECIMAL(28,8)
)
INSERT INTO #UNION
select Null as ImportVoucherDate, Null as ExportVoucherDate, * From #Import 
INSERT INTO #UNION
select Null as ImportVoucherDate, Null as ExportVoucherDate,* from #Export 


'

DECLARE @AgeStepID AS NVARCHAR(50),
		@AgeCur CURSOR,
		@Orders tinyint,
		@FromDay INT,
		@ToDay INT, 
		@Title nvarchar(250)
		
SET @AgeStepID  = (SELECT AgeStepID FROM WT4710 WHERE ReportCode = @ReportCode AND DivisionID = @DivisionID)

SET @AgeCur = CURSOR SCROLL KEYSET FOR
SELECT	Orders,FromDay,ToDay , Title 
FROM	AT1317 
WHERE	AgeStepID = @AgeStepID  AND DivisionID = @DivisionID
ORDER BY Orders

OPEN @AgeCur
FETCH NEXT FROM @AgeCur INTO @Orders,@FromDay,@ToDay , @Title 
SET @sSQL5 = N'
	SELECT	ImportVoucherDate, ExportVoucherDate, InventoryID, UnitID, Sum(Isnull(Quantity,0)) as Quantity, Sum(Isnull(ExportQuantity,0)) as ExportQuantity, Sum(Isnull(Quantity,0))- Sum(Isnull(ExportQuantity,0)) AS EndQuantity, Sum(Isnull(Quantity,0))- Sum(Isnull(ExportQuantity,0)) AS Remain 
	INTO	#Temp1
	FROM	#UNION   
	GROUP BY ImportVoucherDate, ExportVoucherDate,InventoryID, UnitID
	
	Update U
		set U.ImportVoucherDate = I.VoucherDate
		From #Temp1 U left join (Select InventoryID, UnitID, Max(VoucherDate)as VoucherDate from #Import group by inventoryid, unitid)I 
		on U.inventoryid = I.InventoryID and U.UnitID = I.UnitID

	Update U
		set U.ExportVoucherDate = I.VoucherDate
		From #Temp1 U left join (Select InventoryID, UnitID, Max(VoucherDate)as VoucherDate from #Export group by inventoryid, unitid)I 
		on U.inventoryid = I.InventoryID and U.UnitID = I.UnitID
	
	
	'
SET @sSQL6 = N'
	DECLARE @FromDate DATETIME,
		@ToDate DATETIME,
		@TempQuantity DECIMAL(28,8)'
WHILE @@Fetch_Status = 0
BEGIN
	IF ISNULL(@ToDay,0) >0
		SET @sSQL6 = @sSQL6+N'
		SELECT	InventoryID, UnitID, Sum(Isnull(Quantity,0)) as Quantity, Sum(Isnull(ExportQuantity,0))as ExportQuantity, Sum(Isnull(Quantity,0))- Sum(Isnull(ExportQuantity,0)) AS EndQuantity
		INTO	#SUM'+CONVERT(VARCHAR(1),@Orders)+'
		FROM	#UNION   
		WHERE	DATEDIFF(Day,CONVERT(DATETIME,VoucherDate, 103), ''' + LTRIM(@Date) + ''') BETWEEN '+STR(@FromDay)+' AND '+STR(@ToDay)+' 
		GROUP BY InventoryID, UnitID'
	ELSE 
		SET @sSQL6 = @sSQL6+N'
		SELECT	InventoryID, UnitID, Sum(Isnull(Quantity,0)) as Quantity, Sum(Isnull(ExportQuantity,0))as ExportQuantity, Sum(Isnull(Quantity,0))- Sum(Isnull(ExportQuantity,0)) AS EndQuantity
		INTO	#SUM'+CONVERT(VARCHAR(1),@Orders)+'
		FROM	#UNION   
		WHERE	DATEDIFF(Day,CONVERT(DATETIME,VoucherDate, 103), ''' + LTRIM(@Date) + ''') > '+STR(@FromDay)+'
		GROUP BY InventoryID, UnitID'
	
	
	SET @sSQL7=@sSQL7+ N'		
	
	UPDATE S
	SET		S.EndQuantity = 0
	FROM #SUM'+CONVERT(VARCHAR(1),@Orders)+' S inner join #Temp1 T
	ON S.InventoryID = T.InventoryID AND S.UnitID = T.UnitID where T.EndQuantity <= 0
	
	UPDATE S
	SET		S.EndQuantity = (Case when (T.Remain <=0 or S.Quantity <= 0) then 0 when (T.Remain>S.Quantity) then S.Quantity else T.Remain end)
	FROM #SUM'+CONVERT(VARCHAR(1),@Orders)+' S inner join #Temp1 T
	ON S.InventoryID = T.InventoryID AND S.UnitID = T.UnitID where T.EndQuantity > 0
	
	--UPDATE S
	--SET		S.EndQuantity = (Case when (S.EndQuantity >= 0) then 0 when (T.Remain<S.EndQuantity) then S.EndQuantity else T.Remain end)
	--FROM #SUM'+CONVERT(VARCHAR(1),@Orders)+' S inner join #Temp1 T
	--ON S.InventoryID = T.InventoryID AND S.UnitID = T.UnitID where T.EndQuantity < 0
	
	UPDATE T
	SET		T.Remain = T.Remain - S.EndQuantity
	FROM #SUM'+CONVERT(VARCHAR(1),@Orders)+' S inner join #Temp1 T
	ON S.InventoryID = T.InventoryID AND S.UnitID = T.UnitID
	'
	
	SET @sSQL71=@sSQL71+ N'	
	UPDATE B
	SET		B.Title'+CONVERT(VARCHAR(1),@Orders)+' = N'''+@Title+'''
	FROM	#BAOCAO B
	
	UPDATE B
	SET		B.EndQuantity'+CONVERT(VARCHAR(1),@Orders)+' = S.EndQuantity
	FROM	#BAOCAO B
	INNER JOIN #SUM'+CONVERT(VARCHAR(1),@Orders)+' S ON S.InventoryID = B.InventoryID AND S.UnitID = B.UnitID'	
	SET @sSQL72=@sSQL72+ N'
	UPDATE B
	SET B.UnitPrice = (CASE WHEN E.EndQuantity <= 0 THEN 0 ELSE ROUND(EndAmount/EndQuantity,6) END) 
	FROM #BAOCAO B 
	LEFT JOIN 
	(SELECT	InventoryID, SUM(ISNULL(EndQuantity,0)) AS EndQuantity, SUM(ISNULL(EndAmount,0)) AS EndAmount 
		FROM	AT2008
		WHERE	DivisionID = ''' + @DivisionID + ''' 
				AND TranMonth = ' + LTRIM(@TranMonth) + ' 
				AND TranYear = ' + LTRIM(@TranYear) + ' 
				AND WareHouseID BETWEEN '''+@FromWareHouseID+''' AND '''+@ToWareHouseID+''' 
		GROUP BY InventoryID) E
	ON B.InventoryID = E.InventoryID
	
	UPDATE B
	SET B.ImportVoucherDate = T.ImportVoucherDate,  B.ExportVoucherDate = T.ExportVoucherDate
	FROM #BAOCAO B 
	LEFT JOIN #Temp1 T on 
	B.InventoryID = T.InventoryID and B.UnitID = T.UnitID
	'

	FETCH NEXT FROM @AgeCur INTO @Orders,@FromDay,@ToDay , @Title 
END

SET @sSQL8 =  N'
SELECT * FROM #BAOCAO'




EXEC (@sSQL1+@sSQL2+@sSQL3+@sSQL4+@sSQL5+@sSQL6+@sSQL7+@sSQL71+@sSQL72+@sSQL8)

--PRINT @sSQL1
--PRINT @sSQL2
--PRINT @sSQL3
--PRINT @sSQL4
--PRINT @sSQL5
--PRINT @sSQL6
--PRINT @sSQL7
--PRINT @sSQL71
--PRINT @sSQL72
--PRINT @sSQL8

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

