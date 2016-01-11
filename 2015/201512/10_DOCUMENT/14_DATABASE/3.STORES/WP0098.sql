IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WP0098]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[WP0098]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- Duyệt và bỏ duyệt phiếu yêu cầu nhập - xuất - VCNB
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
----Created by: Thanh Sơn on 28/05/2014
---- Modified by Tiểu Mai, on 05/11/2015: bổ sung in ssert và delete table WT8899 (khi quản lý hàng theo quy cách.)
-- <Example>
/*
    EXEC WP0098 'EIS','','59AI20140000000008',1
*/

 CREATE PROCEDURE WP0098
(
     @DivisionID NVARCHAR(2000),
     @UserID VARCHAR(50),
     @VoucherID VARCHAR(50),
     @Mode TINYINT --0: Duyệt,1: Bỏ duyệt
)
AS
DECLARE @NewVoucherID1 UNIQUEIDENTIFIER, @NewVoucherID VARCHAR(50)
SET @NewVoucherID1 = NEWID()
SET @NewVoucherID = @NewVoucherID1
IF @Mode = 0
BEGIN
	IF NOT EXISTS (SELECT TOP 1 1 FROM AT2007 WHERE DivisionID = @DivisionID AND InheritTableID = 'WT0095' And InheritVoucherID = @VoucherID)
	BEGIN
		INSERT INTO AT2006 (DivisionID, VoucherID, TableID, TranMonth, TranYear, VoucherTypeID, VoucherDate, VoucherNo, ObjectID, ProjectID,
					OrderID, BatchID, WareHouseID, ReDeTypeID, KindVoucherID, WareHouseID2, [Status], EmployeeID, [Description], CreateDate,
					CreateUserID, LastModifyUserID, LastModifyDate, RefNo01, RefNo02, RDAddress, ContactPerson, VATObjectName, InventoryTypeID,
					IsGoodsFirstVoucher, MOrderID, ApportionID, IsInheritWarranty, EVoucherID, IsGoodsRecycled, IsVoucher)
		SELECT DivisionID, @NewVoucherID, 'AT2006', TranMonth, TranYear, VoucherTypeID, VoucherDate, VoucherNo, ObjectID, ProjectID,
					OrderID, BatchID, WareHouseID, ReDeTypeID, KindVoucherID, WareHouseID2, [Status], EmployeeID, [Description], CreateDate,
					CreateUserID, LastModifyUserID, LastModifyDate, RefNo01, RefNo02, RDAddress, ContactPerson, VATObjectName, InventoryTypeID,
					IsGoodsFirstVoucher, MOrderID, ApportionID, IsInheritWarranty, EVoucherID, IsGoodsRecycled, IsVoucher
		FROM WT0095
		WHERE DivisionID = @DivisionID
		AND VoucherID = @VoucherID
		IF NOT EXISTS (SELECT TOP 1 1 FROM AT2007 WHERE DivisionID = @DivisionID AND VoucherID = @NewVoucherID)
		BEGIN
			INSERT INTO AT2007 (DivisionID, TransactionID, VoucherID, BatchID, InventoryID, UnitID, ActualQuantity, UnitPrice, OriginalAmount, ConvertedAmount,
					Notes, TranMonth, TranYear, CurrencyID, ExchangeRate, SaleUnitPrice, SaleAmount, DiscountAmount, SourceNo,
					DebitAccountID, CreditAccountID, LocationID, ImLocationID, LimitDate, Orders, ConversionFactor, ReTransactionID, ReVoucherID,
					Ana01ID, Ana02ID, Ana03ID, PeriodID, ProductID, OrderID, InventoryName1, Ana04ID, Ana05ID, OTransactionID, ReSPVoucherID,
					ReSPTransactionID, ETransactionID, MTransactionID, Parameter01, Parameter02, Parameter03, Parameter04, Parameter05,
					ConvertedQuantity, ConvertedPrice, ConvertedUnitID, MOrderID, SOrderID, STransactionID, Ana06ID, Ana07ID, Ana08ID, Ana09ID,
					Ana10ID, LocationCode, Location01ID, Location02ID, Location03ID, Location04ID, Location05ID, WVoucherID, Notes01, Notes02, Notes03,
					Notes04, Notes05, Notes06, Notes07, Notes08, Notes09, Notes10, Notes11, Notes12, Notes13, Notes14, Notes15, MarkQuantity,
					OExpenseConvertedAmount, StandardPrice, StandardAmount, InheritTableID, InheritVoucherID, InheritTransactionID)
			SELECT WT0096.DivisionID, NEWID(), @NewVoucherID, BatchID, InventoryID, UnitID, ActualQuantity, UnitPrice, OriginalAmount, ConvertedAmount,
					Notes, TranMonth, TranYear, CurrencyID, ExchangeRate, SaleUnitPrice, SaleAmount, DiscountAmount, SourceNo,
					DebitAccountID, CreditAccountID, LocationID, ImLocationID, LimitDate, Orders, ConversionFactor, ReTransactionID, @NewVoucherID,
					Ana01ID, Ana02ID, Ana03ID, PeriodID, ProductID, OrderID, InventoryName1, Ana04ID, Ana05ID, OTransactionID, ReSPVoucherID,
					ReSPTransactionID, ETransactionID, MTransactionID, Parameter01, Parameter02, Parameter03, Parameter04, Parameter05,
					ConvertedQuantity, ConvertedPrice, ConvertedUnitID, MOrderID, SOrderID, STransactionID, Ana06ID, Ana07ID, Ana08ID, Ana09ID,
					Ana10ID, LocationCode, Location01ID, Location02ID, Location03ID, Location04ID, Location05ID, WVoucherID, Notes01, Notes02, Notes03,
					Notes04, Notes05, Notes06, Notes07, Notes08, Notes09, Notes10, Notes11, Notes12, Notes13, Notes14, Notes15, MarkQuantity,
					OExpenseConvertedAmount,StandardPrice, StandardAmount, 'WT0095', @VoucherID, WT0096.TransactionID
			FROM WT0096
			LEFT JOIN WT8899 O99 ON O99.DivisionID = WT0096.DivisionID AND O99.VoucherID = WT0096.VoucherID AND O99.TransactionID = WT0096.TransactionID
			WHERE WT0096.DivisionID = @DivisionID
			AND WT0096.VoucherID = @VoucherID
			IF EXISTS (SELECT 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
				INSERT INTO WT8899 (DivisionID, TableID, TransactionID, VoucherID, S01ID, S02ID,S03ID,S04ID,S05ID,S06ID,S07ID,S08ID,S09ID,S10ID,S11ID,S12ID,S13ID,S14ID,S15ID,S16ID,S17ID,S18ID,S19ID,S20ID)
				SELECT T07.DivisionID,'AT2007', T07.TransactionID, T07.VoucherID, O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID, 
						O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
				FROM WT0096 
				LEFT JOIN WT8899 O99 ON O99.DivisionID = WT0096.DivisionID AND O99.VoucherID = WT0096.VoucherID AND O99.TransactionID = WT0096.TransactionID
				LEFT JOIN AT2007 T07 ON T07.DivisionID = WT0096.DivisionID AND T07.InheritVoucherID = WT0096.InheritVoucherID AND T07.InheritTransactionID = WT0096.InheritTransactionID, AT2007 a 
				WHERE WT0096.DivisionID = @DivisionID
				AND WT0096.VoucherID = @VoucherID
			
		END
			
	
	 SELECT TOP 1 VoucherNo FROM AT2006 A06
	 LEFT JOIN AT2007 A07 ON A07.DivisionID = A06.DivisionID AND A07.VoucherID = A06.VoucherID	 
	 WHERE A07.InheritVoucherID = @VoucherID
	END

END

IF @Mode = 1
BEGIN
	SELECT TOP 1 VoucherNo FROM AT2006 A06
	LEFT JOIN AT2007 A07 ON A07.DivisionID = A06.DivisionID AND A07.VoucherID = A06.VoucherID	 
    WHERE A07.InheritVoucherID = @VoucherID  
    IF EXISTS (SELECT 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
		DELETE WT8899
		FROM WT8899 LEFT JOIN AT2007 ON AT2007.DivisionID = WT8899.DivisionID AND AT2007.VoucherID = WT8899.VoucherID AND AT2007.TransactionID = WT8899.TransactionID
		WHERE WT8899.DivisionID = @DivisionID AND AT2007.VoucherID = @VoucherID  
    DELETE AT2006 WHERE DivisionID = @DivisionID AND VoucherID IN (SELECT VoucherID FROM AT2007 WHERE DivisionID = @DivisionID AND InheritVoucherID = @VoucherID)
	DELETE AT2007 WHERE DivisionID = @DivisionID AND InheritVoucherID = @VoucherID
	
	
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO