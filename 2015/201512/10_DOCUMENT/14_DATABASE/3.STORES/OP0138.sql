IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0138]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP0138]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>  
---- Xóa phiếu quyết toán
-- <Param>  
----   
-- <Return>  
----   
-- <Reference>  
----   
-- <History>  
---- Create on 27/10/2014 Mai Trí Thiện
-- <Example>  
----  
/*
	EXEC OP0138	'BBL', 'ASOFTADMIN', 10, 2014, '8CC5C652-F4FD-4347-B8E0-9BB31403D72A'
*/


CREATE PROCEDURE [dbo].[OP0138] 	
	@DivisionID nvarchar(50),
	@UserID nvarchar(50),
	@TranMonth int,
	@TranYear int,
	@OrderID nvarchar(250)

AS
BEGIN
	-- BEGIN TRANSACTION
	BEGIN TRAN T1

	IF EXISTS (SELECT TOP 1 1 FROM OT3004 WHERE OrderID = @OrderID)
	BEGIN 
		--- Cập nhật dữ liệu xác nhận hoàn thành
		UPDATE OT3002
		SET Finish = 0 -- Chưa quyết toán
		WHERE DivisionID = @DivisionID
		AND TransactionID IN (	SELECT RefTransactionID 
								FROM OT3005
								WHERE OrderID = @OrderID)
		
		--- Xóa dữ liệu master
		DELETE OT3004
		WHERE OrderID = @OrderID

		--- Xóa dữ liệu details
		DELETE OT3005
		WHERE OrderID = @OrderID
	END

	-- COMMIT TRANSACTION
	COMMIT TRAN T1
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

