IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0106]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0106]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Create on 20/01/2014 by Bảo Anh
---- Load đơn hàng bán cho màn hình chọn đơn hàng bán để lập hợp đồng (customize Sinolife)
---- Modify on 03/01/2016 by Bảo Anh: Bổ sung cho Angel
---- EXEC AP0106 N'AS',3,2012,3,2012,''

CREATE PROCEDURE AP0106
( 
	@DivisionID NVARCHAR(50),
	@FromMonth int,
	@FromYear int,
	@ToMonth int,
	@ToYear int,
	@ContractID nvarchar(50) --- addnew: ''
)
AS
Declare @SOrderID nvarchar(50),
		@CustomerIndex as tinyint

SELECT @CustomerIndex = CustomerName FROM CustomerIndex

IF @CustomerIndex = 20 --- Sinolife
BEGIN
	SELECT @SOrderID = SOrderID FROM AT1020 Where DivisionID = @DivisionID AND Isnull(ContractID,'') = @ContractID

	SELECT
		  VoucherNo, OrderDate, SOrderID, OT2001.ObjectID, AT1202.ObjectName     
	FROM OT2001
	LEFT JOIN AT1202 ON OT2001.DivisionID = AT1202.DivisionID AND OT2001.ObjectID = AT1202.ObjectID
	WHERE OT2001.DivisionID = @DivisionID
	AND OT2001.[Disabled] = 0 AND OrderType = 0
	AND (TranYear * 100 + TranMonth BETWEEN @FromYear * 100 + @FromMonth AND @ToYear * 100 + @ToMonth)
	AND Isnull((SELECT top 1 1 FROM OT2002 Where DivisionID = @DivisionID And SOrderID = OT2001.SOrderID
				And TransactionID not in (Select STransactionID From AT1020 Where DivisionID = @DivisionID And SOrderID = OT2001.SOrderID)),0) = 1
	OR OT2001.SOrderID = @SOrderID
	ORDER BY OrderDate, VoucherNo
END

ELSE IF @CustomerIndex = 57 --- Angel
BEGIN
	SELECT TOP 1 @SOrderID = InheritVoucherID FROM AT1031 Where DivisionID = @DivisionID AND Isnull(ContractID,'') = @ContractID
	
	SELECT
		  VoucherNo, OrderDate, SOrderID, OT2001.ObjectID, AT1202.ObjectName     
	FROM OT2001
	LEFT JOIN AT1202 ON OT2001.DivisionID = AT1202.DivisionID AND OT2001.ObjectID = AT1202.ObjectID
	WHERE OT2001.DivisionID = @DivisionID
	AND OT2001.[Disabled] = 0 AND OrderType = 0
	AND (TranYear * 100 + TranMonth BETWEEN @FromYear * 100 + @FromMonth AND @ToYear * 100 + @ToMonth)
	AND EXISTS (Select top 1 1 From OT2002 Where DivisionID = @DivisionID And SOrderID = OT2001.SOrderID
				And TransactionID not in (Select InheritTransactionID From AT1031 Where DivisionID = @DivisionID))
	OR OT2001.SOrderID = @SOrderID
	ORDER BY OrderDate, VoucherNo
END
	
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

