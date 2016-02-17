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
----    EXEC CRMP10104 'AS','AS','','','','','','','', 'NV01'

CREATE PROCEDURE [dbo].[CRMP30101] ( 
        @DivisionID       VARCHAR(50),  --Biến môi trường
		@DivisionIDList    NVARCHAR(2000),  --Chọn trong DropdownChecklist DivisionID
		@FromDate         DATETIME,
		@ToDate           DATETIME,
		@IsDate           TINYINT,--- =1 theo ngày , = 0 Theo kỳ
		@Period nvarchar(max),
		@FromAccountID    NVarchar(50),
		@ToAccountID         NVarchar(50),
		@FromEmployeeID      NVarchar(50),
		@ToEmployeeID        NVarchar(50),
		@UserID  VARCHAR(50)
		
)
AS
DECLARE
		@sSQL NVARCHAR (MAX),
		@sWhere NVARCHAR(MAX)

SET @sWhere = ''

--Check Para DivisionIDList null then get DivisionID 
	IF @DivisionIDList IS NULL or @DivisionIDList = ''
		SET @sWhere = @sWhere + ' AND OT01.DivisionID = '''+ @DivisionID+''''
	Else 
		SET @sWhere = @sWhere + ' AND OT01.DivisionID IN ('''+@DivisionIDList+''')'
	IF (@FromAccountID IS NOT NULL)  And (@ToAccountID is not null)
		SET @sWhere = @sWhere +' AND (CR01.AccountID between N'''+@FromAccountID+''' and N'''+@ToAccountID+''')'
	IF @FromEmployeeID IS NOT NULL And (@ToEmployeeID is not null)
		SET @sWhere = @sWhere +' AND (OT01.SalesManID between N'''+@FromEmployeeID+''' and N'''+@ToEmployeeID+''')'
IF @IsDate = 1 ---Kiểm tra theo ngày hay theo kỳ
		SET @sWhere = @sWhere + ' AND (CONVERT(VARCHAR(10),OT01.CreateDate,112) BETWEEN'''+ CONVERT(VARCHAR(20),@FromDate,112)+''' AND''' + CONVERT(VARCHAR(20),@ToDate,112) +''')'
	Else
		SET @sWhere = @sWhere + ' AND (CASE WHEN OT01.TranMonth <10 THEN ''0''+rtrim(ltrim(str(OT01.TranMonth)))+''/''+ltrim(Rtrim(str(OT01.TranYear))) 
  ELSE rtrim(ltrim(str(OT01.TranMonth)))+''/''+ltrim(Rtrim(str(OT01.TranYear))) END) in ('''+@Period+''')'
	
---Load danh sách khách hàng mới theo nhân viên
SET @sSQL =
	'Select b.DivisionID,  b.CreateDate, b.AccountID, b.AccountName, b.Address ,b.Tel, 
		c.InventoryID, c.InventoryName ,c.OrderQuantity, b.SalesManID, b.SalesManID
		From 
		(
			SELECT CR01.DivisionID, OT01.CreateDate, CR01.AccountID, CR01.AccountName, 
			CR01.Address, CR01.Tel, CR01.CreateUserID,
			AT02.InventoryID,AT02.InventoryName, OT01.Notes, OT01.SalesManID, AT03.FullName
			FROM CRMT10101 CR01
			INNER JOIN OT2001 OT01 ON OT01.DivisionID = CR01.DivisionID AND OT01.ObjectID = CR01.AccountID
			INNER JOIN OT2002 OT02 ON OT02.DivisionID = CR01.DivisionID AND OT01.SOrderID = OT02.SOrderID
			INNER JOIN AT1302 AT02 ON AT02.DivisionID = CR01.DivisionID AND AT02.InventoryID = OT02.InventoryID
			INNER JOIN AT1103 AT03 ON AT03.DivisionID = CR01.DivisionID AND AT03.EmployeeID = OT01.SalesManID
			Where (SELECT  Count(B.VoucherNo)  from OT2001 B where B.DivisionID = CR01.DivisionID and B.ObjectID =CR01.AccountID) =1 
			'+@sWhere+' 
			Group by OT01.SalesManID, CR01.DivisionID, OT01.CreateDate, CR01.AccountID, CR01.AccountName, 
			CR01.Address, CR01.Tel, CR01.CreateUserID, AT02.InventoryID,AT02.InventoryName, OT01.Notes,AT03.FullName 
	
		)b Inner join 
		(Select A.DivisionID, A.ObjectID, y.InventoryID, A.OrderQuantity, y.InventoryName
		From
		(
					Select x.DivisionID, x.ObjectID, Max(x.OrderQuantity) as OrderQuantity
					from 
								(
									Select M.DivisionID, M.ObjectID, D.InventoryID , Max(D.OrderQuantity) as OrderQuantity 
									from OT2001 M Left join OT2002 D On M.DivisionID = D.DivisionID and M.SOrderID = D.SOrderID
									Group by M.DivisionID,M.ObjectID, D.InventoryID 
									--Tìm Số lượng max theo mã vật tư và đối tượng
								) x
					Group By x.DivisionID, x.ObjectID
					-- Tìm số lượng max theo đối tượng
		) A left join (
							Select M.DivisionID, M.ObjectID, D.InventoryID , H.InventoryName , MAx(D.OrderQuantity) as  MOrderQuantity 
							from OT2001 M Left join OT2002 D On M.DivisionID = D.DivisionID and M.SOrderID = D.SOrderID
							Left join AT1302 H On M.DivisionID = H.DivisionID and H.InventoryID = D.InventoryID
							Group by M.DivisionID,M.ObjectID, D.InventoryID , H.InventoryName
							--Tìm số lượng max theo mã vật tư và số lượng
						) y on A.DivisionID = y.DivisionID and A.ObjectID = y.ObjectID
		Where A.OrderQuantity = y.MOrderQuantity
		--Tìm danh sách đối tượng có số lượng max 
		)c ON b.AccountID = c.ObjectID And b.DivisionID = c.DivisionID	
		Group by b.AccountID, b.DivisionID,  b.CreateDate, b.AccountName, b.Address ,b.Tel, 
		c.InventoryID, c.InventoryName ,c.OrderQuantity, b.SalesManID, b.SalesManID
		'

EXEC (@sSQL)
GO
