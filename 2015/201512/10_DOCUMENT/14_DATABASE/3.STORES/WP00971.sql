IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WP00971]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[WP00971]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Sinh tự động phiếu chênh lệch nếu check hoàn tất
---- Sinh tự động phiếu xuất kho bên POS khi check hoàn tất
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 09/06/2014 by Lê Thị Thu Hiền
---- 
---- Modified on 19/06/2014 by Lê Thị Thu Hiền : Sinh tự động phiếu xuất kho bên POS khi check hoàn tất
---- Modified on 08/07/2014 by Lê Thị Thu Hiền : INSERT vào POST9000
---- Modified on 21/07/2014 by Le Thi Thu Hien : Tạo phiếu là sinh phiếu xuất bên POS chứ không cần đủ mới sinh
-- <Example>
---- 
CREATE PROCEDURE WP00971
( 
		@DivisionID AS NVARCHAR(50),
		@TranMonth AS INT,
		@TranYear AS INT,
		@UserID AS NVARCHAR(50),
		@VoucherID AS NVARCHAR(50)
) 
AS 
DECLARE @IsKind AS TINYINT
DECLARE @VoucherID1 AS NVARCHAR(50)
DECLARE @VoucherID2 AS NVARCHAR(50)
DECLARE @VoucherNo1 AS NVARCHAR(50)
DECLARE @VoucherNo2 AS NVARCHAR(50)
SET @VoucherID1 = NEWID()
SET @VoucherID2 = NEWID()

----------->>>>>>> Sinh số phiếu chênh lệch

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
	
---- Lay loai phieu
SET @VoucherTypeID = ( SELECT TOP 1 DiffVoucherTypeID FROM WT0000 W WHERE W.DefDivisionID = @DivisionID)

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
	
-----------<<<<<<<<Sinh số phiếu chênh lệch

----------- Chênh lệch dư (Tăng)

DELETE FROM WT0101 WHERE ReVoucherID = @VoucherID
DELETE FROM WT0102 WHERE ReVoucherID = @VoucherID

INSERT INTO WT0102
(
	DivisionID,	TranMonth,	TranYear,	VoucherID,
	TransactionID,	Orders,	InventoryID,	UnitID,
	Price,	ActualQuantity,	ConvertedAmount,
	Notes,	ReVoucherID,	ReTransactionID,
	Ana01ID,	Ana02ID,	Ana03ID,	Ana04ID,	Ana05ID,
	Ana06ID,	Ana07ID,	Ana08ID,	Ana09ID,	Ana10ID
)
SELECT 
	DivisionID,	TranMonth,	TranYear,	@VoucherID1,
	NEWID(),	Orders,	InventoryID,	UnitID,
	UnitPrice,	W.ReceiveQuantity - W.ActualQuantity,	ConvertedAmount,
	Notes,		VoucherID,	TransactionID,
	Ana01ID,	Ana02ID,	Ana03ID,	Ana04ID,	Ana05ID,
	Ana06ID,	Ana07ID,	Ana08ID,	Ana09ID,	Ana10ID
FROM WT0096 W
WHERE W.DivisionID = @DivisionID
AND W.VoucherID = @VoucherID
AND W.ReceiveQuantity - W.ActualQuantity > 0

IF EXISTS ( SELECT TOP 1 1 FROM WT0102 WHERE ReVoucherID = @VoucherID AND ActualQuantity >0)
BEGIN
EXEC AP0000 @DivisionID ,@VoucherNo1 Output, 'WT0101', @StringKey1, @StringKey2, @StringKey3, @OutputLen, @OutputOrder, @Separated, @Separator
--SELECT (@VoucherNo1)
INSERT INTO WT0101
(
	DivisionID,	VoucherID,	TableID,	TranMonth,	TranYear,
	VoucherTypeID,	VoucherNo,	VoucherDate,
	RefNo01,	RefNo02,	ObjectID,	WareHouseID,
	[Status],	EmployeeID,	IsKind,	[Description],	ReVoucherID,
	CreateUserID,	CreateDate,		LastModifyUserID,	LastModifyDate
)
SELECT 	DivisionID,	@VoucherID1,	TableID,	TranMonth,	TranYear,
		VoucherTypeID,	@VoucherNo1,	VoucherDate,
		RefNo01,	RefNo02,	ObjectID,	WareHouseID,
		0,	EmployeeID,	1,	[Description],	VoucherID,
		@UserID,	GETDATE(),	@UserID,	GETDATE()
FROM	WT0095 W
WHERE	W.DivisionID = @DivisionID
		AND W.VoucherID = @VoucherID

	
END
--------------------<<<<<<<< Chênh lệch dư (Tăng)


------------------->>>>>>>>>> Chênh lệch dư (Giảm)

INSERT INTO WT0102
(
	DivisionID,	TranMonth,	TranYear,	VoucherID,	TransactionID,
	Orders,	InventoryID,	UnitID,	Price,
	ActualQuantity,	ConvertedAmount,	Notes,
	ReVoucherID,	ReTransactionID,
	Ana01ID,	Ana02ID,	Ana03ID,	Ana04ID,	Ana05ID,
	Ana06ID,	Ana07ID,	Ana08ID,	Ana09ID,	Ana10ID
)
SELECT 
	DivisionID,	TranMonth,	TranYear,	@VoucherID2,	NEWID(),
	Orders,	InventoryID,	UnitID,	UnitPrice,
	W.ReceiveQuantity - W.ActualQuantity,	ConvertedAmount,	Notes,
	VoucherID,	TransactionID,
	Ana01ID,	Ana02ID,	Ana03ID,	Ana04ID,	Ana05ID,
	Ana06ID,	Ana07ID,	Ana08ID,	Ana09ID,	Ana10ID
FROM	WT0096 W
WHERE	W.DivisionID = @DivisionID
	AND W.VoucherID = @VoucherID
	AND W.ReceiveQuantity - W.ActualQuantity < 0

IF EXISTS ( SELECT TOP 1 1 FROM WT0102 WHERE ReVoucherID = @VoucherID AND ActualQuantity <0)
BEGIN
EXEC AP0000 @DivisionID ,@VoucherNo2 Output, 'WT0101', @StringKey1, @StringKey2, @StringKey3, @OutputLen, @OutputOrder, @Separated, @Separator
--SELECT (@VoucherNo2)
INSERT INTO WT0101
(
	DivisionID,	VoucherID,	TableID,	TranMonth,	TranYear,	
	VoucherTypeID,	VoucherNo,	VoucherDate,
	RefNo01,	RefNo02,	ObjectID,	WareHouseID,
	[Status],	EmployeeID,	IsKind,	[Description],	ReVoucherID,
	CreateUserID,	CreateDate,		LastModifyUserID,	LastModifyDate
)
SELECT 	DivisionID,	@VoucherID2,	TableID,	TranMonth,	TranYear,
		VoucherTypeID,	@VoucherNo2,	VoucherDate,
		RefNo01,	RefNo02,	ObjectID,	WareHouseID,
		1,	EmployeeID,	0,	[Description],	VoucherID,
		@UserID,	GETDATE(),	@UserID,	GETDATE()
FROM	WT0095 W
WHERE	W.DivisionID = @DivisionID
		AND W.VoucherID = @VoucherID

	
END

-------------------<<<<<<<<<< Chênh lệch dư (Giảm)

/*
---------------->>>>>>>>>>>>> Sinh tự động phiếu xuất kho bên POS khi check hoàn tất
IF NOT EXISTS ( SELECT TOP 1 1 FROM POST0028 WHERE DivisionID = @DivisionID AND APKMInherited = @VoucherID)
BEGIN
						
DECLARE @ExWareHouseID AS NVARCHAR(50),
		@ImWareHouseID AS NVARCHAR(50)
----------->>>>>>> Sinh số phiếu

DECLARE	
	@POSVoucherNo AS NVARCHAR(50),
	@ShopID AS NVARCHAR(50)
	
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

---------- INSERT phiếu chênh lệch 	
SELECT @ExWareHouseID = ISNULL(WareHouseID2,''), @ImWareHouseID = ISNULL(WareHouseID,'') 
FROM WT0095
WHERE DivisionID = @DivisionID
AND VoucherID = @VoucherID
AND KindVoucherID = 3

IF EXISTS ( SELECT TOP 1 1 FROM POST0010 
            WHERE DivisionID = @DivisionID 
            AND WarehouseID = @ExWareHouseID 
            AND WarehouseID <> @ImWareHouseID
            )

    BEGIN
    	
    	DELETE FROM POST0028 WHERE APKMaster = @VoucherID
    	DELETE FROM POST0027 WHERE APK = @VoucherID
    	

    	INSERT INTO POST0027
		(APK, DivisionID, TranMonth, TranYear, ShopID, 
		WarehouseID, WarehouseName, 
		ObjectID, ObjectName, 
		VoucherNo, VoucherDate, 
		VoucherTypeID, 
		EmployeeID, EmployeeName, 
		Description, DeleteFlg, 
		CreateUserID, CreateDate, LastModifyUserID, LastModifyDate
		) 
		
		SELECT @VoucherID ,W.DivisionID, W.TranMonth, W.TranYear, @ShopID, 
		W.WarehouseID2, A.WareHouseName, 
		W.ObjectID, A1.ObjectName, 
		@POSVoucherNo, W.VoucherDate, 
		@VoucherTypeID, 
		W.EmployeeID, A2.FullName AS EmployeeName, 
		[Description], 0,
		@UserID, GETDATE(), @UserID, GETDATE()
		FROM WT0095 W
		LEFT JOIN AT1303 A ON A.DivisionID = W.DivisionID AND A.WareHouseID = W.WareHouseID2
		--LEFT JOIN POST0010 P ON P.DivisionID = A.DivisionID AND P.WareHouseID = W.WareHouseID2
		LEFT JOIN AT1202 A1 ON A1.DivisionID = A.DivisionID AND A1.ObjectID = W.ObjectID
		LEFT JOIN AT1103 A2 ON A2.DivisionID = A1.DivisionID AND A2.EmployeeID = W.EmployeeID
		WHERE	W.DivisionID = @DivisionID
				AND W.VoucherID =  @VoucherID
				AND W.KindVoucherID = 3

		----+ Bảng Detail:
		INSERT INTO POST0028(
			DivisionID, ShopID, APKMaster, APKMInherited, APKDInherited, 
			InventoryID,InventoryName,InventoryTypeID,
			UnitID,UnitName,ShipQuantity,IsStocked, DeleteFlg, 
			Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID,
			Ana06ID, Ana07ID, Ana08ID, Ana09ID, Ana10ID, 
			CreateUserID, CreateDate, LastModifyUserID, LastModifyDate)
		SELECT 
			@DivisionID, @ShopID, @VoucherID, M.VoucherID, D.TransactionID,  
			D.InventoryID, P.InventoryName, M.InventoryTypeID,
			D.UnitID, A.UnitName, isnull(D.ReceiveQuantity,0), 1, 0, 
			D.Ana01ID, D.Ana02ID, D.Ana03ID, D.Ana04ID, D.Ana05ID,
			D.Ana06ID, D.Ana07ID, D.Ana08ID, D.Ana09ID, D.Ana10ID, 
			@UserID, GETDATE(), @UserID, GETDATE()
		FROM WT0095 M 
		INNER JOIN WT0096 D on M.DivisionID = D.DivisionID and M.VoucherID = D.VoucherID
		LEFT JOIN AT1302 P on D.DivisionID = P.DivisionID and D.InventoryID = P.InventoryID 
		LEFT JOIN AT1304 A on D.DivisionID = A.DivisionID and A.UnitID = D.UnitID
		--LEFT JOIN POST0010 P1 ON P1.DivisionID = M.DivisionID AND P1.WareHouseID = M.WareHouseID2
		Where M.DivisionID = @DivisionID
				AND M.VoucherID = @VoucherID
				AND M.KindVoucherID = 3 
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE NAME = 'POST9000' AND XTYPE ='U') 
BEGIN	
		DECLARE @sSQL AS NVARCHAR(MAX)
		SET @sSQL = N'			
		INSERT INTO POST9000 ( 
         APK, DivisionID, ShopID, TableID, VoucherTypeID, TranMonth, 
         IsTransferred, TranYear, VoucherNo, VoucherDate, ObjectID, 
         ObjectName, EmployeeID, EmployeeName, APKMaster, WareHouseID, 
         WareHouseName, InventoryID, InventoryName, UnitID, UnitName, 
         Quantity, DeleteFlg, APKMInherited, APKDInherited, MarkQuantity, 
         Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID, Ana06ID, Ana07ID, 
         Ana08ID, Ana09ID, Ana10ID, CreateUserID, CreateDate, 
         LastModifyUserID, LastModifyDate, IsPromotion)
		SELECT   D.APK, D.DivisionID, D.ShopID, ''POST0027'' as TableID, M.VoucherTypeID, 
				 M.TranMonth, 0 as IsTransferred, M.TranYear, M.VoucherNo, M.VoucherDate, 
				 M.ObjectID, M.ObjectName, M.EmployeeID, M.EmployeeName, D.APKMaster,
				 WareHouseID, WareHouseName, InventoryID, D.InventoryName, D.UnitID, 
				 D.UnitName, D.ShipQuantity, D.DeleteFlg, APKMInherited, APKDInherited, 
				 MarkQuantity, D.Ana01ID, D.Ana02ID, D.Ana03ID, D.Ana04ID, D.Ana05ID, 
				 D.Ana06ID, D.Ana07ID, D.Ana08ID, D.Ana09ID, D.Ana10ID, D.CreateUserID, 
				 D.CreateDate, D.LastModifyUserID, D.LastModifyDate, 0 as IsPromotion
		FROM	POST0027 M 
		INNER JOIN POST0028 D on M.APK = D.APKMaster and M.DeleteFlg = D.DeleteFlg
		WHERE D.APKMaster = '''+@VoucherID+''' and D.DeleteFlg = 0
		'

		PRINT(@sSQL)
		EXEC(@sSQL)
END

    END
	
END	
----------------<<<<<<<<<<<<< Sinh tự động phiếu xuất kho bên POS khi check hoàn tất
*/

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

