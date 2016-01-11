IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP9005]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP9005]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
 Created by Nguyen Van Nhan,
 Created Date 29.06.2004
 Thuc hien but toan ket chuyen tu dong
 Edited by Bao Anh		Date: 03/11/2012
 Purpose: Sua loi ket chuyen len nhieu dong va so tien bi cong don khi thiet lap co nhieu MPT
 Edited by: [GS] [Hoàng Phước] [29/07/2010]
 Modified by Thanh Sơn: Bổ sung drop store tạo lại cho trường hợp chạy fix lần đầu tiên
*/

CREATE PROCEDURE AP9005
(
	@DivisionID NVARCHAR(50),
	@TranMonth INT,
	@TranYear INT,
	@AllocationID NVARCHAR(50),
	@VoucherNo NVARCHAR(50),
	@VoucherDate NVARCHAR(20),			
	@BDescription nvarchar(250),
	@VDescription NVARCHAR(250),
	@TDescription  NVARCHAR(250),
	@CreateUserID NVARCHAR(50),
	@LastModifyUserID NVARCHAR(50)
)
AS

SET NOCOUNT ON
DECLARE	@Cur CURSOR,
		@SequenceDesc NVARCHAR(250),
		@SourceAccountIDFrom NVARCHAR(50),
		@SourceAccountIDTo NVARCHAR(50),
		@TargetAccountID NVARCHAR(50),
		@SourceAmountID TINYINT,
		@AllocationMode TINYINT,
		@Percentage DECIMAL(28,8),
		@VoucherTypeID NVARCHAR(50),
		@Ana01ID NVARCHAR(50),
		@Ana02ID NVARCHAR(50),
		@Ana03ID NVARCHAR(50),
		@Ana04ID NVARCHAR(50),
		@Ana05ID NVARCHAR(50)
		--@LastModifyUserID NVARCHAR(20)

SET @LastModifyUserID = @CreateUserID

IF EXISTS (SELECT 1 FROM AT7802 WHERE AllocationID = @AllocationID AND DivisionID = @DivisionID)
BEGIN
	SET @Cur = CURSOR SCROLL KEYSET FOR
		SELECT T2.SequenceDesc,		---- Thu tu buoc thuc hien
			T2.SourceAccountIDFrom,	---- Tu tai khoan nguon
			T2.SourceAccountIDTo,		---- Den tai khoan nguon	
			T2.TargetAccountID,		---- Tai khoan dich: can ket chuyen vao
			T2.SourceAmountID,		---- So du No, So Du Co, So Lon hon		
			T2.AllocationMode,		----- Ket chuyen so Trong Ky, Trong Nam, So du					
			T2.Percentage,			---- Ty lap phan tram ket chuyen						
			T2.VoucherTypeID, T2.SequenceDesc, T2.SequenceDesc,
			ISNULL(T2.Ana01ID,''), ISNULL(T2.Ana02ID,''), ISNULL(T2.Ana03ID,''), ISNULL(T2.Ana04ID,''), ISNULL(T2.Ana05ID,'')
		FROM AT7802 T2
			INNER JOIN AT7801 T1 ON	T2.AllocationID = T1.AllocationID AND T2.DivisionID = T1.DivisionID
		WHERE T2.AllocationID = @AllocationID AND T2.DivisionID = @DivisionID
		ORDER BY T2.SequenceID

	OPEN @Cur
	FETCH NEXT FROM @Cur INTO
		@SequenceDesc, @SourceAccountIDFrom, @SourceAccountIDTo, @TargetAccountID, @SourceAmountID,
		@AllocationMode, @Percentage,  @VoucherTypeID, @BDescription, @TDescription,
		@Ana01ID, @Ana02ID, @Ana03ID, @Ana04ID, @Ana05ID
		
	WHILE @@FETCH_STATUS = 0
	BEGIN
--	    Print ' TEST ' +@AllocationID+' @VDescription '+ @SourceAccountIDFrom
		EXEC AP9006 @AllocationID, @DivisionID, @TranMonth, @TranYear, @VoucherTypeID, @VoucherNo,
			@VoucherDate, @VDescription, @BDescription, @TDescription, @SourceAccountIDFrom ,
			@SourceAccountIDTo,	@TargetAccountID, @SourceAmountID,@AllocationMode, @Percentage,
			@SequenceDesc, @CreateUserID, @LastModifyUserID, @Ana01ID, @Ana02ID, @Ana03ID, @Ana04ID, @Ana05ID
			
		FETCH NEXT FROM @Cur INTO
			@SequenceDesc, @SourceAccountIDFrom, @SourceAccountIDTo, @TargetAccountID, @SourceAmountID,
			@AllocationMode, @Percentage,  @VoucherTypeID, @BDescription, @TDescription,
			@Ana01ID, @Ana02ID, @Ana03ID, @Ana04ID, @Ana05ID	

	END
	CLOSE @Cur
	DEALLOCATE @Cur
END

SET NOCOUNT OFF

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
