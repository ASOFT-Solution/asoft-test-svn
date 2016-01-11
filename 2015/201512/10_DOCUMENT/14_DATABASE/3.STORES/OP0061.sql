IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0061]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP0061]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- <Summary>
---- Kiểm tra sửa /xóa lệnh điều động của BOURBON
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 29/09/2014 by Le Thi Thu Hien
---- 
---- Modified on 29/09/2014 by 
-- <Example>
---- Exec OP0061 'VG', 'ASOFTADMIN', 7, 2014, 'GT/07/2014/0001'
---  exec OP0061 @DivisionID=N'VG',@UserID=N'ASOFTADMIN',@TranMonth=7,@TranYear=2014,@VoucherID=N'DC/07/2014/0030'

CREATE PROCEDURE OP0061
( 
	@DivisionID AS NVARCHAR(50),
	@UserID AS NVARCHAR(50),
	@TranMonth AS TINYINT,
	@TranYear AS INT,
	@VoucherID AS NVARCHAR(50)
) 
AS 
DECLARE @Status AS tinyint,  --- 1: Khong cho xoa, sua:    2--- co canh bao nhung  cho xoa cho sua; --3: Cho sua mot phan thoi
		@EngMessage as NVARCHAR(2000), 
		@VieMessage as NVARCHAR(2000)

SELECT 	@Status = 0, 
		@EngMessage = '',
		@VieMessage = ''

If exists (Select top 1 1 From OT3002
				INNER JOIN OT3001 ON OT3002.DivisionID = OT3001.DivisionID AND OT3002.POrderID = OT3001.POrderID 
	           Where OT3002.DivisionID = @DivisionID
	           AND OT3002.Notes01 = @VoucherID
	           AND OT3001.KindVoucherID = 2)
Begin
		Set @Status = 1
		Set @VieMessage ='OFML000221'
		Set @EngMessage ='This order is used. You can not delete one. You must check!'
		Goto EndMess
END		


EndMess:
SELECT @Status AS Status, @EngMessage AS EngMessage, @VieMessage as VieMessage



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
