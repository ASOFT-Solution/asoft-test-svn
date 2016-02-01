IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[CRMP10107]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[CRMP10107]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
----In báo cáo khách hàng không phát sinh đơn hàng
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
----Created by: Thị Phượng By on 01/02/2016
-- <Example>
----    EXEC CRMP10105 'AS','AS','','','','','','','', 'NV01'

CREATE PROCEDURE [dbo].[CRMP10107] ( 
        @DivisionID       VARCHAR(50),  --Biến môi trường
		@DivisionIDList    NVARCHAR(2000),  --Chọn trong DropdownChecklist DivisionID
		@FromMonth        INT,
		@FromYear          INT,
		@ToMonth           INT,
		@ToYear           INT,
		@FromDate         DATETIME,
		@ToDate           DATETIME,
		@IsDate           TINYINT,
		@UserID  VARCHAR(50)
)
AS
DECLARE
        @sSQL   NVARCHAR (MAX),
		@sWhere NVARCHAR(MAX),
		@FromMonthYearText NVARCHAR(20), 
		@ToMonthYearText NVARCHAR(20), 
		@FromDateText NVARCHAR(20), 
		@ToDateText NVARCHAR(20),
		@sWhere01 NVARCHAR(MAX)

SET @sWhere = ''
SET @sWhere01 = ''

SET @FromMonthYearText = STR(@FromMonth + @FromYear * 100)
SET @ToMonthYearText = STR(@ToMonth + @ToYear * 100)
SET @FromDateText = CONVERT(NVARCHAR(20), @FromDate, 101)
SET @ToDateText = CONVERT(NVARCHAR(20), @ToDate, 101)
--Check Para DivisionIDList null then get DivisionID 
	IF @DivisionIDList IS NULL or @DivisionIDList = ''
		SET @sWhere01 = @sWhere01 + 'and b.DivisionID = '''+ @DivisionID+''''
	Else 
		SET @sWhere01 = @sWhere01 + 'and b.DivisionID IN ('''+@DivisionIDList+''')'
IF @IsDate = 1
SET @sSQL = N'
Select 
	A.DivisionID,A.ObjectID, A.ObjectName, A.Address, A.Tel, A.Contactor,
	A.InventoryID, A.InventoryName, A.OrderQuantity, A.SalePrice, A.OriginalAmount ,
	A.SumAmount, A.Notes, A.Notes01, A.Notes02, 
	Case 
		When  A.TimeDate >= 15 And A.TimeDate<=30 Then ''1_Nhóm khách hàng không phát sinh trong 15->30''
		When  A.TimeDate >= 31 And A.TimeDate<=45 Then ''2_Nhóm khách hàng không phát sinh trong 31->45''
		When  A.TimeDate >= 46 And A.TimeDate<=60 Then ''3_Nhóm khách hàng không phát sinh trong 46->60''
		When  A.TimeDate > 61 Then ''4_Nhóm khách hàng không phát sinh trong >61''
		End as GroupTime
From 
	(Select 
		t.DivisionID, t.OrderDate, t.ObjectID, t.ObjectName, x.Address, x.Tel, x.Contactor,
		x.InventoryID, x.InventoryName, x.OrderQuantity, x.SalePrice, x.OriginalAmount,
		t.SumAmount, x.Notes, x.Notes01, x.Notes02, Max(x.DayTime)as TimeDate
	From 
		(Select 
			y.DivisionID, y.OrderDate, y.ObjectID, y.ObjectName, z.SumAmount
		 From
			(Select 
				F.DivisionID,Max(F.OrderDate) as OrderDate, F.ObjectID, F.ObjectName
			From OT2001 F
			where  (F.OrderDate >= N'''+@FromDateText+''') and   (F.OrderDate <= N'''+@ToDateText+''')
			And F.DivisionID like '''+@DivisionID+'''
			Group By F.DivisionID, F.ObjectID, F.ObjectName
			)y Inner Join
			(Select M.DivisionID, M.ObjectID, Sum(O.OriginalAmount ) as SumAmount 
			From OT2002 O
			Inner Join OT2001 M On O.DivisionID =M.DivisionID And O.SOrderID = M.SOrderID
			Group by M.ObjectID, M.DivisionID
			)z On z.DivisionID=y.DivisionID And z.ObjectID = y.ObjectID
		)t Inner Join
		(
		Select 
			A.DivisionID, A.ObjectID,B.Address, A.OrderDate ,B.Tel, B.Contactor, 
			C.InventoryID, C.InventoryName ,D.OrderQuantity, D.SalePrice, D.OriginalAmount, 
			D.Notes, D.Notes01, D.Notes02, Datediff(DAY,A.OrderDate, GetDate()) as DayTime
		From OT2001 A
		Inner Join AT1202 B On B.DivisionID = A.DivisionID And B.ObjectID = A.ObjectID 
		Inner Join OT2002 D On D.DivisionID = A.DivisionID And A.SOrderID = D.SOrderID
		Inner Join AT1302 C On C.DivisionID = A.DivisionID And C.InventoryID = D.InventoryID
		)x
		On x.DivisionID = t.DivisionID And x.ObjectID = t.ObjectID And x.OrderDate = t.OrderDate
		Group by t.DivisionID, t.OrderDate, t.ObjectID, t.ObjectName, x.Address, x.Tel, x.Contactor,
			x.InventoryID, x.InventoryName, x.OrderQuantity, x.SalePrice, x.OriginalAmount,
			x.Notes, x.Notes01, x.Notes02, t.SumAmount
	
	)A
	where A.TimeDate >=15
	Order by GroupTime

'

IF @IsDate = 0
 SET @sSQL = N'
 
Select 
	A.DivisionID,A.ObjectID, A.ObjectName, A.Address, A.Tel, A.Contactor,
	A.InventoryID, A.InventoryName, A.OrderQuantity, A.SalePrice, A.OriginalAmount ,
	A.SumAmount, A.Notes, A.Notes01, A.Notes02, 
	Case 
		When  A.TimeDate >= 15 And A.TimeDate<=30 Then ''1_Nhóm khách hàng không phát sinh trong 15->30''
		When  A.TimeDate >= 31 And A.TimeDate<=45 Then ''2_Nhóm khách hàng không phát sinh trong 31->45''
		When  A.TimeDate >= 46 And A.TimeDate<=60 Then ''3_Nhóm khách hàng không phát sinh trong 46->60''
		When  A.TimeDate > 61 Then ''4_Nhóm khách hàng không phát sinh trong >61''
		End as GroupTime
From 
	(Select 
		t.DivisionID, t.OrderDate, t.ObjectID, t.ObjectName, x.Address, x.Tel, x.Contactor,
		x.InventoryID, x.InventoryName, x.OrderQuantity, x.SalePrice, x.OriginalAmount,
		t.SumAmount, x.Notes, x.Notes01, x.Notes02, Max(x.DayTime)as TimeDate
	From 
		(Select 
			y.DivisionID, y.OrderDate, y.ObjectID, y.ObjectName, z.SumAmount
		 From
			(Select 
				F.DivisionID,Max(F.OrderDate) as OrderDate, F.ObjectID, F.ObjectName
			From OT2001 F
			where  (F.TranMonth +100*F.TranYear >= '+@FromMonthYearText+') and   (F.TranMonth +100*F.TranYear <= '+@ToMonthYearText+')
			And F.DivisionID like '''+@DivisionID+'''
			Group By F.DivisionID, F.ObjectID, F.ObjectName
			)y Inner Join
			(Select M.DivisionID, M.ObjectID, Sum(O.OriginalAmount ) as SumAmount 
			From OT2002 O
			Inner Join OT2001 M On O.DivisionID =M.DivisionID And O.SOrderID = M.SOrderID
			Group by M.ObjectID, M.DivisionID
			)z On z.DivisionID=y.DivisionID And z.ObjectID = y.ObjectID
		)t Inner Join
		(
		Select 
			A.DivisionID, A.ObjectID,B.Address, A.OrderDate ,B.Tel, B.Contactor, 
			C.InventoryID, C.InventoryName ,D.OrderQuantity, D.SalePrice, D.OriginalAmount, 
			D.Notes, D.Notes01, D.Notes02, Datediff(DAY,A.OrderDate, GetDate()) as DayTime
		From OT2001 A
		Inner Join AT1202 B On B.DivisionID = A.DivisionID And B.ObjectID = A.ObjectID 
		Inner Join OT2002 D On D.DivisionID = A.DivisionID And A.SOrderID = D.SOrderID
		Inner Join AT1302 C On C.DivisionID = A.DivisionID And C.InventoryID = D.InventoryID
		)x
		On x.DivisionID = t.DivisionID And x.ObjectID = t.ObjectID And x.OrderDate = t.OrderDate
		Group by t.DivisionID, t.OrderDate, t.ObjectID, t.ObjectName, x.Address, x.Tel, x.Contactor,
			x.InventoryID, x.InventoryName, x.OrderQuantity, x.SalePrice, x.OriginalAmount,
			x.Notes, x.Notes01, x.Notes02, t.SumAmount
	
	)A
	where A.TimeDate >=15
	Order by GroupTime
'
EXEC (@sSQL )

GO