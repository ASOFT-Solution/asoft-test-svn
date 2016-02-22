IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[CRMP30401]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[CRMP30401]
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

CREATE PROCEDURE [dbo].[CRMP30401] ( 
        @DivisionID       VARCHAR(50),  --Biến môi trường
		@DivisionIDList    NVARCHAR(2000),  --Chọn trong DropdownChecklist DivisionID
		@FromDate         DATETIME,
		@ToDate           DATETIME,
		@IsDate           TINYINT,--- =1 theo ngày , = 0 Theo kỳ
		@Period nvarchar(max),
		@FromAccountID       Varchar(50),
		@ToAccountID         Varchar(50),
		@UserID  VARCHAR(50)
		)
AS
DECLARE
        @sSQL   NVARCHAR (MAX),
		@sWhere NVARCHAR(MAX)

SET @sWhere = ''
--Check Para DivisionIDList null then get DivisionID  
	IF @DivisionIDList IS NULL or @DivisionIDList = ''
		SET @sWhere = @sWhere + ' H.DivisionID = '''+ @DivisionID+''''
	Else 
		SET @sWhere = @sWhere + ' H.DivisionID IN ('''+@DivisionIDList+''')'
	IF (@FromAccountID is not null and @FromAccountID not like '')
		SET @sWhere = @sWhere +' AND (H.ObjectID between N'''+@FromAccountID+N''' and N'''+@ToAccountID+N''')'
IF @IsDate = 1 
		SET @sWhere = @sWhere + ' AND (CONVERT(VARCHAR(10),H.OrderDate,112) BETWEEN'''+ CONVERT(VARCHAR(20),@FromDate,112)+''' AND''' + CONVERT(VARCHAR(20),@ToDate,112) +''')'
	Else
		SET @sWhere = @sWhere + ' AND (CASE WHEN H.TranMonth <10 THEN ''0''+rtrim(ltrim(str(H.TranMonth)))+''/''+ltrim(Rtrim(str(H.TranYear))) 
  ELSE rtrim(ltrim(str(H.TranMonth)))+''/''+ltrim(Rtrim(str(H.TranYear))) END) in ('''+@Period+''')'
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
	(
		Select 
			t.DivisionID, t.OrderDate, t.ObjectID, t.ObjectName, x.Address, x.Tel, x.Contactor,
			x.InventoryID, x.InventoryName, x.OrderQuantity, x.SalePrice, x.OriginalAmount,
			t.SumAmount, x.Notes, x.Notes01, x.Notes02, Max(x.DayTime)as TimeDate
		From 
		(
			Select y.DivisionID, y.OrderDate, y.ObjectID, y.ObjectName, z.SumAmount
			From
			(
				
				Select F.DivisionID, F.ObjectID, F.ObjectName, Max(F.OrderDate ) OrderDate
				from OT2001 F
				Group by F.DivisionID, F.ObjectID, F.ObjectName
				--Tìm thời gian lớn nhất của đơn hàng theo đối tượng
			)y Inner Join
			(
				Select M.DivisionID, M.ObjectID, Sum(O.OriginalAmount ) as SumAmount 
				From OT2002 O
				Inner Join OT2001 M On O.DivisionID =M.DivisionID And O.SOrderID = M.SOrderID
				Group by M.ObjectID, M.DivisionID
		        --Tổng số lượng theo sản phẩm của đối tượng
			)z On z.DivisionID=y.DivisionID And z.ObjectID = y.ObjectID
		)t Inner Join
		(
			Select 
				H.DivisionID, H.ObjectID,B.Address, H.OrderDate ,B.Tel, B.Contactor, 
				C.InventoryID, C.InventoryName ,D.OrderQuantity, D.SalePrice, D.OriginalAmount, 
				D.Notes, D.Notes01, D.Notes02, Datediff(DAY,H.OrderDate, GetDate()) as DayTime 
			From 
			(
				Select F.DivisionID, F.ObjectID, F.ObjectName, F.OrderDate, F.SOrderID, F.TranMonth, F.TranYear
				from OT2001 F
			) H
			Inner Join AT1202 B On B.DivisionID = H.DivisionID And B.ObjectID = H.ObjectID 
			Inner Join OT2002 D On D.DivisionID = H.DivisionID And H.SOrderID = D.SOrderID
			Inner Join AT1302 C On C.DivisionID = H.DivisionID And C.InventoryID = D.InventoryID
			where    '+@sWhere+'
			--Xác định số ngày của đơn hàng đến ngày hiện tại
		)x
		On x.DivisionID = t.DivisionID And x.ObjectID = t.ObjectID And x.OrderDate = t.OrderDate
		Group by t.DivisionID, t.OrderDate, t.ObjectID, t.ObjectName, x.Address, x.Tel, x.Contactor,
				x.InventoryID, x.InventoryName, x.OrderQuantity, x.SalePrice, x.OriginalAmount,
				x.Notes, x.Notes01, x.Notes02, t.SumAmount
	---Danh sách khách hàng + s? ngày k? t? don hàng sau cùng d?n hi?n t?i
	)A 
	where A.TimeDate >=15
	Order by GroupTime
'

EXEC (@sSQL )

GO