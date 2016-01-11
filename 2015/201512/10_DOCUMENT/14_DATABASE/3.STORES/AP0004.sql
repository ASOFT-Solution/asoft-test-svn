IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0004]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0004]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Kiểm tra trùng số seri số hóa đơn
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 04/07/2012 by Lê Thị Thu Hiền
---- 
---- Modified on 26/02/2013 by Lê Thị Thu Hiền : Bổ sung Màn hình bán hàng
-- <Example>
---- EXEC AP0004 'AS', 'ASOFT-T', 'AF0063' , '2','11111', 'EDIT', 'wewewewew'

CREATE PROCEDURE AP0004
( 
	@DivisionID AS NVARCHAR(50),
	@ModuleID AS NVARCHAR(50),
	@FormID AS NVARCHAR(50),
	@Serial AS NVARCHAR(50),
	@InvoiceNo AS NVARCHAR(50),
	@Mode AS NVARCHAR(50) = 'NEW',	--- 'EDIT' : Sửa
							--- 'NEW' : Thêm mới
	@VoucherID AS NVARCHAR(50) = ''
	
) 
AS 
DECLARE @Sql NVARCHAR(MAX),
		@Table NVARCHAR(50),
		@WHERE NVARCHAR(4000),
		@StatusSql TINYINT,
		@Status TINYINT = 0

IF @FormID = 'AF0063' OR @FormID = 'AF0066'
BEGIN
	SET @Table = 'AT9000'
	IF @FormID = 'AF0063' SET @WHERE = 'AND TransactionTypeID = ''T03'''
	IF @FormID = 'AF0066' SET @WHERE = 'AND TransactionTypeID = ''T04'''
	IF @Mode = 'EDIT' SET @WHERE = @WHERE + 'AND VoucherID NOT IN  ('''+@VoucherID+''')'
END

SET @Sql = N'
	SELECT @StatusSql = 1 FROM	'+@Table+' 
	WHERE DivisionID = '''+@DivisionID+'''
		AND ISNULL(Serial,'''') = '''+@Serial+''' 
		AND ISNULL(InvoiceNo,'''') = '''+@InvoiceNo+''''
SET @Sql = @Sql+@WHERE

EXEC sp_executesql @Sql, N'@StatusSql int output', @Status OUTPUT;
PRINT @Sql

SELECT @Status AS Status

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

