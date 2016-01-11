IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0155]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP0155]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Kiểm tra bỏ duyệt đơn hàng bán lần 2 tại OF0138- Duyệt đơn hàng bán lần 2 [Customize LAVO]
-- <History>
---- Create on 05/01/2015 by Lê Thị Hạnh 
---- Modified on ... by 
-- <Example>
/*
OP0155 @DivisionID = 'CA', @SOrderID = 'EO/12/2014/0361'
 */
CREATE PROCEDURE [dbo].[OP0155]  
		@DivisionID NVARCHAR(50),
		@SOrderID NVARCHAR(50)
 AS
DECLARE @sSQL1 NVARCHAR(MAX),
		@sWhere NVARCHAR(MAX)

DECLARE @Status TINYINT,
		@Message NVARCHAR(250),
		@VoucherNoList NVARCHAR(1000)
--@Status = 1: Khong cho bỏ duyệt
--@Status = 2: Co canh bao nhung cho bỏ duyệt
--@Status = 3: Cho sua mot phan thoi
Select @Status = 0, 	@Message ='', @VoucherNoList = ''
	-- Đã sử dụng trong bảng AT9000 hay chưa?
IF EXISTS (SELECT TOP 1 1 FROM AT9000 WHERE DivisionID = @DivisionID AND OrderID = @SOrderID)
	BEGIN
			SET @Status = 1
			SET @Message ='OFML000236'
			SET @VoucherNoList =  (SELECT STUFF((SELECT DISTINCT N', ' + VoucherNo
												FROM AT9000
												WHERE DivisionID = @DivisionID AND OrderID = @SOrderID
												FOR XML PATH('')),1,2,N''))
			GOTO EndMess
	END 

-------------------------------------------------------------------
EndMess:
	Select @Status as Status, @Message as MESSAGE, @VoucherNoList AS VoucherNoList
	
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON