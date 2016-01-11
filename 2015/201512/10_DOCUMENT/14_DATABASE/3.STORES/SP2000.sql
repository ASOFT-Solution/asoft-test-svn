IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[SP2000]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[SP2000]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Đổ nguồn Kế thừa phiếu sửa chữa bảo trì CSF2015
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 19/07/2012 by Lê Thị Thu Hiền
---- 
---- Modified on 19/07/2012 by 
-- <Example>
---- EXEC SP2000 'AS', 1, 1, 2011, 10, 2012, NULL, NULL, '', '', ''
CREATE PROCEDURE SP2000
( 
		@DivisionID AS NVARCHAR(50),
		@IsTime AS TINYINT,
		@FromTranMonth AS INT,
		@FromTranYear AS INT,
		@ToTranMonth AS INT,
		@ToTranYear AS INT,
		@FromDate AS DATETIME,
		@ToDate AS DATETIME,
		@ContractNo AS NVARCHAR(50),
		@WarrantyNo AS NVARCHAR(50),
		@License AS NVARCHAR(50),
		@Where AS NVARCHAR(4000)
		
) 
AS 

DECLARE @Ssql AS NVARCHAR(4000),
		@SWhere AS NVARCHAR(4000)

IF @Where <> ''
SET @Where = N'WHERE '+@Where

IF @IsTime = 1
SET @SWhere  = N'
			AND		CS.TranYear*100+CS.TranMonth >= '''+ STR(@FromTranYear*100+@FromTranMonth) + ''' 
			AND		CS.TranYear*100+CS.TranMonth <= '''+ STR(@ToTranYear*100+@ToTranMonth) + '''
			'
IF @IsTime = 2
SET @SWhere = N'
			AND		CS.VoucherDate >= '''+ CONVERT(varchar(10),@FromDate,101) +'''
			AND		CS.VoucherDate <= '''+ CONVERT(varchar(10),@ToDate,101) +'''
			'

--PRINT (	CONVERT(DATETIME,CONVERT(varchar(10),@FromDate,103),103))


--RETURN		
SET @Ssql = N'
SELECT	CS.DivisionID,	CS.VoucherID,
		CS.VoucherNo,	CS.VoucherDate,	
		CS.ObjectID,	CS.ObjectName,	CS.ObjectAddress,	CS.Mobile,
		CS.InventoryID,	A.InventoryName,	
		CS.Color,		CS.FrameNo,		CS.EngineNo,		CS.License
INTO	#TAM 
FROM	CST2010 CS
LEFT JOIN AT1302 A ON A.DivisionID = CS.DivisionID AND A.InventoryID = CS.InventoryID
WHERE	CS.DivisionID = ''' + @DivisionID + '''
		AND ISNULL(CS.VoucherNo,'''') LIKE  ''%' + @WarrantyNo + '%''
		AND ISNULL(CS.ContractNo,'''') LIKE ''%' + @ContractNo + '%''
		AND ISNULL(CS.License,'''') LIKE ''%' + @License + '%''		
		'
+@SWhere
		
SET @Ssql = @Ssql + N'
SELECT * FROM #TAM 
' + @Where

PRINT(@Ssql)
EXEC(@Ssql)
		

--SELECT * FROM CST2010
--SELECT * FROM CST2011 
--SELECT * FROM CST2012
--SELECT * FROM CST2013


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

