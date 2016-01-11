IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP0117]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[MP0117]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- HUỶ BỎ KẾ THỪA BẢNG GIÁ VỐN SẢN PHẨM [Customize Index: 36 - Sài Gòn Petro]
-- <History>
---- Create on 14/05/2015 by Lê Thị Hạnh 
---- Modified by ... on ...: 
---- <Example>
/*
MP0117 @DivisionID = 'VG', @VoucherID = 'b08a212f-729d-4e95-9555-0b5caefbb0bf', @FromMonth = 7, @FromYear = 2014, 
@ToMonth = 9, @ToYear = 2014, @FromProductID = '1521A00001', @ToProductID = 'ZZ'
*/

CREATE PROCEDURE [dbo].[MP0117] 	
	@DivisionID NVARCHAR(50),
	@TranMonth INT,
	@TranYear INT,
	@UserID NVARCHAR(50)
AS
DECLARE @VoucherID NVARCHAR(50),
		@TransactionID NVARCHAR(50),
		@Cur CURSOR,
		@TestID NVARCHAR(50)
		
SET @Cur = CURSOR SCROLL KEYSET FOR
SELECT MT15.DivisionID, MT15.VoucherID, MT16.TransactionID 
FROM MT0115 MT15
INNER JOIN MT0116 MT16 ON MT16.DivisionID = MT15.DivisionID AND MT16.VoucherID = MT15.VoucherID
WHERE MT15.DivisionID = @DivisionID AND MT15.TranYear*12 + MT15.TranMonth = @TranYear*12 + @TranMonth 
	  AND ISNULL(MT16.InheritPCID,'') <> ''
OPEN @Cur
FETCH NEXT FROM @Cur INTO @DivisionID, @VoucherID, @TransactionID
WHILE @@FETCH_STATUS = 0
BEGIN 
	IF (@TestID IS NULL OR @TestID != @VoucherID)
	BEGIN
	DELETE FROM MT0116 WHERE DivisionID = @DivisionID AND VoucherID =@VoucherID AND TransactionID = @TransactionID
	DELETE FROM MT0115 WHERE DivisionID = @DivisionID AND VoucherID = @VoucherID
	SET @TestID = @VoucherID
	END
	ELSE
	BEGIN
	DELETE FROM MT0116 WHERE DivisionID = @DivisionID AND VoucherID =@VoucherID AND TransactionID = @TransactionID	
	END	
	FETCH NEXT FROM @Cur INTO @DivisionID, @VoucherID, @TransactionID
END 
CLOSE @Cur

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
