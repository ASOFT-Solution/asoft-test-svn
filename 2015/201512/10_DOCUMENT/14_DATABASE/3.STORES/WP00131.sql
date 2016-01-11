IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WP00131]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[WP00131]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- <Summary>
---- Khi lưu thực thi store để UPDATE lại giá trị hàng đã nhận của phiếu yêu cầu nhap xuat VCNB
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 11/06/2014 by Le Thi Thu Hien
---- 
---- Modified on 25/06/2014 by Le Thi Thu Hien : Bổ sung tạo phiếu xuất cho POS cho trường hợp chuyển từ cửa hàng sang công ty
---- Modified on 21/07/2014 by Le Thi Thu Hien : Tạo phiếu là sinh phiếu xuất bên POS chứ không cần đủ mới sinh
---- Modified on 28/07/2014 by Le Thi Thu Hien : Sửa lại phần chuyển dữ liệu qua POS
-- <Example>
---- 
CREATE PROCEDURE WP00131
( 
@DivisionID NVARCHAR(50),
@UserID VARCHAR(50),
@TranMonth AS int,
@TranYear AS int,
@VoucherID AS nvarchar(50) ,
@Mode AS tinyint
) 
AS 

-------->>>> UPDATE vào phiếu yêu cầu chuyển kho
UPDATE WT0096
SET WT0096.ReceiveQuantity = A.ReceiveQuantity
FROM WT0096 WT0096
INNER JOIN (
SELECT	SUM(ActualQuantity) AS ReceiveQuantity, 
		InheritVoucherID, InheritTransactionID , DivisionID
FROM	AT2007 
WHERE	DivisionID = @DivisionID
		AND InheritTransactionID IN ( SELECT InheritTransactionID FROM AT2007 WHERE AT2007.DivisionID = @DivisionID AND AT2007.VoucherID = @VoucherID)
		AND InheritTableID = 'WT0095'
GROUP BY InheritVoucherID, InheritTransactionID,DivisionID
) A
ON A.DivisionID = WT0096.DivisionID 
AND A.InheritVoucherID = WT0096.VoucherID
AND A.InheritTransactionID = WT0096.TransactionID



DECLARE @WT0095VoucherID AS NVARCHAR(50)
SET @WT0095VoucherID = ( SELECT TOP 1 InheritVoucherID 
                         FROM AT2007 
                         WHERE AT2007.DivisionID = @DivisionID
							AND AT2007.VoucherID = @VoucherID
							AND InheritTableID = 'WT0095')
						
DECLARE @ExWareHouseID AS NVARCHAR(50),
		@ImWareHouseID AS NVARCHAR(50)
		
SELECT @ExWareHouseID = ISNULL(WareHouseID2,''), @ImWareHouseID = ISNULL(WareHouseID,'') 
FROM WT0095
WHERE DivisionID = @DivisionID
AND VoucherID = @WT0095VoucherID
AND KindVoucherID = 3
--UPDATE WT0096 
--SET [Status] = 8 
--WHERE DivisionID = @DivisionID
--AND VoucherID = @WT0095VoucherID
--AND ReceiptQuantity = ActualQuantity
-------->>>> UPDATE vào phiếu yêu cầu chuyển kho

IF NOT EXISTS ( SELECT TOP 1 1 FROM WT0096 
                WHERE DivisionID = @DivisionID 
					AND VoucherID  = @WT0095VoucherID 
					AND ISNULL(ReceiveQuantity,0) <> ActualQuantity)
BEGIN ------ Xử lý cho trường hợp hoàn tất

---------->>> UPDATE trạng thái hoàn tất cho phiếu yêu cầu chuyển kho khi nhập đủ hàng
UPDATE WT0095
SET [Status] = 8
FROM WT0095 WT0095
WHERE WT0095.DivisionID = @DivisionID
AND WT0095.VoucherID = @WT0095VoucherID

END
----------->>>>>>> Sinh số phiếu

DECLARE	
	@VoucherTypeID nvarchar(50), --But toan tong hop
	@StringKey1 nvarchar(50), 
	@StringKey2 nvarchar(50),
	@StringKey3 nvarchar(50), 
	@OutputLen int, 
	@OutputOrder int,
	@Separated int, 
	@Separator char(1),
	@Enabled1 tinyint, 
	@Enabled2 tinyint,
	@Enabled3 tinyint,
	@S1 nvarchar(50), 
	@S2 nvarchar(50),
	@S3 nvarchar(50),
	@S1Type tinyint, 
	@S2Type tinyint,
	@S3Type tinyint 
DECLARE @POSVoucherNo AS NVARCHAR(50)
DECLARE @ShopID AS NVARCHAR(50)
	
---------->>>> Lấy thông tin cửa hàng trên POS dựa vào kho xuất ( Xuất từ POS đến ERP)
SET @ShopID = ( SELECT	TOP 1 ShopID 
                FROM	POST0010 P 
                INNER JOIN AT2006 W
					ON	P.DivisionID = W.DivisionID 
					AND P.WareHouseID = W.WareHouseID2 
                WHERE P.DivisionID = @DivisionID
						AND W.VoucherID = @VoucherID
				)

------------->>>> Lay loai phieu
SET @VoucherTypeID = ( SELECT TOP 1 VoucherType09 FROM POST0004 WHERE DivisionID = @DivisionID AND ShopID = @ShopID)

Select	@Enabled1=Enabled1,
		@Enabled2=Enabled2,
		@Enabled3=Enabled3,
		@S1=S1,
		@S2=S2,
		@S3=S3,
		@S1Type=S1Type,
		@S2Type=S2Type,
		@S3Type=S3Type,
		@OutputLen = OutputLength, 
		@OutputOrder= OutputOrder,
		@Separated= Separated,
		@Separator= Separator
FROM	AT1007 
WHERE	DivisionID = @DivisionID
		AND VoucherTypeID = @VoucherTypeID 
		
--SELECT * FROM AT1007		
If @Enabled1 = 1
	Set @StringKey1 = 
	Case @S1Type 
	When 1 Then Case When @TranMonth <10 Then '0' + ltrim(@TranMonth) Else ltrim(@TranMonth) End
	When 2 Then ltrim(@TranYear)
	When 3 Then @VoucherTypeID
	When 4 Then @DivisionID
	When 5 Then @S1
	Else '' End
Else
	Set @StringKey1 = ''

If @Enabled2 = 1
	Set @StringKey2 = 
	Case @S2Type 
	When 1 Then Case When @TranMonth <10 Then '0' + ltrim(@TranMonth) Else ltrim(@TranMonth) End
	When 2 Then ltrim(@TranYear)
	When 3 Then @VoucherTypeID
	When 4 Then @DivisionID
	When 5 Then @S2
	Else '' End
Else
	Set @StringKey2 = ''

If @Enabled3 = 1
	Set @StringKey3 = 
	Case @S3Type 
	When 1 Then Case When @TranMonth <10 Then '0' + ltrim(@TranMonth) Else ltrim(@TranMonth) End
	When 2 Then ltrim(@TranYear)
	When 3 Then @VoucherTypeID
	When 4 Then @DivisionID
	When 5 Then @S3
	Else '' End
Else
	Set @StringKey3 = ''
	
EXEC AP0000 @DivisionID ,@POSVoucherNo Output, 'POST0027', @StringKey1, @StringKey2, @StringKey3, @OutputLen, @OutputOrder, @Separated, @Separator

-----------<<<<<<<<Sinh số phiếu

------------- Tạo phiếu xuất cho POS không cần kiểm tra hoàn tất
---- Bảng Master:
IF EXISTS ( SELECT TOP 1 1 FROM POST0010 
            WHERE DivisionID = @DivisionID 
            AND WarehouseID = @ExWareHouseID 
            AND WarehouseID <> @ImWareHouseID
            )

    BEGIN
    	
    	DELETE FROM POST0028 WHERE APKMaster = (SELECT APK FROM POST0027 WHERE VoucherID = @VoucherID )
    	DELETE FROM POST0027 WHERE VoucherID = @VoucherID
    	
		
    	INSERT INTO POST0027
		(APK, VoucherID, DivisionID, TranMonth, TranYear, ShopID, 
		WarehouseID, WarehouseName, 
		ObjectID, ObjectName, 
		VoucherNo, VoucherDate, 
		VoucherTypeID, 
		EmployeeID, EmployeeName, 
		Description, DeleteFlg, 
		CreateUserID, CreateDate, LastModifyUserID, LastModifyDate
		) 
		
		SELECT W.APK ,@VoucherID, W.DivisionID, W.TranMonth, W.TranYear, @ShopID, 
		W.WarehouseID2, A.WareHouseName, 
		W.ObjectID, A1.ObjectName, 
		@POSVoucherNo, W.VoucherDate, 
		@VoucherTypeID, 
		W.EmployeeID, A2.FullName AS EmployeeName, 
		[Description], 0,
		@UserID, GETDATE(), @UserID, GETDATE()
		--FROM WT0095 W
		FROM AT2006 W
		LEFT JOIN AT1303 A ON A.DivisionID = W.DivisionID AND A.WareHouseID = W.WareHouseID2
		--LEFT JOIN POST0010 P ON P.DivisionID = A.DivisionID AND P.WareHouseID = W.WareHouseID2
		LEFT JOIN AT1202 A1 ON A1.DivisionID = A.DivisionID AND A1.ObjectID = W.ObjectID
		LEFT JOIN AT1103 A2 ON A2.DivisionID = A1.DivisionID AND A2.EmployeeID = W.EmployeeID
		WHERE	W.DivisionID = @DivisionID
				AND W.VoucherID =  @VoucherID
				AND W.KindVoucherID = 3
				AND W.RefNo01 <> '' --- Phân biệt là phiếu từ POS chuyển qua

		----+ Bảng Detail:
		INSERT INTO POST0028(
			DivisionID, ShopID, APKMaster, APKMInherited, APKDInherited, 
			InventoryID,InventoryName,InventoryTypeID,
			UnitID,UnitName,ShipQuantity,IsStocked, DeleteFlg, 
			Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID,
			Ana06ID, Ana07ID, Ana08ID, Ana09ID, Ana10ID, 
			CreateUserID, CreateDate, LastModifyUserID, LastModifyDate)
		SELECT 
			@DivisionID, @ShopID, M.APK, M.APK, D.APK,  
			D.InventoryID, P.InventoryName, M.InventoryTypeID,
			D.UnitID, A.UnitName, isnull(D.ActualQuantity,0), 1, 0, 
			D.Ana01ID, D.Ana02ID, D.Ana03ID, D.Ana04ID, D.Ana05ID,
			D.Ana06ID, D.Ana07ID, D.Ana08ID, D.Ana09ID, D.Ana10ID, 
			@UserID, GETDATE(), @UserID, GETDATE()
		--FROM WT0095 M 
		--INNER JOIN WT0096 D on M.DivisionID = D.DivisionID and M.VoucherID = D.VoucherID
		FROM AT2006 M 
		INNER JOIN AT2007 D on M.DivisionID = D.DivisionID and M.VoucherID = D.VoucherID
		LEFT JOIN AT1302 P on D.DivisionID = P.DivisionID and D.InventoryID = P.InventoryID 
		LEFT JOIN AT1304 A on D.DivisionID = A.DivisionID and A.UnitID = D.UnitID
		--LEFT JOIN POST0010 P1 ON P1.DivisionID = M.DivisionID AND P1.WareHouseID = M.WareHouseID2
		Where M.DivisionID = @DivisionID
				AND M.VoucherID = @VoucherID
				AND M.KindVoucherID = 3 
				AND M.RefNo01 <> '' --- Phân biệt là phiếu từ POS chuyển qua
				
		IF EXISTS (SELECT * FROM SYSOBJECTS WHERE NAME = 'POST9000' AND XTYPE ='U') 
		BEGIN	
		DECLARE @sSQL AS NVARCHAR(MAX)
		SET @sSQL = N'
		DELETE FROM POST9000 WHERE APKMaster = (SELECT TOP 1 APK FROM POST0027 WHERE VoucherID = '''+@VoucherID+''' )
		INSERT INTO POST9000 ( 
        APK, DivisionID, ShopID, TableID, VoucherTypeID, TranMonth, 
         IsTransferred, TranYear, VoucherNo, VoucherDate, ObjectID, 
         ObjectName, EmployeeID, EmployeeName, APKMaster, WareHouseID, 
         WareHouseName, InventoryID, InventoryName, UnitID, UnitName, 
         Quantity, DeleteFlg, APKMInherited, APKDInherited, MarkQuantity, 
         Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID, Ana06ID, Ana07ID, 
         Ana08ID, Ana09ID, Ana10ID, CreateUserID, CreateDate, 
         LastModifyUserID, LastModifyDate, IsPromotion)
		SELECT  D.APK, D.DivisionID, D.ShopID, ''POST0027'' as TableID, M.VoucherTypeID, 
				 M.TranMonth, 0 as IsTransferred, M.TranYear, M.VoucherNo, M.VoucherDate, 
				 M.ObjectID, M.ObjectName, M.EmployeeID, M.EmployeeName, M.APK,
				 WareHouseID, WareHouseName, InventoryID, D.InventoryName, D.UnitID, 
				 D.UnitName, D.ShipQuantity, D.DeleteFlg, APKMInherited, APKDInherited, 
				 MarkQuantity, D.Ana01ID, D.Ana02ID, D.Ana03ID, D.Ana04ID, D.Ana05ID, 
				 D.Ana06ID, D.Ana07ID, D.Ana08ID, D.Ana09ID, D.Ana10ID, D.CreateUserID, 
				 D.CreateDate, D.LastModifyUserID, D.LastModifyDate, 0 as IsPromotion
		FROM	POST0027 M 
		INNER JOIN POST0028 D on M.APK = D.APKMaster and M.DeleteFlg = D.DeleteFlg
		WHERE D.APKMaster = (SELECT TOP 1 APK FROM POST0027 WHERE VoucherID = '''+@VoucherID+''' ) and D.DeleteFlg = 0
		'

		PRINT(@sSQL)
		EXEC(@sSQL)
		END


    END
    	
--END ------ Xử lý cho trường hợp hoàn tất


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

