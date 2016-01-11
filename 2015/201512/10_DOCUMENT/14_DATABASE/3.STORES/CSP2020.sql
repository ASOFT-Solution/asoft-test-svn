IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[CSP2020]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[CSP2020]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Load hồ sơ bảo hành sửa chữa cơ giới
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 09/07/2013 by Lê Thị Thu Hiền
---- 
---- Modified on 09/07/2013 by 
-- <Example>
---- 
CREATE PROCEDURE CSP2020
( 
		@DivisionID as nvarchar(50),
		@UserID as nvarchar(50),
		@TranMonth as int,
		@TranYear as int
) 
AS 

SELECT	C.APK,
		C.DivisionID,
		C.TranMonth,
		C.TranYear,
		C.VoucherID,
		C.VoucherTypeID,
		C.VoucherNo,
		C.VoucherDate,
		C.DeviceGroupID,
		C.DeviceID,
		C.DeviceNumber,
		C.EmployeeID, C1.FullName,
		C.FrameNumber,
		C.EngineNumber,
		C.Notes,
		C.CreateUserID,
		C.CreateDate,
		C.LastModifyUserID,
		C.LastModifyDate 
FROM	CST2020 C
LEFT JOIN AT1103 C1 ON C1.DivisionID = C.DivisionID AND C1.EmployeeID = C.EmployeeID
WHERE	C.DivisionID = @DivisionID
		AND C.TranMonth = @TranMonth
		AND C.TranYear = @TranYear

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

