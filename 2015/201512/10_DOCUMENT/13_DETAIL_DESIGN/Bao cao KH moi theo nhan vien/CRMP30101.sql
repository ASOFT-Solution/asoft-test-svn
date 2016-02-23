IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[CRMP30101]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[CRMP30101]
GO
SET QUOTED_IDENTIFIER ON
GO

-- <Summary>
----In báo cáo Khách hàng mới theo nhân viên
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
----Created by: Thị Phượng on 27/01/2016
-- <Example>
----    EXEC CRMP30101 'AS','AS','','','','','','', 'NV01'

CREATE PROCEDURE [dbo].[CRMP30101] ( 
        @DivisionID       VARCHAR(50),  --Biến môi trường
		@DivisionIDList    NVARCHAR(2000),  --Chọn trong DropdownChecklist DivisionID
		@FromDate         DATETIME,
		@ToDate           DATETIME,
		@FromAccountID    NVarchar(50),
		@ToAccountID         NVarchar(50),
		@FromEmployeeID      NVarchar(50),
		@ToEmployeeID        NVarchar(50),
		@UserID  VARCHAR(50)
		
)
AS
DECLARE
		@sSQL NVARCHAR (MAX),
		@sWhere NVARCHAR(MAX),
		@sWhere1 Nvarchar(Max),
		@sWhere2 Nvarchar(Max)

SET @sWhere = ''
SET @sWhere = @sWhere + ' AND (CONVERT(VARCHAR(10),OT01.OrderDate,112) BETWEEN'''+ CONVERT(VARCHAR(20),@FromDate,112)+''' AND''' + CONVERT(VARCHAR(20),@ToDate,112) +''')'
Set @sWhere1 =	' AND (CONVERT(VARCHAR(10),OT01.OrderDate,112) < '''+ CONVERT(VARCHAR(20),@FromDate,112)+ ''' )'


--Check Para DivisionIDList null then get DivisionID 
	IF @DivisionIDList IS NULL or @DivisionIDList = ''
		SET @sWhere2 = ' OT01.DivisionID = '''+ @DivisionID+''''
	Else 
		SET @sWhere2 =  ' OT01.DivisionID IN ('''+@DivisionIDList+''')'
	IF (@FromAccountID IS NOT NULL )  And ( @FromAccountID not like '')
		SET @sWhere = @sWhere +' AND (CR01.AccountID between N'''+@FromAccountID+''' and N'''+@ToAccountID+''')'
	IF @FromEmployeeID IS NOT NULL And (@FromEmployeeID not like '')
		SET @sWhere = @sWhere +' AND (OT01.SalesManID between N'''+@FromEmployeeID+''' and N'''+@ToEmployeeID+''')'
		 


---Load danh sách khách hàng mới theo nhân viên
SET @sSQL =
	' Select b.DivisionID,  Max(b.OrderDate) as OrderDate  , b.AccountID, b.AccountName, b.Address ,b.Tel, 
		c.InventoryID, c.InventoryName ,c.OrderQuantity, b.SalesManID, b.FullName
		From 
		(
			SELECT CR01.DivisionID, Max(OT01.OrderDate) as OrderDate , CR01.AccountID, CR01.AccountName, 
			CR01.Address, CR01.Tel, CR01.CreateUserID,
			AT02.InventoryID,AT02.InventoryName, OT01.Notes, OT01.SalesManID, AT03.FullName
			FROM CRMT10101 CR01
			Left JOIN OT2001 OT01 ON OT01.DivisionID = CR01.DivisionID AND OT01.ObjectID = CR01.AccountID
			Left JOIN OT2002 OT02 ON OT02.DivisionID = CR01.DivisionID AND OT01.SOrderID = OT02.SOrderID
			Left JOIN AT1302 AT02 ON AT02.DivisionID = CR01.DivisionID AND AT02.InventoryID = OT02.InventoryID
			Left JOIN AT1103 AT03 ON AT03.DivisionID = CR01.DivisionID AND AT03.EmployeeID = OT01.SalesManID
			Where  '+@sWhere2+ @sWhere+'
			And CR01.AccountID not in (SELECT CR01.AccountID FROM CRMT10101 CR01
				Inner JOIN OT2001 OT01 ON OT01.DivisionID = CR01.DivisionID AND OT01.ObjectID = CR01.AccountID
				Inner JOIN OT2002 OT02 ON OT02.DivisionID = CR01.DivisionID AND OT01.SOrderID = OT02.SOrderID
				Where  '+@sWhere2+ @sWhere1+')
			Group by OT01.SalesManID, CR01.DivisionID, CR01.AccountID, CR01.AccountName, 
			CR01.Address, CR01.Tel, CR01.CreateUserID, AT02.InventoryID,AT02.InventoryName, OT01.Notes,AT03.FullName
		)b INNER join 
		(Select A.DivisionID, A.ObjectID, y.InventoryID, A.OrderQuantity, y.InventoryName
		From
		(
					Select x.DivisionID, x.ObjectID, Max(x.OrderQuantity) as OrderQuantity
					from 
								(
									Select M.DivisionID, M.ObjectID, D.InventoryID , Max(D.OrderQuantity) as OrderQuantity 
									from OT2001 M Left join OT2002 D On M.DivisionID = D.DivisionID and M.SOrderID = D.SOrderID
									Group by M.DivisionID,M.ObjectID, D.InventoryID 
									--Tìm S? lu?ng max theo mã v?t tu và d?i tu?ng
								) x
					Group By x.DivisionID, x.ObjectID
					-- Tìm s? lu?ng max theo d?i tu?ng
		) A left join (
							Select M.DivisionID, M.ObjectID, D.InventoryID , H.InventoryName , MAx(D.OrderQuantity) as  MOrderQuantity 
							from OT2001 M Left join OT2002 D On M.DivisionID = D.DivisionID and M.SOrderID = D.SOrderID
							Left join AT1302 H On M.DivisionID = H.DivisionID and H.InventoryID = D.InventoryID
							Group by M.DivisionID,M.ObjectID, D.InventoryID , H.InventoryName
							--Tìm s? lu?ng max theo mã v?t tu và s? lu?ng
						) y on A.DivisionID = y.DivisionID and A.ObjectID = y.ObjectID
		Where A.OrderQuantity = y.MOrderQuantity
		--Tìm danh sách d?i tu?ng có s? lu?ng max 
		)c ON b.AccountID = c.ObjectID And b.DivisionID = c.DivisionID	
		Group by b.AccountID, b.DivisionID, b.AccountName, b.Address ,b.Tel, 
		c.InventoryID, c.InventoryName ,c.OrderQuantity, b.SalesManID, b.FullName
		'

EXEC (@sSQL)
GO
