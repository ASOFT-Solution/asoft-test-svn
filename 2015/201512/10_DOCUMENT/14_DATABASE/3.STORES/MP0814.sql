IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP0814]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[MP0814]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--- Created by Bảo Anh	Date: 21/08/2013
--- Purpose: xóa chấm công sản phẩm được kết chuyển từ KQSX (Thuận Lợi)
--- EXEC MP0814 'AS','MP2012000000023','admin'

CREATE PROCEDURE [dbo].[MP0814]  
				@DivisionID nvarchar(50),
				@VoucherID nvarchar(50),
				@UserID nvarchar(50)
				
AS

DECLARE 	@sSQL nvarchar(4000),
	    	@TimesID nvarchar(50),	    	
			@EmployeeID nvarchar(50),
			@ProductID nvarchar(50),
			@Quantity decimal(28,8),
			@TranMonth int,
			@TranYear int,
			@_Cur as cursor

--- Lấy lần chấm công mặc định đầu tiên trong danh mục
SELECT Top 1 @TimesID = TimesID FROM HT1019 WHERE DivisionID = @DivisionID Order by TimesID

SET NOCOUNT ON

Set @_Cur = Cursor Scroll KeySet For
SELECT TranMonth, TranYear, HRMEmployeeID, ProductID, Quantity
FROM MT1001 
WHERE DivisionID = @DivisionID AND VoucherID = @VoucherID
	
Open @_Cur
Fetch Next From @_Cur Into @TranMonth, @TranYear, @EmployeeID, @ProductID, @Quantity

WHILE @@Fetch_Status = 0		
	Begin
		UPDATE HT2403 SET Quantity = Quantity - ISNULL(@Quantity,0), LastModifyUserID = @UserID, LastModifyDate = GETDATE()
		WHERE DivisionID = @DivisionID AND TranMonth = @TranMonth AND TranYear = @TranYear AND EmployeeID = @EmployeeID
		AND TimesID = @TimesID AND ProductID = @ProductID And Isnull(IsFromAsoftM,0) = 1
		
		IF EXISTS (SELECT TOP 1 1 FROM HT2403 WHERE DivisionID = @DivisionID AND TranMonth = @TranMonth AND TranYear = @TranYear AND EmployeeID = @EmployeeID AND TimesID = @TimesID AND ProductID = @ProductID And Isnull(Quantity,0) = 0 And Isnull(IsFromAsoftM,0) = 1)	
			DELETE HT2403 WHERE DivisionID = @DivisionID AND TranMonth = @TranMonth AND TranYear = @TranYear AND EmployeeID = @EmployeeID AND TimesID = @TimesID AND ProductID = @ProductID And Isnull(Quantity,0) = 0 And Isnull(IsFromAsoftM,0) = 1
			
		Fetch Next From @_Cur Into @TranMonth, @TranYear, @EmployeeID, @ProductID, @Quantity	
	End
	
Close @_Cur
	
SET NOCOUNT OFF

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON