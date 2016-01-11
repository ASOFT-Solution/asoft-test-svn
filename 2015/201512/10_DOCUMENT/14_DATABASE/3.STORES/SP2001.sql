IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[SP2001]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[SP2001]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Đổ nguồn lưới chi tiết 
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 20/07/2012 by Lê Thị Thu Hiền
---- 
---- Modified on 09/08/2012 by Lê Thị Thu Hiền : Bổ sung ObjectID,ObjectName,ObjectAddress,Mobile
-- <Example>
---- EXEC SP2001 'AS', 'ADMIN'
CREATE PROCEDURE SP2001
( 
	@DivisionID AS NVARCHAR(50),
	@UserID AS NVARCHAR(50)
	
) 
AS 

--SELECT * FROM CST2010
--SELECT * FROM CST2011 
--SELECT * FROM CST2012
--SELECT * FROM CST2013

DECLARE @Ssql AS NVARCHAR(4000)

SET @Ssql = N'
SELECT	CS.DivisionID,		CS.VoucherID,
		CS.InventoryID,		A.InventoryName,
		CS.Quantity,		CS.Price,			CS.Amount,
		A.UnitID,
		C.ObjectID,	
		CASE WHEN ISNULL(AT1202.IsUpdateName, 0) = 0 THEN AT1202.ObjectName ELSE C.ObjectName END ObjectName,	
		CASE WHEN ISNULL(AT1202.IsUpdateName, 0) = 0 THEN AT1202.ObjectName ELSE C.ObjectAddress END ObjectAddress,
		C.Mobile
 
FROM	CST2013 CS
LEFT JOIN AT1302 A ON A.DivisionID = CS.DivisionID AND A.InventoryID = CS.InventoryID
LEFT JOIN CST2010 C ON C.DivisionID = CS.DivisionID AND C.VoucherID = CS.VoucherID
LEFT JOIN AT1202 ON AT1202.DivisionID = C.DivisionID AND AT1202.ObjectID = C.ObjectID
WHERE	CS.VoucherID IN (	SELECT  KeyID 
							FROM	AT0999 A 
							WHERE	A.Str02 = '''+@DivisionID+'''
									AND A.UserID = '''+@UserID+'''
									AND A.TransTypeID = ''SF2000'')
		AND CS.DivisionID = '''+@DivisionID+'''
		
		'

PRINT(@Ssql)
EXEC(@Ssql)


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

