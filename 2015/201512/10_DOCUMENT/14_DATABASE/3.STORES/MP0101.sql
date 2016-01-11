IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP0101]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[MP0101]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Xóa phiếu xuất kho nguyên vật liệu và nhập phế liệu của thành phẩm
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 01/06/2012 by Lê Thị Thu Hiền
---- 
---- Modified on 01/06/2012 by 
-- <Example>
---- 
CREATE PROCEDURE MP0101
( 
		@DivisionID AS NVARCHAR(50),
		@UserID AS NVARCHAR(50),
		@VoucherID AS NVARCHAR(50)
) 
AS 

---------Xóa phiếu nhập xuất nguyên vật liệu , phế liệu cũ
DELETE FROM AT2007 WHERE DivisionID = @DivisionID AND MOrderID = @VoucherID
DELETE FROM AT2006 WHERE DivisionID = @DivisionID AND MOrderID = @VoucherID

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

