IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[CRMP10105]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[CRMP10105]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
----In báo cáo Danh sách Khách hàng ngưng sử dụng
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
----Created by: Thị Phượng By on 28/01/2016
-- <Example>
----    EXEC CRMP10105 'AS','AS','','','','','','','', 'NV01'

CREATE PROCEDURE [dbo].[CRMP10105] ( 
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
		@sSQL1   NVARCHAR (MAX),
		@sWhere NVARCHAR(MAX),
		@sWhere01 NVARCHAR(MAX),
		@sWhere02 NVARCHAR(MAX),
		 @set  as Int ,
		@sqlGroupBy as nvarchar(MAX),
		@strTime as nvarchar(4000),
		@FromMonthYearText NVARCHAR(20), 
		@ToMonthYearText NVARCHAR(20), 
		@FromDateText NVARCHAR(20), 
		@ToDateText NVARCHAR(20)

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
  Set @sSQL = N'
		Select b.DivisionID,  b.OrderDate, b.ObjectID, b.ObjectName, b.Address ,b.Tel, c.InventoryID, c.InventoryName ,c.AveQuantity  
		From 
		(
			Select  M.DivisionID, Max(M.OrderDate) as OrderDate ,  M.ObjectID, M.ObjectName, T.Address, T.Tel 
			from OT2001 M Left join OT2002 D On M.DivisionID = D.DivisionID and M.SOrderID = D.SOrderID
			Inner join AT1202 T On T.DivisionID =M.DivisionID AND T.ObjectID = M.ObjectID
			where T.IsUsing = 1
			Group by M.DivisionID,  M.ObjectID, M.ObjectName, T.Address, T.Tel
		)b inner join 
		(Select A.DivisionID, A.ObjectID, y.InventoryID, A.AveQuantity, y.InventoryName
		From
		(
					Select x.DivisionID, x.ObjectID, Max(x.OrderQuantity) as AveQuantity
					from 
								(
									Select M.DivisionID, M.ObjectID, D.InventoryID , AVG(D.OrderQuantity) as OrderQuantity 
									from OT2001 M Left join OT2002 D On M.DivisionID = D.DivisionID and M.SOrderID = D.SOrderID
									where (Month('+@ToDateText+')-Month(M.OrderDate)) <=3
									Group by M.DivisionID,M.ObjectID, D.InventoryID
								) x
					Group By x.DivisionID, x.ObjectID
		) A inner join (
							Select M.DivisionID, M.ObjectID, D.InventoryID , H.InventoryName , AVG(D.OrderQuantity) as  AVGOrderQuantity 
							from OT2001 M Left join OT2002 D On M.DivisionID = D.DivisionID and M.SOrderID = D.SOrderID
							Left join AT1302 H On M.DivisionID = H.DivisionID and H.InventoryID = D.InventoryID
							Group by M.DivisionID,M.ObjectID, D.InventoryID , H.InventoryName
						) y on A.DivisionID = y.DivisionID and A.ObjectID = y.ObjectID
		Where A.AveQuantity = y.AVGOrderQuantity) c ON b.ObjectID = c.ObjectID And b.DivisionID = c.DivisionID	
		
'
	SET @sWhere02 = N' where b.DivisionID like '''+@DivisionID+''' '
 IF @IsDate = 0
  Set @sSQL = N'
		Select b.DivisionID,  b.OrderDate, b.ObjectID, b.ObjectName, b.Address ,b.Tel, c.InventoryID, c.InventoryName ,c.AveQuantity  
		From 
		(
			Select  M.DivisionID, Max(M.OrderDate) as OrderDate ,  M.ObjectID, M.ObjectName, T.Address, T.Tel 
			from OT2001 M Left join OT2002 D On M.DivisionID = D.DivisionID and M.SOrderID = D.SOrderID
			Inner join AT1202 T On T.DivisionID =M.DivisionID AND T.ObjectID = M.ObjectID
			where T.IsUsing = 1
			Group by M.DivisionID,  M.ObjectID, M.ObjectName, T.Address, T.Tel
		)b inner join 
		(Select A.DivisionID, A.ObjectID, y.InventoryID, A.AveQuantity, y.InventoryName
		From
		(
					Select x.DivisionID, x.ObjectID, Max(x.OrderQuantity) as AveQuantity
					from 
								(
									Select M.DivisionID, M.ObjectID, D.InventoryID , AVG(D.OrderQuantity) as OrderQuantity 
									from OT2001 M Left join OT2002 D On M.DivisionID = D.DivisionID and M.SOrderID = D.SOrderID
									where (Month('+@ToMonthYearText+')-Month(M.OrderDate)) <=3
									Group by M.DivisionID,M.ObjectID, D.InventoryID
								) x
					Group By x.DivisionID, x.ObjectID
		) A inner join (
							Select M.DivisionID, M.ObjectID, D.InventoryID , H.InventoryName , AVG(D.OrderQuantity) as  AVGOrderQuantity 
							from OT2001 M Left join OT2002 D On M.DivisionID = D.DivisionID and M.SOrderID = D.SOrderID
							Left join AT1302 H On M.DivisionID = H.DivisionID and H.InventoryID = D.InventoryID
							Group by M.DivisionID,M.ObjectID, D.InventoryID , H.InventoryName
						) y on A.DivisionID = y.DivisionID and A.ObjectID = y.ObjectID
		Where A.AveQuantity = y.AVGOrderQuantity) c ON b.ObjectID = c.ObjectID And b.DivisionID = c.DivisionID	
		
'
	SET @sWhere02 = N' where b.DivisionID like '''+@DivisionID+''' '
	Print @sSQL
	Print @sWhere02
 EXEC (@sSQl+ @sWhere02)
GO