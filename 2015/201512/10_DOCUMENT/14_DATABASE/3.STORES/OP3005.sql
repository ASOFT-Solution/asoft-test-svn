IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP3005]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP3005]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- <Summary>
---- In Tinh hinh thuc hien don hang ban
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 04/11/2004 by Vo Thanh Huong
---- 
---- Modified on 16/05/2013 by Le Thi Thu Hien : Chỉnh sửa Unicode
-- <Example>
---- EXEC OP3005 N'CT', N'CL.12.12.002'
CREATE PROCEDURE [dbo].[OP3005] 
				@DivisionID nvarchar(50),
				@OrderID nvarchar(50)		
AS
Declare @Date01 AS datetime, @Date02 AS datetime, @Date03 AS datetime, @Date04 AS datetime, @Date05 AS datetime, 
		@Date06 AS datetime, @Date07 AS datetime, @Date08 AS datetime, @Date09 AS datetime, @Date10 AS datetime, 
		@Date11 AS datetime, @Date12 AS datetime, @Date13 AS datetime, @Date14 AS datetime, @Date15 AS datetime, 
		@Date16 AS datetime, @Date17 AS datetime, @Date18 AS datetime, @Date19 AS datetime, @Date20 AS datetime, 
		@Date21 AS datetime, @Date22 AS datetime, @Date23 AS datetime, @Date24 AS datetime, @Date25 AS datetime, 
		@Date26 AS datetime, @Date27 AS datetime, @Date28 AS datetime, @Date29 AS datetime, @Date30 AS datetime,	
		@sSQL nvarchar(MAX),  @cur cursor, @VoucherNo nvarchar(50), @VoucherDate datetime,
		@ReAccountID AS nvarchar(50), -- lay tai khoan phai thu mac dinh,
		@ObjectName AS nvarchar(250),
		@DueDate datetime

SELECT	@VoucherNo = VoucherNo, 
		@VoucherDate = OrderDate , 
		@ObjectName = AT1202.ObjectName, 
		@ReAccountID =isnull (ReAccountID,' ') ,
		@DueDate =isnull (DueDate, ' ')
FROM	OT2001
INNER JOIN  AT1202 ON AT1202.ObjectID = OT2001.ObjectID AND AT1202.DivisionID = OT2001.DivisionID
WHERE	SOrderID = @OrderID

PRINT  @ObjectName

IF NOT EXISTS (SELECT TOP 1 1 FROM OT2003 WHERE SOrderID = @OrderID)
	SET @sSQL = 'SELECT '''' AS Dates, 1 AS Times, ''' + @DivisionID + ''' AS DivisionID'
ELSE 	
BEGIN
SELECT   @Date01 = Date01,  @Date02 = Date02, @Date03 = Date03, @Date04 = Date04, @Date05 = Date05,
		 @Date06 = Date06,  @Date07 = Date07, @Date08 = Date08, @Date09 = Date09, @Date10 = Date10,
		 @Date11 = Date11,  @Date12 = Date12, @Date13 = Date13, @Date14 = Date14, @Date15 = Date15,
		 @Date16 = Date16,  @Date17 = Date17, @Date18 = Date18, @Date19 = Date19, @Date20 = Date20,
		 @Date21 = Date21,  @Date22 = Date22, @Date23 = Date23, @Date24 = Date24, @Date25 = Date25,
		 @Date26 = Date26,  @Date27 = Date27, @Date28 = Date28, @Date29 = Date29, @Date30 = Date30	
FROM	OT2003 
WHERE	SOrderID = @OrderID
--print 'abc' + @sSQL
Set @sSQL =  
		CASE WHEN ISNULL(@Date01, '') = '' THEN '' ELSE ' SELECT ''' + convert(nvarchar(50), @Date01, 120) + ''' AS Dates, 1 AS Times, ''' + @DivisionID + ''' AS DivisionID Union ' end +
		CASE WHEN ISNULL(@Date02, '') = '' THEN '' ELSE ' SELECT ''' + convert(nvarchar(50), @Date02, 120) + ''' AS Dates, 2 AS Times, ''' + @DivisionID + ''' AS DivisionID Union ' end +
		CASE WHEN ISNULL(@Date03, '') = '' THEN '' ELSE ' SELECT ''' + convert(nvarchar(50), @Date03, 120) + ''' AS Dates, 3 AS Times, ''' + @DivisionID + ''' AS DivisionID Union ' end +
		CASE WHEN ISNULL(@Date04, '') = '' THEN '' ELSE ' SELECT ''' + convert(nvarchar(50), @Date04, 120) + ''' AS Dates, 4 AS Times, ''' + @DivisionID + ''' AS DivisionID Union ' end +
		CASE WHEN ISNULL(@Date05, '') = '' THEN '' ELSE ' SELECT ''' + convert(nvarchar(50), @Date05, 120) + ''' AS Dates, 5 AS Times, ''' + @DivisionID + ''' AS DivisionID Union ' end +
		CASE WHEN ISNULL(@Date06, '') = '' THEN '' ELSE ' SELECT ''' + convert(nvarchar(50), @Date06, 120) + ''' AS Dates, 6 AS Times, ''' + @DivisionID + ''' AS DivisionID Union ' end +
		CASE WHEN ISNULL(@Date07, '') = '' THEN '' ELSE ' SELECT ''' + convert(nvarchar(50), @Date07, 120) + ''' AS Dates, 7 AS Times, ''' + @DivisionID + ''' AS DivisionID Union ' end +
		CASE WHEN ISNULL(@Date08, '') = '' THEN '' ELSE ' SELECT ''' + convert(nvarchar(50), @Date08, 120) + ''' AS Dates, 8 AS Times, ''' + @DivisionID + ''' AS DivisionID Union ' end +
		CASE WHEN ISNULL(@Date09, '') = '' THEN '' ELSE ' SELECT ''' + convert(nvarchar(50), @Date09, 120) + ''' AS Dates, 9 AS Times, ''' + @DivisionID + ''' AS DivisionID Union ' end +
		CASE WHEN ISNULL(@Date10, '') = '' THEN '' ELSE ' SELECT ''' + convert(nvarchar(50), @Date10, 120) + ''' AS Dates, 10 AS Times, ''' + @DivisionID + ''' AS DivisionID Union ' end +
		CASE WHEN ISNULL(@Date11, '') = '' THEN '' ELSE ' SELECT ''' + convert(nvarchar(50), @Date11, 120) + ''' AS Dates, 11 AS Times, ''' + @DivisionID + ''' AS DivisionID Union ' end +
		CASE WHEN ISNULL(@Date12, '') = '' THEN '' ELSE ' SELECT ''' + convert(nvarchar(50), @Date12, 120) + ''' AS Dates, 12 AS Times, ''' + @DivisionID + ''' AS DivisionID Union ' end +
		CASE WHEN ISNULL(@Date13, '') = '' THEN '' ELSE ' SELECT ''' + convert(nvarchar(50), @Date13, 120) + ''' AS Dates, 13 AS Times, ''' + @DivisionID + ''' AS DivisionID Union ' end +
		CASE WHEN ISNULL(@Date14, '') = '' THEN '' ELSE ' SELECT ''' + convert(nvarchar(50), @Date14, 120) + ''' AS Dates, 14 AS Times, ''' + @DivisionID + ''' AS DivisionID Union ' end +
		CASE WHEN ISNULL(@Date15, '') = '' THEN '' ELSE ' SELECT ''' + convert(nvarchar(50), @Date15, 120) + ''' AS Dates, 15 AS Times, ''' + @DivisionID + ''' AS DivisionID Union ' end +
		CASE WHEN ISNULL(@Date16, '') = '' THEN '' ELSE ' SELECT ''' + convert(nvarchar(50), @Date16, 120) + ''' AS Dates, 16 AS Times, ''' + @DivisionID + ''' AS DivisionID Union ' end +
		CASE WHEN ISNULL(@Date17, '') = '' THEN '' ELSE ' SELECT ''' + convert(nvarchar(50), @Date17, 120) + ''' AS Dates, 17 AS Times, ''' + @DivisionID + ''' AS DivisionID Union ' end +
		CASE WHEN ISNULL(@Date18, '') = '' THEN '' ELSE ' SELECT ''' + convert(nvarchar(50), @Date18, 120) + ''' AS Dates, 18 AS Times, ''' + @DivisionID + ''' AS DivisionID Union ' end +
		CASE WHEN ISNULL(@Date19, '') = '' THEN '' ELSE ' SELECT ''' + convert(nvarchar(50), @Date19, 120) + ''' AS Dates, 19 AS Times, ''' + @DivisionID + ''' AS DivisionID Union ' end +
		CASE WHEN ISNULL(@Date20, '') = '' THEN '' ELSE ' SELECT ''' + convert(nvarchar(50), @Date20, 120) + ''' AS Dates, 20 AS Times, ''' + @DivisionID + ''' AS DivisionID Union ' end +
		CASE WHEN ISNULL(@Date21, '') = '' THEN '' ELSE ' SELECT ''' + convert(nvarchar(50), @Date21, 120) + ''' AS Dates, 21 AS Times, ''' + @DivisionID + ''' AS DivisionID Union ' end +
		CASE WHEN ISNULL(@Date22, '') = '' THEN '' ELSE ' SELECT ''' + convert(nvarchar(50), @Date22, 120) + ''' AS Dates, 22 AS Times, ''' + @DivisionID + ''' AS DivisionID Union ' end +
		CASE WHEN ISNULL(@Date23, '') = '' THEN '' ELSE ' SELECT ''' + convert(nvarchar(50), @Date23, 120) + ''' AS Dates, 23 AS Times, ''' + @DivisionID + ''' AS DivisionID Union ' end +
		CASE WHEN ISNULL(@Date24, '') = '' THEN '' ELSE ' SELECT ''' + convert(nvarchar(50), @Date24, 120) + ''' AS Dates, 24 AS Times, ''' + @DivisionID + ''' AS DivisionID Union ' end +
		CASE WHEN ISNULL(@Date25, '') = '' THEN '' ELSE ' SELECT ''' + convert(nvarchar(50), @Date25, 120) + ''' AS Dates, 25 AS Times, ''' + @DivisionID + ''' AS DivisionID Union ' end +
		CASE WHEN ISNULL(@Date26, '') = '' THEN '' ELSE ' SELECT ''' + convert(nvarchar(50), @Date26, 120) + ''' AS Dates, 26 AS Times, ''' + @DivisionID + ''' AS DivisionID Union ' end +
		CASE WHEN ISNULL(@Date27, '') = '' THEN '' ELSE ' SELECT ''' + convert(nvarchar(50), @Date27, 120) + ''' AS Dates, 27 AS Times, ''' + @DivisionID + ''' AS DivisionID Union ' end +
		CASE WHEN ISNULL(@Date28, '') = '' THEN '' ELSE ' SELECT ''' + convert(nvarchar(50), @Date28, 120) + ''' AS Dates, 28 AS Times, ''' + @DivisionID + ''' AS DivisionID Union ' end +
		CASE WHEN ISNULL(@Date29, '') = '' THEN '' ELSE ' SELECT ''' + convert(nvarchar(50), @Date29, 120) + ''' AS Dates, 29 AS Times, ''' + @DivisionID + ''' AS DivisionID Union ' end +
		CASE WHEN ISNULL(@Date30, '') = '' THEN '' ELSE ' SELECT ''' + convert(nvarchar(50), @Date30, 120) + ''' AS Dates, 30 AS Times, ''' + @DivisionID + ''' AS DivisionID Union ' end 
--print 'abc'
SET @sSQL = left(@sSQL, len(@sSQL) - 5)
END

IF  EXISTS(SELECT TOP 1 1 FROM SYSOBJECTS WHERE XType = 'V' and Name = 'OV2102')
	DROP VIEW OV2102
EXEC('CREATE VIEW OV2102 ---tao boi OP3005
		 AS ' + @sSQL)	
--- Step1 lay ke hoach giao hang
Set @sSQL = N'
SELECT	T00.DivisionID,
		V00.Dates, V00.Times, T00. InventoryID, A00.InventoryName, A01.UnitName, A00.Specification, A00.InventoryTypeID, 
		SUM(OrderQuantity) AS OrderQuantity, T00.Orders,
		(ISNULL(SUM(ConvertedAmount),0) +  ISNULL(SUM(VATConvertedAmount),0)  )as OrderConvertedAmount,
		( ISNULL(SUM(OriginalAmount),0)  +  ISNULL(SUM(OriginalAmount),0)  ) AS OrderOriginalAmount,
		SUM(case when Times = 1 THEN Quantity01 
		when Times = 2 THEN Quantity02 
		when Times = 3 THEN Quantity03 
		when Times = 4 THEN Quantity04 
		when Times = 5 THEN Quantity05 
		when Times = 6 THEN Quantity06 
		when Times = 7 THEN Quantity07 
		when Times = 8 THEN Quantity08 
		when Times = 9 THEN Quantity09 
		when Times = 10 THEN Quantity10 
		when Times = 11 THEN Quantity11 
		when Times = 12 THEN Quantity12 
		when Times = 13 THEN Quantity13 
		when Times = 14 THEN Quantity14 
		when Times = 15 THEN Quantity15 
		when Times = 16 THEN Quantity16 
		when Times = 17 THEN Quantity17 
		when Times = 18 THEN Quantity18 
		when Times = 19 THEN Quantity19 
		when Times = 20 THEN Quantity20 
		when Times = 21 THEN Quantity21 
		when Times = 22 THEN Quantity22 
		when Times = 23 THEN Quantity23 
		when Times = 24 THEN Quantity24 
		when Times = 25 THEN Quantity25 
		when Times = 26 THEN Quantity26 
		when Times = 27 THEN Quantity27 
		when Times = 28 THEN Quantity28 
		when Times = 29 THEN Quantity29 
		when Times = 30 THEN Quantity30  end) AS Quantity
FROM	OT2002 T00 
CROSS JOIN OV2102 V00 
INNER JOIN AT1302 A00 ON A00.DivisionID = T00.DivisionID AND A00.InventoryID = T00.InventoryID
INNER JOIN AT1304 A01 ON A01.DivisionID = T00.DivisionID AND A00.UnitID = A01.UnitID				
WHERE	T00.SOrderID =''' + @OrderID + '''
		AND T00.DivisionID = ''' + @DivisionID + '''
GROUP BY	T00.DivisionID, V00.Dates, V00.Times, 
			T00. InventoryID, A00.InventoryName, 
			A01.UnitName, T00.Orders, A00.Specification, 
			A00.InventoryTypeID '

--Print  @sSQL
IF EXISTS (SELECT TOP 1 1 FROM SYSOBJECTS WHERE XType = 'V' and Name = 'OV2103')
	DROP VIEW OV2103
EXEC('CREATE VIEW OV2103 ---tao boi OP3005
		as ' + @sSQL)



---- Step 2 Lay so luong thuc te giao hang 

Set @sSQL = N'
SELECT  A00.DivisionID, A00.OrderID,  A00. InventoryID,   isnull (SUM(ActualQuantity),0) AS ActualQuantity,
		 (SELECT	SUM(ISNULL(ConvertedAmount, 0)) 
		  FROM		AT9000 
		  WHERE		OrderID = A00.OrderID 
					AND InventoryID = A00.InventoryID)
					+ 
		((SELECT	SUM(ISNULL(ConvertedAmount, 0)) 
		  From		AT9000 
		  Where		OrderID = A00.OrderID 
					And InventoryID = A00.InventoryID)
					*
			ISNULL((SELECT ISNULL(VATRate,0) 
					from	AT1010 
			        Where	VATGroupID In (	SELECT Top 1 VATGroupID 
											FROM	AT9000 
											Where	OrderID = A00.OrderID 
													And TransactiontypeID = ''T04'')), 0)/100) 
		 AS   ActualConvertedAmount ,

		 (SELECT SUM(ISNULL(OriginalAmount, 0)) FROM AT9000 WHERE OrderID = A00.OrderID And InventoryID = A00.InventoryID)
					+ 
		((SELECT SUM(ISNULL(OriginalAmount, 0)) FROM AT9000 WHERE OrderID = A00.OrderID And InventoryID = A00.InventoryID)
						*
		ISNULL((SELECT ISNULL(VATRate,0) 
		        FROM at1010 
		        WHERE VATGroupID In (SELECT Top 1 VATGroupID 
		                             FROM AT9000 
		                             WHERE OrderID = A00.OrderID 
											And TransactiontypeID = ''T04'')), 0)/100) 

		as   ActualOriginalAmount ,

		A09.T01OriginalAmount,  
		A09.T01ConvertedAmount ,
		SumActualConvertedAmount, 
		SumActualOriginalAmount	
	
FROM	AT2007 A00 
INNER JOIN AT2006 A01 ON A01.DivisionID = A00.DivisionID AND A00.VoucherID = A01.VoucherID and A01.KindVoucherID in(2,4)
LEFT  JOIN (SELECT	DivisionID, OrderID, 
					ISNULL(SUM(OriginalAmount),0) AS T01OriginalAmount , 
					isnull (SUM(ConvertedAmount),0) AS T01ConvertedAmount
			FROM	AT9000 
            WHERE	CreditAccountID = '''+@ReAccountID+''' 
					AND OrderID = ''' + @OrderID + '''   
            GROUP BY OrderID, DivisionID)  A09 
	ON		A09.DivisionID = A00.DivisionID 
			AND A09.OrderID = A00.OrderID
LEFT JOIN (SELECT	DivisionID, OrderID, 
					ISNULL(SUM(ConvertedAmount),0) AS SumActualConvertedAmount, 
					ISNULL(SUM(OriginalAmount),0) AS SumActualOriginalAmount
	       FROM		AT9000  
           WHERE	OrderID = ''' + @OrderID + ''' 
					AND TransactiontypeID in ( ''T04'',''T14'') 
           GROUP BY OrderID, DivisionID)  A02 
	ON		A02.DivisionID = A00.DivisionID 
			AND A02.OrderID =A00.OrderID

WHERE	A00.OrderID = ''' + @OrderID + '''
		AND A00.DivisionID = ''' + @DivisionID + '''
GROUP BY	A00.DivisionID, A00.OrderID,  A00.InventoryID, 
			A09.T01OriginalAmount, A09.T01ConvertedAmount ,
			SumActualConvertedAmount, 
			SumActualOriginalAmount	'

PRINT  @sSQL
IF EXISTS(SELECT TOP 1 1 FROM SYSOBJECTS WHERE XType = 'V' and Name = 'OV2104')
	DROP VIEW OV2104
EXEC('CREATE VIEW OV2104 ---tao boi OP3005
		as ' + @sSQL)



Set @sSQL = N'
SELECT	T00.DivisionID, T00.InventoryID, InventoryName, A01.UnitName, A00.Specification, A00.InventoryTypeID,
		VoucherDate AS Dates, V00.ActualQuantity,  V00.ActualConvertedAmount , V00.ActualOriginalAmount , SUM(T00.ActualQuantity) AS Quantity,
		ISNULL(SUM(ConvertedAmount),0)as ConvertedAmount, ISNULL(SUM(OriginalAmount),0) AS OriginalAmount , V00.T01OriginalAmount, V00.T01ConvertedAmount	
		,SumActualConvertedAmount, SumActualOriginalAmount	
FROM	AT2007  T00   
INNER JOIN AT2006 T01 ON T01.DivisionID = T00.DivisionID AND T00.VoucherID = T01.VoucherID and T01.KindVoucherID in(2,4)
INNER JOIN OV2104 V00 ON V00.DivisionID = T00.DivisionID AND T00.InventoryID = V00.InventoryID
INNER JOIN AT1302 A00 ON A00.DivisionID = T00.DivisionID AND T00.InventoryID = A00.InventoryID
INNER JOIN AT1304 A01 ON A01.DivisionID = T00.DivisionID AND A00.UnitID = A01.UnitID
WHERE	T00.OrderID = ''' + @OrderID + '''
		AND T00.DivisionID = ''' + @DivisionID + '''
GROUP BY	T00.DivisionID, T00.InventoryID, InventoryName,  
			A01.UnitName, Voucherdate , V00.ActualQuantity,  
			A00.Specification, A00.InventoryTypeID,  
			V00.ActualConvertedAmount , V00.ActualOriginalAmount ,
			V00.T01OriginalAmount, V00.T01ConvertedAmount ,
			SumActualConvertedAmount, SumActualOriginalAmount	 '

If  exists(SELECT Top 1 1 FROM sysObjects WHERE XType = 'V' and Name ='OV2105')
	Drop view OV2105
EXEC('Create view OV2105 ---tao boi OP3005
		as ' + @sSQL) 

---Tat ca ngay  trong ke hoach san xuat va thuc te thuc hien
Set @sSQL = 'SELECT Dates, DivisionID FROM OV2102 
			UNION
			SELECT DISTINCT Dates, DivisionID FROM OV2105'

IF  EXISTS(SELECT TOP 1 1 FROM SYSOBJECTS WHERE XType = 'V' and Name ='OV2106')
	DROP VIEW OV2106
EXEC('CREATE VIEW OV2106  ---tao boi OP3005
		as ' + @sSQL) 


 /*----Lay tien da thu 
Set @sSQL = 'SELECT OrderID AS VoucherNo, SUM(OriginalAmount) AS OriginalAmount ,SUM(ConvertedAmount) AS ConvertedAmount
FROM AT9000 
WHERE TransactionTypeID =''T01'' and OrderID = ''' + @OrderID + '''
Group by OrderID'

If  exists(SELECT Top 1 1 FROM sysObjects WHERE XType = 'V' and Name ='OV2108')
	Drop view OV2108
EXEC('Create view OV2108  ---tao boi OP3005
		as ' + @sSQL) 


*/
--//

Set @sSQL = N'
SELECT	V00.DivisionID, ''' + @VoucherNo + ''' AS VoucherNo, ''' + convert(nvarchar(10), @VoucherDate, 103) + ''' AS VoucherDate, 
		N''' + @ObjectName + ''' AS ObjectName, ''' + convert(nvarchar(10), @DueDate, 103) + ''' AS DueDate,
		V00.InventoryID,  V00.InventoryName, V00.UnitName, V00.Specification, V00.InventoryTypeID, Dates, 
		1 AS Types, ''OFML000183'' AS TypeName, OrderQuantity, OrderConvertedAmount,  OrderOriginalAmount,
		V01.ActualQuantity,   ActualConvertedAmount , ActualOriginalAmount ,  Quantity , 0 AS ConvertedAmount ,  0 AS OriginalAmount,
		V01.T01OriginalAmount, V01.T01ConvertedAmount  ,SumActualConvertedAmount, SumActualOriginalAmount	
FROM		OV2103 V00 
LEFT JOIN	OV2104 V01 
	ON		V01.DivisionID = V00.DivisionID AND V00.InventoryID = V01.InventoryID '			

---Print  @sSQL
IF  EXISTS(SELECT TOP 1 1 FROM SYSOBJECTS WHERE XTYPE = 'V' AND NAME ='OV2117')
	DROP VIEW OV2117
EXEC('CREATE VIEW OV2117  ---tao boi OP3005
		as ' + @sSQL) 


Set @sSQL =N'
SELECT DISTINCT V00.DivisionID, ''' + @VoucherNo + ''' AS VoucherNo, ''' + convert(nvarchar(10), @VoucherDate, 103) + ''' AS VoucherDate, 
		N''' + @ObjectName + ''' AS ObjectName, ''' + convert(nvarchar(10), @DueDate, 103) + ''' AS DueDate,
		V00.InventoryID, V00.InventoryName, V00.UnitName, V00.Specification, V00.InventoryTypeID, V00.Dates, 
		1 AS Types,''OFML000183'' AS TypeName, V01.OrderQuantity AS OrderQuantity, OrderConvertedAmount,  OrderOriginalAmount,
		ActualQuantity,   ActualConvertedAmount , ActualOriginalAmount  , 0 AS Quantity  , 0 AS ConvertedAmount ,  0 AS OriginalAmount,
		V00.T01OriginalAmount, V00.T01ConvertedAmount ,SumActualConvertedAmount, SumActualOriginalAmount	
FROM	OV2105  V00 
LEFT JOIN (Select	Distinct DivisionID, InventoryID, OrderQuantity, 
					OrderConvertedAmount ,  OrderOriginalAmount  
           FROM OV2103) V01 
	ON V01.DivisionID = V00.DivisionID AND V00.InventoryID = V01.InventoryID
WHERE V00.Dates not in (SELECT Distinct Dates FROM OV2102) '


If  exists(SELECT Top 1 1 FROM sysObjects WHERE XType = 'V' and Name ='OV2127')
	Drop view OV2127
EXEC('Create view OV2127  ---tao boi OP3005
		as ' + @sSQL) 


 Set @sSQL = N'
 SELECT V00.DivisionID, ''' + @VoucherNo + ''' AS VoucherNo, ''' + convert(nvarchar(10), @VoucherDate, 103) + ''' AS VoucherDate, 
		N''' + @ObjectName + ''' AS ObjectName, ''' + convert(nvarchar(10), @DueDate, 103) + ''' AS DueDate,
		 V00.InventoryID,  V00.InventoryName, V00.UnitName , V00.Specification, V00.InventoryTypeID,  Dates, 
		2 AS Types, ''OFML000184'' AS TypeName, V01.OrderQuantity,  OrderConvertedAmount,  OrderOriginalAmount,
		ActualQuantity, ActualConvertedAmount , ActualOriginalAmount  ,   Quantity  ,ConvertedAmount ,  OriginalAmount,
		V00.T01OriginalAmount, V00.T01ConvertedAmount  ,SumActualConvertedAmount, SumActualOriginalAmount	
FROM OV2105 V00 
INNER JOIN	(SELECT Distinct DivisionID, InventoryID, OrderQuantity ,  
					OrderConvertedAmount ,  OrderOriginalAmount 
          	 From	OV2103)V01 
	ON V01.DivisionID = V00.DivisionID AND V00.InventoryID = V01.InventoryID	'	


IF  EXISTS(SELECT TOP 1 1 FROM SYSOBJECTS WHERE XTYPE = 'V' AND NAME ='OV2137')
	DROP VIEW OV2137
EXEC('CREATE VIEW OV2137  ---tao boi OP3005
		as ' + @sSQL) 

Set @sSQL = N'
SELECT DISTINCT V00.DivisionID, ''' + @VoucherNo + ''' AS VoucherNo, ''' + convert(nvarchar(10), @VoucherDate, 103) + ''' AS VoucherDate,
		N''' + @ObjectName + ''' AS ObjectName, ''' + convert(nvarchar(10), @DueDate, 103) + ''' AS DueDate,
		V00.InventoryID,  V00.InventoryName, V00.UnitName,  V00.Specification, V00.InventoryTypeID, V00.Dates,  
		2 AS Types, ''OFML000184'' AS TypeName, OrderQuantity,  OrderConvertedAmount,  OrderOriginalAmount ,
		V01.ActualQuantity,  ActualConvertedAmount , ActualOriginalAmount,  0 AS Quantity ,  0 AS ConvertedAmount ,  0 AS OriginalAmount ,
		V01.T01OriginalAmount, V01.T01ConvertedAmount  ,SumActualConvertedAmount, SumActualOriginalAmount	
FROM	OV2103 V00 
LEFT JOIN OV2104 V01 ON V01.DivisionID = V00.DivisionID AND V00.InventoryID = V01.InventoryID
WHERE Dates not in (SELECT Distinct Dates FROM OV2105) '

If  exists(SELECT Top 1 1 FROM sysObjects WHERE XType = 'V' and Name ='OV2147')
	Drop view OV2147
EXEC('Create view OV2147  ---tao boi OP3005
		as ' + @sSQL) 


 Set @sSQL = N'
SELECT * FROM OV2117
UNION
SELECT * FROM OV2127 
UNION
SELECT * FROM OV2137 
UNION
SELECT * FROM OV2147'




 --Print  @sSQL
IF  EXISTS(SELECT TOP 1 1 FROM SYSOBJECTS WHERE XTYPE = 'V' AND NAME ='OV2107')
	DROP VIEW OV2107
EXEC('CREATE VIEW OV2107 ---tao boi OP3005
		as ' + @sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

