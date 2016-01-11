IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP1309]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP1309]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--------- Created by Nguyen Van Nhan, Date 06/09/2003
--------- Purpose: Tinh gia binh quan gia quyen cuoi ky
--------- Edit by: Dang Le Bao Quynh, Date 08/12/2006
--------- Purpose: Them phuong phap tinh gia binh quan lien hoan
--------- Edit by: Dang Le Bao Quynh, Date 30/06/2008
--------- Purpose: Xu ly lam tron
--------- Edit by: Dang Le Bao Quynh, Date 05/09/2008
--------- Purpose: Cap nhat cac phieu VCNB = 0 truoc khi tinh cho cac ma hang tinh theo phuong phap binh quan
--------- Edit by: Dang Le Bao Quynh, Date 19/09/2008
--------- Purpose: Cap nhat cac phieu nhap hang ban tra lai = 0 truoc khi tinh cho cac ma hang tinh theo phuong phap binh quan
--------- Edit by: Dang Le Bao Quynh, Date 19/05/2010
--------- Purpose: Sap xep lai thu tu cac phieu xuat khi lam tron.
--------- Edit by: Khanh Van, Date 23/01/2013
--------- Purpose: Ap gia nhap hang tra lai va hang tai che bang gia ton dau cho Binh Tay
--------- Edit by: Khanh Van, Date 02/07/2013
--------- Purpose: Áp giá đầu kỳ cho nguyên vật liệu cho PMT
--------- Edit by: Khanh Van, Date 16/09/2013
--------- Purpose: Kết thêm division và tối ưu hóa câu query
--------- Modify on 27/12/2013 by Bảo Anh: Dùng biến table @AV1309 thay AV1309 để cải thiện tốc độ
--------- Modify on 31/12/2013 by Khanh Van: Ghi lại history tính giá thành
--------- Modify on 20/02/2014 by Bảo Anh: Không dùng biến table @AV1309 thay AV1309 nữa vì tính giá xuất không đúng
--------- Modify on 08/05/2014 by Bảo Anh: Bỏ cập nhật thành tiền cho phiếu nhập khi xử lý làm tròn (lỗi TBIV)
--------- Modify on 27/05/2014 by Bảo Anh: khi xử lý làm tròn không cập nhật thành tiền cho phiếu xuất từ kho sửa chữa (customize TBIV)
--------- Modify on 18/08/2015 by Tiểu Mai: Bổ sung đơn giá quy đổi = đơn giá chuẩn
--------- Modified on 08/10/2015 by Tieu Mai: Sửa phần làm tròn số lẻ theo thiết lập đơn vị-chi nhánh
--------- Modified on 04/11/2015 by Tiểu Mai: Bổ sung xử lý tính giá hàng hóa theo quy cách.
--------- Modify on 18/12/2015 by Bảo Anh: khi xử lý làm tròn không dùng Round cho @Amount
/********************************************
'* Edited by: [GS] [Việt Khánh] [29/07/2010]
'********************************************/
--- AP1309 'STH',11,2013,'BB14B001','Z001','CH01','PC08','152','157'

CREATE PROCEDURE [dbo].[AP1309] 
    @DivisionID NVARCHAR(50), 
    @TranMonth INT, 
    @TranYear INT, 
    @FromInventoryID NVARCHAR(50), 
    @ToInventoryID NVARCHAR(50), 
    @FromWareHouseID NVARCHAR(50), 
    @ToWareHouseID NVARCHAR(50), 
    @FromAccountID NVARCHAR(50), 
    @ToAccountID NVARCHAR(50),
    @UserID NVARCHAR(50),
    @GroupID NVARCHAR (50)
AS
DECLARE 
    @sSQL NVARCHAR(4000), 
    @sSQL1 NVARCHAR(4000),
    @QuantityDecimals TINYINT, 
    @UnitCostDecimals TINYINT,
    @ConvertedDecimals TINYINT,
    @CustomerName INT

SET NOCOUNT ON

--Tao bang tam de kiem tra day co phai la khach hang TBIV khong (CustomerName = 29)
CREATE Table #CustomerName (CustomerName INT, ImportExcel int)
INSERT #CustomerName EXEC AP4444
SET @CustomerName = (SELECT TOP 1 CustomerName FROM #CustomerName)

SELECT @QuantityDecimals = QuantityDecimals, 
    @UnitCostDecimals = UnitCostDecimals, 
    @ConvertedDecimals = ConvertedDecimals
FROM AT1101
WHERE DivisionID =@DivisionID

SET @QuantityDecimals = ISNULL(@QuantityDecimals, 2)
SET @UnitCostDecimals = ISNULL(@UnitCostDecimals, 2)
SET @ConvertedDecimals = ISNULL(@ConvertedDecimals, 2)
-- Ghi lai history
Insert into HistoryInfo(TableID, ModifyUserID, ModifyDate, Action, VoucherNo, TransactionTypeID, DivisionID)
Values ('WF0056', @UserID, GETDATE(), 9, @GroupID,'',@DivisionID)

--Cap nhat gia xuat tra lai hang mua = gia cua phieu tra lai hang mua
UPDATE AT2007 
SET AT2007.UnitPrice = (CASE WHEN ActualQuantity <> 0 THEN ROUND(AT9000.ConvertedAmount / ActualQuantity, @UnitCostDecimals) ELSE 0 END),
	AT2007.ConvertedPrice =  (CASE WHEN ActualQuantity <> 0 THEN ROUND(AT9000.ConvertedAmount / ActualQuantity, @UnitCostDecimals) ELSE 0 END),
    OriginalAmount = AT9000.ConvertedAmount, 
    ConvertedAmount = AT9000.ConvertedAmount
FROM AT2007 
    INNER JOIN AT2006 ON AT2006.DivisionID = AT2007.DivisionID AND AT2006.VoucherID = AT2007.VoucherID
    INNER JOIN AT9000 ON AT9000.DivisionID = AT2007.DivisionID AND AT9000.VoucherID = AT2007.VoucherID AND AT9000.TransactionID = AT2007.TransactionID
WHERE AT2007.DivisionID =@DivisionID
    AND AT2006.KindVoucherID = 10 
    AND AT2006.TranMonth = @TranMonth 
    AND AT2006.TranYear = @TranYear 
    AND AT9000.TransactionTypeID = 'T25' 
    AND AT9000.TranMonth = @TranMonth 
    AND AT9000.TranYear = @TranYear

--Cap nhat gia xuat tra lai hang mua = gia cua phieu tra lai hang mua (khi quản lý hàng theo quy cách)
UPDATE AT2007 
SET AT2007.UnitPrice = (CASE WHEN ActualQuantity <> 0 THEN ROUND(AT9000.ConvertedAmount / ActualQuantity, @UnitCostDecimals) ELSE 0 END),
	AT2007.ConvertedPrice =  (CASE WHEN ActualQuantity <> 0 THEN ROUND(AT9000.ConvertedAmount / ActualQuantity, @UnitCostDecimals) ELSE 0 END),
    OriginalAmount = AT9000.ConvertedAmount, 
    ConvertedAmount = AT9000.ConvertedAmount
FROM AT2007 
    INNER JOIN AT2006 ON AT2006.DivisionID = AT2007.DivisionID AND AT2006.VoucherID = AT2007.VoucherID
    INNER JOIN AT9000 ON AT9000.DivisionID = AT2007.DivisionID AND AT9000.VoucherID = AT2007.VoucherID AND AT9000.TransactionID = AT2007.TransactionID
    --LEFT JOIN WT8899 ON WT8899.DivisionID = AT2007.DivisionID AND WT8899.VoucherID = AT2007.VoucherID AND WT8899.TransactionID = AT2007.TransactionID
    --LEFT JOIN AT8899 ON AT8899.DivisionID = AT9000.DivisionID AND AT8899.VoucherID = AT9000.VoucherID AND AT8899.TransactionID = AT9000.TransactionID
WHERE AT2007.DivisionID =@DivisionID
    AND AT2006.KindVoucherID = 10 
    AND AT2006.TranMonth = @TranMonth 
    AND AT2006.TranYear = @TranYear 
    AND AT9000.TransactionTypeID = 'T25' 
    AND AT9000.TranMonth = @TranMonth 
    AND AT9000.TranYear = @TranYear   

UPDATE AT2007 
SET UnitPrice = 0,
	ConvertedPrice = 0, 
    OriginalAmount = 0, 
    ConvertedAmount = 0
FROM AT2007 
    INNER JOIN AT2006 ON AT2007.DivisionID = AT2006.DivisionID AND AT2007.VoucherID = AT2006.VoucherID
    INNER Join AT1302 ON AT2007.DivisionID = AT1302.DivisionID and AT2007.InventoryID = AT1302.InventoryID
WHERE AT2007.TranMonth = @TranMonth 
    AND AT2007.TranYear = @TranYear
    AND AT2007.InventoryID BETWEEN @FromInventoryID AND @ToInventoryID 
	AND MethodID IN (4, 5)
	AND WareHouseID2 BETWEEN @FromWareHouseID AND @ToWareHouseID 
    AND CreditAccountID BETWEEN @FromAccountID AND @ToAccountID 
    AND KindVoucherID = 3
    AND AT2007.DivisionID = @DivisionID

SET @sSQL = '
SELECT AT2008.WareHouseID, 
    AT2008.InventoryID, 
    AT2008.InventoryAccountID, 
    AT1302.InventoryName AS InventoryName, 
    AT1303.WareHouseName AS WareHouseName, 
    AT2008.DivisionID,
    SUM(ISNULL(AT2008.BeginQuantity, 0)) AS ActBegQty, 
    SUM(ISNULL(AT2008.BeginAmount, 0)) AS ActBegTotal, 
    SUM(ISNULL(AT2008.DebitQuantity, 0)) AS ActReceivedQty, 
    SUM(ISNULL(AT2008.DebitAmount, 0)) AS ActReceivedTotal, 
    SUM(ISNULL(AT2008.CreditQuantity, 0)) AS ActDeliveryQty, 
    SUM(ISNULL(AT2008.EndQuantity, 0)) AS ActEndQty, 
    CASE WHEN (SUM(ISNULL(AT2008.BeginQuantity, 0) + 
                    CASE WHEN AT2008.InDebitAmount <> 0 
                        THEN ISNULL(AT2008.DebitQuantity, 0) 
                        ELSE ISNULL(AT2008.DebitQuantity, 0) - ISNULL(AT2008.InDebitQuantity, 0) 
                    END)) = 0 
        THEN 0 
        ELSE (SUM(ISNULL(AT2008.BeginAmount, 0) + ISNULL(AT2008.DebitAmount, 0))) / 
            (SUM(ISNULL(AT2008.BeginQuantity, 0) + 
                CASE WHEN AT2008.InDebitAmount <> 0 
                    THEN ISNULL(AT2008.DebitQuantity, 0) 
                    ELSE ISNULL(AT2008.DebitQuantity, 0) - ISNULL(AT2008.InDebitQuantity, 0) 
                END)) 
    END AS UnitPrice
FROM AT2008 
INNER JOIN AT1302 ON AT1302.DivisionID = AT2008.DivisionID AND AT1302.InventoryID = AT2008.InventoryID 
INNER JOIN AT1303 ON AT1303.DivisionID = AT2008.DivisionID AND AT1303.WareHouseID = AT2008.WareHouseID 
WHERE AT2008.DivisionID = ''' + @DivisionID + ''' 
    AND AT1302.MethodID = 4 
    AND AT2008.TranMonth = ' + str(@TranMonth) + ' 
    AND AT2008.TranYear = ' + str(@TranYear) + ' 
    AND (AT2008.InventoryID BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + ''') 
    AND (AT2008.WareHouseID BETWEEN ''' + @FromWareHouseID + ''' AND ''' + @ToWareHouseID + ''') 
    AND (AT2008.InventoryAccountID BETWEEN ''' + @FromAccountID + ''' AND ''' + @ToAccountID + ''') 
GROUP BY AT2008.WareHouseID, 
    AT2008.InventoryID, 
    AT1303.WareHouseName, 
    AT1302.InventoryName, 
    AT2008.InventoryAccountID,
    AT2008.DivisionID 
'

SET @sSQL1 = '
SELECT AT2008.WareHouseID, 
    AT2008.InventoryID, 
    AT2008.InventoryAccountID, 
    AT1302.InventoryName AS InventoryName, 
    AT1303.WareHouseName AS WareHouseName, 
    AT2008.DivisionID,
    SUM(ISNULL(AT2008.BeginQuantity, 0)) AS ActBegQty, 
    SUM(ISNULL(AT2008.BeginAmount, 0)) AS ActBegTotal, 
    SUM(ISNULL(AT2008.DebitQuantity, 0)) AS ActReceivedQty, 
    SUM(ISNULL(AT2008.DebitAmount, 0)) AS ActReceivedTotal, 
    SUM(ISNULL(AT2008.CreditQuantity, 0)) AS ActDeliveryQty, 
    SUM(ISNULL(AT2008.EndQuantity, 0)) AS ActEndQty, 
    CASE WHEN (SUM(ISNULL(AT2008.BeginQuantity, 0) + 
                    CASE WHEN AT2008.InDebitAmount <> 0 
                        THEN ISNULL(AT2008.DebitQuantity, 0) 
                        ELSE ISNULL(AT2008.DebitQuantity, 0) - ISNULL(AT2008.InDebitQuantity, 0) 
                    END)) = 0 
        THEN 0 
        ELSE (SUM(ISNULL(AT2008.BeginAmount, 0) + ISNULL(AT2008.DebitAmount, 0))) / 
            (SUM(ISNULL(AT2008.BeginQuantity, 0) + 
                CASE WHEN AT2008.InDebitAmount <> 0 
                    THEN ISNULL(AT2008.DebitQuantity, 0) 
                    ELSE ISNULL(AT2008.DebitQuantity, 0) - ISNULL(AT2008.InDebitQuantity, 0) 
                END)) 
    END AS UnitPrice, AT2008.S01ID, AT2008.S02ID, AT2008.S03ID, AT2008.S04ID, AT2008.S05ID, 
    AT2008.S06ID, AT2008.S07ID, AT2008.S08ID, AT2008.S09ID, AT2008.S10ID, AT2008.S11ID, AT2008.S12ID,
    AT2008.S13ID, AT2008.S14ID, AT2008.S15ID, AT2008.S16ID, AT2008.S17ID, AT2008.S18ID, AT2008.S19ID, AT2008.S20ID
FROM AT2008_QC AT2008
INNER JOIN AT1302 ON AT1302.DivisionID = AT2008.DivisionID AND AT1302.InventoryID = AT2008.InventoryID 
INNER JOIN AT1303 ON AT1303.DivisionID = AT2008.DivisionID AND AT1303.WareHouseID = AT2008.WareHouseID 
WHERE AT2008.DivisionID = ''' + @DivisionID + ''' 
    AND AT1302.MethodID = 4 
    AND AT2008.TranMonth = ' + str(@TranMonth) + ' 
    AND AT2008.TranYear = ' + str(@TranYear) + ' 
    AND (AT2008.InventoryID BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + ''') 
    AND (AT2008.WareHouseID BETWEEN ''' + @FromWareHouseID + ''' AND ''' + @ToWareHouseID + ''') 
    AND (AT2008.InventoryAccountID BETWEEN ''' + @FromAccountID + ''' AND ''' + @ToAccountID + ''') 
GROUP BY AT2008.WareHouseID, 
    AT2008.InventoryID, 
    AT1303.WareHouseName, 
    AT1302.InventoryName, 
    AT2008.InventoryAccountID,
    AT2008.DivisionID,
    AT2008.S01ID, AT2008.S02ID, AT2008.S03ID, AT2008.S04ID, AT2008.S05ID,
    AT2008.S06ID, AT2008.S07ID, AT2008.S08ID, AT2008.S09ID, AT2008.S10ID, AT2008.S11ID, AT2008.S12ID,
    AT2008.S13ID, AT2008.S14ID, AT2008.S15ID, AT2008.S16ID, AT2008.S17ID, AT2008.S18ID, AT2008.S19ID, AT2008.S20ID'

IF NOT EXISTS (SELECT 1 FROM SysObjects WHERE Xtype = 'V' AND Name = 'AV1309')
    EXEC (' CREATE VIEW AV1309 AS ' + @sSQL)
ELSE
    EXEC (' ALTER VIEW AV1309 AS ' + @sSQL)
    
IF EXISTS (SELECT 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
BEGIN
	IF NOT EXISTS (SELECT 1 FROM SysObjects WHERE Xtype = 'V' AND Name = 'AV1309_QC')
		EXEC (' CREATE VIEW AV1309_QC AS ' + @sSQL1)
	ELSE
		EXEC (' ALTER VIEW AV1309_QC AS ' + @sSQL1)
END    

--Add by Dang Le Bao Quynh; Date 23/04/2013
--Purpose: Kiem tra customize cho Binh Tay
Declare @AP4444 Table(CustomerName Int, Export Int)
Insert Into @AP4444(CustomerName,Export) EXEC('AP4444')

If (Select CustomerName From @AP4444)=8
BEGIN
	------ Ap gia nhap hang tra lai bang gia dau ky
	IF EXISTS 
	(
		SELECT TOP 1 1 
		FROM AT2007 
			INNER JOIN AT2006 ON AT2006.DivisionID = AT2007.DivisionID AND AT2006.VoucherID = AT2007.VoucherID
			INNER JOIN AT1302 ON AT1302.DivisionID = AT2007.DivisionID AND AT1302.InventoryID = AT2007.InventoryID
		WHERE AT2007.DivisionID = @DivisionID 
		AND AT2007.TranMonth = @TranMonth 
		AND AT2007.TranYear = @TranYear 
		AND KindVoucherID =7 
		AND At1302.MethodID = 4
	) 
		EXEC AP13081 @DivisionID, @TranMonth, @TranYear, @QuantityDecimals, @UnitCostDecimals, @ConvertedDecimals


	------ Ap gia nhap hang tai che bang gia dau ky
	IF EXISTS 
	(
		SELECT TOP 1 1 
		FROM AT2007 
			INNER JOIN AT2006 ON AT2006.DivisionID = AT2007.DivisionID AND AT2006.VoucherID = AT2007.VoucherID
			INNER JOIN AT1302 ON AT1302.DivisionID = AT2007.DivisionID AND AT1302.InventoryID = AT2007.InventoryID
		WHERE AT2007.DivisionID = @DivisionID 
		AND AT2007.TranMonth = @TranMonth 
		AND AT2007.TranYear = @TranYear 
		AND KindVoucherID = 1 
		AND At1302.MethodID = 4
		AND IsGoodsRecycled = 1
	) 
		EXEC AP13082 @DivisionID, @TranMonth, @TranYear, @QuantityDecimals, @UnitCostDecimals, @ConvertedDecimals
END

------------ Xu ly chi tiet gia 

------ Ap gia nhap nhap nguyen vat lieu phat sinh tu dong tu xuat thanh pham
	IF EXISTS 
	(
		SELECT TOP 1 1 
		FROM AT2007 
			INNER JOIN AT2006 ON AT2006.DivisionID = AT2007.DivisionID AND AT2006.VoucherID = AT2007.VoucherID
			INNER JOIN AT1302 ON AT1302.DivisionID = AT2007.DivisionID AND AT1302.InventoryID = AT2007.InventoryID
		WHERE AT2007.DivisionID = @DivisionID 
		AND AT2007.TranMonth = @TranMonth 
		AND AT2007.TranYear = @TranYear 
		AND KindVoucherID = 1 
		AND At1302.MethodID = 4
		AND IsGoodsRecycled = 1
	) 
		EXEC AP13082 @DivisionID, @TranMonth, @TranYear, @QuantityDecimals, @UnitCostDecimals, @ConvertedDecimals
------ Tinh gia xuat kho; Gia Binh quan cho cac phieu xuat van chuyen noi bo
IF EXISTS 
(
    SELECT TOP 1 1 
    FROM AT2007 
        INNER JOIN AT2006 ON AT2006.DivisionID = AT2007.DivisionID AND AT2006.VoucherID = AT2007.VoucherID
        INNER JOIN AT1302 ON AT1302.DivisionID = AT2007.DivisionID AND AT1302.InventoryID = AT2007.InventoryID
    WHERE AT2007.DivisionID = @DivisionID 
    AND AT2007.TranMonth = @TranMonth 
    AND AT2007.TranYear = @TranYear 
    AND KindVoucherID = 3 
    AND At1302.MethodID = 4
) 
    EXEC AP1308 @DivisionID, @TranMonth, @TranYear, @QuantityDecimals, @UnitCostDecimals, @ConvertedDecimals
    IF EXISTS (SELECT 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
		EXEC AP1308_QC @DivisionID, @TranMonth, @TranYear, @QuantityDecimals, @UnitCostDecimals, @ConvertedDecimals
------ Tinh gia xuat kho; Gia Binh quan cho cac phieu xuat kho thuong
IF EXISTS 
(
    SELECT TOP 1 1 
    FROM AT2007 
        INNER JOIN AT2006 ON AT2006.DivisionID = AT2007.DivisionID AND AT2006.VoucherID = AT2007.VoucherID
        INNER JOIN AT1302 ON AT1302.DivisionID = AT2007.DivisionID AND AT1302.InventoryID = AT2007.InventoryID
    WHERE AT2007.DivisionID = @DivisionID 
    AND AT2007.TranMonth = @TranMonth 
    AND AT2007.TranYear = @TranYear 
    AND KindVoucherID IN (2, 4, 6, 8) 
    AND At1302.MethodID = 4
)
BEGIN
	    EXEC AP1307 @DivisionID, @TranMonth, @TranYear, @QuantityDecimals, @UnitCostDecimals, @ConvertedDecimals
	    IF EXISTS (SELECT 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
			EXEC AP1307_QC @DivisionID, @TranMonth, @TranYear, @QuantityDecimals, @UnitCostDecimals, @ConvertedDecimals
END



----------- Tinh gia xuat kho binh quan lien hoan
IF EXISTS 
(
    SELECT TOP 1 1 
    FROM AT2007 
        INNER JOIN AT2006 ON AT2006.DivisionID = AT2007.DivisionID AND AT2006.VoucherID = AT2007.VoucherID
        INNER JOIN AT1302 ON AT1302.DivisionID = AT2007.DivisionID AND AT1302.InventoryID = AT2007.InventoryID
    WHERE AT2007.DivisionID = @DivisionID 
    AND AT2007.TranMonth = @TranMonth 
    AND AT2007.TranYear = @TranYear 
    AND KindVoucherID IN (2, 3, 4, 6, 8) 
    AND AT1302.MethodID = 5
)
BEGIN 
    EXEC AP1410 @DivisionID, @TranMonth, @TranYear, @QuantityDecimals, @UnitCostDecimals, @ConvertedDecimals, 
        @FromInventoryID, @ToInventoryID, @FromWareHouseID, @ToWareHouseID, @FromAccountID, @ToAccountID
    IF EXISTS (SELECT 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
        EXEC AP1410_QC @DivisionID, @TranMonth, @TranYear, @QuantityDecimals, @UnitCostDecimals, @ConvertedDecimals, 
        @FromInventoryID, @ToInventoryID, @FromWareHouseID, @ToWareHouseID, @FromAccountID, @ToAccountID
END


UPDATE AT2008
SET AT2008.UnitPrice = AV1309.UnitPrice
FROM AT2008 
INNER JOIN AV1309 ON AV1309.DivisionID = AT2008.DivisionID AND AV1309.InventoryID = AT2008.InventoryID AND AV1309.WareHouseID = AT2008.WareHouseID AND AV1309.InventoryAccountID = AT2008.InventoryAccountID
WHERE AT2008.TranMonth = @TranMonth 
    AND AT2008.TranYear = @TranYear 
    AND AT2008.DivisionID = @DivisionID

IF EXISTS (SELECT 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
BEGIN
	UPDATE AT2008_QC
SET AT2008_QC.UnitPrice = AV1309_QC.UnitPrice
FROM AT2008_QC 
INNER JOIN AV1309_QC ON AV1309_QC.DivisionID = AT2008_QC.DivisionID AND AV1309_QC.InventoryID = AT2008_QC.InventoryID AND AV1309_QC.WareHouseID = AT2008_QC.WareHouseID AND AV1309_QC.InventoryAccountID = AT2008_QC.InventoryAccountID
WHERE AT2008_QC.TranMonth = @TranMonth 
    AND AT2008_QC.TranYear = @TranYear 
    AND AT2008_QC.DivisionID = @DivisionID
    AND ISNULL(AT2008_QC.S01ID,'') = Isnull(AV1309_QC.S01ID,'')
	AND ISNULL(AT2008_QC.S02ID,'') = isnull(AV1309_QC.S02ID,'') 
	AND ISNULL(AT2008_QC.S03ID,'') = isnull(AV1309_QC.S03ID,'') 	
	AND ISNULL(AT2008_QC.S04ID,'') = isnull(AV1309_QC.S04ID,'') 
	AND ISNULL(AT2008_QC.S05ID,'') = isnull(AV1309_QC.S05ID,'') 
	AND ISNULL(AT2008_QC.S06ID,'') = isnull(AV1309_QC.S06ID,'') 
	AND ISNULL(AT2008_QC.S07ID,'') = isnull(AV1309_QC.S07ID,'') 
	AND ISNULL(AT2008_QC.S08ID,'') = isnull(AV1309_QC.S08ID,'') 
	AND ISNULL(AT2008_QC.S09ID,'') = isnull(AV1309_QC.S09ID,'') 
	AND ISNULL(AT2008_QC.S10ID,'') = isnull(AV1309_QC.S10ID,'') 
	AND ISNULL(AT2008_QC.S11ID,'') = isnull(AV1309_QC.S11ID,'') 
	AND ISNULL(AT2008_QC.S12ID,'') = isnull(AV1309_QC.S12ID,'') 
	AND ISNULL(AT2008_QC.S13ID,'') = isnull(AV1309_QC.S13ID,'') 
	AND ISNULL(AT2008_QC.S14ID,'') = isnull(AV1309_QC.S14ID,'') 
	AND ISNULL(AT2008_QC.S15ID,'') = isnull(AV1309_QC.S15ID,'') 
	AND ISNULL(AT2008_QC.S16ID,'') = isnull(AV1309_QC.S16ID,'') 
	AND ISNULL(AT2008_QC.S17ID,'') = isnull(AV1309_QC.S17ID,'') 
	AND ISNULL(AT2008_QC.S18ID,'') = isnull(AV1309_QC.S18ID,'') 
	AND ISNULL(AT2008_QC.S19ID,'') = isnull(AV1309_QC.S19ID,'')
	AND ISNULL(AT2008_QC.S20ID,'') = isnull(AV1309_QC.S20ID,'')
END    

----------- Tinh gia TTDD
IF EXISTS 
(
    SELECT TOP 1 1 
    FROM AT2007 
        INNER JOIN AT2006 ON AT2006.DivisionID = AT2007.DivisionID AND AT2006.VoucherID = AT2007.VoucherID
        INNER JOIN AT1302 ON AT1302.DivisionID = AT2007.DivisionID AND AT1302.InventoryID = AT2007.InventoryID
    WHERE AT2007.DivisionID = @DivisionID 
    AND AT2007.TranMonth = @TranMonth 
    AND AT2007.TranYear = @TranYear 
    AND KindVoucherID IN (2, 3, 4, 6, 8) 
    AND At1302.MethodID = 3
) 
	EXEC AP1305 @DivisionID, @TranMonth, @TranYear


------------ Tinh gia xuat kho theo PP FIFO 
IF EXISTS 
(
    SELECT TOP 1 1 
    FROM AT2007 
        INNER JOIN AT2006 ON AT2006.DivisionID = AT2007.DivisionID AND AT2006.VoucherID = AT2007.VoucherID
        INNER JOIN AT1302 ON AT1302.DivisionID = AT2007.DivisionID AND AT1302.InventoryID = AT2007.InventoryID
    WHERE AT2007.DivisionID = @DivisionID 
        AND AT2007.TranMonth = @TranMonth 
        AND AT2007.TranYear = @TranYear 
        AND KindVoucherID IN (2, 3, 4, 6, 8) 
        AND At1302.MethodID = 1
) 
    EXEC AP1303 @DivisionID, @TranMonth, @TranYear


----- XU LY LAM TRON
			
DECLARE 
    @InventoryID AS NVARCHAR(50), 
    @AccountID AS NVARCHAR(50), 
    @Amount AS DECIMAL(28, 8), 
    @WareHouseID AS NVARCHAR(50), 
    @Cur AS CURSOR, 
    @TransactionID AS NVARCHAR(50), 
    @Cur_Ware AS CURSOR, 
    @CountUpdate INT,
    @CountUpdate1 INT,
	@S01ID VARCHAR(50),
	@S02ID VARCHAR(50),
    @S03ID VARCHAR(50),
    @S04ID VARCHAR(50),
    @S05ID VARCHAR(50),
    @S06ID VARCHAR(50),
    @S07ID VARCHAR(50),
    @S08ID VARCHAR(50),
    @S09ID VARCHAR(50),
    @S10ID VARCHAR(50),
    @S11ID VARCHAR(50),
    @S12ID VARCHAR(50),
    @S13ID VARCHAR(50),
    @S14ID VARCHAR(50),
    @S15ID VARCHAR(50),
    @S16ID VARCHAR(50),
    @S17ID VARCHAR(50),
    @S18ID VARCHAR(50),
    @S19ID VARCHAR(50),
    @S20ID VARCHAR(50)

Recal: 

SET @CountUpdate = 0
SET @Cur_Ware = CURSOR SCROLL KEYSET FOR 
    SELECT WareHouseID, 
        AT2008.InventoryID, 
        InventoryAccountID, 
        EndAmount
    FROM AT2008 inner join AT1302 on AT2008.DivisionID = AT1302.DivisionID and AT2008.InventoryID = AT1302.InventoryID
    WHERE TranMonth = @TranMonth 
        AND TranYear = @TranYear 
        AND EndQuantity = 0 
        AND EndAmount <> 0 
        AND AT2008.DivisionID = @DivisionID 
        AND (AT2008.InventoryID BETWEEN @FromInventoryID AND @ToInventoryID) 
        AND (InventoryAccountID BETWEEN @FromAccountID AND @ToAccountID)
        
OPEN @Cur_Ware
FETCH NEXT FROM @Cur_Ware INTO  @WareHouseID, @InventoryID, @AccountID, @Amount

WHILE @@Fetch_Status = 0 
    BEGIN
		IF @CustomerName <> 29 or (@CustomerName = 29 and @WareHouseID <> 'SCTP') --- customize TBIV: nếu là kho sửa chữa thì không làm tròn để phiếu xuất của kho này không bị cập nhật lại tiền
        BEGIN
			SET @TransactionID = 
			(
				SELECT TOP 1 D11.TransactionID
				FROM AT2007 D11
					LEFT JOIN AT2007 D12 ON D12.TransactionID = D11.ReTransactionID
					INNER JOIN AT2006 D9 ON D9.DivisionID = D11.DivisionID AND D9.VoucherID = D11.VoucherID
				WHERE D11.InventoryID = @InventoryID 
					AND D11.TranMonth = @TranMonth
					AND D11.TranYear = @TranYear
					AND D11.DivisionID = @DivisionID
					AND (CASE WHEN D9.KindVoucherID = 3 THEN D9.WareHouseID2 ELSE D9.WareHouseID END) = @WareHouseID 
					AND D9.KindVoucherID IN (2, 3, 4, 6, 8,7)---,1) 
					AND D11.CreditAccountID = @AccountID
				ORDER BY CASE WHEN D9.KindVoucherID = 3 THEN 1 ELSE 0 END,  
						 CASE WHEN D11.ActualQuantity = D12.ActualQuantity AND D11.ConvertedAmount < D12.ConvertedAmount THEN 0 ELSE 1 END, D11.ConvertedAmount DESC
			)			
			IF @TransactionID IS NOT NULL
				BEGIN
					UPDATE AT2007 
					SET ConvertedAmount = ISNULL(ConvertedAmount, 0) + @Amount, 
						OriginalAmount = ISNULL(OriginalAmount, 0) + @Amount
					FROM AT2007 
					WHERE AT2007.TransactionID = @TransactionID and AT2007.DivisionID = @DivisionID
					SET @CountUpdate = @CountUpdate + 1
				END
		END
		
        FETCH NEXT FROM @Cur_Ware INTO @WareHouseID, @InventoryID, @AccountID, @Amount
    END 

CLOSE @Cur_Ware

SET @CountUpdate1 = 0
SET @Cur_Ware = CURSOR SCROLL KEYSET FOR 
    SELECT WareHouseID, 
        AT2008.InventoryID, 
        InventoryAccountID, 
        EndAmount,
        AT2008.S01ID, AT2008.S02ID, AT2008.S03ID, AT2008.S04ID, AT2008.S05ID, AT2008.S06ID, AT2008.S07ID, AT2008.S08ID, AT2008.S09ID, AT2008.S10ID,
        AT2008.S11ID, AT2008.S12ID, AT2008.S13ID, AT2008.S14ID, AT2008.S15ID, AT2008.S16ID, AT2008.S17ID, AT2008.S18ID, AT2008.S19ID, AT2008.S20ID 
    FROM AT2008_QC AT2008 inner join AT1302 on AT2008.DivisionID = AT1302.DivisionID and AT2008.InventoryID = AT1302.InventoryID
    WHERE TranMonth = @TranMonth 
        AND TranYear = @TranYear 
        AND EndQuantity = 0 
        AND EndAmount <> 0 
        AND AT2008.DivisionID = @DivisionID 
        AND (AT2008.InventoryID BETWEEN @FromInventoryID AND @ToInventoryID) 
        AND (InventoryAccountID BETWEEN @FromAccountID AND @ToAccountID)

OPEN @Cur_Ware
FETCH NEXT FROM @Cur_Ware INTO  @WareHouseID, @InventoryID, @AccountID, @Amount, @S01ID, @S02ID, @S03ID, @S04ID, @S05ID, @S06ID, @S07ID, @S08ID, @S09ID, @S10ID,
    @S11ID, @S12ID, @S13ID, @S14ID, @S15ID, @S16ID, @S17ID, @S18ID, @S19ID, @S20ID

WHILE @@Fetch_Status = 0 
    BEGIN
		IF @CustomerName <> 29 or (@CustomerName = 29 and @WareHouseID <> 'SCTP') --- customize TBIV: nếu là kho sửa chữa thì không làm tròn để phiếu xuất của kho này không bị cập nhật lại tiền
        BEGIN
			SET @TransactionID = 
			(
				SELECT TOP 1 D11.TransactionID
				FROM AT2007 D11
					LEFT JOIN AT2007 D12 ON D12.TransactionID = D11.ReTransactionID
					INNER JOIN AT2006 D9 ON D9.DivisionID = D11.DivisionID AND D9.VoucherID = D11.VoucherID
					LEFT JOIN WT8899 ON WT8899.DivisionID = D11.DivisionID AND WT8899.VoucherID = D11.VoucherID AND WT8899.TransactionID = D11.TransactionID
				WHERE D11.InventoryID = @InventoryID 
					AND D11.TranMonth = @TranMonth
					AND D11.TranYear = @TranYear
					AND D11.DivisionID = @DivisionID
					AND (CASE WHEN D9.KindVoucherID = 3 THEN D9.WareHouseID2 ELSE D9.WareHouseID END) = @WareHouseID 
					AND D9.KindVoucherID IN (2, 3, 4, 6, 8,7)---,1) 
					AND D11.CreditAccountID = @AccountID
					AND ISNULL(WT8899.S01ID,'') = Isnull(@S01ID,'')
					AND ISNULL(WT8899.S02ID,'') = isnull(@S02ID,'') 
					AND ISNULL(WT8899.S03ID,'') = isnull(@S03ID,'') 	
					AND ISNULL(WT8899.S04ID,'') = isnull(@S04ID,'') 
					AND ISNULL(WT8899.S05ID,'') = isnull(@S05ID,'') 
					AND ISNULL(WT8899.S06ID,'') = isnull(@S06ID,'') 
					AND ISNULL(WT8899.S07ID,'') = isnull(@S07ID,'') 
					AND ISNULL(WT8899.S08ID,'') = isnull(@S08ID,'') 
					AND ISNULL(WT8899.S09ID,'') = isnull(@S09ID,'') 
					AND ISNULL(WT8899.S10ID,'') = isnull(@S10ID,'') 
					AND ISNULL(WT8899.S11ID,'') = isnull(@S11ID,'') 
					AND ISNULL(WT8899.S12ID,'') = isnull(@S12ID,'') 
					AND ISNULL(WT8899.S13ID,'') = isnull(@S13ID,'') 
					AND ISNULL(WT8899.S14ID,'') = isnull(@S14ID,'') 
					AND ISNULL(WT8899.S15ID,'') = isnull(@S15ID,'') 
					AND ISNULL(WT8899.S16ID,'') = isnull(@S16ID,'') 
					AND ISNULL(WT8899.S17ID,'') = isnull(@S17ID,'') 
					AND ISNULL(WT8899.S18ID,'') = isnull(@S18ID,'') 
					AND ISNULL(WT8899.S19ID,'') = isnull(@S19ID,'')
					AND ISNULL(WT8899.S20ID,'') = isnull(@S20ID,'')
				ORDER BY CASE WHEN D9.KindVoucherID = 3 THEN 1 ELSE 0 END,  
						 CASE WHEN D11.ActualQuantity = D12.ActualQuantity AND D11.ConvertedAmount < D12.ConvertedAmount THEN 0 ELSE 1 END, D11.ConvertedAmount DESC
			)			
			IF @TransactionID IS NOT NULL
				BEGIN
					UPDATE AT2007 
					SET ConvertedAmount = ISNULL(ConvertedAmount, 0) + @Amount, 
						OriginalAmount = ISNULL(OriginalAmount, 0) + @Amount
					FROM AT2007 
					WHERE AT2007.TransactionID = @TransactionID and AT2007.DivisionID = @DivisionID
					SET @CountUpdate = @CountUpdate + 1
				END
		END
		
        FETCH NEXT FROM @Cur_Ware INTO @WareHouseID, @InventoryID, @AccountID, @Amount, @S01ID, @S02ID, @S03ID, @S04ID, @S05ID, @S06ID, @S07ID, @S08ID, @S09ID, @S10ID,
    @S11ID, @S12ID, @S13ID, @S14ID, @S15ID, @S16ID, @S17ID, @S18ID, @S19ID, @S20ID
    END 

CLOSE @Cur_Ware
 
IF EXISTS 
(
    SELECT TOP 1 1 
    FROM AT2008 
    WHERE TranMonth = @TranMonth 
        AND TranYear = @TranYear 
        AND EndQuantity = 0 
        AND EndAmount <> 0 
        AND DivisionID = @DivisionID
) 
    AND @CountUpdate > 0
    
	GOTO ReCal

IF EXISTS (SELECT TOP 1 1 
    FROM AT2008_QC 
    WHERE TranMonth = @TranMonth 
        AND TranYear = @TranYear 
        AND EndQuantity = 0 
        AND EndAmount <> 0 
        AND DivisionID = @DivisionID
) 
    AND @CountUpdate1 > 0
    
	GOTO ReCal   


SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON