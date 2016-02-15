IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[CRMP10104]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[CRMP10104]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
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
----    EXEC CRMP10104 'AS','AS','','','','','','','', 'NV01',1,20

CREATE PROCEDURE [dbo].[CRMP10104] ( 
        @DivisionID       VARCHAR(50),  --Biến môi trường
		@DivisionIDList    NVARCHAR(2000),  --Chọn trong DropdownChecklist DivisionID
		@FromDate         DATETIME,
		@ToDate           DATETIME,
		@IsDate           TINYINT,--- =1 theo ngày , = 0 Theo kỳ
		@Period nvarchar(max),
		@CheckBox1 TINYINT,-- =1 chọn theo khách hàng
		@FromAccountID       Varchar(50),
		@ToAccountID         Varchar(50),
		@CheckBox2 TINYINT,--- = 1 Chọn theo nhân viên
		@FromEmployeeID      Varchar(50),
		@ToEmployeeID        Varchar(50),
		@UserID  VARCHAR(50),
		@PageNumber INT,
        @PageSize INT
		
)
AS
DECLARE
		@sSQL NVARCHAR (MAX),
		@sWhere NVARCHAR(MAX),
        @OrderBy NVARCHAR(500),
        @TotalRow NVARCHAR(50)

SET @sWhere = ''
SET @TotalRow = ''
SET @OrderBy = 'b.DivisionID, b.SaleManID'

IF @PageNumber = 1 SET @TotalRow = 'COUNT(*) OVER ()' ELSE SET @TotalRow = 'NULL'
--Check Para DivisionIDList null then get DivisionID 
	IF @DivisionIDList IS NULL or @DivisionIDList = ''
		SET @sWhere = @sWhere + ' AND OT01.DivisionID = '''+ @DivisionID+''''
	Else 
		SET @sWhere = @sWhere + ' AND OT01.DivisionID IN ('''+@DivisionIDList+''')'
	IF @Checkbox1=1
		SET @sWhere = @sWhere +' AND (CR01.AccountID between N'''+@FromAccountID+N''' and N'''+@ToAccountID+N''')'
	IF @Checkbox2=1
		SET @sWhere = @sWhere +' AND (OT01.SalesManID between N'''+@FromEmployeeID+N''' and N'''+@ToEmployeeID+N''')'
IF @IsDate = 1 
		SET @sWhere = @sWhere + ' AND (CONVERT(VARCHAR(10),OT01.CreateDate,112) BETWEEN'''+ CONVERT(VARCHAR(20),@FromDate,112)+''' AND''' + CONVERT(VARCHAR(20),@ToDate,112) +''')'
	Else
		SET @sWhere = @sWhere + ' AND (CASE WHEN OT01.TranMonth <10 THEN ''0''+rtrim(ltrim(str(OT01.TranMonth)))+''/''+ltrim(Rtrim(str(OT01.TranYear))) 
  ELSE rtrim(ltrim(str(OT01.TranMonth)))+''/''+ltrim(Rtrim(str(OT01.TranYear))) END) in ('''+@Period+''')'
	

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
			Where (SELECT  Count(B.VoucherNo)  from OT2001 B where B.DivisionID = CR01.DivisionID and B.ObjectID =CR01.AccountID) =1 '+@sWhere+' 
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
								) x
					Group By x.DivisionID, x.ObjectID
		) A left join (
							Select M.DivisionID, M.ObjectID, D.InventoryID , H.InventoryName , MAx(D.OrderQuantity) as  MOrderQuantity 
							from OT2001 M Left join OT2002 D On M.DivisionID = D.DivisionID and M.SOrderID = D.SOrderID
							Left join AT1302 H On M.DivisionID = H.DivisionID and H.InventoryID = D.InventoryID
							Group by M.DivisionID,M.ObjectID, D.InventoryID , H.InventoryName
						) y on A.DivisionID = y.DivisionID and A.ObjectID = y.ObjectID
		Where A.OrderQuantity = y.MOrderQuantity)c ON b.AccountID = c.ObjectID And b.DivisionID = c.DivisionID	
		Group by b.AccountID, b.DivisionID,  b.CreateDate, b.AccountName, b.Address ,b.Tel, 
		c.InventoryID, c.InventoryName ,c.OrderQuantity, b.SalesManID, b.SalesManID
		'

	Print @sSQL	
EXEC (@sSQL)
GO
