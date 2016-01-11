IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP1304]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP1304]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- <Summary>
---- Load bảng giá cho màn hình lập đơn hàng bán
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 15/09/2011 by Nguyễn Bình Minh
---- 
---- Modified on 22/08/2012 by Lê Thị Thu Hiền : Sửa điều kiện lọc theo ngày
---- Modified on 24/09/2012 by Lê Thị Thu Hiền : Bổ sung TypeID phân biệt giá mua hay giá bán
-- <Example>
---- EXEC OP1304 N'AS', N'', '2011/09/01'
CREATE PROCEDURE OP1304
( 
	@DivisionID NVARCHAR(50),
	@ObjectID NVARCHAR(50),
	@VoucherDate DATETIME,
	@TypeID AS INT = 0	-- 0 : Giá bán
						-- 1 : Giá mua
)
AS 
DECLARE @IsPriceControl AS TINYINT,
		@OTypeID AS NVARCHAR(50)
		
SELECT	@OTypeID = OPriceTypeID + 'ID',
		@IsPriceControl = IsPriceControl
FROM	OT0000
WHERE	DivisionID = @DivisionID

IF @IsPriceControl = 1
BEGIN
	SELECT		ID AS PriceListID, Description AS PriceListName
	FROM		OT1301					
	WHERE		
	CONVERT(datetime,@VoucherDate, 101) BETWEEN CONVERT(datetime,FromDate,101) AND CONVERT(datetime,ISNULL (ToDate, '9999-01-01'),101)
	
				AND DivisionID = @DivisionID AND [Disabled] = 0
				AND (SELECT	TOP 1
							CASE	WHEN @OTypeID = 'O01ID' THEN ISNULL(O01ID, '')
									WHEN @OTypeID = 'O02ID' THEN ISNULL(O02ID, '')
									WHEN @OTypeID = 'O03ID' THEN ISNULL(O03ID, '')
									WHEN @OTypeID = 'O04ID' THEN ISNULL(O04ID, '')
							ELSE ISNULL(O05ID, '%')												 
							END 
		                    FROM AT1202
		                    WHERE ObjectID = @ObjectID
					) LIKE OID	
	AND ISNULL(TypeID , 0 ) = @TypeID					
	ORDER BY	ID			
END
ELSE
	SELECT '' AS PriceListID, '' AS PriceListName

-- SQL dùng để tạo dataset
/*
DROP TABLE OP1304Z

SELECT ID AS PriceListID, Description AS PriceListName
INTO OP1304Z
FROM OT1301	
*/

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

