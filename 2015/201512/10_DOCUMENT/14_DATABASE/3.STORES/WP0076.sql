IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WP0076]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[WP0076]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Bao cao theo doi dat hang - san xuat - Giao hang WF0076
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 27/05/2011 by Le Thi Thu Hien 
---- 
---- Modified on 29/08/2011 by Le Thi Thu Hien : Chinh sua phan ky cho so luong nhap
---- Modified on 07/12/2011 by Le Thi Thu Hien : Bo sung phan D13 (D13.MOrderID = D7.VoucherNo)
-- <Example>
---- 

CREATE PROCEDURE [dbo].[WP0076] 		
					@DivisionID AS nvarchar(50),					
					@FromObjectID  AS nvarchar(50),
					@ToObjectID AS nvarchar(50),
					@FromInventoryID AS nvarchar(50),
					@ToInventoryID AS nvarchar(50),
					@FromMonth AS int,
					@FromYear AS int,
					@ToMonth AS int,
					@ToYear AS int,
					@FromDate AS Datetime,
					@ToDate AS Datetime,
					@IsDate AS tinyint	-- 0 : Ngay
										-- 1 : Ky



AS

EXEC MP0810 @DivisionID, '%', @FromMonth, @FromYear, @ToMonth, @ToYear

DECLARE @sSQL AS NVARCHAR(4000),
		@sSQL1 AS NVARCHAR(4000),
		@sWHERE AS NVARCHAR(4000)
SET @sWHERE = ''

IF @IsDate = 0 
SET @sWHERE = @sWHERE + N'
		AND D.OrderDate >= '''+CONVERT(VARCHAR(20), @FromDate , 101)+'''
		AND D.OrderDate<= '''+CONVERT(VARCHAR(20), @ToDate , 101)+''''
		
IF @IsDate = 1
SET @sWHERE = @sWHERE + N'
		AND	D.TranYear *100 + D.TranMonth >= '+STR(@FromYear)+'*100+'+STR(@FromMonth)+'
		AND	D.TranYear *100 + D.TranMonth <= '+STR(@ToYear)+'*100+'+STR(@ToMonth)+'	'

IF @FromObjectID <> '' AND @FromObjectID <> '%' AND @ToObjectID <> '' AND @ToObjectID <> '%'
SET @sWHERE = @sWHERE +  N'
		AND	D.ObjectID >= N'''+@FromObjectID+'''
		AND	D.ObjectID <= N'''+@ToObjectID+'''
'
SET @sSQL = N'
SELECT		DISTINCT
			D.DivisionID,
			D.SOrderID,			D.OrderDate ,
			D7.VoucherNo AS InputVoucherNo, 
			D.ObjectID,			D4.ObjectName,
			D1.InventoryID,		D5.InventoryName,
			D1.OrderQuantity,	D1.UnitID, 
			CONVERT(DECIMAL(28,8), 0 ) AS ExpectQuantity, -- So luong du kien
			CONVERT(nvarchar(50), '''' ) AS ExpectUnit, -- Don vi tinh du lien
			D13.OrderQuantity AS OutputQuantity,		-- So luong giay xuat kho	
			D10.OrderQuantity AS ProductQuantity, -- So luong san xuat
			D11.InputQuantity AS InputQuantity, --So luong nhap kho
			D14.Quantity AS DeliveryQuantity, -- So luong giao hang
			D10.Ana05ID,
			D7.Description
		
FROM		OT2001 D
LEFT JOIN	OT2002 D1
	ON		D.SOrderID = D1.SOrderID
LEFT JOIN	(	SELECT	DISTINCT MOrderID, SOrderID, InventoryID
         	 	FROM	AT2007
         	 )D2
	ON		D2.SOrderID = D1.SOrderID
			AND D2.InventoryID = D1.InventoryID
LEFT JOIN	AT1202 D4
	ON		D4.ObjectID = D.ObjectID
LEFT JOIN	AT1302 D5
	ON		D5.InventoryID = D1.InventoryID
	
--Don hang xuat kho	giay
LEFT JOIN	(	SELECT		O1.InventoryID,O1.RefSOrderID, O1.SOrderID AS VoucherNo, MAX(O1.Description) AS Description
				FROM		OT2002 O1
         	 	GROUP BY	O1.SOrderID, O1.RefSOrderID,O1.InventoryID
         	 )D7
	ON		D7.RefSOrderID = D.SOrderID
			AND D7.InventoryID = D1.InventoryID

--LEFT JOIN	(	SELECT		SUM(O.OrderQuantity) AS OrderQuantity,
--							O.SOrderID, O.RefSOrderID, O1.VoucherNo, O.InventoryID
--				FROM		OT2002 O
--				LEFT JOIN	OT2001 O1
--					ON		O1.SOrderID =  O.SOrderID							
--         	 	WHERE		O1.OrderType = 1
--         	 	GROUP BY	O.SOrderID, O.RefSOrderID, O1.VoucherNo, O.InventoryID
--         	 )D7
--	ON		D7.SOrderID = D.SOrderID
--			AND D7.InventoryID = D1.InventoryID
			
--- Don hang san xuat
LEFT JOIN	(	SELECT		SUM(D9.OrderQuantity) AS OrderQuantity,
							D9.SOrderID,	D9.RefSOrderID	, D9.InventoryID, D9.Ana05ID			
         	 	FROM		OT2002 D9
				LEFT JOIN	OT2001 D8
					ON		D8.SOrderID = D9.SOrderID
         	 	WHERE		D8.OrderType = 1
         	 				AND D8.TranYear*100+D8.TranMonth >= '+STR(@FromYear*100+@FromMonth)+'
							AND D8.TranYear*100+D8.TranMonth <= '+STR(@ToYear*100+@ToMonth)+'
         	 	GROUP BY	D9.SOrderID, D9.RefSOrderID, D9.InventoryID, D9.Ana05ID
			)D10
	ON		D10.SOrderID = D7.VoucherNo
	AND		D10.InventoryID = D1.InventoryID
	
---So luong nhap kho
LEFT JOIN	(
				SELECT		A.ProductID AS InventoryID,   
							SUM(A.Quantity) AS InputQuantity,
							A.MOrderID, A.SOrderID
				FROM		MV0810 A
				WHERE		A.TranYear*100+A.TranMonth >= '+STR(@FromYear*100+@FromMonth)+'
							AND A.TranYear*100+A.TranMonth <= '+STR(@ToYear*100+@ToMonth)+'
				GROUP BY	A.ProductID,
							A.MOrderID, A.SOrderID
			) D11
	--ON		D11.MOrderID = D2.MOrderID
	--		AND D11.InventoryID = D1.InventoryID
	ON		D11.MOrderID = D7.VoucherNo
			AND D11.InventoryID = D1.InventoryID
			AND	D11.SOrderID = D.SOrderID
			
--So luong xuat kho	giay
LEFT JOIN	(	SELECT	A.ProductID, A.SOrderID, A.MOrderID, 
						SUM(ISNULL(A.ConvertedQuantity, 0)) AS  OrderQuantity 
				FROM	AT2007 A
				WHERE	A.InventoryID LIKE ''1%''
				GROUP BY A.ProductID, A.SOrderID, A.MOrderID
         	 )D13
	ON		D13.SOrderID = D.SOrderID
	AND		D13.ProductID = D1.InventoryID
	AND		D13.MOrderID = D7.VoucherNo
'
set @sSQL1 = N'
---- Xuat kho giao hang
LEFT JOIN	(	SELECT  SUM(D9.OrderQuantity) AS DeliveryQuantity,
						D9.SOrderID,	D9.RefSOrderID	, D9.InventoryID		
         	 	FROM	OT2002 D9
				LEFT JOIN	OT2001 D8
					ON		D8.SOrderID = D9.SOrderID
         	 	WHERE		D8.OrderType = 1 
         	 				       	 				
         	 	GROUP BY	D9.SOrderID, D9.RefSOrderID,  D9.InventoryID	
			)D12
	ON		D12.RefSOrderID = D.SOrderID
			AND D12.InventoryID = D1.InventoryID
-- So luong giao hang	
LEFT JOIN	(	SELECT	A.MOrderID, A.SOrderID, SUM(ISNULL(A.Quantity, 0)) AS Quantity, A.InventoryID
				FROM	AT9000 A
         	 	WHERE	A.TransactionTypeID = ''T06''
         	 			AND A.TranYear*100+A.TranMonth >= '+STR(@FromYear*100+@FromMonth)+'
						AND A.TranYear*100+A.TranMonth <= '+STR(@ToYear*100+@ToMonth)+' 
				GROUP BY A.MOrderID, A.SOrderID, A.InventoryID
			)D14
	ON		D14.SOrderID = D1.SOrderID
	AND		D14.InventoryID = D1.InventoryID
	AND		D14.MOrderID = D7.VoucherNo
		
WHERE	D.OrderType = 0
		AND D.DivisionID LIKE N'''+@DivisionID+'''
'
--SET @sSQL = @sSQL + @sWHERE
PRINT (@sSQL)
PRINT (@sSQL1)
PRINT(@sWHERE)
IF NOT EXISTS (SELECT 1 FROM  SYSOBJECTS WHERE XTYPE ='V' AND NAME ='WV0076')
	EXEC(' CREATE VIEW WV0076 AS '+@sSQL+@sSQL1+ @sWHERE)
ELSE
	EXEC(' ALTER VIEW WV0076 AS '+@sSQL+@sSQL1+ @sWHERE)


		


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

