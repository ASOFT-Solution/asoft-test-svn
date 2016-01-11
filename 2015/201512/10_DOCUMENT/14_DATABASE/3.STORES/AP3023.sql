IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP3023]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP3023]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Báo cáo doanh số đơn hàng bán
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 17/10/2003 by Hoang Thi Lan
---- Modified on 05/12/2009 by B.Anh: Lay them truong VoucherTypeID, DiscountAmount
---- Modified on 29/07/2010 by Hoàng Phước
---- Modified on 05/03/2014 by Le Thi Thu Hien : Bo sung phan quyen xem du lieu cua nguoi khac
---- Modified on 08/01/2016 by Tiểu Mai: Bổ sung thông tin quy cách khi có thiết lập quản lý mặt hàng theo quy cách.
-- <Example>
---- 
CREATE PROCEDURE [dbo].[AP3023] 	
(
	@DivisionID AS NVARCHAR(50) ,
	@sSQLWhere AS NVARCHAR(4000) ,
	@TranMonth AS INT,
	@TranYear AS INT,
	@UserID AS VARCHAR(50) = '' 
)	 
AS


DECLARE @sSQL1  AS NVARCHAR(4000),
        @sSQL2  AS NVARCHAR(4000)
----------------->>>>>> Phân quyền xem chứng từ của người dùng khác		
DECLARE @sSQLPer AS NVARCHAR(MAX),
		@sWHEREPer AS NVARCHAR(MAX)
SET @sSQLPer = ''
SET @sWHEREPer = ''		

IF EXISTS (SELECT TOP 1 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsPermissionView = 1 ) -- Nếu check Phân quyền xem dữ liệu tại Thiết lập hệ thống thì mới thực hiện
	BEGIN
		SET @sSQLPer = ' LEFT JOIN AT0010 ON AT0010.DivisionID = AT9000.DivisionID 
											AND AT0010.AdminUserID = '''+@UserID+''' 
											AND AT0010.UserID = AT9000.CreateUserID '
		SET @sWHEREPer = ' AND (AT9000.CreateUserID = AT0010.UserID
								OR  AT9000.CreateUserID = '''+@UserID+''') '		
	END

-----------------<<<<<< Phân quyền xem chứng từ của người dùng khác	
IF EXISTS (SELECT TOP 1 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
BEGIN
	SET @sSQL1 = N'	
	SELECT		AT9000.InventoryID,
				CASE WHEN ISNULL(AT9000.InventoryName1, '''') = '''' THEN ISNULL(AT1302.InventoryName, '''')
				ELSE AT9000.InventoryName1 END AS InventoryName,
				ISNULL(AT1302.Specification, '''') AS Specification,
				ISNULL(AT1302.Varchar01, '''') AS Varchar01,
				ISNULL(AT1302.Varchar02, '''') AS Varchar02,
				AT1302.UnitID,
				AT1304.UnitName,
				SUM(AT9000.Quantity) AS Quantity,
				AT9000.CurrencyID,
				AT1302.SalePrice01,
				AT1302.S1,
				AT1302.S2,
				AT1302.S3,
				VDescription,
				SUM(AT9000.OriginalAmount) AS OriginalAmount,
				SUM(AT9000.ConvertedAmount) AS ConvertedAmount,
				SUM(AT9000.DiscountAmount) AS DiscountAmount,
				AT9000.VoucherTypeID,
				AT9000.DivisionID,
				O99.S01ID,O99.S02ID,O99.S03ID,O99.S04ID,O99.S05ID,O99.S06ID,O99.S07ID,O99.S08ID,O99.S09ID,O99.S10ID,
				O99.S11ID,O99.S12ID,O99.S13ID,O99.S14ID,O99.S15ID,O99.S16ID,O99.S17ID,O99.S18ID,O99.S19ID,O99.S20ID
	FROM		AT9000
	LEFT JOIN	AT1302
			ON  AT9000.InventoryID = AT1302.InventoryID
				AND AT9000.DivisionID = AT1302.DivisionID
	LEFT JOIN	AT1304
			ON  AT1304.UnitID = AT1302.UnitID
				AND AT9000.DivisionID = AT1304.DivisionID
	LEFT JOIN AT8899 O99 ON O99.DivisionID = AT9000.DivisionID AND O99.VoucherID = AT9000.VoucherID AND O99.TransactionID = AT9000.TransactionID			
	'+@sSQLPer+'
	WHERE		AT9000.DivisionID = ''' + @DivisionID + '''
				'+@sWHEREPer+'
				AND AT9000.TransactionTypeID IN (''T04'', ''T40'')
				AND ' + @sSQLWhere + ''

	SET @sSQL2 = N'  
	GROUP BY 	AT9000.InventoryID, AT1302.InventoryName, AT1302.UnitID, AT1304.UnitName,	
				AT9000.Quantity,
				AT9000.CurrencyID,AT9000.InventoryName1, Specification, Varchar01, 
				Varchar02,	AT1302.SalePrice01,
				AT1302.S1, AT1302.S2, AT1302.S3, VDescription, AT9000.VoucherTypeID, 
				AT9000.DivisionID,
				O99.S01ID,O99.S02ID,O99.S03ID,O99.S04ID,O99.S05ID,O99.S06ID,O99.S07ID,O99.S08ID,O99.S09ID,O99.S10ID,
				O99.S11ID,O99.S12ID,O99.S13ID,O99.S14ID,O99.S15ID,O99.S16ID,O99.S17ID,O99.S18ID,O99.S19ID,O99.S20ID
	'

END 
ELSE
BEGIN
	SET @sSQL1 = N'	
	SELECT		AT9000.InventoryID,
				CASE WHEN ISNULL(AT9000.InventoryName1, '''') = '''' THEN ISNULL(AT1302.InventoryName, '''')
				ELSE AT9000.InventoryName1 END AS InventoryName,
				ISNULL(AT1302.Specification, '''') AS Specification,
				ISNULL(AT1302.Varchar01, '''') AS Varchar01,
				ISNULL(AT1302.Varchar02, '''') AS Varchar02,
				AT1302.UnitID,
				AT1304.UnitName,
				SUM(AT9000.Quantity) AS Quantity,
				AT9000.CurrencyID,
				AT1302.SalePrice01,
				AT1302.S1,
				AT1302.S2,
				AT1302.S3,
				VDescription,
				SUM(AT9000.OriginalAmount) AS OriginalAmount,
				SUM(AT9000.ConvertedAmount) AS ConvertedAmount,
				SUM(AT9000.DiscountAmount) AS DiscountAmount,
				AT9000.VoucherTypeID,
				AT9000.DivisionID
	FROM		AT9000
	LEFT JOIN	AT1302
			ON  AT9000.InventoryID = AT1302.InventoryID
				AND AT9000.DivisionID = AT1302.DivisionID
	LEFT JOIN	AT1304
			ON  AT1304.UnitID = AT1302.UnitID
				AND AT9000.DivisionID = AT1304.DivisionID
	'+@sSQLPer+'
	WHERE		AT9000.DivisionID = ''' + @DivisionID + '''
				'+@sWHEREPer+'
				AND AT9000.TransactionTypeID IN (''T04'', ''T40'')
				AND ' + @sSQLWhere + ''

	SET @sSQL2 = N'  
	GROUP BY 	AT9000.InventoryID, AT1302.InventoryName, AT1302.UnitID, AT1304.UnitName,	
				AT9000.Quantity,
				AT9000.CurrencyID,AT9000.InventoryName1, Specification, Varchar01, 
				Varchar02,	AT1302.SalePrice01,
				AT1302.S1, AT1302.S2, AT1302.S3, VDescription, AT9000.VoucherTypeID, 
				AT9000.DivisionID
	'
	
END			 

--print @sSQL
IF NOT EXISTS (SELECT TOP 1 1 FROM   SysObjects WHERE  NAME = 'AV3023' AND Xtype = 'V')
    EXEC ('CREATE VIEW AV3023 AS ' + @sSQL1 + @sSQL2)
ELSE
    EXEC ('ALTER VIEW AV3023 AS ' + @sSQL1 + @sSQL2)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

