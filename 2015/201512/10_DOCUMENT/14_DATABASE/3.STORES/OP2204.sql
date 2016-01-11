IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP2204]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP2204]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


----Created by: Vo Thanh Huong, date 28/12/2004
---purpose: In ket qua du toan NVL
---Edit: Tuyen, date 20/11/2009. Them cac truong ma phan tich
--- Edit by B.Anh, date 18/12/2009	Lay truong SOrderID tu don hang san xuat
---- Modified on 12/03/2014 by Le Thi Thu Hien : Bo sung them 1 so truong 0022206

CREATE PROCEDURE [dbo].[OP2204] 
		@DivisionID nvarchar(50),				
		@EstimateID nvarchar(50),
		@IsDetail tinyint	
AS
DECLARE @sSQL nvarchar(max),	
		@sSQL1 nvarchar(max),
		@sSQL2 nvarchar(max),
		@sSQL3 nvarchar(max),
		@sSQL4 nvarchar(max)
		
Set @sSQL =  '
Select T00.DivisionID, T00.EDetailID, VoucherNo, VoucherDate,  T01.SOrderID,  ApportionType,
		T01.DepartmentID, DepartmentName, T01.EmployeeID, FullName, 
		ApportionID, T01.Description, PDescription ,  T00.LinkNo,  T00.Orders, 0 AS MOrders,
		'''' AS  InventoryID , '''' AS  InventoryName , '''' AS  InventoryUnitName, 0 AS InventoryQuantity ,
		T00.ProductID , InventoryName AS ProductName, UnitName AS  ProductUnitName, ProductQuantity ,
		0 AS ConvertedAmount,
		 '''' AS ExpenseID, '''' AS MaterialTypeID, '''' MaterialTypeName,
		0 AS ConvertedUnit, 0 AS QuantityUnit, 0 AS MaterialPrice,
		1 AS Parts,T01.ObjectID , T01.PeriodID,null AS MaterialDate, 
		T00.Ana01ID, T00.Ana02ID, T00.Ana03ID, T00.Ana04ID, T00.Ana05ID, 
		T00.Ana06ID, T00.Ana07ID, T00.Ana08ID, T00.Ana09ID, T00.Ana10ID, 
		OT1002_1.AnaName AS AnaName1,
		OT1002_2.AnaName AS AnaName2,
		OT1002_3.AnaName AS AnaName3,
		OT1002_4.AnaName AS AnaName4,
		OT1002_5.AnaName AS AnaName5,
		OT1002_6.AnaName AS AnaName6,
		OT1002_7.AnaName AS AnaName7,
		OT1002_8.AnaName AS AnaName8,
		OT1002_9.AnaName AS AnaName9,
		OT1002_10.AnaName AS AnaName10,
		OT2002.SOrderID AS MOOrderID,
		T01.InventoryTypeID, AT1301.InventoryTypeName,
		T02.I01ID,T02.I02ID,T02.I03ID,T02.I04ID,T02.I05ID,
		I01.AnaName AS I01Name,
		I02.AnaName AS I02Name,
		I03.AnaName AS I03Name,
		I04.AnaName AS I04Name,
		I05.AnaName AS I05Name,
		T02.S1, T02.S2, T02.S3,
		S1.SName AS S1Name, S2.SName AS S2Name, S3.SName AS S3Name,
		'''' AS UnitID
'
SET @sSQL1 = N'		
FROM OT2202 T00 
INNER JOIN OT2201 T01 on T00.EstimateID = T01.EstimateID And T00.DivisionID = T01.DivisionID
LEFT join AT1302 T02 on T02.InventoryID = T00.ProductID And T02.DivisionID = T00.DivisionID
LEFT join AT1304 T03 on T03.UnitID = T02.UnitID And T03.DivisionID = T02.DivisionID
LEFT JOIN AT1102 T04 on T04.DepartmentID = T01.DepartmentID  and T04.DivisionID = T01.DivisionID
LEFT JOIN AT1103 T05 on T05.EmployeeID = T01.EmployeeID And T05.DivisionID = T01.DivisionID
LEFT JOIN AT1011	OT1002_1 on OT1002_1.AnaID = T00.Ana01ID and  OT1002_1.AnaTypeID = ''A01'' and  OT1002_1.DivisionID = T00.DivisionID
LEFT JOIN AT1011	OT1002_2 on OT1002_2.AnaID = T00.Ana02ID and  OT1002_2.AnaTypeID = ''A02'' and  OT1002_2.DivisionID = T00.DivisionID
LEFT JOIN AT1011	OT1002_3 on OT1002_3.AnaID = T00.Ana03ID and  OT1002_3.AnaTypeID = ''A03'' and  OT1002_3.DivisionID = T00.DivisionID
LEFT JOIN AT1011	OT1002_4 on OT1002_4.AnaID = T00.Ana04ID and  OT1002_4.AnaTypeID = ''A04'' and  OT1002_4.DivisionID = T00.DivisionID
LEFT JOIN AT1011	OT1002_5 on OT1002_5.AnaID = T00.Ana05ID and  OT1002_5.AnaTypeID = ''A05'' and  OT1002_5.DivisionID = T00.DivisionID
LEFT JOIN AT1011	OT1002_6 on OT1002_6.AnaID = T00.Ana06ID and  OT1002_6.AnaTypeID = ''A06'' and  OT1002_6.DivisionID = T00.DivisionID
LEFT JOIN AT1011	OT1002_7 on OT1002_7.AnaID = T00.Ana07ID and  OT1002_7.AnaTypeID = ''A07'' and  OT1002_7.DivisionID = T00.DivisionID
LEFT JOIN AT1011	OT1002_8 on OT1002_8.AnaID = T00.Ana08ID and  OT1002_8.AnaTypeID = ''A08'' and  OT1002_8.DivisionID = T00.DivisionID
LEFT JOIN AT1011	OT1002_9 on OT1002_9.AnaID = T00.Ana09ID and  OT1002_9.AnaTypeID = ''A09'' and  OT1002_9.DivisionID = T00.DivisionID
LEFT JOIN AT1011	OT1002_10 on OT1002_10.AnaID = T00.Ana10ID and  OT1002_10.AnaTypeID = ''A10'' and  OT1002_10.DivisionID = T00.DivisionID
LEFT JOIN AT1015	I01 on I01.AnaID = T02.I01ID and  I01.AnaTypeID = ''I01'' and  I01.DivisionID = T02.DivisionID
LEFT JOIN AT1015	I02 on I02.AnaID = T02.I02ID and  I02.AnaTypeID = ''I02'' and  I02.DivisionID = T02.DivisionID
LEFT JOIN AT1015	I03 on I03.AnaID = T02.I03ID and  I03.AnaTypeID = ''I03'' and  I03.DivisionID = T02.DivisionID
LEFT JOIN AT1015	I04 on I04.AnaID = T02.I04ID and  I04.AnaTypeID = ''I04'' and  I04.DivisionID = T02.DivisionID
LEFT JOIN AT1015	I05 on I05.AnaID = T02.I05ID and  I05.AnaTypeID = ''I05'' and  I05.DivisionID = T02.DivisionID
Left Join OT2002 on OT2002.TransactionID = T00.MOTransactionID And OT2002.DivisionID = T00.DivisionID
LEFT JOIN AT1301 AT1301 ON AT1301.DivisionID = T00.DivisionID AND T01.InventoryTypeID = AT1301.InventoryTypeID
LEFT JOIN AT1310 S1 ON S1.STypeID = ''I01'' AND S1.DivisionID = T02.DivisionID AND S1.S = T02.S1
LEFT JOIN AT1310 S2 ON S2.STypeID = ''I02'' AND S2.DivisionID = T02.DivisionID AND S2.S = T02.S2
LEFT JOIN AT1310 S3 ON S3.STypeID = ''I03'' AND S3.DivisionID = T02.DivisionID AND S3.S = T02.S3
 
WHERE	T01.DivisionID = N''' + @DivisionID + ''' 
		AND T00.EstimateID = N''' + @EstimateID + '''
'
SET @sSQL2 = N'
UNION
SELECT	'''' AS DivisionID, '''' AS EDetailID,  '''' AS VoucherNo, '''' AS VoucherDate,  '''' AS SOrderID,  '''' AS ApportionType,
		'''' AS DepartmentID, '''' AS DepartmentName, '''' AS EmployeeID, '''' AS FullName, '''' AS ApportionID, 
		'''' AS Description, ''''  PDescription,  '''' AS LinkNo, 0 AS Orders, 0 AS MOrders,
		'''' AS  InventoryID, '''' AS  InventoryName, '''' AS  InventoryUnitName, 0 AS InventoryQuantity ,
		'''' AS ProductID , '''' AS ProductName, '''' AS ProductUnitName, 0 AS ProductQuantity ,
		0 AS ConvertedAmount, 
		'''' AS ExpenseID, '''' AS MaterialTypeID, '''' AS MaterialTypeName,
		0 AS ConvertedUnit, 0 AS QuantityUnit, 0 AS MaterialPrice,
		2 AS Parts, '''' AS ObjectID , '''' AS PeriodID,null  AS MaterialDate, 
		'''' AS Ana01ID, '''' AS Ana02ID, '''' AS Ana03ID, '''' AS Ana04ID, '''' AS Ana05ID,
		'''' AS Ana06ID, '''' AS Ana07ID, '''' AS Ana08ID, '''' AS Ana09ID, '''' AS Ana10ID,  
		'''' AS AnaName1,	'''' AS AnaName2,	'''' AS AnaName3,	'''' AS AnaName4,	'''' AS AnaName5,
		'''' AS AnaName6,	'''' AS AnaName7,	'''' AS AnaName8,	'''' AS AnaName9,	'''' AS AnaName10,
		'''' AS MOOrderID,
		'''' AS InventoryTypeID, '''' AS InventoryTypeName,
		'''' AS I01ID,'''' AS I02ID,'''' AS I03ID,'''' AS I04ID,'''' AS I05ID,
		'''' AS I01Name,'''' AS I02Name,'''' AS I03Name,'''' AS I04Name,
		'''' AS I05Name,
		'''' AS S1, '''' AS S2, '''' AS S3,
		'''' AS S1Name, '''' AS S2Name, '''' AS S2Name,
		'''' AS UnitID
UNION 
'

if @IsDetail = 1 
	begin 
	Set @sSQL3 = N'
Select T00.DivisionID, T00.EDetailID, VoucherNo, VoucherDate, T01.SOrderID,  ApportionType,
		T01.DepartmentID, DepartmentName, T01.EmployeeID, FullName, '''' AS ApportionID, 
		T01.Description, MDescription AS PDescription, '''' AS  LinkNo, OT2202.Orders, T00.Orders AS MOrders,
		MaterialID  AS InventoryID, T02.InventoryName,  UnitName AS InventoryUnitName, MaterialQuantity AS InventoryQuantity,  
		T06.ProductID , T07.InventoryName AS ProductName, '''' AS ProductUnitName, OT2202.ProductQuantity ,
		T00.ConvertedAmount, 
		T00.ExpenseID, T00.MaterialTypeID, MT0699.UserName AS MaterialTypeName,
		T00.ConvertedUnit, T00.QuantityUnit, T00.MaterialPrice,
		3 AS Parts,T01.ObjectID , T01.PeriodID,T00.MaterialDate, 
		T06.Ana01ID, T06.Ana02ID, T06.Ana03ID, T06.Ana04ID, T06.Ana05ID, 
		T06.Ana06ID, T06.Ana07ID, T06.Ana08ID, T06.Ana09ID, T06.Ana10ID, 
		OT1002_1.AnaName AS AnaName1,
		OT1002_2.AnaName AS AnaName2,
		OT1002_3.AnaName AS AnaName3,
		OT1002_4.AnaName AS AnaName4,
		OT1002_5.AnaName AS AnaName5,
		OT1002_6.AnaName AS AnaName6,
		OT1002_7.AnaName AS AnaName7,
		OT1002_8.AnaName AS AnaName8,
		OT1002_9.AnaName AS AnaName9,
		OT1002_10.AnaName AS AnaName10,
		OT2002.SOrderID AS MOOrderID,
		T01.InventoryTypeID, AT1301.InventoryTypeName,
		T02.I01ID,T02.I02ID,T02.I03ID,T02.I04ID,T02.I05ID,
		I01.AnaName AS I01Name,
		I02.AnaName AS I02Name,
		I03.AnaName AS I03Name,
		I04.AnaName AS I04Name,
		I05.AnaName AS I05Name,
		T02.S1, T02.S2, T02.S3,
		S1.SName AS S1Name, S2.SName AS S2Name, S3.SName AS S3Name,
		T00.UnitID

'
	Set @sSQL4 = N'
FROM OT2203 T00 
INNER JOIN OT2201 T01 on T00.EstimateID = T01.EstimateID And T00.DivisionID = T01.DivisionID
INNER JOIN OT2202 ON OT2202.EstimateID = T00.EstimateID and OT2202.EDetailID = T00.EDetailID And OT2202.DivisionID = T00.DivisionID 
LEFT JOIN AT1302 T02 on T02.InventoryID = T00.MaterialID And T02.DivisionID = T00.DivisionID
LEFT JOIN AT1302 T07 on T07.InventoryID = OT2202.ProductID And T07.DivisionID = OT2202.DivisionID
LEFT JOIN AT1304 T03 on T03.UnitID = T02.UnitID And T03.DivisionID = T02.DivisionID
LEFT JOIN AT1102 T04 on T04.DepartmentID = T01.DepartmentID  and T04.DivisionID = T01.DivisionID
LEFT JOIN AT1103 T05 on T05.EmployeeID = T01.EmployeeID And T05.DivisionID = T01.DivisionID
INNER JOIN OT2202 T06 on T06.EDetailID = T00.EDetailID  And T06.DivisionID = T00.DivisionID
LEFT JOIN AT1011	OT1002_1 on OT1002_1.AnaID = T06.Ana01ID and  OT1002_1.AnaTypeID = ''A01'' and  OT1002_1.DivisionID = T06.DivisionID
LEFT JOIN AT1011	OT1002_2 on OT1002_2.AnaID = T06.Ana02ID and  OT1002_2.AnaTypeID = ''A02'' and  OT1002_2.DivisionID = T06.DivisionID
LEFT JOIN AT1011	OT1002_3 on OT1002_3.AnaID = T06.Ana03ID and  OT1002_3.AnaTypeID = ''A03'' and  OT1002_3.DivisionID = T06.DivisionID
LEFT JOIN AT1011	OT1002_4 on OT1002_4.AnaID = T06.Ana04ID and  OT1002_4.AnaTypeID = ''A04'' and  OT1002_4.DivisionID = T06.DivisionID
LEFT JOIN AT1011	OT1002_5 on OT1002_5.AnaID = T06.Ana05ID and  OT1002_5.AnaTypeID = ''A05'' and  OT1002_5.DivisionID = T06.DivisionID
LEFT JOIN AT1011	OT1002_6 on OT1002_6.AnaID = T06.Ana06ID and  OT1002_6.AnaTypeID = ''A06'' and  OT1002_6.DivisionID = T06.DivisionID
LEFT JOIN AT1011	OT1002_7 on OT1002_7.AnaID = T06.Ana07ID and  OT1002_7.AnaTypeID = ''A07'' and  OT1002_7.DivisionID = T06.DivisionID
LEFT JOIN AT1011	OT1002_8 on OT1002_8.AnaID = T06.Ana08ID and  OT1002_8.AnaTypeID = ''A08'' and  OT1002_8.DivisionID = T06.DivisionID
LEFT JOIN AT1011	OT1002_9 on OT1002_9.AnaID = T06.Ana09ID and  OT1002_9.AnaTypeID = ''A09'' and  OT1002_9.DivisionID = T06.DivisionID
LEFT JOIN AT1011	OT1002_10 on OT1002_10.AnaID = T06.Ana10ID and  OT1002_10.AnaTypeID = ''A10'' and  OT1002_10.DivisionID = T06.DivisionID
LEFT JOIN AT1015	I01 on I01.AnaID = T02.I01ID and  I01.AnaTypeID = ''I01'' and  I01.DivisionID = T02.DivisionID
LEFT JOIN AT1015	I02 on I02.AnaID = T02.I02ID and  I02.AnaTypeID = ''I02'' and  I02.DivisionID = T02.DivisionID
LEFT JOIN AT1015	I03 on I03.AnaID = T02.I03ID and  I03.AnaTypeID = ''I03'' and  I03.DivisionID = T02.DivisionID
LEFT JOIN AT1015	I04 on I04.AnaID = T02.I04ID and  I04.AnaTypeID = ''I04'' and  I04.DivisionID = T02.DivisionID
LEFT JOIN AT1015	I05 on I05.AnaID = T02.I05ID and  I05.AnaTypeID = ''I05'' and  I05.DivisionID = T02.DivisionID
LEFT JOIN MT0699 on MT0699.MaterialTypeID = T00.MaterialTypeID And MT0699.DivisionID = T00.DivisionID
Left Join OT2002 on OT2002.TransactionID = OT2202.MOTransactionID And OT2002.DivisionID = OT2202.DivisionID
LEFT JOIN AT1301 AT1301 ON AT1301.DivisionID = T01.DivisionID AND T01.InventoryTypeID = AT1301.InventoryTypeID
LEFT JOIN AT1310 S1 ON S1.STypeID = ''I01'' AND S1.DivisionID = T02.DivisionID AND S1.S = T02.S1
LEFT JOIN AT1310 S2 ON S2.STypeID = ''I02'' AND S2.DivisionID = T02.DivisionID AND S2.S = T02.S2
LEFT JOIN AT1310 S3 ON S3.STypeID = ''I03'' AND S3.DivisionID = T02.DivisionID AND S3.S = T02.S3

Where 		T01.DivisionID = N''' + @DivisionID + ''' and
			T01.EstimateID = N''' + @EstimateID + ''''
	end
else    
    begin
	Set @sSQL3  = N'
Select  T00.DivisionID, '''' AS  EDetailID, VoucherNo, VoucherDate, T01.SOrderID,  ApportionType,
		T01.DepartmentID, DepartmentName, T01.EmployeeID, FullName, '''' AS ApportionID, 
		Description, MDescription AS PDescription, '''' AS  LinkNo, 0 AS Orders,  0 AS MOrders,
		MaterialID AS InventoryID, InventoryName ,  UnitName AS InventoryUnitName, sum(isnull(MaterialQuantity, 0)) AS InventoryQuantity,
		'''' AS ProductID , '''' AS ProductName, '''' AS ProductUnitName, 0 AS ProductQuantity ,
		sum(isnull(T00.ConvertedAmount,0)) AS ConvertedAmount, 
		T00.ExpenseID, T00.MaterialTypeID, 
		MT0699.UserName AS MaterialTypeName,
		sum(isnull(T00.ConvertedUnit,0)) AS ConvertedUnit, sum(isnull(T00.QuantityUnit, 0)) AS QuantityUnit,
		avg(isnull(T00.MaterialPrice,0)) AS MaterialPrice,
		3 AS Parts,----T01.ObjectID , T01.PeriodID,T01.MaterialDate,
		---OT2202.Ana01ID, OT2202.Ana02ID, OT2202.Ana03ID, OT2202.Ana04ID, OT2202.Ana05ID, 
		---OT1002_1.AnaName AS AnaName1,
		---OT1002_2.AnaName AS AnaName2,
		---OT1002_3.AnaName AS AnaName3,
		---OT1002_4.AnaName AS AnaName4,
		---OT1002_5.AnaName AS AnaName5
		'''' as ObjectID , '''' as PeriodID,	null as MaterialDate,
		'''' AS Ana01ID, '''' AS Ana02ID, '''' AS Ana03ID, '''' AS Ana04ID, '''' AS Ana05ID,
		'''' AS Ana06ID, '''' AS Ana07ID, '''' AS Ana08ID, '''' AS Ana09ID, '''' AS Ana10ID,  
		'''' AS AnaName1,	'''' AS AnaName2,	'''' AS AnaName3,	'''' AS AnaName4,	'''' AS AnaName5,
		'''' AS AnaName6,	'''' AS AnaName7,	'''' AS AnaName8,	'''' AS AnaName9,	'''' AS AnaName10,
		'''' AS MOOrderID,
		T01.InventoryTypeID, AT1301.InventoryTypeName,
		T02.I01ID,T02.I02ID,T02.I03ID,T02.I04ID,T02.I05ID,
		I01.AnaName AS I01Name,
		I02.AnaName AS I02Name,
		I03.AnaName AS I03Name,
		I04.AnaName AS I04Name,
		I05.AnaName AS I05Name,
		T02.S1, T02.S2, T02.S3,
		S1.SName AS S1Name, S2.SName AS S2Name, S3.SName AS S3Name,
		T00.UnitID
'
	Set @sSQL4 = N'
From OT2203 T00 
INNER JOIN OT2201 T01 on T00.EstimateID = T01.EstimateID And T00.DivisionID = T01.DivisionID
LEFT JOIN AT1302 T02 on T02.InventoryID = T00.MaterialID And T02.DivisionID = T00.DivisionID
LEFT JOIN AT1304 T03 on T03.UnitID = T02.UnitID And T03.DivisionID = T02.DivisionID
LEFT JOIN AT1102 T04 on T04.DepartmentID = T01.DepartmentID  and T04.DivisionID = T01.DivisionID	
LEFT JOIN AT1103 T05 on T05.EmployeeID = T01.EmployeeID And T05.DivisionID = T01.DivisionID
LEFT JOIN MT0699 on MT0699.MaterialTypeID = T00.MaterialTypeID And MT0699.DivisionID = T00.DivisionID
LEFT JOIN AT1301 AT1301 ON AT1301.DivisionID = T01.DivisionID AND T01.InventoryTypeID = AT1301.InventoryTypeID
LEFT JOIN AT1015	I01 on I01.AnaID = T02.I01ID and  I01.AnaTypeID = ''I01'' and  I01.DivisionID = T02.DivisionID
LEFT JOIN AT1015	I02 on I02.AnaID = T02.I02ID and  I02.AnaTypeID = ''I02'' and  I02.DivisionID = T02.DivisionID
LEFT JOIN AT1015	I03 on I03.AnaID = T02.I03ID and  I03.AnaTypeID = ''I03'' and  I03.DivisionID = T02.DivisionID
LEFT JOIN AT1015	I04 on I04.AnaID = T02.I04ID and  I04.AnaTypeID = ''I04'' and  I04.DivisionID = T02.DivisionID
LEFT JOIN AT1015	I05 on I05.AnaID = T02.I05ID and  I05.AnaTypeID = ''I05'' and  I05.DivisionID = T02.DivisionID
LEFT JOIN AT1310 S1 ON S1.STypeID = ''I01'' AND S1.DivisionID = T02.DivisionID AND S1.S = T02.S1
LEFT JOIN AT1310 S2 ON S2.STypeID = ''I02'' AND S2.DivisionID = T02.DivisionID AND S2.S = T02.S2
LEFT JOIN AT1310 S3 ON S3.STypeID = ''I03'' AND S3.DivisionID = T02.DivisionID AND S3.S = T02.S3
			
WHERE 	T01.DivisionID = N''' + @DivisionID + ''' and
		T01.EstimateID = N''' + @EstimateID + '''
GROUP BY   T00.DivisionID, VoucherNo, VoucherDate, T01.SOrderID,  ApportionType,
		T01.DepartmentID, DepartmentName, T01.EmployeeID, FullName,
		Description, MDescription , 
		MaterialID , InventoryName,  UnitName, T00.ExpenseID, 
		T00.MaterialTypeID,MT0699.UserName,
		T01.InventoryTypeID, AT1301.InventoryTypeName,
		T02.I01ID,T02.I02ID,T02.I03ID,T02.I04ID,T02.I05ID,
		I01.AnaName,	I02.AnaName,	I03.AnaName,	I04.AnaName,	I05.AnaName,
		T02.S1, T02.S2, T02.S3 ,T00.UnitID,	T00.ConvertedAmount,
		S1.SName, S2.SName, S3.SName'	
	end

--print @sSQL + @sSQL1 + @sSQL2
PRINT(@sSQL)
PRINT(@sSQL1)
PRINT(@sSQL2)
PRINT(@sSQL3)
PRINT(@sSQL4)

IF EXISTS(SELECT TOP 1 1 FROM SYSOBJECTS WHERE XTYPE = 'V' AND NAME = 'OV2205')
	DROP VIEW OV2205 
EXEC('CREATE VIEW OV2205 --tao boi OP2204
		as  ' + @sSQL + @sSQL1 + @sSQL2 +@sSQL3 +@sSQL4)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

